
SECTION code_l_clang


PUBLIC __sshl
EXTERN l_lsl_hl

; hl << c
__sshl:
   push af
   ld   a,c
   call l_lsl_hl
   pop af
   ret

