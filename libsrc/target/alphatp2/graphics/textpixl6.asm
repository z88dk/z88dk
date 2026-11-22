
    SECTION rodata_clib

    PUBLIC  textpixl


;        1  2
;        4  8
;       16 32



textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..

; blank character can be "SPACE" or zero

    defb    32, 1, 2, 3

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..
    defb    4, 5, 6, 7

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..
    defb    8, 9, 10, 11

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..
    defb    12, 13, 14, 15

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.
    defb    0x10, 0x11, 0x12, 0x13

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.
    defb    0x14, 0x15, 0x16, 0x17

;       .. X. .X XX
;       .X .X .X .X
;       X. X. X  X.
    defb    0x18, 0x19, 0x1a, 0x1b

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.
    defb    0x1c, 0x1d, 0x1e, 0x1f
	
;=================================================

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X
    defb    0x9f, 0x9e, 0x9d, 0x9c

;       .. X. .X XX
;       X. X. X. X.
;       .X .X .X .X
    defb    0x9b, 0x9a, 0x99, 0x98

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X
    defb    0x97, 0x96, 0x95, 0x94

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X
    defb    0x93, 0x92, 0x91, 0x90

;       .. X. .X XX
;       .. .. .. ..
;       XX XX XX XX
    defb    0x8f, 0x8e, 0x8d, 0x8c

;	.. X. .X XX
;	X. X. X. X.
;	XX XX XX XX
    defb    0x8b, 0x8a, 0x89, 0x88

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
    defb    0x87, 0x86, 0x85, 0x84

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
    defb    0x83, 0x82, 0x81, 0x80


