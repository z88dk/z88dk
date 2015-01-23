; stdio_out_M
; 07.2009 aralbrec

PUBLIC stdio_out_capm
EXTERN stdio_numprec, stdio_outcommon

INCLUDE "../../stdio.def"

; output %M parameter
; 
; EUI-48 / MAC-48 address in paired hex notation
;
; * width and justification applies to entire address
; * # selects '-' separator for bytes
;
; enter :     ix  = FILE *
;               a = precision (default 1)
;               b = width (default 0)
;               c = flags [-+ O#PLN]
;              de = 16-bit parameter (most significant word if long)
;              hl = & parameter list
;             bc' = total num chars output on stream thus far
;             carry flag reset (important for %x, %lx)
;           stack = output buffer, ptr in format string, ret
; on exit :   bc' = total num chars output on stream thus far
;              hl = & parameter list
;         carry set if error on stream, ERRNO set appropriately

.stdio_out_capm

   push hl                     ; save & parameter list
   push bc                     ; save width and flags
   
   ld hl,STDIO_TEMPBUFSIZE + 7 + 1
   add hl,sp                   ; hl = & last char in temporary buffer + 1
   
   ld a,6                      ; six bytes in MAC address
   ld bc,16                    ; 0 chars in buffer, radix = 16

.loop

   dec hl

   push af                     ; save loop counter
   push de                     ; save mac address pointer
   
   ld a,(de)
   ld e,a
   ld d,0                      ; de = byte for output
   
   ld a,2                      ; precision is two for byte
   call stdio_numprec          ; output hex byte to buffer
   
   pop de                      ; de = mac address pointer
   pop af                      ; a = loop counter
   
   dec a
   jr z, exit_loop

   inc de                      ; next byte in mac address
   
   ld (hl),':'                 ; write byte separator
   inc b                       ; number of chars in temp buffer++
   
   bit 3,c                     ; confirm default separator is selected
   jp z, loop
   
   ld (hl),'-'                 ; use alternate byte separator
   jp loop


.exit_loop

   ; now output buffer onto stream with width and justification applied
   
   pop de                      ; d = width, e = flags [-+ O#PLN]
   call stdio_outcommon
   pop hl                      ; hl = & parameter list
   ret
