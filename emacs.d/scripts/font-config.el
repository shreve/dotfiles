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
