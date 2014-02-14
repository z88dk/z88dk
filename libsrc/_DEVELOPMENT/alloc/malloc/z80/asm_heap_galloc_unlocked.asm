
XLIB asm_heap_galloc_unlocked

LIB error_erange_zc, asm_realloc_unlocked

asm_heap_galloc_unlocked:

   ; Attempt to adjust the size of the allocation by a signed quantity
   ; without locking.  This is a thin layer on top of realloc used by
   ; library functions
   ;
   ; enter : de = void *heap
   ;         hl = void *p
   ;         bc = int resize (signed)
   ;
   ; exit  : success
   ;
   ;            de = old allocation size
   ;            bc = new allocation size
   ;            hl = void *p_new
   ;            carry reset
   ;
   ;         fail on requested size out of range
   ;
   ;            de = old allocation size
   ;            hl = 0
   ;            carry set, errno = ERANGE
   ;
   ;         fail on insufficient memory
   ;
   ;            de = old allocation size
   ;            bc = desired allocation size
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save void *p
   
   dec hl
   dec hl
   dec hl
   
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = block_p->committed
   
   push bc                     ; save resize
   
   ld bc,-(__HEAP_HEADER_SZ)
   add hl,bc                   ; hl = old allocation size
   
   pop bc                      ; bc = resize
   
   pop af
   push hl
   push af
   
   ; bc = resize
   ; hl = old allocation size
   ; de = void *heap
   ; stack = old allocation size, void *p
   
   bit 7,b
   jr z, block_expands

block_shrinks:

   or a
   sbc hl,bc
   jr nc, block_size_ok

block_size_bad:

   pop de
   pop de                      ; de = old allocation size
   
   jp error_erange_zc

block_expands:

   add hl,bc
   jr c, block_size_bad

block_size_ok:

   ; hl = new allocation size
   ; de = void *heap
   ; stack = old allocation size, void *p
   
   ld c,l
   ld b,h
   
   pop hl
   push bc
   
   ; hl = void *p
   ; de = void *heap
   ; bc = new allocation size
   ; stack = old allocation size, new allocation size
   
   call asm_realloc_unlocked

   pop bc                      ; bc = new allocation size
   pop de                      ; de = old allocation size
   
   ret
