; stdio_in_d
; 05.2008 aralbrec

PUBLIC stdio_in_d
EXTERN stdio_incommon1, stdio_incommon2, asm_isdigit, stdio_ungetchar, stdio_inexit

; input %d parameter
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

.stdio_in_d

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = FILE *
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = int *
   ;  a = next char from stream
      
   call asm_isdigit          ; is first char a decimal digit?
   jp c, stdio_inexit
   
   ; now we know we have a valid decimal number on the stream
   
   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,10                     ; radix = 10
   jp stdio_incommon2          ; do the rest
