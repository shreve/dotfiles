;;; evil -- evil config
;;; Commentary:
;;; Code:

(use-package evil
  :defer t
  :init
  (autoload 'evil-mode "evil" nil t)

  :config
  (evil-mode 1)
  (require 'ruby-text-objects)
  (evil-ex-define-cmd "ls" 'ibuffer)
  (define-key evil-normal-state-map "g0" 'evil-first-non-blank)
  (define-key evil-normal-state-map "0" 'evil-first-non-blank)
  (defcustom evil-shift-width 2
    "The offset used by \\<evil-normal-state-map>\\[evil-shift-right] and \\[evil-shift-left]."
    :type 'integer
    :group 'evil)

  ;; Load related dependencies
  (evil-commentary-mode)
  (global-evil-leader-mode)
  )

(use-package evil-leader
  :defer t
  :init
  (autoload 'global-evil-leader-mode "evil-leader")

  :config
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    "b" 'fzf-switch-buffer
    "f" 'fzf-find-file
    "s" 'save-buffer
    "k" 'kill-buffer
    "t" 'projectile-find-file
    "e" (lambda ()
          (interactive)
          (dired "."))
    "y" 'simpleclip-copy
    "o" (lambda ()
          (interactive)
          (find-file "~/notes.org"))
    )
  )

(use-package evil-commentary
  :defer t
  :config
  (evil-commentary-mode))

;;; evil.el ends here
