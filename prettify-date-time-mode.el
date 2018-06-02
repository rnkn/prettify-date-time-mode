;;; prettify-date-time-mode.el --- redisplay date and time strings in pretty format  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Paul W. Rankin

;; Author: Paul W. Rankin <hello@paulwrankin.com>
;; Keywords: text
;; Varion: 0.1.0
;; Package-Requires: ((emacs "24.5"))
;; URL: https://github.com/rnkn/prettify-date-time-mode

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


;;; Variables

(defvar prettify-date-time-regexp
  (concat 
   "\\(?1:[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\\)"
   "\\(?2: +[0-9][0-9]:[0-9][0-9]\\(:[0-9][0-9]\\)?\\)?"))


;;; Customization

(defcustom prettify-date-time-format
  (cons "%A, %-d %B %Y" "at %-I:%M%P")
  "Format to redisplay the date and time.
When redisplaying the date, the first element is used, when
redisplaying date and time, both elements are used (a space is
inserted between the two).

See `format-time-string' for options."
  :group 'prettify-date-time-mode
  :safe 'stringp
  :type '(cons (string :tag "Date format string")
               (string :tag "Time format string")))

(defcustom prettify-date-time-lighter
  " Pdatetime"
  "Mode-line indicator for `prettify-date-time-mode'."
  :group 'prettify-date-time-mode
  :safe 'stringp
  :type 'string)


;;; Functions

(defun prettify-date-time-redisplay (start end)
  (goto-char start)
  (while (re-search-forward prettify-date-time-regexp end t)
    (let ((time (apply 'encode-time (parse-time-string
                                     (if (match-string 2)
                                         (match-string 0)
                                       (concat (match-string 0) " 00:00")))))
          string)
      (setq string (format-time-string
                    (if (match-string 2)
                        (concat (car prettify-date-time-format) "\s"
                                (cdr prettify-date-time-format))
                      (car prettify-date-time-format))
                    time))
      (put-text-property (match-beginning 0) (match-end 0) 'display
                         string))))


;;; Mode Definition

(define-minor-mode prettify-date-time-mode
  "Redisplay date and time strings in pretty format."
  :init-value nil
  :lighter prettify-date-time-lighter
  (if prettify-date-time-mode
      (jit-lock-register #'prettify-date-time-redisplay)
    (jit-lock-unregister #'prettify-date-time-redisplay)
    (with-silent-modifications
     (set-text-properties (point-min) (point-max) 'dislay))))

(provide 'prettify-date-time-mode)
;;; prettify-date-time-mode.el ends here
