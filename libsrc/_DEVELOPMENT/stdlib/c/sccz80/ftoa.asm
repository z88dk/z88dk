
; size_t ftoa(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_stdlib

PUBLIC ftoa

EXTERN asm_ftoa, dread1

ftoa:

   ld hl,8
   add hl,sp
   call dread1

   pop af
   pop bc
   pop de
   pop hl

   push hl
   push de
   push bc
   push af
   
   jp asm_ftoa
