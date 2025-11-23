
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_state_0

EXTERN l_ret

asm_tty_state_0:

   ; de = & tty_table
   ;  c = ascii char
   ; stack = & tty.action
   
   ld a,31
   cp c
   jp c, l_ret - 1             ; if printable char

   ; new command code
   
   ld a,c
   add a,a
   
   ld l,a
   ld h,0
   
   add hl,de
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   jp (hl)                     ; to initial state of command code
