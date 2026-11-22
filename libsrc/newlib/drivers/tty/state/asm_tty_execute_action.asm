
SECTION code_driver
SECTION code_driver_tty

PUBLIC asm_tty_execute_action

EXTERN l_jphl

asm_tty_execute_action:

   ; helper function for output consoles
   ; execute actions demanded by tty
   ;
   ; enter : hl = & action_table
   ;         de = & parameters
   ;
   ;         if producing nothing for the terminal
   ;
   ;            a = 0
   ;
   ;         if executing an action
   ;
   ;            a = action code (> 0)
   ;
   ; uses  : af, bc, de, hl
   
   or a
   ret z                       ; if tty swallowed char
   
   dec a
   add a,a
   
   add a,l
   ld l,a
   
   ld a,0
   adc a,h
   ld h,a
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   call l_jphl
   
   or a
   ret                         ; carry reset indicates char absorbed
