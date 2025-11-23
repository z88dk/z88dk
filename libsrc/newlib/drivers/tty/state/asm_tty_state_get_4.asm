
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_state_get_4

EXTERN l_inc_hl, asm_tty_state_get_3
EXTERN asm0_tty_state_param_store

asm_tty_state_get_4:

   ;  c = ascii char
   ; stack = & tty.action
   
   ; first store next state
   
   pop hl
   
   ld de,asm_tty_state_get_3
   call asm0_tty_state_param_store
   
   ; hl = & tty.state
   ;  c = parameter
   ;  a = 0
   
   call l_inc_hl - 6           ; hl = & tty.param_4
   
   ld (hl),c                   ; store param
   ret
