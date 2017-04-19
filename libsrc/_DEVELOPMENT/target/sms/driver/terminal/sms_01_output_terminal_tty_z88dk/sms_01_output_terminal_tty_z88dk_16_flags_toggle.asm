
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_16_flags_toggle

sms_01_output_terminal_tty_z88dk_16_flags_toggle:

   ; toggle flag bits
   
   ; de = parameters *
   
   ld a,(de)
   
   xor (ix+25)
   ld (ix+25),a
   
   ret
