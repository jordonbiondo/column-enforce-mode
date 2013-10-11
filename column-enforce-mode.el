;;; column-enforce-mode.el --- Highlight text that extends beyond a  column
;;
;; Filename: column-enforce-mode.el
;; Description:
;; Author: Jordon Biondo
;; Maintainer:
;; Created: Fri Oct 11 12:14:25 2013 (-0400)
;; Version: 1.0.1
;; Package-Requires: ()
;; Last-Updated: Fri Oct 11 12:37:51 2013 (-0400)
;;           By: Jordon Biondo
;;     Update #: 8
;; URL: www.github.com/jordonbiondo/column-enforce-mode
;; Keywords:
;; Compatibility:
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

(defvar column-enforce-column 80
  "Begin marking warnings one text after this
 many columns in `column-enforce-mode'.")


(defvar column-enforce-face `(:foreground "red" :underline t)
  "Face used for warnings in `column-enforce-mode'.")


(define-minor-mode column-enforce-mode
  "Minor mode for highlighting text that extends beyond a certain column.

Variable `column-enforce-column' decides which column to start warning at.
 Default is 80
Variable `column-enforce-face' decides how to display the warnings"
  :init-value nil
  :lighter (format "col:%d!" column-enforce-column)
  :keymap nil
  :global nil
  (when font-lock-mode
    (let* ((column-str (number-to-string column-enforce-column))
	   (enforce-regexp
	    (format "\\(^.\\{%s,%s\\}\\)\\(.+$\\)" column-str column-str))
	   (enforce-keywords `((,enforce-regexp 2 column-enforce-face prepend))))
      (if column-enforce-mode
	  (font-lock-add-keywords nil enforce-keywords)
	(font-lock-remove-keywords nil enforce-keywords))
      (font-lock-fontify-buffer))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; column-enforce-mode.el ends here
