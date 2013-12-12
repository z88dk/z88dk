
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void HeapFree(void *heap, void *p)
;
; Return a previously allocated block to the heap for reuse.
;
; If p == 0, no action is taken.
;
; ===============================================================

XLIB HeapFree_callee
XDEF asm_HeapFree

LIB error_znc, error_zc, __malloc_region_locate

HeapFree_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_HeapFree:

   ; enter : bc = void *p
   ;         hl = void *heap (holds address of a region)
   ;
   ; exit  : carry set if p does not belong to heap
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   ret z                       ; if p == NULL

   ; find the region the pointer belongs to
   
   call __malloc_region_locate   ; de = & region containing p
   ret c                         ; p does not belong to heap
   
   ; de = & region
   ; bc = void *p
   
   dec bc
   dec bc
   dec bc
   dec bc                      ; bc = & block containing p
   
   ld hl,4
   add hl,de                   ; hl = & first block in region
   
   ld de,0                     ; lagger block = 0

block_loop:

   ; de = & block_lagger
   ; hl = & block_current
   ; bc = & block_p

   ; found block_p ?
   
   ld a,l
   cp c
   jr nz, not_found
   
   ld a,h
   cp b
   jr nz, not_found
   
block_found:

   ; de = & block_lagger
   ; hl = & block_free
   
   ld a,d
   or e
   jr z, block_first
   
   ; block_lagger->next = block_free->next
   
   ldi
   ldi
   
   ret

block_first:

   ; this block is the first in the region
   ; so set block->committed = 0
   
   inc hl
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   
   ret

not_found:

   jr c, try_next_block
   jp nz, error_zc

   ld a,l
   cp c
   jp nc, error_zc

try_next_block:

   ; de = & block_lagger
   ; hl = & block_current
   ; bc = & block_p

   ld e,l
   ld d,h                      ; de = block_lagger = block_current
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, block_loop
   
   jp error_zc
