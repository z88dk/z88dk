; stdio_in_c
; 05.2008 aralbrec

XLIB stdio_in_c
LIB stdio_getchar

; input %c parameter
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

.stdio_in_c

   bit 2,c                     ; was a width specified?
   jr nz, destbuf
   ld b,1                      ; default width is 1

.destbuf

   bit 3,c                     ; suppressing assignment?
   jr nz, suppress

   ld d,(hl)                   ; get destination buffer from parameter list
   dec hl
   ld e,(hl)                   ; de = char * (destination buffer)
   dec hl
      
.loop

   call stdio_getchar
   ret c

   ld (de),a
   inc de

   djnz loop
      
   exx
   inc de                      ; increase number of successful conversions
   exx
   ret                         ; return with carry reset for success

.suppress

   call stdio_getchar
   ret c
   djnz suppress
   ret
