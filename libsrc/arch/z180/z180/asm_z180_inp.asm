
; ===============================================================
; Nov 2014
; ===============================================================
;
; uint8_t z180_inp(uint16_t port)
;
; Return byte read from 16-bit port address.
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_inp
PUBLIC asm_cpu_inp

asm_z180_inp:
asm_cpu_inp:

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
