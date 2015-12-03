
SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_push_registers

asm_z80_push_registers:

   ; push all z80 registers onto the stack
   ; must be called

   ; exit : hl = return address
   ;
   ; uses : hl
   
   ex (sp),hl
   push af
   push bc
   push de
   exx
   ex af,af'
   push af
   push bc
   push de
   push hl
   push ix
   push iy
   exx
   
   jp (hl)
