
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fmemopen_

EXTERN l0_fmemopen__callee

_fmemopen_:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp l0_fmemopen__callee
