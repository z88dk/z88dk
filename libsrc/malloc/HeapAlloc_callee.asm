; void __CALLEE__ *HeapAlloc_callee(void *heap, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapAlloc_callee
PUBLIC _HeapAlloc_callee
PUBLIC ASMDISP_HEAPALLOC_CALLEE

.HeapAlloc_callee
._HeapAlloc_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

; Allocate memory from the indicated heap.  First fit algorithm.
;
; Each block in list of free blocks formatted like this:
;
; +----------------------+
; |                      |
; +--  size (2 bytes)  --+
; |                      |
; +----------------------+
; |                      |
; +--  next (2 bytes)  --+
; |                      |
; +----------------------+
; |                      |
; |   available bytes    |
; |                      |
; +----------------------+
;
; size includes the two bytes used for the next pointer but not
; the two bytes used for size.  The allocated block will begin
; at the address of the next pointer, leaving the two bytes for
; size as overhead for each block.
; 
; enter : hl = & heap pointer
;         bc = request size in bytes
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry if failed
; uses  : af, bc, de, hl

.MAHeapAlloc

   inc hl
   inc hl

   ld a,b                    ; requests must be at least 2 bytes
   or a
   jp nz, loop
   ld a,c
   cp 2
   jp nc, loop
   ld c,2

.loop

   ; hl = & last block's next pointer
   ; bc = size

   ld a,(hl)
   inc hl
   push hl                   ; save & lagger's next + 1b
   ld h,(hl)
   ld l,a                    ; hl = & next block

   or h
   jr z, exit0               ; if no next block, return with hl=0 and nc for fail
   
   ; hl = & block
   ; bc = size
   ; stack = & lagger->next + 1b
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                  ; hl = block's size, de = & block + 1b

   sbc hl,bc                 ; is block size at least as big as requested?
   jr nc, foundblk           ; if so branch to foundblk
   
   pop hl                    ; junk lagger on stack
   ex de,hl
   inc hl                    ; hl = & block->next
   jp loop                   ; try again with next block
   
.foundblk

   ; bc = size
   ; de = & block + 1b
   ; hl = block's excess size
   ; stack = & lagger->next + 1b
   
   push bc
   ld bc,4
   sbc hl,bc
   pop bc
   jr c, usewholeblk         ; if too small to split, use whole block

.splitblk

   ; bc = size
   ; de = & block + 1b
   ; hl = size remaining of block after allocation satisfied - 2
   ; stack = & lagger->next + 1b
   
   inc hl
   inc hl
   ex de,hl                  ; de = size of remaining part of block
   dec hl                    ; hl = & block
   ld (hl),e                 ; write new block size
   inc hl
   ld (hl),d
   inc hl                    ; hl = & block->next
   add hl,de                 ; skip over part of block we're leaving behind

   ld (hl),c                 ; write the allocated block's size
   inc hl
   ld (hl),b
   inc hl                    ; hl = & allocated memory block
   pop de                    ; junk lagger
   scf                       ; indicate success
   ret

.usewholeblk

   ; bc = size
   ; de = & block + 1b
   ; stack = & lagger->next + 1b
 
   inc de
   inc de                    ; de = & block->next + 1b
   pop hl                    ; hl = & lagger->next + 1b
   ex de,hl
   ldd                       ; write next block after this one into lagger's pointer
   ld a,(hl)                 ; hl = & allocated memory block = & block->next
   ld (de),a
   scf                       ; indicate success
   ret
   
.exit0

   pop de                    ; junk lagger on stack
   ret

DEFC ASMDISP_HEAPALLOC_CALLEE = # asmentry - HeapAlloc_callee
