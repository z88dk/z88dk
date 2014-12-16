
SECTION code_fcntl

PUBLIC asm_tty_reset, asm0_tty_reset

EXTERN asm_tty_state_0

asm_tty_reset:

   ; reset the tty state machine
   ;
   ; enter : hl = & tty
   ;
   ; uses  : hl
   
   inc hl

asm0_tty_reset:

   ld (hl),asm_tty_state_0 % 256
   inc hl
   ld (hl),asm_tty_state_0 / 256
   
   ret
