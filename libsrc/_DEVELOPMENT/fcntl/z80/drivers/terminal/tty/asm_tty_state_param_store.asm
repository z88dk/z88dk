
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_state_param_store
PUBLIC asm0_tty_state_param_store

asm_tty_state_param_store:

   ;  c = action code
   ; de = next state
   ; stack = & tty.action

   pop hl
   
   ld (hl),c                   ; store action code

asm0_tty_state_param_store:

   dec hl
   ld (hl),d                   ; store next state
   dec hl
   ld (hl),e
   
   xor a                       ; indicate char absorbed
   ret
