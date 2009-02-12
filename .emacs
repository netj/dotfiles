;; netj's ~/.emacs
;; Author: Jaeho Shin <netj@sparcs.org>
;; Created: 2006-01-03

;; Hangul
(set-language-environment "Korean")   
(set-default-coding-systems 'utf-8)
(add-hook
 'input-method-activate-hook
 (function (lambda ()
	     (cond ((string= current-input-method "korean-hangul")
		    (setq input-method-verbose-flag nil
			  input-method-highlight-flag nil))))))
(add-hook
 'input-method-inactive-hook
 (function (lambda ()
	     (if (string= current-input-method "korean-hangul")
		 (setq input-method-inactive-hook 'default
		       input-method-highlight-flag t)))))

;; behavior
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
;(create-fontset-from-fontset-spec
;  "-*-lucidatypewriter-*-*-*-*-14-*-*-*-*-*-fontset-lucida14,
;          ascii:-*-lucidatypewriter-*-*-*-*-14-*-*-*-*-*-*-1, 
; korean-ksc5601:-*-gulim-bold-*-*-*-14-*-*-*-*-140-ksx1001.1998-*")
(set-face-font 'default "8x13")
(defun frame-attr (attr) (add-to-list 'default-frame-alist attr))
;(frame-attr '(font . "*-medium-r-*-14-*-iso10646-1"))
(frame-attr '(font . "8x13"))
(frame-attr '(cursor-color . "blue violet"))
(frame-attr '(background-color . "thistle"))
(frame-attr '(vertical-scroll-bars . right))
(tool-bar-mode 0)
(menu-bar-mode 0)
(column-number-mode t)
(transient-mark-mode t)
(global-font-lock-mode t) 
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size nil)
(setq display-time-24hr-format t)

;; AucTeX
(require 'tex-site)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; END OF .emacs

