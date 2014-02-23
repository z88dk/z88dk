
; int vfprintf(FILE *stream, const char *format, void *arg)

XDEF vfprintf

vfprintf:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   ex de,hl
   call asm_vfprintf
   
   pop ix
   ret

   INCLUDE "../../z80/asm_vfprintf.asm"
