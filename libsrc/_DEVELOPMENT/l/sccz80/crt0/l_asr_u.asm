;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       22/3/99 djm Rewritten to be shorter.. unsigned version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_asr_u

EXTERN l_lsr_hl

l_asr_u:

   ld a,l
   ex de,hl
   
   jp l_lsr_hl
