;; Set the path to what .bashrc sets itself
(if (not (getenv "TERM_PROGRAM"))
    (setenv "PATH"
            (shell-command-to-string "source $HOME/.bashrc && printf $PATH")))
