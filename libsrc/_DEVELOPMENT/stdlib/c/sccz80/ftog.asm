
; size_t ftog(float x, char *buf, uint16_t prec, uint16_t flag)

SECTION code_stdlib

PUBLIC ftog

EXTERN asm_ftog, dread1

ftog:

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
   
   jp asm_ftog
