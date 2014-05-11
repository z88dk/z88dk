
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

PUBLIC _fmemopen__callee

_fmemopen__callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld a,$0c                    ; only disallow undefined bits in mode
   
   INCLUDE "stdio/z80/asm__fmemopen.asm"
