;;; column-enforce-mode.el --- Highlight text that extends beyond a  column
;;
;; Filename: column-enforce-mode.el
;; Description:
;; Author: Jordon Biondo
;; Maintainer:
;; Created: Fri Oct 11 12:14:25 2013 (-0400)
;; Version: 1.0.3
;; Package-Requires: ()
;; Last-Updated: Wed Dec  4 21:37:39 2013 (-0500)
;;           By: Jordon Biondo
;;     Update #: 11
;; URL: www.github.com/jordonbiondo/column-enforce-mode
;; Keywords:
;; Compatibility: Emacs 24.x
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;  Highlight text that extends beyond a certain column (80 column rule)
;;
;;  By default, text after 80 columns will be highlighted in red
;;
;;  To customize behavior, see `column-enforce-column' and `column-enforce-face'
;;
;;  To enable: M-x column-enforce-mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;  2013-10-11 12:17:32 : initial
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variables
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar column-enforce-column 80
  "Begin marking warnings one text after this
 many columns in `column-enforce-mode'.")


(defvar column-enforce-face `(:foreground "red" :underline t)
  "Face used for warnings in `column-enforce-mode'.")


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Interactive functions
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun column-enforce-n (n)
  "Turn on `column-enforce-mode' with warnings at column N.
N can be given as a prefix argument.

Ex:
  C-u 70 M-x column-enforce-n <enter>
  sets up `column-enforce-mode' to mark \
text that extends beyond 70 columns."
  (interactive "P")
  (let ((n (if (and n (integerp n)) n column-enforce-column)))
    (setq column-enforce-mode-line-string
	  (column-enforce-make-mode-line-string n))
    (column-enforce-mode -1)
    (set (make-local-variable 'column-enforce-column) n)
    (column-enforce-mode t)))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Predefined column rules
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defmacro make-column-rule(n)
  "Create an interactive function to enforce an N-column-rule."
  `(let ((__n ,n))
     (assert (integerp __n) nil "Wrong type argument")
     (eval `(defun ,(intern (format "%d-column-rule" __n)) ()
	      ,(format "Visually mark text after %d columns." __n)
	      (interactive)
	      (column-enforce-n ,__n)))))

(make-column-rule 100)
(make-column-rule 90)
(make-column-rule 80)
(make-column-rule 70)
(make-column-rule 60)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun column-enforce-make-mode-line-string(rule)
  "Returns the string to display in the mode line"
  (format "%dcol" rule))

(defvar column-enforce-mode-line-string
  (column-enforce-make-mode-line-string column-enforce-column)
  "The current string for the mode line.")

(define-minor-mode column-enforce-mode
  "Minor mode for highlighting text that extends beyond a certain column.

Variable `column-enforce-column' decides which column to start warning at.
 Default is 80
Variable `column-enforce-face' decides how to display the warnings"
  :init-value nil
  :lighter column-enforce-mode-line-string
  :keymap nil
  :global nil
  (when font-lock-mode
    (let* ((column-str (number-to-string column-enforce-column))
	   (enforce-regexp
	    (format "\\(^.\\{%s,%s\\}\\)\\(.+$\\)" column-str column-str))
	   (enforce-keywords `((,enforce-regexp 2 column-enforce-face prepend))))
      (make-local-variable 'column-enforce-column)
      (if column-enforce-mode
	  (font-lock-add-keywords nil enforce-keywords)
	(font-lock-remove-keywords nil enforce-keywords))
      (font-lock-fontify-buffer))))

(provide 'column-enforce-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; column-enforce-mode.el ends here
