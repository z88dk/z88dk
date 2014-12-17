
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_11_home

zx_01_output_char_32_tty_11_home:

   ; move cursor to (0,0)
   
   xor a
   
   ld (ix+14),a                ; x = 0
   ld (ix+15),a                ; y = 0
   
   ret

