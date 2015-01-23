; int __FASTCALL__ readbyte(int fd)
; 06.2008 aralbrec

PUBLIC readbyte

EXTERN stdio_error_eacces_mc, stdio_error_ebadf_mc, stdio_error_mc
EXTERN l_jpix, stdio_fdcommon1

INCLUDE "../stdio.def"

.readbyte

   call stdio_fdcommon1        ; ix = fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with fd
   
   bit 2,(ix+3)                ; open for reading?
   jp z, stdio_error_eacces_mc

   ld a,STDIO_MSG_GETC
   call l_jpix
   jp c, stdio_error_mc
   
   ld l,a
   ld h,0
   ret
