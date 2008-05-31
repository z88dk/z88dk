; stdio_in_lx
; 05.2008 aralbrec

XLIB stdio_in_lx
LIB stdio_incommon1, stdio_incommon3, stdio_ungetchar, stdio_getchar, stdio_isxdigit, stdio_zeroonstream

; input %lx parameter, handles both 16-bit %x and 32-bit %lx
;
; enter :     ix  = & attached file / device getchar function
;               b = width
;               c = flags [000a*WLN]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;             carry flag reset (important for %x, %lx)
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached

.stdio_in_lx

   call stdio_incommon1        ; leading ws, sign, int *
   ret c
   
   ; ix = & getchar function
   ;  c = flags [000a*WLN]
   ; hl = & parameter list
   ; de = int *
   ;  a = next char from stream
   
   ; first digits can be 0X
   
   cp '0'
   jr nz, nobasespecifier

   call stdio_getchar
   jp c, stdio_zeroonstream
   
   cp 'x'
   jr z, hexleaderfound
   cp 'X'
   jr z, hexleaderfound
   
   call stdio_isxdigit
   jr nc, join
   
   call stdio_ungetchar
   jp stdio_zeroonstream
 
.hexleaderfound

   call stdio_getchar
   ret c

.nobasespecifier

   call stdio_isxdigit         ; is first char a hexadecimal digit?
   jr c, exit

   ; now we know we have a valid hexadecimal number on the stream

.join

   call stdio_ungetchar        ; place first digit back on stream
   
   ld b,16                     ; radix = 16
   jp stdio_incommon3          ; do the rest

.exit

   call stdio_ungetchar
   scf
   ret
