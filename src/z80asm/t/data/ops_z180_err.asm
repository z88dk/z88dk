 ld b, ixh              ;; 0000:  DD 44
 ld b, ixl              ;; 0000:  DD 45
 ld c, ixh              ;; 0000:  DD 4C
 ld c, ixl              ;; 0000:  DD 4D
 ld d, ixh              ;; 0000:  DD 54
 ld d, ixl              ;; 0000:  DD 55
 ld e, ixh              ;; 0000:  DD 5C
 ld e, ixl              ;; 0000:  DD 5D
 ld ixh, ixh            ;; 0000:  DD 64
 ld ixh, ixl            ;; 0000:  DD 65
 ld ixl, ixh            ;; 0000:  DD 6C
 ld ixl, ixl            ;; 0000:  DD 6D
 ld a, ixh              ;; 0000:  DD 7C
 ld a, ixl              ;; 0000:  DD 7D
 ld b, iyh              ;; 0000:  FD 44
 ld b, iyl              ;; 0000:  FD 45
 ld c, iyh              ;; 0000:  FD 4C
 ld c, iyl              ;; 0000:  FD 4D
 ld d, iyh              ;; 0000:  FD 54
 ld d, iyl              ;; 0000:  FD 55
 ld e, iyh              ;; 0000:  FD 5C
 ld e, iyl              ;; 0000:  FD 5D
 ld iyh, iyh            ;; 0000:  FD 64
 ld iyh, iyl            ;; 0000:  FD 65
 ld iyl, iyh            ;; 0000:  FD 6C
 ld iyl, iyl            ;; 0000:  FD 6D
 ld a, iyh              ;; 0000:  FD 7C
 ld a, iyl              ;; 0000:  FD 7D
 ld b', 0               ;; 0038:  76 06 00
 ld b', 85              ;; 0038:  76 06 55
 ld b', 170             ;; 0038:  76 06 AA
 ld b', 255             ;; 0038:  76 06 FF
 ld c', 0               ;; 0038:  76 0E 00
 ld c', 85              ;; 0038:  76 0E 55
 ld c', 170             ;; 0038:  76 0E AA
 ld c', 255             ;; 0038:  76 0E FF
 ld d', 0               ;; 0038:  76 16 00
 ld d', 85              ;; 0038:  76 16 55
 ld d', 170             ;; 0038:  76 16 AA
 ld d', 255             ;; 0038:  76 16 FF
 ld e', 0               ;; 0038:  76 1E 00
 ld e', 85              ;; 0038:  76 1E 55
 ld e', 170             ;; 0038:  76 1E AA
 ld e', 255             ;; 0038:  76 1E FF
 ld h', 0               ;; 0038:  76 26 00
 ld h', 85              ;; 0038:  76 26 55
 ld h', 170             ;; 0038:  76 26 AA
 ld h', 255             ;; 0038:  76 26 FF
 ld l', 0               ;; 0038:  76 2E 00
 ld l', 85              ;; 0038:  76 2E 55
 ld l', 170             ;; 0038:  76 2E AA
 ld l', 255             ;; 0038:  76 2E FF
 ld a', 0               ;; 0038:  76 3E 00
 ld a', 85              ;; 0038:  76 3E 55
 ld a', 170             ;; 0038:  76 3E AA
 ld a', 255             ;; 0038:  76 3E FF
 ld ixh, 0              ;; 0038:  DD 26 00
 ld ixh, 85             ;; 0038:  DD 26 55
 ld ixh, 170            ;; 0038:  DD 26 AA
 ld ixh, 255            ;; 0038:  DD 26 FF
 ld ixl, 0              ;; 0038:  DD 2E 00
 ld ixl, 85             ;; 0038:  DD 2E 55
 ld ixl, 170            ;; 0038:  DD 2E AA
 ld ixl, 255            ;; 0038:  DD 2E FF
 ld iyh, 0              ;; 0038:  FD 26 00
 ld iyh, 85             ;; 0038:  FD 26 55
 ld iyh, 170            ;; 0038:  FD 26 AA
 ld iyh, 255            ;; 0038:  FD 26 FF
 ld iyl, 0              ;; 0038:  FD 2E 00
 ld iyl, 85             ;; 0038:  FD 2E 55
 ld iyl, 170            ;; 0038:  FD 2E AA
 ld iyl, 255            ;; 0038:  FD 2E FF
 ld b', (hl)            ;; 003F:  76 46
 ld c', (hl)            ;; 003F:  76 4E
 ld d', (hl)            ;; 003F:  76 56
 ld e', (hl)            ;; 003F:  76 5E
 ld h', (hl)            ;; 003F:  76 66
 ld l', (hl)            ;; 003F:  76 6E
 ld a', (hl)            ;; 003F:  76 7E
 ld b', (ix + -128)     ;; 007E:  76 DD 46 80
 ld b', (ix)            ;; 007E:  76 DD 46 00
 ld b', (ix + 127)      ;; 007E:  76 DD 46 7F
 ld c', (ix + -128)     ;; 007E:  76 DD 4E 80
 ld c', (ix)            ;; 007E:  76 DD 4E 00
 ld c', (ix + 127)      ;; 007E:  76 DD 4E 7F
 ld d', (ix + -128)     ;; 007E:  76 DD 56 80
 ld d', (ix)            ;; 007E:  76 DD 56 00
 ld d', (ix + 127)      ;; 007E:  76 DD 56 7F
 ld e', (ix + -128)     ;; 007E:  76 DD 5E 80
 ld e', (ix)            ;; 007E:  76 DD 5E 00
 ld e', (ix + 127)      ;; 007E:  76 DD 5E 7F
 ld h', (ix + -128)     ;; 007E:  76 DD 66 80
 ld h', (ix)            ;; 007E:  76 DD 66 00
 ld h', (ix + 127)      ;; 007E:  76 DD 66 7F
 ld l', (ix + -128)     ;; 007E:  76 DD 6E 80
 ld l', (ix)            ;; 007E:  76 DD 6E 00
 ld l', (ix + 127)      ;; 007E:  76 DD 6E 7F
 ld a', (ix + -128)     ;; 007E:  76 DD 7E 80
 ld a', (ix)            ;; 007E:  76 DD 7E 00
 ld a', (ix + 127)      ;; 007E:  76 DD 7E 7F
 ld b', (iy + -128)     ;; 00BD:  76 FD 46 80
 ld b', (iy)            ;; 00BD:  76 FD 46 00
 ld b', (iy + 127)      ;; 00BD:  76 FD 46 7F
 ld c', (iy + -128)     ;; 00BD:  76 FD 4E 80
 ld c', (iy)            ;; 00BD:  76 FD 4E 00
 ld c', (iy + 127)      ;; 00BD:  76 FD 4E 7F
 ld d', (iy + -128)     ;; 00BD:  76 FD 56 80
 ld d', (iy)            ;; 00BD:  76 FD 56 00
 ld d', (iy + 127)      ;; 00BD:  76 FD 56 7F
 ld e', (iy + -128)     ;; 00BD:  76 FD 5E 80
 ld e', (iy)            ;; 00BD:  76 FD 5E 00
 ld e', (iy + 127)      ;; 00BD:  76 FD 5E 7F
 ld h', (iy + -128)     ;; 00BD:  76 FD 66 80
 ld h', (iy)            ;; 00BD:  76 FD 66 00
 ld h', (iy + 127)      ;; 00BD:  76 FD 66 7F
 ld l', (iy + -128)     ;; 00BD:  76 FD 6E 80
 ld l', (iy)            ;; 00BD:  76 FD 6E 00
 ld l', (iy + 127)      ;; 00BD:  76 FD 6E 7F
 ld a', (iy + -128)     ;; 00BD:  76 FD 7E 80
 ld a', (iy)            ;; 00BD:  76 FD 7E 00
 ld a', (iy + 127)      ;; 00BD:  76 FD 7E 7F
 ld a', (bc)            ;; 01AC:  76 0A
 ld a', (de)            ;; 01AC:  76 1A
 ld a', (0)             ;; 01C0:  76 3A 00 00
 ld a', (291)           ;; 01C0:  76 3A 23 01
 ld a', (17767)         ;; 01C0:  76 3A 67 45
 ld a', (35243)         ;; 01C0:  76 3A AB 89
 ld a', (52719)         ;; 01C0:  76 3A EF CD
 ld a', (65535)         ;; 01C0:  76 3A FF FF
 add a, ixh             ;; 0372:  DD 84
 add a, ixl             ;; 0372:  DD 85
 adc a, ixh             ;; 0372:  DD 8C
 adc a, ixl             ;; 0372:  DD 8D
 sub a, ixh             ;; 0372:  DD 94
 sub a, ixl             ;; 0372:  DD 95
 sbc a, ixh             ;; 0372:  DD 9C
 sbc a, ixl             ;; 0372:  DD 9D
 and a, ixh             ;; 0372:  DD A4
 and a, ixl             ;; 0372:  DD A5
 xor a, ixh             ;; 0372:  DD AC
 xor a, ixl             ;; 0372:  DD AD
 or a, ixh              ;; 0372:  DD B4
 or a, ixl              ;; 0372:  DD B5
 cp a, ixh              ;; 0372:  DD BC
 cp a, ixl              ;; 0372:  DD BD
 add ixh                ;; 0372:  DD 84
 add ixl                ;; 0372:  DD 85
 adc ixh                ;; 0372:  DD 8C
 adc ixl                ;; 0372:  DD 8D
 sub ixh                ;; 0372:  DD 94
 sub ixl                ;; 0372:  DD 95
 sbc ixh                ;; 0372:  DD 9C
 sbc ixl                ;; 0372:  DD 9D
 and ixh                ;; 0372:  DD A4
 and ixl                ;; 0372:  DD A5
 xor ixh                ;; 0372:  DD AC
 xor ixl                ;; 0372:  DD AD
 or ixh                 ;; 0372:  DD B4
 or ixl                 ;; 0372:  DD B5
 cp ixh                 ;; 0372:  DD BC
 cp ixl                 ;; 0372:  DD BD
 add a, iyh             ;; 0372:  FD 84
 add a, iyl             ;; 0372:  FD 85
 adc a, iyh             ;; 0372:  FD 8C
 adc a, iyl             ;; 0372:  FD 8D
 sub a, iyh             ;; 0372:  FD 94
 sub a, iyl             ;; 0372:  FD 95
 sbc a, iyh             ;; 0372:  FD 9C
 sbc a, iyl             ;; 0372:  FD 9D
 and a, iyh             ;; 0372:  FD A4
 and a, iyl             ;; 0372:  FD A5
 xor a, iyh             ;; 0372:  FD AC
 xor a, iyl             ;; 0372:  FD AD
 or a, iyh              ;; 0372:  FD B4
 or a, iyl              ;; 0372:  FD B5
 cp a, iyh              ;; 0372:  FD BC
 cp a, iyl              ;; 0372:  FD BD
 add iyh                ;; 0372:  FD 84
 add iyl                ;; 0372:  FD 85
 adc iyh                ;; 0372:  FD 8C
 adc iyl                ;; 0372:  FD 8D
 sub iyh                ;; 0372:  FD 94
 sub iyl                ;; 0372:  FD 95
 sbc iyh                ;; 0372:  FD 9C
 sbc iyl                ;; 0372:  FD 9D
 and iyh                ;; 0372:  FD A4
 and iyl                ;; 0372:  FD A5
 xor iyh                ;; 0372:  FD AC
 xor iyl                ;; 0372:  FD AD
 or iyh                 ;; 0372:  FD B4
 or iyl                 ;; 0372:  FD B5
 cp iyh                 ;; 0372:  FD BC
 cp iyl                 ;; 0372:  FD BD
 add a', b              ;; 03F2:  76 80
 add a', c              ;; 03F2:  76 81
 add a', d              ;; 03F2:  76 82
 add a', e              ;; 03F2:  76 83
 add a', h              ;; 03F2:  76 84
 add a', l              ;; 03F2:  76 85
 add a', (hl)           ;; 03F2:  76 86
 add a', a              ;; 03F2:  76 87
 adc a', b              ;; 03F2:  76 88
 adc a', c              ;; 03F2:  76 89
 adc a', d              ;; 03F2:  76 8A
 adc a', e              ;; 03F2:  76 8B
 adc a', h              ;; 03F2:  76 8C
 adc a', l              ;; 03F2:  76 8D
 adc a', (hl)           ;; 03F2:  76 8E
 adc a', a              ;; 03F2:  76 8F
 sub a', b              ;; 03F2:  76 90
 sub a', c              ;; 03F2:  76 91
 sub a', d              ;; 03F2:  76 92
 sub a', e              ;; 03F2:  76 93
 sub a', h              ;; 03F2:  76 94
 sub a', l              ;; 03F2:  76 95
 sub a', (hl)           ;; 03F2:  76 96
 sub a', a              ;; 03F2:  76 97
 sbc a', b              ;; 03F2:  76 98
 sbc a', c              ;; 03F2:  76 99
 sbc a', d              ;; 03F2:  76 9A
 sbc a', e              ;; 03F2:  76 9B
 sbc a', h              ;; 03F2:  76 9C
 sbc a', l              ;; 03F2:  76 9D
 sbc a', (hl)           ;; 03F2:  76 9E
 sbc a', a              ;; 03F2:  76 9F
 and a', b              ;; 03F2:  76 A0
 and a', c              ;; 03F2:  76 A1
 and a', d              ;; 03F2:  76 A2
 and a', e              ;; 03F2:  76 A3
 and a', h              ;; 03F2:  76 A4
 and a', l              ;; 03F2:  76 A5
 and a', (hl)           ;; 03F2:  76 A6
 and a', a              ;; 03F2:  76 A7
 xor a', b              ;; 03F2:  76 A8
 xor a', c              ;; 03F2:  76 A9
 xor a', d              ;; 03F2:  76 AA
 xor a', e              ;; 03F2:  76 AB
 xor a', h              ;; 03F2:  76 AC
 xor a', l              ;; 03F2:  76 AD
 xor a', (hl)           ;; 03F2:  76 AE
 xor a', a              ;; 03F2:  76 AF
 or a', b               ;; 03F2:  76 B0
 or a', c               ;; 03F2:  76 B1
 or a', d               ;; 03F2:  76 B2
 or a', e               ;; 03F2:  76 B3
 or a', h               ;; 03F2:  76 B4
 or a', l               ;; 03F2:  76 B5
 or a', (hl)            ;; 03F2:  76 B6
 or a', a               ;; 03F2:  76 B7
 add a', (ix+-128)      ;; 03F2:  76 DD 86 80
 add a', (ix)           ;; 03F2:  76 DD 86 00
 add a', (ix+127)       ;; 03F2:  76 DD 86 7F
 adc a', (ix+-128)      ;; 03F2:  76 DD 8E 80
 adc a', (ix)           ;; 03F2:  76 DD 8E 00
 adc a', (ix+127)       ;; 03F2:  76 DD 8E 7F
 sub a', (ix+-128)      ;; 03F2:  76 DD 96 80
 sub a', (ix)           ;; 03F2:  76 DD 96 00
 sub a', (ix+127)       ;; 03F2:  76 DD 96 7F
 sbc a', (ix+-128)      ;; 03F2:  76 DD 9E 80
 sbc a', (ix)           ;; 03F2:  76 DD 9E 00
 sbc a', (ix+127)       ;; 03F2:  76 DD 9E 7F
 and a', (ix+-128)      ;; 03F2:  76 DD A6 80
 and a', (ix)           ;; 03F2:  76 DD A6 00
 and a', (ix+127)       ;; 03F2:  76 DD A6 7F
 xor a', (ix+-128)      ;; 03F2:  76 DD AE 80
 xor a', (ix)           ;; 03F2:  76 DD AE 00
 xor a', (ix+127)       ;; 03F2:  76 DD AE 7F
 or a', (ix+-128)       ;; 03F2:  76 DD B6 80
 or a', (ix)            ;; 03F2:  76 DD B6 00
 or a', (ix+127)        ;; 03F2:  76 DD B6 7F
 add a', 0              ;; 03F2:  76 C6 00
 add a', 85             ;; 03F2:  76 C6 55
 add a', 170            ;; 03F2:  76 C6 AA
 add a', 255            ;; 03F2:  76 C6 FF
 adc a', 0              ;; 03F2:  76 CE 00
 adc a', 85             ;; 03F2:  76 CE 55
 adc a', 170            ;; 03F2:  76 CE AA
 adc a', 255            ;; 03F2:  76 CE FF
 sub a', 0              ;; 03F2:  76 D6 00
 sub a', 85             ;; 03F2:  76 D6 55
 sub a', 170            ;; 03F2:  76 D6 AA
 sub a', 255            ;; 03F2:  76 D6 FF
 sbc a', 0              ;; 03F2:  76 DE 00
 sbc a', 85             ;; 03F2:  76 DE 55
 sbc a', 170            ;; 03F2:  76 DE AA
 sbc a', 255            ;; 03F2:  76 DE FF
 and a', 0              ;; 03F2:  76 E6 00
 and a', 85             ;; 03F2:  76 E6 55
 and a', 170            ;; 03F2:  76 E6 AA
 and a', 255            ;; 03F2:  76 E6 FF
 xor a', 0              ;; 03F2:  76 EE 00
 xor a', 85             ;; 03F2:  76 EE 55
 xor a', 170            ;; 03F2:  76 EE AA
 xor a', 255            ;; 03F2:  76 EE FF
 or a', 0               ;; 03F2:  76 F6 00
 or a', 85              ;; 03F2:  76 F6 55
 or a', 170             ;; 03F2:  76 F6 AA
 or a', 255             ;; 03F2:  76 F6 FF
 inc b'                 ;; 0400:  76 04
 inc c'                 ;; 0400:  76 0C
 inc d'                 ;; 0400:  76 14
 inc e'                 ;; 0400:  76 1C
 inc h'                 ;; 0400:  76 24
 inc l'                 ;; 0400:  76 2C
 inc a'                 ;; 0400:  76 3C
 dec b'                 ;; 0400:  76 05
 dec c'                 ;; 0400:  76 0D
 dec d'                 ;; 0400:  76 15
 dec e'                 ;; 0400:  76 1D
 dec h'                 ;; 0400:  76 25
 dec l'                 ;; 0400:  76 2D
 dec a'                 ;; 0400:  76 3D
 inc ixh                ;; 0400:  DD 24
 inc ixl                ;; 0400:  DD 2C
 dec ixh                ;; 0400:  DD 25
 dec ixl                ;; 0400:  DD 2D
 inc iyh                ;; 0400:  FD 24
 inc iyl                ;; 0400:  FD 2C
 dec iyh                ;; 0400:  FD 25
 dec iyl                ;; 0400:  FD 2D
 cpl a'                 ;; 0460:  76 2F
 neg a'                 ;; 0464:  76 ED 44
 ccf'                   ;; 0465:  76 3F
 scf'                   ;; 0466:  76 37
 ld bc', 0              ;; 04AE:  76 01 00 00
 ld bc', 291            ;; 04AE:  76 01 23 01
 ld bc', 17767          ;; 04AE:  76 01 67 45
 ld bc', 35243          ;; 04AE:  76 01 AB 89
 ld bc', 52719          ;; 04AE:  76 01 EF CD
 ld bc', 65535          ;; 04AE:  76 01 FF FF
 ld de', 0              ;; 04AE:  76 11 00 00
 ld de', 291            ;; 04AE:  76 11 23 01
 ld de', 17767          ;; 04AE:  76 11 67 45
 ld de', 35243          ;; 04AE:  76 11 AB 89
 ld de', 52719          ;; 04AE:  76 11 EF CD
 ld de', 65535          ;; 04AE:  76 11 FF FF
 ld hl', 0              ;; 04AE:  76 21 00 00
 ld hl', 291            ;; 04AE:  76 21 23 01
 ld hl', 17767          ;; 04AE:  76 21 67 45
 ld hl', 35243          ;; 04AE:  76 21 AB 89
 ld hl', 52719          ;; 04AE:  76 21 EF CD
 ld hl', 65535          ;; 04AE:  76 21 FF FF
 ld hl', (0)            ;; 04F0:  76 2A 00 00
 ld hl', (291)          ;; 04F0:  76 2A 23 01
 ld hl', (17767)        ;; 04F0:  76 2A 67 45
 ld hl', (35243)        ;; 04F0:  76 2A AB 89
 ld hl', (52719)        ;; 04F0:  76 2A EF CD
 ld hl', (65535)        ;; 04F0:  76 2A FF FF
 ld bc', (0)            ;; 05AA:  76 ED 4B 00 00
 ld bc', (291)          ;; 05AA:  76 ED 4B 23 01
 ld bc', (17767)        ;; 05AA:  76 ED 4B 67 45
 ld bc', (35243)        ;; 05AA:  76 ED 4B AB 89
 ld bc', (52719)        ;; 05AA:  76 ED 4B EF CD
 ld bc', (65535)        ;; 05AA:  76 ED 4B FF FF
 ld de', (0)            ;; 05AA:  76 ED 5B 00 00
 ld de', (291)          ;; 05AA:  76 ED 5B 23 01
 ld de', (17767)        ;; 05AA:  76 ED 5B 67 45
 ld de', (35243)        ;; 05AA:  76 ED 5B AB 89
 ld de', (52719)        ;; 05AA:  76 ED 5B EF CD
 ld de', (65535)        ;; 05AA:  76 ED 5B FF FF
 push ip                ;; 05FF:  ED 76
 push su                ;; 05FF:  ED 66
 pop bc'                ;; 0603:  76 C1
 pop de'                ;; 0603:  76 D1
 pop hl'                ;; 0603:  76 E1
 pop af'                ;; 0603:  76 F1
 pop ip                 ;; 0607:  ED 7E
 pop su                 ;; 0607:  ED 6E
 ld hl, ix              ;; 0607:  DD 7C
 ld hl', ix             ;; 0607:  76 DD 7C
 ld hl, iy              ;; 0607:  FD 7C
 ld hl', iy             ;; 0607:  76 FD 7C
 ld ix, hl              ;; 0607:  DD 7D
 ld iy, hl              ;; 0607:  FD 7D
 ld hl, (hl + -128)     ;; 0607:  DD E4 80
 ld hl, (hl)            ;; 0607:  DD E4 00
 ld hl, (hl + 127)      ;; 0607:  DD E4 7F
 ld hl', (hl + -128)    ;; 0607:  76 DD E4 80
 ld hl', (hl)           ;; 0607:  76 DD E4 00
 ld hl', (hl + 127)     ;; 0607:  76 DD E4 7F
 ld hl, (ix + -128)     ;; 0607:  E4 80
 ld hl, (ix)            ;; 0607:  E4 00
 ld hl, (ix + 127)      ;; 0607:  E4 7F
 ld hl', (ix + -128)    ;; 0607:  76 E4 80
 ld hl', (ix)           ;; 0607:  76 E4 00
 ld hl', (ix + 127)     ;; 0607:  76 E4 7F
 ld hl, (iy + -128)     ;; 0607:  FD E4 80
 ld hl, (iy)            ;; 0607:  FD E4 00
 ld hl, (iy + 127)      ;; 0607:  FD E4 7F
 ld hl', (iy + -128)    ;; 0607:  76 FD E4 80
 ld hl', (iy)           ;; 0607:  76 FD E4 00
 ld hl', (iy + 127)     ;; 0607:  76 FD E4 7F
 ld (hl + -128), hl     ;; 0607:  DD F4 80
 ld (hl), hl            ;; 0607:  DD F4 00
 ld (hl + 127), hl      ;; 0607:  DD F4 7F
 ld (ix + -128), hl     ;; 0607:  F4 80
 ld (ix), hl            ;; 0607:  F4 00
 ld (ix + 127), hl      ;; 0607:  F4 7F
 ld (iy + -128), hl     ;; 0607:  FD F4 80
 ld (iy), hl            ;; 0607:  FD F4 00
 ld (iy + 127), hl      ;; 0607:  FD F4 7F
 ldp (0), hl            ;; 0607:  ED 65 00 00
 ldp (291), hl          ;; 0607:  ED 65 23 01
 ldp (17767), hl        ;; 0607:  ED 65 67 45
 ldp (35243), hl        ;; 0607:  ED 65 AB 89
 ldp (52719), hl        ;; 0607:  ED 65 EF CD
 ldp (65535), hl        ;; 0607:  ED 65 FF FF
 ldp (0), ix            ;; 0607:  DD 65 00 00
 ldp (291), ix          ;; 0607:  DD 65 23 01
 ldp (17767), ix        ;; 0607:  DD 65 67 45
 ldp (35243), ix        ;; 0607:  DD 65 AB 89
 ldp (52719), ix        ;; 0607:  DD 65 EF CD
 ldp (65535), ix        ;; 0607:  DD 65 FF FF
 ldp (0), iy            ;; 0607:  FD 65 00 00
 ldp (291), iy          ;; 0607:  FD 65 23 01
 ldp (17767), iy        ;; 0607:  FD 65 67 45
 ldp (35243), iy        ;; 0607:  FD 65 AB 89
 ldp (52719), iy        ;; 0607:  FD 65 EF CD
 ldp (65535), iy        ;; 0607:  FD 65 FF FF
 ldp hl, (0)            ;; 0607:  ED 6D 00 00
 ldp hl, (291)          ;; 0607:  ED 6D 23 01
 ldp hl, (17767)        ;; 0607:  ED 6D 67 45
 ldp hl, (35243)        ;; 0607:  ED 6D AB 89
 ldp hl, (52719)        ;; 0607:  ED 6D EF CD
 ldp hl, (65535)        ;; 0607:  ED 6D FF FF
 ldp ix, (0)            ;; 0607:  DD 6D 00 00
 ldp ix, (291)          ;; 0607:  DD 6D 23 01
 ldp ix, (17767)        ;; 0607:  DD 6D 67 45
 ldp ix, (35243)        ;; 0607:  DD 6D AB 89
 ldp ix, (52719)        ;; 0607:  DD 6D EF CD
 ldp ix, (65535)        ;; 0607:  DD 6D FF FF
 ldp iy, (0)            ;; 0607:  FD 6D 00 00
 ldp iy, (291)          ;; 0607:  FD 6D 23 01
 ldp iy, (17767)        ;; 0607:  FD 6D 67 45
 ldp iy, (35243)        ;; 0607:  FD 6D AB 89
 ldp iy, (52719)        ;; 0607:  FD 6D EF CD
 ldp iy, (65535)        ;; 0607:  FD 6D FF FF
 ldp (hl), hl           ;; 0607:  ED 64
 ldp (ix), hl           ;; 0607:  DD 64
 ldp (iy), hl           ;; 0607:  FD 64
 ldp hl, (hl)           ;; 0607:  ED 6C
 ldp hl, (ix)           ;; 0607:  DD 6C
 ldp hl, (iy)           ;; 0607:  FD 6C
 ld (sp), hl            ;; 0607:  D4 00
 ld (sp + 85), hl       ;; 0607:  D4 55
 ld (sp + 170), hl      ;; 0607:  D4 AA
 ld (sp + 255), hl      ;; 0607:  D4 FF
 ld (sp), ix            ;; 0607:  DD D4 00
 ld (sp + 85), ix       ;; 0607:  DD D4 55
 ld (sp + 170), ix      ;; 0607:  DD D4 AA
 ld (sp + 255), ix      ;; 0607:  DD D4 FF
 ld (sp), iy            ;; 0607:  FD D4 00
 ld (sp + 85), iy       ;; 0607:  FD D4 55
 ld (sp + 170), iy      ;; 0607:  FD D4 AA
 ld (sp + 255), iy      ;; 0607:  FD D4 FF
 ld hl, (sp)            ;; 0607:  C4 00
 ld hl, (sp + 85)       ;; 0607:  C4 55
 ld hl, (sp + 170)      ;; 0607:  C4 AA
 ld hl, (sp + 255)      ;; 0607:  C4 FF
 ld hl', (sp)           ;; 0607:  76 C4 00
 ld hl', (sp + 85)      ;; 0607:  76 C4 55
 ld hl', (sp + 170)     ;; 0607:  76 C4 AA
 ld hl', (sp + 255)     ;; 0607:  76 C4 FF
 ld ix, (sp)            ;; 0607:  DD C4 00
 ld ix, (sp + 85)       ;; 0607:  DD C4 55
 ld ix, (sp + 170)      ;; 0607:  DD C4 AA
 ld ix, (sp + 255)      ;; 0607:  DD C4 FF
 ld iy, (sp)            ;; 0607:  FD C4 00
 ld iy, (sp + 85)       ;; 0607:  FD C4 55
 ld iy, (sp + 170)      ;; 0607:  FD C4 AA
 ld iy, (sp + 255)      ;; 0607:  FD C4 FF
 ld bc', bc             ;; 0607:  ED 49
 ld bc', de             ;; 0607:  ED 41
 ld de', bc             ;; 0607:  ED 59
 ld de', de             ;; 0607:  ED 51
 ld hl', bc             ;; 0607:  ED 69
 ld hl', de             ;; 0607:  ED 61
 add hl', bc            ;; 060B:  76 09
 add hl', de            ;; 060B:  76 19
 add hl', hl            ;; 060B:  76 29
 add hl', sp            ;; 060B:  76 39
 sbc hl', bc            ;; 062B:  76 ED 42
 sbc hl', de            ;; 062B:  76 ED 52
 sbc hl', hl            ;; 062B:  76 ED 62
 sbc hl', sp            ;; 062B:  76 ED 72
 adc hl', bc            ;; 062B:  76 ED 4A
 adc hl', de            ;; 062B:  76 ED 5A
 adc hl', hl            ;; 062B:  76 ED 6A
 adc hl', sp            ;; 062B:  76 ED 7A
 inc bc'                ;; 0633:  76 03
 inc de'                ;; 0633:  76 13
 inc hl'                ;; 0633:  76 23
 dec bc'                ;; 0633:  76 0B
 dec de'                ;; 0633:  76 1B
 dec hl'                ;; 0633:  76 2B
 add sp, -128           ;; 063B:  27 80
 add sp, 0              ;; 063B:  27 00
 add sp, 127            ;; 063B:  27 7F
 and hl, de             ;; 063B:  DC
 or hl, de              ;; 063B:  EC
 and hl', de            ;; 063B:  76 DC
 or hl', de             ;; 063B:  76 EC
 and ix, de             ;; 063B:  DD DC
 or ix, de              ;; 063B:  DD EC
 and iy, de             ;; 063B:  FD DC
 or iy, de              ;; 063B:  FD EC
 bool hl                ;; 063B:  CC
 bool hl'               ;; 063B:  76 CC
 bool ix                ;; 063B:  DD CC
 bool iy                ;; 063B:  FD CC
 mul                    ;; 0643:  F7
 uma                    ;; 0643:  ED C0
 ums                    ;; 0643:  ED C8
 ex (sp), hl'           ;; 0647:  76 ED 54
 ex de', hl             ;; 064C:  E3
 ex de, hl'             ;; 064C:  76 EB
 ex de', hl'            ;; 064C:  76 E3
 rl de                  ;; 0790:  F3
 rr de                  ;; 0790:  FB
 rr hl                  ;; 0790:  FC
 rl de'                 ;; 0790:  76 F3
 rr de'                 ;; 0790:  76 FB
 rr hl'                 ;; 0790:  76 FC
 rr ix                  ;; 0790:  DD FC
 rr iy                  ;; 0790:  FD FC
 res 0, b'              ;; 0910:  76 CB 80
 res 0, c'              ;; 0910:  76 CB 81
 res 0, d'              ;; 0910:  76 CB 82
 res 0, e'              ;; 0910:  76 CB 83
 res 0, h'              ;; 0910:  76 CB 84
 res 0, l'              ;; 0910:  76 CB 85
 res 0, a'              ;; 0910:  76 CB 87
 res 1, b'              ;; 0910:  76 CB 88
 res 1, c'              ;; 0910:  76 CB 89
 res 1, d'              ;; 0910:  76 CB 8A
 res 1, e'              ;; 0910:  76 CB 8B
 res 1, h'              ;; 0910:  76 CB 8C
 res 1, l'              ;; 0910:  76 CB 8D
 res 1, a'              ;; 0910:  76 CB 8F
 res 2, b'              ;; 0910:  76 CB 90
 res 2, c'              ;; 0910:  76 CB 91
 res 2, d'              ;; 0910:  76 CB 92
 res 2, e'              ;; 0910:  76 CB 93
 res 2, h'              ;; 0910:  76 CB 94
 res 2, l'              ;; 0910:  76 CB 95
 res 2, a'              ;; 0910:  76 CB 97
 res 3, b'              ;; 0910:  76 CB 98
 res 3, c'              ;; 0910:  76 CB 99
 res 3, d'              ;; 0910:  76 CB 9A
 res 3, e'              ;; 0910:  76 CB 9B
 res 3, h'              ;; 0910:  76 CB 9C
 res 3, l'              ;; 0910:  76 CB 9D
 res 3, a'              ;; 0910:  76 CB 9F
 res 4, b'              ;; 0910:  76 CB A0
 res 4, c'              ;; 0910:  76 CB A1
 res 4, d'              ;; 0910:  76 CB A2
 res 4, e'              ;; 0910:  76 CB A3
 res 4, h'              ;; 0910:  76 CB A4
 res 4, l'              ;; 0910:  76 CB A5
 res 4, a'              ;; 0910:  76 CB A7
 res 5, b'              ;; 0910:  76 CB A8
 res 5, c'              ;; 0910:  76 CB A9
 res 5, d'              ;; 0910:  76 CB AA
 res 5, e'              ;; 0910:  76 CB AB
 res 5, h'              ;; 0910:  76 CB AC
 res 5, l'              ;; 0910:  76 CB AD
 res 5, a'              ;; 0910:  76 CB AF
 res 6, b'              ;; 0910:  76 CB B0
 res 6, c'              ;; 0910:  76 CB B1
 res 6, d'              ;; 0910:  76 CB B2
 res 6, e'              ;; 0910:  76 CB B3
 res 6, h'              ;; 0910:  76 CB B4
 res 6, l'              ;; 0910:  76 CB B5
 res 6, a'              ;; 0910:  76 CB B7
 res 7, b'              ;; 0910:  76 CB B8
 res 7, c'              ;; 0910:  76 CB B9
 res 7, d'              ;; 0910:  76 CB BA
 res 7, e'              ;; 0910:  76 CB BB
 res 7, h'              ;; 0910:  76 CB BC
 res 7, l'              ;; 0910:  76 CB BD
 res 7, a'              ;; 0910:  76 CB BF
 set 0, b'              ;; 0910:  76 CB C0
 set 0, c'              ;; 0910:  76 CB C1
 set 0, d'              ;; 0910:  76 CB C2
 set 0, e'              ;; 0910:  76 CB C3
 set 0, h'              ;; 0910:  76 CB C4
 set 0, l'              ;; 0910:  76 CB C5
 set 0, a'              ;; 0910:  76 CB C7
 set 1, b'              ;; 0910:  76 CB C8
 set 1, c'              ;; 0910:  76 CB C9
 set 1, d'              ;; 0910:  76 CB CA
 set 1, e'              ;; 0910:  76 CB CB
 set 1, h'              ;; 0910:  76 CB CC
 set 1, l'              ;; 0910:  76 CB CD
 set 1, a'              ;; 0910:  76 CB CF
 set 2, b'              ;; 0910:  76 CB D0
 set 2, c'              ;; 0910:  76 CB D1
 set 2, d'              ;; 0910:  76 CB D2
 set 2, e'              ;; 0910:  76 CB D3
 set 2, h'              ;; 0910:  76 CB D4
 set 2, l'              ;; 0910:  76 CB D5
 set 2, a'              ;; 0910:  76 CB D7
 set 3, b'              ;; 0910:  76 CB D8
 set 3, c'              ;; 0910:  76 CB D9
 set 3, d'              ;; 0910:  76 CB DA
 set 3, e'              ;; 0910:  76 CB DB
 set 3, h'              ;; 0910:  76 CB DC
 set 3, l'              ;; 0910:  76 CB DD
 set 3, a'              ;; 0910:  76 CB DF
 set 4, b'              ;; 0910:  76 CB E0
 set 4, c'              ;; 0910:  76 CB E1
 set 4, d'              ;; 0910:  76 CB E2
 set 4, e'              ;; 0910:  76 CB E3
 set 4, h'              ;; 0910:  76 CB E4
 set 4, l'              ;; 0910:  76 CB E5
 set 4, a'              ;; 0910:  76 CB E7
 set 5, b'              ;; 0910:  76 CB E8
 set 5, c'              ;; 0910:  76 CB E9
 set 5, d'              ;; 0910:  76 CB EA
 set 5, e'              ;; 0910:  76 CB EB
 set 5, h'              ;; 0910:  76 CB EC
 set 5, l'              ;; 0910:  76 CB ED
 set 5, a'              ;; 0910:  76 CB EF
 set 6, b'              ;; 0910:  76 CB F0
 set 6, c'              ;; 0910:  76 CB F1
 set 6, d'              ;; 0910:  76 CB F2
 set 6, e'              ;; 0910:  76 CB F3
 set 6, h'              ;; 0910:  76 CB F4
 set 6, l'              ;; 0910:  76 CB F5
 set 6, a'              ;; 0910:  76 CB F7
 set 7, b'              ;; 0910:  76 CB F8
 set 7, c'              ;; 0910:  76 CB F9
 set 7, d'              ;; 0910:  76 CB FA
 set 7, e'              ;; 0910:  76 CB FB
 set 7, h'              ;; 0910:  76 CB FC
 set 7, l'              ;; 0910:  76 CB FD
 set 7, a'              ;; 0910:  76 CB FF
 ldisr                  ;; 0B58:  ED 90
 lddsr                  ;; 0B58:  ED 98
 lsdr                   ;; 0B58:  ED F8
 lsir                   ;; 0B58:  ED F0
 lsddr                  ;; 0B58:  ED D8
 lsidr                  ;; 0B58:  ED D0
 ld a, xpc              ;; 0B5C:  ED 77
 ld a', xpc             ;; 0B5C:  76 ED 77
 ld xpc, a              ;; 0B5C:  ED 67
 rdmode                 ;; 0B5C:  ED 7F
 setusr                 ;; 0B5C:  ED 6F
 sures                  ;; 0B5C:  ED 7D
 syscall                ;; 0B5C:  ED 75
 jp lz, 0               ;; 0BFE:  E2 00 00
 jp lz, 291             ;; 0BFE:  E2 23 01
 jp lz, 17767           ;; 0BFE:  E2 67 45
 jp lz, 35243           ;; 0BFE:  E2 AB 89
 jp lz, 52719           ;; 0BFE:  E2 EF CD
 jp lz, 65535           ;; 0BFE:  E2 FF FF
 jp lo, 0               ;; 0BFE:  EA 00 00
 jp lo, 291             ;; 0BFE:  EA 23 01
 jp lo, 17767           ;; 0BFE:  EA 67 45
 jp lo, 35243           ;; 0BFE:  EA AB 89
 jp lo, 52719           ;; 0BFE:  EA EF CD
 jp lo, 65535           ;; 0BFE:  EA FF FF
 djnz b', ASMPC         ;; 0C07:  76 10 FE
 ret lz                 ;; 0C2C:  E0
 ret lo                 ;; 0C2C:  E8
 ipset 0                ;; 0D41:  ED 46
 ipset 1                ;; 0D41:  ED 56
 ipset 2                ;; 0D41:  ED 4E
 ipset 3                ;; 0D41:  ED 5E
 ipres                  ;; 0D41:  ED 5D
 ld iir, a              ;; 0D49:  ED 4F
 ld a, iir              ;; 0D49:  ED 5F
 ld a', iir             ;; 0D49:  76 ED 5F
 ld eir, a              ;; 0D49:  ED 47
 ld a, eir              ;; 0D49:  ED 57
 ld a', eir             ;; 0D49:  76 ED 57
 idet                   ;; 0D4D:  5B
