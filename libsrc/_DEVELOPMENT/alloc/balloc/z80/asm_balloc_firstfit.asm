
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *balloc_firstfit(unsigned int queue, unsigned char num)
;
; Allocate a block from the first queue in [queue, queue+num-1]
; that has a block available.
;
; ===============================================================

XLIB asm_balloc_firstfit

XREF __qtbl

LIB error_enomem_zc

asm_balloc_firstfit:

   ; enter : hl = queue
   ;          a = num
   ;
   ; exit  : success
   ;
   ;           hl = ptr to allocated block
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = 0
   ;           carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   or a
   jp z, error_enomem_zc       ; zero queues to search
   
   add hl,hl
   ld de,(__qtbl)
   add hl,de                   ; forward_list *q
   
   ld b,a

loop:

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = first block in this queue
   inc hl
   
   ld a,d
   or e
   jr nz, found_block
   
   djnz loop
   jp error_enomem_zc

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
