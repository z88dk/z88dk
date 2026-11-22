
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_alloc_unlocked

; __CLIB_OPT_MALLOC = 0 selects the small address-chain walker.
; Any other value selects the fast spare-tail search.

IF __CLIB_OPT_MALLOC = 0

   EXTERN asm_heap_alloc_unlocked_small
   defc asm_heap_alloc_unlocked = asm_heap_alloc_unlocked_small

ELSE

   EXTERN asm_heap_alloc_unlocked_fast
   defc asm_heap_alloc_unlocked = asm_heap_alloc_unlocked_fast

ENDIF
