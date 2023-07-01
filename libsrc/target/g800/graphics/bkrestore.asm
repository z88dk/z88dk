;
;	Fast background restore
;
;	$Id: bkrestore.asm $
;

	SECTION smc_clib
	
	
	EXTERN sety
	EXTERN setx
	EXTERN getpat

    PUBLIC    bkrestore
    PUBLIC    _bkrestore
    PUBLIC    bkrestore_fastcall
    PUBLIC    _bkrestore_fastcall

.bkrestore
._bkrestore
    pop de
    pop hl
    push hl
    push de

.bkrestore_fastcall
._bkrestore_fastcall

	push	ix
; __FASTCALL__ : sprite ptr in HL
	
	push	hl
	pop	ix

	ld	h,(ix+2)
	ld	l,(ix+3)
	
	ld	a,l
	ld	(rbytes+3),a	; Y pos

	ld	b,(ix+0)	; Xsize
	ld	a,(ix+1)	; Ysize
	
	dec	a
	srl	a
	srl	a
	srl	a
	inc	a
	inc	a		; INT ((Ysize-1)/8+2)
	ld	(rbytes+1),a	; Y byte count

.bkrestores
	push	bc

.rbytes
	ld	b,0	; SMC	; Y byte count
	ld	l,0	; SMC	; Y pos
	
	  
.rloop	  
      call sety
      call setx
;      in a,(0x41) ;dummy read
	ld	a,(ix+4)
	out (0x41),a ;write data  (auto-increment)
	
	ld	a,8
	add	l
	ld	l,a

	inc	ix
	djnz	rloop

	inc h
	
	pop	bc
	djnz	bkrestores
	
	pop	ix
	ret
