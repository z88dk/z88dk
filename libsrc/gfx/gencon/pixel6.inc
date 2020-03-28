;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols using generic console
;

IF !__CPU_GBZ80__ & !__CPU_INTEL__
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
	push	ix
	push	bc		;Save entry bc
	ld	ix,-4		;ix + 0 = orig x
				;ix + 1 = orig y
				;ix + 2 = reduced x
				;ix + 3 = reduced y
	add	ix,sp		
	ld	sp,ix
	ld	(ix+0),h
	ld	(ix+1),l

	ld	c,h		; x
	ld	de,div3
	ld	h,0		;l = y
	add	hl,de
	ld	b,(hl)		; y / 3
	srl	c		; x / 2
	ld	(ix+2),c
	ld	(ix+3),b
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

	;Find the modulus of orig y /3
	ld	l,(ix+3)
	ld	a,(ix+1)
	sub	l
	sub	l
	sub	l
	ld	l,a		;Remainder, 0..2
	ld	a,1 		;Pixel we want to draw
	jr	z,iszero
	; Now values 1 or 2
	bit	0,l
	jr	nz,is1
	add	a
	add	a
is1:
	add	a
	add	a
iszero:
	bit	0,(ix+0)	;original x
	jr	z, evencol
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
	ld	c,(ix+2)
	ld	b,(ix+3)
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
	pop	bc		;dump buffer
	pop	bc
	pop	bc		;restore callers
	pop	ix		;restore callers
	ret

ENDIF
