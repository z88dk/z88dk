;       Small C+ Z88 Support Library
;
;       Increment long by 1
;
;       djm 21/2/99
;       Rewritten so that I know it works properly!

                SECTION   code_crt0_sccz80
                PUBLIC    l_inclong

.l_inclong

   inc l
   ret nz
   inc h
   ret nz
   inc de
   ret
   
;        inc     hl
;        ld      a,h
;        or      l
;        ret     nz
;        inc     de
;        ret


IF ARCHAIC

.l_inclong
        ld      bc,1
        add     hl,bc
        ret     nc
        inc     de
        ret
ENDIF
