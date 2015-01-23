; stdio_in_lb
; 05.2008 aralbrec

PUBLIC stdio_in_lb
EXTERN stdio_incommon1, stdio_incommon3, stdio_getchar, stdio_ungetchar, asm_isbdigit, stdio_inexit

; input %lb parameter, handles both 16-bit %b and 32-bit %lb
;
; enter :     ix  = FILE *
;               b = width
;               c = flags [000a*WL0]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached
;
; MUST NOT ALTER HL' FOR SSCANF FAMILY

.stdio_in_lb

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = FILE *
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = long *
   ;  a = next char from stream
   
   cp '%'
   jr nz, notbasespecifier

   call stdio_getchar
   ret c

.notbasespecifier

   call asm_isbdigit
   jp c, stdio_inexit

   ; now we know we have a valid binary number on the stream
   
   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,2                      ; radix = 2
   jp stdio_incommon3          ; do the rest
