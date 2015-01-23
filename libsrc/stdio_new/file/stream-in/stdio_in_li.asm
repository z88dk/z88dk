; stdio_in_li
; 05.2008 aralbrec

PUBLIC stdio_in_li
EXTERN stdio_incommon1, stdio_incommon3, stdio_ungetchar, stdio_getchar, stdio_inexit
EXTERN asm_isdigit, asm_isxdigit, asm_isodigit, asm_isbdigit, stdio_longzeroonstream

; input %li parameter, read a binary / octal / hex / decimal number, handles 16-bit and 32-bit
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

.stdio_in_li

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = FILE *
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = long *
   ;  a = next char from stream
   
   ; first determine the radix
   
   cp '0'                      ; leading 0 means octal or hex
   jr z, octalorhex
   
   cp '%'
   jr nz, decimal

   ; should be binary...make sure next digit is valid
   
   call stdio_getchar
   ret c
   
   call asm_isbdigit
   jp c, stdio_inexit
      
   ld b,2                      ; radix = 2
   jp join   

.decimal

   ; should be decimal...make sure the digit is valid

   call asm_isdigit
   jp c, stdio_inexit
   
   ld b,10                     ; radix = 10
   jp join

.octalorhex

   call stdio_getchar          ; examine next digit to see if hex or octal
   jp c, stdio_longzeroonstream

   cp 'x'
   jr z, hex
   cp 'X'
   jr z, hex
   
   ; octal number

   ld b,8
   call asm_isodigit
   jp nc, join                 ; this digit is an octal digit so join number loop

   call stdio_ungetchar        ; otherwise return it
   jp stdio_longzeroonstream

 .hex  
   
   call stdio_getchar          ; get first hex digit after '0x'
   ret c

   call asm_isxdigit         ; is first char a hexadecimal digit?
   jp c, stdio_inexit

   ld b,16                     ; radix = 16
   
.join

   call stdio_ungetchar        ; place first digit back on stream
   jp stdio_incommon3          ; do the rest
