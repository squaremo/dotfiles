(add-hook 'clojure-mode-hook 'typed-clojure-mode)

;; Go Oracle
;;(load-file "~/golang/src/code.google.com/p/go.tools/cmd/oracle/oracle.el")

(defun my-go-mode-hook ()
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  ;; Use goimports instead of go-fmt
  ;; (setq gofmt-command "goimports")
  ;; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ;; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  ;;  (go-oracle-mode)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)
