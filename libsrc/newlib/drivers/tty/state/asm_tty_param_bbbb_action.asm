
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_param_bbbb_action

EXTERN asm_tty_state_get_4
EXTERN asm_tty_state_param_store

asm_tty_param_bbbb_action:

   ;  c = action code
   ; stack = & tty.action

   ; command code has one parameter and action is invoked

   ld de,asm_tty_state_get_4
   jp asm_tty_state_param_store
