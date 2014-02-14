
XLIB asm_heap_alloc_aligned_unlocked

LIB __heap_place_block, __heap_allocate_block, l_andc_hl_bc
LIB l_power_2_bc, asm_heap_alloc_unlocked, error_enomem_zc, error_einval_zc

asm_heap_alloc_aligned_unlocked:

   ; Attempt to allocate memory at an address that is aligned to a power of 2
   ; without locking
   ;
   ; enter : de = void *heap
   ;         hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_aligned could be zero if size == 0
   ;            carry reset
   ;
   ;         fail on alignment == 2^16
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail on memory not found
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses   : af, bc, de, hl

   ld a,h
   or l
   ret z                       ; if size == 0

   call l_power_2_bc           ; bc = power of two >= bc
   jp c, error_einval_zc       ; if alignment == 2^16

   dec bc                      ; bc = alignment - 1
   
   ld a,b
   or c
   jp z, asm_heap_alloc_unlocked  ; if no alignment (alignment == 1)

   ; de = void *heap
   ; hl = size
   ; bc = alignment - 1

   push bc                     ; save alignment - 1
   
   ld bc,__HEAP_HEADER_SZ
   add hl,bc
   
   ex de,hl                    ; de = gross request size
   
   ld bc,__MTX_STRUCT_SZ
   add hl,bc                   ; hl = & first block in heap

   ; hl = & block
   ; de = gross request size
   ; stack = alignment - 1

   ex de,hl
   ex (sp),hl
   push hl
   ex de,hl
   
   ; hl = & block
   ; stack = gross request size, alignment - 1

   ; the first block may have zero committed bytes
   
   ld e,l
   ld d,h
   
   inc hl
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed
   
   ld a,b
   or c
   jr nz, enter_loop           ; if committed != 0
   
   ; committed is zero so test special case that aligned block overlays
   
   inc hl
   inc hl
   inc hl                      ; hl = & block_mem
   
   pop bc                      ; bc = alignment - 1
   
   ld a,c
   and l
   jr nz, special_fail         ; if address is not aligned
   
   ld a,b
   and h
   jr nz, special_fail         ; if address is not aligned
   
   ; overlayed block will align
   
   ; bc = alignment - 1
   ; de = & block
   ; stack = gross request size
   
   pop hl
   push bc
   
   ld c,l
   ld b,h                      ; bc = gross request size
   
   ld l,e
   ld h,d
   
   ; bc = gross request size
   ; de = & block
   ; hl = & block
   ; stack = alignment - 1

   call __heap_place_block
   jr c, overlay_fail
   
   ; overlay is successful
   
   inc sp
   inc sp                      ; junk item on stack
   
   jp __heap_allocate_block
   
special_fail:

   ; overlay will not align so try to allocate within free area
   
   ; bc = alignment - 1
   ; de = & block
   ; stack = gross request size

   pop hl
   push bc
   
   ld c,l
   ld b,h

overlay_fail:
   
   ; failed overlay so try to allocate within free area
   
   ; bc = gross request size
   ; de = & block
   ; stack = alignment - 1

   pop hl
   push bc
   push hl
   
   ld bc,__HEAP_HEADER_SZ

enter_loop:

   ; de = & block
   ; bc = block->committed
   ; stack = gross request size, alignment - 1

   ; calculate earliest possible allocation address
   
   ld hl,__HEAP_HEADER_SZ
   add hl,bc
   add hl,de
   jp c, error_enomem_zc - 2   ; proposed address out of range

   ; de = & block
   ; hl = void *p
   ; stack = gross request size, alignment - 1

   ; compute next aligned address
   
   pop bc                      ; bc = alignment - 1
   
   add hl,bc
   jp c, error_enomem_zc - 1   ; proposed address out of range
   
   call l_andc_hl_bc           ; hl = hl & (~bc)

   pop af
   push af
   push bc
   push af

   ; de = & block
   ; hl = void *p_aligned
   ; bc = gross request size
   ; stack = gross request size, alignment - 1, gross request size
   
   ld bc,-(__HEAP_HEADER_SZ)
   add hl,bc
   
   pop bc
   
   ; de = & block
   ; hl = & block_aligned
   ; bc = gross request size
   ; stack = gross request size, alignment - 1

   ; check if aligned block fits

   ex de,hl
   call __heap_place_block
   jr nc, success

   ; try next block
   
   ex de,hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next = & block_next
   
   ld l,e
   ld h,d
   
   ld a,(hl)
   inc hl
   or (hl)
   jp z, error_enomem_zc - 2   ; if end of heap reached
   
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block_next -> committed
   
   jr enter_loop

success:

   pop af
   pop af                      ; junk two items on stack
   
   jp __heap_allocate_block
