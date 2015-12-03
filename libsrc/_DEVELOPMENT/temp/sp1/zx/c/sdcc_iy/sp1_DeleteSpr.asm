
; void __FASTCALL__ sp1_DeleteSpr(struct sp1_ss *s)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DeleteSpr

EXTERN asm_sp1_DeleteSpr

_sp1_DeleteSpr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_DeleteSpr
