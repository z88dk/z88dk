; stdio_in_s
; 05.2008 aralbrec

XLIB stdio_in_s
LIB stdio_getchar, stdio_ungetchar, stdio_consumews, stdio_isspace

; input %s parameter
;
; enter :     ix  = & attached file / device getchar function
;               b = width
;               c = flags [000a*WL0]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached

.stdio_in_s

   bit 3,c
   jr nz, suppress0

   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = char *s
   dec hl

.suppress0

   call stdio_consumews        ; consume whitespace ahead of string
   ret c
   
   call stdio_getchar          ; must be able to read at least one non-whitespace char
   jr nc, join
   ret
   
.loop

   call stdio_getchar          ; read char from stream
   jr c, done
   
   call stdio_isspace          ; if whitespace then end of string reached
   jr z, success

.join

   bit 3,c
   jr nz, suppress1
   
   ld (de),a
   inc de

.suppress1

   bit 2,c                     ; without width specifier just loop back
   jr z, loop

   djnz loop

.done

   xor a                       ; also clears carry flag
   
   bit 3,c
   ret nz
   
   ld (de),a                   ; write terminating \0 to string

   exx
   inc de                      ; increase number of conversions done
   exx
   ret

.success

   call stdio_ungetchar        ; unget whitespace char
   jr done
