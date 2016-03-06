; 01.2007 aralbrec

                SECTION   code_crt0_sccz80
PUBLIC l_setmem

; Many places in the library have functions
; that initialize structures to 0.  This
; consolidates all those initializations into
; one quick routine.

; enter: a = init char, hl = top of struct
; usage: call l_setmem - 2*bytes + 1
;        where bytes = # bytes to write, up to 16

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl

   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a

.l_setmem
   
   ret
