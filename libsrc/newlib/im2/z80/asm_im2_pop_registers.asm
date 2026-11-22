
SECTION code_clib
SECTION code_im2

PUBLIC asm_im2_pop_registers

asm_im2_pop_registers:

   ; pop all z80 registers from the stack
   ; must be called
   
   ; uses : all
   
   pop hl
   
   exx
   pop iy
   pop ix
   pop hl
   pop de
   pop bc
   pop af
   ex af,af'
   exx
   pop de
   pop bc
   pop af
   ex (sp),hl
   
   ret
