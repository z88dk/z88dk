dnl############################################################
dnl##        VGL_CRT_0.ASM.M4 - V-TECH GENIUS LEADER         ##
dnl############################################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 V-Tech Genius Leader target               ;;
;;    generated from target/vgl/startup/vgl_crt_0.asm.m4     ;;
;;                                                           ;;
;;                      RAM payload                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SYMBOLS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This will be a file containing all the defined constants from the config directory.  When the library is built, the file will be generated.
include "config_vgl_public.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT AND CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_defaults.inc"
include "crt_config.inc"
include(`../crt_rules.inc')

; This file will process target-specific pragmas, of which you will initially have none.
include(`vgl_rules.inc')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SET UP MEMORY MAP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "crt_memory_map.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSTANTIATE DRIVERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


dnl############################################################
dnl## LIST OF AVAILABLE DRIVERS WITH STATIC INSTANTIATORS #####
dnl############################################################
dnl
dnl## input terminals
dnl
dnl#include(`driver/character/vgl_00_input_char.m4')dnl
dnl#include(`driver/terminal/vgl_01_input_kbd.m4')dnl
dnl
dnl## output terminals
dnl
dnl#include(`driver/character/vgl_00_output_char.m4')dnl
dnl#include(`driver/terminal/vgl_01_output_char.m4')dnl
dnl
dnl## file dup
dnl
dnl#include(`../m4_file_dup.m4')dnl
dnl
dnl## empty fd slot
dnl
dnl---dnl
dnl
dnl############################################################
dnl## INSTANTIATE DRIVERS #####################################
dnl############################################################


dnl	include(`../clib_instantiate_begin.m4')
dnl	
dnl	ifelse(eval(M4__CRT_INCLUDE_DRIVER_INSTANTIATION == 0), 1,
dnl	`
dnl	   include(`../m4_file_absent.m4')dnl
dnl	   m4_file_absentdnl
dnl	   
dnl	   include(`../m4_file_absent.m4')dnl
dnl	   m4_file_absentdnl
dnl	   
dnl	   include(`../m4_file_absent.m4')dnl
dnl	   m4_file_absentdnl
dnl	',
dnl	`
dnl	   include(`crt_driver_instantiation.asm.m4')
dnl	')
dnl	
dnl	include(`../clib_instantiate_end.m4')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

PUBLIC __Start, __Exit

EXTERN _main


dnl	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl	;; ROM SIGNATURE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl	
dnl	; The signature must be the first few bytes in ROM
dnl	SECTION CODE
dnl	include(`startup/vgl_signature_code.inc')


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; USER PREAMBLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_include_preamble

   include "crt_preamble.asm"
   SECTION CODE

ENDIF

dnl	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl	;; PAGE ZERO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl	
dnl	IF (ASMPC = 0) && (__crt_org_code = 0)
dnl	
dnl	   include "../crt_page_zero_z80.inc"
dnl	
dnl	ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT INIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


__Start:

dnl	   include "../crt_start_di.inc"
dnl	   include "../crt_save_sp.inc"

__Restart:

;   include "../crt_init_sp.inc"
   
dnl	   ; command line
dnl	   
dnl	   IF (__crt_enable_commandline = 1) || (__crt_enable_commandline >= 3)
dnl	   
dnl	      include "../crt_cmdline_empty.inc"
dnl	   
dnl	   ENDIF

__Restart_2:

dnl	   IF __crt_enable_commandline >= 1
dnl	
dnl	      push hl                  ; argv
dnl	      push bc                  ; argc
dnl	
dnl	   ENDIF

   ; initialize data section

   include "../clib_init_data.inc"

   ; initialize bss section

   include "../clib_init_bss.inc"

   ; interrupt mode
   
   include "../crt_set_interrupt_mode.inc"

SECTION code_crt_init          ; user and library initialization

   ; Prepare hardware (timers etc.)
   
   
SECTION code_crt_main

dnl	   include "../crt_start_ei.inc"

   ; call user program
   
dnl   call _main                  ; hl = return status
   jp _main                  ; hl = return status

   ; run exit stack

dnl	   IF __clib_exit_stack_size > 0
dnl	   
dnl	      EXTERN asm_exit
dnl	      jp asm_exit              ; exit function jumps to __Exit
dnl	   
dnl	   ENDIF

__Exit:

dnl	   IF !((__crt_on_exit & 0x10000) && (__crt_on_exit & 0x8))
dnl	   
dnl	      ; not restarting
dnl	      
dnl	      push hl                  ; save return status
dnl	   
dnl	   ENDIF

SECTION code_crt_exit          ; user and library cleanup
SECTION code_crt_return

dnl	   ; close files
dnl	   
dnl	   include "../clib_close.inc"
dnl	
dnl	   ; terminate
dnl	   
dnl	   include "../crt_exit_eidi.inc"
dnl	   include "../crt_restore_sp.inc"
dnl	   include "../crt_program_exit.inc"      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUNTIME VARS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_jump_vectors_z80.inc"

IF (__crt_on_exit & 0x10000) && ((__crt_on_exit & 0x6) || ((__crt_on_exit & 0x8) && (__register_sp = -1)))

   SECTION BSS_UNINITIALIZED
   __sp_or_ret:  defw 0

ENDIF

dnl	include "../clib_variables.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLIB STUBS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dnl	include "../clib_stubs.inc"
