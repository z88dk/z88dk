
PUBLIC l_long_add_mhl_bc

EXTERN l0_long_inc_mhl

l_long_add_mhl_bc:

   ; add bc to long pointed at by hl
   ;
   ; enter : hl = unsigned long *
   ;         bc = unsigned int
   ;
   ; exit  : *hl += bc
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   add a,c
   ld (hl),a
   
   inc hl
   ld a,(hl)
   adc a,b
   ld (hl),a
   ret nc
   
   jp l0_long_inc_mhl
