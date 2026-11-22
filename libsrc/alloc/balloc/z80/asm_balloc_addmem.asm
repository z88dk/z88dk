
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *balloc_addmem(unsigned char q, size_t num, size_t size, void *addr)
;
; Add num memory blocks to queue.  Each block is size bytes
; large and uses memory starting at address addr.
;
; size must be >= 2 but is not checked.  The actual memory space
; occupied by each block is (size + 1) bytes, the single extra
; byte being a hidden queue identifier.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC asm_balloc_addmem

EXTERN __balloc_array
EXTERN asm_p_forward_list_insert_after

asm_balloc_addmem:

   ; enter :  a = unsigned char q
   ;         bc = size_t num
   ;         de = void *addr
   ;         hl = size_t size
   ;
   ; exit  : hl = address of next free byte
   ;         de = size
   ;
   ; uses  : af, bc, de, hl

   push hl
   push bc
   
   ld l,a
   ld h,0
   add hl,hl
   
   ld bc,(__balloc_array)
   add hl,bc
   ld c,l
   ld b,h                      ; bc = p_forward_list *q
   
   pop hl

loop:

   ; bc = p_forward_list *q
   ; de = void *next_addr
   ; hl = num
   ;  a = queue
   ; stack = size

   inc l
   dec l
   jr nz, continue
   
   inc h
   dec h
   jr nz, continue

done:

   ; de = void *next_addr
   ; stack = size

   pop hl

   ex de,hl
   ret

continue:

   ; bc = p_forward_list *q
   ; de = void *next_addr
   ; hl = num
   ;  a = queue
   ; stack = size
   
   ld (de),a                   ; record queue number in block
   inc de
   
   ex (sp),hl
   push af
   push hl

   ; bc = p_forward_list *q
   ; de = void *addr
   ; stack = num, queue, size
   
   ld l,c
   ld h,b
   call asm_p_forward_list_insert_after  ; push memory block to front of list
   
   ; bc = p_forward_list *q
   ; hl = void *addr
   ; stack = num, queue, size
   
   pop de
   add hl,de
   ex de,hl                    ; de = void *next_addr, hl = size
   
   pop af
   ex (sp),hl
   
   dec hl                      ; hl = num--
   
   jr loop
