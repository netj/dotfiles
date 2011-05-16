;; netj's ~/.emacs
;; Author: Jaeho Shin <netj@sparcs.org>
;; Created: 2006-01-03

;; behavior
(set-language-environment "UTF-8")
(set-language-environment-input-method "Korean")
(setq shell-command-switch "-ic")

(push "~/.emacs.d/elisp" load-path)

(setq inhibit-startup-message t)
(defalias 'yes-or-no-p 'y-or-n-p)
(icomplete-mode)
(setq case-fold-search t)
(setq kill-whole-line t)
(setq make-backup-files nil)
(auto-compression-mode t)
(setq-default auto-fill-function 'do-auto-fill)
(setq fill-column 78)
(global-set-key "\C-x\C-j" 'goto-line)
(defun other-window-reverse () "previous-window" (interactive) (other-window -1))
(global-set-key "\C-x\C-o" 'other-window-reverse)

;; looks
(defun frame-attr (attr) (add-to-list 'default-frame-alist attr))
;(frame-attr '(cursor-color . "blue violet"))
;(frame-attr '(background-color . "thistle"))
(create-fontset-from-fontset-spec
 "-*-*-*-*-*-*-16-160-*-*-*-*-fontset-j,
    latin:-apple-menlo-*-*-*-*-*-*-*-*-m-*-iso10646-1,
   hangul:-apple-HCR Dotum-*-*-*-*-*-*-*-*-p-*-iso10646-1")
;; ;(frame-attr '(font . "*-Palatino-medium-r-*-160-*-iso10646-1"))
(frame-attr '(font . "-*-16-*-fontset-j"))

;; color-theme
(load "color-theme.el")
;; ;; greenish
;; (color-theme-subtle-hacker)
;; (color-theme-gnome2)
;; (color-theme-pok-wog)
;; (color-theme-bharadwaj-slate)
;; (color-theme-jonadabian-slate)
;; ;; blueish
(color-theme-dark-blue2)
;; (color-theme-deep-blue)
;; (color-theme-sitaramv-solaris)

(tool-bar-mode 0)
(menu-bar-mode 1)
(column-number-mode t)
(transient-mark-mode t)
(global-font-lock-mode t) 
(show-paren-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size nil)
(setq display-time-24hr-format t)


;; AUCTeX
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-shell shell-file-name)
(setq TeX-shell-command-option shell-command-switch)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-PDF-mode t)
;; for Mac
(setq-default TeX-view-program-list nil
	      ;; TeX-view-predicate-list nil
	      ;; TeX-view-program-selection nil
	      )
(push '("Evince" "open %o") TeX-view-program-list)
;; (push '(open-pdf "Open") TeX-view-predicate-list)
;; (push '(open-pdf "Open") TeX-view-program-selection)
;; (push TeX-view-program-selection '(open-pdf "Open"))



;; Markdown mode
;; http://jblevins.org/projects/markdown-mode/
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(push '("\\.geul" . markdown-mode) auto-mode-alist)
(push '("\\.markdown" . markdown-mode) auto-mode-alist)
(push '("\\.mkd" . markdown-mode) auto-mode-alist)

;; respect local config
(load "~/.emacs_local" t)

;; END OF .emacs
