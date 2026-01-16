
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fmemopen__callee, l0_fmemopen__callee

EXTERN asm__fmemopen

_fmemopen__callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

l0_fmemopen__callee:

   ld a,$0c                    ; only disallow undefined bits in mode
   
   jp asm__fmemopen
