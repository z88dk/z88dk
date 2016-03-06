;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       22/3/99 djm Rewritten to be shorter..


                SECTION   code_crt0_sccz80
                PUBLIC    l_asr

.l_asr
        ex      de,hl
.l_asr1
        dec     e
        ret     m
        sra h
        rr l
        jp      l_asr1





IF ARCHAIC
.l_asr
        ex de,hl
.l_asr1   
        dec   e
        ret   m
        ld a,h
        rla
        ld a,h
        rra
        ld h,a
        ld a,l
        rra
        ld l,a
        jr l_asr1
ENDIF
