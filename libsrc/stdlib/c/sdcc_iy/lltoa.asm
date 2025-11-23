
; char *lltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _lltoa

EXTERN asm_lltoa

_lltoa:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   pop ix
   exx
   pop bc
   
   push bc
   push hl
   push de
   push hl
   push de
   push hl
   push af
   
   jp asm_lltoa
