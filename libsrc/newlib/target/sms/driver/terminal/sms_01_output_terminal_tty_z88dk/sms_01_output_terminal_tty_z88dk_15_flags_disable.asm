
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_15_flags_disable

sms_01_output_terminal_tty_z88dk_15_flags_disable:

   ; disable flag bits
   
   ; de = parameters *
   
   ld a,(de)

   cpl
   and (ix+25)
   ld (ix+25),a
   
   ret
