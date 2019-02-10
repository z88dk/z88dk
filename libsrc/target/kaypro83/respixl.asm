;
;       Kaypro ('83 versions) pseudo graphics routines
;        Version for the standard text symbols
;
;       Stefano Bodrato 2018
;
;
;       Reset pixel at (x,y) coordinate.
;
;
;


        SECTION code_graphics
        PUBLIC  respixel

        EXTERN  plot_end
        EXTERN  plot_decode
	EXTERN	generic_console_printc
        EXTERN  GRAPHICS_CHAR_UNSET
        EXTERN  __kayproii_gfxmode
        EXTERN  CONSOLE_ROWS
        EXTERN  CONSOLE_COLUMNS

.respixel
        ld      a,h
        cp      CONSOLE_COLUMNS
        ret     nc
        ld      a,(__kayproii_gfxmode)
        and     a
        jr      z,res_one
        ; Plotting with funny characters
        ld      a,l
        cp      CONSOLE_ROWS * 2
        ret     nc
        push    bc
        call    plot_decode
        jr      c,odd
        and     $FE
        jr      even
.odd
        and     $FD
.even
        jp      plot_end



res_one:
        ld      a,l
        cp      CONSOLE_ROWS
        ret     nc

        push    bc              ;save entry bc
        ld      c,h
        ld      b,l
        ld      a,GRAPHICS_CHAR_UNSET
        ld      d,a
        ld      e,1             ;raw mode
        call    generic_console_printc
        pop     bc
        ret
