; 05.2005 aralbrec

XLIB l_bsearch
LIB Lbsearch, l_jpiy

.l_bsearch

; void *bsearch(   const void *key,
;                  const void *base,
;                  uint n,
;                  char (*cmp)(const void *key, const void *datum)
;              );

; see Lbsearch for comments

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d         ; IY = C cmp function
   ld e,(hl)
   inc hl
   ld d,(hl)        ; DE = n
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)        ; AB = base
   inc hl
   ld c,(hl)
   inc hl
   ld h,(hl)        ; HC = key
   ld l,b
   ld b,h           ; BC = key
   ld h,a           ; HL = base
   ex de,hl
   ld ix,compare
   call Lbsearch
   ret nc
   ld hl,0
   ret

.compare            ; an effective *key - *datum
   push de          ; save registers
   push bc          ; C params on stack -- NOTE CONST QUALIFIER!
   push hl
   call l_jpiy
   ld a,l
   pop hl
   pop bc
   pop de
   ret

; enter: BC = key
;        DE = base address of array
;        HL = size of array
;        IX = cmp function (BC=key, HL=datum ; result in A (see ".compare"),
;                           MUST PRESERVE BC,DE,HL,IX registers)
; exit : HL = address of found item
;        carry set indicates item not found
; uses : AF,DE,HL
