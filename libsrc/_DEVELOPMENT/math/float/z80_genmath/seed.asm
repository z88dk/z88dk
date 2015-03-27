;
;       Small C+ Generic Math Library
;
;       Set the floating point seed
;
;
                PUBLIC    fpseed
                EXTERN    dstore
                EXTERN    fp_seed


.fpseed
        ld      hl,fp_seed
        jp      dstore
