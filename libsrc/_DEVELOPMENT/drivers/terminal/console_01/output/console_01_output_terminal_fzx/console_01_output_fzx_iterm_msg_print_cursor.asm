
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_print_cursor

EXTERN console_01_output_fzx_oterm_msg_putc_raw

console_01_output_fzx_iterm_msg_print_cursor:

   ;   Input terminal is printing the cursor.
   ;
   ;   enter  :  c = cursor ascii code (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
   ;   can use:  af, bc, de, hl, ix

   ld (ix+22),c                ; store cursor code
   jp console_01_output_fzx_oterm_msg_putc_raw
