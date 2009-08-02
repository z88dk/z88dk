; int scanf(const char *fmt, ...)
; 05.2008 aralbrec

XLIB scanf

LIB vfscanf_callee, stdio_varg
XREF ASMDISP_VFSCANF_CALLEE
XREF _stdin

.scanf

   call stdio_varg             ; de = char *fmt

   ld c,l
   ld b,h                      ; bc = top of parameter list
   
   ld ix,(_stdin)
   
   jp vfscanf_callee + ASMDISP_VFSCANF_CALLEE
