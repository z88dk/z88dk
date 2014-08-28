
PUBLIC db_00_file_msg_pointer_eof

db_00_file_msg_pointer_eof:

   ; enter:
   ;
   ;   ix = FILE *
   ;
   ; return:
   ;
   ;   hl = & unsigned long eof
   ;
   ; uses:
   ;
   ;   af, hl
   
   ld l,(ix+1)
   ld h,(ix+2)                 ; hl = eFILE *
   
   inc hl
   inc hl
   inc hl
   inc hl
   
   ret
