divert(-1)
###############################################################
##        CPM_CRT0.M4 - GENERATOR FOR CPM_CRT0.ASM           ##
##         customize by editing the options below            ##
###############################################################

include(`../../crt_declare_static_module_head.m4')

###############################################################
##                       OPTIONS                             ##
###############################################################

## select drivers for the standard streams, set to zero to omit

define(`M4_STDIN_DRIVER', cons_input_bdos_6_L1)
define(`M4_STDOUT_DRIVER', cons_output_bdos_2_L1)
define(`M4_STDERR_DRIVER', cons_output_bdos_2_L1)

## include macros for all supported drivers on zx target
## only drivers that do not acquire host resources can be
## statically allocated and should be listed here

include(`../driver/terminal/cons_input_bdos_6_L1/cons_input_bdos_6_L1.m4')
include(`../driver/terminal/cons_output_bdos_2_L1/cons_output_bdos_2_L1.m4')

##                                                           ##
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

divert(2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        cpm crt0                           ;;
;;     generated from target/cpm/startup/cpm_crt0.m4         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; stdin    : M4_STDIN_DRIVER
;; stdout   : M4_STDOUT_DRIVER
;; stderr   : M4_STDERR_DRIVER
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

divert(3)
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
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment stored copy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(7)
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
      
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment - attached to binary ;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(8)
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
      
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment - external ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(6)
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
   
   defvars -1
   {
   }
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; bss segment - attached to binary ;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(5)
   ; ----------------------------------------------------------
   ; -- insert local crt bss segment here ---------------------
   ; ----------------------------------------------------------
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; bss segment - external ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(4)
   ; ----------------------------------------------------------
   ; -- insert local crt bss segment here ---------------------
   ; ----------------------------------------------------------
   
   defvars -1
   {
   }
dnl
dnl ###########################################################
dnl
include(`../../crt_declare_static_module_tail.m4')
