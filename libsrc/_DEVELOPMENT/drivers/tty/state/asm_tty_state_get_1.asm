
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_state_get_1

EXTERN asm0_tty_reset

asm_tty_state_get_1:

   ;  c = ascii char
   ; stack = & tty.action
   
   ; first reset the state machine
   
   pop hl                      ; hl = & tty.action
   
   dec hl
   dec hl                      ; hl = & tty.state
   
   call asm0_tty_reset
   
   ; get action code and store last parameter
   
   ; hl = & tty.state + 1b
   ;  c = last parameter
   
   inc hl
   ld a,(hl)                   ; a = action code
   
   inc hl
   ld (hl),c                   ; store last param
   
   ex de,hl                    ; de = & parameters

   ; take action or absorb
   
   or a
   ret p                       ; bit 7 = 0 indicates take action
   
   xor a                       ; indicate absorb
   ret
