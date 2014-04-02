
; FILE *_fmemopen(void **bufp, size_t *sizep, const char *mode)

XDEF __fmemopen

__fmemopen:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   ld a,$0c
   
   INCLUDE "stdio/z80/asm__fmemopen.asm"
