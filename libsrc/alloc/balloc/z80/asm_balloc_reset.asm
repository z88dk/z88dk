
; ===============================================================
; May 2017
; ===============================================================
; 
; void *balloc_reset(unsigned char queue)
;
; Reset queue to empty.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC asm_balloc_reset

EXTERN __balloc_array

asm_balloc_reset:

   ; enter : l = unsigned char queue
   ;
   ; exit  : hl = head of former free list
   ;
   ; uses  : de, hl

   ld h,0
   add hl,hl
   ld de,(__balloc_array)
   add hl,de
	
	ld e,(hl)
	ld (hl),0
	inc hl
	ld d,(hl)
	ld (hl),0
	
	ex de,hl
	ret
