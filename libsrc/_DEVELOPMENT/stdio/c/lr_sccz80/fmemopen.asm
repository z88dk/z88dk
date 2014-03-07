
; FILE *fmemopen(void *buf, size_t size, const char *mode)

XLIB fmemopen

LIB asm_fmemopen

fmemopen:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_fmemopen
