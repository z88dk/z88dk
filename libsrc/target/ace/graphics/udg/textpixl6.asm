
	SECTION	rodata_clib

	PUBLIC	textpixl

	defc	INV = 128

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
	defb	INV + 31,INV + 29,INV + 30, INV + 28

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.
	defb	INV + 23, INV + 21, INV + 22, INV + 20

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X. X.
	defb	INV + 27, INV + 25, INV + 26, INV + 24

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.
	defb    INV + 19, INV + 17, INV + 18, INV + 16

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
	defb	INV + 15, INV + 13, INV + 14, INV + 12

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	INV + 7, INV + 5, INV + 6, INV + 4

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	INV + 11, INV + 9, INV + 10, INV + 8


;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	INV + 3, INV + 1, INV + 2, INV + 0
