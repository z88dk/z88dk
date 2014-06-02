divert(-1)
###############################################################
##             DECLARE STATIC MODULES PART 2                 ##
## sequences crt and statically declares stdin,stdout,stderr ##
###############################################################

# diversion streams are used to re-sequence the crt when it is constructed
#
# divert(1) : header
# divert(2) : startup header
# divert(3) : startup code
# divert(4) : external bss segment (segment_bss_defvars)
# divert(5) : internal bss segment attached (segment_bss_defs)
# divert(6) : external data segment (segment_data_defvars)
# divert(7) : internal data segment attached stored copy (segment_data_s_defb)
# divert(8) : internal data segment attached (segment_data_defb)

###############################################################

dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment stored copy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(7)define(`M4_OPEN_FILE_PTR', 0)dnl
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDIN_DRIVER,0,,`M4_CREATE_FILE_DATA_S_DEFB(STDIN, M4_STDIN_DRIVER, STDIN, M4_FILE_MODE_R, M4_FILE_DF_ITERM_SRELC)
   M4_PUT_SEGMENT_DATA_S_DEFB(M4_STDIN_DRIVER, STDIN, __crt_cfg_edit_buflen, `ifelse(M4_STDOUT_DRIVER,0,0,__FILE_STDOUT)') define(`M4_OPEN_FILE_PTR', __FILE_STDIN)')

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   ifelse(M4_STDOUT_DRIVER,0,,`M4_CREATE_FILE_DATA_S_DEFB(STDOUT, M4_STDOUT_DRIVER, STDOUT, M4_FILE_MODE_W, M4_FILE_DF_OTERM_C)
   M4_PUT_SEGMENT_DATA_S_DEFB(M4_STDOUT_DRIVER, STDOUT, `ifelse(M4_STDIN_DRIVER,0,0,STDIN_`'M4_STDIN_DRIVER`'_file_state)') define(`M4_OPEN_FILE_PTR', __FILE_STDOUT)')
   
   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDERR_DRIVER,0,,`M4_CREATE_FILE_DATA_S_DEFB(STDERR, M4_STDERR_DRIVER, STDERR, M4_FILE_MODE_W, M4_FILE_DF_OTERM_C, 0)
   M4_PUT_SEGMENT_DATA_S_DEFB(M4_STDERR_DRIVER, STDERR, 0) define(`M4_OPEN_FILE_PTR', __FILE_STDERR)')
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment - attached to binary ;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(8)define(`M4_OPEN_FILE_PTR', 0)dnl
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDIN_DRIVER,0,,`M4_CREATE_FILE_DATA_DEFB(STDIN, M4_STDIN_DRIVER, STDIN, M4_FILE_MODE_R, M4_FILE_DF_ITERM_SRELC)
   M4_PUT_SEGMENT_DATA_DEFB(M4_STDIN_DRIVER, STDIN, __crt_cfg_edit_buflen, `ifelse(M4_STDOUT_DRIVER,0,0,__FILE_STDOUT)') define(`M4_OPEN_FILE_PTR', __FILE_STDIN)')

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   ifelse(M4_STDOUT_DRIVER,0,,`M4_CREATE_FILE_DATA_DEFB(STDOUT, M4_STDOUT_DRIVER, STDOUT, M4_FILE_MODE_W, M4_FILE_DF_OTERM_C)
   M4_PUT_SEGMENT_DATA_DEFB(M4_STDOUT_DRIVER, STDOUT, `ifelse(M4_STDIN_DRIVER,0,0,STDIN_`'M4_STDIN_DRIVER`'_file_state)') define(`M4_OPEN_FILE_PTR', __FILE_STDOUT)')

   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDERR_DRIVER,0,,`M4_CREATE_FILE_DATA_DEFB(STDERR, M4_STDERR_DRIVER, STDERR, M4_FILE_MODE_W, M4_FILE_DF_OTERM_C, 0)
   M4_PUT_SEGMENT_DATA_DEFB(M4_STDERR_DRIVER, STDERR, 0) define(`M4_OPEN_FILE_PTR', __FILE_STDERR)')
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment - external ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(6)
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDIN_DRIVER,0,,`M4_CREATE_FILE_DATA_DEFVARS(STDIN, M4_STDIN_DRIVER, STDIN, M4_FILE_MODE_R, M4_FILE_DF_ITERM_SRELC)
   M4_PUT_SEGMENT_DATA_DEFVARS(M4_STDIN_DRIVER, STDIN, __crt_cfg_edit_buflen, `ifelse(M4_STDOUT_DRIVER,0,0,__FILE_STDOUT)')')

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   ifelse(M4_STDOUT_DRIVER,0,,`M4_CREATE_FILE_DATA_DEFVARS(STDOUT, M4_STDOUT_DRIVER, STDOUT, M4_FILE_MODE_W, M4_FILE_DF_OTERM_C)
   M4_PUT_SEGMENT_DATA_DEFVARS(M4_STDOUT_DRIVER, STDOUT, `ifelse(M4_STDIN_DRIVER,0,0,STDIN_`'M4_STDIN_DRIVER`'_file_state)')')

   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDERR_DRIVER,0,,`M4_CREATE_FILE_DATA_DEFVARS(STDERR, M4_STDERR_DRIVER, STDERR, M4_FILE_MODE_W, M4_FILE_DF_OTERM_C, 0)
   M4_PUT_SEGMENT_DATA_DEFVARS(M4_STDERR_DRIVER, STDERR, 0)')
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; bss segment - attached to binary ;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(5)
   ; ----------------------------------------------------------
   ; -- stdin bss segment -------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDIN_DRIVER,0,,`M4_PUT_SEGMENT_BSS_DEFS(M4_STDIN_DRIVER, STDIN, __crt_cfg_edit_buflen, `ifelse(M4_STDOUT_DRIVER,0,0,__FILE_STDOUT)')')

   ; ----------------------------------------------------------
   ; -- stdout bss segment ------------------------------------
   ; ----------------------------------------------------------
   
   ifelse(M4_STDOUT_DRIVER,0,,`M4_PUT_SEGMENT_BSS_DEFS(M4_STDOUT_DRIVER, STDOUT, `ifelse(M4_STDIN_DRIVER,0,0,STDIN_`'M4_STDIN_DRIVER`'_file_state)')')

   ; ----------------------------------------------------------
   ; -- stderr bss segment ------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDERR_DRIVER,0,,`M4_PUT_SEGMENT_BSS_DEFS(M4_STDERR_DRIVER, STDERR, 0)')
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; bss segment - external ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(4)
   ; ----------------------------------------------------------
   ; -- stdin bss segment -------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDIN_DRIVER,0,,`M4_PUT_SEGMENT_BSS_DEFVARS(M4_STDIN_DRIVER, STDIN, __crt_cfg_edit_buflen, `ifelse(M4_STDOUT_DRIVER,0,0,__FILE_STDOUT)')')

   ; ----------------------------------------------------------
   ; -- stdout bss segment ------------------------------------
   ; ----------------------------------------------------------
   
   ifelse(M4_STDOUT_DRIVER,0,,`M4_PUT_SEGMENT_BSS_DEFVARS(M4_STDOUT_DRIVER, STDOUT, `ifelse(M4_STDIN_DRIVER,0,0,STDIN_`'M4_STDIN_DRIVER`'_file_state)')')

   ; ----------------------------------------------------------
   ; -- stderr bss segment ------------------------------------
   ; ----------------------------------------------------------

   ifelse(M4_STDERR_DRIVER,0,,`M4_PUT_SEGMENT_BSS_DEFVARS(M4_STDERR_DRIVER, STDERR, 0)')

divert(-1)

###############################################################
###############################################################
##      CRT CONSTRUCTED BELOW -  FOR MACHINE USE ONLY        ##
###############################################################
###############################################################

divert(0)
dnl
dnl ###########################################################
dnl # HEADER DEFINES
dnl ###########################################################
dnl
undivert(1)
dnl
dnl ###########################################################
dnl # CRT STARTUP HEADER
dnl ###########################################################
dnl
undivert(2)
dnl
dnl ###########################################################
dnl # BSS SEGMENT - EXTERNAL
dnl ###########################################################
dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BSS SEGMENT - EXTERNAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_bss_address > 0
   
   defc __crt_segment_bss_begin = __crt_segment_bss_address

   defvars __crt_segment_bss_begin
   {
   }
   
   undivert(4)

   INCLUDE "../crt_segment_bss_defvars.inc"
   INCLUDE "target_segment_bss_defvars.inc"
   
   defvars -1
   {
      __crt_segment_bss_end
   }

ENDIF

dnl
dnl ###########################################################
dnl # DATA SEGMENT - EXTERNAL
dnl ###########################################################
dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA SEGMENT - EXTERNAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_data_address > 0
   
   defc __crt_segment_data_begin = __crt_segment_data_address
   
   defvars __crt_segment_data_begin
   {
   }

   undivert(6)
   
   INCLUDE "../crt_segment_data_defvars.inc"
   INCLUDE "target_segment_data_defvars.inc"
   
   ; ----------------------------------------------------------
   ; -- stdio -------------------------------------------------
   ; ----------------------------------------------------------
   
   IF __CLIB_OPT_MULTITHREAD & $01
   
      PUBLIC __stdio_file_list_lock
   
      defvars -1
      {
         __stdio_file_list_lock       ds.b 6
      }
      
   ENDIF
   
   PUBLIC __stdio_file_list_open, __stdio_file_list_avail
   PUBLIC __stdio_file_stdin, __stdio_file_stdout, __stdio_file_stderr
   
   defvars -1
   {
      __stdio_file_list_open          ds.w 1
      __stdio_file_list_avail         ds.w 2
      
      __stdio_file_stdin              ds.w 1
      __stdio_file_stdout             ds.w 1
      __stdio_file_stderr             ds.w 1
   }

   defvars -1
   {
      __crt_segment_data_end
   }

ENDIF

dnl
dnl ###########################################################
dnl # CRT STARTUP CODE
dnl ###########################################################
dnl
undivert(3)
dnl
dnl ###########################################################
dnl # DATA SEGMENT - STORED COPY
dnl ###########################################################
dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA SEGMENT - STORED COPY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__crt_segment_data_source_begin:

IF (__crt_cfg_segment_data & 3) = 1

   undivert(7)

   INCLUDE "../crt_segment_data_s_defb.asm"
   INCLUDE "target_segment_data_s_defb.asm"

   ; ----------------------------------------------------------
   ; -- stdio -------------------------------------------------
   ; ----------------------------------------------------------
   
   IF __CLIB_OPT_MULTITHREAD & $01
   
      __stdio_file_list_lock_s:       `defb 0, 1, 0, 254, 0, 0'
 
   ENDIF
   
   __stdio_file_list_open_s:          defw M4_OPEN_FILE_PTR
   __stdio_file_list_avail_s:         defw 0, __stdio_file_list_avail
   
   EXTERN __stdio_badfile
   
   __stdio_file_stdin_s:              defw ifelse(M4_STDIN_DRIVER,0,__stdio_badfile,__FILE_STDIN)
   __stdio_file_stdout_s:             defw ifelse(M4_STDIN_DRIVER,0,__stdio_badfile,__FILE_STDOUT)
   __stdio_file_stderr_s:             defw ifelse(M4_STDIN_DRIVER,0,__stdio_badfile,__FILE_STDERR)

ENDIF

IF (__crt_cfg_segment_data & 3) = 3
   
   BINARY "segment_data_s.bin.zx7"

ENDIF

__crt_segment_data_source_end:

dnl
dnl ###########################################################
dnl # DATA SEGMENT - ATTACHED TO BINARY
dnl ###########################################################
dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA SEGMENT - ATTACHED ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_data_address = 0
   
__crt_segment_data_begin:

   undivert(8)

   INCLUDE "../crt_segment_data_defb.asm"
   INCLUDE "target_segment_data_defb.asm"

   ; ----------------------------------------------------------
   ; -- stdio -------------------------------------------------
   ; ----------------------------------------------------------
   
   IF __CLIB_OPT_MULTITHREAD & $01
   
      PUBLIC __stdio_file_list_lock
   
      __stdio_file_list_lock:         `defb 0, 1, 0, 254, 0, 0'
 
   ENDIF

   PUBLIC __stdio_file_list_open, __stdio_file_list_avail
   PUBLIC __stdio_file_stdin, __stdio_file_stdout, __stdio_file_stderr
   
   __stdio_file_list_open:            defw M4_OPEN_FILE_PTR
   __stdio_file_list_avail:           defw 0, __stdio_file_list_avail
   
   EXTERN __stdio_badfile
   
   __stdio_file_stdin:                defw ifelse(M4_STDIN_DRIVER,0,__stdio_badfile,__FILE_STDIN)
   __stdio_file_stdout:               defw ifelse(M4_STDIN_DRIVER,0,__stdio_badfile,__FILE_STDOUT)
   __stdio_file_stderr:               defw ifelse(M4_STDIN_DRIVER,0,__stdio_badfile,__FILE_STDERR)

__crt_segment_data_end:

ENDIF

dnl
dnl ###########################################################
dnl # BSS SEGMENT - ATTACHED TO BINARY
dnl ###########################################################
dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BSS SEGMENT - ATTACHED ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_bss_address = 0

__crt_segment_bss_begin:

   undivert(5)
   
   INCLUDE "../crt_segment_bss_defs.asm"
   INCLUDE "target_segment_bss_defs.asm"

__crt_segment_bss_end:

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __crt_segment_bss_len, __crt_segment_bss_end, __crt_segment_bss_begin
PUBLIC __crt_segment_data_len, __crt_segment_data_end, __crt_segment_data_begin
PUBLIC __crt_segment_data_source_len, __crt_segment_data_source_end, __crt_segment_data_source_begin

defc __crt_segment_bss_len = __crt_segment_bss_end - __crt_segment_bss_begin
defc __crt_segment_data_len = __crt_segment_data_end - __crt_segment_data_begin
defc __crt_segment_data_source_len = __crt_segment_data_source_end - __crt_segment_data_source_begin
