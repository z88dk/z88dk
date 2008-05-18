; int t_snprintf(char *s, unsigned int size, const char *fmt,...)
; 05.2008 aralbrec

XLIB t_snprintf

LIB t_vsnprintf_callee
XREF ASMDISP_VSNPRINTF_CALLEE

.t_snprintf

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
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   
   exx
   pop de
   pop hl
   exx
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   
   ld c,l
   ld b,h
   
   jp t_vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE

   