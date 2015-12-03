
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_putc

EXTERN console_01_output_fzx_oterm_msg_putc_raw

defc console_01_output_fzx_iterm_msg_putc = console_01_output_fzx_oterm_msg_putc_raw

   ; enter  :  c = char to output
   ; can use:  af, bc, de, hl, ix
   
   ; char to print is coming from the input terminal
   ; so it should not be subject to tty emulation
