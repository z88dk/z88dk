
	SECTION	rodata_clib

	PUBLIC	textpixl

	EXTERN	base_graphics

;       32 16
;        8  4
;        2  1
; If pixel > 32 then  191 - value

textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


	defb	0,  32,  16, 48

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..

	defb	 8,  40, 24, 56

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..

	defb	 4, 36, 20, 52

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..

	defb	12, 44, 28, 60

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.

	defb	 2, 34, 18, 50

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.

	defb	10, 42, 26, 58

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.

	defb	 6, 38, 22, 54

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.

	defb	14, 46, 30, 62

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X

	defb	  1,  33,  17, 49 

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X

	defb	  9,  41,  25,  57

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X

	defb	  5,  37,  21, 53 

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X

	defb	 13,  45,  29, 61 

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX

	defb	  3,  35,  19, 51

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	 11,  43,  27, 59 

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	  7,  39,  23, 55 

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	 15,  47,  31,  63
