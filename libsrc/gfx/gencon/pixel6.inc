;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols using generic console
;

IF !__CPU_GBZ80__ 
	INCLUDE	"graphics/grafix.inc"

	EXTERN	textpixl
	EXTERN	div3
	EXTERN	generic_console_printc
	EXTERN	generic_console_vpeek
	EXTERN	generic_console_plotc
	EXTERN	generic_console_pointxy
	EXTERN	__console_w
	EXTERN	__console_h
	EXTERN	__gfx_coords



        ld      a,(__console_w)
        add     a
        dec     a
        cp      h
        ret     c

        ld      a,(__console_h)
	ld	e,a
        add     a
	add	e
        dec     a
        cp      l
        ret     c

	ld	(__gfx_coords),hl
	push	bc		;Save entry bc

	ld	c,h		; x
	ld	de,div3
	ld	h,0		;l = y
	add	hl,de
	ld	b,(hl)		; y / 3
	and	a		; x/2
	ld	a,c
	rra
	ld	c,a
	push	bc		;Save reduced coordinates
IF USEplotc
	call	generic_console_pointxy
ELSE
	ld	e,1		;raw mode
	call	generic_console_vpeek
ENDIF
IF USEindex
	cp	64
	jr	c,inrange
	xor	a
inrange:
	ld	e,a
ELSE
	ld	hl,textpixl
	ld	e,0
	ld	b,64		; whole symbol table size
.ckmap	cp	(hl)		; compare symbol with the one in map
	jr	z,chfound
	inc	hl
	inc	e
	djnz	ckmap
	ld	e,0
ENDIF
chfound:

	; e = pixels set at the coordinate
	pop	hl
	push	hl

	;Find the modulus of orig y /3
	ld	a,(__gfx_coords)	;original y
	sub	h			;reduced y
	sub	h
	sub	h
	ld	h,a		;Remainder, 0..2
	rrca			;Carry set if odd
	ld	a,1 		;Pixel we want to draw
	jr	z,iszero
	; Now values 1 or 2
	jr	c,is1
	add	a
	add	a
is1:
	add	a
	add	a
iszero:
	ld	h,a	;Save pixel to set for a moment
	
	ld	a,(__gfx_coords+1)	;original x
	rrca
	ld	a,h
	jr	nc, evencol
	add	a
evencol:
IF NEEDplot
	or	e
ENDIF
IF NEEDunplot
	cpl
	and	e
ENDIF
IF NEEDxor
	xor	e
ENDIF
IF NEEDpoint
	and	e
	pop	bc	;Dump reduced coordinates
ELSE
  IF USEindex
	; The character is the index
  ELSE
	ld	hl,textpixl
	ld	d,0
	ld	e,a
	add	hl,de
	ld	a,(hl)
  ENDIF
	pop	bc		;Get back reduced coordinates
  IF USEplotc
	ld	d,a
	ld	e,1		;pixel6 mode
	call	generic_console_plotc
  ELSE
	ld	d,a
	ld	e,1		;raw mode
	call	generic_console_printc
  ENDIF
ENDIF
	pop	bc		;restore callers
	ret

ENDIF
