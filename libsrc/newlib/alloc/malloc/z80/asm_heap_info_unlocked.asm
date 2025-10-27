
; ===============================================================
; Apr 2014
; ===============================================================
; 
; void heap_info_unlocked(void *heap, void *callback)
;
; Visit each block in the heap and pass information about
; the block to the callback function.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_info_unlocked

EXTERN l_jpix, l_inc_sp

asm_heap_info_unlocked:

   ; enter : ix = void *callback
   ;         de = void *heap
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl + callback

   ld hl,6                     ; sizeof(mutex)
   add hl,de                   ; hl = & heap.hdr

block_loop:

   ; hl = & hdr
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = hdr->next
   dec hl
   
   ld a,d
   or e
   ret z                       ; if end of heap reached
   
   push de                     ; save hdr->next
   push de                     ; save hdr->next

   push hl                     ; save hdr
   push ix                     ; save callback
   
   call header

   pop ix                      ; restore callback
   pop hl                      ; hl = & hdr
   
   push hl                     ; save & hdr
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = hdr->committed
   
   inc hl
   inc hl
   inc hl                      ; hl = hdr->mem[

   
   pop bc
   
   ld a,d
   or e
   jr z, committed_zero        ; if hdr->committed == 0
   
   push bc
   
   ; hl = hdr->mem[

   ; de = hdr->committed
   ; stack = hdr->next, hdr->next, hdr
   
   push de                     ; save hdr->committed
   ex de,hl
   
   ld bc,-6
   add hl,bc                   ; hl = hdr->committed - 6 = allocated size
   
   push ix                     ; save callback
   
   call allocated
   
   pop ix                      ; restore callback

   pop hl                      ; hl = hdr->committed
   pop de                      ; de = hdr
   
   add hl,de

committed_zero:

   ; hl = & free memory block
   ; stack = hdr->next, hdr->next

   ex de,hl                    ; de = & free memory in block
   pop hl                      ; hl = hdr->next
   
   ; de = & free memory block
   ; hl = hdr->next
   ; stack = hdr->next
   
   or a
   sbc hl,de                   ; hl = free memory size
   jr z, free_zero             ; if no free memory available
   
   ; hl = free memory size
   ; de = & free memory block
   ; stack = hdr->next
     
   push ix                     ; save callback
   
   call free
   
   pop ix                      ; restore callback
   
free_zero:

   pop hl                      ; hl = hdr->next
   jr block_loop

header:

   ; HEADER BLOCK
   
   ; hl = & hdr
   
   ld de,6
   push de                     ; size    = 6
   push hl                     ; address = hdr
   ld e,0
   push de                     ; type    = 0

invoke:

   ld hl,0
   add hl,sp
   
   push hl
   call l_jpix                 ; invoke callback

   jp l_inc_sp - 8

allocated:

   ; ALLOCATED BLOCK
   
   ; hl = allocated size
   ; de = hdr->mem[

   
   ld bc,1

   push hl                     ; size
   push de                     ; address
   push bc                     ; type

   jr invoke

free:

   ; FREE BLOCK

   ; hl = free memory size
   ; de = & free memory block

   ld bc,2
   
   push hl                     ; size
   push de                     ; address
   push bc                     ; type
   
   jr invoke
