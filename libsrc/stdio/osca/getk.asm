;
; 	Basic keyboard handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call kjt_get_key
	or a
	jr nz,knz
	ld	b,a
.knz

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
	jr	nz,nodel
	ld	b,12
.nodel

	ld	l,b	; ASCII CODE
	ld	h,0

	ret
