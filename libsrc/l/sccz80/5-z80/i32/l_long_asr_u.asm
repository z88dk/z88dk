;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;
;       aralbrec 01/2007
;       sped up some more
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 22/3/99 Unsigned version

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_asr_u

EXTERN l_lsr_dehl

l_long_asr_u:

   ; Shift primary (on stack) right by secondary, 

   ld a,l                      ; a = shift amount
   
   pop hl                      ; hl = return address
   pop de                      ; de = primary.LSW
   ex (sp),hl                  ; hl = primary.MSW
   
   ex de,hl
   jp l_lsr_dehl
