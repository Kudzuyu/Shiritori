#lang racket

(require racket/gui/base)
(require db)

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

(send frame show #t)
