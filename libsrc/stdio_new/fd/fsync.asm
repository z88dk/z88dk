; int __FASTCALL__ fsync(int fd)
; 07.2009 aralbrec

PUBLIC fsync

EXTERN l_jpix, stdio_fdcommon1
EXTERN stdio_error_ebadf_mc, stdio_success_znc, stdio_error_mc

INCLUDE "../stdio.def"

; request device driver transmit buffered data to device
; enter : l = fd

.fsync

   call stdio_fdcommon1        ; ix = fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with fd
   
   ld a,STDIO_MSG_SYNC
   call l_jpix
   jp nc, stdio_success_znc
   
   jp stdio_error_mc
