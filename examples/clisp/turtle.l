;;;; Turtle graphics example
;;;; clisp must be compiled with the 'GRAPHICS' option
;;;; 
;;;; $Id: turtle.l $


; Draw a square at a given size
(defun square (n)
  (progn nil
    (fwd n) (right 90)
    (fwd n) (right 90)
    (fwd n) (right 90)
    (fwd n) (right 90)))


; Clear screen, position turtle at (88,128)
; (center of a 255x192 display, direction NORTH, pen DOWN)
(defun init ()
  (progn nil
    (cls)
    (fwd 96)
    (right 90)
    (fwd 128)
    (right 270)
	(pend)))

	
; Draw a spiral of squares
(defun rotate (a n c)
  (while (> n 0)
    (right a)
    (square n)
    (setq n (- n c))))

(progn nil
  (init) (rotate 8 50 2))
