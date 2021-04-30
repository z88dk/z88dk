; void __CALLEE__ HeapRealloc_callee(void *heap, void *p, unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapRealloc_callee
PUBLIC _HeapRealloc_callee
PUBLIC MAHeapRealloc
PUBLIC asm_HeapRealloc

EXTERN HeapAlloc_callee, HeapFree_callee
EXTERN asm_HeapAlloc, asm_HeapFree

.HeapRealloc_callee
._HeapRealloc_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

.asm_HeapRealloc

; Grab a new memory block from the heap specified.
; Copy as much of the old block possible to
; the new memory block.  If reallocation is not
; possible return 0 to indicate failure.
;
; enter : hl = old block address (+2)
;         de = & heap pointer
;         bc = new block size request
; exit  : hl = address of memory block and carry set if successful
;              else 0 and no carry (original block left as is)
; used  : af, bc, de, hl
;
; Not allowed to use IX,IY,EXX which really constrains things.
;
; ** For now just attempts to allocate a new block of given size.
; Must revisit to investigate if the old block can be merged with
; any free blocks in the free list to form a bigger block.  The
; ansi requirements for this function make it harder than it should
; be.

.MAHeapRealloc

   ld a,h
   or l
   jr nz, checksize

   ex de,hl                    ; ISO C wants a malloc to occur if realloc block == 0
   jp asm_HeapAlloc

.checksize

   ld a,b
   or a
   jp nz, sizeok
   ld a,c
   cp 2
   jp nc, sizeok
   ld c,2
   
.sizeok

   push de
   push hl
   push bc
   ex de,hl
   call asm_HeapAlloc
   jr c, success
   
.fail

   pop bc
   pop bc
   pop de
   ret

.success

   ; hl = & new block (+2)
   ; stack = & heap, & old block (+2), new block size
   
   pop bc                    ; bc = new block size
   pop de
   ex de,hl                  ; de = & new block (+2), hl = & old block (+2)
   push hl
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                    ; hl = size of old block
   
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,l
   sub c
   ld l,a
   ld a,h
   sbc b
   ld  h,a
ELSE
   or a
   sbc hl,bc                 ; old size - new size
ENDIF
   jr nc, usenewsize
   add hl,bc
   ld c,l
   ld b,h                    ; bc = old size
   
.usenewsize

   ; bc = number of bytes to copy
   ; de = & new block (+2)
   ; stack = & heap, & old block (+2)
   
   pop hl
   push hl
   push de
IF __CPU_INTEL__ || __CPU_GBZ80__
ldir_loop:
   ld a,(hl)
   ld (de),a
   inc hl
   inc de
   dec bc
   ld a,b
   or c
   jp nz,ldir_loop
ELSE
   ldir                      ; copy old data block to new data block
ENDIF
   
   ; stack = & heap, & old block (+2), & new block (+2)
   
   pop hl
   pop de
   ex (sp),hl
   ex de,hl
   
   ; de = & heap, hl = & old block (+2)
   ; stack = & new block
   
   call asm_HeapFree  ; return old block to free list
   
   pop hl
   scf
   ret
