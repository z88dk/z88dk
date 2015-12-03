
INCLUDE "clib_target_cfg.asm"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_oterm_msg_bell

EXTERN asm_bit_beep_raw_di

zx_01_output_char_32_oterm_msg_bell:

   ;   can use:  af, bc, de, hl

   bit 0,(ix+7)
   ret z                       ; if bell disabled

   push ix
   
   ld hl,#((__clock_freq / 1200) - 236) / 8  ; 1200 Hz tone
   ld de,1200 / 5                            ; 0.2 sec
   
   call asm_bit_beep_raw_di
   
   pop ix
   ret
