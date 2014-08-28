
PUBLIC db_00_file_msg_pointer_fp

db_00_file_msg_pointer_fp:

   ; enter:
   ;
   ;   ix = FILE *
   ;
   ; return:
   ;
   ;   hl = & unsigned long file_pointer
   ;
   ; uses:
   ;
   ;   af, hl
   
   push de
   
   ld e,ixl
   ld d,ixh
   
   ld hl,15
   add hl,de
   
   pop de
   ret
