; int __CALLEE__ t_vsscanf_callee(const char *s, const char *format, void *arg_ptr)
; 05.2008 aralbrec

XLIB t_vsscanf_callee
XDEF ASMDISP_VSSCANF_CALLEE

LIB t_vfscanf_callee
XREF LIBDISP_VFSCANF_CALLEE

.t_vsscanf_callee

   pop hl
   pop bc
   pop de
   exx
   pop hl
   exx
   push hl

.asmentry

   ; enter : hl' = char *s
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of conversions done
   ;         if string empty carry set and hl=-1
   
   ld hl,sscanf_getchar        ; construct a truncated FILE* on the stack
   push hl
   ld hl,195*256
   push hl
   ld hl,$0202
   push hl
   
   ld ix,3
   add ix,sp

   ; enter : ix  = & attached file / device getchar function
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of conversions done
   ;         if stream unreadable carry set and hl=-1

   call t_vfscanf_callee + LIBDISP_VFSCANF_CALLEE
   pop de
   pop de
   pop de
   ret

.sscanf_getchar

   ; called by vfscanf()
   ; when called the secondary register set is active
   ;
   ; enter : hl = char *s
   ; exit  :  a = next char from string
   ;         carry set if end of string
   
   ld a,(hl)
   or a
   scf
   ret z
   
   inc hl
   ccf
   ret

