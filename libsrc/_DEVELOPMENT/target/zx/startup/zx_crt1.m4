divert(-1)
###############################################################
##         ZX_CRT1.M4 - GENERATOR FOR ZX_CRT1.ASM            ##
##         customize by editing the options below            ##
###############################################################

include(`../../crt_declare_static_module_head.m4')

###############################################################
##                       OPTIONS                             ##
###############################################################

## select drivers for the standard streams, set to zero to omit

define(`M4_STDIN_DRIVER', cons_input_kbd_inkey_L1)
define(`M4_STDOUT_DRIVER', cons_output_fzx_L1)
define(`M4_STDERR_DRIVER', cons_output_fzx_L1)

## parameters passed to drivers when instantiated

define(`M4_STDIN_PARAMS', `0,0,0,0,0,0')
define(`M4_STDOUT_PARAMS', `0,0,0,0,0,0')
define(`M4_STDERR_PARAMS', `0,0,0,0,0,0')

## include macros for all supported drivers on zx target
## only drivers that do not acquire host resources can be
## statically allocated and should be listed here

include(`../driver/terminal/cons_input_kbd_inkey_L1/cons_input_kbd_inkey_L1.m4')
include(`../driver/terminal/cons_input_kbd_lastk_L1/cons_input_kbd_lastk_L1.m4')
include(`../driver/terminal/cons_output_char_L1/cons_output_char_L1.m4')
include(`../driver/terminal/cons_output_fzx_L1/cons_output_fzx_L1.m4')

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
;;                    zx spectrum crt1                       ;;
;;      generated from target/zx/startup/zx_crt1.m4          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; #pragma output STACKPTR=nnnnn
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; stdin     : M4_STDIN_DRIVER`('M4_STDIN_PARAMS`)'
;; stdout    : M4_STDOUT_DRIVER`('M4_STDOUT_PARAMS`)'
;; stderr    : M4_STDERR_DRIVER`('M4_STDERR_PARAMS`)'
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
INCLUDE "crt_target_cfg.asm"
INCLUDE "../crt_cfg_default.asm"

divert(3)
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
   
   IF REGISTER_SP
   
      ld sp,REGISTER_SP        ; pragma to locate stack
   
   ELSE
   
      IF STACKPTR
      
         ld sp,STACKPTR        ; pragma to locate stack
      
      ENDIF
   
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
   
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; bss segment - attached to binary ;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(5)
   ; ----------------------------------------------------------
   ; -- insert local crt bss segment here ---------------------
   ; ----------------------------------------------------------

   __sp:                              defs 2
   
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
      __sp                            ds.w 1
   }
dnl
dnl ###########################################################
dnl
include(`../../crt_declare_static_module_tail.m4')
