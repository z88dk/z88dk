; int __CALLEE__ ioctl_callee(int fd, int request, int arg)
; 06.2008 aralbrec

PUBLIC ioctl_callee
PUBLIC ASMDISP_IOCTL_CALLEE

EXTERN stdio_error_mc, stdio_error_ebadf_mc
EXTERN l_jpix, stdio_fdcommon1

INCLUDE "../stdio.def"

.ioctl_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; send a driver-specific control message
   ;
   ; enter : bc = int arg
   ;         de = int request
   ;          l = int fd
   ; exit  : hl = return value, carry reset if success
   ;         hl = -1, carry set if fail

   call stdio_fdcommon1        ; ix = fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with fd
   
   ld a,STDIO_MSG_ICTL
   call l_jpix
   ret nc
   
   jp stdio_error_mc
   
defc ASMDISP_IOCTL_CALLEE = # asmentry - ioctl_callee
