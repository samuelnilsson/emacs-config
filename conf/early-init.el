;; Tangle the config file only when it has changed
(let* ((default-directory user-emacs-directory)
       (org-file "config.org")
       (el-file "config.el")
       (changed-at (file-attribute-modification-time (file-attributes org-file))))
  (require 'org-macs)
  (unless (org-file-newer-than-p el-file changed-at)
    (require 'ob-tangle)
    (org-babel-tangle-file org-file el-file "emacs-lisp")))
