


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        cpm crt0                           ;;
;;     generated from target/cpm/startup/cpm_crt0.m4         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; stdin    : cons_input_bdos_6_L1
;; stdout   : cons_output_bdos_2_L1
;; stderr   : cons_output_bdos_2_L1
;;
;; fzx font : M4_FZX_FONT
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; #pragma output noprotectmsdos
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; origin ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

org $100

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
   }

   ; ----------------------------------------------------------
   ; -- stdin bss segment -------------------------------------
   ; ----------------------------------------------------------

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_bdos_6_L1, instance = STDIN

   defvars -1
   {
      STDIN_cons_input_bdos_6_L1_edit_buffer    ds.b __crt_cfg_edit_buflen
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
   
   defvars -1
   {
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
   ;; driver = cons_input_bdos_6_L1, instance = STDIN

   defvars -1
   {
      STDIN_cons_input_bdos_6_L1_file_state	ds.b 7
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
   ;; driver = cons_output_bdos_2_L1, instance = STDOUT

   defvars -1
   {
      STDOUT_cons_output_bdos_2_L1_file_state	ds.b 2
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
   ;; driver = cons_output_bdos_2_L1, instance = STDERR

   defvars -1
   {
      STDERR_cons_output_bdos_2_L1_file_state	ds.b 2
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

EXTERN _main, asm_isspace

__crt_code_begin:

   IF !DEFINED_noprotectmsdos

      defb $eb, $04            ; DOS protection... JMPS LABE
      ex de, hl
      jp __begin
      
      defb $b4, $09            ; DOS protection... MOV AH,9
      defb $ba
      defw dosmessage          ; DOS protection... MOV DX,OFFSET dosmessage
      defb $cd, $21            ; DOS protection... INT 21h.
      defb $cd, $20            ; DOS protection... INT 20h.

   dosmessage:

      defm "This program is for a CP/M system."
      defb 13, 10, '$'

__begin:

   ENDIF

   ; crt initialization
   
   INCLUDE "../crt_init.asm"

   ld sp,($0006)               ; set SP just below FDOS

   ; Command line arguments - push points to argv[n] onto the stack

   ld hl,0                     ; NULL pointer at end, just in case
   push hl
   
   ld b,l
   ld hl,$80
   
   ld a,(hl)
   or a
   jr z, argv_done

   ld c,a
   add hl,bc                   ; now points to the end
   
   ; Try to find the end of the arguments

argv_loop_1:

   ld a,(hl)
   
   call asm_isspace
   jr c, argv_loop_2
   
   ld (hl),0
   dec hl
   
   dec c
   jr nz, argv_loop_1

   ; We've located the end of the last argument, try to find the start

argv_loop_2:

   ld a,(hl)
   
   call asm_isspace
   jr c, argv_loop_3
   
   inc hl
   
   ; TODO: Redirection (when we have file i/o)

   push hl
   
   inc b
   dec hl

   ; skip extra blanks

argv_zloop:

   ld (hl),0
   
   dec c
   jr z, argv_done
   
   dec hl
   ld a,(hl)
   
   call asm_isspace
   jr nc, argv_zloop
   
   inc c
   inc hl

argv_loop_3:

   dec hl
   dec c
   jr nz, argv_loop_2

argv_done:

   ld hl,__null_string + 1     ; name of program (NULL)
   push hl
   
   inc b

__null_string:

   ld hl,0
   add hl,sp                   ; address of argv
   
   ld c,b
   ld b,0

   ; call user program

   IF __SDCC | __SDCC_IX | __SDCC_IY
   
      push hl                 ; argv
      push bc                 ; argc
   
   ELSE

      push bc                 ; argc
      push hl                 ; argv
   
   ENDIF
   
   call _main                 ; hl holds return status

   ; run exit stack
   
   INCLUDE "../crt_exit.asm"
   
__Exit:

   ; close open files
   
   INCLUDE "../crt_cleanup.asm"

   ; exit to host

   rst 0

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
      
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   defw 0
   
__FILE_STDIN_s:

   EXTERN cons_input_bdos_6_L1
   
   defb 195		; JP instruction
   defw cons_input_bdos_6_L1		; address of driver message dispatcher
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
      defw STDIN_cons_input_bdos_6_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_bdos_6_L1, instance = STDIN
   
   STDIN_cons_input_bdos_6_L1_file_state_s:
   
      defw __FILE_STDOUT
      defw STDIN_cons_input_bdos_6_L1_edit_buffer
      defw STDIN_cons_input_bdos_6_L1_edit_buffer
      defb __crt_cfg_edit_buflen
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   defw __FILE_STDIN - 2
   
__FILE_STDOUT_s:

   EXTERN cons_output_bdos_2_L1
   
   defb 195		; JP instruction
   defw cons_output_bdos_2_L1		; address of driver message dispatcher
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
      defw STDOUT_cons_output_bdos_2_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_bdos_2_L1, instance = STDOUT
   
   STDOUT_cons_output_bdos_2_L1_file_state_s:
   
      defw STDIN_cons_input_bdos_6_L1_file_state
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
   
   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   defw __FILE_STDOUT - 2
   
__FILE_STDERR_s:

   EXTERN cons_output_bdos_2_L1
   
   defb 195		; JP instruction
   defw cons_output_bdos_2_L1		; address of driver message dispatcher
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
      defw STDERR_cons_output_bdos_2_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_bdos_2_L1, instance = STDERR
   
   STDERR_cons_output_bdos_2_L1_file_state_s:
   
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
      
   ; ----------------------------------------------------------
   ; -- stdin data segment ------------------------------------
   ; ----------------------------------------------------------

   defw 0
   
__FILE_STDIN:

   EXTERN cons_input_bdos_6_L1
   
   defb 195		; JP instruction
   defw cons_input_bdos_6_L1		; address of driver message dispatcher
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
      defw STDIN_cons_input_bdos_6_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_bdos_6_L1, instance = STDIN
   
   STDIN_cons_input_bdos_6_L1_file_state:
   
      defw __FILE_STDOUT
      defw STDIN_cons_input_bdos_6_L1_edit_buffer
      defw STDIN_cons_input_bdos_6_L1_edit_buffer
      defb __crt_cfg_edit_buflen
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

   ; ----------------------------------------------------------
   ; -- stdout data segment -----------------------------------
   ; ----------------------------------------------------------
   
   defw __FILE_STDIN - 2
   
__FILE_STDOUT:

   EXTERN cons_output_bdos_2_L1
   
   defb 195		; JP instruction
   defw cons_output_bdos_2_L1		; address of driver message dispatcher
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
      defw STDOUT_cons_output_bdos_2_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_bdos_2_L1, instance = STDOUT
   
   STDOUT_cons_output_bdos_2_L1_file_state:
   
      defw STDIN_cons_input_bdos_6_L1_file_state
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

   ; ----------------------------------------------------------
   ; -- stderr data segment -----------------------------------
   ; ----------------------------------------------------------

   defw __FILE_STDOUT - 2
   
__FILE_STDERR:

   EXTERN cons_output_bdos_2_L1
   
   defb 195		; JP instruction
   defw cons_output_bdos_2_L1		; address of driver message dispatcher
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
      defw STDERR_cons_output_bdos_2_L1_file_state
      
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 4
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_output_bdos_2_L1, instance = STDERR
   
   STDERR_cons_output_bdos_2_L1_file_state:
   
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
   

   ; ----------------------------------------------------------
   ; -- stdin bss segment -------------------------------------
   ; ----------------------------------------------------------

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = cons_input_bdos_6_L1, instance = STDIN

   STDIN_cons_input_bdos_6_L1_edit_buffer:      defs __crt_cfg_edit_buflen
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

