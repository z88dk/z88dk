; int sprintf(char *s, const char *fmt,...)
; 05.2008 aralbrec

PUBLIC sprintf

EXTERN vsprintf_callee, stdio_varg, stdio_nextarg
EXTERN ASMDISP_VSPRINTF_CALLEE

.sprintf

   call stdio_varg
   push de
   exx
   pop hl                      ; hl = char *s
   exx
   
   call stdio_nextarg          ; de = char *fmt
   
   ld c,l
   ld b,h                      ; bc = top of parameter stack
   
   jp vsprintf_callee + ASMDISP_VSPRINTF_CALLEE
