; based on gitlab.com/olberger/docker-org-teaching-export
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-refresh-contents)
(package-initialize)
;; install version of org-mode >= 9.6 to be able to use org-latex-src-block-backend for engraved
;; work around the problem of org-mode being a builtin :-/
;; see https://github.com/jwiegley/use-package/issues/319#issuecomment-845214233
(assq-delete-all 'org package--builtins)
(assq-delete-all 'org package--builtin-versions)
(package-install 'org)
(package-install 'engrave-faces)
(package-install 'org-contrib)
(package-install 'org-ref)
(package-install 'htmlize)
(package-install 'ox-reveal)
