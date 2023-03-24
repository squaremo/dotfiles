;; Marmalade package repo
(require 'package)
; Marmalade seems to have been unavailable since about 2021:
; https://www.emacswiki.org/emacs/MarmaladeRepo
;(add-to-list 'package-archives
;             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
