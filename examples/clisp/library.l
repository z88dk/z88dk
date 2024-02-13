;;;; 
;;;; Campus LIsP function lib
;;;; 
;;;; $Id: library.l,v 1.6 2015-04-22 17:37:01 stefano Exp $


; factorial example, for comparison to 'minimalistic'
(defun fact (n)
  (if (zerop n)
    1
    (* n (fact (1- n)))))


;constants
	
(setq most-positive-fixnum 134217727)
(setq most-negative-fixnum -134217728)


; print
(defun print (n) (progn (terpri) (princ n)))

; execute a given function on the given argument list
(defun apply (f l)
    (progn (setq z_z (cons f l)) (eval z_z)))


; execute a given function for each list element
; it works also on list of lists
(defun mapcar (f l)
    (progn (setq y_y l) (setq w_w nil)
      (while (not  (null y_y))
            (setq z_z (list f '(car y_y)))
            (setq w_w (cons (eval z_z) w_w))
        (setq y_y (cdr y_y))
      )
    (reverse w_w)
))

; (aka mappend)  maps elements in list and appends the results
(defun mapcan (f l)
    (progn (setq y_y l) (setq w_w nil)
      (while (not  (null y_y))
            (setq z_z (list f '(car y_y)))
            (setq w_w (append w_w (eval z_z)))
        (setq y_y (cdr y_y))
      )
    w_w
))
 
; execute a given function coupling the result of the first
; two list elements to the next one, and so on..
(defun reduce (f l)
    (if (consp l)
        (progn (setq y_y (cdr l)) (setq w_w (car l))
          (while (not  (null y_y))
            (setq z_z (list f 'w_w '(car y_y)))
                (setq w_w (eval z_z))
            (setq y_y (cdr y_y))
          )
        w_w
        )
    l)
)

; positive?
(defun positivep (n)
  (> n 0))

; negative?
(defun negativep (n)
  (> 0 n))

; negative?
(defun minusp (n)
  (> 0 n))

; iseven
(defun evenp (x)
  (if (zerop x) t
  (eq (* 2 (/ x 2)) x)))

;isodd
(defun oddp (x)
  (not (iseven x)))

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


; tiny recursive square root (good for small values only)
(defun sqrt (x)
	(if (negativep x) nil
	(_sqrt x 0)))

(defun _sqrt (x y)
	(if (> (* y y) x) (1- y)
	(_sqrt x (1+ y))))


; non-recursive version (too slow for big values)
(defun sqrt (x)
	(if (< x 0) nil
	(progn
	  (setq zz 0)
	  (while (< (* zz zz) x)
	     (setq zz (1+ zz)))
	  zz)))


; better recursive square root implementation
(defun sqrt (x)
	(if (<= x 0) 0
	(__sqrt x (_sqrt x (bsqrt x (splace 67108864 x) 0)))))

(defun _sqrt (x y)
	(if (< (* y y) x) (1+ y)
	(_sqrt x (1- y))))

(defun __sqrt (x y)
	(if (> (* y y) x) (1- y)
	(__sqrt x (1+ y))))

(defun bsqrt (x p r)
  (cond ((zerop p)
         r)
        ((>= x (+ r p))
           (bsqrt (- x (* r p))
                  (/ p 4)
                  (/ (+ r (* p 2)) 2)))
        (t (bsqrt x (/ p 4) (/ r 2)))))

(defun splace (p x)
	(if (<= p x) p
	   (splace (/ p 4) x)))


; 2nd degree function resolution
(defun quadratic (a b c)
(list (/ (+ (- b) (sqrt (- (* b b) (* 4 a c))))
         (* 2 a))
      (/ (- (- b) (sqrt (- (* b b) (* 4 a c))))
         (* 2 a))))

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

; check if the element is a number
(defun numberp (x)
(cond ((consp x) nil)
       ((null x) nil)
       ((eq t x) nil)
       ((symbolp x) nil)
       (t t)))

; element type query
(defun type-of (x)
(cond ((consp x) 'cons)
       ((null x) 'null)
       ((eq t x) 't)
       ((symbolp x) 'symbol)
       (t 'fixnum)))


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

; flatten (tree-to-list conversion)
(defun flatten (mylist)
  (cond
   ((null mylist) nil)
   ((atom mylist) (list mylist))
   (t
    (append (flatten (car mylist)) (flatten (cdr mylist))))))

;  Choose an element from a list at random.
(defun random-elt (l)
  (nth (random (list-length l)) l))

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

(defun make-set (s)
    (cond ((null s) nil)
          ((member (car s) (cdr s)) (make-set (cdr s)))
          (t (cons (car s) (make-set (cdr s))))))

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

; assv
(defun assv (obj alist) 
  (cond ((null alist) nil) 
    ((equal (car (car alist)) obj) 
        (car alist))
    (t 
        (assv obj (cdr alist))))) 


; sort and splice make up a sorting utility.
; ex: (sort '(3 6 7 1 9) '<) => (1 3 6 7 9).

(defun sort (slist pred)
    (cond ((null slist) nil)
          (t (splice (car slist) (sort (cdr slist) pred) pred))))

(defun splice (elem slist pred)
    (cond ((null slist) (list elem))
          ((eval (list pred elem (car slist))) (cons elem slist))
          (t (cons (car slist) (splice elem (cdr slist) pred)))))




; human friendly comparison
(defun compare (x y)
      (cond ((equal x y)     'numbers-are-the-same)
            ((< x y) 'first-is-smaller)
            ((> x y)  'first-is-bigger)))

; human friendly algebric operations,
;   e.g. (compute 'add 4 5)
(defun compute (op x y)
      (cond ((equal op 'add)      (+ x y))
            ((equal op 'subtract) (- x y))
            ((equal op 'multiply) (* x y))
            ((equal op 'divide)   (/ x y))
            (t '(I do not know how to do that))))

