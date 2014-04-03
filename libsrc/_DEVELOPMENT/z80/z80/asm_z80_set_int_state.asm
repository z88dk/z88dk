
; ===============================================================
; Stefano Bodrato
; ===============================================================
;
; void z80_set_int_state(unsigned int state)
;
; Set the ei/di status previously retrieved.
;
; ===============================================================

XLIB asm_z80_set_int_state

asm_z80_set_int_state:

   ; enter : hl = ei/di status
   ;
   ; uses  : f

   bit 6,l
   jr z, di_state
   
ei_state:

   ei
   ret

di_state:

   di
   ret
