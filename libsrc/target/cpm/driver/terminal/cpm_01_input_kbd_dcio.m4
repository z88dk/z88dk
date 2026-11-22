dnl############################################################
dnl##      CPM_01_INPUT_KBD_DCIO STATIC INSTANTIATOR         ##
dnl############################################################
dnl##                                                        ##
dnl## m4_cpm_01_input_kbd_dcio(...)                          ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = label attached to output FDSTRUCT or 0 if none    ##
dnl## $3 = ioctl_flags (16 bits)                             ##
dnl## $4 = size of edit buffer attached to FDSTRUCT or 0     ##
dnl##                                                        ##
dnl############################################################

define(`m4_cpm_01_input_kbd_dcio',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE  : `ifelse($1,0,`(none)',$1)'
   ;
   ; driver: cpm_01_input_kbd_dcio
   ; fd    : __I_FCNTL_NUM_FD
   ; mode  : read only
   ; type  : 001 = input terminal
   ; tie   : `ifelse($2,0,`(none)',$2)'
   ;
   ; ioctl_flags   : $3
   ; buffer size   : $4 bytes
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   `ifelse($1,0,,dnl
   
   SECTION data_clib
   SECTION data_stdio
   
   ; FILE *
      
   PUBLIC $1
      
   $1:  defw __i_stdio_file_`'__I_STDIO_NUM_FILE + 2
   
   ; FILE structure
   
   __i_stdio_file_`'__I_STDIO_NUM_FILE:
   
      ; open files link
      
      defw ifelse(__I_STDIO_NUM_FILE,0,0,__i_stdio_file_`'decr(__I_STDIO_NUM_FILE))
      
      ; jump to underlying fd
      
      defb 195
      defw __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD

      ; state_flags_0
      ; state_flags_1
      ; conversion flags
      ; ungetc

      defb 0x40      ; read + stdio manages ungetc + normal file type
      defb 0x02      ; last operation was read
      defb 0
      defb 0
      
      ; mtx_recursive
      
      defb 0         ; thread owner = none
      defb 0x02      ; mtx_recursive
      defb 0         ; lock count = 0
      defb 0xfe      ; atomic spinlock
      defw 0         ; list of blocked threads
    
   `define(`__I_STDIO_NUM_FILE', incr(__I_STDIO_NUM_FILE))'dnl
   )'dnl
   
   ; fd table entry
   
   SECTION data_fcntl_fdtable_body
   defw __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD

   ; FDSTRUCT structure
   
   SECTION data_fcntl_stdio_heap_body
   
   EXTERN console_01_input_terminal_fdriver
   EXTERN cpm_01_input_kbd_dcio
   
   __i_fcntl_heap_`'__I_FCNTL_NUM_HEAP:
   
      ; heap header
      
      defw __i_fcntl_heap_`'incr(__I_FCNTL_NUM_HEAP)
      defw `eval($4 + 34)'
      defw ifelse(__I_FCNTL_NUM_HEAP,0,0,__i_fcntl_heap_`'decr(__I_FCNTL_NUM_HEAP))
   
   __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD:

      ; FDSTRUCT structure
      
      ; call to first entry to driver
      
      defb 205
      defw console_01_input_terminal_fdriver
      
      ; jump to driver
      
      defb 195
      defw cpm_01_input_kbd_dcio
      
      ; flags
      ; reference_count
      ; mode_byte
      
      defb 0x01      ; stdio handles ungetc + type = input terminal
      defb `ifelse($1,0,1,2)'
      defb 0x01      ; read only
      
      ; ioctl_flags
      
      defw $3
      
      ; mtx_plain
      
      defb 0         ; thread owner = none
      defb 0x01      ; mtx_plain
      defb 0         ; lock count = 0
      defb 0xfe      ; atomic spinlock
      defw 0         ; list of blocked threads

      ; tied output terminal
      ; pending_char
      ; read_index
      
      defw `ifelse($2,0,0,$2)'
      defb 0
      defw 0
      
      ; b_array_t edit_buffer
      
      defw `ifelse($4,0,0,__edit_buffer_`'__I_FCNTL_NUM_FD)'
      defw 0
      defw $4
      
      `ifelse($4,0,,dnl
      
      ; reserve space for edit buffer
      
      __edit_buffer_`'__I_FCNTL_NUM_FD:   defs $4
      )'

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   `define(`__I_FCNTL_HEAP_SIZE', eval(__I_FCNTL_HEAP_SIZE + $4 + 34))'dnl
   `define(`__I_FCNTL_NUM_HEAP', incr(__I_FCNTL_NUM_HEAP))'dnl
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)dnl
