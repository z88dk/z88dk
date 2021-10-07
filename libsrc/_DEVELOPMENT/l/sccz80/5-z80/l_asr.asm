;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       22/3/99 djm Rewritten to be shorter..


SECTION code_clib
SECTION code_l_sccz80
PUBLIC    l_asr
PUBLIC	  l_asr_hl_by_e

.l_asr
        ex      de,hl
.l_asr_hl_by_e
.l_asr1
        dec     e
        ret     m
        sra h
        rr l
        jp      l_asr1
