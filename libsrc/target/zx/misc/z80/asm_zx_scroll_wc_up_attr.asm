
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)
;
; Scroll the attrs in the rectangular area upward by rows characters.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_wc_up_attr
PUBLIC asm0_zx_scroll_wc_up_attr

EXTERN asm_zx_cls_wc_attr, asm_zx_cxy2aaddr

asm_zx_scroll_wc_up_attr:

   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;         ix = rect *
   ;
   ; uses  : af bc, de, hl
   
   inc d
   dec d
   jp nz, asm_zx_cls_wc_attr

asm0_zx_scroll_wc_up_attr:

   inc e
   dec e
   ret z
   
   ld a,(ix+3)                 ; a = rect.height
   dec a
   
   sub e
   jp c, asm_zx_cls_wc_attr
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = attr
   ; a = loop count
   
   ld b,a                      ; b = loop count
   push hl                     ; save attr
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_zx_cxy2aaddr
   ex de,hl                    ; de = destination attr address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,l
   ld h,a                      ; h = absolute y coord of copy up area
   ld l,(ix+0)                 ; l = absolute x coord of copy up area
   
   call asm_zx_cxy2aaddr       ; hl = source attr address

copy_up_loop_0:

   ;; copy row of attributes
   
   push bc
   
   ld b,0
   ld c,(ix+1)                 ; c = rect.width
   
   ld a,32
   sub c
   
   ldir
   
   ld c,a                      ; c = offset to start of next row
   
   ex de,hl
   add hl,bc
   
   ex de,hl
   add hl,bc
   
   pop bc
   djnz copy_up_loop_0
   
   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows
   
   ex de,hl

   pop de
   ld a,e                      ; a = attr
   
vacate_loop_0:

   ;; clear row of attributes

   push bc
   
   ld b,0
   ld c,(ix+1)                 ; bc = rect.width
   
   ld (hl),a
   
   dec c
   jr z, end_attr_x
   
   push hl
   
   ld e,l
   ld d,h
   inc e
   
   ldir
   
   pop hl

end_attr_x:

   ld c,32
   add hl,bc
   
   pop bc
   djnz vacate_loop_0

   ret
