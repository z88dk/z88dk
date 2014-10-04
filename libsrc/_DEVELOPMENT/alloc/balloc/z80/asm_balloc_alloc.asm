
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *balloc_alloc(unsigned int queue)
;
; Allocate a block of memory from the front of the queue.
;
; ===============================================================

SECTION seg_code_balloc

PUBLIC asm_balloc_alloc

EXTERN __balloc_qtbl

EXTERN asm_p_forward_list_remove_after, error_enomem_zc

asm_balloc_alloc:

   ; enter : hl = unsigned int queue
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated block
   ;
   ;         fail
   ;
   ;           carry set, errno = ENOMEM
   ;           hl = 0
   ;
   ; uses  : af, de, hl

   add hl,hl
   ld de,(__balloc_qtbl)
   add hl,de                   ; p_forward_list *q

   call asm_p_forward_list_remove_after
   ret nc

   jp error_enomem_zc          ; if queue is empty
