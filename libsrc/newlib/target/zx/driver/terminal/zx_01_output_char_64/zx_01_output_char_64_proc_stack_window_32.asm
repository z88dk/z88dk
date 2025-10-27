
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_64_proc_stack_window_32

EXTERN l_offset_ix_de

zx_01_output_char_64_proc_stack_window_32:

   ; create a 32-column equivalent window on the stack
   ;
   ; uses : f, bc, de, hl
   
   ld hl,19
   call l_offset_ix_de         ; hl = & window.height
   
   pop de                      ; de = return address
   
   ld b,(hl)                   ; b = window.height
   dec hl
   ld c,(hl)                   ; c = window.y
   dec hl
   
   push bc
   
   ld b,(hl)                   ; b = window.width
   dec hl
   ld c,(hl)                   ; c = window.x
   
   srl b                       ; b = width / 2 = 32 column equivalent
   srl c                       ; c = x /2 = 32 column equivalent
   
   push bc
   
   ex de,hl
   jp (hl)
