; stdio_error_enomem_mc
; 06.2008 aralbrec

PUBLIC stdio_error_enomem_mc
EXTERN stdio_errno_mc

INCLUDE "../stdio.def"

   pop hl
   
.stdio_error_enomem_mc

   ld hl,ENOMEM
   jp stdio_errno_mc
