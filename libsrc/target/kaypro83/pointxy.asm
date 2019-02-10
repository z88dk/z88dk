;
;       Kaypro ('83 versions) pseudo graphics routines
;        Version for the standard text symbols
;


        SECTION code_graphics
        PUBLIC  pointxy

        EXTERN  plot_decode
        EXTERN  GRAPHICS_CHAR_UNSET
        EXTERN  __kayproii_gfxmode
	EXTERN	generic_console_vpeek
        EXTERN  CONSOLE_ROWS
        EXTERN  CONSOLE_COLUMNS

.pointxy
        ld      a,h
        cp      CONSOLE_COLUMNS
        ret     nc
        ld      a,(__kayproii_gfxmode)
        and     a
        jr      z,point_one
        ; Plotting with funny characters
        ld      a,l
        cp      CONSOLE_ROWS * 2
        ret     nc

        push    bc
        push    de
        push    hl
        call plot_decode
        jr	c,odd
        and	1
        jr	even
.odd
        and	2
.even
        pop     hl
        pop     de
        pop     bc
        ret

point_one:
        ld      a,l
        cp      CONSOLE_ROWS 
        ret     nc
        push    bc              ;save entry bc
	ld	c,h
	ld	b,l
	ld	e,1		;raw mode
	call	generic_console_vpeek
        cp      GRAPHICS_CHAR_UNSET
	pop	bc
	ret

