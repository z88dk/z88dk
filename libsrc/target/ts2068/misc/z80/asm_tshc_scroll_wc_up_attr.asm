; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)
;
; Scroll the rectangular area upward by rows characters.
; Clear the vacated area.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_scroll_wc_up_attr
PUBLIC asm0_tshc_scroll_wc_up_attr

EXTERN asm1_zx_scroll_wc_up_pix, asm_tshc_cls_wc_attr
EXTERN asm_tshc_cxy2aaddr, asm_tshc_py2aaddr

asm_tshc_scroll_wc_up_attr:

   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl
   
   inc d
   dec d
   jp nz, asm_tshc_cls_wc_attr

asm0_tshc_scroll_wc_up_attr:

   inc e
   dec e
   ret z
   
   ld a,(ix+3)                 ; a = rect.height
   add a,a
   add a,a
   add a,a
   dec a
   
   sub e
   jp c, asm_tshc_cls_wc_attr
   
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
   
   call asm_tshc_cxy2aaddr
   ex de,hl                    ; de = destination screen address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,a
   add a,a
   add a,a
   add a,l
   ld l,a                      ; l = absolute y coord of copy up area
   
   call asm_tshc_py2aaddr

   jp asm1_zx_scroll_wc_up_pix
