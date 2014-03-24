
; FILE *_fmemopen(void **bufp, size_t *sizep, const char *mode)

XDEF _fmemopen_callee

_fmemopen_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   ld a,$0c                    ; only disallow undefined bits in mode
   
   INCLUDE "stdio/z80/asm__fmemopen.asm"
