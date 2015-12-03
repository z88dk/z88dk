
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_proc_linefeed
PUBLIC console_01_output_fzx_proc_linefeed_check_scroll

EXTERN __fzx_puts_newline, __fzx_puts_newline_set_y
EXTERN console_01_output_fzx_proc_line_spacing 
EXTERN console_01_output_fzx_proc_check_scroll

console_01_output_fzx_proc_linefeed:

   ; change coordinates to beginning of next line
   ;
   ; enter : ix = struct fzx_state *
   ;
   ; exit  : if no scroll necessary
   ;
   ;            carry set
   ;
   ;         if scroll necessary
   ;
   ;            hl = scroll amount in pixels
   ;            carry reset
   ;
   ; uses  : af, de, hl

   call __fzx_puts_newline                         ; move coordinates to next line

   ; ix = struct fzx_state *
   ; de = font_height
   ; hl = y + font_height

   call console_01_output_fzx_proc_line_spacing
   call nz, __fzx_puts_newline_set_y               ; if y coord changes
   
   jp console_01_output_fzx_proc_check_scroll
