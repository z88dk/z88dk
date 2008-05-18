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
   pop de
   pop hl
   exx
   push hl

.asmentry

   ; enter : de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ;         hl' = char *s
   ;         de' = max size (including '\0')
   ; exit  : hl  = number of chars output to stream

   exx
   ld a,d                      ; reduce buffer size by 1 if possible for the '\0' char
   or e
   jr z, nobuffer
   dec de

   call nobuffer               ; there is a non-empty destination buffer
   exx
   ld (hl),a                   ; which means we need to add a terminating '\0'
   exx
   ret

.nobuffer

   exx

   ld ix,snprintf_outchar       ; address of 'stream' output function
   call t_vfprintf_callee + LIBDISP_VFPRINTF_CALLEE
   ret

.snprintf_outchar

   ; called by vfprintf()
   ; when called the secondary register set is active
   ;
   ; enter :  a = char to write to string
   ;         hl = char *s
   ;         de = space remaining in buffer
   ; exit  : no carry to indicate no error

   ld c,a

   ld a,d                      ; if there's no space left in buffer
   or e
   ret z                       ; return without advancing buffer ptr (to find out how many chars are actually printed)
   dec de
   
   ld (hl),c
   inc hl
   ret

defc ASMDISP_VSNPRINTF_CALLEE = asmentry - t_vsnprintf_callee
