
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords
	EXTERN	__pc88_ink
	EXTERN	__pc88_paper
	EXTERN	l_push_di
	EXTERN	l_pop_ei
	EXTERN	__CLIB_PC8800_V2_ENABLED
        EXTERN  __gfx_fatpix

; Generic code to handle the pixel commands
; Define NEEDxxx before including

	push	hl		;save x
	call	getmaxy		;hl = maxy
	inc	hl
	call	l_cmp
	pop	hl
	ret	nc

	ex	de,hl		;de = x, hl = y
	push	hl		;save y
	call	getmaxx
	inc	hl
	call	l_cmp
	pop	hl
	ret	nc
	ex	de,hl
	ld	(__gfx_coords),hl	;x
	ld	(__gfx_coords+2),de	;y
	push	bc

	call	l_push_di

	call	w_pixeladdress
	ld	b,a
        ex      af,af
        ld      a,(__gfx_fatpix)
        and     a
        ld      c,@00000001
        jr      z,not_fatpix_rotate
        ld      c,@00000011
        res     0,b
not_fatpix_rotate:
        ex      af,af
        ld      a,c
	jr	z, rotated 	; pixel is at bit 0...
.plot_position	
	rlca
	djnz	plot_position
	; a = byte holding pixel mask
	; hl = address
rotated:
	ld	d,a		;Pixel to set
	cpl
	ld	e,a		;Mask to preserve
IF NEEDunplot
	ld	a,(__pc88_paper)
ELSE
	ld	a,(__pc88_ink)
ENDIF
	ld	c,a

IF NEEDplot|NEEDunplot
 ; IF ALU
	ld	a,__CLIB_PC8800_V2_ENABLED
	and	a
	jp	z,plot_v1_only
        ld      a,$80           ;Turn on expanded gvram
        out     ($35),a
        in      a,($32)         ;Enable ALU
	ld	b,a
        set     6,a
        out     ($32),a
	ld	a,c		;Set colour
	out	($34),a		
	ld	(hl),d
        xor     a               ;Turn off extended gbram
        out     ($35),a
	ld	b,a
        out     ($32),a
	jp	plot_exit
;  ELSE
plot_v1_only:
	out	($5c),a		;Switch to blue plane
	ld	a,(hl)
	and	e
	rrc	c
	jr	nc,noset_blue
	or	d
noset_blue:
	ld	(hl),a
	out	($5e),a		;Switch to green plane
	ld	a,(hl)
	and	e
	rrc	c
	jr	nc,noset_green
	or	d
noset_green:
	ld	(hl),a
	out	($5d),a		;Switch to red plane
	ld	a,(hl)
	and	e
	rrc	c
	jr	nc,noset_red
	or	d
noset_red:
	ld	(hl),a
	out	($5f),a		;Back to main memory
;  ENDIF
plot_exit:
ENDIF

IF NEEDxor
	out	($5c),a		;Switch to blue plane
	ld	a,(hl)
	rrc	c
	jr	nc,noset_blue
	xor	d
noset_blue:
	ld	(hl),a
	out	($5e),a		;Switch to green plane
	ld	a,(hl)
	rrc	c
	jr	nc,noset_green
	xor	d
noset_green:
	ld	(hl),a
	out	($5d),a		;Switch to red plane
	ld	a,(hl)
	rrc	c
	jr	nc,noset_red
	xor	d
noset_red:
	ld	(hl),a
	out	($5f),a		;Back to main memory
ENDIF

IF NEEDpoint
	out	($5c),a
	ld	e,(hl)
	out	($5d),a
	ld	a,(hl)
	or	e
	ld	d,a
	out	($5e),a
	ld	a,(hl)
	or	e
	and	d		;Bit to check
	out	($5f),a
	ex	af,af
	call	l_pop_ei
	ex	af,af
ELSE
	call	l_pop_ei
ENDIF
	pop	bc		;Restore callers
	ret
