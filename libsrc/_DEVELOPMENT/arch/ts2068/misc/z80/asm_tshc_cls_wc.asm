; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_wc

EXTERN asm_memset
EXTERN asm_tshc_cxy2aaddr, asm0_tshc_aaddrpdown

asm_tshc_cls_wc:

   ; enter :  l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

	ld a,l
	push af                     ; save attribute

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_tshc_cxy2aaddr     ; hl = attribute address

   ; ix = rect *
   ; hl = attribute address
   ; stack = attribute

   ld c,(ix+3)                 ; c = rect.height

pixel_loop_0:

   ld b,8

pixel_loop_1:

   pop af
	push af
	ld e,a                      ; e = attribute

   push bc
   
   ld b,0
   ld c,(ix+1)                 ; bc = rect.width

   call asm_memset             ; set attributes
   
	ld c,(ix+1)                 ; bc = rect.width
	ld e,b

	res 5,h
	call asm_memset             ; clear pixels
	
	set 5,h
	inc h

   pop bc
   djnz pixel_loop_1
   
   call asm0_tshc_aaddrpdown
   
   dec c
   jr nz, pixel_loop_0

   pop hl                      ; junk attribute
	ret
