; void __CALLEE__ *sp1_PreShiftSpr_callee(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_PreShiftSpr_callee
PUBLIC ASMDISP_SP1_PRESHIFTSPR_CALLEE

.sp1_PreShiftSpr_callee

   pop af
   pop bc
   pop iy
   pop de
   pop hl
   ld b,l
   pop hl
   pop ix
   push af
   ld a,ixl
   ld h,a
   ld a,c

.asmentry

; enter :  a = right shift amount (0-7)
;          b = width in characters (# columns)
;          h = zero for 1-byte definition; otherwise 2-byte
;         de = source frame graphic
;         iy = destination frame address
;          l = height in characters
; exit  : hl = next available address
; uses  : af, bc, de, hl, af', iy

.SP1PreShiftSpr

   and $07
   inc a
   ld c,a                    ; c = right shift amount + 1
   
   ld a,l
   inc h
   dec h
   ld hl,dummy1byte          ; point at two 0 bytes if 1-byte def
   jr z, onebyte
   add a,a
   ld hl,dummy2byte          ; point at (255,0) pair if 2-byte def
   
.onebyte

   add a,a
   add a,a
   add a,a                   ; a = # bytes in graphic definition in each column
      
.dofirstcol                  ; first column has no graphics on left, will use dummy bytes for left

   push af                   ; save height of column in bytes
   push de                   ; save top of first column

.firstcolloop

   ex af,af                  ; a' = pixel height

   push bc                   ; save width and rotation amount
   ld b,c                    ; b = right shift + 1
   ld c,(hl)                 ; c = graphic byte from col on left
   ld a,1
   xor l
   ld l,a
   ld a,(de)                 ; a = graphic byte in current col
   inc de
   djnz firstsloop
   jp firstdoneshift

.firstsloop

   rr c
   rra
   djnz firstsloop

.firstdoneshift

   ld (iy+0),a               ; store shifted graphic in destination frame
   inc iy
   
   pop bc
   ex af,af
   dec a
   jr nz, firstcolloop

   pop hl
   pop af
   djnz nextcol
   
   push iy
   pop hl
   ret

.nextcol                     ; do rest of columns

   push af
   push de

;  a = height in pixels
; de = graphic definition for this column
; hl = graphic definition for column to left
;  b = width remaining in characters
;  c = right shift amount + 1

.colloop

   ex af,af
   
   push bc
   ld b,c
   ld a,(de)
   inc de
   ld c,(hl)
   inc hl
   djnz sloop
   jp doneshift

.sloop

   rr c
   rra
   djnz sloop

.doneshift

   ld (iy+0),a
   inc iy
   
   pop bc
   ex af,af
   dec a
   jr nz, colloop

   pop hl
   pop af
   djnz nextcol

   push iy
   pop hl
   ret

   defb 0
.dummy1byte
   defb 0,0
.dummy2byte
   defb 255,0

DEFC ASMDISP_SP1_PRESHIFTSPR_CALLEE = # asmentry - sp1_PreShiftSpr_callee
