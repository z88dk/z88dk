
SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_pop_registers_8080

asm_z80_pop_registers_8080:

   ; pop the main registers from the stack
   ; must be called
   
   ; uses : af, bc, de, hl
   
   pop hl
   
   pop de
   pop bc
   pop af
   ex (sp),hl
   
   ret
