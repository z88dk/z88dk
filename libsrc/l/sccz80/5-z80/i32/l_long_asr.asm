;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       aralbrec 01/2007
;       sped up some more

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_asr

EXTERN l_asr_dehl

l_long_asr:

   ; Shift primary (on stack) right by secondary, 

   ld a,l                      ; a = shift amount
   
   pop hl                      ; hl = return address
   pop de                      ; de = primary.LSW
   ex (sp),hl                  ; hl = primary.MSW
   
   ex de,hl
   jp l_asr_dehl
