
; char *ulltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ulltoa

EXTERN asm_ulltoa

_ulltoa:

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

   jp asm_ulltoa
