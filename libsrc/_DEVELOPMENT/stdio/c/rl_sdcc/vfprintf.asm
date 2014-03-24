
; int vfprintf(FILE *stream, const char *format, void *arg)

XDEF vfprintf

vfprintf:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_vfprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_vfprintf.asm"
