; stdio_in_d
; 05.2008 aralbrec

XLIB stdio_in_d
LIB stdio_incommon1, stdio_incommon2, stdio_isdigit, stdio_ungetchar

; input %d parameter
;
; enter :     ix  = & attached file / device getchar function
;               b = width
;               c = flags [000a*WLN]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached

.stdio_in_d

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = & getchar function
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = int *
   ;  a = next char from stream
      
   call stdio_isdigit          ; is first char a decimal digit?
   jr c, exit
   
   ; now we know we have a valid decimal number on the stream
   
   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,10                     ; radix = 10
   jp stdio_incommon2          ; do the rest

.exit

   call stdio_ungetchar
   scf
   ret
