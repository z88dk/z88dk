
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_align_to(struct obstack *ob, size_t alignment)
;
; Set the obstack fence to the next address aligned to alignment.
; Any following allocations or further growth will begin at this
; address.  Does not close the currently growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_align_to

EXTERN asm_obstack_align_distance, asm0_obstack_blank
EXTERN error_zc

asm_obstack_align_to:

   ; enter : hl = struct obstack *ob
   ;         bc = size_t alignment
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = struct obstack *ob
   ;
   ;         fail invalid alignment
   ;
   ;            carry set, einval
   ;            hl = 0
   ;
   ;         fail insufficient memory
   ;
   ;            carry set, enomem
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl
   
   push hl                     ; save ob

   call asm_obstack_align_distance  ; hl = align distance
   jp c, error_zc - 1               ; some problem with alignment

   ld c,l
   ld b,h                      ; bc = align distance
   
   pop hl                      ; hl = struct obstack *ob
   jp asm0_obstack_blank
