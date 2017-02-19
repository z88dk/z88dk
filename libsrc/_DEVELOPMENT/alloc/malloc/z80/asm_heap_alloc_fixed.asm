
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_fixed(void *heap, void *p, size_t size)
;
; Attempt to allocate size bytes from the heap at fixed
; address p.  The allocation will fail if the heap does
; not contain enough free memory at address p.
;
; Returns p on success or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_heap_alloc_fixed

EXTERN asm_heap_alloc_fixed_unlocked
EXTERN __heap_lock_acquire, __heap_lock_release_0, error_enolck_zc

asm_heap_alloc_fixed:

   ; Attempt to allocate memory from the heap at a fixed address
   ;
   ; enter : bc = void *p
   ;         de = void *heap
   ;         hl = size
   ;
   ; exit  : success
   ;
   ;            hl = void *p (zero size allocation will occur)
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errono = ENOLCK
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   call __heap_lock_acquire
   jp c, error_enolck_zc
   
   push de                       ; save void *heap
   call asm_heap_alloc_fixed_unlocked

   jp __heap_lock_release_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_heap_alloc_fixed

EXTERN asm_heap_alloc_fixed_unlocked

defc asm_heap_alloc_fixed = asm_heap_alloc_fixed_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
