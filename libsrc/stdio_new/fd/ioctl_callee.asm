; int __CALLEE__ ioctl_callee(int fd, int request, int arg)
; 06.2008 aralbrec

XLIB ioctl_callee
XDEF ASMDISP_IOCTL_CALLEE

LIB stdio_error_mc
LIB l_jpix, fd_common1

INCLUDE "stdio.def"

.ioctl_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : bc = int arg
   ;         de = int request
   ;          l = int fd
   ; exit  : hl = return value, carry reset if success
   ;         hl = -1, carry set if fail

   call fd_common1             ; ix = fdstruct
   ret c
   
   ld l,c
   ld h,b                      ; hl = arg
   ld c,STDIO_MSG_ICTL
   call l_jpix
   
   ret nc
   jp stdio_error_mc
   
defc ASMDISP_IOCTL_CALLEE = asmentry - ioctl_callee
