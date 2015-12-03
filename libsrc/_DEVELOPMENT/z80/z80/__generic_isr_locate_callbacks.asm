
SECTION code_clib
SECTION code_z80

PUBLIC __generic_isr_locate_callbacks

__generic_isr_locate_callbacks:

   ; enter :  l = interrupt vector corresponding to a generic isr
   ;
   ; exit  : hl = address of callback functions for the generic isr
   ;
   ; uses  : af, bc, hl
   
   ld a,i
   ld h,a
   
   ld c,(hl)
   inc hl
   ld b,(hl)
   
   ld hl,16
   add hl,bc
   
   ret
