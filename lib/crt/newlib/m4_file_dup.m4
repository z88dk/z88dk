dnl############################################################
dnl##                   DUP INSTANTIATOR                     ##
dnl############################################################
dnl##                                                        ##
dnl## m4_file_dup(...)                                       ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = FILE.state_flags_0 (file type and mode)           ##
dnl## $3 = label assigned to FDSTRUCT being duped            ##
dnl##                                                        ##
dnl############################################################
dnl
define(`m4_file_dup',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; DUPED FILE DESCRIPTOR
   ;
   ; FILE  : `ifelse($1,0,`(none)', $1)'
   ; flags : $2
   ;
   ; fd    : __I_FCNTL_NUM_FD
   ; dup fd: $3
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
      
      ; jump to duped fd
      
      defb 195
      defw $3

      ; state_flags_0
      ; state_flags_1
      ; conversion flags
      ; ungetc

      defb $2
      defb `eval(($2 >> 5) & 2)'
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
   defw $3
   
   ; FDSTRUCT structure
   
   defc __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD = $3
   
   ; adjust reference count on duped FDSTRUCT
   
   SECTION code_crt_init
   
   `ld hl,$3 + 7'     ; & FDSTRUCT.ref_count
   `inc (hl)'
   `ifelse($1,0,,`inc (hl)')'

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)dnl
