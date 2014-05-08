
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

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
   
   push ix
   
   call asm__fmemopen
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm__fmemopen.asm"
