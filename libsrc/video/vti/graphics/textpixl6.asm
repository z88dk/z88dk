
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


	defb	63,  31,  59,   27

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..
	defb	 47, 15,   43,  11

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..
	defb     61,  29,  57,  25

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..
	defb	 45,  13,  41,   9

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.
	defb     55,  23,  51,  19

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.
	defb	 39,   7,  35,   3

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.
	defb	 53,  21,  49,  17

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.
	defb	 37,   5,  33,   1

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X
	defb	 62,  30,  58,  26

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X
	defb	 46,  14,  42,  10

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X
	defb	 60,  28,  56,  24

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X
	defb	 44,  12,  40,   8

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX
	defb	 54,  12,  50,  18

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	 38,   6,  34,   2

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	 52,  20,  48,  16

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	 36,   4,  32,   0
