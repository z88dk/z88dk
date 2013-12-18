
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_addmem(int queue, int numblocks, uint size, void *addr)
;
; Add numblocks memory blocks to queue.  Each block is size bytes
; large and uses memory starting at address addr.
;
; size must be >= 2 but is not checked.  The actual memory space
; occupied by each block is (size + 1) bytes, the single byte
; being a hidden queue identifier.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB asm_ba_addmem

LIB asm_ba_free

asm_ba_addmem:

   ; enter :  a = queue
   ;         bc = numblocks
   ;         de = size
   ;         hl = addr
   ;
   ; exit  : hl = address of next free byte of memory
   ;         bc = 0
   ;
   ; uses  : bc, hl
   
   inc de                      ; size++, space for q id
   push af
   
loop:

   ld a,b
   or c
   jr z, done
   
   pop af
   ld (hl),a                   ; block belongs to queue a
   
   push af
   push bc
   push de
   push hl
   
   inc hl
   call asm_ba_free            ; put block into queue
   
   pop hl
   pop de
   pop bc
   
   dec bc
   jp loop

done:

   pop af
   ret
