;; package --- Summary
;;; Commentary:
;;; Code:
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; 3rd party config
(add-to-list 'load-path "~/.emacs.d/theme")
(add-to-list 'load-path "~/.emacs.d/vendor")

(require 'whitespace)
(require 'evil)
(require 'evil-leader)
(require 'grizzl)
(require 'tomorrow-night-bright-theme)
(require 'flycheck)
(require 'sass-mode)
(require 'web-mode)
(require 'yaml-mode)
(require 'ruby-text-objects)
(require 'crystal-mode)
(require 'jade-mode)

;; General Config
(setenv "PATH" (concat  "~/.emacs.d/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("~/.emacs.d/bin")))
(setq exec-path (append exec-path '("~/.yarn/bin")))
(setq scroll-step 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq inhibit-splash-screen t)
(menu-bar-mode -1) ;; minimal chrome
(tool-bar-mode -1) ;; hide tool bar
(toggle-scroll-bar -1)
(show-paren-mode 1) ;; show matching parens
(save-place-mode 1)
(setq tab-stop-list (number-sequence 2 60 2)) ;; generate a list from 2-60 by 2s
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Don't ask until the TAGS file is 15 Mb.
(setq large-file-warning-threshold 15000000)

;; Set the title of the window to emacs + buffer path
(setq frame-title-format
      (list
       '(buffer-file-name
         "emacs %f"
         (dired-directory dired-directory "%b"))))

(setq projectile-completion-system 'grizzl)

(defun grizzl-select-buffer ()
  "Select a buffer via `grizzl-search'."
  (interactive)
  (let* (
         (visible-buffer-names
          (loop for buffer being the buffers
                for buffer-name = (buffer-name buffer)
                if (not (string-match "^ " buffer-name))
                collect buffer-name
                )
          )
         (buffers-index (grizzl-make-index visible-buffer-names))
         (buffer (grizzl-completing-read "Buffer: " buffers-index)))
    (if (not (eq buffer (buffer-name)))
        (switch-to-buffer buffer))))

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
(setq tags-revert-without-query 1)

;; Don't require 'yes' or 'no', just 'y' or 'n'
(defalias 'yes-or-no-p 'y-or-n-p)

(global-linum-mode 1)
(linum-relative-mode 1)
(setq left-margin-width 20)
(defvar linum-relative-format)
(setq linum-relative-format "%4s \u2502 ")
(defvar linum-relative-current-symbol)
(setq linum-relative-current-symbol "")

;; Fill Column Indicator (80 char line)
(setq fci-rule-column 79)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(add-hook 'web-mode-hook (lambda () (fci-mode 0)))

(evil-mode 1)
(evil-ex-define-cmd "ls" 'ibuffer)

(defcustom evil-shift-width 2
  "The offset used by \\<evil-normal-state-map>\\[evil-shift-right] \
and \\[evil-shift-left]."
  :type 'integer
  :group 'evil)

(define-key evil-normal-state-map "g0" 'evil-first-non-blank)
(define-key evil-normal-state-map "0" 'evil-first-non-blank)

(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "b" 'grizzl-select-buffer
  "s" 'save-buffer
  "k" 'kill-buffer
  "e" (lambda ()
        (interactive)
        (dired "."))
  "y" 'simpleclip-copy
  "o" (lambda ()
        (interactive)
        (find-file "~/notes.org"))
  )

(evil-commentary-mode)

(defcustom projectile-rails-stylesheet-dirs '("app/assets/stylesheets/")
  "The list of directories to look for the stylesheet files in."
  :group 'projectile-rails
  :type '(repeat string))

(defcustom projectile-rails-javascript-dirs '("app/assets/javascripts/")
  "The list of directories to look for the javascript files in."
  :group 'projectile-rails
  :type '(repeat string))

(if (or
     (file-accessible-directory-p ".git")
     (file-accessible-directory-p ".hg")
     )
    ((lambda ()
      (add-hook 'projectile-mode-hook 'projectile-rails-on)
      (projectile-global-mode)
      (setq projectile-enable-caching t)
      ;; (setq projectile-indexing-method 'alien)
      (add-to-list 'projectile-globally-ignored-directories "vendor/bundle")
      (add-to-list 'projectile-globally-ignored-directories "node_modules")
      (add-to-list 'projectile-globally-ignored-directories "tmp")
      (add-to-list 'projectile-globally-ignored-directories "app/assets/images")
      (add-to-list 'projectile-globally-ignored-directories "app/assets/fonts")
      (setq projectile-globally-ignored-file-suffixes '(".png" ".jpg" ".gif" ".woff" ".woff2" ".ttf" ".cache"))
      (setq tags-table-list (cons (concat (projectile-project-root) "TAGS") '()))

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
        "o" (lambda ()
              (interactive)
              (find-file
               (concat
                (projectile-project-root) "/notes.org")))
        "p" 'projectile-rails-find-spec
        "t" 'projectile-find-file
        "v" 'projectile-rails-find-view
        "w" 'projectile-rails-find-migration
        )))
  'not-a-projectile-project)

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-check-syntax-automatically
      '(mode-enabled save idle-change))
(setq flycheck-indication-mode 'left-fringe)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; Indicate rubocop version
(setq flycheck-ruby-rubocop-executable "~/.rbenv/shims/rubocop")

;; Use c++11 standard.
(add-hook 'c++-mode-hook (lambda ()
                           (setq flycheck-clang-language-standard "c++11"
                                 flycheck-gcc-language-standard "c++11")
                           ))

;; Use c++ mode for header files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

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

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Set the font size to 9pt
(set-face-attribute 'default nil
                    :family "Fira Mono"
                    :height 140)

(set-face-attribute 'linum nil
                    :background "black"
                    :foreground "#999")

(set-face-attribute 'linum-relative-current-face nil
                    :foreground "white"
                    :background "black")

(set-face-background 'mode-line "grey9")
(set-face-background 'fringe "black")

(set-face-attribute 'whitespace-space nil
                    :background "black"
                    :foreground "#333")
(set-face-attribute 'whitespace-newline nil
                    :background "black"
                    :foreground "#333")

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

(defun shreve-dired-mode ()
  "Configure dired mode to my liking."
  (dired-hide-details-mode)
  (auto-revert-mode)
  (linum-mode))
(add-hook 'dired-mode-hook 'shreve-dired-mode)

(defun shreve-text-mode ()
  "Configure Emacs for more intuitive large-blob editing."
  (visual-line-mode)
  (define-key evil-normal-state-map "j" 'next-line)
  (define-key evil-normal-state-map "k" 'previous-line)
  (fci-mode 0))
(add-hook 'latex-mode-hook 'shreve-text-mode)
(add-hook 'org-mode-hook 'shreve-text-mode)
(add-hook 'markdown-mode-hook 'shreve-text-mode)

(defun shreve-jade-mode ()
  "Use company preferred formatting for jade/pug files."
  (setq indent-tabs-mode t)
  (setq tab-width 4))
  (whitespace-mode)
(add-to-list 'auto-mode-alist '("\\.jade\\'" . jade-mode))
(add-hook 'jade-mode-hook 'shreve-jade-mode)

(defun shreve-markdown-mode ()
  "Configure Emacs for pleasant journaling use."
  (markdown-mode)
  (auto-fill-mode 1)
  (fci-mode 1)
  (setq fill-column 80)
)
(add-to-list 'auto-mode-alist '("\\.md\\'" . shreve-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.txt\\'" . shreve-markdown-mode))

;;
;; Ruby-specific code folding config
;;
(add-hook 'ruby-mode-hook (lambda () (hs-minor-mode)))

(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
    `(ruby-mode
      ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
      ,(rx (or "}" "]" "end"))                       ; Block end
      ,(rx (or "#" "=begin"))                        ; Comment start
      ruby-forward-sexp nil)))
(global-set-key (kbd "C-c h") 'hs-hide-block)
(global-set-key (kbd "C-c s") 'hs-show-block)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (js2-mode eslint-fix csharp-mode scss-mode dockerfile-mode magit grizzl fzf ag jsx-mode rjsx-mode notmuch web-mode slim-mode simpleclip sass-mode rust-mode projectile-rails package-utils linum-relative jade-mode indent-guide goto-last-change go-mode flycheck flx-ido fish-mode fill-column-indicator evil-leader evil-commentary elixir-mode coffee-mode apib-mode)))
 '(safe-local-variable-values (quote ((fci-rule-column . 99)))))

(provide '.emacs)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
