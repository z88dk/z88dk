dnl############################################################
dnl##   ZX_01_OUTPUT_CHAR_64_TTY_Z88DK STATIC INSTANTIATOR   ##
dnl############################################################
dnl##                                                        ##
dnl## m4_zx_01_output_char_64_tty_z88dk(...)                 ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = ioctl_flags (16 bits)                             ##
dnl## $3 = cursor.x coordinate                               ##
dnl## $4 = cursor.y coordinate                               ##
dnl## $5 = window.x coordinate (must be even)                ##
dnl## $6 = window.width (must be even)                       ##
dnl## $7 = window.y coordinate                               ##
dnl## $8 = window.height                                     ##
dnl## $9 = scroll limit (number of scrolls until pause)      ##
dnl## $10 = font address                                     ##
dnl## $11 = foreground colour (text attribute)               ##
dnl## $12 = foreground mask (set bits = keep screen bits)    ##
dnl## $13 = background colour (cls attribute)                ##
dnl##                                                        ##
dnl############################################################

define(`m4_zx_01_output_char_64_tty_z88dk',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE  : `ifelse($1,0,`(none)',$1)'
   ;
   ; driver: zx_01_output_char_64_tty_z88dk
   ; fd    : __I_FCNTL_NUM_FD
   ; mode  : write only
   ; type  : 002 = output terminal
   ;
   ; ioctl_flags   : $2
   ; cursor coord  : `($3,$4)'
   ; window        : `(eval($5 & 254),eval($6 & 254),$7,$8)'
   ; scroll limit  : $9
   ; font address  : $10
   ; text colour   : $11
   ; text mask     : $12
   ; background    : $13
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
   EXTERN zx_01_output_char_64_tty_z88dk
   
   __i_fcntl_heap_`'__I_FCNTL_NUM_HEAP:
   
      ; heap header
      
      defw __i_fcntl_heap_`'incr(__I_FCNTL_NUM_HEAP)
      defw 41
      defw ifelse(__I_FCNTL_NUM_HEAP,0,0,__i_fcntl_heap_`'decr(__I_FCNTL_NUM_HEAP))

   __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD:
   
      ; FDSTRUCT structure
      
      ; call to first entry to driver
      
      defb 205
      defw console_01_output_terminal_fdriver
      
      ; jump to driver
      
      defb 195
      defw zx_01_output_char_64_tty_z88dk
      
      ; flags
      ; reference_count
      ; mode_byte
      
      defb 0x02      ; type = output terminal
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

      ; cursor coordinate
      ; window rectangle
      ; scroll limit

      defb `$3, $4'
      defb `eval($5 & 254), eval($6 & 254), $7, $8'
      defb $9
      
      ; font address
      ; text colour
      ; text mask
      ; background colour
      
      EXTERN $10
      
      defw $10 - 256
      defb $11
      defb $12
      defb $13
      
      ; tty_z88dk
      
      EXTERN asm_tty_state_0
      
      defb 205                 ; call
      defw asm_tty_state_0     ; start state of tty state machine
      defb 0
      defb `0,0'                 ; parameters

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   `define(`__I_FCNTL_HEAP_SIZE', eval(__I_FCNTL_HEAP_SIZE + 41))'dnl
   `define(`__I_FCNTL_NUM_HEAP', incr(__I_FCNTL_NUM_HEAP))'dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)dnl
