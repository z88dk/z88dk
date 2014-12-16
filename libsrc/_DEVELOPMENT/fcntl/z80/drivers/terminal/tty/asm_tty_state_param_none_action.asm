
SECTION code_fcntl

PUBLIC asm_tty_param_none_action

asm_tty_param_none_action:

   ; command code has no parameters and action is invoked

   ;  c = action code
   ; stack = & tty.action
   
   ld a,c
   or a
   
   pop hl
   ret
