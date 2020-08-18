;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 22/3/99 Unsigned version
;
;       djm 7/5/99 Optimizer version, enter with dehl = long c=counter
;
;       aralbrec 01/2007 Sped up, would be better with a or b = counter

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_asr_uo

EXTERN l_lsr_dehl

l_long_asr_uo:

   ; dehl = long
   ;    c = shift amount
   
   ld a,c
   jp l_lsr_dehl
