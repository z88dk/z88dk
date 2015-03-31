;;;; 
;;;; Campus LIsP function lib
;;;; 
;;;; $Id: library.l,v 1.3 2015-03-31 20:55:08 stefano Exp $


; factorial example, for comparison to 'minimalistic'
(defun fact (n)
  (if (zerop n)
    1
    (* n (fact (1- n)))))


; print
(defun print (n) (progn (terpri) (princ n)))

; execute a given function on the given argument list
(defun apply (f l)
    (progn (setq z_z (cons f l)) (eval z_z)))

; positive?
(defun positivep (n)
  (> n 0))

; negative?
(defun negativep (n)
  (> 0 n))

; sum
(defun sum (n)
  (if (zerop n)
     0
     (+ n (sum (1- n)))))

; power
(defun expt (x n)
  (if (zerop n)
     1
     (* x (expt x (1- n)))))

; absolute value
(defun abs (n)
  (if (< n 0)
     (- 0 n)
     n))

; greatest common divisor
(defun gcd (a b)
  (if (zerop b) (abs a) (gcd b (% a b))))

; compute the greatest common divisor on a list
; i.e. (l_gcd '(24 8 32 4'))
(defun l_gcd (l) (_l_gcd (car l) (cdr l)))
(defun _l_gcd (a l)
  (if (null l)
    a 
    (_l_gcd (gcd a (car l)) (cdr l))))

    
; least common multiple
(defun lcm (a b) 
  (/ (abs (* a b)) (gcd a b))))

; least common multiple from a list
; i.e. (l_lcm '(20 4 8 18))
(defun l_lcm (l) (_l_lcm (car l) (cdr l)))
(defun _l_lcm (a l)
  (if (null l)
    a 
    (_l_lcm (lcm a (car l)) (cdr l))))

; check if last list element
(defun endp (l)
  (if (null (cdr l))
  t nil))

; cdr alias
(defun rest (x)
  (cdr x))

; cddr
(defun cddr (x)
  (cdr (cdr x)))

; caar
(defun caar (x)
  (car (car x)))

; cadr
(defun cadr (x)
  (car (cdr x)))

; cadadr
(defun cadadr (x)
  (car (cdr (car (cdr x)))))

; skip n elements in list (aka list-tail)
(defun nthcdr (n l)
  (cond ((zerop n) l)
        ((null l) nil)
        (t (nthcdr (1- n) (cdr l)))))

; pick an element at a given position in a list
; Note that the elements are numbered from zero, not one.
(defun nth (n list)
  (if (null (nthcdr n list)) nil
  (car (nthcdr n list))))

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

; see whether a previously 'qset' object is a member of list
(defun memq (i x)
  (cond ((null x) nil)
        ((eq i (car x)) x)
        (t (memq i (cdr x)))))

; see whether a previously 'qset' object is a member of list
(defun member (i x)
  (cond ((null x) nil)
        ((equal i (car x)) x)
        (t (member i (cdr x)))))

; list length
(defun length (x) (_length 0 x))
(defun _length (n l)
  (if (null l)
    n
    (_length (1+ n) (cdr l))))

; list union, add items from list2 to list1 avoiding duplicates
(defun union (x y)
  (if (consp x)
      (if (member (car x) y)
          (union (cdr x) y)
          (cons (car x) (union (cdr x) y)))
      y))

; list intersection
(defun intersection (x y)
  (if (consp x)
      (if (member (car x) y)
          (cons (car x) (intersection (cdr x) y))
          (intersection (cdr x) y))
      '()))
;;;;;;;;;;
; copy list
(defun copy-list (l)
  (if (consp l)
      (cons (car l) (copy-list (cdr l)))
      l))

; copy tree
(defun copy-tree (x)
  (if (consp x)
      (cons (copy-tree (car x))
            (copy-tree (cdr x)))
      x))

; subst - find and replace elements in a tree
(defun subst (new old tree)
  (if (consp tree)
      (cons (subst new old (car tree))
            (subst new old (cdr tree)))
      (if (equal old tree)
          new
          tree)))

; assv
(defun assv (obj alist) 
  (cond ((null alist) nil) 
    ((equal (car (car alist)) obj) 
        (car alist))
    (t 
        (assv obj (cdr alist))))) 


; sublis - find and replace list
(defun sublis (alist tree)
  (if (consp tree)
      (cons (sublis alist (car tree))
            (sublis alist (cdr tree)))
      (if (assv tree alist)
          (cdr (assv tree alist))
          tree)))
