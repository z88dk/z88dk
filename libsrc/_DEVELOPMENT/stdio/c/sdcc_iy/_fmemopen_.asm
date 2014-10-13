
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

SECTION seg_code_stdio

PUBLIC __fmemopen_

__fmemopen_:

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
