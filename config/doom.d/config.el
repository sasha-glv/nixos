;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Sasha Guljajev"
      user-mail-address "sasha@zxcvmk.com")

(when IS-MAC
  (setq ns-use-thin-smoothing t))

(setq doom-modeline-major-mode-icon t)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode" :size 38)
      doom-unicode-font (font-spec :family "FiraCode" :size 38)
      doom-big-font (font-spec :family "FiraCode" :size 38 :weight 'regular)
      ; doom-variable-pitch-font (font-spec :family "Dejavu Sans")
      doom-font-increment 1)
;;
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'modus-vivendi)

(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notes/")
(setq evil-snipe-scope 'buffer)

(use-package! modus-themes
  :config
  (setq modus-themes-headings nil)
  (setq modus-themes-subtle-line-numbers t)
  (modus-themes-load-themes))

(after! org
  ;; (setq org-startup-indented nil)
                                        ;  (electric-indent-mode -1)
  ;; (set-company-backend! 'org-mode '(:separate company-capf company-yasnippet))
  (setq org-todo-keywords
        '((sequence "TODO" "DOING" "DONE" )))
  (setq org-todo-keywords-for-agenda
        '((sequence "TODO" "DOING" "DONE" )))
  (setq org-capture-templates
        '(("t" "Todo" entry (file "~/notes/todos.org")
           "* TODO %?\n  %i\n  %a")
          ))
  )

;; (global-display-fill-column-indicator-mode)

(use-package! org-roam
  :config
  (setq org-roam-directory "~/notes/")
  (setq org-roam-dailies-directory "journals/")
  (setq org-roam-db-location "~/notes/org-roam.db")
  (setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y_%m_%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))
  (setq org-roam-capture-templates
   '(("d" "default" plain
      "%?" :target
      (file+head "pages/${slug}.org" "#+title: ${title}\n")
      :unnarrowed t))))

;;
(after! org
  (setq org-agenda-files (list "~/notes/pages" "~/notes/" "~/notes/journals"))
  (setq org-pretty-entities t)
  (org-superstar-mode t))

;; (after! evil
;;   (setq evil-default-state 'emacs))

(use-package! org-superstar
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

;; (use-package! company
;;   :config
;;   (setq +company-backend-alist (assq-delete-all 'text-mode +company-backend-alist))
;;   (add-to-list '+company-backend-alist '(text-mode (:separate company-dabbrev company-yasnippet))))

(add-hook! dired-mode
  (lambda () (dired-hide-details-mode +1)))

(use-package! dired
  :hook (dired-mode . (lambda () (dired-hide-details-mode +1))))

(setq indent-tabs-mode nil)
(setq projectile-switch-project-action 'projectile-vc)
(setq auth-sources '("~/.authinfo.gpg"))
(setq evil-snipe-scope 'buffer)
(setq org-link-descriptive 'nil)
(setq lsp-headerline-breadcrumb-enable 't)
(setq eldoc-echo-area-prefer-doc-buffer 't)

;; Maps
;;
(map! "s-s" #'save-buffer)

;; Defuns
;; https://github.com/magit/forge/issues/91
(defun forge-browse-buffer-file ()
  (interactive)
  (browse-url
   (let
       ((rev (magit-rev-abbrev "HEAD"))
        (repo (forge-get-repository 'stub))
        (file (magit-file-relative-name buffer-file-name))
        (highlight
         (if
             (use-region-p)
             (let ((l1 (line-number-at-pos (region-beginning)))
                   (l2 (line-number-at-pos (- (region-end) 1))))
               (format "#L%d-L%d" l1 l2))
           ""
           )))
     (forge--format repo "https://%h/%o/%n/blob/%r/%f%L"
                    `((?r . ,rev) (?f . ,file) (?L . ,highlight))))))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
