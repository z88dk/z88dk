 ld b', b               ;; 0031:  76 40
 ld b', c               ;; 0031:  76 41
 ld b', d               ;; 0031:  76 42
 ld b', e               ;; 0031:  76 43
 ld b', h               ;; 0031:  76 44
 ld b', l               ;; 0031:  76 45
 ld b', a               ;; 0031:  76 47
 ld c', b               ;; 0031:  76 48
 ld c', c               ;; 0031:  76 49
 ld c', d               ;; 0031:  76 4A
 ld c', e               ;; 0031:  76 4B
 ld c', h               ;; 0031:  76 4C
 ld c', l               ;; 0031:  76 4D
 ld c', a               ;; 0031:  76 4F
 ld d', b               ;; 0031:  76 50
 ld d', c               ;; 0031:  76 51
 ld d', d               ;; 0031:  76 52
 ld d', e               ;; 0031:  76 53
 ld d', h               ;; 0031:  76 54
 ld d', l               ;; 0031:  76 55
 ld d', a               ;; 0031:  76 57
 ld e', b               ;; 0031:  76 58
 ld e', c               ;; 0031:  76 59
 ld e', d               ;; 0031:  76 5A
 ld e', e               ;; 0031:  76 5B
 ld e', h               ;; 0031:  76 5C
 ld e', l               ;; 0031:  76 5D
 ld e', a               ;; 0031:  76 5F
 ld h', b               ;; 0031:  76 60
 ld h', c               ;; 0031:  76 61
 ld h', d               ;; 0031:  76 62
 ld h', e               ;; 0031:  76 63
 ld h', h               ;; 0031:  76 64
 ld h', l               ;; 0031:  76 65
 ld h', a               ;; 0031:  76 67
 ld l', b               ;; 0031:  76 68
 ld l', c               ;; 0031:  76 69
 ld l', d               ;; 0031:  76 6A
 ld l', e               ;; 0031:  76 6B
 ld l', h               ;; 0031:  76 6C
 ld l', l               ;; 0031:  76 6D
 ld l', a               ;; 0031:  76 6F
 ld a', b               ;; 0031:  76 78
 ld a', c               ;; 0031:  76 79
 ld a', d               ;; 0031:  76 7A
 ld a', e               ;; 0031:  76 7B
 ld a', h               ;; 0031:  76 7C
 ld a', l               ;; 0031:  76 7D
 ld a', a               ;; 0031:  76 7F
 ld b', 0               ;; 00A1:  76 06 00
 ld b', 85              ;; 00A1:  76 06 55
 ld b', 170             ;; 00A1:  76 06 AA
 ld b', 255             ;; 00A1:  76 06 FF
 ld c', 0               ;; 00A1:  76 0E 00
 ld c', 85              ;; 00A1:  76 0E 55
 ld c', 170             ;; 00A1:  76 0E AA
 ld c', 255             ;; 00A1:  76 0E FF
 ld d', 0               ;; 00A1:  76 16 00
 ld d', 85              ;; 00A1:  76 16 55
 ld d', 170             ;; 00A1:  76 16 AA
 ld d', 255             ;; 00A1:  76 16 FF
 ld e', 0               ;; 00A1:  76 1E 00
 ld e', 85              ;; 00A1:  76 1E 55
 ld e', 170             ;; 00A1:  76 1E AA
 ld e', 255             ;; 00A1:  76 1E FF
 ld h', 0               ;; 00A1:  76 26 00
 ld h', 85              ;; 00A1:  76 26 55
 ld h', 170             ;; 00A1:  76 26 AA
 ld h', 255             ;; 00A1:  76 26 FF
 ld l', 0               ;; 00A1:  76 2E 00
 ld l', 85              ;; 00A1:  76 2E 55
 ld l', 170             ;; 00A1:  76 2E AA
 ld l', 255             ;; 00A1:  76 2E FF
 ld a', 0               ;; 00A1:  76 3E 00
 ld a', 85              ;; 00A1:  76 3E 55
 ld a', 170             ;; 00A1:  76 3E AA
 ld a', 255             ;; 00A1:  76 3E FF
 ld b', (hl)            ;; 00D8:  76 46
 ld c', (hl)            ;; 00D8:  76 4E
 ld d', (hl)            ;; 00D8:  76 56
 ld e', (hl)            ;; 00D8:  76 5E
 ld h', (hl)            ;; 00D8:  76 66
 ld l', (hl)            ;; 00D8:  76 6E
 ld a', (hl)            ;; 00D8:  76 7E
 ld b', (ix + -128)     ;; 0117:  76 DD 46 80
 ld b', (ix)            ;; 0117:  76 DD 46 00
 ld b', (ix + 127)      ;; 0117:  76 DD 46 7F
 ld c', (ix + -128)     ;; 0117:  76 DD 4E 80
 ld c', (ix)            ;; 0117:  76 DD 4E 00
 ld c', (ix + 127)      ;; 0117:  76 DD 4E 7F
 ld d', (ix + -128)     ;; 0117:  76 DD 56 80
 ld d', (ix)            ;; 0117:  76 DD 56 00
 ld d', (ix + 127)      ;; 0117:  76 DD 56 7F
 ld e', (ix + -128)     ;; 0117:  76 DD 5E 80
 ld e', (ix)            ;; 0117:  76 DD 5E 00
 ld e', (ix + 127)      ;; 0117:  76 DD 5E 7F
 ld h', (ix + -128)     ;; 0117:  76 DD 66 80
 ld h', (ix)            ;; 0117:  76 DD 66 00
 ld h', (ix + 127)      ;; 0117:  76 DD 66 7F
 ld l', (ix + -128)     ;; 0117:  76 DD 6E 80
 ld l', (ix)            ;; 0117:  76 DD 6E 00
 ld l', (ix + 127)      ;; 0117:  76 DD 6E 7F
 ld a', (ix + -128)     ;; 0117:  76 DD 7E 80
 ld a', (ix)            ;; 0117:  76 DD 7E 00
 ld a', (ix + 127)      ;; 0117:  76 DD 7E 7F
 ld b', (iy + -128)     ;; 0156:  76 FD 46 80
 ld b', (iy)            ;; 0156:  76 FD 46 00
 ld b', (iy + 127)      ;; 0156:  76 FD 46 7F
 ld c', (iy + -128)     ;; 0156:  76 FD 4E 80
 ld c', (iy)            ;; 0156:  76 FD 4E 00
 ld c', (iy + 127)      ;; 0156:  76 FD 4E 7F
 ld d', (iy + -128)     ;; 0156:  76 FD 56 80
 ld d', (iy)            ;; 0156:  76 FD 56 00
 ld d', (iy + 127)      ;; 0156:  76 FD 56 7F
 ld e', (iy + -128)     ;; 0156:  76 FD 5E 80
 ld e', (iy)            ;; 0156:  76 FD 5E 00
 ld e', (iy + 127)      ;; 0156:  76 FD 5E 7F
 ld h', (iy + -128)     ;; 0156:  76 FD 66 80
 ld h', (iy)            ;; 0156:  76 FD 66 00
 ld h', (iy + 127)      ;; 0156:  76 FD 66 7F
 ld l', (iy + -128)     ;; 0156:  76 FD 6E 80
 ld l', (iy)            ;; 0156:  76 FD 6E 00
 ld l', (iy + 127)      ;; 0156:  76 FD 6E 7F
 ld a', (iy + -128)     ;; 0156:  76 FD 7E 80
 ld a', (iy)            ;; 0156:  76 FD 7E 00
 ld a', (iy + 127)      ;; 0156:  76 FD 7E 7F
 ld a', (bc)            ;; 0245:  76 0A
 ld a', (de)            ;; 0245:  76 1A
 ld a', (0)             ;; 0259:  76 3A 00 00
 ld a', (291)           ;; 0259:  76 3A 23 01
 ld a', (17767)         ;; 0259:  76 3A 67 45
 ld a', (35243)         ;; 0259:  76 3A AB 89
 ld a', (52719)         ;; 0259:  76 3A EF CD
 ld a', (65535)         ;; 0259:  76 3A FF FF
 add a', b              ;; 050B:  76 80
 add a', c              ;; 050B:  76 81
 add a', d              ;; 050B:  76 82
 add a', e              ;; 050B:  76 83
 add a', h              ;; 050B:  76 84
 add a', l              ;; 050B:  76 85
 add a', (hl)           ;; 050B:  76 86
 add a', a              ;; 050B:  76 87
 adc a', b              ;; 050B:  76 88
 adc a', c              ;; 050B:  76 89
 adc a', d              ;; 050B:  76 8A
 adc a', e              ;; 050B:  76 8B
 adc a', h              ;; 050B:  76 8C
 adc a', l              ;; 050B:  76 8D
 adc a', (hl)           ;; 050B:  76 8E
 adc a', a              ;; 050B:  76 8F
 sub a', b              ;; 050B:  76 90
 sub a', c              ;; 050B:  76 91
 sub a', d              ;; 050B:  76 92
 sub a', e              ;; 050B:  76 93
 sub a', h              ;; 050B:  76 94
 sub a', l              ;; 050B:  76 95
 sub a', (hl)           ;; 050B:  76 96
 sub a', a              ;; 050B:  76 97
 sbc a', b              ;; 050B:  76 98
 sbc a', c              ;; 050B:  76 99
 sbc a', d              ;; 050B:  76 9A
 sbc a', e              ;; 050B:  76 9B
 sbc a', h              ;; 050B:  76 9C
 sbc a', l              ;; 050B:  76 9D
 sbc a', (hl)           ;; 050B:  76 9E
 sbc a', a              ;; 050B:  76 9F
 and a', b              ;; 050B:  76 A0
 and a', c              ;; 050B:  76 A1
 and a', d              ;; 050B:  76 A2
 and a', e              ;; 050B:  76 A3
 and a', h              ;; 050B:  76 A4
 and a', l              ;; 050B:  76 A5
 and a', (hl)           ;; 050B:  76 A6
 and a', a              ;; 050B:  76 A7
 xor a', b              ;; 050B:  76 A8
 xor a', c              ;; 050B:  76 A9
 xor a', d              ;; 050B:  76 AA
 xor a', e              ;; 050B:  76 AB
 xor a', h              ;; 050B:  76 AC
 xor a', l              ;; 050B:  76 AD
 xor a', (hl)           ;; 050B:  76 AE
 xor a', a              ;; 050B:  76 AF
 or a', b               ;; 050B:  76 B0
 or a', c               ;; 050B:  76 B1
 or a', d               ;; 050B:  76 B2
 or a', e               ;; 050B:  76 B3
 or a', h               ;; 050B:  76 B4
 or a', l               ;; 050B:  76 B5
 or a', (hl)            ;; 050B:  76 B6
 or a', a               ;; 050B:  76 B7
 add a', (ix+-128)      ;; 050B:  76 DD 86 80
 add a', (ix)           ;; 050B:  76 DD 86 00
 add a', (ix+127)       ;; 050B:  76 DD 86 7F
 adc a', (ix+-128)      ;; 050B:  76 DD 8E 80
 adc a', (ix)           ;; 050B:  76 DD 8E 00
 adc a', (ix+127)       ;; 050B:  76 DD 8E 7F
 sub a', (ix+-128)      ;; 050B:  76 DD 96 80
 sub a', (ix)           ;; 050B:  76 DD 96 00
 sub a', (ix+127)       ;; 050B:  76 DD 96 7F
 sbc a', (ix+-128)      ;; 050B:  76 DD 9E 80
 sbc a', (ix)           ;; 050B:  76 DD 9E 00
 sbc a', (ix+127)       ;; 050B:  76 DD 9E 7F
 and a', (ix+-128)      ;; 050B:  76 DD A6 80
 and a', (ix)           ;; 050B:  76 DD A6 00
 and a', (ix+127)       ;; 050B:  76 DD A6 7F
 xor a', (ix+-128)      ;; 050B:  76 DD AE 80
 xor a', (ix)           ;; 050B:  76 DD AE 00
 xor a', (ix+127)       ;; 050B:  76 DD AE 7F
 or a', (ix+-128)       ;; 050B:  76 DD B6 80
 or a', (ix)            ;; 050B:  76 DD B6 00
 or a', (ix+127)        ;; 050B:  76 DD B6 7F
 add a', 0              ;; 050B:  76 C6 00
 add a', 85             ;; 050B:  76 C6 55
 add a', 170            ;; 050B:  76 C6 AA
 add a', 255            ;; 050B:  76 C6 FF
 adc a', 0              ;; 050B:  76 CE 00
 adc a', 85             ;; 050B:  76 CE 55
 adc a', 170            ;; 050B:  76 CE AA
 adc a', 255            ;; 050B:  76 CE FF
 sub a', 0              ;; 050B:  76 D6 00
 sub a', 85             ;; 050B:  76 D6 55
 sub a', 170            ;; 050B:  76 D6 AA
 sub a', 255            ;; 050B:  76 D6 FF
 sbc a', 0              ;; 050B:  76 DE 00
 sbc a', 85             ;; 050B:  76 DE 55
 sbc a', 170            ;; 050B:  76 DE AA
 sbc a', 255            ;; 050B:  76 DE FF
 and a', 0              ;; 050B:  76 E6 00
 and a', 85             ;; 050B:  76 E6 55
 and a', 170            ;; 050B:  76 E6 AA
 and a', 255            ;; 050B:  76 E6 FF
 xor a', 0              ;; 050B:  76 EE 00
 xor a', 85             ;; 050B:  76 EE 55
 xor a', 170            ;; 050B:  76 EE AA
 xor a', 255            ;; 050B:  76 EE FF
 or a', 0               ;; 050B:  76 F6 00
 or a', 85              ;; 050B:  76 F6 55
 or a', 170             ;; 050B:  76 F6 AA
 or a', 255             ;; 050B:  76 F6 FF
 inc b'                 ;; 0519:  76 04
 inc c'                 ;; 0519:  76 0C
 inc d'                 ;; 0519:  76 14
 inc e'                 ;; 0519:  76 1C
 inc h'                 ;; 0519:  76 24
 inc l'                 ;; 0519:  76 2C
 inc a'                 ;; 0519:  76 3C
 dec b'                 ;; 0519:  76 05
 dec c'                 ;; 0519:  76 0D
 dec d'                 ;; 0519:  76 15
 dec e'                 ;; 0519:  76 1D
 dec h'                 ;; 0519:  76 25
 dec l'                 ;; 0519:  76 2D
 dec a'                 ;; 0519:  76 3D
 tst a, b               ;; 054F:  ED 04
 tst a, c               ;; 054F:  ED 0C
 tst a, d               ;; 054F:  ED 14
 tst a, e               ;; 054F:  ED 1C
 tst a, h               ;; 054F:  ED 24
 tst a, l               ;; 054F:  ED 2C
 tst a, a               ;; 054F:  ED 3C
 tst b                  ;; 054F:  ED 04
 tst c                  ;; 054F:  ED 0C
 tst d                  ;; 054F:  ED 14
 tst e                  ;; 054F:  ED 1C
 tst h                  ;; 054F:  ED 24
 tst l                  ;; 054F:  ED 2C
 tst a                  ;; 054F:  ED 3C
 tst a, 0               ;; 054F:  ED 64 00
 tst a, 85              ;; 054F:  ED 64 55
 tst a, 170             ;; 054F:  ED 64 AA
 tst a, 255             ;; 054F:  ED 64 FF
 tst 0                  ;; 054F:  ED 64 00
 tst 85                 ;; 054F:  ED 64 55
 tst 170                ;; 054F:  ED 64 AA
 tst 255                ;; 054F:  ED 64 FF
 tst a, (hl)            ;; 054F:  ED 34
 tst (hl)               ;; 054F:  ED 34
 cpl a'                 ;; 0556:  76 2F
 neg a'                 ;; 055A:  76 ED 44
 ccf f'                 ;; 055C:  76 3F
 scf f'                 ;; 055E:  76 37
 ld bc', 0              ;; 05A6:  76 01 00 00
 ld bc', 291            ;; 05A6:  76 01 23 01
 ld bc', 17767          ;; 05A6:  76 01 67 45
 ld bc', 35243          ;; 05A6:  76 01 AB 89
 ld bc', 52719          ;; 05A6:  76 01 EF CD
 ld bc', 65535          ;; 05A6:  76 01 FF FF
 ld de', 0              ;; 05A6:  76 11 00 00
 ld de', 291            ;; 05A6:  76 11 23 01
 ld de', 17767          ;; 05A6:  76 11 67 45
 ld de', 35243          ;; 05A6:  76 11 AB 89
 ld de', 52719          ;; 05A6:  76 11 EF CD
 ld de', 65535          ;; 05A6:  76 11 FF FF
 ld hl', 0              ;; 05A6:  76 21 00 00
 ld hl', 291            ;; 05A6:  76 21 23 01
 ld hl', 17767          ;; 05A6:  76 21 67 45
 ld hl', 35243          ;; 05A6:  76 21 AB 89
 ld hl', 52719          ;; 05A6:  76 21 EF CD
 ld hl', 65535          ;; 05A6:  76 21 FF FF
 ld hl', (0)            ;; 05E8:  76 2A 00 00
 ld hl', (291)          ;; 05E8:  76 2A 23 01
 ld hl', (17767)        ;; 05E8:  76 2A 67 45
 ld hl', (35243)        ;; 05E8:  76 2A AB 89
 ld hl', (52719)        ;; 05E8:  76 2A EF CD
 ld hl', (65535)        ;; 05E8:  76 2A FF FF
 ld bc', (0)            ;; 06A2:  76 ED 4B 00 00
 ld bc', (291)          ;; 06A2:  76 ED 4B 23 01
 ld bc', (17767)        ;; 06A2:  76 ED 4B 67 45
 ld bc', (35243)        ;; 06A2:  76 ED 4B AB 89
 ld bc', (52719)        ;; 06A2:  76 ED 4B EF CD
 ld bc', (65535)        ;; 06A2:  76 ED 4B FF FF
 ld de', (0)            ;; 06A2:  76 ED 5B 00 00
 ld de', (291)          ;; 06A2:  76 ED 5B 23 01
 ld de', (17767)        ;; 06A2:  76 ED 5B 67 45
 ld de', (35243)        ;; 06A2:  76 ED 5B AB 89
 ld de', (52719)        ;; 06A2:  76 ED 5B EF CD
 ld de', (65535)        ;; 06A2:  76 ED 5B FF FF
 push ip                ;; 06F7:  ED 76
 push su                ;; 06F7:  ED 66
 pop bc'                ;; 06FB:  76 C1
 pop de'                ;; 06FB:  76 D1
 pop hl'                ;; 06FB:  76 E1
 pop af'                ;; 06FB:  76 F1
 pop ip                 ;; 06FF:  ED 7E
 pop su                 ;; 06FF:  ED 6E
 ld hl, ix              ;; 06FF:  DD 7C
 ld hl', ix             ;; 06FF:  76 DD 7C
 ld hl, iy              ;; 06FF:  FD 7C
 ld hl', iy             ;; 06FF:  76 FD 7C
 ld ix, hl              ;; 06FF:  DD 7D
 ld iy, hl              ;; 06FF:  FD 7D
 ld hl, (hl + -128)     ;; 06FF:  DD E4 80
 ld hl, (hl)            ;; 06FF:  DD E4 00
 ld hl, (hl + 127)      ;; 06FF:  DD E4 7F
 ld hl', (hl + -128)    ;; 06FF:  76 DD E4 80
 ld hl', (hl)           ;; 06FF:  76 DD E4 00
 ld hl', (hl + 127)     ;; 06FF:  76 DD E4 7F
 ld hl, (ix + -128)     ;; 06FF:  E4 80
 ld hl, (ix)            ;; 06FF:  E4 00
 ld hl, (ix + 127)      ;; 06FF:  E4 7F
 ld hl', (ix + -128)    ;; 06FF:  76 E4 80
 ld hl', (ix)           ;; 06FF:  76 E4 00
 ld hl', (ix + 127)     ;; 06FF:  76 E4 7F
 ld hl, (iy + -128)     ;; 06FF:  FD E4 80
 ld hl, (iy)            ;; 06FF:  FD E4 00
 ld hl, (iy + 127)      ;; 06FF:  FD E4 7F
 ld hl', (iy + -128)    ;; 06FF:  76 FD E4 80
 ld hl', (iy)           ;; 06FF:  76 FD E4 00
 ld hl', (iy + 127)     ;; 06FF:  76 FD E4 7F
 ld (hl + -128), hl     ;; 06FF:  DD F4 80
 ld (hl), hl            ;; 06FF:  DD F4 00
 ld (hl + 127), hl      ;; 06FF:  DD F4 7F
 ld (ix + -128), hl     ;; 06FF:  F4 80
 ld (ix), hl            ;; 06FF:  F4 00
 ld (ix + 127), hl      ;; 06FF:  F4 7F
 ld (iy + -128), hl     ;; 06FF:  FD F4 80
 ld (iy), hl            ;; 06FF:  FD F4 00
 ld (iy + 127), hl      ;; 06FF:  FD F4 7F
 ldp (0), hl            ;; 06FF:  ED 65 00 00
 ldp (291), hl          ;; 06FF:  ED 65 23 01
 ldp (17767), hl        ;; 06FF:  ED 65 67 45
 ldp (35243), hl        ;; 06FF:  ED 65 AB 89
 ldp (52719), hl        ;; 06FF:  ED 65 EF CD
 ldp (65535), hl        ;; 06FF:  ED 65 FF FF
 ldp (0), ix            ;; 06FF:  DD 65 00 00
 ldp (291), ix          ;; 06FF:  DD 65 23 01
 ldp (17767), ix        ;; 06FF:  DD 65 67 45
 ldp (35243), ix        ;; 06FF:  DD 65 AB 89
 ldp (52719), ix        ;; 06FF:  DD 65 EF CD
 ldp (65535), ix        ;; 06FF:  DD 65 FF FF
 ldp (0), iy            ;; 06FF:  FD 65 00 00
 ldp (291), iy          ;; 06FF:  FD 65 23 01
 ldp (17767), iy        ;; 06FF:  FD 65 67 45
 ldp (35243), iy        ;; 06FF:  FD 65 AB 89
 ldp (52719), iy        ;; 06FF:  FD 65 EF CD
 ldp (65535), iy        ;; 06FF:  FD 65 FF FF
 ldp hl, (0)            ;; 06FF:  ED 6D 00 00
 ldp hl, (291)          ;; 06FF:  ED 6D 23 01
 ldp hl, (17767)        ;; 06FF:  ED 6D 67 45
 ldp hl, (35243)        ;; 06FF:  ED 6D AB 89
 ldp hl, (52719)        ;; 06FF:  ED 6D EF CD
 ldp hl, (65535)        ;; 06FF:  ED 6D FF FF
 ldp ix, (0)            ;; 06FF:  DD 6D 00 00
 ldp ix, (291)          ;; 06FF:  DD 6D 23 01
 ldp ix, (17767)        ;; 06FF:  DD 6D 67 45
 ldp ix, (35243)        ;; 06FF:  DD 6D AB 89
 ldp ix, (52719)        ;; 06FF:  DD 6D EF CD
 ldp ix, (65535)        ;; 06FF:  DD 6D FF FF
 ldp iy, (0)            ;; 06FF:  FD 6D 00 00
 ldp iy, (291)          ;; 06FF:  FD 6D 23 01
 ldp iy, (17767)        ;; 06FF:  FD 6D 67 45
 ldp iy, (35243)        ;; 06FF:  FD 6D AB 89
 ldp iy, (52719)        ;; 06FF:  FD 6D EF CD
 ldp iy, (65535)        ;; 06FF:  FD 6D FF FF
 ldp (hl), hl           ;; 06FF:  ED 64
 ldp (ix), hl           ;; 06FF:  DD 64
 ldp (iy), hl           ;; 06FF:  FD 64
 ldp hl, (hl)           ;; 06FF:  ED 6C
 ldp hl, (ix)           ;; 06FF:  DD 6C
 ldp hl, (iy)           ;; 06FF:  FD 6C
 ld (sp), hl            ;; 06FF:  D4 00
 ld (sp + 85), hl       ;; 06FF:  D4 55
 ld (sp + 170), hl      ;; 06FF:  D4 AA
 ld (sp + 255), hl      ;; 06FF:  D4 FF
 ld (sp), ix            ;; 06FF:  DD D4 00
 ld (sp + 85), ix       ;; 06FF:  DD D4 55
 ld (sp + 170), ix      ;; 06FF:  DD D4 AA
 ld (sp + 255), ix      ;; 06FF:  DD D4 FF
 ld (sp), iy            ;; 06FF:  FD D4 00
 ld (sp + 85), iy       ;; 06FF:  FD D4 55
 ld (sp + 170), iy      ;; 06FF:  FD D4 AA
 ld (sp + 255), iy      ;; 06FF:  FD D4 FF
 ld hl, (sp)            ;; 06FF:  C4 00
 ld hl, (sp + 85)       ;; 06FF:  C4 55
 ld hl, (sp + 170)      ;; 06FF:  C4 AA
 ld hl, (sp + 255)      ;; 06FF:  C4 FF
 ld hl', (sp)           ;; 06FF:  76 C4 00
 ld hl', (sp + 85)      ;; 06FF:  76 C4 55
 ld hl', (sp + 170)     ;; 06FF:  76 C4 AA
 ld hl', (sp + 255)     ;; 06FF:  76 C4 FF
 ld ix, (sp)            ;; 06FF:  DD C4 00
 ld ix, (sp + 85)       ;; 06FF:  DD C4 55
 ld ix, (sp + 170)      ;; 06FF:  DD C4 AA
 ld ix, (sp + 255)      ;; 06FF:  DD C4 FF
 ld iy, (sp)            ;; 06FF:  FD C4 00
 ld iy, (sp + 85)       ;; 06FF:  FD C4 55
 ld iy, (sp + 170)      ;; 06FF:  FD C4 AA
 ld iy, (sp + 255)      ;; 06FF:  FD C4 FF
 ld bc', bc             ;; 06FF:  ED 49
 ld bc', de             ;; 06FF:  ED 41
 ld de', bc             ;; 06FF:  ED 59
 ld de', de             ;; 06FF:  ED 51
 ld hl', bc             ;; 06FF:  ED 69
 ld hl', de             ;; 06FF:  ED 61
 add hl', bc            ;; 0703:  76 09
 add hl', de            ;; 0703:  76 19
 add hl', hl            ;; 0703:  76 29
 add hl', sp            ;; 0703:  76 39
 sbc hl', bc            ;; 0723:  76 ED 42
 sbc hl', de            ;; 0723:  76 ED 52
 sbc hl', hl            ;; 0723:  76 ED 62
 sbc hl', sp            ;; 0723:  76 ED 72
 adc hl', bc            ;; 0723:  76 ED 4A
 adc hl', de            ;; 0723:  76 ED 5A
 adc hl', hl            ;; 0723:  76 ED 6A
 adc hl', sp            ;; 0723:  76 ED 7A
 inc bc'                ;; 072B:  76 03
 inc de'                ;; 072B:  76 13
 inc hl'                ;; 072B:  76 23
 dec bc'                ;; 072B:  76 0B
 dec de'                ;; 072B:  76 1B
 dec hl'                ;; 072B:  76 2B
 add sp, -128           ;; 0733:  27 80
 add sp, 0              ;; 0733:  27 00
 add sp, 127            ;; 0733:  27 7F
 and hl, de             ;; 0733:  DC
 or hl, de              ;; 0733:  EC
 and hl', de            ;; 0733:  76 DC
 or hl', de             ;; 0733:  76 EC
 and ix, de             ;; 0733:  DD DC
 or ix, de              ;; 0733:  DD EC
 and iy, de             ;; 0733:  FD DC
 or iy, de              ;; 0733:  FD EC
 bool hl                ;; 0733:  CC
 bool hl'               ;; 0733:  76 CC
 bool ix                ;; 0733:  DD CC
 bool iy                ;; 0733:  FD CC
 mlt bc                 ;; 0733:  ED 4C
 mlt de                 ;; 0733:  ED 5C
 mlt hl                 ;; 0733:  ED 6C
 mlt sp                 ;; 0733:  ED 7C
 mul                    ;; 0733:  F7
 uma                    ;; 0733:  ED C0
 ums                    ;; 0733:  ED C8
 ex (sp), hl'           ;; 0737:  76 ED 54
 ex de', hl             ;; 073C:  E3
 ex de, hl'             ;; 073C:  76 EB
 ex de', hl'            ;; 073C:  76 E3
 rl de                  ;; 0880:  F3
 rr de                  ;; 0880:  FB
 rr hl                  ;; 0880:  FC
 rl de'                 ;; 0880:  76 F3
 rr de'                 ;; 0880:  76 FB
 rr hl'                 ;; 0880:  76 FC
 rr ix                  ;; 0880:  DD FC
 rr iy                  ;; 0880:  FD FC
 res 0, b'              ;; 0A00:  76 CB 80
 res 0, c'              ;; 0A00:  76 CB 81
 res 0, d'              ;; 0A00:  76 CB 82
 res 0, e'              ;; 0A00:  76 CB 83
 res 0, h'              ;; 0A00:  76 CB 84
 res 0, l'              ;; 0A00:  76 CB 85
 res 0, a'              ;; 0A00:  76 CB 87
 res 1, b'              ;; 0A00:  76 CB 88
 res 1, c'              ;; 0A00:  76 CB 89
 res 1, d'              ;; 0A00:  76 CB 8A
 res 1, e'              ;; 0A00:  76 CB 8B
 res 1, h'              ;; 0A00:  76 CB 8C
 res 1, l'              ;; 0A00:  76 CB 8D
 res 1, a'              ;; 0A00:  76 CB 8F
 res 2, b'              ;; 0A00:  76 CB 90
 res 2, c'              ;; 0A00:  76 CB 91
 res 2, d'              ;; 0A00:  76 CB 92
 res 2, e'              ;; 0A00:  76 CB 93
 res 2, h'              ;; 0A00:  76 CB 94
 res 2, l'              ;; 0A00:  76 CB 95
 res 2, a'              ;; 0A00:  76 CB 97
 res 3, b'              ;; 0A00:  76 CB 98
 res 3, c'              ;; 0A00:  76 CB 99
 res 3, d'              ;; 0A00:  76 CB 9A
 res 3, e'              ;; 0A00:  76 CB 9B
 res 3, h'              ;; 0A00:  76 CB 9C
 res 3, l'              ;; 0A00:  76 CB 9D
 res 3, a'              ;; 0A00:  76 CB 9F
 res 4, b'              ;; 0A00:  76 CB A0
 res 4, c'              ;; 0A00:  76 CB A1
 res 4, d'              ;; 0A00:  76 CB A2
 res 4, e'              ;; 0A00:  76 CB A3
 res 4, h'              ;; 0A00:  76 CB A4
 res 4, l'              ;; 0A00:  76 CB A5
 res 4, a'              ;; 0A00:  76 CB A7
 res 5, b'              ;; 0A00:  76 CB A8
 res 5, c'              ;; 0A00:  76 CB A9
 res 5, d'              ;; 0A00:  76 CB AA
 res 5, e'              ;; 0A00:  76 CB AB
 res 5, h'              ;; 0A00:  76 CB AC
 res 5, l'              ;; 0A00:  76 CB AD
 res 5, a'              ;; 0A00:  76 CB AF
 res 6, b'              ;; 0A00:  76 CB B0
 res 6, c'              ;; 0A00:  76 CB B1
 res 6, d'              ;; 0A00:  76 CB B2
 res 6, e'              ;; 0A00:  76 CB B3
 res 6, h'              ;; 0A00:  76 CB B4
 res 6, l'              ;; 0A00:  76 CB B5
 res 6, a'              ;; 0A00:  76 CB B7
 res 7, b'              ;; 0A00:  76 CB B8
 res 7, c'              ;; 0A00:  76 CB B9
 res 7, d'              ;; 0A00:  76 CB BA
 res 7, e'              ;; 0A00:  76 CB BB
 res 7, h'              ;; 0A00:  76 CB BC
 res 7, l'              ;; 0A00:  76 CB BD
 res 7, a'              ;; 0A00:  76 CB BF
 set 0, b'              ;; 0A00:  76 CB C0
 set 0, c'              ;; 0A00:  76 CB C1
 set 0, d'              ;; 0A00:  76 CB C2
 set 0, e'              ;; 0A00:  76 CB C3
 set 0, h'              ;; 0A00:  76 CB C4
 set 0, l'              ;; 0A00:  76 CB C5
 set 0, a'              ;; 0A00:  76 CB C7
 set 1, b'              ;; 0A00:  76 CB C8
 set 1, c'              ;; 0A00:  76 CB C9
 set 1, d'              ;; 0A00:  76 CB CA
 set 1, e'              ;; 0A00:  76 CB CB
 set 1, h'              ;; 0A00:  76 CB CC
 set 1, l'              ;; 0A00:  76 CB CD
 set 1, a'              ;; 0A00:  76 CB CF
 set 2, b'              ;; 0A00:  76 CB D0
 set 2, c'              ;; 0A00:  76 CB D1
 set 2, d'              ;; 0A00:  76 CB D2
 set 2, e'              ;; 0A00:  76 CB D3
 set 2, h'              ;; 0A00:  76 CB D4
 set 2, l'              ;; 0A00:  76 CB D5
 set 2, a'              ;; 0A00:  76 CB D7
 set 3, b'              ;; 0A00:  76 CB D8
 set 3, c'              ;; 0A00:  76 CB D9
 set 3, d'              ;; 0A00:  76 CB DA
 set 3, e'              ;; 0A00:  76 CB DB
 set 3, h'              ;; 0A00:  76 CB DC
 set 3, l'              ;; 0A00:  76 CB DD
 set 3, a'              ;; 0A00:  76 CB DF
 set 4, b'              ;; 0A00:  76 CB E0
 set 4, c'              ;; 0A00:  76 CB E1
 set 4, d'              ;; 0A00:  76 CB E2
 set 4, e'              ;; 0A00:  76 CB E3
 set 4, h'              ;; 0A00:  76 CB E4
 set 4, l'              ;; 0A00:  76 CB E5
 set 4, a'              ;; 0A00:  76 CB E7
 set 5, b'              ;; 0A00:  76 CB E8
 set 5, c'              ;; 0A00:  76 CB E9
 set 5, d'              ;; 0A00:  76 CB EA
 set 5, e'              ;; 0A00:  76 CB EB
 set 5, h'              ;; 0A00:  76 CB EC
 set 5, l'              ;; 0A00:  76 CB ED
 set 5, a'              ;; 0A00:  76 CB EF
 set 6, b'              ;; 0A00:  76 CB F0
 set 6, c'              ;; 0A00:  76 CB F1
 set 6, d'              ;; 0A00:  76 CB F2
 set 6, e'              ;; 0A00:  76 CB F3
 set 6, h'              ;; 0A00:  76 CB F4
 set 6, l'              ;; 0A00:  76 CB F5
 set 6, a'              ;; 0A00:  76 CB F7
 set 7, b'              ;; 0A00:  76 CB F8
 set 7, c'              ;; 0A00:  76 CB F9
 set 7, d'              ;; 0A00:  76 CB FA
 set 7, e'              ;; 0A00:  76 CB FB
 set 7, h'              ;; 0A00:  76 CB FC
 set 7, l'              ;; 0A00:  76 CB FD
 set 7, a'              ;; 0A00:  76 CB FF
 ldisr                  ;; 0C48:  ED 90
 lddsr                  ;; 0C48:  ED 98
 lsdr                   ;; 0C48:  ED F8
 lsir                   ;; 0C48:  ED F0
 lsddr                  ;; 0C48:  ED D8
 lsidr                  ;; 0C48:  ED D0
 slp                    ;; 0C52:  ED 76
 altd                   ;; 0C52:  76
 ld a, xpc              ;; 0C52:  ED 77
 ld a', xpc             ;; 0C52:  76 ED 77
 ld xpc, a              ;; 0C52:  ED 67
 rdmode                 ;; 0C52:  ED 7F
 setusr                 ;; 0C52:  ED 6F
 sures                  ;; 0C52:  ED 7D
 syscall                ;; 0C52:  ED 75
 jp lz, 0               ;; 0CF4:  E2 00 00
 jp lz, 291             ;; 0CF4:  E2 23 01
 jp lz, 17767           ;; 0CF4:  E2 67 45
 jp lz, 35243           ;; 0CF4:  E2 AB 89
 jp lz, 52719           ;; 0CF4:  E2 EF CD
 jp lz, 65535           ;; 0CF4:  E2 FF FF
 jp lo, 0               ;; 0CF4:  EA 00 00
 jp lo, 291             ;; 0CF4:  EA 23 01
 jp lo, 17767           ;; 0CF4:  EA 67 45
 jp lo, 35243           ;; 0CF4:  EA AB 89
 jp lo, 52719           ;; 0CF4:  EA EF CD
 jp lo, 65535           ;; 0CF4:  EA FF FF
 djnz b', ASMPC         ;; 0CFD:  76 10 FE
 ret lz                 ;; 0DB2:  E0
 ret lo                 ;; 0DB2:  E8
 in0 b, (0)             ;; 0DD2:  ED 00 00
 in0 b, (85)            ;; 0DD2:  ED 00 55
 in0 b, (170)           ;; 0DD2:  ED 00 AA
 in0 b, (255)           ;; 0DD2:  ED 00 FF
 in0 c, (0)             ;; 0DD2:  ED 08 00
 in0 c, (85)            ;; 0DD2:  ED 08 55
 in0 c, (170)           ;; 0DD2:  ED 08 AA
 in0 c, (255)           ;; 0DD2:  ED 08 FF
 in0 d, (0)             ;; 0DD2:  ED 10 00
 in0 d, (85)            ;; 0DD2:  ED 10 55
 in0 d, (170)           ;; 0DD2:  ED 10 AA
 in0 d, (255)           ;; 0DD2:  ED 10 FF
 in0 e, (0)             ;; 0DD2:  ED 18 00
 in0 e, (85)            ;; 0DD2:  ED 18 55
 in0 e, (170)           ;; 0DD2:  ED 18 AA
 in0 e, (255)           ;; 0DD2:  ED 18 FF
 in0 h, (0)             ;; 0DD2:  ED 20 00
 in0 h, (85)            ;; 0DD2:  ED 20 55
 in0 h, (170)           ;; 0DD2:  ED 20 AA
 in0 h, (255)           ;; 0DD2:  ED 20 FF
 in0 l, (0)             ;; 0DD2:  ED 28 00
 in0 l, (85)            ;; 0DD2:  ED 28 55
 in0 l, (170)           ;; 0DD2:  ED 28 AA
 in0 l, (255)           ;; 0DD2:  ED 28 FF
 in0 f, (0)             ;; 0DD2:  ED 30 00
 in0 f, (85)            ;; 0DD2:  ED 30 55
 in0 f, (170)           ;; 0DD2:  ED 30 AA
 in0 f, (255)           ;; 0DD2:  ED 30 FF
 in0 a, (0)             ;; 0DD2:  ED 38 00
 in0 a, (85)            ;; 0DD2:  ED 38 55
 in0 a, (170)           ;; 0DD2:  ED 38 AA
 in0 a, (255)           ;; 0DD2:  ED 38 FF
 out0 (0), b            ;; 0DEA:  ED 01 00
 out0 (85), b           ;; 0DEA:  ED 01 55
 out0 (170), b          ;; 0DEA:  ED 01 AA
 out0 (255), b          ;; 0DEA:  ED 01 FF
 out0 (0), c            ;; 0DEA:  ED 09 00
 out0 (85), c           ;; 0DEA:  ED 09 55
 out0 (170), c          ;; 0DEA:  ED 09 AA
 out0 (255), c          ;; 0DEA:  ED 09 FF
 out0 (0), d            ;; 0DEA:  ED 11 00
 out0 (85), d           ;; 0DEA:  ED 11 55
 out0 (170), d          ;; 0DEA:  ED 11 AA
 out0 (255), d          ;; 0DEA:  ED 11 FF
 out0 (0), e            ;; 0DEA:  ED 19 00
 out0 (85), e           ;; 0DEA:  ED 19 55
 out0 (170), e          ;; 0DEA:  ED 19 AA
 out0 (255), e          ;; 0DEA:  ED 19 FF
 out0 (0), h            ;; 0DEA:  ED 21 00
 out0 (85), h           ;; 0DEA:  ED 21 55
 out0 (170), h          ;; 0DEA:  ED 21 AA
 out0 (255), h          ;; 0DEA:  ED 21 FF
 out0 (0), l            ;; 0DEA:  ED 29 00
 out0 (85), l           ;; 0DEA:  ED 29 55
 out0 (170), l          ;; 0DEA:  ED 29 AA
 out0 (255), l          ;; 0DEA:  ED 29 FF
 out0 (0), a            ;; 0DEA:  ED 39 00
 out0 (85), a           ;; 0DEA:  ED 39 55
 out0 (170), a          ;; 0DEA:  ED 39 AA
 out0 (255), a          ;; 0DEA:  ED 39 FF
 tstio 0                ;; 0DEA:  ED 74 00
 tstio 85               ;; 0DEA:  ED 74 55
 tstio 170              ;; 0DEA:  ED 74 AA
 tstio 255              ;; 0DEA:  ED 74 FF
 ioe                    ;; 0DEA:  DB
 ioi                    ;; 0DEA:  D3
 otdm                   ;; 0DFA:  ED 8B
 otdmr                  ;; 0DFA:  ED 9B
 otim                   ;; 0DFA:  ED 83
 otimr                  ;; 0DFA:  ED 93
 ipset 0                ;; 0E02:  ED 46
 ipset 1                ;; 0E02:  ED 56
 ipset 2                ;; 0E02:  ED 4E
 ipset 3                ;; 0E02:  ED 5E
 ipres                  ;; 0E02:  ED 5D
 ld iir, a              ;; 0E0A:  ED 4F
 ld a, iir              ;; 0E0A:  ED 5F
 ld a', iir             ;; 0E0A:  76 ED 5F
 ld eir, a              ;; 0E0A:  ED 47
 ld a, eir              ;; 0E0A:  ED 57
 ld a', eir             ;; 0E0A:  76 ED 57
 idet                   ;; 0E0E:  5B
