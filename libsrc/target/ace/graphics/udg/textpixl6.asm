
	SECTION	rodata_clib

	PUBLIC	textpixl

	defc	BASE = 96

;        2  1
;        8  4
;       32 16

textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


	defb	0,2, 1, 3

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..
	defb	8,10,9,11

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..
	defb	4,6,5,7

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..
	defb	12,14,13,15

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.
	defb	BASE + 0,BASE + 2,BASE + 1, BASE + 3

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.
	defb	BASE + 8, BASE + 10, BASE + 9, BASE + 11

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.
	defb	BASE + 4, BASE + 6, BASE + 5, BASE  + 7

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.
	defb    BASE + 12, BASE + 14, BASE + 13, BASE + 15

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X
	defb	16, 18, 17, 19

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X
	defb	24, 26, 25, 27


;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X
	defb	20, 22, 21, 23

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X
        defb    28, 30, 29, 31

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX
	defb	BASE + 16, BASE + 18, BASE + 17, BASE + 19

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	BASE + 24, BASE + 26, BASE + 25, BASE + 27

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	BASE + 20, BASE + 22, BASE + 21, BASE + 23


;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	BASE + 28, BASE + 30, BASE + 29, BASE + 31
