; based on gitlab.com/olberger/docker-org-teaching-export

(require 'package)
(package-initialize)

(setf enable-local-variables :all)
(require 'ox-reveal)
(require 'org-ref)
(setq org-latex-pdf-process
      '("lualatex -shell-escape -interaction nonstopmode %f"
	"luatatex -shell-escape -interaction nonstopmode %f"))

; Silence compiler warnings as they can be pretty disruptive
(if (boundp 'comp-deferred-compilation)
    (setq native-comp-deferred-compilation nil
          native-comp-async-query-on-exit nil
          native-comp-async-report-warnings-errors 'silent
	  native-comp-speed -1))
