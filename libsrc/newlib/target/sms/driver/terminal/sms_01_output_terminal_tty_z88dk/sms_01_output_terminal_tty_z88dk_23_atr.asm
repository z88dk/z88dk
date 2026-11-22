
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_23_atr

sms_01_output_terminal_tty_z88dk_23_atr:

   ; atr dx,dy
   
   ; de = parameters *
   
   ld a,(de)                   ; biased dy
   inc de
   
   sub 0x80                    ; dy
   add a,(ix+15)               ; + y
   ld (ix+15),a
   
   ld a,(de)                   ; biased dx
   
   sub 0x80                    ; dx
   add a,(ix+14)               ; + x
   ld (ix+14),a

   ret
