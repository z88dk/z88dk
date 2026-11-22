;       Z88 Small C+ Run Time Library 
;       Long functions
;
;       djm 21/2/99
;       The old routine is fubarred! Written a new one now..but
;       I'm mystified!

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_sub

l_long_sub:

   ; compute A - B
   ;
   ; dehl  = B
   ; stack = A, ret

   pop ix
   
   ld c,l
   ld b,h                      ; bc = B.LSW
   pop hl                      ; hl = A.LSW
   
   or a
   sbc hl,bc
   ex de,hl                    ; de = result.LSW
   
   ld c,l
   ld b,h                      ; bc = B.MSW
   pop hl                      ; hl = A.MSW
   
   sbc hl,bc
   ex de,hl                    ; dehl = A - B
   
   jp (ix)

