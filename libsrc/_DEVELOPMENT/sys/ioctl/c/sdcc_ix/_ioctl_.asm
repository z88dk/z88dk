
; int _ioctl_(FILE *stream, uint16_t command, ...)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __ioctl_

__ioctl_:

   push ix
   
   call asm__ioctl_
   
   pop ix
   ret

   INCLUDE "sys/ioctl/z80/asm__ioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __ioctl_

EXTERN __ioctl__unlocked

__ioctl_:

   jp __ioctl__unlocked
   
   INCLUDE "sys/ioctl/z80/asm__ioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
