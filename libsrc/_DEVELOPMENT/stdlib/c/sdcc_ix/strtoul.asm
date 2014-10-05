
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

SECTION seg_code_stdlib

PUBLIC _strtoul

_strtoul:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push ix
   
   call asm_strtoul
   
   pop ix
   ret

   INCLUDE "stdlib/z80/asm_strtoul.asm"
