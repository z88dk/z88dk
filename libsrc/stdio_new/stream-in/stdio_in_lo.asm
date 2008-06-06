; stdio_in_lo
; 05.2008 aralbrec

XLIB stdio_in_lo
LIB stdio_incommon1, stdio_incommon3, stdio_isodigit, stdio_ungetchar, stdio_inexit

; input %lo parameter, handles 16-bit %o and 32-bit %lo
;
; enter :     ix  = FILE *
;               b = width
;               c = flags [000a*WLN]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached

.stdio_in_lo

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = FILE *
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = long *
   ;  a = next char from stream
      
   call stdio_isodigit         ; is first char an octal digit?
   jp c, stdio_inexit
   
   ; now we know we have a valid octal number on the stream
   
   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,8                      ; radix = 8
   jp stdio_incommon3          ; do the rest
