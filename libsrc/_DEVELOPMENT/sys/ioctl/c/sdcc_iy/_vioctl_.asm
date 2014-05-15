
; int _vioctl_(FILE *stream, uint16_t command, void *arg)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __vioctl_

__vioctl_:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af

   INCLUDE "sys/ioctl/z80/asm__vioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __vioctl_

EXTERN __vioctl__unlocked

__vioctl_:

   jp __vioctl__unlocked

   INCLUDE "sys/ioctl/z80/asm__vioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
