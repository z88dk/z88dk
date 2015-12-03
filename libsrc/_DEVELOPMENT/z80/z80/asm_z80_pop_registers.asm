
SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_pop_registers

asm_z80_pop_registers:

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
