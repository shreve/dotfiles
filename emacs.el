;;; emacs.el -- emacs config
;;; Commentary:
;;; Code:

;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold-bak gc-cons-threshold)
(setq gc-cons-threshold (* 50 1000000))

;; Force UTF-8 character display
(set-language-environment "UTF-8")
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(setenv "GOPATH" "/home/jacob/code/go")

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://melpa.org/packages/") t)
(package-initialize)

(eval-when-compile
  (require 'use-package))

;; 3rd party config
(add-to-list 'load-path "~/.emacs.d/scripts")
(add-to-list 'load-path "~/.emacs.d/theme")
(add-to-list 'load-path "~/.emacs.d/vendor")

(load "tomorrow-night-bright-theme")
(enable-theme 'tomorrow-night-bright)

(load "modeline")
(load "helm-config")
(load "evil-config")
(load "projectile-config")
(load "flycheck-config")
(load "fzf")
(load "helm-fzf")

(use-package web-mode)
(use-package yaml-mode)
(use-package scss-mode)
(use-package whitespace
  :config
  (setq face-remapping-alist '((whitespace-tab . whitespace-newline)))
  ;; (setq whitespace-style '(face trailing tabs newline tab-mark newline-mark space-before-tab::space))
  (setq whitespace-style
        '(face tabs tab-mark space-before-tab::space))
  (setq whitespace-action '(cleanup))
  (setq whitespace-line-column 80)
  (global-whitespace-mode))

(use-package fira-code-mode
  :config
  (fira-code-mode))

;; (use-package company-tabnine
;;   :ensure t
;;   :config
;;   (setq company-idle-delay 0)
;;   ;; (setq company-show-numbers t)

;;   ;; (define-key company-active-map [tab] 'company-select-next-or-abort)
;;   ;; (define-key company-active-map (kbd "TAB") 'company-select-next-or-abort)

;;   (add-to-list 'company-backends #'company-tabnine))

(use-package saveplace
  :config
  (save-place-mode 1))

(use-package linum-relative
  :config
  (global-linum-mode)
  (linum-relative-mode 1)
  (setq linum-relative-format "%4s  ")
  (setq linum-relative-current-symbol "")
  (load "font-config"))

(use-package ranger
  :config
  (ranger-override-dired-mode t)
  (setq ranger-show-hidden t)
  (setq ranger-cleanup-eagerly t))

(use-package xclip
  :config
  (xclip-mode 1))

(use-package fzf)
(use-package helm-fzf)

;; (use-package yasnippet
;;   :config
;;   (yas-global-mode))

;; General Config
;; (setenv "PATH" (concat  "~/.emacs.d/bin:" (getenv "PATH")))
;; (add-to-list 'exec-path "~/.emacs.d/bin")

(setq scroll-step 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq inhibit-splash-screen t)
(setq fill-column 80)
(menu-bar-mode -1) ;; minimal chrome
(tool-bar-mode -1) ;; hide tool bar
;; (toggle-scroll-bar -1) ;; not used in nox build
(show-paren-mode 1) ;; show matching parens
(setq tab-stop-list (number-sequence 2 60 2)) ;; generate a list from 2-60 by 2s
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Don't ask until the TAGS file is 15 Mb.
(setq large-file-warning-threshold 25000000)

;; Set the title of the window to emacs + buffer path
(setq frame-title-format
      (list
       '(buffer-file-name
         "emacs %f"
         (dired-directory dired-directory "%b"))))

(setq ruby-indent-offset 2)
(setq css-indent-offset 2)
(setq scss-indent-level 2)
(setq js-indent-level 2)
(setq scss-compile-at-save nil)
(setq backup-directory-alist `(("." . "/tmp/backups")))
(setq auto-save-file-name-transforms `((".*" , temporary-file-directory t)))
(setq vc-follow-symlinks t)
(setq tags-revert-without-query 1)

;; Don't require 'yes' or 'no', just 'y' or 'n'
(defalias 'yes-or-no-p 'y-or-n-p)

(setq left-margin-width 20)

;; Fill Column Indicator (80 char line)
(setq fci-rule-column 80)
(setq fci-rule-character (char-from-name "BOX DRAWINGS LIGHT VERTICAL"))
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(add-hook 'web-mode-hook (lambda () (fci-mode 0)))

;; Add mode hooks for various file extensions
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.latex\\'" . latex-mode))
(add-to-list 'auto-mode-alist '("\\.slime\\'" . slim-mode))

(defun shreve-sass-mode ()
  "Use company preferred formatting for sass files."
  (require 'sass-mode)
  (setq sass-indent-offset 2))
(add-hook 'sass-mode-hook 'shreve-sass-mode)

;; everything is indented 2 spaces
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(defun shreve-dired-mode ()
  "Configure dired mode to my liking."
  (setq dired-hide-details-hide-symlink-targets nil)
  (auto-revert-mode)
  (linum-mode))
(add-hook 'dired-mode-hook 'shreve-dired-mode)

(defun shreve-text-mode ()
  "Configure Emacs for more intuitive large-blob editing."
  (visual-line-mode)
  (define-key evil-normal-state-map "j" 'next-line)
  (define-key evil-normal-state-map "k" 'previous-line)
  (fci-mode 0))

(add-hook 'text-mode-hook 'shreve-text-mode)
(add-hook 'latex-mode-hook 'shreve-text-mode)
(add-hook 'org-mode-hook 'shreve-text-mode)
(add-hook 'markdown-mode-hook 'shreve-text-mode)

(setq c-default-style "linux"
      c-basic-offset 4)

(defun shreve-tabs-mode ()
  "Set preferred options for editing with tabstops."
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (setq backward-delete-char-untabify-method 'hungry))

(add-hook 'c++-mode-hook 'shreve-tabs-mode)

(defun shreve-csharp-mode ()
  "Language specific config for c#."
  (c-set-style "bsd")
  (setq c-default-style "bsd"
        c-basic-offset 4)
  )

(add-hook 'csharp-mode-hook 'shreve-csharp-mode)


(defun shreve-typist-mode ()
  "Configure Emacs for pleasant journaling use."
  (interactive)
  (auto-fill-mode 1)
  (fci-mode 1)
  (setq fill-column 80)
)

(add-hook 'markdown-mode-hook 'shreve-typist-mode)
;; (add-hook 'org-mode-hook 'shreve-typist-mode)
;; (add-hook 'text-mode-hook 'shreve-typist-mode)

;; (defun shreve-suggest-mode ()
;;   "Set up for using company completions."
;;   (interactive)
;;   (fci-mode 0)
;;   ;; (setq whitespace-style
;;   ;;       '(face tabs tab-mark space-before-tab::space trailing lines))
;;   (company-mode)
;;   (company-tabnine))

;; (add-hook 'go-mode-hook 'shreve-suggest-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#eaeaea" "#d54e53" "#b9ca4a" "#e7c547" "#7aa6da" "#c397d8" "#70c0b1" "#000000"))
 '(custom-safe-themes
   '("5ee12d8250b0952deefc88814cf0672327d7ee70b16344372db9460e9a0e3ffc" default))
 '(fci-rule-color "#2a2a2a")
 '(helm-completion-style 'emacs)
 '(package-selected-packages
   '(flycheck-rust gdscript-mode yasnippet-snippets yasnippet rg helm-flx xclip company company-go company-tabnine vue-mode pug-mode helm-rg helm use-package ## ranger js2-mode eslint-fix csharp-mode scss-mode dockerfile-mode rjsx-mode web-mode slim-mode simpleclip sass-mode rust-mode projectile-rails package-utils linum-relative indent-guide goto-last-change go-mode flycheck fish-mode fill-column-indicator evil-leader evil-commentary elixir-mode))
 '(safe-local-variable-values '((fci-rule-column . 99))))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold gc-cons-threshold-bak)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
