; int t_scanf(const char *fmt, ...)
; 05.2008 aralbrec

XLIB t_scanf

LIB t_vfscanf_callee
XREF ASMDISP_VFSCANF_CALLEE
XREF _t_stdin

.t_scanf

   ld ix,_t_stdin

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
   
   jp t_vfscanf_callee + ASMDISP_VFSCANF_CALLEE
