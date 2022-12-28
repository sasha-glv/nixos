#!/usr/bin/env bash

# This script is used to send a ZFS snapshot to a remote server.
# Arguments:
# -r: Remote server
# -d: Destination dataset
# -s: Source dataset

usage () {
    echo "Usage: $0 -r remote_server -d destination_dataset -s source_dataset"
    exit 1
}
# Process arguments
while getopts ":r:h:s:d:" opt; do
  case "${opt}" in
    s)
      local_zfs_volume="${OPTARG}"
      ;;
    d)
      remote_zfs_volume="${OPTARG}"
      ;;
    r)
      remote_host=$OPTARG
      ;;
    *)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "$remote_host" ]; then
  echo "Remote host is required."
  usage
  exit 1
fi
if [ -z "$local_zfs_volume" ]; then
  echo "Local ZFS volume is required."
  usage
  exit 1
fi
if [ -z "$remote_zfs_volume" ]; then
  echo "Remote ZFS volume is required."
  usage
  exit 1
fi

# Create a snapshot of the local zfs volume with the current date and time
snapshot_name=$(date +%Y-%m-%d_%H-%M)
zfs snapshot $local_zfs_volume@$snapshot_name

# Check if the snapshot was created successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to create snapshot of $local_zfs_volume"
    exit 1
fi

# Get the base snapshot on the remote host
base_snapshot_remote=$(ssh $remote_host zfs list -t snapshot -o name -H $remote_zfs_volume | tail -n 1 | cut -d @ -f 2)

# Check if the base snapshot exists
if [ -z "$base_snapshot_remote" ]; then
    # Send the snapshot to the remote host
    zfs send $local_zfs_volume@$snapshot_name | ssh $remote_host zfs receive $remote_zfs_volume
    exit 0
fi

zfs send -I $local_zfs_volume@$base_snapshot_remote $local_zfs_volume@$snapshot_name | ssh $remote_host zfs receive $remote_zfs_volume

# Check if the snapshot was sent successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to send snapshot of $local_zfs_volume to $remote_host"
    exit 1
fi

echo "Successfully sent snapshot of $local_zfs_volume to $remote_host"
