; ===============================================================
; 2017
; ===============================================================
; 
; void sms_cls_wc(struct r_Rect8 *r, unsigned int background)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_cls_wc

EXTERN asm_sms_cxy2saddr, asm_sms_memsetw_vram

asm_sms_cls_wc:

   ; enter : hl = background character
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   ex de,hl                    ; de = background character

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_sms_cxy2saddr      ; hl = screen map address

   ; ix = rect *
   ; hl = screen map address
   ; de = background
   
   ld c,(ix+3)                 ; c = rect.height
   ld b,0

clear_loop:

   push bc
   push hl
   
   ld c,(ix+1)                 ; bc = rect.width
   
   ex de,hl
   call asm_sms_memsetw_vram
   
   pop hl
   
   ld c,64
   add hl,bc
   
   pop bc
   
   dec c
   jr nz, clear_loop

   ret
