
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *_falloc(void *p, size_t size)
;
; Attempt to allocate size bytes from the thread's heap at
; fixed address p.  Returns p or 0 with carry set on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__falloc

EXTERN __malloc_heap

EXTERN asm_heap_alloc_fixed

asm__falloc:

   ; Attempt to allocate memory from the thread's default heap
   ; at a fixed address
   ;
   ; enter : bc = void *p
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

   IF __CPU_INTEL__ || __CPU_GBZ80__
   ex de,hl
   ld hl,(__malloc_heap)
   ex de,hl
   ELSE
   ld de,(__malloc_heap)
   ENDIF
   jp asm_heap_alloc_fixed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm__falloc

EXTERN asm__falloc_unlocked

defc asm__falloc = asm__falloc_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
