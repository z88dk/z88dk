; stdio_in_b
; 05.2008 aralbrec

XLIB stdio_in_b
LIB stdio_incommon1, stdio_incommon2, stdio_isbdigit
LIB stdio_getchar, stdio_ungetchar, stdio_inexit

; input %b parameter
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

.stdio_in_b

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = & getchar function
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = int *
   ;  a = next char from stream
   
   cp '%'
   jr nz, notbasespecifier

   call stdio_getchar
   ret c

.notbasespecifier

   call stdio_isbdigit
   jp c, stdio_inexit

   ; now we know we have a valid binary number on the stream
   
   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,2                      ; radix = 2
   jp stdio_incommon2          ; do the rest
