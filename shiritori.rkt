#lang racket

(require racket/gui/base)
(require db)


;;Database Connection
(define connect (sqlite3-connect #:database "data.db" #:mode 'create))


(define number-of-used-words 0)
(define history-list (new text%))


;;GUI
(define frame
  (new frame%
       (label "しりとり")
       (width 500)
       (height 300)))

(define vertical-1
  (new vertical-panel%
       (parent frame)))

(define answer
  (new editor-canvas%
       (parent vertical-1)
       (min-height 40)
       (stretchable-width 300)
       (style '(resize-corner))
       (label "answer canvas")))

(define horizontal-1
  (new horizontal-panel%
       (parent frame)))

(define input-text
  (new text-field%
       (label "あなた>")
       (parent horizontal-1)))

(new button%
     (parent horizontal-1)
     (label "入力"))


;;Word manipulate
(define (last-char word)
  (let ((len (string-length word)))
   (substring word (- len 1) len)))

(define (last-two-char word)
  (let ((len (string-length word)))
   (substring word (- len 2) (- len 1))))

(define (input-prompt turn)
  (send history-list insert (format "~a:~a>" turn number-of-used-words)))


;;Database query
(define (search-word word)
  (let ((last-ch (last-char word)))
   (query-value (format "select word from wordsa where word like '~a%' limit 1" last-ch))))

(define (insert-word-to-table)
  (query-exec connect "insert or ignore into words values($1)"))


;; Database initialize/reset/create
(define (create-table)
  (when (= (query-value connect "select count(*) from sqlite_master where type='table' and name='words';") 0)
    (define (create-new-table table)
      (format "create table ~a (word text unique)" table))
    (query-exec connect (create-new-table "words"))
    (query-exec connect (create-new-table "wordsa"))
    (query-exec connect (create-new-table "used_words"))))

(define (database-initialize)
  (define (reset-table table)
    (format "drop table ~a; create table ~a (word text unique)" table table))
  (query-exec connect (reset-table "wordsa"))
  (query-exec connect "insert into wordsa select * from words order by random()")
  (query-exec connect (reset-table "words"))
  (query-exec connect "insert into words select * from wordsa")
  (query-exec connect (reset-table "used_words")))

(create-table)

(send frame show #t)
