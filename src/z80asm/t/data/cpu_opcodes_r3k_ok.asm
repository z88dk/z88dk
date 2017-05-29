 adc (42)               ;; CE 2A
 adc (hl)               ;; 8E
 adc (ix)               ;; DD 8E 00
 adc (ix+127)           ;; DD 8E 7F
 adc (iy)               ;; FD 8E 00
 adc (iy+127)           ;; FD 8E 7F
 adc 42                 ;; CE 2A
 adc a                  ;; 8F
 adc a', (42)           ;; 76 CE 2A
 adc a', (hl)           ;; 76 8E
 adc a', (ix)           ;; 76 DD 8E 00
 adc a', (ix+127)       ;; 76 DD 8E 7F
 adc a', (iy)           ;; 76 FD 8E 00
 adc a', (iy+127)       ;; 76 FD 8E 7F
 adc a', 42             ;; 76 CE 2A
 adc a', a              ;; 76 8F
 adc a', b              ;; 76 88
 adc a', c              ;; 76 89
 adc a', d              ;; 76 8A
 adc a', e              ;; 76 8B
 adc a', h              ;; 76 8C
 adc a', l              ;; 76 8D
 adc a, (42)            ;; CE 2A
 adc a, (hl)            ;; 8E
 adc a, (ix)            ;; DD 8E 00
 adc a, (ix+127)        ;; DD 8E 7F
 adc a, (iy)            ;; FD 8E 00
 adc a, (iy+127)        ;; FD 8E 7F
 adc a, 42              ;; CE 2A
 adc a, a               ;; 8F
 adc a, b               ;; 88
 adc a, c               ;; 89
 adc a, d               ;; 8A
 adc a, e               ;; 8B
 adc a, h               ;; 8C
 adc a, l               ;; 8D
 adc b                  ;; 88
 adc c                  ;; 89
 adc d                  ;; 8A
 adc e                  ;; 8B
 adc h                  ;; 8C
 adc l                  ;; 8D
 add (42)               ;; C6 2A
 add (hl)               ;; 86
 add (ix)               ;; DD 86 00
 add (ix+127)           ;; DD 86 7F
 add (iy)               ;; FD 86 00
 add (iy+127)           ;; FD 86 7F
 add 42                 ;; C6 2A
 add a                  ;; 87
 add a', (42)           ;; 76 C6 2A
 add a', (hl)           ;; 76 86
 add a', (ix)           ;; 76 DD 86 00
 add a', (ix+127)       ;; 76 DD 86 7F
 add a', (iy)           ;; 76 FD 86 00
 add a', (iy+127)       ;; 76 FD 86 7F
 add a', 42             ;; 76 C6 2A
 add a', a              ;; 76 87
 add a', b              ;; 76 80
 add a', c              ;; 76 81
 add a', d              ;; 76 82
 add a', e              ;; 76 83
 add a', h              ;; 76 84
 add a', l              ;; 76 85
 add a, (42)            ;; C6 2A
 add a, (hl)            ;; 86
 add a, (ix)            ;; DD 86 00
 add a, (ix+127)        ;; DD 86 7F
 add a, (iy)            ;; FD 86 00
 add a, (iy+127)        ;; FD 86 7F
 add a, 42              ;; C6 2A
 add a, a               ;; 87
 add a, b               ;; 80
 add a, c               ;; 81
 add a, d               ;; 82
 add a, e               ;; 83
 add a, h               ;; 84
 add a, l               ;; 85
 add b                  ;; 80
 add c                  ;; 81
 add d                  ;; 82
 add e                  ;; 83
 add h                  ;; 84
 add l                  ;; 85
 altd adc a, (42)       ;; 76 CE 2A
 altd adc a, (hl)       ;; 76 8E
 altd adc a, (ix)       ;; 76 DD 8E 00
 altd adc a, (ix+127)   ;; 76 DD 8E 7F
 altd adc a, (iy)       ;; 76 FD 8E 00
 altd adc a, (iy+127)   ;; 76 FD 8E 7F
 altd adc a, 42         ;; 76 CE 2A
 altd adc a, a          ;; 76 8F
 altd adc a, b          ;; 76 88
 altd adc a, c          ;; 76 89
 altd adc a, d          ;; 76 8A
 altd adc a, e          ;; 76 8B
 altd adc a, h          ;; 76 8C
 altd adc a, l          ;; 76 8D
 altd add a, (42)       ;; 76 C6 2A
 altd add a, (hl)       ;; 76 86
 altd add a, (ix)       ;; 76 DD 86 00
 altd add a, (ix+127)   ;; 76 DD 86 7F
 altd add a, (iy)       ;; 76 FD 86 00
 altd add a, (iy+127)   ;; 76 FD 86 7F
 altd add a, 42         ;; 76 C6 2A
 altd add a, a          ;; 76 87
 altd add a, b          ;; 76 80
 altd add a, c          ;; 76 81
 altd add a, d          ;; 76 82
 altd add a, e          ;; 76 83
 altd add a, h          ;; 76 84
 altd add a, l          ;; 76 85
 altd and a, (42)       ;; 76 E6 2A
 altd and a, (hl)       ;; 76 A6
 altd and a, (ix)       ;; 76 DD A6 00
 altd and a, (ix+127)   ;; 76 DD A6 7F
 altd and a, (iy)       ;; 76 FD A6 00
 altd and a, (iy+127)   ;; 76 FD A6 7F
 altd and a, 42         ;; 76 E6 2A
 altd and a, a          ;; 76 A7
 altd and a, b          ;; 76 A0
 altd and a, c          ;; 76 A1
 altd and a, d          ;; 76 A2
 altd and a, e          ;; 76 A3
 altd and a, h          ;; 76 A4
 altd and a, l          ;; 76 A5
 altd ccf f             ;; 76 3F
 altd cp a, (42)        ;; 76 FE 2A
 altd cp a, (hl)        ;; 76 BE
 altd cp a, (ix)        ;; 76 DD BE 00
 altd cp a, (ix+127)    ;; 76 DD BE 7F
 altd cp a, (iy)        ;; 76 FD BE 00
 altd cp a, (iy+127)    ;; 76 FD BE 7F
 altd cp a, 42          ;; 76 FE 2A
 altd cp a, a           ;; 76 BF
 altd cp a, b           ;; 76 B8
 altd cp a, c           ;; 76 B9
 altd cp a, d           ;; 76 BA
 altd cp a, e           ;; 76 BB
 altd cp a, h           ;; 76 BC
 altd cp a, l           ;; 76 BD
 altd cpl a             ;; 76 2F
 altd dec a             ;; 76 3D
 altd dec b             ;; 76 05
 altd dec c             ;; 76 0D
 altd dec d             ;; 76 15
 altd dec e             ;; 76 1D
 altd dec h             ;; 76 25
 altd dec l             ;; 76 2D
 altd inc a             ;; 76 3C
 altd inc b             ;; 76 04
 altd inc c             ;; 76 0C
 altd inc d             ;; 76 14
 altd inc e             ;; 76 1C
 altd inc h             ;; 76 24
 altd inc l             ;; 76 2C
 altd ld a, (4660)      ;; 76 3A 34 12
 altd ld a, (bc)        ;; 76 0A
 altd ld a, (de)        ;; 76 1A
 altd ld a, (hl)        ;; 76 7E
 altd ld a, (ix)        ;; 76 DD 7E 00
 altd ld a, (ix+127)    ;; 76 DD 7E 7F
 altd ld a, (iy)        ;; 76 FD 7E 00
 altd ld a, (iy+127)    ;; 76 FD 7E 7F
 altd ld a, 42          ;; 76 3E 2A
 altd ld b, (42)        ;; 76 06 2A
 altd ld b, (hl)        ;; 76 46
 altd ld b, (ix)        ;; 76 DD 46 00
 altd ld b, (ix+127)    ;; 76 DD 46 7F
 altd ld b, (iy)        ;; 76 FD 46 00
 altd ld b, (iy+127)    ;; 76 FD 46 7F
 altd ld b, 42          ;; 76 06 2A
 altd ld bc, (4660)     ;; 76 ED 4B 34 12
 altd ld bc, 4660       ;; 76 01 34 12
 altd ld c, (42)        ;; 76 0E 2A
 altd ld c, (hl)        ;; 76 4E
 altd ld c, (ix)        ;; 76 DD 4E 00
 altd ld c, (ix+127)    ;; 76 DD 4E 7F
 altd ld c, (iy)        ;; 76 FD 4E 00
 altd ld c, (iy+127)    ;; 76 FD 4E 7F
 altd ld c, 42          ;; 76 0E 2A
 altd ld d, (42)        ;; 76 16 2A
 altd ld d, (hl)        ;; 76 56
 altd ld d, (ix)        ;; 76 DD 56 00
 altd ld d, (ix+127)    ;; 76 DD 56 7F
 altd ld d, (iy)        ;; 76 FD 56 00
 altd ld d, (iy+127)    ;; 76 FD 56 7F
 altd ld d, 42          ;; 76 16 2A
 altd ld de, (4660)     ;; 76 ED 5B 34 12
 altd ld de, 4660       ;; 76 11 34 12
 altd ld e, (42)        ;; 76 1E 2A
 altd ld e, (hl)        ;; 76 5E
 altd ld e, (ix)        ;; 76 DD 5E 00
 altd ld e, (ix+127)    ;; 76 DD 5E 7F
 altd ld e, (iy)        ;; 76 FD 5E 00
 altd ld e, (iy+127)    ;; 76 FD 5E 7F
 altd ld e, 42          ;; 76 1E 2A
 altd ld h, (42)        ;; 76 26 2A
 altd ld h, (hl)        ;; 76 66
 altd ld h, (ix)        ;; 76 DD 66 00
 altd ld h, (ix+127)    ;; 76 DD 66 7F
 altd ld h, (iy)        ;; 76 FD 66 00
 altd ld h, (iy+127)    ;; 76 FD 66 7F
 altd ld h, 42          ;; 76 26 2A
 altd ld hl, (4660)     ;; 76 2A 34 12
 altd ld hl, (hl)       ;; 76 DD E4 00
 altd ld hl, (hl+127)   ;; 76 DD E4 7F
 altd ld hl, (ix)       ;; 76 E4 00
 altd ld hl, (ix+127)   ;; 76 E4 7F
 altd ld hl, (iy)       ;; 76 FD E4 00
 altd ld hl, (iy+127)   ;; 76 FD E4 7F
 altd ld hl, 4660       ;; 76 21 34 12
 altd ld hl, ix         ;; 76 DD 7C
 altd ld hl, iy         ;; 76 FD 7C
 altd ld l, (42)        ;; 76 2E 2A
 altd ld l, (hl)        ;; 76 6E
 altd ld l, (ix)        ;; 76 DD 6E 00
 altd ld l, (ix+127)    ;; 76 DD 6E 7F
 altd ld l, (iy)        ;; 76 FD 6E 00
 altd ld l, (iy+127)    ;; 76 FD 6E 7F
 altd ld l, 42          ;; 76 2E 2A
 altd neg a             ;; 76 ED 44
 altd or a, (42)        ;; 76 F6 2A
 altd or a, (hl)        ;; 76 B6
 altd or a, (ix)        ;; 76 DD B6 00
 altd or a, (ix+127)    ;; 76 DD B6 7F
 altd or a, (iy)        ;; 76 FD B6 00
 altd or a, (iy+127)    ;; 76 FD B6 7F
 altd or a, 42          ;; 76 F6 2A
 altd or a, a           ;; 76 B7
 altd or a, b           ;; 76 B0
 altd or a, c           ;; 76 B1
 altd or a, d           ;; 76 B2
 altd or a, e           ;; 76 B3
 altd or a, h           ;; 76 B4
 altd or a, l           ;; 76 B5
 altd pop af            ;; 76 F1
 altd pop bc            ;; 76 C1
 altd pop de            ;; 76 D1
 altd pop hl            ;; 76 E1
 altd pop ix            ;; 76 DD E1
 altd pop iy            ;; 76 FD E1
 altd sbc a, (42)       ;; 76 DE 2A
 altd sbc a, (hl)       ;; 76 9E
 altd sbc a, (ix)       ;; 76 DD 9E 00
 altd sbc a, (ix+127)   ;; 76 DD 9E 7F
 altd sbc a, (iy)       ;; 76 FD 9E 00
 altd sbc a, (iy+127)   ;; 76 FD 9E 7F
 altd sbc a, 42         ;; 76 DE 2A
 altd sbc a, a          ;; 76 9F
 altd sbc a, b          ;; 76 98
 altd sbc a, c          ;; 76 99
 altd sbc a, d          ;; 76 9A
 altd sbc a, e          ;; 76 9B
 altd sbc a, h          ;; 76 9C
 altd sbc a, l          ;; 76 9D
 altd scf f             ;; 76 37
 altd sub a, (42)       ;; 76 D6 2A
 altd sub a, (hl)       ;; 76 96
 altd sub a, (ix)       ;; 76 DD 96 00
 altd sub a, (ix+127)   ;; 76 DD 96 7F
 altd sub a, (iy)       ;; 76 FD 96 00
 altd sub a, (iy+127)   ;; 76 FD 96 7F
 altd sub a, 42         ;; 76 D6 2A
 altd sub a, a          ;; 76 97
 altd sub a, b          ;; 76 90
 altd sub a, c          ;; 76 91
 altd sub a, d          ;; 76 92
 altd sub a, e          ;; 76 93
 altd sub a, h          ;; 76 94
 altd sub a, l          ;; 76 95
 altd xor a, (42)       ;; 76 EE 2A
 altd xor a, (hl)       ;; 76 AE
 altd xor a, (ix)       ;; 76 DD AE 00
 altd xor a, (ix+127)   ;; 76 DD AE 7F
 altd xor a, (iy)       ;; 76 FD AE 00
 altd xor a, (iy+127)   ;; 76 FD AE 7F
 altd xor a, 42         ;; 76 EE 2A
 altd xor a, a          ;; 76 AF
 altd xor a, b          ;; 76 A8
 altd xor a, c          ;; 76 A9
 altd xor a, d          ;; 76 AA
 altd xor a, e          ;; 76 AB
 altd xor a, h          ;; 76 AC
 altd xor a, l          ;; 76 AD
 and (42)               ;; E6 2A
 and (hl)               ;; A6
 and (ix)               ;; DD A6 00
 and (ix+127)           ;; DD A6 7F
 and (iy)               ;; FD A6 00
 and (iy+127)           ;; FD A6 7F
 and 42                 ;; E6 2A
 and a                  ;; A7
 and a', (42)           ;; 76 E6 2A
 and a', (hl)           ;; 76 A6
 and a', (ix)           ;; 76 DD A6 00
 and a', (ix+127)       ;; 76 DD A6 7F
 and a', (iy)           ;; 76 FD A6 00
 and a', (iy+127)       ;; 76 FD A6 7F
 and a', 42             ;; 76 E6 2A
 and a', a              ;; 76 A7
 and a', b              ;; 76 A0
 and a', c              ;; 76 A1
 and a', d              ;; 76 A2
 and a', e              ;; 76 A3
 and a', h              ;; 76 A4
 and a', l              ;; 76 A5
 and a, (42)            ;; E6 2A
 and a, (hl)            ;; A6
 and a, (ix)            ;; DD A6 00
 and a, (ix+127)        ;; DD A6 7F
 and a, (iy)            ;; FD A6 00
 and a, (iy+127)        ;; FD A6 7F
 and a, 42              ;; E6 2A
 and a, a               ;; A7
 and a, b               ;; A0
 and a, c               ;; A1
 and a, d               ;; A2
 and a, e               ;; A3
 and a, h               ;; A4
 and a, l               ;; A5
 and b                  ;; A0
 and c                  ;; A1
 and d                  ;; A2
 and e                  ;; A3
 and h                  ;; A4
 and l                  ;; A5
 ccf                    ;; 3F
 ccf f                  ;; 3F
 ccf f'                 ;; 76 3F
 cp (42)                ;; FE 2A
 cp (hl)                ;; BE
 cp (ix)                ;; DD BE 00
 cp (ix+127)            ;; DD BE 7F
 cp (iy)                ;; FD BE 00
 cp (iy+127)            ;; FD BE 7F
 cp 42                  ;; FE 2A
 cp a                   ;; BF
 cp a', (42)            ;; 76 FE 2A
 cp a', (hl)            ;; 76 BE
 cp a', (ix)            ;; 76 DD BE 00
 cp a', (ix+127)        ;; 76 DD BE 7F
 cp a', (iy)            ;; 76 FD BE 00
 cp a', (iy+127)        ;; 76 FD BE 7F
 cp a', 42              ;; 76 FE 2A
 cp a', a               ;; 76 BF
 cp a', b               ;; 76 B8
 cp a', c               ;; 76 B9
 cp a', d               ;; 76 BA
 cp a', e               ;; 76 BB
 cp a', h               ;; 76 BC
 cp a', l               ;; 76 BD
 cp a, (42)             ;; FE 2A
 cp a, (hl)             ;; BE
 cp a, (ix)             ;; DD BE 00
 cp a, (ix+127)         ;; DD BE 7F
 cp a, (iy)             ;; FD BE 00
 cp a, (iy+127)         ;; FD BE 7F
 cp a, 42               ;; FE 2A
 cp a, a                ;; BF
 cp a, b                ;; B8
 cp a, c                ;; B9
 cp a, d                ;; BA
 cp a, e                ;; BB
 cp a, h                ;; BC
 cp a, l                ;; BD
 cp b                   ;; B8
 cp c                   ;; B9
 cp d                   ;; BA
 cp e                   ;; BB
 cp h                   ;; BC
 cp l                   ;; BD
 cpl                    ;; 2F
 cpl a                  ;; 2F
 cpl a'                 ;; 76 2F
 dec (hl)               ;; 35
 dec (ix)               ;; DD 35 00
 dec (ix+127)           ;; DD 35 7F
 dec (iy)               ;; FD 35 00
 dec (iy+127)           ;; FD 35 7F
 dec a                  ;; 3D
 dec a'                 ;; 76 3D
 dec b                  ;; 05
 dec b'                 ;; 76 05
 dec c                  ;; 0D
 dec c'                 ;; 76 0D
 dec d                  ;; 15
 dec d'                 ;; 76 15
 dec e                  ;; 1D
 dec e'                 ;; 76 1D
 dec h                  ;; 25
 dec h'                 ;; 76 25
 dec l                  ;; 2D
 dec l'                 ;; 76 2D
 inc (hl)               ;; 34
 inc (ix)               ;; DD 34 00
 inc (ix+127)           ;; DD 34 7F
 inc (iy)               ;; FD 34 00
 inc (iy+127)           ;; FD 34 7F
 inc a                  ;; 3C
 inc a'                 ;; 76 3C
 inc b                  ;; 04
 inc b'                 ;; 76 04
 inc c                  ;; 0C
 inc c'                 ;; 76 0C
 inc d                  ;; 14
 inc d'                 ;; 76 14
 inc e                  ;; 1C
 inc e'                 ;; 76 1C
 inc h                  ;; 24
 inc h'                 ;; 76 24
 inc l                  ;; 2C
 inc l'                 ;; 76 2C
 ld (4660), a           ;; 32 34 12
 ld (4660), bc          ;; ED 43 34 12
 ld (4660), de          ;; ED 53 34 12
 ld (4660), hl          ;; 22 34 12
 ld (4660), ix          ;; DD 22 34 12
 ld (4660), iy          ;; FD 22 34 12
 ld (4660), sp          ;; ED 73 34 12
 ld (bc), a             ;; 02
 ld (de), a             ;; 12
 ld (hl), (42)          ;; 36 2A
 ld (hl), 42            ;; 36 2A
 ld (hl), a             ;; 77
 ld (hl), b             ;; 70
 ld (hl), c             ;; 71
 ld (hl), d             ;; 72
 ld (hl), e             ;; 73
 ld (hl), h             ;; 74
 ld (hl), hl            ;; DD F4 00
 ld (hl), l             ;; 75
 ld (hl+127), hl        ;; DD F4 7F
 ld (ix), (42)          ;; DD 36 00 2A
 ld (ix), 42            ;; DD 36 00 2A
 ld (ix), a             ;; DD 77 00
 ld (ix), b             ;; DD 70 00
 ld (ix), c             ;; DD 71 00
 ld (ix), d             ;; DD 72 00
 ld (ix), e             ;; DD 73 00
 ld (ix), h             ;; DD 74 00
 ld (ix), hl            ;; F4 00
 ld (ix), l             ;; DD 75 00
 ld (ix+127), (42)      ;; DD 36 7F 2A
 ld (ix+127), 42        ;; DD 36 7F 2A
 ld (ix+127), a         ;; DD 77 7F
 ld (ix+127), b         ;; DD 70 7F
 ld (ix+127), c         ;; DD 71 7F
 ld (ix+127), d         ;; DD 72 7F
 ld (ix+127), e         ;; DD 73 7F
 ld (ix+127), h         ;; DD 74 7F
 ld (ix+127), hl        ;; F4 7F
 ld (ix+127), l         ;; DD 75 7F
 ld (iy), (42)          ;; FD 36 00 2A
 ld (iy), 42            ;; FD 36 00 2A
 ld (iy), a             ;; FD 77 00
 ld (iy), b             ;; FD 70 00
 ld (iy), c             ;; FD 71 00
 ld (iy), d             ;; FD 72 00
 ld (iy), e             ;; FD 73 00
 ld (iy), h             ;; FD 74 00
 ld (iy), hl            ;; FD F4 00
 ld (iy), l             ;; FD 75 00
 ld (iy+127), (42)      ;; FD 36 7F 2A
 ld (iy+127), 42        ;; FD 36 7F 2A
 ld (iy+127), a         ;; FD 77 7F
 ld (iy+127), b         ;; FD 70 7F
 ld (iy+127), c         ;; FD 71 7F
 ld (iy+127), d         ;; FD 72 7F
 ld (iy+127), e         ;; FD 73 7F
 ld (iy+127), h         ;; FD 74 7F
 ld (iy+127), hl        ;; FD F4 7F
 ld (iy+127), l         ;; FD 75 7F
 ld a', (4660)          ;; 76 3A 34 12
 ld a', (bc)            ;; 76 0A
 ld a', (de)            ;; 76 1A
 ld a', (hl)            ;; 76 7E
 ld a', (ix)            ;; 76 DD 7E 00
 ld a', (ix+127)        ;; 76 DD 7E 7F
 ld a', (iy)            ;; 76 FD 7E 00
 ld a', (iy+127)        ;; 76 FD 7E 7F
 ld a', 42              ;; 76 3E 2A
 ld a, (4660)           ;; 3A 34 12
 ld a, (bc)             ;; 0A
 ld a, (de)             ;; 1A
 ld a, (hl)             ;; 7E
 ld a, (ix)             ;; DD 7E 00
 ld a, (ix+127)         ;; DD 7E 7F
 ld a, (iy)             ;; FD 7E 00
 ld a, (iy+127)         ;; FD 7E 7F
 ld a, 42               ;; 3E 2A
 ld b', (42)            ;; 76 06 2A
 ld b', (hl)            ;; 76 46
 ld b', (ix)            ;; 76 DD 46 00
 ld b', (ix+127)        ;; 76 DD 46 7F
 ld b', (iy)            ;; 76 FD 46 00
 ld b', (iy+127)        ;; 76 FD 46 7F
 ld b', 42              ;; 76 06 2A
 ld b, (42)             ;; 06 2A
 ld b, (hl)             ;; 46
 ld b, (ix)             ;; DD 46 00
 ld b, (ix+127)         ;; DD 46 7F
 ld b, (iy)             ;; FD 46 00
 ld b, (iy+127)         ;; FD 46 7F
 ld b, 42               ;; 06 2A
 ld bc', (4660)         ;; 76 ED 4B 34 12
 ld bc', 4660           ;; 76 01 34 12
 ld bc, (4660)          ;; ED 4B 34 12
 ld bc, 4660            ;; 01 34 12
 ld c', (42)            ;; 76 0E 2A
 ld c', (hl)            ;; 76 4E
 ld c', (ix)            ;; 76 DD 4E 00
 ld c', (ix+127)        ;; 76 DD 4E 7F
 ld c', (iy)            ;; 76 FD 4E 00
 ld c', (iy+127)        ;; 76 FD 4E 7F
 ld c', 42              ;; 76 0E 2A
 ld c, (42)             ;; 0E 2A
 ld c, (hl)             ;; 4E
 ld c, (ix)             ;; DD 4E 00
 ld c, (ix+127)         ;; DD 4E 7F
 ld c, (iy)             ;; FD 4E 00
 ld c, (iy+127)         ;; FD 4E 7F
 ld c, 42               ;; 0E 2A
 ld d', (42)            ;; 76 16 2A
 ld d', (hl)            ;; 76 56
 ld d', (ix)            ;; 76 DD 56 00
 ld d', (ix+127)        ;; 76 DD 56 7F
 ld d', (iy)            ;; 76 FD 56 00
 ld d', (iy+127)        ;; 76 FD 56 7F
 ld d', 42              ;; 76 16 2A
 ld d, (42)             ;; 16 2A
 ld d, (hl)             ;; 56
 ld d, (ix)             ;; DD 56 00
 ld d, (ix+127)         ;; DD 56 7F
 ld d, (iy)             ;; FD 56 00
 ld d, (iy+127)         ;; FD 56 7F
 ld d, 42               ;; 16 2A
 ld de', (4660)         ;; 76 ED 5B 34 12
 ld de', 4660           ;; 76 11 34 12
 ld de, (4660)          ;; ED 5B 34 12
 ld de, 4660            ;; 11 34 12
 ld e', (42)            ;; 76 1E 2A
 ld e', (hl)            ;; 76 5E
 ld e', (ix)            ;; 76 DD 5E 00
 ld e', (ix+127)        ;; 76 DD 5E 7F
 ld e', (iy)            ;; 76 FD 5E 00
 ld e', (iy+127)        ;; 76 FD 5E 7F
 ld e', 42              ;; 76 1E 2A
 ld e, (42)             ;; 1E 2A
 ld e, (hl)             ;; 5E
 ld e, (ix)             ;; DD 5E 00
 ld e, (ix+127)         ;; DD 5E 7F
 ld e, (iy)             ;; FD 5E 00
 ld e, (iy+127)         ;; FD 5E 7F
 ld e, 42               ;; 1E 2A
 ld h', (42)            ;; 76 26 2A
 ld h', (hl)            ;; 76 66
 ld h', (ix)            ;; 76 DD 66 00
 ld h', (ix+127)        ;; 76 DD 66 7F
 ld h', (iy)            ;; 76 FD 66 00
 ld h', (iy+127)        ;; 76 FD 66 7F
 ld h', 42              ;; 76 26 2A
 ld h, (42)             ;; 26 2A
 ld h, (hl)             ;; 66
 ld h, (ix)             ;; DD 66 00
 ld h, (ix+127)         ;; DD 66 7F
 ld h, (iy)             ;; FD 66 00
 ld h, (iy+127)         ;; FD 66 7F
 ld h, 42               ;; 26 2A
 ld hl', (4660)         ;; 76 2A 34 12
 ld hl', (hl)           ;; 76 DD E4 00
 ld hl', (hl+127)       ;; 76 DD E4 7F
 ld hl', (ix)           ;; 76 E4 00
 ld hl', (ix+127)       ;; 76 E4 7F
 ld hl', (iy)           ;; 76 FD E4 00
 ld hl', (iy+127)       ;; 76 FD E4 7F
 ld hl', 4660           ;; 76 21 34 12
 ld hl', ix             ;; 76 DD 7C
 ld hl', iy             ;; 76 FD 7C
 ld hl, (4660)          ;; 2A 34 12
 ld hl, (hl)            ;; DD E4 00
 ld hl, (hl+127)        ;; DD E4 7F
 ld hl, (ix)            ;; E4 00
 ld hl, (ix+127)        ;; E4 7F
 ld hl, (iy)            ;; FD E4 00
 ld hl, (iy+127)        ;; FD E4 7F
 ld hl, 4660            ;; 21 34 12
 ld hl, ix              ;; DD 7C
 ld hl, iy              ;; FD 7C
 ld ix, (4660)          ;; DD 2A 34 12
 ld ix, 4660            ;; DD 21 34 12
 ld ix, hl              ;; DD 7D
 ld iy, (4660)          ;; FD 2A 34 12
 ld iy, 4660            ;; FD 21 34 12
 ld iy, hl              ;; FD 7D
 ld l', (42)            ;; 76 2E 2A
 ld l', (hl)            ;; 76 6E
 ld l', (ix)            ;; 76 DD 6E 00
 ld l', (ix+127)        ;; 76 DD 6E 7F
 ld l', (iy)            ;; 76 FD 6E 00
 ld l', (iy+127)        ;; 76 FD 6E 7F
 ld l', 42              ;; 76 2E 2A
 ld l, (42)             ;; 2E 2A
 ld l, (hl)             ;; 6E
 ld l, (ix)             ;; DD 6E 00
 ld l, (ix+127)         ;; DD 6E 7F
 ld l, (iy)             ;; FD 6E 00
 ld l, (iy+127)         ;; FD 6E 7F
 ld l, 42               ;; 2E 2A
 ld sp, (4660)          ;; ED 7B 34 12
 ld sp, 4660            ;; 31 34 12
 ld sp, hl              ;; F9
 ld sp, ix              ;; DD F9
 ld sp, iy              ;; FD F9
 ldp (4660), hl         ;; ED 65 34 12
 ldp (4660), ix         ;; DD 65 34 12
 ldp (4660), iy         ;; FD 65 34 12
 ldp (hl), hl           ;; ED 64
 ldp (ix), hl           ;; DD 64
 ldp (iy), hl           ;; FD 64
 ldp hl, (4660)         ;; ED 6D 34 12
 ldp hl, (hl)           ;; ED 6C
 ldp hl, (ix)           ;; DD 6C
 ldp hl, (iy)           ;; FD 6C
 ldp ix, (4660)         ;; DD 6D 34 12
 ldp iy, (4660)         ;; FD 6D 34 12
 neg                    ;; ED 44
 neg a                  ;; ED 44
 neg a'                 ;; 76 ED 44
 or (42)                ;; F6 2A
 or (hl)                ;; B6
 or (ix)                ;; DD B6 00
 or (ix+127)            ;; DD B6 7F
 or (iy)                ;; FD B6 00
 or (iy+127)            ;; FD B6 7F
 or 42                  ;; F6 2A
 or a                   ;; B7
 or a', (42)            ;; 76 F6 2A
 or a', (hl)            ;; 76 B6
 or a', (ix)            ;; 76 DD B6 00
 or a', (ix+127)        ;; 76 DD B6 7F
 or a', (iy)            ;; 76 FD B6 00
 or a', (iy+127)        ;; 76 FD B6 7F
 or a', 42              ;; 76 F6 2A
 or a', a               ;; 76 B7
 or a', b               ;; 76 B0
 or a', c               ;; 76 B1
 or a', d               ;; 76 B2
 or a', e               ;; 76 B3
 or a', h               ;; 76 B4
 or a', l               ;; 76 B5
 or a, (42)             ;; F6 2A
 or a, (hl)             ;; B6
 or a, (ix)             ;; DD B6 00
 or a, (ix+127)         ;; DD B6 7F
 or a, (iy)             ;; FD B6 00
 or a, (iy+127)         ;; FD B6 7F
 or a, 42               ;; F6 2A
 or a, a                ;; B7
 or a, b                ;; B0
 or a, c                ;; B1
 or a, d                ;; B2
 or a, e                ;; B3
 or a, h                ;; B4
 or a, l                ;; B5
 or b                   ;; B0
 or c                   ;; B1
 or d                   ;; B2
 or e                   ;; B3
 or h                   ;; B4
 or l                   ;; B5
 pop af                 ;; F1
 pop af'                ;; 76 F1
 pop bc                 ;; C1
 pop bc'                ;; 76 C1
 pop de                 ;; D1
 pop de'                ;; 76 D1
 pop hl                 ;; E1
 pop hl'                ;; 76 E1
 pop ip                 ;; ED 7E
 pop ix                 ;; DD E1
 pop iy                 ;; FD E1
 pop su                 ;; ED 6E
 push af                ;; F5
 push bc                ;; C5
 push de                ;; D5
 push hl                ;; E5
 push ip                ;; ED 76
 push ix                ;; DD E5
 push iy                ;; FD E5
 push su                ;; ED 66
 sbc (42)               ;; DE 2A
 sbc (hl)               ;; 9E
 sbc (ix)               ;; DD 9E 00
 sbc (ix+127)           ;; DD 9E 7F
 sbc (iy)               ;; FD 9E 00
 sbc (iy+127)           ;; FD 9E 7F
 sbc 42                 ;; DE 2A
 sbc a                  ;; 9F
 sbc a', (42)           ;; 76 DE 2A
 sbc a', (hl)           ;; 76 9E
 sbc a', (ix)           ;; 76 DD 9E 00
 sbc a', (ix+127)       ;; 76 DD 9E 7F
 sbc a', (iy)           ;; 76 FD 9E 00
 sbc a', (iy+127)       ;; 76 FD 9E 7F
 sbc a', 42             ;; 76 DE 2A
 sbc a', a              ;; 76 9F
 sbc a', b              ;; 76 98
 sbc a', c              ;; 76 99
 sbc a', d              ;; 76 9A
 sbc a', e              ;; 76 9B
 sbc a', h              ;; 76 9C
 sbc a', l              ;; 76 9D
 sbc a, (42)            ;; DE 2A
 sbc a, (hl)            ;; 9E
 sbc a, (ix)            ;; DD 9E 00
 sbc a, (ix+127)        ;; DD 9E 7F
 sbc a, (iy)            ;; FD 9E 00
 sbc a, (iy+127)        ;; FD 9E 7F
 sbc a, 42              ;; DE 2A
 sbc a, a               ;; 9F
 sbc a, b               ;; 98
 sbc a, c               ;; 99
 sbc a, d               ;; 9A
 sbc a, e               ;; 9B
 sbc a, h               ;; 9C
 sbc a, l               ;; 9D
 sbc b                  ;; 98
 sbc c                  ;; 99
 sbc d                  ;; 9A
 sbc e                  ;; 9B
 sbc h                  ;; 9C
 sbc l                  ;; 9D
 scf                    ;; 37
 scf f                  ;; 37
 scf f'                 ;; 76 37
 sub (42)               ;; D6 2A
 sub (hl)               ;; 96
 sub (ix)               ;; DD 96 00
 sub (ix+127)           ;; DD 96 7F
 sub (iy)               ;; FD 96 00
 sub (iy+127)           ;; FD 96 7F
 sub 42                 ;; D6 2A
 sub a                  ;; 97
 sub a', (42)           ;; 76 D6 2A
 sub a', (hl)           ;; 76 96
 sub a', (ix)           ;; 76 DD 96 00
 sub a', (ix+127)       ;; 76 DD 96 7F
 sub a', (iy)           ;; 76 FD 96 00
 sub a', (iy+127)       ;; 76 FD 96 7F
 sub a', 42             ;; 76 D6 2A
 sub a', a              ;; 76 97
 sub a', b              ;; 76 90
 sub a', c              ;; 76 91
 sub a', d              ;; 76 92
 sub a', e              ;; 76 93
 sub a', h              ;; 76 94
 sub a', l              ;; 76 95
 sub a, (42)            ;; D6 2A
 sub a, (hl)            ;; 96
 sub a, (ix)            ;; DD 96 00
 sub a, (ix+127)        ;; DD 96 7F
 sub a, (iy)            ;; FD 96 00
 sub a, (iy+127)        ;; FD 96 7F
 sub a, 42              ;; D6 2A
 sub a, a               ;; 97
 sub a, b               ;; 90
 sub a, c               ;; 91
 sub a, d               ;; 92
 sub a, e               ;; 93
 sub a, h               ;; 94
 sub a, l               ;; 95
 sub b                  ;; 90
 sub c                  ;; 91
 sub d                  ;; 92
 sub e                  ;; 93
 sub h                  ;; 94
 sub l                  ;; 95
 tst (42)               ;; ED 64 2A
 tst (hl)               ;; ED 34
 tst 42                 ;; ED 64 2A
 tst a                  ;; ED 3C
 tst a, (42)            ;; ED 64 2A
 tst a, (hl)            ;; ED 34
 tst a, 42              ;; ED 64 2A
 tst a, a               ;; ED 3C
 tst a, b               ;; ED 04
 tst a, c               ;; ED 0C
 tst a, d               ;; ED 14
 tst a, e               ;; ED 1C
 tst a, h               ;; ED 24
 tst a, l               ;; ED 2C
 tst b                  ;; ED 04
 tst c                  ;; ED 0C
 tst d                  ;; ED 14
 tst e                  ;; ED 1C
 tst h                  ;; ED 24
 tst l                  ;; ED 2C
 xor (42)               ;; EE 2A
 xor (hl)               ;; AE
 xor (ix)               ;; DD AE 00
 xor (ix+127)           ;; DD AE 7F
 xor (iy)               ;; FD AE 00
 xor (iy+127)           ;; FD AE 7F
 xor 42                 ;; EE 2A
 xor a                  ;; AF
 xor a', (42)           ;; 76 EE 2A
 xor a', (hl)           ;; 76 AE
 xor a', (ix)           ;; 76 DD AE 00
 xor a', (ix+127)       ;; 76 DD AE 7F
 xor a', (iy)           ;; 76 FD AE 00
 xor a', (iy+127)       ;; 76 FD AE 7F
 xor a', 42             ;; 76 EE 2A
 xor a', a              ;; 76 AF
 xor a', b              ;; 76 A8
 xor a', c              ;; 76 A9
 xor a', d              ;; 76 AA
 xor a', e              ;; 76 AB
 xor a', h              ;; 76 AC
 xor a', l              ;; 76 AD
 xor a, (42)            ;; EE 2A
 xor a, (hl)            ;; AE
 xor a, (ix)            ;; DD AE 00
 xor a, (ix+127)        ;; DD AE 7F
 xor a, (iy)            ;; FD AE 00
 xor a, (iy+127)        ;; FD AE 7F
 xor a, 42              ;; EE 2A
 xor a, a               ;; AF
 xor a, b               ;; A8
 xor a, c               ;; A9
 xor a, d               ;; AA
 xor a, e               ;; AB
 xor a, h               ;; AC
 xor a, l               ;; AD
 xor b                  ;; A8
 xor c                  ;; A9
 xor d                  ;; AA
 xor e                  ;; AB
 xor h                  ;; AC
 xor l                  ;; AD
