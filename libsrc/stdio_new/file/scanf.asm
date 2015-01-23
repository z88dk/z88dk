; int scanf(const char *fmt, ...)
; 05.2008 aralbrec

PUBLIC scanf

EXTERN vfscanf_callee, stdio_varg
EXTERN ASMDISP_VFSCANF_CALLEE
EXTERN _stdin

.scanf

   call stdio_varg             ; de = char *fmt

   ld c,l
   ld b,h                      ; bc = top of parameter list
   
   ld ix,(_stdin)
   
   jp vfscanf_callee + ASMDISP_VFSCANF_CALLEE
