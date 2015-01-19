;
;       Small C+ Z88 Internal Routine
;       Puts a string to the console - mapping \n to \n\l as we
;       go and appending \n\l to the end of the line
;
;       Called by puts and fputs - near routine!!
;
;       djm 2/4/99

                INCLUDE "stdio.def"

                PUBLIC    putconsole

;Entry: hl=string, a print nl at end or not (0=no)

.putconsole
        push    af
.putconsole0
        ld      a,(hl)
        and     a
        jr      z,putconsole_out
        push    hl
        cp      13
        jr      z,putconsole_nl
        call_oz(os_out)
.putconsole_lp
        pop     hl
        inc     hl
        jr      putconsole0
.putconsole_out
        pop     af
        and     a
        ret     z 
        call_oz(gn_nln)
        ret
.putconsole_nl
        call_oz(gn_nln)
        jr      putconsole_lp
                
