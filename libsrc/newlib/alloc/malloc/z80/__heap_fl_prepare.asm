
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_fl_prepare
PUBLIC __heap_fl_anchor
PUBLIC __heap_fl_hole_heap
PUBLIC __heap_fl_hole_count

EXTERN __heap_fl_link

; The free-list head is the first block's prev word. That word is otherwise
; unused: nothing is allocated before the first block. Zero means the list
; has not been built (a static heap). After the first use it is either a
; node or the address of the word itself (empty).

__heap_fl_prepare:

   ; enter : de = void *heap
   ;
   ; exit  : hl = & first block
   ;         de = void *heap
   ;         bc unchanged
   ;         __heap_fl_anchor = & first->prev
   ;         carry reset
   ;
   ; uses  : af, hl

   push bc
   push de

   ld hl,10
   add hl,de                   ; hl = & first->prev
   ld (__heap_fl_anchor),hl

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = head

   ld a,d
   or e
   jr nz, prepare_ready

   pop de
   push de
   call build_free_list

prepare_ready:

   pop de
   pop bc

   ld hl,6
   add hl,de                   ; hl = & first block

   or a
   ret

build_free_list:

   ; de = void *heap
   ; link every committed tail. A committed == 0 region is not a node.
   ; Count non-first holes so largest-fit knows when a scan is required.
   ; malloc does not decrement the count. A high count forces one scan,
   ; and that scan writes the count again. A low count would hide a hole.

   xor a
   ld (__heap_fl_hole_count),a
   ld (__heap_fl_hole_heap),de

   ld hl,6
   add hl,de

build_loop:

   ; hl = & block

   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl                      ; de = block->next

   ld a,d
   or e
   jr z, build_done

   push de                     ; save & next
   push hl

   inc hl
   inc hl
   ld a,(hl)
   inc hl
   or (hl)                     ; committed
   pop hl                      ; hl = & block
   jr nz, build_link

   ld de,(__heap_fl_hole_heap)
   ld a,e
   add a,6
   ld e,a
   ld a,d
   adc a,0
   ld d,a                      ; de = & first block

   ld a,l
   cp e
   jr nz, build_count
   ld a,h
   cp d
   jr z, build_link            ; the first hole is tested directly

build_count:

   ld a,(__heap_fl_hole_count)
   inc a
   jr z, build_link            ; saturated at 255
   ld (__heap_fl_hole_count),a

build_link:

   call __heap_fl_link
   pop hl                      ; hl = & next block
   jr build_loop

build_done:

   ld hl,(__heap_fl_anchor)
   ld a,(hl)
   inc hl
   or (hl)
   dec hl
   ret nz                      ; a region was linked

   ld e,l
   ld d,h
   ld (hl),e
   inc hl
   ld (hl),d                   ; empty sentinel
   ret

SECTION bss_clib
SECTION bss_alloc_malloc

__heap_fl_anchor:       defs 2
__heap_fl_hole_heap:    defs 2
__heap_fl_hole_count:   defs 1
