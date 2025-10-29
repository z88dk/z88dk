
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)
;
; Scroll the rectangular area upward by rows characters.
; Clear the vacated area.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_wc_up_pix
PUBLIC asm0_zx_scroll_wc_up_pix
PUBLIC asm1_zx_scroll_wc_up_pix

EXTERN asm_zx_cls_wc_pix, asm_zx_cxy2saddr
EXTERN asm_zx_saddrpdown, asm_zx_py2saddr

asm_zx_scroll_wc_up_pix:

   ; enter : de = number of rows to scroll upward by
   ;          l = screen byte
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl
   
   inc d
   dec d
   jp nz, asm_zx_cls_wc_pix

asm0_zx_scroll_wc_up_pix:

   inc e
   dec e
   ret z
   
   ld a,(ix+3)                 ; a = rect.height
   add a,a
   add a,a
   add a,a
   dec a
   
   sub e
   jp c, asm_zx_cls_wc_pix
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = screen byte
   ; a = loop count
   
   ld b,a                      ; b = loop count
   push hl                     ; save screen byte
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_zx_cxy2saddr
   ex de,hl                    ; de = destination screen address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,a
   add a,a
   add a,a
   add a,l
   ld l,a                      ; l = absolute y coord of copy up area
   
   call asm_zx_py2saddr

asm1_zx_scroll_wc_up_pix:

   ld a,l
   add a,(ix+0)                ; add rect.x
   ld l,a                      ; hl = source screen address

copy_up_loop_0:

   push bc
   
   ld b,0
   ld c,(ix+1)                 ; bc = rect.width
   
   push hl
   push de
   
   ldir
   
   pop hl

   call asm_zx_saddrpdown
   ex de,hl
   
   pop hl

   call asm_zx_saddrpdown
   
   pop bc
   djnz copy_up_loop_0
   
   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows
   
   ex de,hl

   pop de
   ld a,e                      ; a = screen byte
   
vacate_loop_0:

   push bc
   
   ld b,0
   ld c,(ix+1)                 ; bc = rect.width
   
   ld (hl),a
   
   dec c
   jr z, end_pix_x
   
   push hl
   
   ld e,l
   ld d,h
   inc e
   
   ldir
   
   pop hl

end_pix_x:

   ld e,a
   call asm_zx_saddrpdown
   ld a,e
   
   pop bc
   djnz vacate_loop_0

   ret
