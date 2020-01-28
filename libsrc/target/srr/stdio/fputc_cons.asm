;
;	ROM Console routine for  the Sorcerer Exidy
;	By Stefano Bodrato - 23/5/2011
;
;	$Id: fputc_cons.asm,v 1.3 2016-05-15 20:15:46 dom Exp $
;

	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocrlf
	call $e00c
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld	a,10
ENDIF
.nocrlf
	jp $e00c
