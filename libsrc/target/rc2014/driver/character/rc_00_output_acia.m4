dnl############################################################
dnl##         RC_00_OUTPUT_ACIA STATIC INSTANTIATOR          ##
dnl############################################################
dnl##                                                        ##
dnl## m4_rc_00_output_acia(...)                              ##
dnl##                                                        ##
dnl## Simplified character_00 serial output. Re-entrant.     ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = ioctl_flags (16 bits)                             ##
dnl##                                                        ##
dnl############################################################

define(`m4_rc_00_output_acia',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE  : `ifelse($1,0,`(none)',$1)'
   ;
   ; driver: rc_00_output_acia
   ; fd    : __I_FCNTL_NUM_FD
   ; mode  : write only
   ; type  : 004 = character output
   ;
   ; ioctl_flags   : $2
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   `ifelse($1,0,,dnl   
   
   SECTION data_clib
   SECTION data_stdio
      
   PUBLIC $1
      
   $1:  defw __i_stdio_file_`'__I_STDIO_NUM_FILE + 2
   
   __i_stdio_file_`'__I_STDIO_NUM_FILE:
   
      defw ifelse(__I_STDIO_NUM_FILE,0,0,__i_stdio_file_`'decr(__I_STDIO_NUM_FILE))
      
      defb 195
      defw __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD

      defb 0x80         ; write + normal file type
      defb 0            ; last operation was write
      defb 0
      defb 0
      
      defb 0
      defb 0x02
      defb 0
      defb 0xfe
      defw 0
    
   `define(`__I_STDIO_NUM_FILE', incr(__I_STDIO_NUM_FILE))'dnl
   )'dnl
   
   SECTION data_fcntl_fdtable_body
   defw __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD

   SECTION data_fcntl_stdio_heap_body
   
   EXTERN console_01_output_terminal_fdriver
   EXTERN rc_00_output_acia
   
   __i_fcntl_heap_`'__I_FCNTL_NUM_HEAP:
   
      defw __i_fcntl_heap_`'incr(__I_FCNTL_NUM_HEAP)
      defw 23
      defw ifelse(__I_FCNTL_NUM_HEAP,0,0,__i_fcntl_heap_`'decr(__I_FCNTL_NUM_HEAP))

   __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD:
   
      defb 205
      defw console_01_output_terminal_fdriver
      
      defb 195
      defw rc_00_output_acia
      
      defb 0x04      ; type = character output
      defb `ifelse($1,0,1,2)'
      defb 0x02      ; write only
      
      defw $2
      
      defb 0
      defb 0x01
      defb 0
      defb 0xfe
      defw 0

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   `define(`__I_FCNTL_HEAP_SIZE', eval(__I_FCNTL_HEAP_SIZE + 23))'dnl
   `define(`__I_FCNTL_NUM_HEAP', incr(__I_FCNTL_NUM_HEAP))'dnl

)dnl
