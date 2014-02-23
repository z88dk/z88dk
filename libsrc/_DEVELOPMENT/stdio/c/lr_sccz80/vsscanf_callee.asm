
; int vsscanf(const char *s, const char *format, va_list arg)

XDEF vsscanf_callee

vsscanf_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_vsscanf.asm"
