
SECTION code_clib
SECTION code_l

PUBLIC l_testword_hl

   inc hl
   inc hl
   
   inc hl
   inc hl

l_testword_hl:

   ; Common operation to test if word at offset from hl equals zero
   ;
   ; enter : hl = int *address
   ;
   ; exit  : if *address == 0
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if *address != 0
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   inc hl
   or (hl)

   ld hl,0
   ret nz
   
   inc l
   ret
