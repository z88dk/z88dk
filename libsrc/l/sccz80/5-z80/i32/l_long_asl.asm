;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)
;
;       aralbrec 01/2007
;       shifts are faster than doubling and ex with de/hl

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_asl

EXTERN l_lsl_dehl

l_long_asl:

   ; Shift primary left by secondary
   ;
   ; Primary is on the stack, and is 32 bits long therefore we need only
   ; concern ourselves with l (secondary) as our counter

   ld a,l                      ; a = shift amount
   
   pop hl                      ; hl = return address
   pop de                      ; de = primary.LSW
   ex (sp),hl                  ; hl = primary.MSW
   
   ex de,hl                    ; dehl = primary
   jp l_lsl_dehl
