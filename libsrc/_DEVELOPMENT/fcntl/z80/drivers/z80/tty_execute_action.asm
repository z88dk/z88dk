
SECTION seg_code_fcntl

PUBLIC tty_execute_action

tty_execute_action:

   ; helper function for output consoles
   ; execute actions demanded by tty
   ;
   ; enter : hl = & action_table
   ;         bc = parameter
   ;         de = parameter
   ;
   ;         if producing a char for the terminal
   ;
   ;            c = ascii code
   ;            carry set
   ;
   ;         if producing nothing for the terminal
   ;
   ;            a = 0
   ;            carry reset
   ;
   ;         if executing an action
   ;
   ;            a = action code (> 0)
   ;            carry reset

   ret c                       ; deliver char to terminal
   
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
   
   jp (hl)                     ; perform action
