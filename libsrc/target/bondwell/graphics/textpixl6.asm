
	SECTION	rodata_clib

	PUBLIC	textpixl

	EXTERN	base_graphics


;       1   2
;       4   8
;       16 32


textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..

	defb	32, 2, 1, 3


;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..

	defb	8, 10, 9, 11


;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..

	defb	4, 6, 5, 7


;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..

	defb	12, 14, 13, 15


;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.

	defb	0x9f, 0x9d, 0x9e, 0x9c


;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.

	defb	0x97, 0x95, 0x96, 0x94


;	.. X. .X XX
;	.X .X .X .X
;	X. X. X  X.

	defb	0x9b, 0x99, 0x9a, 0x98


;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.

	defb	0x93, 0x91, 0x92, 0x90


;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X

	defb	16, 18, 17, 19


;	.. X. .X XX
;	X. X. X. X.
;	.X .X .X .X

	defb	24, 26, 25, 27


;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X

	defb	20, 22, 21, 23


;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X

	defb	28, 30, 29, 31


;	.. X. .X XX
;	.. .. .. ..
;	XX XX XX XX

	defb	0x8f, 0x8d, 0x8e, 0x8c


;	.. X. .X XX
;	X. X. X. X.
; 	XX XX XX XX

	defb	0x87, 0x85, 0x86, 0x84


;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX

	defb	0x8b, 0x89, 0x8a, 0x88


;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX

	defb	0x83, 0x81, 0x82, 128



        SECTION code_crt_init

        ld      hl,0xf800
        ld      (base_graphics),hl
