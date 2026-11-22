
; Tiny ELIZA implementation
; please enter your sentences
; (between parenthesis)


(defun nthcdr (n l)
  (cond ((zerop n) l)
        ((null l) nil)
        (t (nthcdr (1- n) (cdr l)))))

(defun nth (n list)
  (if (null (nthcdr n list)) nil
  (car (nthcdr n list))))

(defun member (i x)
  (cond ((null x) nil)
        ((equal i (car x)) x)
        (t (member i (cdr x)))))

; Pick a question word
(defun wword (wword-count)
  (nth (rem wword-count 4)
          '(when why where how) ) )

; used with find
(setq questions '(why where when what which how))

; auxiliary verbs
(setq dpred '(do can should would))

; Choose a default response
(defun punt (cnt)
  (nth (rem cnt 6)
            '((please go on)
              (tell me more)
              (i see)
              (what does that indicate)
              (but why be concerned about it)
              (just tell me how you feel) ) ) )

;  Invert you <> me in a word
(defun ym (w)
  (cond
    ((eq w 'i) 'you) ((eq w 'me) 'you) ((eq w 'you) 'me)
    ((eq w 'my) 'your) ((eq w 'your) 'my) 
    ((eq w 'yours) 'mine) ((eq w 'mine) 'yours)
    ((eq w 'am) 'are) (t w) ) )

; Apply you-me on the whole sentence
(defun youme (l)
    (progn (setq y_y l) (setq w_w nil)
      (while (not  (null y_y))
            (setq z_z (list 'ym '(car y_y)))
            (setq w_w (cons (eval z_z) w_w))
        (setq y_y (cdr y_y))
      )
    (reverse w_w nil)
))

(defun reverse (s r)
  (cond
   ((null s) r)
   (t (reverse (cdr s) (cons (car s) r)))))


; Verb list
(setq verb '(go have be try eat take help make get jump
              write type fill put turn compute cry kill
              drink crash add))

(setq opinionverb '(hope think dream want prefer))

(defun find (x y)
  (cond ((not (consp x)) nil)
		((member (car x) y) x)
        (t (find (cdr x) y))))

;  Print sentence
(defun print-s (message)
   (progn
      (princ message)
      (princ '.)
	  (terpri)
	  ))

;  Print question
(defun print-q (message)
   (progn
      (princ message)
      (princ '?)
	  (terpri)
	  ))

(defun is_in (i l)
  (cond
	((null i) (if (null l) t (setq xx l)))
	((null l) nil)
    ((eq (car i) (car l)) (is_in (cdr i) (cdr l)))
	(t nil)))

(defun match (i l)
  (cond
	((null l) nil)
	((is_in i l) t)
	(t (match i (cdr l)))))

(defun eliza ()
(progn (setq ww 0) (setq wwc 0)
  (while  (setq s (youme (read)))
	 (terpri)
	 (gc)
	 (cond
		  ((match '(you are) s)
			(setq b xx)
			(print-s (list '(please tell me)
							 (list (wword wwc))
							 '(you are) b)))
		  ((match '(you have) s) (setq b xx)
		    (print-q (list '(how long have you had) b)))
          ((match '(you feel) s)
			(print-s '(sometimes i feel the same way)))
          ((match '(because) s) (setq b xx)
            (print-q '(is that really the reason)))
          ((match '(yes) s)
            (print-q (list '(how can you be so sure)
			  (if (match '(me are) b) (list '(i am) xx) b))))
          ((match '(me are) s)
            (print-q (list '(so you think) (setq b (list '(i am) xx)))))
          ((match '(because) s) (setq b xx)
            (print-q '(is that really the reason)))
		  ((setq b (find s opinionverb))
            (print-q (list '(do you really) b)))
		  ((setq b (find s verb))
            (print-q (list (wword wwc) '(have you decided that to) b '(is important for you))))
		  ((setq b (find s questions))
            (print-s (list '(i keep my opinion on) b '(for myself))))
          ((match '(do me think) s)
			(print-s '(i think you should answer that yourself) ))
		  (t (print-s (punt wwc)) )
	  )
	  (setq wwc (1+ wwc))
	  (setq b s)
  )
  (print-s '(goodbye))
))

