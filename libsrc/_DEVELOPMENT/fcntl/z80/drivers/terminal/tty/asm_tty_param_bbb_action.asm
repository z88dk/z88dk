
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_param_bbb_action

EXTERN asm_tty_state_get_3
EXTERN asm_tty_state_param_store

asm_tty_param_bbb_action:

   ;  c = action code
   ; stack = & tty.action

   ; command code has three parameters and action is invoked

   ld de,asm_tty_state_get_3
   jp asm_tty_state_param_store
