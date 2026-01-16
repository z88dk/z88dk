;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 7/6/99
;       The optimizer version! Entered with long in dehl and counter in c
;
;       aralbrec 01/2007
;       Sped up, would be better with counter in a or b

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_asro

EXTERN l_asr_dehl

l_long_asro:

   ; dehl = primary
   ;    c = shift amount
   
   ld a,c
   jp l_asr_dehl
