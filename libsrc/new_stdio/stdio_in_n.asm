; stdio_in_n
; 05.2008 aralbrec

XLIB stdio_in_n
LIB stdio_out_n

; input %n parameter
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

.stdio_in_n

   or a                        ; make sure we exit without indicating an error
   bit 3,c                     ; ok, implement suppression
   ret nz
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = int *n
   dec hl
   
   jp stdio_out_n
