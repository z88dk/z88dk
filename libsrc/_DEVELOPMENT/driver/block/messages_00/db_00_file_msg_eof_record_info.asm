
PUBLIC db_00_file_msg_eof_record_info
EXTERN _0_db_00_file_msg_fp_record_info

EXTERN db_00_file_msg_pointer_eof

db_00_file_msg_eof_record_info:

   ; return information about the record containing eof pointer
   ;
   ; enter:
   ;
   ;   ix = FILE *
   ;   de = long *record_number
   ;
   ; return:
   ;
   ;   de = long *record_number (filled in)
   ;   hl = offset into record
   ;   bc = number bytes remaining in record
   ;   z flag set if hl=offset == 0
   ;   carry reset

   call db_00_file_msg_pointer_eof  ; hl = & eof pointer
   jp _0_db_00_file_msg_fp_record_info
