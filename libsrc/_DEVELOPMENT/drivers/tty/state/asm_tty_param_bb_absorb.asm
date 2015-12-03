
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_param_bb_absorb

EXTERN asm_tty_state_get_2
EXTERN asm_tty_state_param_store

asm_tty_param_bb_absorb:

   ;  c = action code
   ; stack = & tty.action

   ; command code has one parameter and tty absorbs

   set 7,c                     ; indicate absorb

   ld de,asm_tty_state_get_2
   jp asm_tty_state_param_store
