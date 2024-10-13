;; Tangle the config file only when it has changed
(let* ((default-directory user-emacs-directory)
       (early-el-file "early.el"))
  (load-file early-el-file))
