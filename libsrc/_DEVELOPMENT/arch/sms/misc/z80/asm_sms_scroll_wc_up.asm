; ===============================================================
; 2017
; ===============================================================
; 
; void sms_scroll_wc_up(struct r_Rect8 *r, uchar rows, uint bgnd_char)
;
; Scroll the rectangular area upward by rows characters.
; Clear the vacated area.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_scroll_wc_up

EXTERN asm_sms_cls_wc, asm_sms_cxy2saddr
EXTERN asm_sms_memcpy_vram_to_vram, asm_sms_memsetw_vram

asm_sms_scroll_wc_up:

   ; enter :  e = number of rows to scroll upward by
   ;         hl = background character
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl, bc'

   inc e
   dec e
   ret z
   
   ld a,(ix+3)                 ; a = rect.height
   dec a
   
   sub e
   jp c, asm_sms_cls_wc
   
   inc a
   
   ;  e = number of rows to scroll upward
   ; hl = background character
   ;  a = copy row count
   
   ld b,a
   ld c,e
   
   push hl
   push bc
   
   ;; copy upward
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_sms_cxy2saddr
   ex de,hl                    ; de = copy to screen map address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,l                     ; add number of rows to scroll
   ld h,a                      ; h = y coord of copy up area
   ld l,(ix+0)                 ; l = x coord of copy up area
   
   call asm_sms_cxy2saddr      ; hl = copy from screen map address
   
   ld b,0
   
   exx

   pop bc
   
scroll_loop:

   ; b = copy row count
   ; c = scroll amount
   ; stack = background char
   
   exx
   
   ; hl = copy from vram address
   ; de = copy to vram address
   ;  b = 0
   ; stack = background char
   
   ld c,(ix+1)                 ; c = rect.width
   sla c
   
   call asm_sms_memcpy_vram_to_vram
   
   ld a,32
   sub (ix+1)
   add a,a
   ld c,a                      ; bc = displacement to next row of rect
   
   add hl,bc                   ; copy from += displacement
   ex de,hl
   
   add hl,bc                   ; copy to += displacement
   ex de,hl
   
   exx
   
   djnz scroll_loop
   
clear_blank:

   ; c = scroll amount
   ; stack = background char

   ld b,c
   
   exx
   ex de,hl                    ; hl = copy to address becomes next row to clear
   pop de                      ; de = background character
   exx

clear_loop:

   ; b = scroll amount = number of blank rows
   
   exx

   ; hl = screen map address
   ; de = background character
   ;  b = 0
   
   push hl
   
   ld c,(ix+1)                 ; c = rect.width
   
   ex de,hl
   call asm_sms_memsetw_vram

   pop hl
   
   ld c,64                     ; bc = displacement to next row of rect
   add hl,bc                   ; screen map address += displacement
   
   exx
   
   djnz clear_loop
   
   exx
   ret
