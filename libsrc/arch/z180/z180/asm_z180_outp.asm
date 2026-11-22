
; ===============================================================
; Nov 2014
; ===============================================================
;
; void z180_outp(uint16_t port, uint8_t data)
;
; Write data to 16-bit port.
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_outp
PUBLIC asm_cpu_outp

asm_z180_outp:
asm_cpu_outp:

   ; enter : bc = port
   ;          l = data
   ;
   ; uses  : none
   
   out (c),l
   ret
