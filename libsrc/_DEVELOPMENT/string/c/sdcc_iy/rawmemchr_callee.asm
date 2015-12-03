
; BSD
; void *rawmemchr_callee(const void *mem, int c)

SECTION code_clib
SECTION code_string

PUBLIC _rawmemchr_callee, l0_rawmemchr_callee

EXTERN asm_rawmemchr

_rawmemchr_callee:

   pop af
   pop hl
   pop bc
   push af

l0_rawmemchr_callee:

   ld a,c
   
   jp asm_rawmemchr
