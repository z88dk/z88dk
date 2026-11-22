
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_02_pattern_offset

sms_01_output_terminal_tty_z88dk_02_pattern_offset:

   ; de = parameters *

   ld a,(de)                   ; a = MSB pattern offset
   inc de
   
   and $01
   ld (ix+24),a
   
   ld a,(de)                   ; a = LSB of pattern offset
   ld (ix+23),a
   
   ret
