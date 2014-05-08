
; int vsscanf(const char *s, const char *format, va_list arg)

PUBLIC vsscanf_callee

vsscanf_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_vsscanf.asm"
