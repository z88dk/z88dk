


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    zx spectrum crt1                       ;;
;;      generated from target/zx/startup/zx_crt1.m4          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  * Creates global fzx state in variable "_fzx"
;;    This is required by the fzx output driver.
;;
;;  * Creates global "_cons_attr_p" byte to hold a background
;;    colour.  This is required by the fzx output driver.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; #pragma output STACKPTR=nnnnn
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; stdin    : cons_input_kbd_inkey_L1
;; stdout   : cons_output_fzx_L1
;; stderr   : cons_output_fzx_L1
;;
;; fzx font : ff_ao_SoixanteQuatre
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; origin ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IF !myzorg

   defc myzorg = 32768

ENDIF

org myzorg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global symbols ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_symbol.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt configuration ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"
INCLUDE "crt_cfg.asm"
INCLUDE "../crt_cfg_default.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BSS SEGMENT - EXTERNAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_bss_address > 0
   
   defc __crt_segment_bss_begin = __crt_segment_bss_address

   defvars __crt_segment_bss_begin
   {
   }
   
   
   ; ----------------------------------------------------------
   ; -- insert local crt bss segment here ---------------------
   ; ----------------------------------------------------------
   
   defvars -1
   {
      __sp                            ds.w 1
   }

   ; ----------------------------------------------------------
   ; -- stdin bss segment -------------------------------------
   ; ----------------------------------------------------------

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_kbd_inkey_L1, instance = STDIN

   defvars -1
   {
      STDIN_cons_input_kbd_inkey_L1_edit_buffer    ds.b __crt_cfg_edit_buflen
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   ; ----------------------------------------------------------
   ; -- stdout bss segment ------------------------------------
   ; ----------------------------------------------------------
   
   

   ; ----------------------------------------------------------
   ; -- stderr bss segment ------------------------------------
   ; ----------------------------------------------------------

   



   INCLUDE "../crt_segment_bss_defvars.asm"
   INCLUDE "target_segment_bss_defvars.asm"
   
   defvars -1
   {
      __crt_segment_bss_end
   }

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA SEGMENT - EXTERNAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_data_address > 0
   
   defc __crt_segment_data_begin = __crt_segment_data_address
   
   defvars __crt_segment_data_begin
   {
   }

   
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
   
   PUBLIC _fzx
   
   defvars -1
   {
      _fzx                            ds.b 6
   }
   

   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   defvars -1
   {
                                      ds.w 1
      __FILE_STDIN                       ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_kbd_inkey_L1, instance = STDIN

   defvars -1
   {
      STDIN_cons_input_kbd_inkey_L1_file_state	ds.b 14
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   defvars -1
   {
                                      ds.w 1
      __FILE_STDOUT                       ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_fzx_L1, instance = STDOUT

   defvars -1
   {
      STDOUT_cons_output_fzx_L1_file_state	ds.b 4
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   defvars -1
   {
                                      ds.w 1
      __FILE_STDERR                       ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_fzx_L1, instance = STDERR

   defvars -1
   {
      STDERR_cons_output_fzx_L1_file_state	ds.b 4
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   

   
   INCLUDE "../crt_segment_data_defvars.asm"
   INCLUDE "target_segment_data_defvars.asm"
   
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __crt_code_begin, __crt_code_end, __Exit

EXTERN _main, asm_zx_cls

__crt_code_begin:

   push iy                     ; save state required for successful
   exx                         ; return to basic
   push hl
      
   ; crt initialization
   
   INCLUDE "../crt_init.asm"

   ; save stack address for easy exit

   ld (__sp),sp                ; exit() can occur at any value of sp
   
   IF STACKPTR                 ; pragma to locate stack
   
      ld sp,STACKPTR
   
   ENDIF

   ; console initialization
   
   ld a,(__sound_bit_state)
   out (254),a
   
   ld hl,(_cons_attr_p)
   call asm_zx_cls
      
   ; call user program
   
   call _main                  ; hl = return status
   
   ; run exit stack
   
   INCLUDE "../crt_exit.asm"
   
__Exit:

   ; close open files
   
   INCLUDE "../crt_cleanup.asm"
   
   ; exit to host
   
   ld c,l
   ld b,h                      ; bc = return status
   
   ld sp,(__sp)                ; restore original stack
   
   exx
   pop hl                      ; restore hl'
   exx
   pop iy                      ; restore iy
   
   im 1
   
   ei
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt stubs -- library functions not yet implemented ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_stub.asm"

__crt_code_end:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA SEGMENT - STORED COPY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__crt_segment_data_source_begin:

IF (__crt_cfg_segment_data & 3) = 1

   
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------

   _fzx_s:

      EXTERN _ff_ao_SoixanteQuatre

      defw _ff_ao_SoixanteQuatre
      defb 0, 0, 0, 0
      
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   defw 0
   
__FILE_STDIN_s:

   EXTERN cons_input_kbd_inkey_L1
   
   defb 195		; JP instruction
   defw cons_input_kbd_inkey_L1		; address of driver message dispatcher
   defb 0x40		; state_flags_0 = mode byte
   
   IF 0x40 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb 0, 2, 0, 254, 0, 0	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw 0x03b1
      defw STDIN_cons_input_kbd_inkey_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_kbd_inkey_L1, instance = STDIN
   
   STDIN_cons_input_kbd_inkey_L1_file_state_s:
   
      defw __FILE_STDOUT
      defw STDIN_cons_input_kbd_inkey_L1_edit_buffer
      defw STDIN_cons_input_kbd_inkey_L1_edit_buffer
      defb __crt_cfg_edit_buflen
      defb 1
      defb 0
      defb 0
      defw 500
      defw 15
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   defw __FILE_STDIN - 2
   
__FILE_STDOUT_s:

   EXTERN cons_output_fzx_L1
   
   defb 195		; JP instruction
   defw cons_output_fzx_L1		; address of driver message dispatcher
   defb 0x80		; state_flags_0 = mode byte
   
   IF 0x80 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb 0, 2, 0, 254, 0, 0	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw 0x0012
      defw STDOUT_cons_output_fzx_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_fzx_L1, instance = STDOUT
   
   STDOUT_cons_output_fzx_L1_file_state_s:
   
      defw STDIN_cons_input_kbd_inkey_L1_file_state
      defw 0
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
   
   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   defw __FILE_STDOUT - 2
   
__FILE_STDERR_s:

   EXTERN cons_output_fzx_L1
   
   defb 195		; JP instruction
   defw cons_output_fzx_L1		; address of driver message dispatcher
   defb 0x80		; state_flags_0 = mode byte
   
   IF 0x80 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb 0, 2, 0, 254, 0, 0	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw 0x0012
      defw STDERR_cons_output_fzx_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_fzx_L1, instance = STDERR
   
   STDERR_cons_output_fzx_L1_file_state_s:
   
      defw 0
      defw 0
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
   


   INCLUDE "../crt_segment_data_s_defb.asm"
   INCLUDE "target_segment_data_s_defb.asm"

   ; ----------------------------------------------------------
   ; -- stdio -------------------------------------------------
   ; ----------------------------------------------------------
   
   IF __CLIB_OPT_MULTITHREAD & $01
   
      __stdio_file_list_lock_s:       defb 0, 1, 0, 254, 0, 0
 
   ENDIF
   
   __stdio_file_list_open_s:          defw __FILE_STDERR - 2
   __stdio_file_list_avail_s:         defw 0, __stdio_file_list_avail
   
   EXTERN __stdio_badfile
   
   __stdio_file_stdin_s:              defw __FILE_STDIN
   __stdio_file_stdout_s:             defw __FILE_STDOUT
   __stdio_file_stderr_s:             defw __FILE_STDERR

ENDIF

IF (__crt_cfg_segment_data & 3) = 3
   
   BINARY "segment_data_s.bin.zx7"

ENDIF

__crt_segment_data_source_end:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DATA SEGMENT - ATTACHED ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_data_address = 0
   
__crt_segment_data_begin:

   
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
   
   PUBLIC _fzx

   _fzx:

      EXTERN _ff_ao_SoixanteQuatre

      defw _ff_ao_SoixanteQuatre
      defb 0, 0, 0, 0
      
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   defw 0
   
__FILE_STDIN:

   EXTERN cons_input_kbd_inkey_L1
   
   defb 195		; JP instruction
   defw cons_input_kbd_inkey_L1		; address of driver message dispatcher
   defb 0x40		; state_flags_0 = mode byte
   
   IF 0x40 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb 0, 2, 0, 254, 0, 0	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw 0x03b1
      defw STDIN_cons_input_kbd_inkey_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_kbd_inkey_L1, instance = STDIN
   
   STDIN_cons_input_kbd_inkey_L1_file_state:
   
      defw __FILE_STDOUT
      defw STDIN_cons_input_kbd_inkey_L1_edit_buffer
      defw STDIN_cons_input_kbd_inkey_L1_edit_buffer
      defb __crt_cfg_edit_buflen
      defb 1
      defb 0
      defb 0
      defw 500
      defw 15
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   defw __FILE_STDIN - 2
   
__FILE_STDOUT:

   EXTERN cons_output_fzx_L1
   
   defb 195		; JP instruction
   defw cons_output_fzx_L1		; address of driver message dispatcher
   defb 0x80		; state_flags_0 = mode byte
   
   IF 0x80 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb 0, 2, 0, 254, 0, 0	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw 0x0012
      defw STDOUT_cons_output_fzx_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_fzx_L1, instance = STDOUT
   
   STDOUT_cons_output_fzx_L1_file_state:
   
      defw STDIN_cons_input_kbd_inkey_L1_file_state
      defw 0
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   defw __FILE_STDOUT - 2
   
__FILE_STDERR:

   EXTERN cons_output_fzx_L1
   
   defb 195		; JP instruction
   defw cons_output_fzx_L1		; address of driver message dispatcher
   defb 0x80		; state_flags_0 = mode byte
   
   IF 0x80 & 0x40
   
      defb 0x02         ; state_flags_1 = make last operation a read
   
   ELSE
   
      defb 0            ; state_flags_1 = make last operation a write
   
   ENDIF
   
   defb 0		; printf conversion flags
   defb 0		; ungetc
   defb 0, 2, 0, 254, 0, 0	; recursive mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
   
      defw 0x0012
      defw STDERR_cons_output_fzx_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_fzx_L1, instance = STDERR
   
   STDERR_cons_output_fzx_L1_file_state:
   
      defw 0
      defw 0
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
   


   INCLUDE "../crt_segment_data_defb.asm"
   INCLUDE "target_segment_data_defb.asm"

   ; ----------------------------------------------------------
   ; -- stdio -------------------------------------------------
   ; ----------------------------------------------------------
   
   IF __CLIB_OPT_MULTITHREAD & $01
   
      PUBLIC __stdio_file_list_lock
   
      __stdio_file_list_lock:         defb 0, 1, 0, 254, 0, 0
 
   ENDIF

   PUBLIC __stdio_file_list_open, __stdio_file_list_avail
   PUBLIC __stdio_file_stdin, __stdio_file_stdout, __stdio_file_stderr
   
   __stdio_file_list_open:            defw __FILE_STDERR - 2
   __stdio_file_list_avail:           defw 0, __stdio_file_list_avail
   
   EXTERN __stdio_badfile
   
   __stdio_file_stdin:                defw __FILE_STDIN
   __stdio_file_stdout:               defw __FILE_STDOUT
   __stdio_file_stderr:               defw __FILE_STDERR

__crt_segment_data_end:

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BSS SEGMENT - ATTACHED ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_bss_address = 0

__crt_segment_bss_begin:

   
   ; ----------------------------------------------------------
   ; -- insert local crt bss segment here ---------------------
   ; ----------------------------------------------------------

   __sp:                              defs 2
   

   ; ----------------------------------------------------------
   ; -- stdin bss segment -------------------------------------
   ; ----------------------------------------------------------

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_kbd_inkey_L1, instance = STDIN

   STDIN_cons_input_kbd_inkey_L1_edit_buffer:      defs __crt_cfg_edit_buflen
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   ; ----------------------------------------------------------
   ; -- stdout bss segment ------------------------------------
   ; ----------------------------------------------------------
   
   

   ; ----------------------------------------------------------
   ; -- stderr bss segment ------------------------------------
   ; ----------------------------------------------------------

   
   

   
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

