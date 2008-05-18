; stdio_out_u
; 05.2008 aralbrec

XLIB stdio_out_u
LIB stdio_numprec, stdio_outcommon

INCLUDE "stdio.def"

; output %u parameter
;
; enter :    ix  = & attached file / device output function
;             a = precision
;             b = width
;             c = flags [-+ O#PLN]
;            de = integer
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
; exit  :   bc' = total num chars output on stream thus far
;            hl = & parameter list
;         carry set if error on stream, ERRNO set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_u

   push hl                     ; save & parameter list
   
   push bc                     ; save width and flags
   ld bc,10                    ; num chars in buffer = 0, radix = 10
   
   ld hl,STDIO_TEMPBUFSZ + 7
   add hl,sp                   ; hl = & last char in temporary buffer
   
   call stdio_numprec          ; write number to buffer including precision digits
   
   pop de

   ;     b = num chars written to buffer
   ;     d = width
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   inc b                       ; no digits written to buffer means precision and integer == 0
   djnz noadj
   ld e,0                      ; in this case clear zero-pad flag so zeroes aren't written

.noadj

   call stdio_outcommon
   pop hl                      ; hl = & parameter list
   ret
