
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC cpm_00_input_cons_stdio_msg_flsh

EXTERN l_offset_ix_de

cpm_00_input_cons_stdio_msg_flsh:
 
   ; get rid of any pending chars in buffer

   ld hl,14
   call l_offset_ix_de         ; hl = & index

   ld (hl),255                 ; index = 255

   or a
   ret
