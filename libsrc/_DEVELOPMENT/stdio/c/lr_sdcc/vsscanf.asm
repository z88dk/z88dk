
; int vsscanf(const char *s, const char *format, va_list arg)

XDEF vsscanf

vsscanf:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push ix
   
   call asm_vsscanf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vsscanf.asm"
