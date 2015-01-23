; int __CALLEE__ vsscanf_callee(const char *s, const char *format, void *arg_ptr)
; 05.2008 aralbrec

PUBLIC vsscanf_callee
PUBLIC ASMDISP_VSSCANF_CALLEE

EXTERN vfscanf_callee
EXTERN LIBDISP_VFSCANF_CALLEE

.vsscanf_callee

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
   
   ld hl,$0404        ; construct a truncated FILE struct on the stack
   push hl
   ld hl,sscanf_getchar
   push hl
   ld hl,$c3c3
   push hl
   
   ld ix,1
   add ix,sp

   ; enter : ix  = pseudo FILE *
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of conversions done
   ;         if stream unreadable carry set and hl=-1

   call vfscanf_callee + LIBDISP_VFSCANF_CALLEE
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

defc ASMDISP_VSSCANF_CALLEE = # asmentry - vsscanf_callee
