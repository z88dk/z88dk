
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void heap_info(void *heap, void *callback)
;
; Visit each block in the heap and pass information about
; the block to the callback function.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_heap_info

EXTERN asm_heap_info_unlocked
EXTERN __heap_lock_acquire, __heap_lock_release_0, error_enolck_zc

asm_heap_info:

   ; enter : ix = void *callback
   ;         de = void *heap
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl + callback

   call __heap_lock_acquire
   jp c, error_enolck_zc
   
   push de                       ; save void *heap
   call asm_heap_info_unlocked

   jp __heap_lock_release_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_heap_info

EXTERN asm_heap_info_unlocked

defc asm_heap_info = asm_heap_info_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
