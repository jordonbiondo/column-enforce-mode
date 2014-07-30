(flycheck-define-checker column-enforce-test
  "Some docs"
  :command ("cem-longlines"
            source
            (eval (format "%d" tab-width))
            (eval (format "%d" (column-enforce-get-column))))
  :error-parser (lambda (output checker buffer)
                  (mapcar (lambda (line)
                            (flycheck-error-new
                             :level 'warning
                             :buffer buffer
                             :checker checker
                             :filename (buffer-file-name buffer)
                             :line (string-to-int line)
                             :column 0
                             :message (format "Line is too long [%d/%d]"
                                              (string-to-int line)
                                              (column-enforce-get-column))))
                             
                          (split-string output "\n")))
  :predicate  (lambda () (and (executable-find "cem-longlines") (buffer-file-name (current-buffer)))))
