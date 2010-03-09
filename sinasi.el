;;; sinasi.el --- Sinasi Is Not A SproutCore IDE

;; Copyright 2010 Eric Kidd, Phil Hagelberg, Eric Schulte

;; Authors: Eric Kidd, Phil Hagelberg, Eric Schulte
;; URL: http://github.com/emk/sinasi
;; Version: 2.1
;; Created: 2010-03-09
;; Keywords: sproutcore, project
;; Package-Requires: ((jump "2.0"))

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Sinasi Is Not A SproutCore IDE
;;
;; Anything good about Sinasi is the work of Phil Hagelberg and Eric
;; Schulte.  Anything bad is the fault of Eric Kidd.
;;
;; Sinasi is a hacked copy of Rinari, an excellent Emacs toolkit for
;; working with Rails applications.  Sinasi ports a few of the many Rinari
;; features to work with SproutCore applications.  In particular, it allows
;; you to flip between models, unit tests, fixtures, controllers, etc., in
;; a SproutCore source tree.
;;
;; You need to install Rinari and javascript-mode.el to get this working,
;; at least for now.  Eventually, I might add support for installing via
;; ELPA.
;;
;; Please feel free to fork this project on github and enhance it.

(require 'jump)
(require 'javascript-mode)
(require 'cl)

;; Copied from Rinari and hacked accordingly.
(defgroup sinasi nil
  "Sinasi customizations."
  :prefix "sinasi-"
  :group 'sinasi)

;; Copied from Rinari and hacked accordingly.
(defcustom sinasi-tags-file-name
  "tags"
  "Path to your TAGS file inside of your SproutCore project.  See `tags-file-name'."
  :group 'sinasi)

;; Copied from Rinari and hacked accordingly.
(defvar sinasi-minor-mode-prefixes
  (list ",")
  "List of characters, each of which will be bound (with C-c) as a sinasi-minor-mode keymap prefix.")

(defun sinasi-root (&optional dir home)
  ;; Copied from Rinari and hacked accordingly.
  (or dir (setq dir default-directory))
  (if (and (file-exists-p (expand-file-name "Buildfile" dir))
           (file-exists-p (expand-file-name "apps" dir)))
      dir
    (let ((new-dir (expand-file-name (file-name-as-directory "..") dir)))
      ;; regexp to match windows roots, tramp roots, or regular posix roots
      (unless (string-match "\\(^[[:alpha:]]:/$\\|^/[^\/]+:\\|^/$\\)" dir)
	(sinasi-root new-dir)))))

(defun sinasi-clean-tests ()
  "Work around a SproutCore test runner bug that causes it to run stale tests."
  (interactive)
  (let ((root (sinasi-root)))
    (unless root
      (error "Not safe to clean tests outside of a Sinasi project!"))
    (let ((default-directory root))
      (compile "rm -f tmp/debug/build/static/*/*/current/tests/*/*.html"))))

;; Basic file groupings:
;;
;;   apps/APP/models/NAME.js
;;   apps/APP/tests/models/NAME.js
;;   apps/APP/fixtures/NAME.js
;;
;;   apps/APP/controllers/NAMEs.js
;;   apps/APP/tests/controllers/NAMEs.js
;;
;;   apps/APP/views/NAME.js
;;   apps/APP/tests/views/NAME.js
;;   apps/APP/resources/NAME.css
;;
;;   apps/APP/core.js
;;   apps/APP/main.js
;;   apps/APP/resources/main_page.js
(setf
 sinasi-jump-schema
 '((test
    "t"
    (("apps/\\1/models/\\2.js"            . "apps/\\1/tests/models/\\2.js")
     ("apps/\\1/fixtures/\\2.js"          . "apps/\\1/tests/models/\\2.js")
     ("apps/\\1/controllers/\\2.js"       . "apps/\\1/tests/controllers/\\2.js")
     ("apps/\\1/views/\\2.js"             . "apps/\\1/tests/views/\\2.js")
     ("apps/\\1/resources/\\2.css"        . "apps/\\1/tests/views/\\2.js")
     ;; TODO: Handle default case.
     )
    t)
   (model
    "m"
    (("apps/\\1/tests/models/\\2.js"       . "apps/\\1/models/\\2.js")
     ("apps/\\1/fixtures/\\2.js"           . "apps/\\1/models/\\2.js")
     ("apps/\\1/controllers/\\2s.js"       . "apps/\\1/models/\\2.js")
     ("apps/\\1/tests/controllers/\\2s.js" . "apps/\\1/models/\\2.js")
     ("apps/\\1/views/\\2.js"              . "apps/\\1/models/\\2.js")
     ("apps/\\1/tests/views/\\2.js"        . "apps/\\1/models/\\2.js")
     ("apps/\\1/resources/\\2.css"         . "apps/\\1/models/\\2.js")
     ;; TODO: Handle default case.
     )
    t)
   (fixture
    "f"
    (("apps/\\1/models/\\2.js"             . "apps/\\1/fixtures/\\2.js")
     ("apps/\\1/tests/models/\\2.js"       . "apps/\\1/fixtures/\\2.js")
     ("apps/\\1/controllers/\\2s.js"       . "apps/\\1/fixtures/\\2.js")
     ("apps/\\1/tests/controllers/\\2s.js" . "apps/\\1/fixtures/\\2.js")
     ("apps/\\1/views/\\2.js"              . "apps/\\1/fixtures/\\2.js")
     ("apps/\\1/tests/views/\\2.js"        . "apps/\\1/fixtures/\\2.js")
     ("apps/\\1/resources/\\2.css"         . "apps/\\1/fixtures/\\2.js")
     ;; TODO: Handle default case.
     )
    t)
   (controller
    "c"
    (("apps/\\1/models/\\2.js"             . "apps/\\1/controllers/\\2s.js")
     ("apps/\\1/tests/models/\\2.js"       . "apps/\\1/controllers/\\2s.js")
     ("apps/\\1/fixtures/\\2.js"           . "apps/\\1/controllers/\\2s.js")
     ("apps/\\1/tests/controllers/\\2.js"  . "apps/\\1/controllers/\\2.js")
     ("apps/\\1/views/\\2.js"              . "apps/\\1/controllers/\\2s.js")
     ("apps/\\1/tests/views/\\2.js"        . "apps/\\1/controllers/\\2s.js")
     ("apps/\\1/resources/\\2.css"         . "apps/\\1/controllers/\\2s.js")
     ;; TODO: Handle default case.
     )
    t)
   (view
    "v"
    (("apps/\\1/models/\\2.js"             . "apps/\\1/views/\\2.js")
     ("apps/\\1/tests/models/\\2.js"       . "apps/\\1/views/\\2.js")
     ("apps/\\1/fixtures/\\2.js"           . "apps/\\1/views/\\2.js")
     ("apps/\\1/controllers/\\2s.js"       . "apps/\\1/views/\\2.js")
     ("apps/\\1/tests/controllers/\\2s.js" . "apps/\\1/views/\\2.js")
     ("apps/\\1/tests/views/\\2.js"        . "apps/\\1/views/\\2.js")
     ("apps/\\1/resources/\\2.css"         . "apps/\\1/views/\\2.js")
     ;; TODO: Handle default case.
     )
    t)
   (stylesheet
    "s"
    (("apps/\\1/models/\\2.js"             . "apps/\\1/resources/\\2.css")
     ("apps/\\1/tests/models/\\2.js"       . "apps/\\1/resources/\\2.css")
     ("apps/\\1/fixtures/\\2.js"           . "apps/\\1/resources/\\2.css")
     ("apps/\\1/controllers/\\2s.js"       . "apps/\\1/resources/\\2.css")
     ("apps/\\1/tests/controllers/\\2s.js" . "apps/\\1/resources/\\2.css")
     ("apps/\\1/views/\\2.js"              . "apps/\\1/resources/\\2.css")
     ("apps/\\1/tests/views/\\2.js"        . "apps/\\1/resources/\\2.css")
     ;; TODO: Handle default case.
     )
    t)
   (core
    "a" ;; "application"
    (("apps/\\1/.*" . "apps/\\1/core.js"))
    nil)
   (main
    "i" ;; "initialization"
    (("apps/\\1/.*" . "apps/\\1/main.js"))
    nil)
   (main-page
    "p" ;; "page"
    (("apps/\\1/.*" . "apps/\\1/resources/main_page.js"))
    nil)
   ))

(defun sinasi-apply-jump-schema (schema)
  "This function takes a of SCHEMA s.t. each element in the list
can be fed to `defjump'.  This is used to define all of the
sinasi-find-* functions, and can be used to customize their
behavior."
  ;; Copied from Rinari and hacked accordingly.
  (mapcar
   (lambda (type)
     (let ((name (first type))
	   (specs (third type))
	   (make (fourth type)))
       (eval `(defjump
		(quote ,(read (format "sinasi-find-%S" name)))
		(quote ,specs)
		'sinasi-root
		,(format "Go to the most logical %S given the current location" name)
		,(if make `(quote ,make))
                ;; We don't have a JavaScript equivalent, nor really a need
		;; for one.
                ;;'ruby-add-log-current-method
                ))))
   schema))
(sinasi-apply-jump-schema sinasi-jump-schema)

;;--------------------------------------------------------------------
;; minor mode and keymaps

(defvar sinasi-minor-mode-map
  ;; Copied from Rinari and hacked accordingly.
  (let ((map (make-sparse-keymap)))
    map)
  "Key map for Sinasi minor mode.")

(defun sinasi-bind-key-to-func (key func)
  ;; Copied from Rinari and hacked accordingly.
  (dolist (prefix sinasi-minor-mode-prefixes)
    (eval `(define-key sinasi-minor-mode-map 
             ,(format "\C-c%s%s" prefix key) ,func))))

(defvar sinasi-minor-mode-keybindings
  ;; Copied from Rinari and hacked accordingly.
  '(("c" . 'sinasi-clean-tests))
  "alist mapping of keys to functions in `sinasi-minor-mode'")

;; Copied from Rinari and hacked accordingly.
(mapcar (lambda (el) (sinasi-bind-key-to-func (car el) (cdr el)))
	(append (mapcar (lambda (el)
			  (cons (concat "f" (second el))
				(read (format "'sinasi-find-%S" (first el)))))
			sinasi-jump-schema)
		sinasi-minor-mode-keybindings))

(defun sinasi-bind-finders-with-prefix (prefix)
  "Bind the sinasi-find-* commands under an additonal prefix.
For example, to bind the finders using prefix super-s, run:

    (sinasi-bind-finders-with-prefix ?\\s-s)

This assumes you have a working Super key in your Emacs."
  (dolist (schema sinasi-jump-schema)
    (let ((command (read (format "'sinasi-find-%S" (first schema))))
          (key (read (format "?%s" (second schema)))))
      (eval `(define-key sinasi-minor-mode-map [,prefix ,key]
                ,command)))))

;;;###autoload
(defun sinasi-launch ()
  "Run `sinasi-minor-mode' if inside of a SproutCore project,
otherwise turn `sinasi-minor-mode' off if it is on."
  ;; Copied from Rinari and hacked accordingly.
  (interactive)
  (let* ((root (sinasi-root)) (s-tags-path (concat root sinasi-tags-file-name)))
    (if root (progn
	       (set (make-local-variable 'tags-file-name)
		    (and (file-exists-p s-tags-path) s-tags-path))
	       (run-hooks 'sinasi-minor-mode-hook)
	       (sinasi-minor-mode t))
      (if (and (fboundp sinasi-minor-mode) sinasi-minor-mode) (sinasi-minor-mode)))))

;;;###autoload
(defvar sinasi-major-modes
  ;; Copied from Rinari and hacked accordingly.
  (if (boundp 'sinasi-major-modes)
      sinasi-major-modes
    (list 'find-file-hook 'dired-mode-hook))
  "Major Modes from which to launch Sinasi.")

;;;###autoload
(dolist (hook sinasi-major-modes) (add-hook hook 'sinasi-launch))

(defadvice cd (after sinasi-on-cd activate)
  "Active/Deactive sinasi-minor-node when changing into and out
  of SproutCore project directories."
  ;; Copied from Rinari and hacked accordingly.
  (sinasi-launch))

;;;###autoload
(define-minor-mode sinasi-minor-mode
  "Enable Sinasi minor mode providing Emacs support for working
with the SproutCore framework.

\\{sinasi-minor-mode-map}"
  ;; Copied from Rinari and hacked accordingly.  
  nil
  " Sinasi"
  sinasi-minor-mode-map)

(provide 'sinasi)
;;; sinasi.el ends here
