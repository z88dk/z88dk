; int __CALLEE__ writebyte_callee(int fd, int c)
; 06.2008 aralbrec

PUBLIC writebyte_callee
PUBLIC ASMDISP_WRITEBYTE_CALLEE

EXTERN stdio_fdcommon1, l_jpix
EXTERN stdio_error_ebadf_mc, stdio_error_eacces_mc, stdio_error_mc, stdio_success_znc

INCLUDE "../stdio.def"

.writebyte_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

   ; enter :  l = fd
   ;          c = char
   
   call stdio_fdcommon1        ; ix = fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with fd
   
   bit 1,(ix+3)                ; open for writing?
   jp z, stdio_error_eacces_mc

   ld a,STDIO_MSG_PUTC
   call l_jpix
   jp nc, stdio_success_znc
   
   jp stdio_error_mc

defc ASMDISP_WRITEBYTE_CALLEE = # asmentry - writebyte_callee
