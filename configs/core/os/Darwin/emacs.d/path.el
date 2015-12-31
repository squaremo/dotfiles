;; Set the path to what .bashrc sets itself
(if (not (getenv "TERM_PROGRAM"))
    (setq exec-path
          (append exec-path (split-string (shell-command-to-string "source $HOME/.bashrc && printf $PATH") ":"))))
