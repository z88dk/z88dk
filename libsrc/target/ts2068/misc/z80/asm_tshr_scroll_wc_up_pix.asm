; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)
;
; Scroll screen upward by rows pixels and clear vacated area.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_scroll_wc_up_pix
PUBLIC asm0_tshr_scroll_wc_up_pix

EXTERN asm_tshr_cls_wc_pix, asm_tshr_py2saddr
EXTERN asm_tshr_saddrpdown, asm_tshr_cxy2saddr

asm_tshr_scroll_wc_up_pix:

   ; enter : de = number of rows to scroll upward by
   ;          l = pix
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jp nz, asm_tshr_cls_wc_pix

asm0_tshr_scroll_wc_up_pix:

   inc e
   dec e
   ret z

   ld a,(ix+3)                 ; a = rect.height
   add a,a
   add a,a
   add a,a
   dec a
   
   sub e
   jp c, asm_tshr_cls_wc_pix
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = pix
   ; a = loop count
   
   ld b,a                      ; b = loop count
   push hl                     ; save pix
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_tshr_cxy2saddr
   ex de,hl                    ; de = destination screen address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,a
   add a,a
   add a,a
   add a,l
   ld l,a                      ; l = absolute y coord of copy up area
   
   call asm_tshr_py2saddr      ; hl = source screen address @ x = 0

   ld a,(ix+0)                 ; a = rect.x

   rra
   jr nc, even                 ; if column is even

   set 5,h

even:

   add a,l
   ld l,a                      ; hl = source screen address
   
   ;  b = loop count
   ; de = destination screen address
   ; hl = source screen address
   ; stack = pix, scroll amount

copy_up_loop_0:

   push bc
   
   push hl
   push de
   
   ld b,0
   ld c,(ix+1)                ; bc = rect.width
   
   bit 5,h
   jr nz, pixel_loop_odd

pixel_loop_even:

   ld a,(hl)
   ld (de),a
   
   dec c
   jr z, pixel_loop_end

   set 5,d
   set 5,h

pixel_loop_odd:

   ldi
   
   res 5,d
   res 5,h
   
   jp pe, pixel_loop_even
   
pixel_loop_end:

   pop hl                      ; hl = destination address
   
   call asm_tshr_saddrpdown
   ex de,hl                    ; de = destination address
   
   pop hl
   
   call asm_tshr_saddrpdown    ; hl = source address
   
   pop bc
   djnz copy_up_loop_0

   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows

   ex de,hl
   
   pop de                      ; e = pix

   ; e = pix
   ; b = number of rows to clear
   ; hl = screen address

vacate_loop_0:

   push bc
   push hl

   ld b,(ix+1)                 ; b = rect.width
   
   bit 5,h
   jr nz, vacate_loop_odd

vacate_loop_even:

   ld (hl),e                   ; clear pixels
   
   dec b
   jr z, vacate_loop_end
   
   set 5,h
   
vacate_loop_odd:

   ld (hl),e                   ; clear pixels
   
   res 5,h
   inc l
   
   djnz vacate_loop_even

vacate_loop_end:

   pop hl
   call asm_tshr_saddrpdown
   
   pop bc
   djnz vacate_loop_0
   
   ret
