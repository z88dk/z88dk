
SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_push_registers_8080

asm_z80_push_registers_8080:

   ; push the main registers onto the stack
   ; must be called
   
   ; exit : hl = return address
   ;
   ; uses : hl
   
   ex (sp),hl
   push af
   push bc
   push de
   
   jp (hl)
