
SECTION code_clib
SECTION code_im2

PUBLIC asm_im2_push_registers_8080

asm_im2_push_registers_8080:

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
