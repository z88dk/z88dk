
; Classic LISP 'DataDase' demonstration
; we miss a lot of core functions, they need to be provided in LISP

;----------------------------
;        PROPERTIES
;----------------------------


; Global store (define once)
(setq *props* nil)


; Searches an association list (alist) for a pair whose car equals obj
(defun assv (obj alist) 
  (cond
    ((null alist)
        nil) 
    ((eq (car (car alist)) obj) 
        (car alist))
    (t 
        (assv obj (cdr alist)))
  )
)


;-------------------------------
; PUTPROP: [obj, value, property] (returns value)
;    e.g.  (putprop 'sky 'blue 'color)

;    New object: create (obj . ((prop . val))) and add to *props*
;    Existing object: rebuild its property alist with (prop . val)

(defun putprop (obj val prop)
  (progn
    (setq entry (assv obj *props*))
    (cond
      ((null entry)
       (setq *props* (cons (cons obj (cons (cons prop val) nil)) *props*))
       val)
      (t
       (setq plist (cdr entry))
       (setq ppair (assv prop plist))
       (cond
         ((null ppair)
          (rplacd entry (cons (cons prop val) plist))
          val)
         (t
          (rplacd ppair val)
          val))))))


;-------------------------------
; GETPROP [obj, property] (returns value or 'nil')
;    e.g.  (getprop 'sky 'color)

(defun alist-get (key alist)
    (if (null (assv key alist)) nil (cdr (assv key alist))))

(defun getprop (obj prop)
    (if
      (null (assv obj *props*)) nil
      (alist-get prop (cdr (assv obj *props*)))))


;-------------------------------
; REMPROP [obj, property] (returns 't' or 'nil')
;    e.g.  (remprop 'sky 'color)

(defun delete (e l)
  (cond
    ((null l) nil)
    ((equal e (car l)) (cdr l))
    (t (cons (car l) (delete e (cdr l))))))

(defun remprop (obj prop)
  (progn
    (setq entry (assv obj *props*))
    (cond
      ((null entry) nil)
      (t
       (setq plist (cdr entry))
       (setq ppair (assv prop plist))
       (cond
         ((null ppair) nil)
         (t
          (rplacd entry (delete ppair plist))
          t))))))



;----------------------------
;         DATABASE
;----------------------------

; Inserts a fact under 'data for its key, which avoids duplicates
;    e.g.  (insert '(father john))

(defun insert (fact)
  (putprop (car fact) (cdr fact) 'data)
)


; Removes a fact looking for the 'data key only
;    e.g.  (remove 'father)

(defun remove (fact)
  (if (getprop fact 'data)
      (progn
        (remprop fact 'data)
        fact)
      nil))


; Picks the declared 'data property
;    e.g.  (get 'father)
(defun get (key)
  (getprop key 'data))
