
; ===============================================================
; Dominic Morris, adapted by Stefano Bodrato
; ===============================================================
;
; void bit_fx_di(void *effect)
;
; Plays the selected sound effect on the one bit device.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_fx_di

EXTERN asm_bit_fx, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_fx_di:

   ; enter : hl = void *effect
   ;
   ; uses  : af, bc, de, hl, ix, (bc' if port_16)

   call asm_z80_push_di
   call asm_bit_fx
   jp asm0_z80_pop_ei
