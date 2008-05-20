; int t_asprintf(char **s, const char *fmt,...)
; 05.2008 aralbrec

XLIB t_asprintf

LIB t_vasprintf_callee
XREF ASMDISP_VASPRINTF_CALLEE

.t_asprintf

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
   
   ld c,l
   ld b,h
   
   exx
   pop hl
   ld de,0
   exx
      
   jp t_vasprintf_callee + ASMDISP_VASPRINTF_CALLEE
