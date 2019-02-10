;
;       Kaypro ('83 versions) pseudo graphics routines
;	Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;       Plot pixel at (x,y) coordinate.
;
;
;	$Id: plotpixl_83.asm $
;


	SECTION code_graphics
	PUBLIC	plotpixel

	EXTERN	plot_end
	EXTERN	plot_decode
        EXTERN  GRAPHICS_CHAR_SET
        EXTERN  __kayproii_gfxmode
	EXTERN	generic_console_printc
        EXTERN  CONSOLE_ROWS
        EXTERN  CONSOLE_COLUMNS

.plotpixel
        ld      a,h
        cp      CONSOLE_COLUMNS
        ret     nc
        ld      a,(__kayproii_gfxmode)
        and     a
        jr      z,plot_one
        ; Plotting with funny characters
        ld      a,l
        cp      CONSOLE_ROWS * 2
        ret     nc
        push    bc
        call    plot_decode
        jr      c,odd
        or      1
        jr      even
odd:
        or      2
even:
        jp      plot_end

plot_one:
        ld      a,l
        cp      CONSOLE_ROWS
        ret     nc

        push    bc              ;save entry bc
        ld      c,h
        ld      b,l
        ld      a,GRAPHICS_CHAR_SET
        ld      d,a
        ld      e,1             ;raw mode
        call    generic_console_printc
        pop     bc
        ret
