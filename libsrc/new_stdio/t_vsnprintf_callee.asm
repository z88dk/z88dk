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

   exx
   ld a,h                      ; reduce buffer size by 1 if possible for the '\0' char
   or l
   jr z, dontadj
   dec hl

.dontadj

   exx

   ld ix,snprintf_outchar       ; address of 'stream' output function
   call t_vfprintf_callee + LIBDISP_VFPRINTF_CALLEE
   
   exx
   xor a
   ld (de),a                   ; terminate string with '\0'
   push bc
   exx
   pop hl                      ; hl = # chars written to string
   ret

.snprintf_outchar

   ; called by vfprintf()
   ; when called the secondary register set is active
   ;
   ; enter :  a = char to write to string
   ;         de = char *s
   ;         hl = space remaining in buffer
   ; exit  : no carry to indicate no error
   ;         carry if string buffer full

   ld (de),a

   ld a,h                      ; if there's no space left in buffer
   or l                        ; (buffer write above goes into '\0' slot)
   scf
   ret z                       ; return indicating error
   dec hl
   
   inc de
   ccf
   ret

defc ASMDISP_VSNPRINTF_CALLEE = asmentry - t_vsnprintf_callee
