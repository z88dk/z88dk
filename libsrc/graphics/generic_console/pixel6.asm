;
;       Generic pseudo graphics routines for text-only platforms
;	Version for the 2x3 graphics symbols using generic console
;


	INCLUDE	"graphics/grafix.inc"

	EXTERN	textpixl
	EXTERN	div3
	EXTERN	generic_console_printc
	EXTERN	generic_console_vpeek


			ld	a,h
			cp	maxx
			ret	nc
			ld	a,l
			cp	maxy
			ret	nc		; y0	out of range
			
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

			ld	c,h	; x
			
			ld	de,div3
			ld	h,0		;l = y
			add	hl,de
			ld	b,(hl)		; y / 3
			srl	c		; x / 2
			ld	(ix+2),c
			ld	(ix+3),b
			call	generic_console_vpeek
			ld	hl,textpixl
			ld	e,0
			ld	b,64		; whole symbol table size
.ckmap			cp	(hl)		; compare symbol with the one in map
			jr	z,chfound
			inc	hl
			inc	e
			djnz	ckmap
			ld	e,0
chfound:

			;Find the modulus of orig y /3
			ld	l,(ix+3)
			ld	a,(ix+1)
			sub	l
			sub	l
			sub	l
			ld	l,a
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
			ld	hl,textpixl
			ld	d,0
			ld	e,a
			add	hl,de
			ld	a,(hl)
			ld	c,(ix+2)
			ld	b,(ix+3)
			ld	e,0		;raw mode
			call	generic_console_printc
ENDIF
			pop	bc		;dump buffer
			pop	bc
			pop	bc		;restore callers
			pop	ix		;restore callers
			ret

