
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_init

; __CLIB_OPT_MALLOC = 0 selects the small address-chain walker.
; Any other value selects the fast spare-tail search.

IF __CLIB_OPT_MALLOC = 0

   EXTERN asm_heap_init_small
   defc asm_heap_init = asm_heap_init_small

ELSE

   EXTERN asm_heap_init_fast
   defc asm_heap_init = asm_heap_init_fast

ENDIF
