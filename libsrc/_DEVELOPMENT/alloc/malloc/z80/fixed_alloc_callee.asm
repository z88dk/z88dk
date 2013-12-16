
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *fixed_alloc(void *p, size_t size)
;
; Attempt to allocate size bytes from the thread's heap at
; fixed address p.  Returns p or 0 on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

INCLUDE "../../../crt_vars.inc"

XLIB fixed_alloc_callee
XDEF asm_fixed_alloc

LIB asm_HeapAllocFixed

fixed_alloc_callee:

   pop de
   pop hl
   pop bc
   push de

asm_fixed_alloc:

   ; enter : bc = void *p
   ;         hl = size_t size
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = p or 0 if size == 0
   ;
   ;         fail
   ;
   ;            carry set, enomem
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld de,(__heap)
   jp asm_HeapAllocFixed
