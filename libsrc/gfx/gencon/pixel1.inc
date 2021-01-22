
	INCLUDE	"graphics/grafix.inc"


	EXTERN	generic_console_printc
	EXTERN	generic_console_plotc
	EXTERN	generic_console_vpeek
	EXTERN	generic_console_pointxy
	EXTERN	textpixl
	EXTERN	__console_w
	EXTERN	__console_h
	EXTERN	__gfx_coords
	EXTERN	GRAPHICS_CHAR_SET
	EXTERN	GRAPHICS_CHAR_UNSET

		ld	a,(__console_w)
		dec	a
		cp	h
		ret	c

		ld	a,(__console_h)
		dec	a
		cp	l
		ret	c

IF __CPU_GBZ80__
		ld	a,l
		ld	(__gfx_coords),a
		ld	a,h
		ld	(__gfx_coords+1),a
ELSE
		ld	(__gfx_coords),hl
ENDIF
		push	bc		;save entry bc	
		ld	c,h
		ld	b,l
		push	bc
IF USEplotc
		call	generic_console_pointxy
ELSE
		ld	e,1		;raw mode
		call	generic_console_vpeek
ENDIF

IF NEEDplot
		ld	a,GRAPHICS_CHAR_SET
ENDIF
IF NEEDunplot
		ld	a,GRAPHICS_CHAR_UNSET
ENDIF
IF NEEDxor
		ld	b,GRAPHICS_CHAR_SET
		cp	GRAPHICS_CHAR_UNSET
		jr	z,xor_done
		ld	b,GRAPHICS_CHAR_UNSET
xor_done:	ld	a,b
ENDIF
IF NEEDpoint
		cp	GRAPHICS_CHAR_UNSET
		pop	bc
ELSE
		pop	bc		;original coordinates
  IF USEplotc
		ld	d,a
                ld      e,0             ;pixel4 mode
                call    generic_console_plotc
  ELSE
		ld	d,a
		ld	e,1		;raw mode
		call	generic_console_printc
  ENDIF
ENDIF
		pop	bc
		ret
