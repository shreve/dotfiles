;;; package --- Summary
;;; Commentary:
;;; Code:
(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)
(package-initialize)

;; General Config
(setenv "PATH" (concat  "~/.emacs.d/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("~/.emacs.d/bin")))
(setq scroll-step 1)
(defvar linum-format)
(setq linum-format "%4d \u2502 ")
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq inhibit-splash-screen t)
(menu-bar-mode -1) ;; minimal chrome
(tool-bar-mode -1)
(show-paren-mode 1) ;; show matching parens
(setq tab-stop-list (number-sequence 2 60 2)) ;; generate a list from 2-60 by 2s
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq flycheck-status-emoji-mode t)
;; Update the modeline bar
(set-fontset-font t nil "Symbola")
(setq-default mode-line-format
      (list
       "["
       '(:eval (list (nyan-create)))
       "]"
       ;; 'flycheck-mode-line
       "[%m: %b]"
       "[%02l:%02c]"
       ))

(defvar ruby-indent-offset)
(defvar css-indent-offset)
(defvar scss-indent-level)
(defvar sass-indent-offset)
(defvar js-indent-level)
(defvar scss-compile-at-save)
(setq ruby-indent-offset 2)
(setq css-indent-offset 2)
(setq scss-indent-level 2)
(setq sass-indent-offset 2)
(setq js-indent-level 2)
(setq scss-compile-at-save nil)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" , temporary-file-directory t)))
(setq vc-follow-symlinks t)

(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)

;; disable ido faces to see flx highlights.
(defvar ido-enable-flex-matching)
(setq ido-enable-flex-matching t)
(defvar ido-use-faces)
(setq ido-use-faces nil)

;; 3rd party config
(add-to-list 'load-path "~/.emacs.d/theme")
(add-to-list 'load-path "~/.emacs.d/vendor")

(linum-mode 1)
(linum-relative-mode 1)
(defvar linum-relative-format)
(setq linum-relative-format "%3s  ")
(defvar linum-relative-current-symbol)
(setq linum-relative-current-symbol "")

;; Fill Column Indicator (80 char line)
(setq fci-rule-column 79)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;; Code Completion Mode
(add-hook 'after-init-hook 'global-company-mode)
(setq company-auto-complete t)

(nyan-mode 1)
(setq nyan-animate-nyancat nil)
(setq nyan-wavy-trail t)
(setq nyan-bar-length 32)
(nyan-start-animation)

(require 'evil)
(evil-mode 1)
(evil-ex-define-cmd "ls" 'ibuffer)

(defcustom evil-shift-width 2
  "The offset used by \\<evil-normal-state-map>\\[evil-shift-right] \
and \\[evil-shift-left]."
  :type 'integer
  :group 'evil)

(define-key evil-normal-state-map "g0" 'evil-first-non-blank)
(define-key evil-normal-state-map "0" 'evil-first-non-blank)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "s" 'save-buffer
  "k" 'kill-buffer
  "e" (lambda ()
         (interactive)
         (dired "."))
  "y" 'simpleclip-copy
  )

(evil-commentary-mode)

(if (or
     (file-accessible-directory-p ".git")
     (file-accessible-directory-p ".hg")
     )
    ((lambda ()
      (add-hook 'projectile-mode-hook 'projectile-rails-on)
      (projectile-global-mode)
      (setq projectile-enable-caching t)
      (setq projectile-indexing-method 'native)
      (add-to-list 'projectile-globally-ignored-directories "vendor")
      (add-to-list 'projectile-globally-ignored-directories "tmp")
      (add-to-list 'projectile-globally-ignored-directories "app/assets/images")
      (add-to-list 'projectile-globally-ignored-directories "app/assets/fonts")
      (setq projectile-globally-ignored-file-suffixes '(".png" ".jpg" ".gif" ".woff" ".woff2" ".ttf" ".cache"))
      (setq tags-table-list (cons (concat (projectile-project-root) ".git") '()))

      (evil-leader/set-key
        "cr" 'projectile-rails-find-controller
        "js" 'projectile-rails-find-javascript
        "cs" 'projectile-rails-find-stylesheet
        "r" (lambda ()
              (interactive)
              (dired (projectile-project-root)))
        "h" 'projectile-rails-find-helper
        "l" 'projectile-rails-find-layout
        "m" 'projectile-rails-find-model
        "n" 'projectile-rails-find-mailer
        "p" 'projectile-rails-find-spec
        "t" 'projectile-find-file
        "v" 'projectile-rails-find-view
        "w" 'projectile-rails-find-migration
        )))
  'not-a-projectile-project)

(require 'tomorrow-night-bright-theme)

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-check-syntax-automatically
      '(mode-enabled save idle-change))
(setq flycheck-indication-mode 'left-fringe)

;; Indicate rubocop version
(setq flycheck-ruby-rubocop-executable "~/.rbenv/shims/rubocop")

;; Use c++11 standard.
(add-hook 'c++-mode-hook (lambda ()
                           (setq flycheck-clang-language-standard "c++11"
                                 flycheck-gcc-language-standard "c++11")
                           ))

;; Use c++ mode for header files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(custom-set-variables '(coffee-tab-width 2))
(require 'sass-mode)

(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.hb\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.latex\\'" . latex-mode))
(add-to-list 'auto-mode-alist '("\\.slime\\'" . slim-mode))

;; everything is indented 2 spaces
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Highlight current row
(global-hl-line-mode)

(custom-set-faces
 '(linum ((t (:background "black"))))
 '(linum-relative-current-face ((t (:foreground "white" :background "black"))))
 )

;; Set the font size to 9pt
(set-face-attribute 'default nil :height 90)

(set-face-background 'hl-line "grey9")
(set-face-background 'mode-line "grey9")
(set-face-background 'fringe "black")

(define-fringe-bitmap 'my-flycheck-fringe-indicator
  (vector #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00111100
          #b01111110
          #b11111111
          #b11111111
          #b11111111
          #b11111111
          #b01111110
          #b00111100
          #b00000000
          #b00000000
          #b00000000
          #b00000000))

(set-face-attribute 'flycheck-error nil
                    :background "red"
                    :foreground "white"
                    :underline nil)
(set-face-attribute 'flycheck-warning nil
                    :background "orange"
                    :foreground "white"
                    :underline nil)
(set-face-attribute 'flycheck-info nil
                    :foreground "white"
                    :background "dodger blue"
                    :underline nil)

(set-face-attribute 'flycheck-fringe-error nil
                    :foreground "red")
(set-face-attribute 'flycheck-fringe-warning nil
                    :foreground "orange")
(set-face-attribute 'flycheck-fringe-info nil
                    :foreground "dodger blue")


(flycheck-define-error-level 'error
  :severity 2
  :overlay-category 'flycheck-error-overlay
  :fringe-bitmap 'my-flycheck-fringe-indicator
  :fringe-face 'flycheck-fringe-error)
(flycheck-define-error-level 'warning
  :severity 1
  :overlay-category 'flycheck-warning-overlay
  :fringe-bitmap 'my-flycheck-fringe-indicator
  :fringe-face 'flycheck-fringe-warning)
(flycheck-define-error-level 'info
  :severity 0
  :overlay-category 'flycheck-info-overlay
  :fringe-bitmap 'my-flycheck-fringe-indicator
  :fringe-face 'flycheck-fringe-info)

(defun shreve-dired-mode ()
  (dired-hide-details-mode)
  (linum-mode))
(add-hook 'dired-mode-hook 'shreve-dired-mode)

(defun on-after-init()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)

(provide '.emacs)
;;; .emacs ends here
