
; =============================================================
; DRIVER_BLOCK_STDIO_BIN_00
; =============================================================
;
; Most fundamental base class for all binary block devices.
;
; Consumes stdio stream messages and generates messages
; that are interpretted by classes derived from this one.
; 
; Effectively converts character oriented i/o requests into
; block i/o requests.  The class that derives from this one
; is intended to be a buffer manager that holds images of
; the block device's records in memory.
;
; There is one unfortunate dependency on the buffer manager's
; data structure in "eatc_entire_record_1".  The word following
; "& record->flags" must hold the address of the buffer in memory
; ("& record->data").
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MESSAGES CONSUMED:
;
; STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_EATC, STDIO_MSG_READ
; STDIO_MSG_GETC, STDIO_MSG_SEEK, STDIO_MSG_FLSH, STDIO_MSG_CLOS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MESSAGES GENERATED:
;
; FILE_MSG_POINTER_FP, FILE_MSG_POINTER_EOF, FILE_MSG_WRITE_MODE
; FILE_MSG_FP_TO_EOF, FILE_MSG_FP_TO_MAX, FILE_MSG_EOF_TO_MAX
; FILE_MSG_FP_RECORD_INFO, FILE_MSG_EOF_RECORD_INFO
;
; BUFFER_MSG_READ_RECORD, BUFFER_MSG_WRITE_RECORD
; BUFFER_MSG_PIN_RECORD, BUFFER_MSG_CREATE_RECORD
; BUFFER_MSG_UNPIN_RECORD, BUFFER_MSG_UNPIN_DIRTY_RECORD
; BUFFER_MSG_UNPIN_ACTIVE_RECORD, BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC driver_block_stdio_bin_00

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_EATC, STDIO_MSG_READ
EXTERN STDIO_MSG_GETC, STDIO_MSG_SEEK, STDIO_MSG_FLSH, STDIO_MSG_CLOS

EXTERN db_bin_00_stdio_msg_eatc, db_bin_00_stdio_msg_getc, db_bin_00_stdio_msg_putc
EXTERN db_bin_00_stdio_msg_read, db_bin_00_stdio_msg_seek, db_bin_00_stdio_msg_writ

EXTERN error_enotsup_zc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

driver_block_stdio_bin_00:

   ; enter:
   ;
   ;   ix = FILE *
   ;    a = message id

   cp STDIO_MSG_EATC
   jp z, db_bin_00_stdio_msg_eatc
  
   cp STDIO_MSG_WRIT
   jp z, db_bin_00_stdio_msg_writ

   cp STDIO_MSG_GETC
   jp z, db_bin_00_stdio_msg_getc

   cp STDIO_MSG_READ
   jp z, db_bin_00_stdio_msg_read
  
   cp STDIO_MSG_PUTC
   jp z, db_bin_00_stdio_msg_putc
   
   cp STDIO_MSG_SEEK
   jp z, db_bin_00_stdio_msg_seek
    
   cp STDIO_MSG_CLOS
   ret z                       ; nothing to do for close here
  
   cp STDIO_MSG_FLSH
   ret z                       ; nothing to do for flush here
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state except for ICTL
