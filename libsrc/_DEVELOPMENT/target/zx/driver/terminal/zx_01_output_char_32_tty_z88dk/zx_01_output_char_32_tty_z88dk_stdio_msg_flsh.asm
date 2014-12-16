
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_z88dk_stdio_msg_flsh

EXTERN l_offset_ix_de, asm_tty_reset

zx_01_output_char_32_tty_z88dk_stdio_msg_flsh:

   ; carry indicates error
   
   ld hl,26
   call l_offset_ix_de         ; hl = & tty_state
   
   ; carry is reset here
   
   jp asm_tty_reset            ; base drivers do not implement flush
