
; void *memalign(size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _memalign

EXTERN _aligned_alloc

defc _memalign = _aligned_alloc

INCLUDE "alloc/malloc/z80/asm_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _memalign

EXTERN _memalign_unlocked

defc _memalign = _memalign_unlocked
   
INCLUDE "alloc/malloc/z80/asm_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
