; uint in_LookupKey(uchar c)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

; Given the ascii code of a character, returns the scan row and mask
; corresponding to the key that needs to be pressed to generate the
; character.  Eg: Calling LookupKey with character 'a' will return
; '$fd' for key row and '$01' for the mask.  You could then check to
; see if the key is pressed with the following bit of code:
;
;   ld a,$fd
;   in a,($fe)
;   and $01
;   jr z, a_is_pressed
;
; The mask returned will have bit 7 set and bit 6 set to
; indicate if CAPS, SYM SHIFTS also have to be pressed to generate the
; ascii code, respectively.

; enter: L = ascii character code
; exit : carry set & HL=0 if ascii code not found
;        else: L = scan row, H = mask
;              bit 7 of H set if CAPS needs to be pressed
;              bit 6 of H set if SYM SHIFT needs to be pressed
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
   ld a,l
   ld hl,in_keytranstbl
   ld bc,160
   cpir
   jr nz, notfound

   ld a,159
   sub c                       ; A = position in table of ascii code
   ld l,b
   ld h,b

   cp 80
   jr c, nosymshift
   sub 80
   set 6,h

.nosymshift
   cp 40
   jr c, nocapshift
   sub 40
   set 7,h

.nocapshift
.div5loop
   inc b
   sub 5
   jp nc, div5loop

.donedivide
   add a,6                 ; A = bit position + 1, B = row + 1

   ld l,$7f
.rowlp
   rlc l
   djnz rowlp

   ld b,a
   ld a,$80
.masklp
   rlca
   djnz masklp

   or h
   ld h,a
   ret

.notfound
   ld hl,0
   scf
   ret
   
