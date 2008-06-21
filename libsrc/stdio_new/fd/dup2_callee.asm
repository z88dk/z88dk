; int __CALLEE__ dup2_callee(int fdsrc, int fddst)
; 06.2008 aralbrec

XLIB dup2_callee
XDEF ASMDISP_DUP2_CALLEE

LIB close, dup_common1, dup_common2
LIB stdio_error_ebadf_mc

INCLUDE "stdio.def"

.dup2_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

   ; 1. check fd numbers are valid
   ;
   ;  l = fd src
   ;  c = fd dst
   
   ld a,l
   cp MAXFILES
   jp nc, stdio_error_ebadf_mc

   ld a,c
   cp MAXFILES
   jp nc, stdio_error_ebadf_mc
   
   ; 2. check if the two fd numbers are equal
   ;
   ;  l = fd src
   ;  a = c = fd dst
   
   cp l                        ; if fddst == fdsrc, just return fdsrc
   ret z

   call dup_common1
   ret c
   
   ; 6. close fd dst if necessary
   ;
   ;  c = fd dst
   ; hl = dup fdstruct

   push bc
   push hl
   
   ld l,c
   call close

   pop de
   pop bc

   ;  c = fd dst
   ; de = dup fdstruct

   jp dup_common2

defc ASMDISP_DUP2_CALLEE = asmentry - dup2_callee
