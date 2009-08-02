; int printf(const char *fmt, ...)
; 05.2008 aralbrec

XLIB printf

LIB vfprintf_callee, stdio_varg
XREF ASMDISP_VFPRINTF_CALLEE
XREF _stdout

.printf

   call stdio_varg             ; de = char *fmt
   
   ld c,l
   ld b,h                      ; bc = top of parameter list

   ld ix,(_stdout)

   jp vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
