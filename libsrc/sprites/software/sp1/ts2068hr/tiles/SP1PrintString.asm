; m/c entry point for print string function
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC SP1PrintString

EXTERN sp1_GetUpdateStruct_callee, l_jpix
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
EXTERN SP1V_UPDATELISTT, SP1V_DISPWIDTH

; A sophisticated print string function
;
; The string to print is pointed at by HL and terminates with a 0 byte.
; Characters are printed as background tiles
; with the following special character codes understood:
;
; code     meaning
; ----     -------
;   0      terminate string
;   1      NOP N* [other ports: logically AND into attribute mask N*]
;   2      gotoy N* (goto y coordinate on same column)
;   3      ywrap N*
;   4      NOP N* [other ports: attribute mask N*]
;   5      16-bit tile code follows W*
;   6      gotox N* (goto x coordinate on same line)
;   7      print string at address W* (like a subroutine call / macro for printstrings; see also 26,28)
;   8      left
;   9      right
;  10      up
;  11      down
;  12      home (to top left of bounds rectangle)
;  13      carriage return (move to start of next line in bounds rectangle)
;  14      repeat N*
;  15      endrepeat
;  16      NOP N* [other ports: ink N*]
;  17      NOP N* [other ports: paper N*]
;  18      NOP N* [other ports: flash N*]
;  19      NOP N* [other ports: bright N*]
;  20      NOP N* [other ports: attribute N*]
;  21      invalidate N*
;  22      AT y(N*),x(N*) (relative to bounds rectangle)
;  23      AT dy(N*), dx(N*)  (relative to current position in bounds rectangle)
;  24      xwrap N*
;  25      yinc N*
;  26      push state
;  27      escape, next char is literal not special code
;  28      pop state
;  29      transparent char
;  30      NOP N* [other ports: logically OR into attribute mask N*]
;  31      visit : call function pointed at by ix with current struct_sp1_update as parameter
;
; * N is a single byte parameter following the code.
; * W is a 16-bit parameter following the code.
;
; All printing is done within a bounds rectangle.  No printing outside this
; bounds rectangle will occur.
;
; enter:  HL = address of string to print
;          E = flags (bit 0 = invalidate?, bit 1 = xwrap?, bit 2 = yinc?, bit3 = ywrap?)
;          B = current x coordinate (relative to bounds rect IY)
;          C = current y coordinate (relative to bounds rect IY)
;    (    HL' = & tail struct sp1_update.ulist in invalidated list   ) loaded here, not entry condition
;        DE' = current struct sp1_update *
;         IX = visit function
;       IY+0 = row coordinate   \
;       IY+1 = col coordinate   |  Bounds Rectangle
;       IY+2 = width in chars   |  Must Fit On Screen
;       IY+3 = height in chars  /
; exit : same as enter
; uses : all except ix, iy
;
; The C API maintains a structure to retain the print state between calls.
; Doing something similar from assembly language may be helpful.

.SP1PrintString

   exx
   ld hl,(SP1V_UPDATELISTT)
   ld bc,5
   add hl,bc
   exx
   
   call psloop
   
   exx
   ld (hl),0
   ld bc,-5
   add hl,bc
   ld (SP1V_UPDATELISTT),hl
   exx
   ret

.psloop

   ld a,(hl)
   or a
   ret z
   
   inc hl
   cp 32
   jp nc, printable

   ; here we have a special code [1,31]

   push hl
   ld d,a
   add a,a                   ; get address of handler from jump table
   ld h,jumptbl/256
   add a,jumptbl%256
   ld l,a
   jp nc, nospill
   inc h
.nospill
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld a,d                    ; restore A to code
   ex (sp),hl
   ret

.jumptbl
   defw NOP0, NOP1, codeGotoY, codeYWrap
   defw NOP1, codeTC, codeGotoX, codePString
   defw codeLeft, codeRight, codeUp, codeDown
   defw codeHome, codeReturn, codeRepeat, codeEndRepeat
   defw NOP1, NOP1, NOP1, NOP1
   defw NOP1, codeInvalidate, codeAt, codeAtRel
   defw codeXWrap, codeYInc, codePush, codeEscape
   defw codePop, codeTransparent, NOP1, codeVisit

.NOP1

   inc hl              ; consume a single byte parameter

   ; fall through to NOP0

.NOP0

   jp psloop           ; on to the next byte to interpret

.codeVisit
   ld a,b              ; only visit if inbounds
   cp (iy+2)
   jp nc, psloop
   ld a,c
   cp (iy+3)
   jp nc, psloop

   push bc
   push de
   push hl
   exx
   push hl
   push de
   ex de,hl
   call l_jpix
   pop de
   pop hl
   exx
   pop hl
   pop de
   pop bc
   jp psloop

.codeYWrap
   ld a,(hl)           ; parameter following YWRAP (0/1)
   inc hl
   rra
   jp nc, noywrap
   set 3,e
   jp psloop
.noywrap
   res 3,e
   jp psloop

.codeEscape
   ld a,(hl)          ; char following ESCAPE
   inc hl
   jp printable

.codePop
   exx
   pop de
   exx
   pop de
   pop bc
   jp psloop

.codePush
   push bc
   push de
   exx
   push de
   exx
   jp psloop

.codeYInc
   ld a,(hl)           ; parameter following YINC (0/1)
   inc hl
   rra
   jp nc, noywrap5
   set 2,e
   jp psloop
.noywrap5
   res 2,e
   jp psloop

.codeXWrap
   ld a,(hl)           ; parameter following XWRAP (0/1)
   inc hl
   rra
   jp nc, noxwrap
   set 1,e
   jp psloop
.noxwrap
   res 1,e
   jp psloop

.codeAtRel
   ld a,(hl)
   add a,c
   ld c,a
   inc hl
   ld a,(hl)
   add a,b
   ld b,a
   inc hl
   jp computenewupdate

.codeAt
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   jp computenewupdate

.codeGotoX

   ld b,(hl)
   inc hl
   jp computenewupdate

.codeGotoY

   ld c,(hl)
   inc hl
   jp computenewupdate

.codePString
   ld a,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push hl
   ld h,d
   ld l,a
   call psloop
   pop hl
   jp psloop

.codeInvalidate
   ld a,(hl)           ; parameter following INVALIDATE (0/1)
   inc hl
   srl e
   rra
   rl e
   jp psloop

.codeHome

   ld bc,0
   jp computenewupdate

.codeReturn

   ld b,0
   inc c
   jp computenewupdate

.codeRepeat

   ld a,(hl)           ; # times to repeat
   inc hl
.reploop
   push hl             ; save string position at start of repeat block
   push af             ; save # remaining iterations
   call psloop         ; returns after endrepeat or 0 terminator
   pop af
   dec a               ; any more iterations?
   jr z, nomoreiter
   pop hl              ; restore string pointer for next repeat
   jp reploop
.nomoreiter
   pop af              ; trash saved string position
   jp psloop

.codeEndRepeat

   ret
   
.codeTC                      ; a 16 bit tile code follows

   ; first check if in bounds
   
   ld a,b
   cp (iy+2)
   jr nc, codeRight2
   ld a,c
   cp (iy+3)
   jr nc, codeRight2
   
   ; are we invalidating?
   
   bit 0,e
   push hl
   exx
   jr z, noinvalidation2

   ; invalidate the char

   ld a,(de)
   xor $80
   jp p, noinvalidation2     ; if already invalidated, skip
   ld (de),a   
   ld (hl),d
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de

.noinvalidation2
   
   pop bc                    ; bc = & 16-bit tile
   ld a,(bc)
   inc de
   ld (de),a                 ; write tile into sp1_update
   inc bc
   ld a,(bc)
   inc de
   ld (de),a
   dec de
   dec de

   exx

.codeRight2                  ; skip 16-bit tile code in string

   inc hl
   inc hl
      
   ; advance to next char on right
    
   jp codeRight

.codeTransparent

   ; are we invalidating?
   
   bit 0,e
   jp z, codeRight
   
   ; invalidate the char
   
   exx
   ld a,(de)
   xor $80
   jp p, noinvalidation20    ; if already invalidated, skip
   ld (de),a   
   ld (hl),d
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de

.noinvalidation20
   
   exx
   jp codeRight

.printable                   ; a = tile#

   ex af,af

   ; first check if in bounds
   
   ld a,b
   cp (iy+2)
   jr nc, codeRight
   ld a,c
   cp (iy+3)
   jr nc, codeRight
   
   ; are we invalidating?
   
   bit 0,e
   exx
   jr z, noinvalidation

   ; invalidate the char

   ld a,(de)
   xor $80
   jp p, noinvalidation      ; if already invalidated, skip
   ld (de),a   
   ld (hl),d
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de

.noinvalidation
   
   ex de,hl
   inc hl
   ex af,af
   ld (hl),a                 ; store tile
   inc hl
   ld (hl),0
   
   ; advance to next char on right
   
   dec hl
   dec hl
   ex de,hl
   exx
   
.codeRight

   inc b                     ; increase x coord
   bit 1,e                   ; are we doing x wrap?
   jr nz, yesxwrap

.inxbounds

   exx                       ; move update struct to right
   ld a,9
   add a,e
   ld e,a
   jp nc, noinc1
   inc d
.noinc1
   exx
   
   jp psloop

.yesxwrap

   ld a,b
   cp (iy+2)
   jr c, inxbounds
   ld b,0
   
   bit 2,e                   ; are we doing yinc?
   jr z, noyinc
   inc c
   
   bit 3,e                   ; are we doing ywrap?
   jr z, noyinc
   ld a,c
   cp (iy+3)
   jr c, noyinc
   ld c,0

.noyinc
.computenewupdate

   ; need to compute struct sp1_update for new coords
   
   push bc
   exx
   ex (sp),hl
   ld a,(iy+0)
   add a,l
   ld d,a
   ld a,(iy+1)
   add a,h
   ld e,a
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   ex de,hl
   pop hl
   exx
   
   jp psloop

.codeLeft

   dec b
   bit 1,e
   jr nz, yesxwrap2

.inxbounds2
   
   exx
   ld a,-9
   add a,e
   ld e,a
   ld a,$ff
   adc a,d
   ld d,a
   exx
   jp psloop
   
.yesxwrap2

   ld a,b
   cp (iy+2)
   jr c, inxbounds2
   ld b,(iy+2)
   dec b
   
   bit 2,e
   jr z, computenewupdate
   dec c
   
   bit 3,e
   jr z, computenewupdate
   
   ld a,c
   cp (iy+3)
   jr c, computenewupdate
   ld c,(iy+3)
   dec c
   jp computenewupdate

.codeUp

   dec c
   bit 3,e
   jr nz, yesywrap
   
.inybounds

   exx
   ld a,#(-SP1V_DISPWIDTH*9) & 0xff
   add a,e
   ld e,a

   ld a,-SP1V_DISPWIDTH*9/256
;   ld a,#(((SP1V_DISPWIDTH*9):$ffff)+1)/256

   adc a,d
   ld d,a
   exx
   jp psloop

.yesywrap

   ld a,c
   cp (iy+3)
   jr c, inybounds
   ld c,(iy+3)
   dec c
   jp computenewupdate

.codeDown

   inc c
   bit 3,e
   jr nz, yesywrap2

.inybounds2

   exx
   ld a,0+(SP1V_DISPWIDTH*9)%256
   add a,e
   ld e,a
   ld a,0+(SP1V_DISPWIDTH*9)/256
   adc a,d
   ld d,a
   exx
   jp psloop

.yesywrap2

   ld a,c
   cp (iy+3)
   jr c, inybounds2
   ld c,0
   jp computenewupdate
