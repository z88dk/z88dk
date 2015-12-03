
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls_wc

EXTERN asm_memset, asm_zx_saddr2aaddr
EXTERN asm_zx_cyx2saddr, asm0_zx_saddrpdown

asm_zx_cls_wc:

   ; enter :  l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save attribute

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_zx_cyx2saddr       ; hl = screen address

   ; ix = rect *
   ; hl = screen address
   ; stack = attribute

   push hl                     ; save screen address

   ;; clear pixels

   ld c,(ix+3)                 ; c = rect.height

pixel_loop_0:

   ld b,8

pixel_loop_1:

   push bc
   
   ld b,0
   ld c,(ix+1)                 ; bc = rect.width
   
   ld e,b
   call asm_memset
   
   inc h
   
   pop bc
   djnz pixel_loop_1
   
   call asm0_zx_saddrpdown
   
   dec c
   jr nz, pixel_loop_0

   ;; clear attributes
   
   pop hl                      ; hl = screen address
   call asm_zx_saddr2aaddr     ; hl = attribute address
   
   ld c,(ix+3)                 ; bc = rect.height

attr_loop:

   pop de
   push de                     ; e = attribute
   
   push bc
   
   ld c,(ix+1)                 ; bc = rect.width
   
   call asm_memset
   
   ld c,32
   add hl,bc
   
   pop bc
   
   dec c
   jr nz, attr_loop

   pop hl                      ; junk attribute
   ret
