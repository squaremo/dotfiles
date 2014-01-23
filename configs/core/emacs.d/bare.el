;; Remove a bunch of stuff
;; See http://bzg.fr/emacs-strip-tease.html

(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

;; Don't use messages that you don't read
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
;; Don't let Emacs hurt your ears
(setq visible-bell t)
