(use-package projectile
  :defer t
  :init
  (autoload 'projectile-mode "projectile" nil t)

  :config
  (projectile-mode)
  (setq projectile-enable-caching t)
  (defcustom projectile-rails-stylesheet-dirs '("app/assets/stylesheets/")
    "The list of directories to look for the stylesheet files in."
    :group 'projectile-rails
    :type '(repeat string))

  (defcustom projectile-rails-javascript-dirs '("app/assets/javascripts/")
    "The list of directories to look for the javascript files in."
    :group 'projectile-rails
    :type '(repeat string))

  (evil-leader/set-key
    "r" (lambda ()
          (interactive)
          (dired (projectile-project-root)))
    "o" (lambda ()
          (interactive)
          (find-file
           (concat
            (projectile-project-root) "/notes.org")))
    )
  (setq tags-table-list (cons (concat (projectile-project-root) "TAGS") '()))

  ;; Ignore certain directories and files that don't make sense with emacs
  (add-to-list 'projectile-globally-ignored-directories "vendor/bundle")
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories "tmp")
  (add-to-list 'projectile-globally-ignored-directories "app/assets/images")
  (add-to-list 'projectile-globally-ignored-directories "app/assets/fonts")
  (setq projectile-globally-ignored-file-suffixes '(".png" ".jpg" ".gif" ".woff" ".woff2" ".ttf" ".cache"))

  ;; Projectile Rails config
  (if (and
       (file-exists-p "config.ru")
       (file-exists-p "Gemfile")
       )
      ((lambda ()
         (add-hook 'projectile-mode-hook 'projectile-rails-on)

         (evil-leader/set-key
           "cr" 'projectile-rails-find-controller
           "js" 'projectile-rails-find-javascript
           "cs" 'projectile-rails-find-stylesheet
           "h" 'projectile-rails-find-helper
           "l" 'projectile-rails-find-layout
           "m" 'projectile-rails-find-model
           "n" 'projectile-rails-find-mailer
           "p" 'projectile-rails-find-spec
           "v" 'projectile-rails-find-view
           "w" 'projectile-rails-find-migration
           )))
    'not-a-projectile-project)
  )

;;; projectile-config.el ends here
