;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>

                INCLUDE "stdio.def"

                XLIB    fdputs    ;Print string
                LIB     putconsole


.fdputs
        pop     de      ;return address
        pop     hl      ;address of string..
        push    hl
        push    de
        ld      a,1
        jp      putconsole

