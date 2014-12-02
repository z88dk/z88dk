
SECTION seg_code_fcntl

PUBLIC console_01_output_proc_tty_return

console_01_output_proc_tty_return:

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
   ;            z flag set
   ;            carry reset
   ;
   ;         if executing an action
   ;
   ;            a = action code (> 0)
   ;            nz flag set
   ;            carry reset

   ret c                       ; deliver char to terminal
   ret z                       ; indicate no action to terminal
   
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
