; stdio_error_mc
; 06.2008 aralbrec

PUBLIC stdio_error_mc

; exit : hl = -1 and carry set

   pop hl

.stdio_error_mc

   ld hl,-1
   scf
   ret
