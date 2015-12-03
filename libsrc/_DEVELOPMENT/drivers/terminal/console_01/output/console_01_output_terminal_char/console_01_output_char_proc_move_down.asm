
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_move_down
PUBLIC console_01_output_char_proc_move_down_check_y

console_01_output_char_proc_move_down:

   ; move character coordinates down one row, snap to window
   ;
   ; enter :  d = y coord
   ;          b = window.height
   ;
   ; exit :   d = new y coord
   ;
   ; uses : af, d

   ld a,d
   
   inc a
   jr z, set_max_y
   
   inc d

console_01_output_char_proc_move_down_check_y:

   cp b
   ret c                       ; if y < window.height

set_max_y:

   ld d,b
   dec d                       ; d = window.height - 1
   
   ret
