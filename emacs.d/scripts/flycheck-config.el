(use-package flycheck
  :defer t
  :config
  (global-flycheck-mode)
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
  )

;;; flycheck-config.el ends here
