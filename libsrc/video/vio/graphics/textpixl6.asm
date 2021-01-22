
 	SECTION	rodata_clib

 	PUBLIC	textpixl


;        1  2
;        4  8
;       16 32

; VIO graphics mapped as
;	32 4
;	16 2
;	 8 1



 textpixl:
;
;
;       .. X. .X XX
;       .. .. .. ..
;       .. .. .. ..


 	defb	32,  $80+32,  $80+ 4,   $80+36

;       .. X. .X XX
;       X. X. X. X.
;       .. .. .. ..
	defb	 $80+16, $80+48,   $80+20,  $80+52

;       .. X. .X XX
;       .X .X .X .X
;       .. .. .. ..
	defb    $80+ 2,  $80+34,   $80+6,  $80+38

;       .. X. .X XX
;       XX XX XX XX
;       .. .. .. ..
	defb	 $80+18,  $80+50,  $80+22,  $80+54

;	.. X. .X XX
;	.. .. .. ..
;	X. X. X. X.
	defb      $80+8,  $80+40,  $80+12,  $80+44

;	.. X. .X XX
;	X. X. X. X.
;	X. X. X. X.
	defb	 $80+24,  $80+56,  $80+28,  $80+60

;	.. X. .X XX
;       .X .X .X .X
;       X. X. X  X.
	defb	 $80+10,  $80+42,  $80+14,  $80+46

;	.. X. .X XX
;	XX XX XX XX
;	X. X. X. X.
	defb	 $80+26,  $80+58,  $80+30,  $80+62

;	.. X. .X XX
;	.. .. .. ..
;	.X .X .X .X
	defb	  $80+1,  $80+33,   $80+5,  $80+37

;	.. X. .X XX
;       X. X. X. X.
;       .X .X .X .X
	defb	 $80+17,  $80+49,  $80+21,  $80+53

;	.. X. .X XX
;	.X .X .X .X
;	.X .X .X .X
	defb	  $80+3,  $80+35,   $80+7,  $80+39

;	.. X. .X XX
;	XX XX XX XX
;	.X .X .X .X
	defb	 $80+19,  $80+51,  $80+23,  $80+55

;	.. X. .X XX
;       .. .. .. ..
;       XX XX XX XX
	defb	  $80+9,  $80+41,  $80+13,  $80+45

;	.. X. .X XX
;       X. X. X. X.
; 	XX XX XX XX
	defb	 $80+25,  $80+57,  $80+29,  $80+61

;	.. X. .X XX
;	.X .X .X .X
;	XX XX XX XX
	defb	 $80+11,  $80+43,  $80+15,  $80+47

;	.. X. .X XX
;	XX XX XX XX
;	XX XX XX XX
	defb	 $80+27,  $80+59,  $80+31,  $80+63
