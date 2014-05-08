
PUBLIC l_jp_table

l_jp_table:

   ; jump to an address stored in a jump table
   ;
   ; enter : de = base address of jump table
   ;         hl = index into jump table

   add hl,hl
   add hl,de
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ex de,hl
   jp (hl)
