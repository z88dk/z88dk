
; =============================================================
; DRIVER_BLOCK_FILE_00
; =============================================================
;
; This class handles messages concerned with file attributes.
;
; The intended class hierarchy is:
;
; (base class)
; DRIVER_BLOCK_STDIO_BIN_00 = convert char i/o to block i/o
; DRIVER_BLOCK_BUFFER_00    = manage device records stored in memory
; DRIVER_BLOCK_FILE_00      = answer queries on file attributes
; DRIVER_BLOCK_DEVICE       = device driver reads and writes records
; (derived class)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MESSAGES CONSUMED:
;
; FILE_MSG_POINTER_FP (lowest id), FILE_MSG_POINTER_EOF
; FILE_MSG_FP_TO_EOF, FILE_MSG_FP_TO_MAX, FILE_MSG_EOF_TO_MAX
; FILE_MSG_FP_RECORD_INFO, FILE_MSG_EOF_RECORD_INFO
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MESSAGES GENERATED:
;
; BLOCKIO_MSG_RECORD_SIZE
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC driver_block_file_00

EXTERN FILE_MSG_POINTER_FP, FILE_MSG_POINTER_EOF
EXTERN FILE_MSG_FP_TO_EOF, FILE_MSG_FP_TO_MAX, FILE_MSG_EOF_TO_MAX
EXTERN FILE_MSG_FP_RECORD_INFO, FILE_MSG_EOF_RECORD_INFO

EXTERN driver_block_buffer_00

EXTERN db_00_file_msg_pointer_fp, db_00_file_msg_pointer_eof
EXTERN db_00_file_msg_fp_to_eof, db_00_file_msg_fp_to_max, db_00_file_msg_eof_to_max
EXTERN db_00_file_msg_fp_record_info, db_00_file_msg_eof_record_info

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

driver_block_file_00:

   ; enter:
   ;
   ;   ix = FILE *
   ;    a = message id
   
   cp FILE_MSG_POINTER_FP
   jp z, db_00_file_msg_pointer_fp

   jp c, driver_block_buffer_00    ; forward message not understood here
   
   cp FILE_MSG_POINTER_EOF
   jp z, db_00_file_msg_pointer_eof
   
   cp FILE_MSG_FP_TO_EOF
   jp z, db_00_file_msg_fp_to_eof
   
   cp FILE_MSG_FP_TO_MAX
   jp z, db_00_file_msg_fp_to_max
   
   cp FILE_MSG_EOF_TO_MAX
   jp z, db_00_file_msg_eof_to_max
   
   cp FILE_MSG_FP_RECORD_INFO
   jp z, db_00_file_msg_fp_record_info
   
   cp FILE_MSG_EOF_RECORD_INFO
   jp z, db_00_file_msg_eof_record_info
   
   jp driver_block_buffer_00       ; forward message not understood here
