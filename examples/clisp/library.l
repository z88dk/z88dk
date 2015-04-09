;;;; 
;;;; Campus LIsP function lib
;;;; 
;;;; $Id: library.l,v 1.5 2015-04-09 19:08:47 stefano Exp $


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

; check if the element is a list
(defun listp (l)
  (cond ((null l) t)
		((consp l) t)
		(t nil)))

; check if the element is an atom
(defun atom (l)
  (if (not (consp l)) t nil))

; car alias
(defun first (x)
  (car x))

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

; cadr alias
(defun second (x)
  (car (cdr x)))

; caddr
(defun caddr (x)
  (car (cdr (cdr x))))

; caddr alias
(defun third (x)
  (car (cdr (cdr x))))

; cadar
(defun cadar (x)
  (car (cdr (car x))))

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
; elt works similarly
(defun nth (n list)
  (if (null (nthcdr n list)) nil
  (car (nthcdr n list))))

; last list element
(defun last (l)
  (cond ((null l) nil)
        ((endp l) (car l))
        (t (last (cdr l)))))

; remove last list element
(defun butlast (l)
  (cond ((null l) nil)
        ((endp l) nil)
        (t (cons (car l) (butlast (cdr l))))))

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
(defun list-length (l)
  (if (null l) 0
     (1+ (list-length (cdr l)))))

; list union, add items from list2 to list1 avoiding duplicates
(defun union (x y)
  (cond ((not (consp x)) y)
        ((member (car x) y) (union (cdr x) y))
        (t (cons (car x) (union (cdr x) y)))))

; list intersection
(defun intersection (x y)
  (cond ((not (consp x)) nil)
        ((member (car x) y)
            (cons (car x) (intersection (cdr x) y)))
        (t (intersection (cdr x) y))))

; Returns a list of elements of list1 that do not appear in list2.
(defun set-difference (x y)
(cond
  ((null x) x)
  ((member (car x) y) (set-difference (cdr x) y))
  (t (cons (car x) (set-difference (cdr x) y)))))

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
  (cond ((consp tree)
            (cons (subst new old (car tree))
            (subst new old (cdr tree))))
        ((equal old tree)
             new)
        (t tree)))

; assv
(defun assv (obj alist) 
  (cond ((null alist) nil) 
    ((equal (car (car alist)) obj) 
        (car alist))
    (t 
        (assv obj (cdr alist))))) 


; identify elements from first list not present in 2nd list
(defun set-difference (x y)
  (cond ((not (consp x)) nil)
        ((member (car x) y) (set-difference (cdr x) y))
         (t   (cons (car x) (set-difference (cdr x) y)))))

; count the leaves
(defun count-leaves (x)
  (cond ((null x) 0)  
        ((not (consp x)) 1)
        (t (+ (count-leaves (car x))
              (count-leaves (cdr x))))))

;
; association lists
;

(defun acons (x y a) 
   (cons (cons x y) a))

; sublis - find and replace an association list in a tree
(defun sublis (alist tree)
  (cond ((consp tree)  (cons (sublis alist (car tree))
                       (sublis alist (cdr tree))))
        ((assv tree alist)   (cdr (assv tree alist)))
        (t tree)))

; pairlis - get two pairs from an association list and associate their elements
;    i.e. (pairlis '(one two three) '(1 2 3))
;            =>((one 1) (two 2) (three 3))
(defun pairlis (x y)
  (if (null x) nil
    (cons (cons (car x) (car y)) (pairlis (cdr x) (cdr y)))))

