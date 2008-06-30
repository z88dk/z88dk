; int __CALLEE__ pollfd_callee(int fd, char event)
; 06.2008 aralbrec

XLIB pollfd_callee
XDEF ASMDISP_POLLFD_CALLEE

LIB l_jpix, stdio_error_eacces_mc

INCLUDE "stdio.def"

.pollfd_callee

   pop hl
   pop bc
   ex (sp),hl
   ld b,c

.asmentry

   ; enter : l = fd
   ;         b = event (see poll_callee.asm)
   ; exit  : hl = revent, carry reset for success
   ;         hl = -1, carry set for fail
   
   call fd_common1             ; ix = fdstruct
   ret c
   
   ld c,STDIO_MSG_POLL
   call l_jpix
   jp c, stdio_error_eacces_mc

   ld l,b
   ld h,0
   ret
   
defc ASMDISP_POLLFD_CALLEE = asmentry - pollfd_callee
