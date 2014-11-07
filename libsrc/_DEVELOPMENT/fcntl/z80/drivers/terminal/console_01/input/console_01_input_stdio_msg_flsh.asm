
SECTION seg_code_fcntl

PUBLIC console_01_input_stdio_msg_flsh

EXTERN l_setmem_hl

console_01_input_stdio_msg_flsh:

   ; carry set on error (write buffers could not be flushed)
   
   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,16
   add hl,de                   ; hl = & FDSTRUCT.pending_char
   
   xor a
   call l_setmem_hl - 6        ; pending_char = read_index = 0
   
   inc hl
   inc hl
   
   jp l_setmem_hl - 4          ; b_array.size = 0
