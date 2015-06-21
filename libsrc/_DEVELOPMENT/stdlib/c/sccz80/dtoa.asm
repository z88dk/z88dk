
; size_t dtoa(double x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_stdlib

PUBLIC dtoa

EXTERN asm_dtoa, dread1b

dtoa:

   ld hl,13
   add hl,sp
   call dread1b

   pop af
   pop bc
   pop de
   pop hl

   push hl
   push de
   push bc
   push af
   
   jp asm_dtoa
