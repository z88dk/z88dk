; int __CALLEE__ t_vsprintf_callee(char *s, const char *fmt, void *arg_ptr)
; 05.2008 aralbrec

XLIB t_vsprintf_callee
XDEF ASMDISP_VSPRINTF_CALLEE

LIB t_vfprintf_callee
XREF LIBDISP_VFPRINTF_CALLEE

.t_vsprintf_callee

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
   call t_vfprintf_callee + LIBDISP_VFPRINTF_CALLEE
   
   exx
   ld (hl),0                   ; terminate string with '\0'
   exx
   ret                         ; ret with hl = # chars written to string

   defw 0                      ; really aggravating hack: stdio_outchar wants to res 0,(ix-2)

.sprintf_outchar

   ; called by vfprintf()
   ; when called the secondary register set is active
   ;
   ; enter :  a = char to write to string
   ;         hl = char *s
   ; exit  : no carry to indicate no error
   
   ld (hl),a
   inc hl
   or a
   ret

defc ASMDISP_VSPRINTF_CALLEE = asmentry - t_vsprintf_callee
