
PUBLIC db_00_file_msg_fp_to_max
PUBLIC _0_db_00_file_msg_fp_to_max

EXTERN BLOCKIO_MSG_RECORD_SIZE
EXTERN db_00_file_msg_pointer_fp

EXTERN l_long_load_mhl, l_cpl_dehl, error_bc_zc

db_00_file_msg_fp_to_max:

   ; enter:
   ;
   ;   ix = FILE *
   ;
   ; return:
   ;
   ;   success:
   ;
   ;     dehl = # bytes from file pointer to max filesize
   ;       bc = record size in bytes
   ;     carry reset
   ;
   ;   fail:
   ;
   ;     bc = 0
   ;     carry set

   call db_00_file_msg_pointer_fp  ; hl = & fp

_0_db_00_file_msg_fp_to_max:

   call l_long_load_mhl            ; dehl = file pointer
   call l_cpl_dehl                 ; dehl = $ffffffff - dehl
   
   ld a,d
   or e
   or h
   or l
   
   jp z, error_bc_zc               ; if fp >= max file size, bc=0 carry set
   
   ld a,BLOCKIO_MSG_RECORD_SIZE
   jp (ix)
