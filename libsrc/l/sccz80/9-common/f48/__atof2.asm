        
SECTION code_clib
SECTION code_l_sccz80

PUBLIC    __atof2
EXTERN	  atof

__atof2:
        push    hl
        call    atof
        pop     bc
        ret
