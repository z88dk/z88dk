; Simulates a Mouse using Joystick Functions
; 06.2003, 09.2005 aralbrec

SECTION code_clib
PUBLIC INMouseSim
PUBLIC _INMouseSim
EXTERN l_jpix

; enter: HL = struct in_UDM *
; exit : C = button state 11111MRL active low
;        B = X coordinate (0..255)
;        A = Y coordinate (0..191)
; used : AF,BC,DE,HL,AF',IX
; note : last maxcount in struct in_UDM must be 255

.INMouseSim
._INMouseSim
   push ix
   ld e,(hl)
   inc hl
   ld d,(hl)               ; DE = struct in_UDK *
   inc hl
   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a                ; IX = joystick function pointer
   inc hl
   push hl
   push de
   ex de,hl
   call l_jpix             ; read joystick with optional parameter on stack, in HL
   pop de
   ld a,l
   and $0f
   jp z, nomovement
   ld a,l
   ex af,af                ; A' = F000RLDU active high
   pop hl                  ; HL = &in_UDM.delta

   ld e,(hl)
   inc hl
   ld d,(hl)               ; DE = base address of delta array
   inc hl
   ld a,(hl)               ; A = state = current index into delta array
   inc hl                  ; HL = &in_UDM.count

   ld c,a
   add a,a
   add a,a
   add a,c
   add a,e
   ld e,a
   jr nc, noinc
   inc d
   
.noinc                     ; DE = &delta[state]

   inc (hl)                ; increase current count
   jp nz, not255
   ld (hl),255
   jp samestate
   
.not255

   ld a,(de)               ; A = max count for this state
   cp (hl)
   jp nc, samestate
   ld (hl),0               ; clear current count to zero
   dec hl
   inc (hl)                ; advance to next state
   inc hl

.samestate                 ; HL = &in_UDM.count, DE = &delta[state], A' = F111RLDU active low

   inc hl                  ; HL = &in_UDM.y
   inc de                  ; DE = delta[state].dy
   ex de,hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   push bc                 ; stack = dx
   ld c,(hl)
   inc hl
   ld b,(hl)               ; BC = dy

   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                ; DE = &in_UDM.y + 1b, HL = y

.up

   ex af,af                ; A = F000RLDU active high
   rrca
   jr nc, down
   rrca                    ; swallow down, only doing up
   or a
   sbc hl,bc
   jp nc, endvertical
   ld hl,0
   jp endvertical
   
.down

   rrca
   jr nc, endvertical
   add hl,bc
   ex af,af
   ld a,h
   cp 192
   jr nc, notoutofrange
   ld h,191
   
.notoutofrange

   ex af,af

.endvertical                ; A = ??F000RL

   ex de,hl                 ; DE = new Y, HL = &in_UDM.y + 1b
   ld (hl),d
   dec hl
   ld (hl),e
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                 ; HL = x, DE = &in_UDM.x + 1b
   pop bc                   ; BC = dx

.left

   rrca
   jr nc,right
   rrca                     ; swallow right
   or a
   sbc hl,bc
   jp nc, endhorizontal
   ld hl,0
   jp endhorizontal
   
.right

   rrca
   jr nc, endhorizontal
   add hl,bc
   jp nc, endhorizontal
   ld hl,$ffff

.endhorizontal              ; A = ????F000

   ex de,hl                 ; DE = new x, HL = &in_UDM.x + 1b
   ld (hl),d
   dec hl
   ld (hl),e
   dec hl                   ; hl = in_UDM.y + 1b

   ld b,d                   ; B = x coord 0..255
   and $08
   ld c,0
   jr z, nofire
   inc c
   
.nofire                     ; C = mouse button state

   ld a,(hl)                ; A = y coord 0..191
   pop ix
   ret

.nomovement

   ld a,l                   ; A = F000RLDU active high
   pop hl                   ; HL = &in_UDM.delta

   inc hl
   inc hl
   ld (hl),0                ; state = 0
   inc hl
   ld (hl),0                ; count = 0

   ld c,0
   rla
   rl c                     ; C = 0000000L active high

   inc hl
   inc hl
   ld a,(hl)                ; A = y coord
   cp 192
   jr nc, notout
   ld a,191
   ld (hl),a
   
.notout

   inc hl
   inc hl
   ld b,(hl)                ; B = x coord
   pop ix
   ret
