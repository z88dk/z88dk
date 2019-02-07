;
;       Kaypro ('83 versions) pseudo graphics routines
;        Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;       Xor pixel at (x,y) coordinate.
;
;
;


        SECTION code_clib
        PUBLIC  xorpixel

        EXTERN  plot_end
        EXTERN  plot_decode

        EXTERN  GRAPHICS_CHAR_SET
        EXTERN  GRAPHICS_CHAR_UNSET
        EXTERN  __kayproii_gfxmode
        EXTERN  generic_console_printc
        EXTERN  generic_console_vpeek
        EXTERN  CONSOLE_ROWS
        EXTERN  CONSOLE_COLUMNS


.xorpixel
        ld      a,h
        cp      CONSOLE_COLUMNS
        ret     nc
        ld      a,(__kayproii_gfxmode)
        and     a
        jr      z,xor_one
        ; Plotting with funny characters
        ld      a,l
        cp      CONSOLE_ROWS * 2
        ret     nc
        push    bc
        call	plot_decode
        jr	c,odd
        xor	1
        jr	even
.odd
        xor	2
.even
        jp	plot_end

xor_one:
        ld      a,l
        cp      CONSOLE_ROWS
        ret     nc

        push    bc              ;save entry bc
        ld      c,h
        ld      b,l
	ld	e,1
	call	generic_console_vpeek
	ld	b,GRAPHICS_CHAR_SET
	cp	GRAPHICS_CHAR_UNSET
	jr	z,xor_done
	ld	b,GRAPHICS_CHAR_UNSET
xor_done:
	ld	(hl),b
	pop	bc	
	ret

	

