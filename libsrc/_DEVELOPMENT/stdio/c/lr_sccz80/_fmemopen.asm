
; FILE *_fmemopen(void **bufp, size_t *sizep, const char *mode)

XLIB _fmemopen

LIB asm__fmemopen

_fmemopen:

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
