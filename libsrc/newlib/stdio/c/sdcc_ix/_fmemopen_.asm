
; FILE *_fmemopen_(void **bufp, size_t *sizep, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC __fmemopen_

EXTERN l0__fmemopen__callee

__fmemopen_:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af

   jp l0__fmemopen__callee
