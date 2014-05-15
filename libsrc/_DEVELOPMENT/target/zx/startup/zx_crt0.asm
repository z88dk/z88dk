
; zx spectrum crt0 for testing purposes

;; origin ;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"
INCLUDE "clib_cfg.asm"

IF !myzorg

   defc myzorg = 32768

ENDIF

org myzorg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC start
PUBLIC __Exit

EXTERN _main

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

   push iy                     ; target requires saving iy
   exx
   push hl                     ; target requires saving hl'
   
   ld (__sp),sp

   IF STACKPTR                 ; pragma to locate stack
   
      ld sp,STACKPTR
   
   ENDIF

   INCLUDE "../crt_init.asm"   ; intialize crt state

   ; clear screen 

   call cls                    ; clear screen, reset fzx state
      
   ; initialize fzx state
   
   EXTERN _ff_ao_SoixanteQuatre
   ld hl,_ff_ao_SoixanteQuatre
   ld (_fzx),hl                ; initial font
   
   ; call user program

   call _main                  ; hl holds return status

   INCLUDE "../crt_exit.asm"   ; run exit stack
   
__Exit:

   INCLUDE "../crt_cleanup.asm"  ; close files 

   ld c,l
   ld b,h                      ; return status to basic

   ld sp,(__sp)
   
   exx
   pop hl                      ; restore hl'
   exx
   pop iy                      ; restore iy
   
   im 1
   
   ei   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_vars.asm"      ; crt variable declarations
INCLUDE "../crt_stubs.asm"     ; crt stubs for unimplemented lib functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   defw 0
   
__FILE_STDIN:
   
   defb 195                    ; jp driver
   defw __kbd_driver
   defb $40                    ; open for reading
   defb $02                    ; last op was read, to skip auto-flush
   defb 0
   defb 0
   defs 6                      ; mutex
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
      defb $81                 ; driver flags = echo on
   ENDIF
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 1
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 1
   ENDIF


   defw 0
   
__FILE_STDOUT:

   defb 195                    ; jp driver
   defw __fzx_driver
   defb $80                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
      defb 0                   ; driver flags n/a
   ENDIF
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 1
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 1
   ENDIF


   defw 0
   
__FILE_STDERR:

   ; separate from stdout allows output
   ; even when stdout is in an error state

   defb 195                    ; jp driver
   defw __fzx_driver
   defb $80                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
      defb 0                   ; driver flags n/a
   ENDIF
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 1
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 1
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; fzx state

PUBLIC _fzx

_fzx:   defs 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC cls

cls:

   ; reset fzx
   
   ld hl,0
   ld (_fzx + 2),hl
   ld (_fzx + 4),hl

   ; attributes
   
   ld e,56
   ld hl,$5800
   ld bc,768
   
   EXTERN asm_memset
   call asm_memset

   ; pixels
   
   ld e,0
   ld hl,$4000
   ld bc,6144
   
   jp asm_memset

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "driver/__fzx_driver.asm"     ; output driver
INCLUDE "driver/__kbd_driver.asm"     ; input driver
