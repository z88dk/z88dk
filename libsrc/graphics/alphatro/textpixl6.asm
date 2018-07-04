
	SECTION	rodata_clib

	PUBLIC	textpixl

	EXTERN	base_graphics

;       1   2
;       4   8
;       16 32
; If pixel > 32 then  191 - value

textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


	defb	0,   1,   2,  3

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..

	defb	 4,   5,  6,   7

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..

	defb	 8,  9, 10, 11

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..

	defb	12, 13, 14, 15

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.

	defb	16, 17, 18, 19

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.

	defb	20, 21, 22, 23

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.

	defb	24, 25, 26, 27

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.

	defb	28, 29, 30, 31

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X

	defb	159, 158, 157, 156

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X

	defb	155, 154, 153, 152

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X

	defb	151, 150, 149, 148

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X

	defb	147, 146, 145, 144

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX

	defb	143, 142, 141, 140

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	139, 138, 137, 136

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	135, 134, 133, 132

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	131, 130, 129, 128

        SECTION code_crt_init
        ld      hl,0xf000
        ld      (base_graphics),hl
