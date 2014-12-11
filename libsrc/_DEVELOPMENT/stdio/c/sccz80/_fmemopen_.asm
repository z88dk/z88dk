
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

SECTION code_stdio

PUBLIC _fmemopen_

EXTERN asm__fmemopen

_fmemopen_:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   ld a,$0c
   jp asm__fmemopen
