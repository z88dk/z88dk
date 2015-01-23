; stdio_error_enfile_mc
; 06.2008 aralbrec

PUBLIC stdio_error_enfile_mc
EXTERN stdio_errno_mc

INCLUDE "../stdio.def"

   pop hl
   
.stdio_error_enfile_mc

   ld hl,ENFILE
   jp stdio_errno_mc
