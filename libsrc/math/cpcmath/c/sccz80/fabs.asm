;
;	CPC Maths Routines
;

        SECTION code_fp
        PUBLIC  fabs

        EXTERN  fa

fabs:
        ld      hl, fa+4
        res     7, (hl)
        ret
