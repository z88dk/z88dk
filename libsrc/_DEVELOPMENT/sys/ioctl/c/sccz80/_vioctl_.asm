
; int _vioctl_(FILE *stream, uint16_t command, void *arg)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vioctl_

EXTERN asm__vioctl_

_vioctl_:

   pop af
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push af
   
   jp asm__vioctl_

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vioctl_

EXTERN _vioctl__unlocked

_vioctl_:

   jp _vioctl__unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
