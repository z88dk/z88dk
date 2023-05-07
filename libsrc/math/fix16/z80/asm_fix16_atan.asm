;
; Z80 fixed Q8.8 maths routines
;
; These routines have been adapted from two sources:
;
; https://github.com/Zeda/Z80-Optimized-Routines/tree/master/math
;
; With the following licence:
;
; 1. This License does not apply to any file with a separate License header.
; 2. Permission is granted, free of charge, to use, modify, and/or distribute any part of this software for any purpose.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
; WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
; COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
;
; Written by Zeda Thomas zedae.z80@gmail.com, Aug 2019


    SECTION code_math
    PUBLIC  asm_fix16_atan

asm_fix16_atan:
    ex      de,hl
    call    arctan_88
    ex      de,hl
    ret

arctan_88:
;Input:
;   D.E
;Output: atan(D.E)->D.E
   push de
   ld a,d
   or a
   jp p,$+5
   neg
   ld d,a
   dec a
   jr nz,checkneedinv
   inc e
   dec e
   jr nz,checkneedinv
   pop af
   rla
   ld de,201
   ret nc
   ld de,-201
   ret
checkneedinv:
   inc a
   call nz,DEgt1_Inv
;0.E is the value to atan
   ld hl,adjustatan
   push hl
   ld a,e
   cp 46
   ret c
   dec a
   cp 42h
   ret c
   dec a
   cp 4Eh
   ret c
   dec a
   cp 57h
   ret c
   dec a
   cp 5Eh
   ret c
   dec a
   cp 64h
   ret c
   dec a
   cp 6Ah
   ret c
   dec a
   cp 6Fh
   ret c
   sub 6Fh
   ld e,a
   ld hl,atanlut
   add hl,de
   ld a,(hl)
   ret
adjustatan:
   ld e,a
   pop bc
   ld a,b
   or a
   jp p,$+5
   neg
   jr z,$+9
   ld hl,402
   or a
   sbc hl,de
   ex de,hl
   rl b
   ret nc
   xor a
   sub e
   ld e,a
   sbc a,a
   sub d
   ld d,a
   ret


DEgt1_Inv:
;Works if DE>1
   ld hl,256
   ld b,8
InvLoop:
   add hl,hl
   sbc hl,de
   jr nc,$+3
   add hl,de
   adc a,a
   djnz InvLoop
    cpl
   ld e,a
    ld d,b
    ret
atanlut:
defb $6F
defb $6F
defb $70
defb $71
defb $72
defb $73
defb $73
defb $74
defb $75
defb $76
defb $77
defb $77
defb $78
defb $79
defb $7A
defb $7B
defb $7B
defb $7C
defb $7D
defb $7E
defb $7F
defb $7F
defb $80
defb $81
defb $82
defb $82
defb $83
defb $84
defb $85
defb $85
defb $86
defb $87
defb $88
defb $88
defb $89
defb $8A
defb $8B
defb $8B
defb $8C
defb $8D
defb $8E
defb $8E
defb $8F
defb $90
defb $90
defb $91
defb $92
defb $93
defb $93
defb $94
defb $95
defb $95
defb $96
defb $97
defb $97
defb $98
defb $99
defb $9A
defb $9A
defb $9B
defb $9C
defb $9C
defb $9D
defb $9E
defb $9E
defb $9F
defb $A0
defb $A0
defb $A1
defb $A2
defb $A2
defb $A3
defb $A3
defb $A4
defb $A5
defb $A5
defb $A6
defb $A7
defb $A7
defb $A8
defb $A9
defb $A9
defb $AA
defb $AA
defb $AB
defb $AC
defb $AC
defb $AD
defb $AD
defb $AE
defb $AF
defb $AF
defb $B0
defb $B0
defb $B1
defb $B2
defb $B2
defb $B3
defb $B3
defb $B4
defb $B5
defb $B5
defb $B6
defb $B6
defb $B7
defb $B7
defb $B8
defb $B9
defb $B9
defb $BA
defb $BA
defb $BB
defb $BB
defb $BC
defb $BC
defb $BD
defb $BE
defb $BE
defb $BF
defb $BF
defb $C0
defb $C0
defb $C1
defb $C1
defb $C2
defb $C2
defb $C3
defb $C3
defb $C4
defb $C4
defb $C5
defb $C6
defb $C6
defb $C7
defb $C7
defb $C8
defb $C8
defb $C9
