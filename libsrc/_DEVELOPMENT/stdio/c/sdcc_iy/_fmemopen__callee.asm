
; FILE *_fmemopen__callee(void **bufp, size_t *sizep, const char *mode)

SECTION code_stdio

PUBLIC __fmemopen__callee, l0__fmemopen__callee

__fmemopen__callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

l0__fmemopen__callee:

   ld a,$0c
   
   INCLUDE "stdio/z80/asm__fmemopen.asm"
