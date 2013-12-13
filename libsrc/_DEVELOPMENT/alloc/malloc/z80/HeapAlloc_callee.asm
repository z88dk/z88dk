
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *HeapAlloc(void *heap, size_t size)
;
; Allocate size bytes from the heap, returning ptr to the
; allocated memory or 0 on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

XLIB HeapAlloc_callee
XDEF asm_HeapAlloc

LIB error_enomem_zc
LIB __malloc_region_info, __malloc_first_fit, __malloc_block_allocate

HeapAlloc_callee:

   pop bc
   pop hl
   pop de
   push bc

asm_HeapAlloc:

   ; enter : de = void *heap (holds address of a region)
   ;         hl = size
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated memory, could be 0 if size == 0
   ;
   ;         fail on insufficient memory
   ;
   ;           carry set, enomem
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl
   
   ld a,h
   or l
   ret z                       ; return 0 and no error if size == 0
   
   ld bc,6                     ; header size
   add hl,bc                   ; add space for header
   jp c, error_enomem_zc
   
   ld c,l
   ld b,h
   ex de,hl

region_loop:

   ; bc = request size
   ; hl = & region
   
   push hl                     ; save region
   
   call __malloc_region_info
   jp z, error_enomem_zc - 1   ; no more regions to search
   
   sbc hl,bc                   ; region size - request size
   
   pop hl
   ex de,hl                    ; hl = & next region, de = & region
   
   jr c, region_loop           ; if region is too small

   push hl                     ; save & next region
   
search_region:

   ld hl,4
   add hl,de
   
   ; bc = request size
   ; hl = & first block in region
   ; stack = & next_region
   
   call __malloc_first_fit
   jr nc, found_memory
   
   ; bc = request size
   ; stack = & next_region
   
   pop hl
   jp region_loop              ; better luck in next region

found_memory:

   ; bc = request size
   ; hl = & block
   ; stack = & next_region
   
   pop de
   jp __malloc_block_allocate  ; allocate into block
