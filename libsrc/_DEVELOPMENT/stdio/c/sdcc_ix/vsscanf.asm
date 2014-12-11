
; int vsscanf(const char *s, const char *format, va_list arg)

SECTION code_stdio

PUBLIC _vsscanf

_vsscanf:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push ix
   
   call asm_vsscanf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vsscanf.asm"
