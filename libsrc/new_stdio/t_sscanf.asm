; int t_sscanf(char *s, const char *fmt,...)
; 05.2008 aralbrec

XLIB t_sscanf

LIB t_vsscanf_callee
XREF ASMDISP_VSSCANF_CALLEE

.t_sscanf

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
   
   jp t_vsscanf_callee + ASMDISP_VSSCANF_CALLEE

   