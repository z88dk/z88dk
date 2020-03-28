;       Small C+ Z88 Support Library
;
;       Convert signed int to long

                SECTION   code_crt0_sccz80
                PUBLIC    l_int2long_s_float
                EXTERN		float

; If MSB of h sets de to 255, if not sets de=0

.l_int2long_s_float
        ld      de,0
IF __CPU_INTEL__
        ld      a,h
        rla
        jp      nc,float
ELSE
        bit     7,h
        jp		z,float
ENDIF
        dec     de
        jp		float
