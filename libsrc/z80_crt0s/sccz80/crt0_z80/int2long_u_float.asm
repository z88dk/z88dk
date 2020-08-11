;       Small C+ Z88 Support Library
;
;       Convert signed int to long

                SECTION   code_crt0_sccz80
                PUBLIC    l_int2long_u_float
                EXTERN	  float

.l_int2long_u_float
        ld      de,0
        jp		float
