
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *balloc_firstfit(unsigned char queue, unsigned char num)
;
; Allocate a block from the first queue in [queue, queue+num-1]
; that has a block available.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC asm_balloc_firstfit

EXTERN __balloc_array, error_zc

asm_balloc_firstfit:

   ; enter :  l = queue
   ;          h = num
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
   ; uses  : af, bc, de, hl

   ld a,h

   or a
   jp Z, error_zc              ; zero queues to search

   ld h,0
   add hl,hl
   IF __CPU_INTEL__ || __CPU_GBZ80__
   ex de,hl
   ld hl,(__balloc_array)
   ex de,hl
   ELSE
   ld de,(__balloc_array)
   ENDIF
   add hl,de                   ; forward_list *q
   
   ld b,a

loop:

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = first block in this queue
   inc hl
   
   ld a,d
   or e
IF __CPU_8085__
   jp NZ, found_block
ELSE
   jr NZ, found_block
ENDIF
   
   IF __CPU_INTEL__ || __CPU_GBZ80__
   dec b
   jp NZ,loop
   ELSE
   djnz loop
   ENDIF
   jp error_zc

found_block:

   ex de,hl
   
   ; hl = & block
   ; de = & queue + 2b
   ; carry reset
   
   inc hl
   dec de
   
   ldd                         ; copy link to next block from block to q
   ld a,(hl)
   ld (de),a
   
   ret
