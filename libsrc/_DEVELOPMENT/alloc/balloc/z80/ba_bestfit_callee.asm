
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_bestfit(int queue, int num)
;
; Allocate a block from the first queue in [queue, queue+num-1]
; that has a block available.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB ba_bestfit_callee
XDEF asm_ba_bestfit

LIB error_enomem_zc

ba_bestfit_callee:

   pop hl
   pop de
   ex (sp),hl
   ld a,e

asm_ba_bestfit:

   ; enter : hl = queue
   ;          a = num
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated block
   ;
   ;         fail
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl

   or a
   jp z, error_enomem_zc       ; zero queues to search
   
   add hl,hl
   ld de,(__qbtl)              ; current queue table
   
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
