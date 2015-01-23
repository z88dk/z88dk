; stdio_nextarg
; 05.2008 aralbrec

PUBLIC stdio_nextarg

; get next 16-bit parameter from a va_arg parameter list
;
; enter : hl = & top of parameter list
; exit  : de = 16-bit parameter from list
;         hl = hl - 2

.stdio_nextarg

   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ret
