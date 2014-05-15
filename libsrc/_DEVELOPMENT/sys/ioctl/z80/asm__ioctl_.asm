
; ===============================================================
; May 2014
; ===============================================================
; 
; int _ioctl_(FILE *stream, uint16_t command, ...)
;
; IOCTL on FILEs.
; This is a temporary function until posix i/o is available.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__ioctl_

EXTERN asm__vioctl_, __stdio_varg_2, __stdio_nextarg_de

asm__ioctl_:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
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

   call __stdio_varg_2
   
   ld ixl,e
   ld ixh,d                    ; ix = FILE *
   
   call __stdio_nextarg_de     ; de = command
   
   ld c,l
   ld b,h                      ; bc = void *arg

   jp asm__vioctl_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__ioctl_

EXTERN asm__ioctl__unlocked

asm__ioctl_:

   jp asm__ioctl__unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
