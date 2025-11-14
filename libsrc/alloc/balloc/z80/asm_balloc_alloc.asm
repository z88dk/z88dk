
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *balloc_alloc(unsigned char queue)
;
; Allocate a block of memory from the front of the queue.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC asm_balloc_alloc

EXTERN __balloc_array
EXTERN asm_p_forward_list_remove_after

asm_balloc_alloc:

   ; enter : l = unsigned int queue
   ;
   ; exit  : success
   ;
   ;           hl = ptr to allocated block
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = 0
   ;           carry set
   ;
   ; uses  : af, de, hl

   ld h,0
   add hl,hl
   ld de,(__balloc_array)
   add hl,de                   ; p_forward_list *q

   jp asm_p_forward_list_remove_after
