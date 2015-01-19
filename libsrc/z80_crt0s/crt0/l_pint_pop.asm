;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       23/1/2001  djm

                PUBLIC    l_pint_pop
		EXTERN	l_pint

; store int from HL into (DE)
.l_pint_pop   
	pop	bc	;return address
	pop	de	;where to put it
	push	bc
	jp	l_pint
