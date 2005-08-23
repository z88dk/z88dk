; 05.2005 aralbrec

XLIB l_qsort
LIB Lqsort, l_jpiy

.l_qsort

; void qsort(   void *base,
;               uint size,
;               char (*cmp)(const void *key, const void *datum)
;           );

; Lqsort for comments

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d         ; iy = (*cmp)
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld ix,compare
   ex de,hl
   jp Lqsort


.compare            ; an effective *key - *datum
   push hl          ; save registers
   push de          ; C params on stack -- NOTE CONST QUALIFIER!
   push bc
   call l_jpiy
   ld a,l
   pop bc
   pop de
   pop hl
   ret

; enter: BC = base address of array
;        HL = size of array
;        IX = cmp function (DE=key, BC=datum ; result in A (see ".compare"),
;                           MUST PRESERVE BC,DE,HL,IX registers)
; exit : array sorted
; uses : AF,BC,DE,HL,AF'
