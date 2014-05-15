
; int _vioctl__callee(FILE *stream, uint16_t command, void *arg)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vioctl__callee

_vioctl_callee:

   pop af
   pop bc
   pop de
   pop ix
   
   push af
   
   INCLUDE "sys/ioctl/z80/asm__vioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vioctl__callee

EXTERN _vioctl__unlocked_callee

_vioctl__callee:

   jp _vioctl__unlocked_callee

   INCLUDE "sys/ioctl/z80/asm__vioctl_.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
