
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void free(void *p)
;
; Deallocate memory previously allocated at p from the thread's
; default heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_free

EXTERN __malloc_heap

EXTERN asm_heap_free

asm_free:

   ; Return the memory block to the thread's default heap
   ;
   ; enter : hl = void *p
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            de = void *p
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, de, hl

   ld de,(__malloc_heap)
   jp asm_heap_free

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_free

EXTERN asm_free_unlocked

defc asm_free = asm_free_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
