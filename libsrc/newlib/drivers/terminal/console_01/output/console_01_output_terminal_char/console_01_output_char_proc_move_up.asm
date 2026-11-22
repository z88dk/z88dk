
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_move_up

console_01_output_char_proc_move_up:

   ; move character coordinates up one row, snap to window
   ;
   ; enter :  d = y coord
   ;          b = window.height
   ;
   ; exit  :  d = new y coord
   ;
   ; uses  : af, d

   ld a,d
   
   or a
   ret z                       ; if y == 0
   
   dec d
   dec a
   
   cp b
   ret c                       ; if y < window.height
   
   ld d,0                      ; set y = 0
   ret
