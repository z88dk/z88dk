; stdio_consumesign
; 05.2008 aralbrec

PUBLIC stdio_consumesign
EXTERN stdio_getchar, stdio_ungetchar

; consume a '+' or '-' sign on the stream
; 
; enter :     ix  = FILE *
;               c = flags [000a*WLN]
;             bc' = total num chars read from stream thus far
; uses  :     af, c
; on exit :   bc' = total num chars read from stream thus far
;             carry set of EOF reached
;             bit 0 of c set if negative sign read

.stdio_consumesign

   call stdio_getchar
   ret c
   
   cp '-'
   jr nz, notneg
   set 0,c
   
   ret

.notneg

   cp '+'
   ret z
   
   jp stdio_ungetchar
