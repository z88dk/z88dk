
; ===============================================================
; Nov 2014
; ===============================================================
;
; uint8_t z80_inp(uint16_t port)
;
; Return byte read from 16-bit port address.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_inp

asm_z80_inp:

   ; enter : hl = port
   ;
   ; exit  : hl = byte read from port
   ;
   ; uses  : f, bc, hl

   ld c,l
   ld b,h
   
   in l,(c)
   ld h,0
   
   ret
