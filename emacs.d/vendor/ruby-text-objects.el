;;;  ruby-text-objects.el  ---  Ruby text objects for evil mode
;;
;; Copyright (C) 2017 Jacob Evan Shreve
;;
;; Author: Jacob Evan Shreve <shreve@umich.edu>
;; Keywords: ruby, evil, vi
;; Package-Requires: ((evil "1.0"))
;;
;;
;;; Commentary:
;;
;; This package provides several text objects to be used in coordination with
;; actions provided by evil mode.
;;
;; This package automatically enables itself when necessary, so you only need to
;; require it from your ~/.emacs file.
;;
;; Inspiration:
;;
;; https://github.com/XuHaoJun/evil-ruby-block-object/blob/master/evil-ruby-block-object.el
;; https://github.com/hpdeifel/evil-latex-textobjects/blob/master/evil-latex-textobjects.el
;;
;;; Code:

(defvar ruby-block-beg-re)
(defvar ruby-block-end-re)
(defvar ruby-defun-beg-re)

(setq-default ruby-block-beg-re
              "\\(?:begin\\|c\\(?:ase\\|lass\\)\\|d\\(?:ef\\|o\\)\\|for\\|if\\|module\\|un\\(?:less\\|til\\)\\|while\\|{\\)")

(setq-default ruby-defun-beg-re
              "\\(def\\|class\\|module\\)")

(setq-default ruby-block-end-re
              "\\(_<end\\_>|}\\)")

(defmacro define-and-bind-text-object (key start-regex end-regex)
  "Bind a text object to a letter based on start and end regex.

KEY is a single letter.  START-REGEX, END-REGEX are regex strings."

  (let ((inner-name (make-symbol "inner-name"))
        (outer-name (make-symbol "outer-name")))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count t))

       (define-key evil-inner-text-objects-map ,key (quote ,inner-name))
       (define-key evil-outer-text-objects-map ,key (quote ,outer-name)))))

(define-and-bind-text-object "b"
                             ruby-block-beg-re
                             ruby-block-end-re)
(define-and-bind-text-object "m"
                             (concat "\n\s*" ruby-defun-beg-re ".*$")
                             (concat ruby-block-end-re "\n"))


(provide 'ruby-text-objects)
;;; ruby-text-objects.el ends here
