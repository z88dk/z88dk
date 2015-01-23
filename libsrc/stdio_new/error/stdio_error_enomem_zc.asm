; stdio_error_enomem_zc
; 06.2008 aralbrec

PUBLIC stdio_error_enomem_zc
EXTERN stdio_errno_zc

INCLUDE "../stdio.def"

   pop hl

.stdio_error_enomem_zc

   ld hl,ENOMEM
   jp stdio_errno_zc
