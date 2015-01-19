; void __CALLEE__ *sp1_PreShiftSpr_callee(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

PUBLIC sp1_PreShiftSpr_callee
PUBLIC ASMDISP_SP1_PRESHIFTSPR_CALLEE

.sp1_PreShiftSpr_callee

   pop af
   exx
   pop bc
   exx
   pop ix
   pop de
   pop bc
   ld b,c
   pop hl
   ld c,l
   pop hl
   push af
   ld h,l
   ld l,c
   exx
   ld a,c
   exx

.asmentry

; enter :  a = right shift amount (0-7)
;          b = width in characters (# columns)
;          h = zero for 1-byte definition; otherwise 2-byte
;         de = source frame graphic
;         ix = destination frame address
;          l = height in characters
; exit  : hl = next available address
; uses  : af, bc, de, hl, b', ix

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

   push de                   ; save top of first column
   exx
   ld b,a
   push bc                   ; save height of column in bytes

.firstcolloop

   exx
   
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

   ld (ix+0),a               ; store shifted graphic in destination frame
   inc ix
   
   pop bc
   exx
   djnz  firstcolloop

   pop bc
   exx
   pop hl
   djnz nextcol
   
   push ix
   pop hl
   ret

.nextcol                     ; do rest of columns

   push de
   exx
   push bc

; b' = height in pixels
; de = graphic definition for this column
; hl = graphic definition for column to left
;  b = width remaining in characters
;  c = right shift amount + 1

.colloop

   exx
   
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

   ld (ix+0),a
   inc ix
   
   pop bc
   exx
   djnz  colloop

   pop bc
   exx
   pop hl
   djnz nextcol

   push ix
   pop hl
   ret

   defb 0
.dummy1byte
   defb 0,0
.dummy2byte
   defb 255,0

DEFC ASMDISP_SP1_PRESHIFTSPR_CALLEE = # asmentry - sp1_PreShiftSpr_callee
