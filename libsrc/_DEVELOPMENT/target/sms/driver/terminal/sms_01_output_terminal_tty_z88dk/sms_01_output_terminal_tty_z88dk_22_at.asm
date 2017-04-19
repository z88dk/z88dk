
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_22_at

sms_01_output_terminal_tty_z88dk_22_at:

   ; at x,y
   
   ; de = parameters *

   ex de,hl
   
   ld d,(hl)                   ; d = y coord
   inc hl
   ld e,(hl)                   ; e = x coord

   ld (ix+14),e                ; set x coord
   ld (ix+15),d                ; set y coord
   
   ret
