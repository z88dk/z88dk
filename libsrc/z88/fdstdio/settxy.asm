;Z88 Small C Library functions, linked using the z80 module assembler
;Small C Z88 converted by Dominic Morris <djm@jb.man.ac.uk>

                INCLUDE "stdio.def"

                PUBLIC    setxy   ;Set xy position in window


.setxy
        ld      hl,2
        add     hl,sp
        ld      a,1
        call_oz(os_out)
        ld      a,'3'
        call_oz(os_out)
        ld      a,'@'
        call_oz(os_out)
        ld      a,(hl)
        add     a,32
        call_oz(os_out)
        ld      hl,4    
        add     hl,sp
        ld      a,(hl)
        add     a,32
        call_oz(os_out)
        ret

