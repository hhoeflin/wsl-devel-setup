;;;; package.el
(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
               ("marmalade" . "http://marmalade-repo.org/packages/")
               ("melpa" . "http://melpa.milkbox.net/packages/")
))
  (package-initialize)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; load needed packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; ess
(require 'ess-site)
(ess-toggle-underscore nil)

;;;; IDO
(require 'ido)
(ido-mode t)

;;;; tramp
(require 'tramp)
(setq tramp-default-method "ssh")

;;;; auto-complete
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)

;;;; org-mode
(setq org-todo-keywords
      '((sequence "TODO(t!)" "STARTED(s!)" "PROGRESS(p!)" "WAITING(w!)" "|" "DONE(d!)" "CANCELED(c!)")))

(setq org-todo-keyword-faces 
        '(("TODO" . org-todo) ("STARTED" . org-todo) ("PROGRESS" . org-todo)
        ("WAITING" . "blue") ("DONE" . org-done) ("CANCELLED", org-done)))

; ORG-IDO (target completion)
(setq org-completion-use-ido t)

(require 'ob)
;; todo: figure out what to do for org-babel...
(require 'ob-R)
(require 'ob-emacs-lisp)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (emacs-lisp . t)
   (python . t)
   (sql . t)
   (sqlite . t)
   ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(electric-indent-mode nil)
 '(ess-default-style (quote RRR))
 '(inhibit-startup-screen t)
 '(org-confirm-babel-evaluate nil)
 '(org-src-fontify-natively t)
 '(org-startup-truncated nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Emacs jump to last line after eval in ir
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)

;; switch on auto fill mode so that lines are not too long
;;(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; activate cua mode
(cua-mode t)
    (setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
    (transient-mark-mode 1) ;; No region when it is not highlighted
    (setq cua-keep-region-after-copy nil) ;; Standard Windows behaviour

;; ESS Mode (.R file)
  (define-key ess-mode-map (kbd "<f11>") 'ess-eval-line-and-step)
  (define-key ess-mode-map (kbd "<f10>") 'ess-eval-function-or-paragraph-and-step)
  (define-key ess-mode-map (kbd "<f12>") 'ess-eval-region)

;; make emacs work with clipboard
(setq x-select-enable-clipboard t)

(require 'poly-R)
(require 'poly-markdown)

;;; MARKDOWN
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

;;; R modes
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; window switcher
(require 'switch-window)
(global-set-key (kbd "C-x p") 'ace-window)


;; emacs and python as well as ipython
(package-initialize)
(elpy-enable)
(elpy-use-ipython)



(setq python-shell-interpreter "ipython"
;       python-shell-interpreter-args "--simple-prompt --pprint")
       python-shell-interpreter-args "-i")

;  some key bindings
(define-key elpy-mode-map (kbd "<f12>") `elpy-shell-send-region-or-buffer)
(define-key elpy-mode-map (kbd "<f11>") `elpy-shell-send-current-statement)
(define-key elpy-mode-map (kbd "<f10>") `python-shell-send-defun)
(define-key elpy-mode-map (kbd "<f9>") `elpy-shell-switch-to-shell)

;; revert all buffers; useful in git
(defun revert-all-buffers ()
     "Refreshes all open buffers from their respective files"
     (interactive)
     (let* ((list (buffer-list))
            (buffer (car list)))
       (while buffer
         (when (and (buffer-file-name buffer) 
                    (not (buffer-modified-p buffer)))
           (set-buffer buffer)
           (revert-buffer t t t))
         (setq list (cdr list))
         (setq buffer (car list))))
     (message "Refreshed open files")
)

(global-set-key (kbd "<f8>") 'revert-all-buffers)
