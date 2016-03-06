;       Small C+ Z88 Support Library
;
;       Decrement long by 1
;
;       djm 21/2/99
;       Rewritten so that I know it works

                SECTION   code_crt0_sccz80
                PUBLIC    l_declong

.l_declong
        ld      a,h
        or      l
        dec     hl
        ret     nz
        dec     de
        ret



IF ARCHAIC

.l_declong
        ld      bc,-1
        add     hl,bc
        ret     nc
        dec     de
        ret
ENDIF
