;
; 	Basic keyboard handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.2 2011-07-27 15:11:27 stefano Exp $
;


    INCLUDE "flos.def"

	XLIB	fgetc_cons

.fgetc_cons

.kwait

	call kjt_get_key
	or a
	jr z,kwait

	cp	$5a
	jr	nz,noent
	ld	b,13
.noent
	cp	$6b
	jr	nz,noleft
	ld	b,8
.noleft
	cp	$74
	jr	nz,noright
	ld	b,9
.noright
	cp	$75
	jr	nz,noup
	ld	b,11
.noup
	cp	$72
	jr	nz,nodown
	ld	b,10
.nodown
	cp	$71
	jr	z,isdel
	cp	$66
	jr	nz,nodel
.isdel
	ld	b,12
.nodel

	ld	l,b	; ASCII CODE
	ld	h,0

	ret
