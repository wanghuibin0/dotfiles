(setq-default cursor-type 'bar)
(setq org-refile-use-outline-path 'file)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-image-actual-width nil)
(setq org-startup-folded 'show2levels)

(setq org-capture-templates
      `(("i" "Idea" entry (file ,(concat org-directory "/idea.org"))
         "*  %^{Title} %?\n%U\n")
        ("t" "Todo" entry (file ,(concat org-directory "/gtd.org"))
         "* TODO %?\n%U\n")
        ("n" "Note" entry (file ,(concat org-directory "/note.org"))
         "* %? :NOTE:\n%U\n")
        ("s" "Sci-Note" entry (file ,(concat org-directory "/../sci-notes.org"))
         "* %^{Title} :NOTE:\n%U\n** 问题\n%?\n** 意义\n\n** 方案\n\n** 效果\n\n")
        ("j" "Journal" entry (,(if emacs/>=26p 'file+olp+datetree 'file+datetree)
                              ,(concat org-directory "/journal.org"))
         "* 今日小记\n** 天气：%?\n** 日子：\n** 心情：\n
* 昨天最成功的5件事\n* 今日计划\n
* 梦想/创意/灵感\n* 健康/饮食/运动\n
* 成长/阅读/咨询\n* 科研/事业\n
* 理财/金钱\n* 亲人/朋友\n")
        ("b" "Book" entry (,(if emacs/>=26p 'file+olp+datetree 'file+datetree)
                           ,(concat org-directory "/book.org"))
         "* TODO Topic: %^{Description}  %^g %? Added: %U")))


(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package org-journal
  :config
  (setq org-journal-dir "~/verysync/org/journal")
  (setq org-journal-file-type 'monthly)
  (setq org-journal-file-format "%Y%m%d.org")
  :ensure t
  :bind ("C-c C-x j" . org-journal-new-entry))

(use-package org-download
  :ensure t
  :custom
  (org-download-screenshot-method "import %s")
  (org-download-image-org-width 600)
  :config
  (setq org-download-method 'directory)
  (setq-default org-download-image-dir "~/verysync/org/images")
  (setq-default org-download-heading-lvl nil)
  :hook ((org-mode . org-download-enable)
         (dired-mode . org-download-enable))
  )

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/verysync/org/roam")
  (org-roam-complete-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  :config
  (org-roam-db-autosync-mode))

(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)

(use-package org-ref
  :ensure t)

(use-package tex
  :defer t
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (add-to-list 'TeX-view-program-selection
               '(output-pdf "PDF Tools"))
  )

(use-package helm-bibtex
  :ensure t
  :config
  (setq bibtex-completion-bibliography "~/Zotero/library.bib")
  (setq bibtex-completion-pdf-field "File")
  (setq bibtex-completion-notes-path "~/verysync/org/sci-notes.org")
  (setq bibtex-completion-pdf-open-function
        (lambda (fpath)
          (call-process "llpp" nil 0 nil fpath))))

(use-package anki-editor
  :ensure t
  :defer t)

(use-package esup
  :ensure t
  ;; To use MELPA Stable use ":pin melpa-stable",
  :pin melpa)

(bind-key "C-c m" 'org-mark-ring-goto org-mode-map)
(unbind-key [remap org-capture] counsel-mode-map)

(global-set-key (kbd "<f5>") (lambda() (interactive)(find-file "~/verysync/org/roam/20211209111241-00_index.org")))
(global-set-key (kbd "<f12>") (lambda() (interactive)(find-file "~/.config/centaur-emacs-config/custom-post.el")))
