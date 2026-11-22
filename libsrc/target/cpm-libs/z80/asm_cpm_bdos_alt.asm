
SECTION code_clib
SECTION code_arch

PUBLIC asm_cpm_bdos_alt

asm_cpm_bdos_alt:

   ; bdos call but most alt z80 registers saved
   ;
   ; enter :  c = bdos function
   ;         de = argument
   ;
   ; exit  : registers set by cpm
   ;
   ; saves : bc', de', hl', ix, iy
   
   exx
   
   push bc
   push de
   push hl
   push ix
   push iy
   
   exx
   
   call 0x0005
   
   exx
   
   pop iy
   pop ix
   pop hl
   pop de
   pop bc
   
   exx
   ret
