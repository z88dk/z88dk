
SECTION code_clib
SECTION code_im2

PUBLIC asm_im2_pop_registers_8080

asm_im2_pop_registers_8080:

   ; pop the main registers from the stack
   ; must be called
   
   ; uses : af, bc, de, hl
   
   pop hl
   
   pop de
   pop bc
   pop af
   ex (sp),hl
   
   ret
