(defcustom sspp-flow-basic-offset 4 "Basic indent offset for sspp-flow-mode."
  :group 'sspp-flow)

(defvar sspp-flow-font-lock-keywords
  (list
   '("\\<\\(SPP_DEF_STATE_EXIT\\)\\>" . font-lock-function-name-face)
   '("\\<\\(SPP_DEF_STATE\\)\\>" . font-lock-builtin-face))
  "Minimal highlighting expressions for sspp-flow mode.")

(defvar sspp-flow-mode-syntax-table
  (let ((sspp-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" sspp-mode-syntax-table)
    (modify-syntax-entry ?/ ". 124b" sspp-mode-syntax-table)
    (modify-syntax-entry ?* ". 23" sspp-mode-syntax-table)
    (modify-syntax-entry ?\n "> b" sspp-mode-syntax-table)
    sspp-mode-syntax-table)
  "Syntax table for sspp-flow-mode")

(defun sspp-flow-indent-line ()
  "Indent current line as sspp-flow code."
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at "^[ \t]*)")
          (progn
            (save-excursion
              (forward-line -1)
              (setq cur-indent (- (current-indentation) tab-width)))
            (if (< cur-indent 0)
                (setq cur-indent 0)))
        (save-excursion
          (while not-indented
            (forward-line -1)
            (if (looking-at "^[ \t]*)")
                (progn
                  (setq cur-indent (current-indentation))
                  (setq not-indented nil))
              (if (looking-at "^[ \t]*SPP_DEF_STATE[ \t]*(")
                  (progn
                    (setq cur-indent (+ (current-indentation) tab-width))
                    (setq not-indented nil))
                (if (bobp)
                    (setq not-indented nil)))))))
      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0)))))


(define-derived-mode sspp-flow-mode fundamental-mode "sspp-flow"
  "Major mode for editing SSPP flow definition files."
  (set (make-local-variable 'indent-line-function) 'sspp-flow-indent-line)
  (set (make-local-variable 'font-lock-defaults) '(sspp-flow-font-lock-keywords))
  (set (make-local-variable 'tab-width) sspp-flow-basic-offset))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.flow\\'" . sspp-flow-mode))

(provide 'sspp-flow-mode)
