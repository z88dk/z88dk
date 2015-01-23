; stdio_error_ebadf_mc
; 06.2008 aralbrec

PUBLIC stdio_error_ebadf_mc
EXTERN stdio_errno_mc

INCLUDE "../stdio.def"

   pop hl
   
.stdio_error_ebadf_mc

   ld hl,EBADF
   jp stdio_errno_mc
