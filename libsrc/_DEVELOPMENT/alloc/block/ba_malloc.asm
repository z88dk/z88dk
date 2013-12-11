
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_malloc(int queue)
;
; Allocate a block of memory from queue.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB ba_malloc
XDEF asm_ba_malloc

LIB error_enomem_zc

ba_malloc:
asm_ba_malloc:

   ; enter : hl = queue to allocate from
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
   
   add hl,hl
   ld de,(__qtbl)              ; current queue table
   add hl,de                   ; hl = q
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                    ; hl = first block in queue, de = q + 1b
   
   ld a,h
   or l
   jp z, error_enomem_zc       ; queue is empty
   
   inc hl                      ; copy link to next block from block to q
   ldd
   ld a,(hl)
   ld (de),a
   
   ret
