; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)
;
; Scroll screen upward by rows pixels and clear vacated area.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_scroll_wc_up
PUBLIC asm0_tshc_scroll_wc_up

EXTERN asm_tshc_cls_wc, asm_tshc_py2saddr
EXTERN asm_tshc_saddrpdown, asm_tshc_cxy2saddr

asm_tshc_scroll_wc_up:

   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jp nz, asm_tshc_cls_wc

asm0_tshc_scroll_wc_up:

   inc e
   dec e
   ret z

   ld a,(ix+3)                 ; a = rect.height
   add a,a
   add a,a
   add a,a
   dec a
   
   sub e
   jp c, asm_tshc_cls_wc
   
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
   
   call asm_tshc_cxy2saddr
   ex de,hl                    ; de = destination screen address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,a
   add a,a
   add a,a
   add a,l
   ld l,a                      ; l = absolute y coord of copy up area
   
   call asm_tshc_py2saddr      ; hl = source screen address @ x = 0

   ld a,(ix+0)                 ; a = rect.x
   add a,l
   ld l,a                      ; hl = source screen address
   
   ;  b = loop count
   ; de = destination screen address
   ; hl = source screen address
   ; stack = attr, scroll amount

copy_up_loop:

   push bc

   ld b,0
   ld c,(ix+1)                ; bc = rect.width

   ldir
   
   dec de
   dec hl
   
   set 5,d
   set 5,h
   
   ld c,(ix+1)
   
   lddr
   
   inc de
   inc hl
   
   res 5,d
   res 5,h
   
   ex de,hl
   call asm_tshc_saddrpdown
   
   ex de,hl
   call asm_tshc_saddrpdown
   
   pop bc
   djnz copy_up_loop

   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows

   ex de,hl
   
   pop de
   ld a,e                      ; a = attr

   ; a = attr
   ; b = number of rows to clear
   ; hl = screen address

vacate_loop_0:

   push bc

   ld c,(ix+1)                 ; c = rect.width

   ld (hl),0
   
   dec c
   jr z, vacate_loop_1
   
   ld e,l
   ld d,h
   inc e
   
   ld b,0
   ldir

vacate_loop_1:

   ld c,(ix+1)
   
   set 5,h
   ld (hl),a
   
   dec c
   jr z, vacate_loop_2
   
   dec de
   dec e
   
   lddr

vacate_loop_2:

   ld e,a
   call asm_tshc_saddrpdown
   ld a,e
   
   pop bc
   djnz vacate_loop_0
   
   ret
