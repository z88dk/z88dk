include(`z88dk.m4')

dnl############################################################
dnl##      YAZ180_CRT_256.ASM.M4 - NO DRIVERS TARGET         ##
dnl############################################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                yaz180 standalone target                   ;;
;; generated from target/yaz180/startup/yaz180_crt_256.asm.m4;;
;;                                                           ;;
;;                  flat 64k address space                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SYMBOLS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "config_yaz180_public.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT AND CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_defaults.inc"
include "crt_config.inc"
include(`../crt_rules.inc')
include(`yaz180_rules.inc')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SET UP MEMORY MAP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`crt_memory_map.inc')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSTANTIATE DRIVERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
dnl############################################################
dnl## LIST OF AVAILABLE DRIVERS WITH STATIC INSTANTIATORS #####
dnl############################################################
dnl
dnl## input terminals
dnl
dnl#include(`driver/terminal/rc_01_input_asci0.m4')
dnl#include(`driver/terminal/rc_01_input_asci1.m4')
dnl
dnl## output terminals
dnl
dnl#include(`driver/terminal/rc_01_output_asci0.m4')
dnl#include(`driver/terminal/rc_01_output_asci1.m4')
dnl
dnl## file dup
dnl
dnl#include(`../m4_file_dup.m4')
dnl
dnl## empty fd slot
dnl
dnl#include(`../m4_file_absent.m4')
dnl
dnl############################################################
dnl## INSTANTIATE DRIVERS #####################################
dnl############################################################
dnl

include(`../clib_instantiate_begin.m4')

ifelse(eval(M4__CRT_INCLUDE_DRIVER_INSTANTIATION == 0), 1,,
`
   include(`crt_driver_instantiation.asm.m4')
')

include(`../clib_instantiate_end.m4')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

PUBLIC __Start, __Exit

EXTERN _main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; USER PREAMBLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_include_preamble

   include "crt_preamble.asm"
   SECTION CODE

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PAGE ZERO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF (__crt_org_code = 0) && !(__page_zero_present)

   include "../crt_page_zero_z180.inc"

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT INIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_crt_start         ; system initialization

__Start:

   include "../crt_start_di.inc"
   include "../crt_save_sp.inc"

__Restart:

   include "../crt_init_sp.inc"

   ; command line

IF (__crt_enable_commandline = 1) || (__crt_enable_commandline >= 3)

   include "../crt_cmdline_empty.inc"

ENDIF

__Restart_2:

IF __crt_enable_commandline >= 1

   push hl                     ; argv
   push bc                     ; argc

ENDIF

   ; initialize data section

   include "../clib_init_data.inc"

   ; initialize bss section

   include "../clib_init_bss.inc"

   ; interrupt mode

   include "../crt_set_interrupt_mode.inc"

SECTION code_crt_init          ; user and library initialization

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_crt_main

   include "../crt_start_ei.inc"

   ; call user program

   call _main                  ; hl = return status

   ; run exit stack

IF __clib_exit_stack_size > 0

   EXTERN asm_exit
   jp asm_exit                 ; exit function jumps to __Exit

ENDIF

__Exit:

IF !((__crt_on_exit & 0x10000) && (__crt_on_exit & 0x8))

   ; not restarting

   push hl                     ; save return status

ENDIF

SECTION code_crt_exit          ; user and library cleanup
SECTION code_crt_return

   ; close files

   include "../clib_close.inc"

   ; terminate

   include "../crt_exit_eidi.inc"
   include "../crt_restore_sp.inc"
   include "../crt_program_exit.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUNTIME VARS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_jump_vectors_z180.inc"
include "../crt_interrupt_vectors_z180.inc"

IF (__crt_on_exit & 0x10000) && ((__crt_on_exit & 0x6) || ((__crt_on_exit & 0x8) && (__register_sp = -1)))

   SECTION BSS_UNINITIALIZED
   __sp_or_ret:  defw 0

ENDIF

include "../clib_variables.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLIB STUBS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../clib_stubs.inc"
