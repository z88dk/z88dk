;
;       Small C+ Generic Math Library
;
;       Set the floating point seed
;
;
                XLIB    fpseed
                XREF    dstore
                XREF    fp_seed


.fpseed
        ld      hl,fp_seed
        jp      dstore
