 altd ld a, (bc)                ; 76 0A
 ld a', (bc)                    ; 76 0A
 altd ld a, (de)                ; 76 1A
 ld a', (de)                    ; 76 1A
 altd add a, b                  ; 76 80
 altd add b                     ; 76 80
 add a', b                      ; 76 80
 altd add a, c                  ; 76 81
 altd add c                     ; 76 81
 add a', c                      ; 76 81
 altd add a, d                  ; 76 82
 altd add d                     ; 76 82
 add a', d                      ; 76 82
 altd add a, e                  ; 76 83
 altd add e                     ; 76 83
 add a', e                      ; 76 83
 altd add a, h                  ; 76 84
 altd add h                     ; 76 84
 add a', h                      ; 76 84
 altd add a, l                  ; 76 85
 altd add l                     ; 76 85
 add a', l                      ; 76 85
 altd add a, a                  ; 76 87
 altd add a                     ; 76 87
 add a', a                      ; 76 87
 altd add a, (hl)               ; 76 86
 altd add (hl)                  ; 76 86
 add a', (hl)                   ; 76 86
 altd add a, (ix)               ; 76 DD 86 00
 altd add a, (ix + 127)         ; 76 DD 86 7F
 altd add a, (ix - 128)         ; 76 DD 86 80
 altd add (ix)                  ; 76 DD 86 00
 altd add (ix + 127)            ; 76 DD 86 7F
 altd add (ix - 128)            ; 76 DD 86 80
 add a', (ix)                   ; 76 DD 86 00
 add a', (ix + 127)             ; 76 DD 86 7F
 add a', (ix - 128)             ; 76 DD 86 80
 altd add a, (iy)               ; 76 FD 86 00
 altd add a, (iy + 127)         ; 76 FD 86 7F
 altd add a, (iy - 128)         ; 76 FD 86 80
 altd add (iy)                  ; 76 FD 86 00
 altd add (iy + 127)            ; 76 FD 86 7F
 altd add (iy - 128)            ; 76 FD 86 80
 add a', (iy)                   ; 76 FD 86 00
 add a', (iy + 127)             ; 76 FD 86 7F
 add a', (iy - 128)             ; 76 FD 86 80
 altd add a,  42                ; 76 C6 2A
 altd add a, (42)               ; 76 C6 2A
 altd add  42                   ; 76 C6 2A
 altd add (42)                  ; 76 C6 2A
 add a',  42                    ; 76 C6 2A
 add a', (42)                   ; 76 C6 2A
 altd adc a, b                  ; 76 88
 altd adc b                     ; 76 88
 adc a', b                      ; 76 88
 altd adc a, c                  ; 76 89
 altd adc c                     ; 76 89
 adc a', c                      ; 76 89
 altd adc a, d                  ; 76 8A
 altd adc d                     ; 76 8A
 adc a', d                      ; 76 8A
 altd adc a, e                  ; 76 8B
 altd adc e                     ; 76 8B
 adc a', e                      ; 76 8B
 altd adc a, h                  ; 76 8C
 altd adc h                     ; 76 8C
 adc a', h                      ; 76 8C
 altd adc a, l                  ; 76 8D
 altd adc l                     ; 76 8D
 adc a', l                      ; 76 8D
 altd adc a, a                  ; 76 8F
 altd adc a                     ; 76 8F
 adc a', a                      ; 76 8F
 altd adc a, (hl)               ; 76 8E
 altd adc (hl)                  ; 76 8E
 adc a', (hl)                   ; 76 8E
 altd adc a, (ix)               ; 76 DD 8E 00
 altd adc a, (ix + 127)         ; 76 DD 8E 7F
 altd adc a, (ix - 128)         ; 76 DD 8E 80
 altd adc (ix)                  ; 76 DD 8E 00
 altd adc (ix + 127)            ; 76 DD 8E 7F
 altd adc (ix - 128)            ; 76 DD 8E 80
 adc a', (ix)                   ; 76 DD 8E 00
 adc a', (ix + 127)             ; 76 DD 8E 7F
 adc a', (ix - 128)             ; 76 DD 8E 80
 altd adc a, (iy)               ; 76 FD 8E 00
 altd adc a, (iy + 127)         ; 76 FD 8E 7F
 altd adc a, (iy - 128)         ; 76 FD 8E 80
 altd adc (iy)                  ; 76 FD 8E 00
 altd adc (iy + 127)            ; 76 FD 8E 7F
 altd adc (iy - 128)            ; 76 FD 8E 80
 adc a', (iy)                   ; 76 FD 8E 00
 adc a', (iy + 127)             ; 76 FD 8E 7F
 adc a', (iy - 128)             ; 76 FD 8E 80
 altd adc a,  42                ; 76 CE 2A
 altd adc a, (42)               ; 76 CE 2A
 altd adc  42                   ; 76 CE 2A
 altd adc (42)                  ; 76 CE 2A
 adc a',  42                    ; 76 CE 2A
 adc a', (42)                   ; 76 CE 2A
 altd sub a, b                  ; 76 90
 altd sub b                     ; 76 90
 sub a', b                      ; 76 90
 altd sub a, c                  ; 76 91
 altd sub c                     ; 76 91
 sub a', c                      ; 76 91
 altd sub a, d                  ; 76 92
 altd sub d                     ; 76 92
 sub a', d                      ; 76 92
 altd sub a, e                  ; 76 93
 altd sub e                     ; 76 93
 sub a', e                      ; 76 93
 altd sub a, h                  ; 76 94
 altd sub h                     ; 76 94
 sub a', h                      ; 76 94
 altd sub a, l                  ; 76 95
 altd sub l                     ; 76 95
 sub a', l                      ; 76 95
 altd sub a, a                  ; 76 97
 altd sub a                     ; 76 97
 sub a', a                      ; 76 97
 altd sub a, (hl)               ; 76 96
 altd sub (hl)                  ; 76 96
 sub a', (hl)                   ; 76 96
 altd sub a, (ix)               ; 76 DD 96 00
 altd sub a, (ix + 127)         ; 76 DD 96 7F
 altd sub a, (ix - 128)         ; 76 DD 96 80
 altd sub (ix)                  ; 76 DD 96 00
 altd sub (ix + 127)            ; 76 DD 96 7F
 altd sub (ix - 128)            ; 76 DD 96 80
 sub a', (ix)                   ; 76 DD 96 00
 sub a', (ix + 127)             ; 76 DD 96 7F
 sub a', (ix - 128)             ; 76 DD 96 80
 altd sub a, (iy)               ; 76 FD 96 00
 altd sub a, (iy + 127)         ; 76 FD 96 7F
 altd sub a, (iy - 128)         ; 76 FD 96 80
 altd sub (iy)                  ; 76 FD 96 00
 altd sub (iy + 127)            ; 76 FD 96 7F
 altd sub (iy - 128)            ; 76 FD 96 80
 sub a', (iy)                   ; 76 FD 96 00
 sub a', (iy + 127)             ; 76 FD 96 7F
 sub a', (iy - 128)             ; 76 FD 96 80
 altd sub a,  42                ; 76 D6 2A
 altd sub a, (42)               ; 76 D6 2A
 altd sub  42                   ; 76 D6 2A
 altd sub (42)                  ; 76 D6 2A
 sub a',  42                    ; 76 D6 2A
 sub a', (42)                   ; 76 D6 2A
 altd sbc a, b                  ; 76 98
 altd sbc b                     ; 76 98
 sbc a', b                      ; 76 98
 altd sbc a, c                  ; 76 99
 altd sbc c                     ; 76 99
 sbc a', c                      ; 76 99
 altd sbc a, d                  ; 76 9A
 altd sbc d                     ; 76 9A
 sbc a', d                      ; 76 9A
 altd sbc a, e                  ; 76 9B
 altd sbc e                     ; 76 9B
 sbc a', e                      ; 76 9B
 altd sbc a, h                  ; 76 9C
 altd sbc h                     ; 76 9C
 sbc a', h                      ; 76 9C
 altd sbc a, l                  ; 76 9D
 altd sbc l                     ; 76 9D
 sbc a', l                      ; 76 9D
 altd sbc a, a                  ; 76 9F
 altd sbc a                     ; 76 9F
 sbc a', a                      ; 76 9F
 altd sbc a, (hl)               ; 76 9E
 altd sbc (hl)                  ; 76 9E
 sbc a', (hl)                   ; 76 9E
 altd sbc a, (ix)               ; 76 DD 9E 00
 altd sbc a, (ix + 127)         ; 76 DD 9E 7F
 altd sbc a, (ix - 128)         ; 76 DD 9E 80
 altd sbc (ix)                  ; 76 DD 9E 00
 altd sbc (ix + 127)            ; 76 DD 9E 7F
 altd sbc (ix - 128)            ; 76 DD 9E 80
 sbc a', (ix)                   ; 76 DD 9E 00
 sbc a', (ix + 127)             ; 76 DD 9E 7F
 sbc a', (ix - 128)             ; 76 DD 9E 80
 altd sbc a, (iy)               ; 76 FD 9E 00
 altd sbc a, (iy + 127)         ; 76 FD 9E 7F
 altd sbc a, (iy - 128)         ; 76 FD 9E 80
 altd sbc (iy)                  ; 76 FD 9E 00
 altd sbc (iy + 127)            ; 76 FD 9E 7F
 altd sbc (iy - 128)            ; 76 FD 9E 80
 sbc a', (iy)                   ; 76 FD 9E 00
 sbc a', (iy + 127)             ; 76 FD 9E 7F
 sbc a', (iy - 128)             ; 76 FD 9E 80
 altd sbc a,  42                ; 76 DE 2A
 altd sbc a, (42)               ; 76 DE 2A
 altd sbc  42                   ; 76 DE 2A
 altd sbc (42)                  ; 76 DE 2A
 sbc a',  42                    ; 76 DE 2A
 sbc a', (42)                   ; 76 DE 2A
 altd and a, b                  ; 76 A0
 altd and b                     ; 76 A0
 and a', b                      ; 76 A0
 altd and a, c                  ; 76 A1
 altd and c                     ; 76 A1
 and a', c                      ; 76 A1
 altd and a, d                  ; 76 A2
 altd and d                     ; 76 A2
 and a', d                      ; 76 A2
 altd and a, e                  ; 76 A3
 altd and e                     ; 76 A3
 and a', e                      ; 76 A3
 altd and a, h                  ; 76 A4
 altd and h                     ; 76 A4
 and a', h                      ; 76 A4
 altd and a, l                  ; 76 A5
 altd and l                     ; 76 A5
 and a', l                      ; 76 A5
 altd and a, a                  ; 76 A7
 altd and a                     ; 76 A7
 and a', a                      ; 76 A7
 altd and a, (hl)               ; 76 A6
 altd and (hl)                  ; 76 A6
 and a', (hl)                   ; 76 A6
 altd and a, (ix)               ; 76 DD A6 00
 altd and a, (ix + 127)         ; 76 DD A6 7F
 altd and a, (ix - 128)         ; 76 DD A6 80
 altd and (ix)                  ; 76 DD A6 00
 altd and (ix + 127)            ; 76 DD A6 7F
 altd and (ix - 128)            ; 76 DD A6 80
 and a', (ix)                   ; 76 DD A6 00
 and a', (ix + 127)             ; 76 DD A6 7F
 and a', (ix - 128)             ; 76 DD A6 80
 altd and a, (iy)               ; 76 FD A6 00
 altd and a, (iy + 127)         ; 76 FD A6 7F
 altd and a, (iy - 128)         ; 76 FD A6 80
 altd and (iy)                  ; 76 FD A6 00
 altd and (iy + 127)            ; 76 FD A6 7F
 altd and (iy - 128)            ; 76 FD A6 80
 and a', (iy)                   ; 76 FD A6 00
 and a', (iy + 127)             ; 76 FD A6 7F
 and a', (iy - 128)             ; 76 FD A6 80
 altd and a,  42                ; 76 E6 2A
 altd and a, (42)               ; 76 E6 2A
 altd and  42                   ; 76 E6 2A
 altd and (42)                  ; 76 E6 2A
 and a',  42                    ; 76 E6 2A
 and a', (42)                   ; 76 E6 2A
 altd xor a, b                  ; 76 A8
 altd xor b                     ; 76 A8
 xor a', b                      ; 76 A8
 altd xor a, c                  ; 76 A9
 altd xor c                     ; 76 A9
 xor a', c                      ; 76 A9
 altd xor a, d                  ; 76 AA
 altd xor d                     ; 76 AA
 xor a', d                      ; 76 AA
 altd xor a, e                  ; 76 AB
 altd xor e                     ; 76 AB
 xor a', e                      ; 76 AB
 altd xor a, h                  ; 76 AC
 altd xor h                     ; 76 AC
 xor a', h                      ; 76 AC
 altd xor a, l                  ; 76 AD
 altd xor l                     ; 76 AD
 xor a', l                      ; 76 AD
 altd xor a, a                  ; 76 AF
 altd xor a                     ; 76 AF
 xor a', a                      ; 76 AF
 altd xor a, (hl)               ; 76 AE
 altd xor (hl)                  ; 76 AE
 xor a', (hl)                   ; 76 AE
 altd xor a, (ix)               ; 76 DD AE 00
 altd xor a, (ix + 127)         ; 76 DD AE 7F
 altd xor a, (ix - 128)         ; 76 DD AE 80
 altd xor (ix)                  ; 76 DD AE 00
 altd xor (ix + 127)            ; 76 DD AE 7F
 altd xor (ix - 128)            ; 76 DD AE 80
 xor a', (ix)                   ; 76 DD AE 00
 xor a', (ix + 127)             ; 76 DD AE 7F
 xor a', (ix - 128)             ; 76 DD AE 80
 altd xor a, (iy)               ; 76 FD AE 00
 altd xor a, (iy + 127)         ; 76 FD AE 7F
 altd xor a, (iy - 128)         ; 76 FD AE 80
 altd xor (iy)                  ; 76 FD AE 00
 altd xor (iy + 127)            ; 76 FD AE 7F
 altd xor (iy - 128)            ; 76 FD AE 80
 xor a', (iy)                   ; 76 FD AE 00
 xor a', (iy + 127)             ; 76 FD AE 7F
 xor a', (iy - 128)             ; 76 FD AE 80
 altd xor a,  42                ; 76 EE 2A
 altd xor a, (42)               ; 76 EE 2A
 altd xor  42                   ; 76 EE 2A
 altd xor (42)                  ; 76 EE 2A
 xor a',  42                    ; 76 EE 2A
 xor a', (42)                   ; 76 EE 2A
 altd or a, b                   ; 76 B0
 altd or b                      ; 76 B0
 or a', b                       ; 76 B0
 altd or a, c                   ; 76 B1
 altd or c                      ; 76 B1
 or a', c                       ; 76 B1
 altd or a, d                   ; 76 B2
 altd or d                      ; 76 B2
 or a', d                       ; 76 B2
 altd or a, e                   ; 76 B3
 altd or e                      ; 76 B3
 or a', e                       ; 76 B3
 altd or a, h                   ; 76 B4
 altd or h                      ; 76 B4
 or a', h                       ; 76 B4
 altd or a, l                   ; 76 B5
 altd or l                      ; 76 B5
 or a', l                       ; 76 B5
 altd or a, a                   ; 76 B7
 altd or a                      ; 76 B7
 or a', a                       ; 76 B7
 altd or a, (hl)                ; 76 B6
 altd or (hl)                   ; 76 B6
 or a', (hl)                    ; 76 B6
 altd or a, (ix)                ; 76 DD B6 00
 altd or a, (ix + 127)          ; 76 DD B6 7F
 altd or a, (ix - 128)          ; 76 DD B6 80
 altd or (ix)                   ; 76 DD B6 00
 altd or (ix + 127)             ; 76 DD B6 7F
 altd or (ix - 128)             ; 76 DD B6 80
 or a', (ix)                    ; 76 DD B6 00
 or a', (ix + 127)              ; 76 DD B6 7F
 or a', (ix - 128)              ; 76 DD B6 80
 altd or a, (iy)                ; 76 FD B6 00
 altd or a, (iy + 127)          ; 76 FD B6 7F
 altd or a, (iy - 128)          ; 76 FD B6 80
 altd or (iy)                   ; 76 FD B6 00
 altd or (iy + 127)             ; 76 FD B6 7F
 altd or (iy - 128)             ; 76 FD B6 80
 or a', (iy)                    ; 76 FD B6 00
 or a', (iy + 127)              ; 76 FD B6 7F
 or a', (iy - 128)              ; 76 FD B6 80
 altd or a,  42                 ; 76 F6 2A
 altd or a, (42)                ; 76 F6 2A
 altd or  42                    ; 76 F6 2A
 altd or (42)                   ; 76 F6 2A
 or a',  42                     ; 76 F6 2A
 or a', (42)                    ; 76 F6 2A
 altd cp a, b                   ; 76 B8
 altd cp b                      ; 76 B8
 cp a', b                       ; 76 B8
 altd cp a, c                   ; 76 B9
 altd cp c                      ; 76 B9
 cp a', c                       ; 76 B9
 altd cp a, d                   ; 76 BA
 altd cp d                      ; 76 BA
 cp a', d                       ; 76 BA
 altd cp a, e                   ; 76 BB
 altd cp e                      ; 76 BB
 cp a', e                       ; 76 BB
 altd cp a, h                   ; 76 BC
 altd cp h                      ; 76 BC
 cp a', h                       ; 76 BC
 altd cp a, l                   ; 76 BD
 altd cp l                      ; 76 BD
 cp a', l                       ; 76 BD
 altd cp a, a                   ; 76 BF
 altd cp a                      ; 76 BF
 cp a', a                       ; 76 BF
 altd cp a, (hl)                ; 76 BE
 altd cp (hl)                   ; 76 BE
 cp a', (hl)                    ; 76 BE
 altd cp a, (ix)                ; 76 DD BE 00
 altd cp a, (ix + 127)          ; 76 DD BE 7F
 altd cp a, (ix - 128)          ; 76 DD BE 80
 altd cp (ix)                   ; 76 DD BE 00
 altd cp (ix + 127)             ; 76 DD BE 7F
 altd cp (ix - 128)             ; 76 DD BE 80
 cp a', (ix)                    ; 76 DD BE 00
 cp a', (ix + 127)              ; 76 DD BE 7F
 cp a', (ix - 128)              ; 76 DD BE 80
 altd cp a, (iy)                ; 76 FD BE 00
 altd cp a, (iy + 127)          ; 76 FD BE 7F
 altd cp a, (iy - 128)          ; 76 FD BE 80
 altd cp (iy)                   ; 76 FD BE 00
 altd cp (iy + 127)             ; 76 FD BE 7F
 altd cp (iy - 128)             ; 76 FD BE 80
 cp a', (iy)                    ; 76 FD BE 00
 cp a', (iy + 127)              ; 76 FD BE 7F
 cp a', (iy - 128)              ; 76 FD BE 80
 altd cp a,  42                 ; 76 FE 2A
 altd cp a, (42)                ; 76 FE 2A
 altd cp  42                    ; 76 FE 2A
 altd cp (42)                   ; 76 FE 2A
 cp a',  42                     ; 76 FE 2A
 cp a', (42)                    ; 76 FE 2A
 altd inc b                     ; 76 04
 inc b'                         ; 76 04
 altd inc c                     ; 76 0C
 inc c'                         ; 76 0C
 altd inc d                     ; 76 14
 inc d'                         ; 76 14
 altd inc e                     ; 76 1C
 inc e'                         ; 76 1C
 altd inc h                     ; 76 24
 inc h'                         ; 76 24
 altd inc l                     ; 76 2C
 inc l'                         ; 76 2C
 altd inc a                     ; 76 3C
 inc a'                         ; 76 3C
 altd dec b                     ; 76 05
 dec b'                         ; 76 05
 altd dec c                     ; 76 0D
 dec c'                         ; 76 0D
 altd dec d                     ; 76 15
 dec d'                         ; 76 15
 altd dec e                     ; 76 1D
 dec e'                         ; 76 1D
 altd dec h                     ; 76 25
 dec h'                         ; 76 25
 altd dec l                     ; 76 2D
 dec l'                         ; 76 2D
 altd dec a                     ; 76 3D
 dec a'                         ; 76 3D
 tst a, b                       ; ED 04
 tst b                          ; ED 04
 tst a, c                       ; ED 0C
 tst c                          ; ED 0C
 tst a, d                       ; ED 14
 tst d                          ; ED 14
 tst a, e                       ; ED 1C
 tst e                          ; ED 1C
 tst a, h                       ; ED 24
 tst h                          ; ED 24
 tst a, l                       ; ED 2C
 tst l                          ; ED 2C
 tst a, a                       ; ED 3C
 tst a                          ; ED 3C
 tst a, (hl)                    ; ED 34
 tst (hl)                       ; ED 34
 tst a,  42                     ; ED 64 2A
 tst a, (42)                    ; ED 64 2A
 tst  42                        ; ED 64 2A
 tst (42)                       ; ED 64 2A
 altd cpl a                     ; 76 2F
 altd cpl                       ; 76 2F
 cpl a'                         ; 76 2F
 altd neg a                     ; 76 ED 44
 altd neg                       ; 76 ED 44
 neg a'                         ; 76 ED 44
 altd ccf f                     ; 76 3F
 altd ccf                       ; 76 3F
 ccf f'                         ; 76 3F
 altd scf f                     ; 76 37
 altd scf                       ; 76 37
 scf f'                         ; 76 37
 altd ld hl,  256               ; 76 21 00 01
 altd ld hl, (256)              ; 76 2A 00 01
 ld hl',  256                   ; 76 21 00 01
 ld hl', (256)                  ; 76 2A 00 01
 altd ld bc,  256               ; 76 01 00 01
 altd ld bc, (256)              ; 76 ED 4B 00 01
 ld bc',  256                   ; 76 01 00 01
 ld bc', (256)                  ; 76 ED 4B 00 01
 altd ld de,  256               ; 76 11 00 01
 altd ld de, (256)              ; 76 ED 5B 00 01
 ld de',  256                   ; 76 11 00 01
 ld de', (256)                  ; 76 ED 5B 00 01
 altd pop bc                    ; 76 C1
 pop bc'                        ; 76 C1
 altd pop de                    ; 76 D1
 pop de'                        ; 76 D1
 altd pop hl                    ; 76 E1
 pop hl'                        ; 76 E1
 altd pop af                    ; 76 F1
 pop af'                        ; 76 F1
 push ip                        ; ED 76
 pop ip                         ; ED 7E
 push su                        ; ED 66
 pop su                         ; ED 6E
 ld hl, ix                      ; DD 7C
 altd ld hl, ix                 ; 76 DD 7C
 ld hl', ix                     ; 76 DD 7C
 ld ix, hl                      ; DD 7D
 ld hl, iy                      ; FD 7C
 altd ld hl, iy                 ; 76 FD 7C
 ld hl', iy                     ; 76 FD 7C
 ld iy, hl                      ; FD 7D
