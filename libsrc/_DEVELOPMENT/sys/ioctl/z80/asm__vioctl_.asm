
; ===============================================================
; May 2014
; ===============================================================
; 
; int _vioctl_(FILE *stream, uint16_t command, void *arg)
;
; IOCTL on FILEs.
; This is a temporary function until posix i/o is available.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__vioctl_

EXTERN asm0__vioctl__unlocked, __stdio_lock_release

asm__vioctl_:

   ; enter : ix = FILE *
   ;         de = command
   ;         hl = void *stack_param = arg
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = return value != -1
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid_lock

   call __stdio_verify_valid_lock
   ret c

ELSE

   EXTERN __stdio_lock_acquire, error_enolck_mc
   
   call __stdio_lock_acquire
   jp c, error_enolck_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call asm0__vioctl__unlocked
   jp __stdio_lock_release

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__vioctl_

EXTERN asm__vioctl__unlocked

asm__vioctl_:

   jp asm__vioctl__unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
