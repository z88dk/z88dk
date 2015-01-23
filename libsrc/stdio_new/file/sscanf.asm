; int sscanf(char *s, const char *fmt,...)
; 05.2008 aralbrec

PUBLIC sscanf

EXTERN vsscanf_callee, stdio_varg, stdio_nextarg
EXTERN ASMDISP_VSSCANF_CALLEE

.sscanf

   call stdio_varg
   push de
   exx
   pop hl                      ; hl = char *s
   exx
   
   call stdio_nextarg          ; de = char *fmt
   
   ld c,l
   ld b,h                      ; bc = top of parameter list
   
   jp vsscanf_callee + ASMDISP_VSSCANF_CALLEE
