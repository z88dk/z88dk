;;;; Turtle graphics example
;;;; clisp must be compiled with the 'GRAPHICS' option
;;;; 
;;;; $Id: turtle_minimalistic.l $


; Draw a square at a given size
(defun square (n)
  (progn nil
    (fwd n) (right 90)
    (fwd n) (right 90)
    (fwd n) (right 90)
    (fwd n) (right 90)))


; Clear screen, position turtle at (32,24)
; (center of a 64x48 display, direction NORTH, pen DOWN)
(defun init ()
  (progn nil
    (cls)
    (fwd 24)
    (right 90)
    (fwd 32)
    (right 270)
	(pend)))

	
; Draw a spiral of squares
(defun rotate (a n c)
  (cond ((eq n 0) 1)
	(t (progn nil
		(right a)
	    (square n)
	    (rotate (a (- n c) c))))))

(progn nil
  (init) (rotate 16 24 4))
