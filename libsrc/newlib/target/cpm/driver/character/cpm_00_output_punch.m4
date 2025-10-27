dnl############################################################
dnl##       CPM_00_OUTPUT_PUNCH STATIC INSTANTIATOR          ##
dnl############################################################
dnl##                                                        ##
dnl## m4_cpm_00_output_punch(...)                            ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = ioctl_flags (16 bits)                             ##
dnl##                                                        ##
dnl############################################################

define(`m4_cpm_00_output_punch',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE  : `ifelse($1,0,`(none)',$1)'
   ;
   ; driver: cpm_00_output_punch
   ; fd    : __I_FCNTL_NUM_FD
   ; mode  : write only
   ; type  : 004 = character output
   ;
   ; ioctl_flags   : $2
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

      defb 0x80         ; write + normal file type
      defb 0            ; last operation was write
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
   
   EXTERN console_01_output_terminal_fdriver
   EXTERN cpm_00_output_punch
   
   __i_fcntl_heap_`'__I_FCNTL_NUM_HEAP:
   
      ; heap header
      
      defw __i_fcntl_heap_`'incr(__I_FCNTL_NUM_HEAP)
      defw 23
      defw ifelse(__I_FCNTL_NUM_HEAP,0,0,__i_fcntl_heap_`'decr(__I_FCNTL_NUM_HEAP))

   __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD:
   
      ; FDSTRUCT structure
      
      ; call to first entry to driver
      
      defb 205
      defw console_01_output_terminal_fdriver
      
      ; jump to driver
      
      defb 195
      defw cpm_00_output_punch
      
      ; flags
      ; reference_count
      ; mode_byte
      
      defb 0x04      ; type = character output
      defb `ifelse($1,0,1,2)'
      defb 0x02      ; write only
      
      ; ioctl_flags
      
      defw $2
      
      ; mtx_plain
      
      defb 0         ; thread owner = none
      defb 0x01      ; mtx_plain
      defb 0         ; lock count = 0
      defb 0xfe      ; atomic spinlock
      defw 0         ; list of blocked threads

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   `define(`__I_FCNTL_HEAP_SIZE', eval(__I_FCNTL_HEAP_SIZE + 23))'dnl
   `define(`__I_FCNTL_NUM_HEAP', incr(__I_FCNTL_NUM_HEAP))'dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)dnl
