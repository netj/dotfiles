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


;; for detecting operating system
(defun system-type-is-mac ()
  (interactive)
  "Return true if system is darwin-based (Mac OS X)"
  (string-equal system-type "darwin"))
(defun system-type-is-gnu ()
  (interactive)
  "Return true if system is GNU/Linux-based"
  (string-equal system-type "gnu/linux"))


;; AUCTeX
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-shell shell-file-name)
(setq TeX-shell-command-option shell-command-switch)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-PDF-mode t)
;; See-Also: http://www.bleedingmind.com/index.php/2010/06/17/synctex-on-linux-and-mac-os-x-with-emacs/
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(setq TeX-source-correlate-method 'synctex)
(server-start)
(when (system-type-is-mac)
    ;; for Mac, add the "open" command for viewing pdf
    (setq TeX-view-program-list '(("Open" "open %o")))
    (setq TeX-view-program-selection '((output-pdf "Open")))
    ;;; See-Also: http://tex.stackexchange.com/questions/11613/launching-an-external-pdf-viewer-from-emacs-auctex-on-a-mac-osx-fails
    (add-hook 'LaTeX-mode-hook
          (lambda()
            (add-to-list 'TeX-expand-list
                 '("%q" skim-make-url))))
    (defun skim-make-url () (concat
            (TeX-current-line)
            " "
            (expand-file-name (funcall file (TeX-output-extension) t)
                (file-name-directory (TeX-master-file)))
            " "
            (buffer-file-name)))
    (setq TeX-view-program-list
          '(("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %q")))
    (setq TeX-view-program-selection '((output-pdf "Skim")))
)


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
