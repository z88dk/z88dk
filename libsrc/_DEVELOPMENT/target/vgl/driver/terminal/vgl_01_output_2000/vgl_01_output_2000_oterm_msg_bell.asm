
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_2000_oterm_msg_bell

EXTERN asm_bit_beep_raw_di

vgl_01_output_2000_oterm_msg_bell:
   ;   can use:  af, bc, de, hl
   
   ; Use bit_beep
   push ix
   
   ld hl,+((__CPU_CLOCK / 1200) - 236) / 8  ; 1200 Hz tone
   ld de, 1200 / 10                            ; 0.1 sec
   
   call asm_bit_beep_raw_di
   
   pop ix
   ret
