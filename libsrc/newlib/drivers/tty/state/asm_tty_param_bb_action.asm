
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_param_bb_action

EXTERN asm_tty_state_get_2
EXTERN asm_tty_state_param_store

asm_tty_param_bb_action:

   ;  c = action code
   ; stack = & tty.action

   ; command code has two parameters and action is invoked

   ld de,asm_tty_state_get_2
   jp asm_tty_state_param_store
