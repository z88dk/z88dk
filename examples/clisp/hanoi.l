(defun hanoi (n)
  (__hanoi n 'a 'b 'c))

(defun __hanoi (n from via to)
  (cond ((eq n 1) 
	 (print (list 'move 'disk from '=> to))
	 (terpri))
	(t
	 (__hanoi (- n 1) from to via)
	 (__hanoi 1  from via to)
	 (__hanoi (- n 1) via from to))))
