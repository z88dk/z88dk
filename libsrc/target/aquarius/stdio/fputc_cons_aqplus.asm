;
;	Mattel Aquarius Routines
;
;	Print character to the screen
;
;       We can corrupt any register
;
;
;	$Id: fputc_cons.asm,v 1.3 2016-05-15 20:15:45 dom Exp $
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native

TTYCHR	 equ $1d72
ext_call equ $2103

;
; Entry:   char to print
;


.fputc_cons_native
	push	ix

	ld	hl,4
	add	hl,sp
	ld	a,(hl); Now A contains the char
IF STANDARDESCAPECHARS
        cp      10      ; CR ?
        jr      nz,nocrlf
	ld	iy, TTYCHR
	call	ext_call
	ld	a,13
ELSE
	cp	13
	jr	nz,nocrlf
	ld	iy, TTYCHR
	call	ext_call
	ld	a,10
ENDIF
.nocrlf
	cp	12
	jr	nz,nocls
	ld	a,$b
.nocls	
	ld	iy, TTYCHR
	call	ext_call

	pop	ix
	ret
