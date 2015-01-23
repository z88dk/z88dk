; int __CALLEE__ pollfd_callee(int fd, char event)
; 06.2008 aralbrec

PUBLIC pollfd_callee
PUBLIC ASMDISP_POLLFD_CALLEE

EXTERN stdio_fdcommon1, l_jpix
EXTERN stdio_error_eacces_mc, stdio_error_ebadf_mc

INCLUDE "../stdio.def"

.pollfd_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

   ; enter : l = fd
   ;         c = event
   ; exit  : c = hl = revent, carry reset for success
   ;         hl = -1, carry set for fail
   
   call stdio_fdcommon1        ; ix = fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with fd
   
   ld a,c                      ; poll always checks for errors
   or $f0
   ld c,a
   
   ld a,STDIO_MSG_POLL
   call l_jpix
   jp c, stdio_error_eacces_mc

   ld l,c
   ld h,0
   ret
   
defc ASMDISP_POLLFD_CALLEE = # asmentry - pollfd_callee
