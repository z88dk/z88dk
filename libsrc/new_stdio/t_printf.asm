; int t_printf(const char *fmt, ...)
; 05.2008 aralbrec

XLIB t_printf

LIB t_vfprintf_callee
XREF ASMDISP_VFPRINTF_CALLEE
XREF _tempoutput

.t_printf

   ld ix,_tempoutput

   add a,a
   inc a
   ld l,a
   ld h,0
   add hl,sp
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   
   ld c,l
   ld b,h
   
   jp t_vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
