
; int _ioctl_(FILE *stream, uint16_t command, ...)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ioctl_

_ioctl_:

   INCLUDE "sys/ioctl/z80/asm__ioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ioctl_

EXTERN _ioctl__unlocked

_ioctl_:

   jp _ioctl__unlocked
   
   INCLUDE "sys/ioctl/z80/asm__ioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
