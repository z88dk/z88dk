
; size_t dtog(double x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC dtog

EXTERN asm_dtog, dload

dtog:

   ld hl,8
   add hl,sp
   call dload

   pop af
   pop bc
   pop de
   pop hl

   push hl
   push de
   push bc
   push af
   
   jp asm_dtog
