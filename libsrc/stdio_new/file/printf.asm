; int printf(const char *fmt, ...)
; 05.2008 aralbrec

PUBLIC printf

EXTERN vfprintf_callee, stdio_varg
EXTERN ASMDISP_VFPRINTF_CALLEE
EXTERN _stdout

.printf

   call stdio_varg             ; de = char *fmt
   
   ld c,l
   ld b,h                      ; bc = top of parameter list

   ld ix,(_stdout)

   jp vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
