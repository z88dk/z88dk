
; char *itoa(int num, char *buf, int radix)

SECTION seg_code_stdlib

PUBLIC itoa

EXTERN asm_itoa

itoa:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_itoa
