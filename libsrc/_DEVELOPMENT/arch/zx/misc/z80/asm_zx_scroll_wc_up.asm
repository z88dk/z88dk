
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)
;
; Scroll the rectangular area upward by rows characters.
; Clear the vacated area.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_wc_up

EXTERN asm_zx_cls_wc, asm_zx_cyx2saddr, asm_zx_saddr2aaddr
EXTERN asm0_zx_saddrpdown, asm_memset

asm_zx_scroll_wc_up:

   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;         ix = rect *
   ;
   ; uses  : af bc, de, hl, bc', de', hl'
   
   inc d
   dec d
   jp nz, asm_zx_cls_wc
   
   inc e
   dec e
   ret z
   
   ld a,(ix+3)                 ; a = rect.height
   dec a
   
   sub e
   jp c, asm_zx_cls_wc
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = attr
   ; a = loop count
   
   ld c,a                      ; c = loop count
   push hl                     ; save attr
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ld h,(ix+2)                 ; h = rect.y
   ld l,(ix+0)                 ; l = rect.x
   
   call asm_zx_cyx2saddr
   ex de,hl                    ; de = destination screen address
   
   ld a,(ix+2)                 ; a = rect.y
   add a,l
   ld h,a                      ; h = absolute y coord of copy up area
   ld l,(ix+0)                 ; l = absolute x coord of copy up area
   
   call asm_zx_cyx2saddr       ; hl = source screen address
   
   push hl
   push de
   
   exx

   pop hl                      ; hl = destination screen address
   pop de                      ; de = source screen address
   
   call asm_zx_saddr2aaddr
   ex de,hl                    ; de = destination attribute address
   
   call asm_zx_saddr2aaddr     ; hl = source attribute address
   ld b,0
   
   exx

copy_up_loop_0:

   ;; copy row of attributes
   
   exx
   
   ld c,(ix+1)                 ; c = rect.width
   
   ld a,32
   sub c
   
   ldir
   
   ld c,a                      ; c = offset to start of next row
   
   ex de,hl
   add hl,bc
   
   ex de,hl
   add hl,bc
   
   exx
   
   ;; copy row of pixels
   
   ld b,8
   ld a,(ix+1)                 ; a = rect.width

copy_up_loop_1:

   push bc
   
   ld b,0
   ld c,a                      ; bc = rect.width
   
   push de
   push hl
   
   ldir
   
   pop hl
   pop de
   
   inc d
   inc h
   
   pop bc
   djnz copy_up_loop_1

   ex de,hl
   call asm0_zx_saddrpdown
   
   ex de,hl
   call asm0_zx_saddrpdown
   
   dec c
   jr nz, copy_up_loop_0
   
   ;; clear vacated area
   
   pop bc                      ; c = scroll amount = number of vacated rows
   
   ex de,hl
   exx
   
   ex de,hl
   exx

vacate_loop_0:

   ;; clear row of attributes
   
   exx
   
   pop de
   push de                     ; e = attribute
   
   ld c,(ix+1)                 ; bc = rect.width
   
   call asm_memset
   
   ld c,32
   add hl,bc
   
   exx
   
   ; clear row of pixels
   
   ld b,8

vacate_loop_1:

   push bc
   
   ld b,0
   ld c,(ix+1)                 ; bc = rect.width
   
   ld e,b
   call asm_memset
   
   inc h
   
   pop bc
   djnz vacate_loop_1
   
   call asm0_zx_saddrpdown

   dec c
   jr nz, vacate_loop_0
   
   pop de
   ret
