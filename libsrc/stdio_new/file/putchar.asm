; int __FASTCALL__ putchar(int c)
; 06.2008 aralbrec

PUBLIC putchar
EXTERN fputc_callee
EXTERN ASMDISP_FPUTC_CALLEE, _stdout

.putchar

   ld ix,(_stdout)
   jp fputc_callee + ASMDISP_FPUTC_CALLEE
