
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *HeapGalloc(void *heap, void *p, int resize)
;
; Attempts to grow or shrink block p by signed resize bytes.
; This is a thin layer on top of HeapRealloc().
;
; Non-standard function used internally by the C library.
; See HeapRealloc() for exit conditions.
;
; ===============================================================

XLIB HeapGalloc_callee
XDEF asm_HeapGalloc

LIB error_einval_zc

HeapGalloc_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

asm_HeapGalloc:

   ; enter : hl = void *heap (holds address of a region)
   ;         de = void *p
   ;         bc = int resize (signed)
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = & new memory
   ;
   ;         fail
   ;
   ;           carry set, errno = enomem / einval
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld a,d
   or e
   jp z, asm_HeapRealloc       ; if p == 0 we are allocating, not resizing
   
   push hl                     ; save heap
   push de                     ; save p
   
   ex de,hl
   
   dec hl
   dec hl
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = block_p->committed
   
   ld hl,-6
   add hl,de                   ; hl = p allocation size
   add hl,bc                   ; hl = new size request
   
   ld c,l
   ld b,h                      ; bc = request size
   
   pop de                      ; de = p
   pop hl                      ; hl = heap
   
   jp nc, asm_HeapRealloc
   
   jp error_einval_zc          ; request size bad
