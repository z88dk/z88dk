
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_17_paper

zx_01_output_fzx_tty_z88dk_17_paper:

   ; change paper of foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   and $07
   add a,a
   add a,a
   add a,a
   ld e,a
   
   ld a,(ix+52)                ; a = foreground colour
   and $c7
   
   or e
   ld (ix+52),a
   
   ret
