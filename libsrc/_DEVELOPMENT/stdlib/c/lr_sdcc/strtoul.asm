
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

XDEF strtoul

strtoul:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   push ix

   call asm_strtoul

   pop ix
   ret

   INCLUDE "stdlib/z80/asm_strtoul.asm"
