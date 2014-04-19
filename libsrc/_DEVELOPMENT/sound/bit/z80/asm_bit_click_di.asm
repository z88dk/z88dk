
; ===============================================================
; 2001 Stefano Bodrato
; ===============================================================
;
; void bit_click_di(void)
;
; Toggle state of 1-bit output device.
;
; ===============================================================

XLIB asm_bit_click_di

LIB asm_bit_click, asm_z80_push_di, asm_z80_pop_ei

asm_bit_click_di:

   ; uses : af, c, (bc if port_16)

   call asm_z80_push_di

   call asm_bit_click

   jp asm_z80_pop_ei
