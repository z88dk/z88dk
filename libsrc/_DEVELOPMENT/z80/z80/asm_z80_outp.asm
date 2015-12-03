
; ===============================================================
; Nov 2014
; ===============================================================
;
; void z80_outp(uint16_t port, uint8_t data)
;
; Write data to 16-bit port.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_outp

asm_z80_outp:

   ; enter : bc = port
   ;          l = data
   ;
   ; uses  : none
   
   out (c),l
   ret
