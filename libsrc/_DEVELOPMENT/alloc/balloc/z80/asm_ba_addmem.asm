
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_addmem(unsigned char q, size_t num, size_t size, void *addr)
;
; Add num memory blocks to queue.  Each block is size bytes
; large and uses memory starting at address addr.
;
; size must be >= 2 but is not checked.  The actual memory space
; occupied by each block is (size + 1) bytes, the single extra
; byte being a hidden queue identifier.
;
; ===============================================================

XLIB asm_ba_addmem

LIB asm_forward_list_insert_after

asm_ba_addmem:

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
   
   ld bc,(__qtbl)
   add hl,bc
   ld c,l
   ld b,h                      ; bc = forward_list *q
   
   pop hl

loop:

   ; bc = forward_list *q
   ; de = void *next_addr
   ; hl = num
   ;  a = queue
   ; stack = size

   inc l
   dec l
   jp nz, continue
   
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

   ; bc = forward_list *q
   ; de = void *next_addr
   ; hl = num
   ;  a = queue
   ; stack = size
   
   ld (de),a                   ; record queue number in block
   inc de
   
   ex (sp),hl
   push af
   push hl

   ; bc = forward_list *q
   ; de = void *addr
   ; stack = num, queue, size
   
   ld l,c
   ld h,b
   call asm_forward_list_insert_after  ; push memory block to front of list
   
   ; bc = forward_list *q
   ; hl = void *addr
   ; stack = num, queue, size
   
   pop de
   add hl,de
   ex de,hl                    ; de = void *next_addr, hl = size
   
   pop af
   ex (sp),hl
   
   dec hl                      ; hl = num--
   
   jp loop
