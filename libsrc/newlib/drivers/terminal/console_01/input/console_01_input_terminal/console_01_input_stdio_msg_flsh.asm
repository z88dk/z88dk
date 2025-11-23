
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_stdio_msg_flsh

EXTERN l_setmem_hl, l_offset_ix_de

console_01_input_stdio_msg_flsh:

   ; carry set on error (write buffers could not be flushed)
   
   res 6,(ix+7)
   
   ld hl,16
   call l_offset_ix_de         ; hl = & FDSTRUCT.pending_char
   
   xor a
   call l_setmem_hl - 6        ; pending_char = read_index = 0
   
   inc hl
   inc hl
   
   jp l_setmem_hl - 4          ; b_array.size = 0
