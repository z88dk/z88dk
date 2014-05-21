
PUBLIC asm_cons_scroll_00

; scroll full screen upward by HL character rows
;
; * blanked row attribute values come from _cons_attr_p
; * _cons_cls_00 is called to clear screen

EXTERN asm_cons_cls_00, asm_memset, _cons_attr_p
EXTERN asm_zx_cy2saddr, asm_zx_cy2aaddr, asm_zx_saddrpdown

asm_cons_scroll_00:

   ; enter : hl = number of rows to scroll upward by
   ;
   ; uses  : af, bc, de, hl, de', bc', hl'

   inc h
   dec h
   jp nz, asm_cons_cls_00
   
   inc l
   dec l
   ret z
   
   ld a,23
   sub l
   jp c, asm_cons_cls_00
   
   inc a
   
   ; l = number of rows to scroll upward
   ; a = loop count
   
   ld c,a                      ; c = loop count
   push hl                     ; save scroll amount
   
   ;; copy upward
   
   call asm_zx_cy2saddr        ; hl = screen address corresponding to first scroll row L
   ld de,$4000                 ; destination screen address of first scroll row
   
   exx
   
   pop hl
   push hl                     ; hl = scroll amount
   
   call asm_zx_cy2aaddr        ; hl = attribute address corresponding to first scroll row L
   ld de,$5800                 ; destination attribute address of first scroll row

   exx

copy_up_loop_0:

   ; copy row of attributes upward
   
   exx
   
   ld bc,32
   ldir
   
   exx
   
   ; copy row of pixels upward
   
   ld b,8
      
copy_up_loop_1:

   push bc

   ld bc,32
   
   push de
   push hl
   
   ldir
   
   pop de
   pop hl
   
   call asm_zx_saddrpdown
   ex de,hl
   call asm_zx_saddrpdown
   
   pop bc
   djnz copy_up_loop_1
   
   dec c
   jr nz, copy_up_loop_0

   ;; clear vacated area

   pop bc                      ; c = scroll amount = number of vacated rows

   ex de,hl
   exx
   ex de,hl
   exx

vacate_loop_0:

   ; clear row of attributes
   
   exx
   
   ld a,(_cons_attr_p)
   ld e,a
   ld bc,32
   
   call asm_memset
   ex de,hl
   
   exx
   
   ; clear row of pixels
   
   ld b,8

vacate_loop_1:

   push bc
   
   ld e,0
   ld bc,32

   call asm_memset
   call asm_zx_saddrpdown
      
   pop bc
   djnz vacate_loop_1
   
   dec c
   jr nz, vacate_loop_0

   ret
