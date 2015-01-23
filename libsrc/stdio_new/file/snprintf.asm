; int snprintf(char *s, unsigned int size, const char *fmt,...)
; 05.2008 aralbrec

PUBLIC snprintf

EXTERN vsnprintf_callee, stdio_varg, stdio_nextarg
EXTERN ASMDISP_VSNPRINTF_CALLEE

.snprintf

   call stdio_varg
   push de                     ; stack = char *s

   call stdio_nextarg   
   push de                     ; stack = int size
   
   exx
   pop de
   pop hl
   exx
   
   call stdio_nextarg          ; de = char *fmt
   
   ld c,l
   ld b,h                      ; bc = top of parameter list
   
   jp vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE
