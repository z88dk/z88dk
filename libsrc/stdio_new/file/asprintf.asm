; int asprintf(char **s, const char *fmt, ...)
; 05.2008 aralbrec

PUBLIC asprintf

EXTERN vasprintf_callee, stdio_varg, stdio_nextarg
EXTERN ASMDISP_VASPRINTF_CALLEE

.asprintf

   call stdio_varg
   push de                     ; stack = char **s
   
   call stdio_nextarg          ; de = char *fmt
   
   ld c,l
   ld b,h                      ; bc = top of parameter list
   
   exx
   pop hl                      ; char **s
   ld de,0
   exx
   
   jp vasprintf_callee + ASMDISP_VASPRINTF_CALLEE
