
PUBLIC db_00_file_msg_fp_to_eof

EXTERN BLOCKIO_MSG_RECORD_SIZE
EXTERN db_00_file_msg_pointer_eof, db_00_file_msg_pointer_fp

EXTERN l_long_sbc_mde_mhl, error_bc_zc

db_00_file_msg_fp_to_eof:

   ; enter:
   ;
   ;   ix = FILE *
   ;
   ; return:
   ;
   ;   success:
   ;
   ;     dehl = # bytes from file pointer to eof
   ;       bc = record size in bytes
   ;     carry reset
   ;
   ;   fail:
   ;
   ;     bc = 0
   ;     carry set
   
   call db_00_file_msg_pointer_eof   
   ex de,hl                          ; de = & eof
   
   call db_00_file_msg_pointer_fp    ; hl = & fp
   
   or a
   call l_long_sbc_mde_mhl           ; dehl = eof - fp

   jp c, error_bc_zc                 ; if eof < fp
   
   ld a,d
   or e
   or h
   or l
   
   jp z, error_bc_zc                 ; if eof == fp
   
   ld a,BLOCKIO_MSG_RECORD_SIZE
   jp (ix)                           ; return with bc = record size
