
; int vfprintf(FILE *stream, const char *format, void *arg)

XDEF vfprintf

vfprintf:
   
   pop af
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push bc
   push af

   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_vfprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_vfprintf.asm"
