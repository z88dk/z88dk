;
;	Fast background save
;
;	$Id: bksave.asm $
;

	SECTION smc_clib
	
	PUBLIC    bksave
	PUBLIC    _bksave

	EXTERN sety
	EXTERN setx
	EXTERN getpat


.bksave
._bksave
	push	ix
        ld      hl,4   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix

	inc     hl
	ld      e,(hl)  
 	inc     hl
	inc     hl
	ld      d,(hl)	; x and y __gfx_coords

	ld	h,d	; current x coordinate
	ld	l,e	; current y coordinate

	ld	(ix+2),h
	ld	(ix+3),l
	
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

.bksaves
	push	bc
	
.rbytes
	ld	b,0	; SMC	; Y byte count
	ld	l,0	; SMC	; Y pos
	
	  
.rloop
      call sety
      call setx
      in a,(0x41) ;dummy read
	in a,(0x41) ;read data
	ld	(ix+4),a
	
	ld	a,8
	add	l
	ld	l,a

	inc	ix
	djnz	rloop

	inc h

	pop	bc
	djnz	bksaves
	
	pop	ix
	ret
