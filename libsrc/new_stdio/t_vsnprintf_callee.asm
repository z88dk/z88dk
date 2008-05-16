; int __CALLEE__ t_vsnprintf_callee(char *s, unsigned int size, const char *fmt, void *arg_ptr)
; 05.2008 aralbrec

XLIB t_vsnprintf_callee
XDEF ASMDISP_VSNPRINTF_CALLEE

LIB t_vfprintf_callee
XREF LIBDISP_VFPRINTF_CALLEE

.t_vsnprintf_callee

   pop hl
   pop bc
   pop de
   exx
   pop hl
   pop de
   exx
   push hl

.asmentry

   ; enter : de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ;         de' = char *s
   ;         hl' = max size (including '\0')
   ; exit  : hl  = number of chars output to stream

   ld ix,snprintf_outchar       ; address of 'stream' output function
   call t_vfprintf_callee + LIBDISP_VFPRINTF_CALLEE
   
   exx
   xor a
   ld (de),0                   ; terminate string with '\0'
   exx
   ret                         ; ret with hl = # chars written to string

.snprintf_outchar

   ; called by vfprintf()
   ; when called the secondary register set is active
   ;
   ; enter :  a = char to write to string
   ;         de = char *s
   ;         hl = size
   ;         bc = number of chars written so far
   ; exit  : no carry to indicate no error
   ;         carry if string buffer full

   inc bc                      ; increment char count to accommodate '\0'
   
   push hl
   scf
   sbc hl,bc                   ; if buf.size < num.out + 2
   pop hl
   ret c                       ; then there is no more room in buff so return with error
   
   ld (de),a
   inc de
   ret
