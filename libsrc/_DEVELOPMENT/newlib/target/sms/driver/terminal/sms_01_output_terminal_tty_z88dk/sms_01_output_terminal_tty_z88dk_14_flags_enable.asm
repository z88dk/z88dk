
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_14_flags_enable

sms_01_output_terminal_tty_z88dk_14_flags_enable:

   ; enable flag bits
   
   ; de = parameters *
   
   ld a,(de)
   
   or (ix+25)
   ld (ix+25),a
   
   ret
