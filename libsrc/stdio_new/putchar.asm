; int __FASTCALL__ putchar(int c)
; 06.2008 aralbrec

XLIB putchar
LIB fputc_callee
XREF ASMDISP_FPUTC_CALLEE, _stdout

.putchar

   ld ix,(_stdout)
   jp fputc_callee + ASMDISP_FPUTC_CALLEE
