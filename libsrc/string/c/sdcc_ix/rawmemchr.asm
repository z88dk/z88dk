
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_clib
SECTION code_string

PUBLIC _rawmemchr

EXTERN l0_rawmemchr_callee

_rawmemchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_rawmemchr_callee
