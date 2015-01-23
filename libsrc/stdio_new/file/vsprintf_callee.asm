; int __CALLEE__ vsprintf_callee(char *s, const char *fmt, void *arg_ptr)
; 05.2008 aralbrec

PUBLIC vsprintf_callee
PUBLIC ASMDISP_VSPRINTF_CALLEE

EXTERN vfprintf_callee
EXTERN LIBDISP_VFPRINTF_CALLEE

.vsprintf_callee

   pop hl
   pop bc
   pop de
   exx
   pop hl
   exx
   push hl

.asmentry

   ; enter : de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ;         hl' = char *s
   ; exit  : hl  = number of chars output to string not including \0

   ld ix,sprintf_outchar       ; address of 'stream' output function
   call vfprintf_callee + LIBDISP_VFPRINTF_CALLEE
   
   exx
   ld (hl),0                   ; terminate string with '\0'
   exx
   ret                         ; ret with hl = # chars written to string

.sprintf_outchar

   ; called by vfprintf()
   ; when called the secondary register set is active
   ;
   ; enter :  c = char to write to string
   ;         hl = char *s
   ; exit  : no carry to indicate no error
   
   ld (hl),c
   inc hl
   or a
   ret

defc ASMDISP_VSPRINTF_CALLEE = # asmentry - vsprintf_callee
