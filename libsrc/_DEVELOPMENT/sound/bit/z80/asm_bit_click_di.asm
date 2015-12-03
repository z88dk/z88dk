
; ===============================================================
; 2001 Stefano Bodrato
; ===============================================================
;
; void bit_click_di(void)
;
; Toggle state of 1-bit output device.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_click_di

EXTERN asm_bit_click, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_click_di:

   ; uses : af, c, (bc if port_16)

   call asm_z80_push_di
   call asm_bit_click
   jp asm0_z80_pop_ei
