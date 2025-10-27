
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_putchar_scroll_adjust

EXTERN console_01_output_char_proc_putchar_scroll

console_01_output_char_proc_putchar_scroll_adjust:

   ; enter : a = num rows to scroll
   ;
   ; exit  : carry reset
   ;
   ; uses  : af, bc, de, hl

   push af                     ; save num rows scrolled
   
   call console_01_output_char_proc_putchar_scroll
   
   pop bc                      ; b = num rows scrolled
   jr c, screen_cleared

   ; adjust current y coord
   
   ld a,(ix+15)                ; a = y
   
   sub b
   jr nc, store_y

screen_cleared:

   xor a

store_y:

   ld (ix+15),a                ; y = 0   
   ret
