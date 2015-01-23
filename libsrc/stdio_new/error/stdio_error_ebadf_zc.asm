; stdio_error_ebadf_zc
; 06.2008 aralbrec

PUBLIC stdio_error_ebadf_zc
EXTERN stdio_errno_zc

INCLUDE "../stdio.def"

   pop hl
   
.stdio_error_ebadf_zc

   ld hl,EBADF
   jp stdio_errno_zc
