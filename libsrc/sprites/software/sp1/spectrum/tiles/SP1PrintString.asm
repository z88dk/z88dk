; m/c entry point for print string function
; 05.2006, 12.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1PrintString

EXTERN sp1_GetUpdateStruct_callee, l_jpix
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
EXTERN SP1V_UPDATELISTT, SP1V_DISPWIDTH

; A sophisticated print string function
;
; The string to print is pointed at by HL and terminates with a 0 byte.
; Characters are printed as background tiles (ie a tile# and colour/pallette)
; with the following special character codes understood:
;
; code     meaning
; ----     -------
;   0      terminate string
;   1      logically AND into attribute mask N*
;   2      gotoy N* (goto y coordinate on same column)
;   3      ywrap N*
;   4      attribute mask N*
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
;  16      ink N*
;  17      paper N*
;  18      flash N*
;  19      bright N*
;  20      attribute N*
;  21      invalidate N*
;  22      AT y(N*),x(N*) (relative to bounds rectangle)
;  23      AT dy(N*), dx(N*)  (relative to current position in bounds rectangle)
;  24      xwrap N*
;  25      yinc N*
;  26      push state
;  27      escape, next char is literal not special code
;  28      pop state
;  29      transparent char
;  30      logically OR into attribute mask N*
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
;         B' = current attribute mask
;         C' = current colour
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
   ld a,6
   add a,l
   ld l,a
   jp nc, noinc0
   inc h
.noinc0
   exx
   
   call psloop
   
   exx
   ld (hl),0
   ld a,-6
   add a,l
   ld l,a
   ld a,$ff
   adc a,h
   ld h,a
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
   defw printable, codeAMaskAND, codeGotoY, codeYWrap
   defw codeAMask, codeTC, codeGotoX, codePString
   defw codeLeft, codeRight, codeUp, codeDown
   defw codeHome, codeReturn, codeRepeat, codeEndRepeat
   defw codeInk, codePaper, codeFlash, codeBright
   defw codeAttribute, codeInvalidate, codeAt, codeAtRel
   defw codeXWrap, codeYInc, codePush, codeEscape
   defw codePop, codeTransparent, codeAMaskOR, codeVisit

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
   push bc
   push hl
   push de
   ex de,hl
   call l_jpix
   pop de
   pop hl
   pop bc
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
   pop bc
   exx
   pop de
   pop bc
   jp psloop

.codePush
   push bc
   push de
   exx
   push bc
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

.codeAMaskAND

   ld a,(hl)
   inc hl
   exx
   and b
   ld b,a
   exx
   jp psloop

.codeAMaskOR

   ld a,(hl)
   inc hl
   exx
   or b
   ld b,a
   exx
   jp psloop

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
;   exx
;   ld a,6
;   add a,l
;   ld l,a
;   jp nc, noinc5
;   inc h
;.noinc5
;   exx
   jp psloop

.codeInvalidate
   ld a,(hl)           ; parameter following INVALIDATE (0/1)
   inc hl
   srl e
   rra
   rl e
   jp psloop

.codeAttribute
   ld a,(hl)           ; parameter following ATTRIBUTE
   inc hl
   exx
   ld c,a
   exx
   jp psloop

.codeBright
   ld a,(hl)           ; parameter following BRIGHT (0/1)
   inc hl
   exx
   rra
   jp nc,nobright
   set 6,c
   exx
   jp psloop
.nobright
   res 6,c
   exx
   jp psloop

.codeFlash
   ld a,(hl)           ; parameter following FLASH (0/1)
   inc hl
   exx
   rl c
   rra
   rr c
   exx
   jp psloop

.codePaper
   ld a,(hl)           ; parameter following PAPER (0-7)
   inc hl
   rla
   rla
   rla
   and $38             ; move paper to bits 5:3
   exx
   ex af,af'
   ld a,c              ; get current attribute
   and $c7             ; throw away current paper colour
   ld c,a
   ex af,af'           ; get new paper colour
   or c
   ld c,a              ; set new attribute
   exx
   jp psloop

.codeInk
   ld a,(hl)           ; parameter following INK (0-7)
   and $07
   inc hl
   exx
   ex af,af'           ; save ink colour
   ld a,c              ; get current attribute
   and $f8             ; clear current ink
   ld c,a
   ex af,af'           ; get new ink colour
   or c
   ld c,a              ; set new ink colour
   exx
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

.codeAMask

   ld a,(hl)
   inc hl
   exx
   ld b,a
   exx
   jp psloop
   
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
   ld hl,6
   add hl,de

.noinvalidation2
   
   ex de,hl
   inc hl
   ld a,b
   and (hl)                  ; do attr mask
   or c
   ld (hl),a                 ; store bgnd colour
   inc hl
   
   exx
   ld a,(hl)
   inc hl
   push hl
   ld h,(hl)
   ld l,a
   ex (sp),hl
   inc hl
   exx
   
   ex de,hl
   ex (sp),hl
   ex de,hl
   ld (hl),e                 ; store tile
   inc hl
   ld (hl),d
   pop de
   
   ; advance to next char on right
   
   dec hl
   dec hl
   dec hl
   ex de,hl
   exx
 
   jp codeRight
   
.codeRight2

   inc hl
   inc hl
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
   ld hl,6
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
   ld hl,6
   add hl,de

.noinvalidation
   
   ex de,hl
   inc hl
   ld a,b
   and (hl)                  ; do attr mask
   or c
   ld (hl),a                 ; store bgnd colour
   inc hl
   ex af,af
   ld (hl),a                 ; store tile
   inc hl
   ld (hl),0
   
   ; advance to next char on right
   
   dec hl
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
   ld a,10
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
   ld a,-10
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
   ld a,#(-SP1V_DISPWIDTH*10) & 0xff
   add a,e
   ld e,a
   ld a,-SP1V_DISPWIDTH*10/256
;   ld a,#(((SP1V_DISPWIDTH*10):$ffff)+1)/256
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
   ld a,0+(SP1V_DISPWIDTH*10)%256
   add a,e
   ld e,a
   ld a,0+(SP1V_DISPWIDTH*10)/256
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
