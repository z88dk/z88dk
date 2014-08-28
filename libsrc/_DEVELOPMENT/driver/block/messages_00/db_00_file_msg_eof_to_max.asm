
PUBLIC db_00_file_msg_eof_to_max

EXTERN db_00_file_msg_pointer_fp, _0_db_00_file_msg_fp_to_max

db_00_file_msg_eof_to_max:

   ; enter:
   ;
   ;   ix = FILE *
   ;
   ; return:
   ;
   ;   success:
   ;
   ;     dehl = # bytes from eof pointer to max filesize
   ;       bc = record size in bytes
   ;     carry reset
   ;
   ;   fail:
   ;
   ;     bc = 0
   ;     carry set, errno = ERANGE

   call db_00_file_msg_pointer_eof  ; hl = & eof
   jp _0_db_00_file_msg_fp_to_max
