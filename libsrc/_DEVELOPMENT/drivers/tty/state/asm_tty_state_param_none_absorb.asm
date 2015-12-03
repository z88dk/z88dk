
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_state_param_none_absorb

asm_tty_state_param_none_absorb:

   ; command code has no parameters and tty absorbs
   
   xor a
   
   pop hl
   ret

