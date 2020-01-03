;
;	Sharp MZ Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - 5/5/2000
;
;	No auto-repeat for now.
;	Maybe someone wants to improve this ?
;
;	UncleBod - 2018-09-25
;	Added handling of DEL key
;
;	TODO
;	Conversion of mzASCII to real ASCII, especially codes 0-127
;
;	$Id: fgetc_cons.asm,v 1.5 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
;		call	$9b3	; wait for a key
;		call	$bce	; convert it to ASCII

		call	$1B   ;get key
		and	a
		jr		nz,fgetc_cons

.wkey
		call	$1B   ;get key
		and a
		jr	z,wkey

		cp	$66	; was it ENTER ?
		jr	nz,noenter
IF STANDARDESCAPECHARS
		ld	a,10
ELSE
		ld	a,13
ENDIF
.noenter
; Handling of DEL key
		cp	$60	;DEL
		jr	nz,nodelkey
		ld	a,8	;DEL_KEY
.nodelkey		

		ld	l,a
		ld	h,0
		ret
