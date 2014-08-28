
PUBLIC db_00_file_msg_write_mode

db_00_file_msg_write_mode:

   ; enter:
   ;
   ;   ix = FILE *
   ;
   ; return:
   ;
   ;   nz flag set if append mode
   ;
   ; uses:
   ;
   ;   af
   
   bit 6,(ix+14)
   ret
