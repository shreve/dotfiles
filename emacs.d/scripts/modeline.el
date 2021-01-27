;;; modeline -- Andrew's modeline
;;; Commentary:
;;; Code:

(defvar modeline/show-minor-modes)

(setq modeline/show-minor-modes t)

(defun modeline/toggle-minor-modes ()
  "Toggle modeline/show-minor-modes between t and nil."
  (interactive)
  (setq modeline/show-minor-modes (not modeline/show-minor-modes)))

(defun shorten-directory (dir max-length)
  "Show up to `MAX-LENGTH' characters of a directory name `DIR'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length containing LEFT, and RIGHT aligned respectively."
  (let* ((available-width (- (window-width) (length left) 2)))
    (format (format "%%s %%%ds" available-width) left right)))

(setq-default
 mode-line-format
 '((:eval
    (simple-mode-line-render
     ;; left
     (format-mode-line
      (quote
       (
        ;; Position, including warning for 80 columns
        (:propertize "%4l " face mode-line-position-face)
        (:eval (propertize " %c" 'face
                           (if (>= (current-column) 80)
                               'mode-line-80col-face
                             'mode-line-position-face)))

        mode-line-client " " ;; emacsclient

        ;; read-only or modified status
        (:eval
         (cond (buffer-read-only
                (propertize " RO " 'face 'mode-line-read-only-face))
               ((buffer-modified-p)
                (propertize " M " 'face 'mode-line-modified-face))
               (t "")))
        " "

        ;; directory and buffer/file name
        (:propertize (:eval (shorten-directory default-directory 30)) face mode-line-folder-face)
        (:propertize "%b" face mode-line-filename-face)

        (projectile-mode projectile-mode-line)  "  " ;; projectile
        (vc-mode vc-mode) ;; git branch

        "  %[" ;; tells you recursive editing status (if applicable)
        (:propertize mode-name face mode-line-mode-face) "  " ;; major mode
        (flycheck-mode flycheck-mode-line) ;; flycheck
        )))
     ;; right
     (format-mode-line
      (quote
       ("%m: "
        mode-line-misc-info " " ;; misc info has some nice things like persp.el workspaces
        (modeline/show-minor-modes mode-line-modes)
        )))))))

(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)

(set-face-attribute 'mode-line nil
                    :foreground "gray60" :background "gray9"
                    :inverse-video nil
                    )
(set-face-attribute 'mode-line-inactive nil
                    :foreground "gray80" :background "gray40"
                    :inverse-video nil
                    )
(set-face-attribute 'mode-line-read-only-face nil
                    :inherit 'mode-line-face
                    :foreground "#4271ae")
(set-face-attribute 'mode-line-modified-face nil
                    :inherit 'mode-line-face
                    :foreground "#c82829"
                    :background "#ffffff")
(set-face-attribute 'mode-line-folder-face nil
                    :inherit 'mode-line-face
                    :foreground "gray60")
(set-face-attribute 'mode-line-filename-face nil
                    :inherit 'mode-line-face
                    :foreground "#eab700"
                    :weight 'bold)
(set-face-attribute 'mode-line-position-face nil
                    :inherit 'mode-line-face)
(set-face-attribute 'mode-line-mode-face nil
                    :inherit 'mode-line-face
                    :foreground "gray80")
(set-face-attribute 'mode-line-minor-mode-face nil
                    :inherit 'mode-line-mode-face
                    :foreground "gray40")
(set-face-attribute 'mode-line-process-face nil
                    :inherit 'mode-line-face
                    :foreground "#718c00")
(set-face-attribute 'mode-line-80col-face nil
                    :inherit 'mode-line-position-face
                    :foreground "black" :background "#eab700")

;;; modeline.el ends here
