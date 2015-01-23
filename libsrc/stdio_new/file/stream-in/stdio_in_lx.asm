; stdio_in_lx
; 05.2008 aralbrec

PUBLIC stdio_in_lx
EXTERN stdio_incommon1, stdio_incommon3, stdio_ungetchar, stdio_getchar, asm_isxdigit, stdio_longzeroonstream, stdio_inexit

; input %lx parameter, handles both 16-bit %x and 32-bit %lx
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

.stdio_in_lx

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = FILE *
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = long *
   ;  a = next char from stream
   
   ; first digits can be 0X
   
   cp '0'
   jr nz, nobasespecifier

   call stdio_getchar
   jp c, stdio_longzeroonstream
   
   cp 'x'
   jr z, hexleaderfound
   cp 'X'
   jr z, hexleaderfound
   
   call asm_isxdigit
   jp nc, join
   
   call stdio_ungetchar
   jp stdio_longzeroonstream
 
.hexleaderfound

   call stdio_getchar
   ret c

.nobasespecifier

   call asm_isxdigit         ; is first char a hexadecimal digit?
   jp c, stdio_inexit

   ; now we know we have a valid hexadecimal number on the stream

.join

   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,16                     ; radix = 16
   jp stdio_incommon3          ; do the rest
