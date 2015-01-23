; stdio_success_znc
; 05.2008 aralbrec

PUBLIC stdio_success_znc

; exit : hl = 0 and carry reset

   pop hl

.stdio_success_znc

   ld hl,0
   or a
   ret
