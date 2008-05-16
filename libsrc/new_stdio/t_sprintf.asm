; int t_sprintf(char *s, const char *fmt,...)
; 05.2008 aralbrec

XLIB t_sprintf

LIB t_vsprintf_callee
XREF ASMDISP_VSPRINTF_CALLEE

.t_sprintf

   add a,a
   inc a
   ld l,a
   ld h,0
   add hl,sp
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   exx
   pop hl
   exx
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   
   ld c,l
   ld b,h
   
   jp t_vsprintf_callee + ASMDISP_VSPRINTF_CALLEE

   