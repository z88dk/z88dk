
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_push_hlix
PUBLIC ____sdcc_ll_push_hlix_0

____sdcc_ll_push_hlix:

IFDEF __SDCC_IX

   push ix
   pop de

ELSE

   push iy
   pop de
   
ENDIF

   add hl,de
   
____sdcc_ll_push_hlix_0:
   
   ex de,hl
   
   ld hl,-6
   add hl,sp
   
   pop af
   ld sp,hl
   
   push af
   push	bc
   
   ld hl,7+4
   add hl,sp
   
   ex de,hl
   
   ld bc,7
   lddr
   
   ld a,(hl)
   ld (de),a

   pop bc
   ret
