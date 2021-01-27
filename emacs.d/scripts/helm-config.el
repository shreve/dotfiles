(defun helm-or-evil-escape ()
  "Escape from anything."
  (interactive)
  (cond ((minibuffer-window-active-p (minibuffer-window))
         ;; quit the minibuffer if open.
         (abort-recursive-edit))
        ;; Run all escape hooks. If any returns non-nil, then stop there.
        ;; ((cl-find-if #'funcall doom-escape-hook))
        ;; don't abort macros
        ((or defining-kbd-macro executing-kbd-macro) nil)
        ;; Back to the default
        ((keyboard-quit))))

(use-package helm-rg
  :ensure t)

(use-package helm-projectile
  :ensure t
  :config
  (setq helm-bookmark-show-location t)
  (helm-projectile-on))

;; Makes escaping from helm (and other buffers) MUCH better
(global-set-key [escape] #'helm-or-evil-escape)
(use-package helm
  :defer t
  :ensure t
  :bind (([remap apropos]                     . helm-apropos)
         ([remap find-library]                . helm-locate-library)
         ([remap bookmark-jump]               . helm-bookmarks)
         ([remap execute-extended-command]    . helm-M-x)
         ([remap find-file]                   . helm-find-files)
         ([remap imenu-anywhere]              . helm-imenu-anywhere)
         ([remap imenu]                       . helm-semantic-or-imenu)
         ([remap noop-show-kill-ring]         . helm-show-kill-ring)
         ([remap persp-switch-to-buffer]      . helm-mini)
         ([remap switch-to-buffer]            . helm-buffers-list)
         ([remap projectile-find-file]        . helm-projectile-find-file)
         ([remap projectile-recentf]          . helm-projectile-recentf)
         ([remap projectile-switch-project]   . helm-projectile-switch-project)
         ([remap projectile-switch-to-buffer] . helm-projectile-switch-to-buffer)
         ([remap recentf-open-files]          . helm-recentf)
         :map helm-map
         ("C-h a"                             . helm-apropos)
         ("C-j"                               . helm-next-line)
         ("C-k"                               . helm-previous-line)
         ("<tab>"                             . helm-execute-persistent-action)
         ("C-i"                               . helm-execute-persistent-action)
         ("C-z"                               . helm-select-action)
         ("C-w"                               . backward-kill-word)
         ("C-a"                               . move-beginning-of-line)
         ("C-u"                               . backward-kill-sentence)
         ("C-b"                               . backward-word)
         ("C-f"                               . forward-word)
         ("C-r"                               . evil-paste-from-register)
         ("ESC"                               . abort-recursive-edit)
         ("C-S-j"                             . scroll-up-command)
         ("C-S-k"                             . scroll-down-command))

  :init
  (setq
   helm-M-x-fuzzy-match                  t
   helm-ag-fuzzy-match                   t
   helm-apropos-fuzzy-match              t
   helm-apropos-fuzzy-match              t
   helm-bookmark-show-location           t
   helm-buffers-fuzzy-matching           t
   helm-completion-in-region-fuzzy-match t
   helm-completion-in-region-fuzzy-match t
   helm-ff-fuzzy-matching                t
   helm-file-cache-fuzzy-match           t
   helm-flx-for-helm-locate              t
   helm-imenu-fuzzy-match                t
   helm-lisp-fuzzy-completion            t
   helm-locate-fuzzy-match               t
   helm-mode-fuzzy-match                 t
   helm-projectile-fuzzy-match           t
   helm-recentf-fuzzy-match              t
   helm-semantic-fuzzy-match             t)
  :preface
  (setq helm-split-window-in-side-p nil         ; open helm buffer inside current window
        helm-move-to-line-cycle-in-source t     ; move to end or beginning of source when reaching top or bottom
        helm-ff-search-library-in-sexp t        ; search for library in `require' and `declare-function' sexp
        helm-scroll-amount 8                    ; scroll 8 lines other window using M-<next>/M-<prior>
        helm-ff-file-name-history-use-recentf t
        helm-echo-input-in-header-line t
        helm-candidate-number-limit 50
        helm-display-header-line nil
        helm-mode-line-string nil
        helm-ff-auto-update-initial-value nil
        helm-find-files-doc-header nil
        helm-display-buffer-default-width nil
        helm-display-buffer-default-height 0.25
        helm-split-window-default-side 'below)

  :config
  ;; (require 'helm-config)
  (set-face-attribute 'helm-selection nil :foreground "black" :background "#9c91e4")
  (set-face-attribute 'helm-header-line-left-margin nil :background "unspecified")
  (set-face-attribute 'helm-candidate-number nil :background "unspecified" :foreground "white")
  (global-set-key (kbd "M-x")     #'helm-M-x)
  (global-set-key (kbd "C-s")     #'helm-swoop)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode +1))

(use-package helm-swoop
  :ensure t)

(use-package helm-flx
  :ensure t
  ;; :hook (helm-mode . helm-flx-mode)
  :config (helm-flx-mode +1))

;; flx
(use-package flx
  :ensure t)

;;; helm-config.el ends here
