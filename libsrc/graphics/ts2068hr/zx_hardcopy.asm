;
;		Copy the graphics area to the zx printer
;		TS2068 rotated HR display
;
;		Stefano Bodrato, 2018
;
;
;		$Id: zx_hardcopy.asm $
;


		SECTION code_clib
		PUBLIC    zx_hardcopy
		PUBLIC    _zx_hardcopy
		
		EXTERN w_pixeladdress



.zx_hardcopy
._zx_hardcopy

		ld hl,0
.chrows
		ld (xpos+1),hl		; SMC for X coordinate
		push hl
		ld	hl,$5b00
		push hl
		pop ix
		ld	b,0
.clean_prbuf
		ld	(hl),0
		djnz clean_prbuf
		ld	b,8
		
.chcolums
		push bc
        ld l,24 ; char row counter (bottom)
		
.column
		ld	a,l
		add a
		add a
		add a   ; char row * 8
		dec a
		ld	d,0
		ld	e,a
		
		ld b,8
		xor a
.byteloop
		ld c,a	; save byte to be printed
		push hl
		push de
		push bc
.xpos
		ld	 hl,0
		call w_pixeladdress   ; de = screen address, pixel coordinates (hl,de)
		pop bc
		ld	h,d
		ld	l,e
		rlc (hl)
		pop de
		pop hl
		ld	a,c	; restore byte to be printed
		rla		; add bit
		dec de	; move 1 pixel upwards
		djnz byteloop
		
		ld	(ix+0),a	; put byte to be printed into printer buffer
		inc ix			; move to next byte
		dec l
		jr  nz,column	; loop 24 times (8*24=192)
		
		ld bc,8
		add ix,bc
		pop bc
		djnz chcolums		; loop 8 times (1 text column)
		
		CALL $0A23  ; print out the 256 bytes buffer at $5b00
		pop hl
		ld	de,8
		add	hl,de
		bit 1,h
		jr	z,chrows

		ret
