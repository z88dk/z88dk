
; int vsscanf(const char *s, const char *format, va_list arg)

XDEF _vsscanf

_vsscanf:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_vsscanf.asm"
