.label nop              ; opcode with label
label: nop              ; opcode with label
nop                     ; single opcode
ld a, b                 ; b as register
ld a, b+1               ; b+1 as expression, not b as register
altd ioe bit 0, (ix)    ; long opcode, but valid in some CPUs
ldir                    ; invalid opcode in some CPUs, but valid in others
dwjnz label             ; invalid opcode in some CPUs, but valid in others
out (bc), 0             ; Is_0, None
im 1                    ; Is_0_1_2, Is_0_1_2_3, Select2, Select3
bit 0, a                ; Is_0_1_2_3_4_5_6_7, AddScaled
rst $20                 ; Is_1_2_3_4_5_6_7_0_8_10_18_20_28_30_38, Is_2_3_4_5_7_10_18_20_28_38, ScaleBelowThreshold
rl 4, bcde              ; Is_1_2_4, AddScaled
rlc 8, bcde             ; Is_1_2_4_8, AddScaled
rst v, $40              ; Is_40, None
rla 8, bcde             ; Is_8, None
rlc 1, bcde             ; Is_1_2_4_8, SelectOrAdd
ld a, 1+2*3             ; Unsigned
ld a, (1+2*3)           ; Unsigned
ld a, (ix+1+2*3)        ; Signed
ld a, (hl)              ; ambiguity expression vs register
ld a, (bc)              ; ambiguity expression vs register
ldh (0x01), a           ; HighByte
ldh (0xFF01), a         ; HighByte
push 0x1234             ; BigEndian
jr label                ; PCrelative
jr nc, label            ; PCrelative
jre label               ; PCrelative
ld (ix+1+2*3), bc       ; signed8()
ld de, sp+1+2*3         ; unsigned8()
ld a, (hl)
ld a, (ix)
ld a, (b+c)
ld a, -1
ld a, ~1
ld a, (ix-3)
ld a, (iy+(-2))
jp (hl)
jp (ix)
jp (1234)
ret
ret nz
ld a, 0x1234
ld a, 1+                ; error in expression
