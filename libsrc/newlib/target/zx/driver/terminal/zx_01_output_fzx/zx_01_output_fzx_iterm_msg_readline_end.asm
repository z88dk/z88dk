
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_iterm_msg_readline_end

EXTERN console_01_output_fzx_iterm_msg_readline_end

zx_01_output_fzx_iterm_msg_readline_end:

   ; input terminal has completed editing
   ; can use: af, bc, de, hl, ix

   ld a,(ix+37)                ; a = pixel y coord (must be < 256)
   rra
   rra
   rra
   and $1f
   inc a                       ; a = char y coord rounded up
   
   ld (ix+20),a                ; set new scroll limit
   
   jp console_01_output_fzx_iterm_msg_readline_end
