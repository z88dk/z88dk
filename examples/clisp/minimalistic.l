;;;; These functions need to be declared only 
;;;; if clisp is compiled in 'MINIMALISTIC' mode
;;;; 
;;;; memory cost:  'zerop' takes 78 bytes if implemented in C
;;;; 
;;;; $Id: minimalistic.l,v 1.1 2015-03-31 13:50:44 stefano Exp $


; factorial, minimalistic mode example
(defun fact (n)
  (cond ((< n 1)
	 1)
	(t
	 (* n (fact (- n 1))))))


; print
(defun print (n) (progn (terpri) (princ n)))

; zero?
(defun zerop (n)
  (eq n 0))

; greater than or equal to?
(defun >= (n1 n2)
  (or (> n1 n2) (= n1 n2)))

; less than or equal to?
(defun <= (n1 n2)
  (or (< n1 n2) (= n1 n2)))

; eq?
(defun = (n1 n2)
  (eq n1 n2))

; increment
(defun 1+ (n)
  (+ n 1))

; decrement
(defun 1- (n)
  (- n 1))

; remainder
(defun % (a b) (- a (* (/ a b) b)))

; sum
(defun sum (n)
  (cond ((< n 1)
	 0)
	(t
	 (+ n (sum (- n 1))))))

; power
(defun power (x n)
  (cond ((< n 1)
	 1)
	(t
	 (* x (power x (- n 1))))))

; equal
(defun equal (s1 s2)
 (cond ((atom s1)
        (eq s1 s2))
       ((not (atom s2))
	(and (equal (car s1) (car s2))
	     (equal (cdr s1) (cdr s2))))
       (t
	nil)))
