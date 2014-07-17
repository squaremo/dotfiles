
;; Standard PC keys
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [insertchar] 'overwrite-mode)

;; Some preferred bindings
(global-set-key [?\M-g] 'goto-line)
(global-set-key [(control tab)] 'other-window)

;; Themes: F1 for dark, F2 for light (better if in sunlight)
(defun light-theme ()
  (interactive)
  (load-theme 'solarized-light))
(defun dark-theme ()
  (interactive)
  (load-theme 'solarized-dark))

(global-set-key [f1] 'dark-theme)
(global-set-key [f2] 'light-theme)

;; Allow tabs to be literally inserted when editing C
;(setq c-tab-always-indent nil)

;; Tabs are evil
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 2)

(global-set-key [button5] 'forward-block-of-lines)
(global-set-key [button4] 'backward-block-of-lines)

;; Use directory-ish uniquifying
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;; Clojure, Lisp, Scheme
(defun turn-on-paredit () (paredit-mode +1))
(defun turn-off-paredit () (paredit-mode 0))
;(add-hook 'clojure-mode-hook 'turn-on-paredit)
;; Somehow Clojure mode automagically switches paredit on, and paredit
;; is evil. So switch it off again.
(add-hook 'clojure-mode-hook 'turn-off-paredit)
;; Mostly of use for the above languages
(show-paren-mode)

;; Prettty! Well, allegedly.
;;(byte-compile-file "~/.xemacs/rainbow-delimiters.el")
(require 'rainbow-delimiters)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)

(require 'erlang)
(setq auto-mode-alist (append auto-mode-alist
                              '(("\\.rel$" . erlang-mode)
                                ("\\.app$" . erlang-mode)
                                ("\\.appSrc$" . erlang-mode)
                                ("\\.app.src$" . erlang-mode)
                                ("\\.hrl$" . erlang-mode)
                                ("\\.erl$" . erlang-mode)
                                ("\\.yrl$" . erlang-mode)
                                ("rebar\\.config" . erlang-mode))))

(add-hook 'haskell-mode-hook '(turn-on-haskell-indentation))

;; Tuareg mode is broken unless you turn SMIE indentation off
(require 'tuareg)
(setq tuareg-use-smie nil)

;; Save sessions
(desktop-save-mode 1)
;; enable emacs-client; may be worth aliasing emacs to emacs-client
(server-start)
