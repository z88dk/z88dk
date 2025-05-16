;;;; These functions need to be declared only 
;;;; if clisp is compiled in 'MINIMALISTIC' mode
;;;; 
;;;; memory cost comparison:  'zerop' takes 78 bytes if implemented in C
;;;; 
;;;; $Id: minimalistic.l $


; factorial, minimalistic mode example
(defun fact (n)
  (cond ((> 1 n)
	 1)
	(t
	 (* n (fact (- n 1))))))


; print
(defun print (n) (progn (terpri) (princ n)))

; zero?
(defun zerop (n)
  (eq n 0))

; less than?
(defun < (n1 n2)
  (> n2 n1))

; greater than or equal to?
(defun >= (n1 n2)
  (or (> n1 n2) (= n1 n2)))

; less than or equal to?
(defun <= (n1 n2)
  (or (> n2 n1) (= n1 n2)))

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
(defun rem (a b) (- a (* (/ a b) b)))

; random alternative, for NO_TIMER builds
; SEED must be initialized with a value between 1 and 99
(setq seed 55)
(defun random (x) (progn nil
   (setq seed (rem (+ 2113233 (* seed 271821)) 9999991))
   (rem seed x)))

; as above, for SHORT atoms
(defun random (x) (progn nil
   (setq seed (abs (rem (+ 133 (* seed 113)) 991)))
   (rem seed x)))

; absolute value
(defun abs (n)
  (if (not (> n 0))
     (- 0 n)
     n))

; sum
(defun sum (n)
  (cond ((> 1 n)
	 0)
	(t
	 (+ n (sum (- n 1))))))

; power
(defun power (x n)
  (cond ((> 1 n)
	 1)
	(t
	 (* x (power x (- n 1))))))

; atom
(defun atom (x) (not (consp x)))

; and
(defun and (x y)
 (not (or (not x) (not y))))

; equal
(defun equal (s1 s2)
 (cond ((not (consp s1))
        (eq s1 s2))
       ((consp s2)
	(and (equal (car s1) (car s2))
	     (equal (cdr s1) (cdr s2))))
       (t
	nil)))

; reverse
(defun reverse (s)
  (__reverse s nil))
  
(defun __reverse (s r)
  (cond
   ((null s) r)
   (t (__reverse (cdr s) (cons (car s) r)))))

; append
(defun append (ls1 ls2)
  (if (null ls1)
    ls2
    (cons (car ls1) (append (cdr ls1) ls2))))

; revappend
(defun revappend (x y)
  (append (reverse x) y))

; flatten (tree-to-list conversion)
(defun flatten (mylist)
  (cond
   ((null mylist) nil)
   ((not (consp mylist)) (list mylist))
   (t
    (append (flatten (car mylist)) (flatten (cdr mylist))))))

; list length
(defun list-length (l)
  (if (null l) 0
     (+ (list-length (cdr l)) 1)))

; see whether a previously 'qset' object is a member of list
(defun member (i x)
  (cond ((null x) nil)
        ((equal i (car x)) x)
        (t (member i (cdr x)))))

; list intersection, difference..
; Example:
; (setq lst1 '(A b C d))
; (setq lst2 '(a B C d))
; (ldifference lst1 lst2)

(defun intersection (x y)
  (cond ((not (consp x)) nil)
        ((member (car x) y)
            (cons (car x) (intersection (cdr x) y)))
        (t (intersection (cdr x) y))))

(defun ldifference (in out)
    (cond ((null in) nil)
          ((member (car in) out) (ldifference (cdr in) out))
          (t (cons (car in) (ldifference (cdr in) out)))))


