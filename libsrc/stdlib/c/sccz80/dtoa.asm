
; size_t dtoa(double x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_clib
SECTION code_stdlib

PUBLIC dtoa

EXTERN asm_dtoa, dload

dtoa:

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
   
   jp asm_dtoa
