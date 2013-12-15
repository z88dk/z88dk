
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int posix_memalign(void **memptr, size_t alignment, size_t size)
;
; Allocate size bytes from the thread's heap whose address is
; a multiple of alignment.  Alignment must be an exact power of 2
; and if it is not, it is rounded upward to the next power of 2.
;
; The pointer to allocated memory is stored in memptr.
;
; Return 0 on succes or errno.  If size == 0, 0 is returned as
; the pointer but no error is indicated.
;
; ===============================================================

INCLUDE "../../../crt_vars.inc"

XLIB posix_memalign_callee
XDEF asm_posix_memalign

LIB asm_HeapAllocAligned

posix_memalign_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

asm_posix_memalign:

   ; enter : de = void **memptr
   ;         hl = size (raw request size)
   ;         bc = alignment (exact power of 2)
   ;
   ; exit  : *memptr = ptr to allocated memory
   ;
   ;         success
   ;
   ;           carry reset
   ;           hl = 0
   ;
   ;         fail on aligned block of sufficient size not found
   ;
   ;           carry set, enomem
   ;           hl = enomem
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save memptr
   
   ld de,(__heap)
   call asm_HeapAllocAligned   ; hl = aligned memory block or 0
   
   pop de                      ; de = memptr
   
   ex de,hl                    ; de = aligned memory block, hl = void **memptr
   ld (hl),e
   inc hl
   ld (hl),d                   ; *memptr = & memory on success or 0
   
   ld hl,0
   ret nc                      ; no error, return 0
   
   ld hl,(_errno)              ; otherwise error is stored in errno
   ret
