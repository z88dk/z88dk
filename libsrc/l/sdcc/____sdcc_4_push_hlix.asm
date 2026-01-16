
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_push_hlix

____sdcc_4_push_hlix:

   pop af
   push af
   push af
   push af
   
   push de
   
IFDEF __SDCC_IX

   push ix
   pop de

ELSE

   push iy
   pop de
   
ENDIF

   add hl,de
   
   ex de,hl
   
   ld hl,2+2
   add hl,sp
   
   ex de,hl
   
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a
   
   inc bc
   inc bc
   inc bc
   
   pop de
   ret
