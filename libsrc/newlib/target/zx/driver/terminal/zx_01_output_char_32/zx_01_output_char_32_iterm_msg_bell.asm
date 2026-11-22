
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_iterm_msg_bell

EXTERN asm_bit_beep_raw_di

zx_01_output_char_32_iterm_msg_bell:

   bit 1,(ix+7)
   ret z                       ; if signal bell is disabled

   push ix
   
   ld hl,+((__CPU_CLOCK / 600) - 236) / 8   ; 600 Hz tone
   ld de,600 / 100                           ; 0.01 sec
   
   call asm_bit_beep_raw_di
   
   pop ix
   ret
