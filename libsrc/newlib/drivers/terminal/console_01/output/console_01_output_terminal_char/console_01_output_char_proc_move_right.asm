
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_move_right

EXTERN console_01_output_char_proc_move_down
EXTERN console_01_output_char_proc_move_down_check_y

console_01_output_char_proc_move_right:

   ; move right, wrap, snap to window
   ;
   ; enter :  e = x coord
   ;          d = y coord
   ;
   ;          c = window.width
   ;          b = window.height
   ;
   ; exit  :  e = new x coord
   ;          d = new y coord
   ;
   ; uses : af, de

   ld a,e
   
   inc a
   jr z, x_is_large
   
   inc e
   
   cp c
   jr nc, x_is_large           ; if x >= window.width

   ld a,d
   jp console_01_output_char_proc_move_down_check_y

x_is_large:

   ld e,0
   jp console_01_output_char_proc_move_down
