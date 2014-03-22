
; FILE *_fmemopen(void **bufp, size_t *sizep, const char *mode)

XDEF _fmemopen

_fmemopen:

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
   
   INCLUDE "../../z80/asm__fmemopen.asm"
