
; SP1PreShiftSpr
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1PreShiftSpr

; Create copy of sprite's graphics shifted right 0-7
; pixels and store at destination address specified.
; The destination address can serve as a sprite frame
; address in the move sprite functions.
;
; There should be R*C*(8 or 16) bytes of free memory at
; the destination address for the new frame where R and
; C are the row and column sizes of the sprite in chars.
;
; enter : ix = & struct sp1_ss
;         iy = destination frame address
;          a = right shift amount (will be mod 8 here)
; exit  : iy = next free address after new frame

.SP1PreShiftSpr

   and $07
   ld c,a                    ; c = right shift amount

   ld h,(ix+15)
   ld l,(ix+16)              ; hl = & first struct sp1_cs in sprite

.collp

   push hl                   ; stack first sp1_cs in column
   
.docolumn

   ; ix = & struct sp1_ss
   ; hl = & struct sp1_cs
   ;  c = right shift amount
   ; iy = destination address
   
   push hl
   
   ; stack = & struct sp1_cs, 1st in col

   ld de,16
   add hl,de
   ld d,(hl)
   dec hl
   ld e,(hl)                 ; de = left char graphic ptr
   
   ld a,d                    ; if there is no left char graphic this is LB
   or a
   jr nz, notLB
   ld de,dummychar1          ; so use a blank dummy char for graphic
   bit 7,(ix+4)
   jr z, notLB
   ld de,dummychar2          ; use 2-byte definition dummy char

.notLB

   dec hl
   dec hl
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                    ; hl = char graphic ptr

   or a                      ; if there is no graphic in the char this is RB
   jr z, notRB
   ld hl,dummychar1          ; so use blank dummy char for graphic
   bit 7,(ix+4)
   jr z, notRB
   ld hl,dummychar2          ; use 2-byte definition dummy char
   
.notRB

   ld a,8
   bit 7,(ix+4)              ; is it a 2-byte definition?
   jr z, onebyte
   add a,a                   ; a = # bytes per char
   
.onebyte

   ld b,c                    ; b = shift amount
   
.charloop

   ex af,af                  ; a' = height of char (8 or 16)
   push bc

   ld c,(hl)                 ; c = char graphic
   inc hl

   ld a,(de)                 ; a = left graphic
   inc de

   inc b
   djnz shiftdone            ; in case right shift amount = 0

.shiftloop

   rra
   rr c
   djnz shiftloop

.shiftdone

   ; c = shifted char graphic
   
   ld (iy+0),c               ; store at destination address
   inc iy
   
   pop bc
   ex af,af
   dec a
   jp nz, charloop

   ; ix = & struct sp1_ss
   ; iy = destination address
   ;  c = right shift amount
   ; stack = & struct sp1_cs, 1st in col

   pop hl                    ; hl = & struct sp1_cs   
   ld b,(ix+2)               ; b = width of sprite in chars
   
   ; find struct sp1_cs directly underneath in same column
   
.nextincollp

   ld a,(hl)
   or a
   jp z, endcol
   
   inc hl
   ld l,(hl)
   ld h,a
   
   djnz nextincollp

   ; hl = & next struct sp1_cs in column
   ;  c = right shift
   ; iy = dest address
   ; ix = & struct sp1_ss
   ; stack = 1st in col

   jp docolumn

.endcol

   ;  c = right shift
   ; iy = dest address
   ; ix = & struct sp1_ss
   ; stack = 1st in col
   
   pop hl                    ; hl = first sp1_cs in column just done
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & struct sp1_cs in next column
   inc hl
   inc hl
   inc hl
   inc hl                    ; hl = & sp1_cs.type
   
   bit 6,(hl)                ; if the last column was just done
   ret nz                    ;   we're finished

   ex de,hl
   jp collp

.dummychar1                  ; just graphics

   defb 0,0,0,0,0,0,0,0

.dummychar2                  ; (mask,graph) pairs

   defb 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0
