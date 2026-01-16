
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_output_char

asm_tty_output_char:

   ;  c = action code
   ; stack = & tty.action

   pop hl
   
   scf
   ret
