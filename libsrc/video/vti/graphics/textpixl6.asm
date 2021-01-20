
	SECTION	rodata_clib

	PUBLIC	textpixl


;        1  2
;        4  8
;       16 32

; VTI graphics mapped as
;	32 4
;	16 2
;	 8 1



textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


	defb	0,   32,   4,   36

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..
	defb	 16, 48,   20,  52

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..
	defb      2,  34,   6,  38

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..
	defb	 18,  50,  22,  54

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.
	defb      8,  40,  12,  44

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.
	defb	 24,  56,  28,  60

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.
	defb	 10,  42,  14,  46

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.
	defb	 26,  58,  30,  62

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X
	defb	  1,  33,   5,  37

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X
	defb	 17,  49,  21,  53

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X
	defb	  3,  35,   7,  39

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X
	defb	 19,  51,  23,  55

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX
	defb	  9,  41,  13,  45

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	 25,  57,  29,  61

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	 11,  43,  15,  47

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	 27,  59,  31,  63
