
SECTION code_stdlib

PUBLIC __ftoa_stack_restore

__ftoa_stack_restore:

   ; restore size must match reservation in asm_ftoa and asm_ftoe
   
   ld c,l
   ld b,h
   
   ld hl,32
   add hl,sp
   ld sp,hl
   
   ld l,c
   ld h,b
   
   ret
