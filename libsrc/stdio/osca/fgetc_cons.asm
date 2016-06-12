;
; 	Basic keyboard handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.6 2016-06-12 17:32:01 dom Exp $
;


    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons


.fgetc_cons
._fgetc_cons

.kwait

	ld	a,(buf)
	and a
	jr	z,nobuf
	ld	b,a
	xor	a
	ld	(buf),a
	jr	dokey
.nobuf
	call kjt_get_key
	or a
	jr z,kwait

	cp	20		; CTRL
	jr  nz,noctrl
	; Let's handle CTRL-Z and CTRL-C
.ctrl_wait
	call kjt_get_key
	or	a
	jr z,ctrl_wait
	cp  33
	jr	nz,nobreak
	ld	a,3
.nobreak
	; keyboard scan code for Z is 26 which is perfect
	; for CTRL-Z without further conversions
	ld	b,a
	jr  dokey
.noctrl
	cp	$5a
	jr	nz,noent
	ld	b,13
	ld	a,10
	ld  (buf),a
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
.dokey
	ld	l,b	; ASCII CODE
	ld	h,0

	ret

        SECTION bss_clib
.buf defb 0
