
; void *memalign(size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _memalign

EXTERN _aligned_alloc

_memalign:

   jp _aligned_alloc

   INCLUDE "alloc/malloc/z80/asm_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _memalign

EXTERN _memalign_unlocked

_memalign:

   jp _memalign_unlocked
   
   INCLUDE "alloc/malloc/z80/asm_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
