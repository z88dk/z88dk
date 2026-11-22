
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_move_left

EXTERN console_01_output_char_proc_move_down_check_y

console_01_output_char_proc_move_left:

   ; move left, wrap, snap to window
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
   
   or a
   jr z, x_is_zero             ; if x == 0
   
   dec a
   dec e
   
   cp c
   jr c, check_y               ; if x < window.width

   ld e,c
   dec e                       ; x = window.width - 1
   
   jr check_y

x_is_zero:

   ld a,d

   or a
   ret z                       ; if y == 0

   dec d
   
   ld e,c
   dec e
   
check_y:

   ld a,d
   jp console_01_output_char_proc_move_down_check_y
