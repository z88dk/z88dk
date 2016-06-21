;
;	Fast background restore
;
;	MSX version
;
;	$Id: bkrestore.asm,v 1.6 2016-06-21 20:16:35 dom Exp $
;

	SECTION	code_clib
	PUBLIC    bkrestore
	PUBLIC    _bkrestore
	EXTERN	bkpixeladdress


IF FORmsx
	INCLUDE "msx.def"
ELSE
	INCLUDE "svi.def"
ENDIF


.bkrestore
._bkrestore

; __FASTCALL__ : sprite ptr in HL
	push	ix		;save callers	
	push	hl
	pop	ix

	ld	h,(ix+2)
	ld	l,(ix+3)

	ld	a,(ix+0)
	ld	b,(ix+1)
	
	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Xsize-1)/8+2)
	ld	(rbytes+1),a

.bkrestores
	push	bc

	push	hl
	call	bkpixeladdress
	pop	hl

.rbytes
	ld	b,0
.rloop
	
	;ld	(de),a
	
         ld       a,e		; LSB of video memory ptr
         di
         out      (VDP_CMD),a
         ld       a,d		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         ei
         out      (VDP_CMD), a
         ld       a,(ix+4)	; <- current data byte
         out      (VDP_DATA), a
	
	;inc	de
	
	push	hl		; Point to next byte
	ld	hl,8
	add	hl,de
	ex	de,hl
	pop	hl

	inc	ix
	djnz	rloop

	inc	l
	
	pop	bc
	djnz	bkrestores
	pop	ix	;restore callers
	ret
