
        SECTION	code_graphics
        PUBLIC  generic_console_scrollup

        EXTERN  swapgfxbk
        EXTERN  swapgfxbk1
        EXTERN  clsgraph


        EXTERN	CONSOLE_ROWS
        EXTERN	CONSOLE_COLUMNS

        defc    DISPLAY = 0xF800
        defc    pagein = swapgfxbk
        defc    pageout = swapgfxbk1


generic_console_scrollup:
        push    de
        push    bc
        call    pagein
        ld      hl, DISPLAY + 80
        ld      de, DISPLAY
        ld      bc,+ ((80) * (CONSOLE_ROWS-1))
        ldir
        ex      de,hl
        ld      b,CONSOLE_COLUMNS
generic_console_scrollup_3:
        ld      (hl),32
        inc     hl
        djnz    generic_console_scrollup_3
        call    pageout
        pop     bc
        pop     de
        ret
