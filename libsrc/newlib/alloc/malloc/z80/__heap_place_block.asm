
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_place_block

; __CLIB_OPT_MALLOC = 0 selects the small address-chain walker.
; Any other value selects the fast spare-tail search.

IF __CLIB_OPT_MALLOC = 0

   EXTERN __heap_place_block_small
   defc __heap_place_block = __heap_place_block_small

ELSE

   EXTERN __heap_place_block_fast
   defc __heap_place_block = __heap_place_block_fast

ENDIF
