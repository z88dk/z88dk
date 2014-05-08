
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void balloc_init(unsigned char num)
;
; Clear all queues to empty.
;
; ===============================================================

PUBLIC asm_balloc_init

EXTERN __qtbl

EXTERN asm_p_forward_list_init

asm_balloc_init:

   ; enter : l = number of queues
   ;
   ; exit  : hl = address of byte following queue table
   ;
   ; uses  : af, b, de, hl

   ld a,l
   or a
   ret z                       ; if num == 0
   
   ld b,l
   ld hl,(__qtbl)

loop:

   call asm_p_forward_list_init  ; initialize a forward_list at address hl
   djnz loop
   
   ret
