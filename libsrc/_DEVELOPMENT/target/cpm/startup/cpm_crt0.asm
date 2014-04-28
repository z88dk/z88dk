
; zx spectrum crt0 for testing purposes

;; origin ;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

org $100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB start
XDEF __Exit

XREF _main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_defs.inc"      ; crt defines

;; crt configuration ;;;;;;;;;;

defc __heap_sz = 2048          ; malloc's heap, eliminate if not required
defc __qtbl_sz = 6             ; balloc's qtable, eliminate if not required

defc __exit_stack_sz      = 6  ; set to 0 if not required, default is 32
defc __quickexit_stack_sz = 6  ; set to 0 if not required, default is 32

defc __HAVE_FILE_STDIN    = 1  ; set to 0 if stdin not available
defc __HAVE_FILE_STDOUT   = 1  ; set to 0 if stdout not available
defc __HAVE_FILE_STDERR   = 1  ; set to 0 if stderr not available

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:
   ld (__sp),sp


   INCLUDE "../crt_init.asm"   ; intialize crt state

   ; TODO: command line arguments/redirection etc

   ; call user program

   call _main                  ; hl holds return status

   INCLUDE "../crt_exit.asm"   ; run exit stack
   
__Exit:

   INCLUDE "../crt_cleanup.asm"  ; close files 

   ld c,l
   ld b,h                      ; return status to basic

   ld sp,(__sp)
   jp 0
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_vars.asm"      ; crt variable declarations
INCLUDE "../crt_stubs.asm"     ; crt stubs for unimplemented lib functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defw 0
   
__FILE_STDIN:
   
   defb 195                    ; jp driver
   defw __bdoskbd_driver
   defb $80                    ; open for reading
   defb $02                    ; last op was read, to skip auto-flush
   defb 0
   defb 0
   defs 6                      ; mutex

   defw 0
   
__FILE_STDOUT:

   defb 195                    ; jp driver
   defw __bdoscons_driver
   defb $40                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

   defw 0
   
__FILE_STDERR:

   ; separate from stdout allows output
   ; even when stdout is in an error state

   defb 195                    ; jp driver
   defw __bdoscons_driver
   defb $40                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "driver/__bdoscons_driver.asm"     ; input/output driver
INCLUDE "driver/__bdoskbd_driver.asm"     ; input/output driver
