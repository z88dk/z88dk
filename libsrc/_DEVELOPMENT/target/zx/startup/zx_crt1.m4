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

## select default font for fzx driver

define(`M4_FZX_FONT', ff_ao_SoixanteQuatre)

## include macros for all supported drivers on zx target
## only drivers that do not acquire host resources can be
## statically allocated and should be listed here

include(`../driver/terminal/cons_input_kbd_inkey_L1/cons_input_kbd_inkey_L1.m4')
include(`../driver/terminal/cons_input_kbd_lastk_L1/cons_input_kbd_lastk_L1.m4')
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
;; stdin    : M4_STDIN_DRIVER
;; stdout   : M4_STDOUT_DRIVER
;; stderr   : M4_STDERR_DRIVER
;;
;; fzx font : M4_FZX_FONT
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
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment stored copy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(7)
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------

   _fzx_s:

      EXTERN _`'M4_FZX_FONT

      defw _`'M4_FZX_FONT
      defb 0, 0, 0, 0
      
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment - attached to binary ;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(8)
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
   
   PUBLIC _fzx

   _fzx:

      EXTERN _`'M4_FZX_FONT

      defw _`'M4_FZX_FONT
      defb 0, 0, 0, 0
      
dnl
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;; data segment - external ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnl
divert(6)
   ; ----------------------------------------------------------
   ; -- insert local crt data segment here --------------------
   ; ----------------------------------------------------------
   
   PUBLIC _fzx
   
   defvars -1
   {
      _fzx                            ds.b 6
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
