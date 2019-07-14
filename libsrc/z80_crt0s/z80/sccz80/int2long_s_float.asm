;       Small C+ Z88 Support Library
;
;       Convert signed int to long

                SECTION   code_crt0_sccz80
                PUBLIC    l_int2long_s_float
                EXTERN		float

; If MSB of h sets de to 255, if not sets de=0

.l_int2long_s_float
        ld      de,0
        bit     7,h
        jp		z,float
        dec     de
        jp		float
