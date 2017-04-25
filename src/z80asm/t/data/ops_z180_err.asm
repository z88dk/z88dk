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
 ld b, ixh              ;; 0031:  DD 44
 ld b, ixl              ;; 0031:  DD 45
 ld c, ixh              ;; 0031:  DD 4C
 ld c, ixl              ;; 0031:  DD 4D
 ld d, ixh              ;; 0031:  DD 54
 ld d, ixl              ;; 0031:  DD 55
 ld e, ixh              ;; 0031:  DD 5C
 ld e, ixl              ;; 0031:  DD 5D
 ld ixh, ixh            ;; 0031:  DD 64
 ld ixh, ixl            ;; 0031:  DD 65
 ld ixl, ixh            ;; 0031:  DD 6C
 ld ixl, ixl            ;; 0031:  DD 6D
 ld a, ixh              ;; 0031:  DD 7C
 ld a, ixl              ;; 0031:  DD 7D
 ld b, iyh              ;; 0031:  FD 44
 ld b, iyl              ;; 0031:  FD 45
 ld c, iyh              ;; 0031:  FD 4C
 ld c, iyl              ;; 0031:  FD 4D
 ld d, iyh              ;; 0031:  FD 54
 ld d, iyl              ;; 0031:  FD 55
 ld e, iyh              ;; 0031:  FD 5C
 ld e, iyl              ;; 0031:  FD 5D
 ld iyh, iyh            ;; 0031:  FD 64
 ld iyh, iyl            ;; 0031:  FD 65
 ld iyl, iyh            ;; 0031:  FD 6C
 ld iyl, iyl            ;; 0031:  FD 6D
 ld a, iyh              ;; 0031:  FD 7C
 ld a, iyl              ;; 0031:  FD 7D
 ld ixh, 0              ;; 0069:  DD 26 00
 ld ixh, 85             ;; 0069:  DD 26 55
 ld ixh, 170            ;; 0069:  DD 26 AA
 ld ixh, 255            ;; 0069:  DD 26 FF
 ld ixl, 0              ;; 0069:  DD 2E 00
 ld ixl, 85             ;; 0069:  DD 2E 55
 ld ixl, 170            ;; 0069:  DD 2E AA
 ld ixl, 255            ;; 0069:  DD 2E FF
 ld iyh, 0              ;; 0069:  FD 26 00
 ld iyh, 85             ;; 0069:  FD 26 55
 ld iyh, 170            ;; 0069:  FD 26 AA
 ld iyh, 255            ;; 0069:  FD 26 FF
 ld iyl, 0              ;; 0069:  FD 2E 00
 ld iyl, 85             ;; 0069:  FD 2E 55
 ld iyl, 170            ;; 0069:  FD 2E AA
 ld iyl, 255            ;; 0069:  FD 2E FF
 ld b', (hl)            ;; 0070:  76 46
 ld c', (hl)            ;; 0070:  76 4E
 ld d', (hl)            ;; 0070:  76 56
 ld e', (hl)            ;; 0070:  76 5E
 ld h', (hl)            ;; 0070:  76 66
 ld l', (hl)            ;; 0070:  76 6E
 ld a', (hl)            ;; 0070:  76 7E
 ld b', (ix + -128)     ;; 00AF:  76 DD 46 80
 ld b', (ix + 0)        ;; 00AF:  76 DD 46 00
 ld b', (ix + 127)      ;; 00AF:  76 DD 46 7F
 ld c', (ix + -128)     ;; 00AF:  76 DD 4E 80
 ld c', (ix + 0)        ;; 00AF:  76 DD 4E 00
 ld c', (ix + 127)      ;; 00AF:  76 DD 4E 7F
 ld d', (ix + -128)     ;; 00AF:  76 DD 56 80
 ld d', (ix + 0)        ;; 00AF:  76 DD 56 00
 ld d', (ix + 127)      ;; 00AF:  76 DD 56 7F
 ld e', (ix + -128)     ;; 00AF:  76 DD 5E 80
 ld e', (ix + 0)        ;; 00AF:  76 DD 5E 00
 ld e', (ix + 127)      ;; 00AF:  76 DD 5E 7F
 ld h', (ix + -128)     ;; 00AF:  76 DD 66 80
 ld h', (ix + 0)        ;; 00AF:  76 DD 66 00
 ld h', (ix + 127)      ;; 00AF:  76 DD 66 7F
 ld l', (ix + -128)     ;; 00AF:  76 DD 6E 80
 ld l', (ix + 0)        ;; 00AF:  76 DD 6E 00
 ld l', (ix + 127)      ;; 00AF:  76 DD 6E 7F
 ld a', (ix + -128)     ;; 00AF:  76 DD 7E 80
 ld a', (ix + 0)        ;; 00AF:  76 DD 7E 00
 ld a', (ix + 127)      ;; 00AF:  76 DD 7E 7F
 ld b', (iy + -128)     ;; 00EE:  76 FD 46 80
 ld b', (iy + 0)        ;; 00EE:  76 FD 46 00
 ld b', (iy + 127)      ;; 00EE:  76 FD 46 7F
 ld c', (iy + -128)     ;; 00EE:  76 FD 4E 80
 ld c', (iy + 0)        ;; 00EE:  76 FD 4E 00
 ld c', (iy + 127)      ;; 00EE:  76 FD 4E 7F
 ld d', (iy + -128)     ;; 00EE:  76 FD 56 80
 ld d', (iy + 0)        ;; 00EE:  76 FD 56 00
 ld d', (iy + 127)      ;; 00EE:  76 FD 56 7F
 ld e', (iy + -128)     ;; 00EE:  76 FD 5E 80
 ld e', (iy + 0)        ;; 00EE:  76 FD 5E 00
 ld e', (iy + 127)      ;; 00EE:  76 FD 5E 7F
 ld h', (iy + -128)     ;; 00EE:  76 FD 66 80
 ld h', (iy + 0)        ;; 00EE:  76 FD 66 00
 ld h', (iy + 127)      ;; 00EE:  76 FD 66 7F
 ld l', (iy + -128)     ;; 00EE:  76 FD 6E 80
 ld l', (iy + 0)        ;; 00EE:  76 FD 6E 00
 ld l', (iy + 127)      ;; 00EE:  76 FD 6E 7F
 ld a', (iy + -128)     ;; 00EE:  76 FD 7E 80
 ld a', (iy + 0)        ;; 00EE:  76 FD 7E 00
 ld a', (iy + 127)      ;; 00EE:  76 FD 7E 7F
 ld a', (bc)            ;; 01DD:  76 0A
 ld a', (de)            ;; 01DD:  76 1A
 ld a', (0)             ;; 01F1:  76 3A 00 00
 ld a', (291)           ;; 01F1:  76 3A 23 01
 ld a', (17767)         ;; 01F1:  76 3A 67 45
 ld a', (35243)         ;; 01F1:  76 3A AB 89
 ld a', (52719)         ;; 01F1:  76 3A EF CD
 ld a', (65535)         ;; 01F1:  76 3A FF FF
 add a, ixh             ;; 03A3:  DD 84
 add a, ixl             ;; 03A3:  DD 85
 adc a, ixh             ;; 03A3:  DD 8C
 adc a, ixl             ;; 03A3:  DD 8D
 sub a, ixh             ;; 03A3:  DD 94
 sub a, ixl             ;; 03A3:  DD 95
 sbc a, ixh             ;; 03A3:  DD 9C
 sbc a, ixl             ;; 03A3:  DD 9D
 and a, ixh             ;; 03A3:  DD A4
 and a, ixl             ;; 03A3:  DD A5
 xor a, ixh             ;; 03A3:  DD AC
 xor a, ixl             ;; 03A3:  DD AD
 or a, ixh              ;; 03A3:  DD B4
 or a, ixl              ;; 03A3:  DD B5
 cp a, ixh              ;; 03A3:  DD BC
 cp a, ixl              ;; 03A3:  DD BD
 add ixh                ;; 03A3:  DD 84
 add ixl                ;; 03A3:  DD 85
 adc ixh                ;; 03A3:  DD 8C
 adc ixl                ;; 03A3:  DD 8D
 sub ixh                ;; 03A3:  DD 94
 sub ixl                ;; 03A3:  DD 95
 sbc ixh                ;; 03A3:  DD 9C
 sbc ixl                ;; 03A3:  DD 9D
 and ixh                ;; 03A3:  DD A4
 and ixl                ;; 03A3:  DD A5
 xor ixh                ;; 03A3:  DD AC
 xor ixl                ;; 03A3:  DD AD
 or ixh                 ;; 03A3:  DD B4
 or ixl                 ;; 03A3:  DD B5
 cp ixh                 ;; 03A3:  DD BC
 cp ixl                 ;; 03A3:  DD BD
 add a, iyh             ;; 03A3:  FD 84
 add a, iyl             ;; 03A3:  FD 85
 adc a, iyh             ;; 03A3:  FD 8C
 adc a, iyl             ;; 03A3:  FD 8D
 sub a, iyh             ;; 03A3:  FD 94
 sub a, iyl             ;; 03A3:  FD 95
 sbc a, iyh             ;; 03A3:  FD 9C
 sbc a, iyl             ;; 03A3:  FD 9D
 and a, iyh             ;; 03A3:  FD A4
 and a, iyl             ;; 03A3:  FD A5
 xor a, iyh             ;; 03A3:  FD AC
 xor a, iyl             ;; 03A3:  FD AD
 or a, iyh              ;; 03A3:  FD B4
 or a, iyl              ;; 03A3:  FD B5
 cp a, iyh              ;; 03A3:  FD BC
 cp a, iyl              ;; 03A3:  FD BD
 add iyh                ;; 03A3:  FD 84
 add iyl                ;; 03A3:  FD 85
 adc iyh                ;; 03A3:  FD 8C
 adc iyl                ;; 03A3:  FD 8D
 sub iyh                ;; 03A3:  FD 94
 sub iyl                ;; 03A3:  FD 95
 sbc iyh                ;; 03A3:  FD 9C
 sbc iyl                ;; 03A3:  FD 9D
 and iyh                ;; 03A3:  FD A4
 and iyl                ;; 03A3:  FD A5
 xor iyh                ;; 03A3:  FD AC
 xor iyl                ;; 03A3:  FD AD
 or iyh                 ;; 03A3:  FD B4
 or iyl                 ;; 03A3:  FD B5
 cp iyh                 ;; 03A3:  FD BC
 cp iyl                 ;; 03A3:  FD BD
 add a', b              ;; 0423:  76 80
 add a', c              ;; 0423:  76 81
 add a', d              ;; 0423:  76 82
 add a', e              ;; 0423:  76 83
 add a', h              ;; 0423:  76 84
 add a', l              ;; 0423:  76 85
 add a', (hl)           ;; 0423:  76 86
 add a', a              ;; 0423:  76 87
 adc a', b              ;; 0423:  76 88
 adc a', c              ;; 0423:  76 89
 adc a', d              ;; 0423:  76 8A
 adc a', e              ;; 0423:  76 8B
 adc a', h              ;; 0423:  76 8C
 adc a', l              ;; 0423:  76 8D
 adc a', (hl)           ;; 0423:  76 8E
 adc a', a              ;; 0423:  76 8F
 sub a', b              ;; 0423:  76 90
 sub a', c              ;; 0423:  76 91
 sub a', d              ;; 0423:  76 92
 sub a', e              ;; 0423:  76 93
 sub a', h              ;; 0423:  76 94
 sub a', l              ;; 0423:  76 95
 sub a', (hl)           ;; 0423:  76 96
 sub a', a              ;; 0423:  76 97
 sbc a', b              ;; 0423:  76 98
 sbc a', c              ;; 0423:  76 99
 sbc a', d              ;; 0423:  76 9A
 sbc a', e              ;; 0423:  76 9B
 sbc a', h              ;; 0423:  76 9C
 sbc a', l              ;; 0423:  76 9D
 sbc a', (hl)           ;; 0423:  76 9E
 sbc a', a              ;; 0423:  76 9F
 and a', b              ;; 0423:  76 A0
 and a', c              ;; 0423:  76 A1
 and a', d              ;; 0423:  76 A2
 and a', e              ;; 0423:  76 A3
 and a', h              ;; 0423:  76 A4
 and a', l              ;; 0423:  76 A5
 and a', (hl)           ;; 0423:  76 A6
 and a', a              ;; 0423:  76 A7
 xor a', b              ;; 0423:  76 A8
 xor a', c              ;; 0423:  76 A9
 xor a', d              ;; 0423:  76 AA
 xor a', e              ;; 0423:  76 AB
 xor a', h              ;; 0423:  76 AC
 xor a', l              ;; 0423:  76 AD
 xor a', (hl)           ;; 0423:  76 AE
 xor a', a              ;; 0423:  76 AF
 or a', b               ;; 0423:  76 B0
 or a', c               ;; 0423:  76 B1
 or a', d               ;; 0423:  76 B2
 or a', e               ;; 0423:  76 B3
 or a', h               ;; 0423:  76 B4
 or a', l               ;; 0423:  76 B5
 or a', (hl)            ;; 0423:  76 B6
 or a', a               ;; 0423:  76 B7
 add a', (ix+-128)      ;; 0423:  76 DD 86 80
 add a', (ix+0)         ;; 0423:  76 DD 86 00
 add a', (ix+127)       ;; 0423:  76 DD 86 7F
 adc a', (ix+-128)      ;; 0423:  76 DD 8E 80
 adc a', (ix+0)         ;; 0423:  76 DD 8E 00
 adc a', (ix+127)       ;; 0423:  76 DD 8E 7F
 sub a', (ix+-128)      ;; 0423:  76 DD 96 80
 sub a', (ix+0)         ;; 0423:  76 DD 96 00
 sub a', (ix+127)       ;; 0423:  76 DD 96 7F
 sbc a', (ix+-128)      ;; 0423:  76 DD 9E 80
 sbc a', (ix+0)         ;; 0423:  76 DD 9E 00
 sbc a', (ix+127)       ;; 0423:  76 DD 9E 7F
 and a', (ix+-128)      ;; 0423:  76 DD A6 80
 and a', (ix+0)         ;; 0423:  76 DD A6 00
 and a', (ix+127)       ;; 0423:  76 DD A6 7F
 xor a', (ix+-128)      ;; 0423:  76 DD AE 80
 xor a', (ix+0)         ;; 0423:  76 DD AE 00
 xor a', (ix+127)       ;; 0423:  76 DD AE 7F
 or a', (ix+-128)       ;; 0423:  76 DD B6 80
 or a', (ix+0)          ;; 0423:  76 DD B6 00
 or a', (ix+127)        ;; 0423:  76 DD B6 7F
 add a', 0              ;; 0423:  76 C6 00
 add a', 85             ;; 0423:  76 C6 55
 add a', 170            ;; 0423:  76 C6 AA
 add a', 255            ;; 0423:  76 C6 FF
 adc a', 0              ;; 0423:  76 CE 00
 adc a', 85             ;; 0423:  76 CE 55
 adc a', 170            ;; 0423:  76 CE AA
 adc a', 255            ;; 0423:  76 CE FF
 sub a', 0              ;; 0423:  76 D6 00
 sub a', 85             ;; 0423:  76 D6 55
 sub a', 170            ;; 0423:  76 D6 AA
 sub a', 255            ;; 0423:  76 D6 FF
 sbc a', 0              ;; 0423:  76 DE 00
 sbc a', 85             ;; 0423:  76 DE 55
 sbc a', 170            ;; 0423:  76 DE AA
 sbc a', 255            ;; 0423:  76 DE FF
 and a', 0              ;; 0423:  76 E6 00
 and a', 85             ;; 0423:  76 E6 55
 and a', 170            ;; 0423:  76 E6 AA
 and a', 255            ;; 0423:  76 E6 FF
 xor a', 0              ;; 0423:  76 EE 00
 xor a', 85             ;; 0423:  76 EE 55
 xor a', 170            ;; 0423:  76 EE AA
 xor a', 255            ;; 0423:  76 EE FF
 or a', 0               ;; 0423:  76 F6 00
 or a', 85              ;; 0423:  76 F6 55
 or a', 170             ;; 0423:  76 F6 AA
 or a', 255             ;; 0423:  76 F6 FF
 inc b'                 ;; 0431:  76 04
 inc c'                 ;; 0431:  76 0C
 inc d'                 ;; 0431:  76 14
 inc e'                 ;; 0431:  76 1C
 inc h'                 ;; 0431:  76 24
 inc l'                 ;; 0431:  76 2C
 inc a'                 ;; 0431:  76 3C
 dec b'                 ;; 0431:  76 05
 dec c'                 ;; 0431:  76 0D
 dec d'                 ;; 0431:  76 15
 dec e'                 ;; 0431:  76 1D
 dec h'                 ;; 0431:  76 25
 dec l'                 ;; 0431:  76 2D
 dec a'                 ;; 0431:  76 3D
 inc ixh                ;; 0431:  DD 24
 inc ixl                ;; 0431:  DD 2C
 dec ixh                ;; 0431:  DD 25
 dec ixl                ;; 0431:  DD 2D
 inc iyh                ;; 0431:  FD 24
 inc iyl                ;; 0431:  FD 2C
 dec iyh                ;; 0431:  FD 25
 dec iyl                ;; 0431:  FD 2D
 cpl a'                 ;; 0496:  76 2F
 ld bc', 0              ;; 04E2:  76 01 00 00
 ld bc', 291            ;; 04E2:  76 01 23 01
 ld bc', 17767          ;; 04E2:  76 01 67 45
 ld bc', 35243          ;; 04E2:  76 01 AB 89
 ld bc', 52719          ;; 04E2:  76 01 EF CD
 ld bc', 65535          ;; 04E2:  76 01 FF FF
 ld de', 0              ;; 04E2:  76 11 00 00
 ld de', 291            ;; 04E2:  76 11 23 01
 ld de', 17767          ;; 04E2:  76 11 67 45
 ld de', 35243          ;; 04E2:  76 11 AB 89
 ld de', 52719          ;; 04E2:  76 11 EF CD
 ld de', 65535          ;; 04E2:  76 11 FF FF
 ld hl', 0              ;; 04E2:  76 21 00 00
 ld hl', 291            ;; 04E2:  76 21 23 01
 ld hl', 17767          ;; 04E2:  76 21 67 45
 ld hl', 35243          ;; 04E2:  76 21 AB 89
 ld hl', 52719          ;; 04E2:  76 21 EF CD
 ld hl', 65535          ;; 04E2:  76 21 FF FF
 ld hl', (0)            ;; 0524:  76 2A 00 00
 ld hl', (291)          ;; 0524:  76 2A 23 01
 ld hl', (17767)        ;; 0524:  76 2A 67 45
 ld hl', (35243)        ;; 0524:  76 2A AB 89
 ld hl', (52719)        ;; 0524:  76 2A EF CD
 ld hl', (65535)        ;; 0524:  76 2A FF FF
 ld bc', (0)            ;; 05DE:  76 ED 4B 00 00
 ld bc', (291)          ;; 05DE:  76 ED 4B 23 01
 ld bc', (17767)        ;; 05DE:  76 ED 4B 67 45
 ld bc', (35243)        ;; 05DE:  76 ED 4B AB 89
 ld bc', (52719)        ;; 05DE:  76 ED 4B EF CD
 ld bc', (65535)        ;; 05DE:  76 ED 4B FF FF
 ld de', (0)            ;; 05DE:  76 ED 5B 00 00
 ld de', (291)          ;; 05DE:  76 ED 5B 23 01
 ld de', (17767)        ;; 05DE:  76 ED 5B 67 45
 ld de', (35243)        ;; 05DE:  76 ED 5B AB 89
 ld de', (52719)        ;; 05DE:  76 ED 5B EF CD
 ld de', (65535)        ;; 05DE:  76 ED 5B FF FF
 push ip                ;; 0633:  ED 76
 push su                ;; 0633:  ED 66
 pop ip                 ;; 063B:  ED 7E
 pop su                 ;; 063B:  ED 6E
 ld hl, ix              ;; 063B:  DD 7C
 ld hl', ix             ;; 063B:  76 DD 7C
 ld hl, iy              ;; 063B:  FD 7C
 ld hl', iy             ;; 063B:  76 FD 7C
 ld ix, hl              ;; 063B:  DD 7D
 ld iy, hl              ;; 063B:  FD 7D
 ld hl, (hl + -128)     ;; 063B:  DD E4 80
 ld hl, (hl + 0)        ;; 063B:  DD E4 00
 ld hl, (hl + 127)      ;; 063B:  DD E4 7F
 ld hl', (hl + -128)    ;; 063B:  76 DD E4 80
 ld hl', (hl + 0)       ;; 063B:  76 DD E4 00
 ld hl', (hl + 127)     ;; 063B:  76 DD E4 7F
 ld hl, (ix + -128)     ;; 063B:  E4 80
 ld hl, (ix + 0)        ;; 063B:  E4 00
 ld hl, (ix + 127)      ;; 063B:  E4 7F
 ld hl', (ix + -128)    ;; 063B:  76 E4 80
 ld hl', (ix + 0)       ;; 063B:  76 E4 00
 ld hl', (ix + 127)     ;; 063B:  76 E4 7F
 ld hl, (iy + -128)     ;; 063B:  FD E4 80
 ld hl, (iy + 0)        ;; 063B:  FD E4 00
 ld hl, (iy + 127)      ;; 063B:  FD E4 7F
 ld hl', (iy + -128)    ;; 063B:  76 FD E4 80
 ld hl', (iy + 0)       ;; 063B:  76 FD E4 00
 ld hl', (iy + 127)     ;; 063B:  76 FD E4 7F
 ld (hl + -128), hl     ;; 063B:  DD F4 80
 ld (hl + 0), hl        ;; 063B:  DD F4 00
 ld (hl + 127), hl      ;; 063B:  DD F4 7F
 ld (ix + -128), hl     ;; 063B:  F4 80
 ld (ix + 0), hl        ;; 063B:  F4 00
 ld (ix + 127), hl      ;; 063B:  F4 7F
 ld (iy + -128), hl     ;; 063B:  FD F4 80
 ld (iy + 0), hl        ;; 063B:  FD F4 00
 ld (iy + 127), hl      ;; 063B:  FD F4 7F
 ldp (0), hl            ;; 063B:  ED 65 00 00
 ldp (291), hl          ;; 063B:  ED 65 23 01
 ldp (17767), hl        ;; 063B:  ED 65 67 45
 ldp (35243), hl        ;; 063B:  ED 65 AB 89
 ldp (52719), hl        ;; 063B:  ED 65 EF CD
 ldp (65535), hl        ;; 063B:  ED 65 FF FF
 ldp (0), ix            ;; 063B:  DD 65 00 00
 ldp (291), ix          ;; 063B:  DD 65 23 01
 ldp (17767), ix        ;; 063B:  DD 65 67 45
 ldp (35243), ix        ;; 063B:  DD 65 AB 89
 ldp (52719), ix        ;; 063B:  DD 65 EF CD
 ldp (65535), ix        ;; 063B:  DD 65 FF FF
 ldp (0), iy            ;; 063B:  FD 65 00 00
 ldp (291), iy          ;; 063B:  FD 65 23 01
 ldp (17767), iy        ;; 063B:  FD 65 67 45
 ldp (35243), iy        ;; 063B:  FD 65 AB 89
 ldp (52719), iy        ;; 063B:  FD 65 EF CD
 ldp (65535), iy        ;; 063B:  FD 65 FF FF
 ldp hl, (0)            ;; 063B:  ED 6D 00 00
 ldp hl, (291)          ;; 063B:  ED 6D 23 01
 ldp hl, (17767)        ;; 063B:  ED 6D 67 45
 ldp hl, (35243)        ;; 063B:  ED 6D AB 89
 ldp hl, (52719)        ;; 063B:  ED 6D EF CD
 ldp hl, (65535)        ;; 063B:  ED 6D FF FF
 ldp ix, (0)            ;; 063B:  DD 6D 00 00
 ldp ix, (291)          ;; 063B:  DD 6D 23 01
 ldp ix, (17767)        ;; 063B:  DD 6D 67 45
 ldp ix, (35243)        ;; 063B:  DD 6D AB 89
 ldp ix, (52719)        ;; 063B:  DD 6D EF CD
 ldp ix, (65535)        ;; 063B:  DD 6D FF FF
 ldp iy, (0)            ;; 063B:  FD 6D 00 00
 ldp iy, (291)          ;; 063B:  FD 6D 23 01
 ldp iy, (17767)        ;; 063B:  FD 6D 67 45
 ldp iy, (35243)        ;; 063B:  FD 6D AB 89
 ldp iy, (52719)        ;; 063B:  FD 6D EF CD
 ldp iy, (65535)        ;; 063B:  FD 6D FF FF
 ldp (hl), hl           ;; 063B:  ED 64
 ldp (ix), hl           ;; 063B:  DD 64
 ldp (iy), hl           ;; 063B:  FD 64
 ldp hl, (hl)           ;; 063B:  ED 6C
 ldp hl, (ix)           ;; 063B:  DD 6C
 ldp hl, (iy)           ;; 063B:  FD 6C
 ld (sp + 0), hl        ;; 063B:  D4 00
 ld (sp + 85), hl       ;; 063B:  D4 55
 ld (sp + 170), hl      ;; 063B:  D4 AA
 ld (sp + 255), hl      ;; 063B:  D4 FF
 ld (sp + 0), ix        ;; 063B:  DD D4 00
 ld (sp + 85), ix       ;; 063B:  DD D4 55
 ld (sp + 170), ix      ;; 063B:  DD D4 AA
 ld (sp + 255), ix      ;; 063B:  DD D4 FF
 ld (sp + 0), iy        ;; 063B:  FD D4 00
 ld (sp + 85), iy       ;; 063B:  FD D4 55
 ld (sp + 170), iy      ;; 063B:  FD D4 AA
 ld (sp + 255), iy      ;; 063B:  FD D4 FF
 ld hl, (sp + 0)        ;; 063B:  C4 00
 ld hl, (sp + 85)       ;; 063B:  C4 55
 ld hl, (sp + 170)      ;; 063B:  C4 AA
 ld hl, (sp + 255)      ;; 063B:  C4 FF
 ld hl', (sp + 0)       ;; 063B:  76 C4 00
 ld hl', (sp + 85)      ;; 063B:  76 C4 55
 ld hl', (sp + 170)     ;; 063B:  76 C4 AA
 ld hl', (sp + 255)     ;; 063B:  76 C4 FF
 ld ix, (sp + 0)        ;; 063B:  DD C4 00
 ld ix, (sp + 85)       ;; 063B:  DD C4 55
 ld ix, (sp + 170)      ;; 063B:  DD C4 AA
 ld ix, (sp + 255)      ;; 063B:  DD C4 FF
 ld iy, (sp + 0)        ;; 063B:  FD C4 00
 ld iy, (sp + 85)       ;; 063B:  FD C4 55
 ld iy, (sp + 170)      ;; 063B:  FD C4 AA
 ld iy, (sp + 255)      ;; 063B:  FD C4 FF
 ld bc', bc             ;; 063B:  ED 49
 ld bc', de             ;; 063B:  ED 41
 ld de', bc             ;; 063B:  ED 59
 ld de', de             ;; 063B:  ED 51
 ld hl', bc             ;; 063B:  ED 69
 ld hl', de             ;; 063B:  ED 61
 add hl', bc            ;; 063F:  76 09
 add hl', de            ;; 063F:  76 19
 add hl', hl            ;; 063F:  76 29
 add hl', sp            ;; 063F:  76 39
 sbc hl', bc            ;; 065F:  76 ED 42
 sbc hl', de            ;; 065F:  76 ED 52
 sbc hl', hl            ;; 065F:  76 ED 62
 sbc hl', sp            ;; 065F:  76 ED 72
 adc hl', bc            ;; 065F:  76 ED 4A
 adc hl', de            ;; 065F:  76 ED 5A
 adc hl', hl            ;; 065F:  76 ED 6A
 adc hl', sp            ;; 065F:  76 ED 7A
 inc bc'                ;; 0667:  76 03
 inc de'                ;; 0667:  76 13
 inc hl'                ;; 0667:  76 23
 dec bc'                ;; 0667:  76 0B
 dec de'                ;; 0667:  76 1B
 dec hl'                ;; 0667:  76 2B
 add sp, -128           ;; 066F:  27 80
 add sp, 0              ;; 066F:  27 00
 add sp, 127            ;; 066F:  27 7F
 and hl, de             ;; 066F:  DC
 or hl, de              ;; 066F:  EC
 and hl', de            ;; 066F:  76 DC
 or hl', de             ;; 066F:  76 EC
 and ix, de             ;; 066F:  DD DC
 or ix, de              ;; 066F:  DD EC
 and iy, de             ;; 066F:  FD DC
 or iy, de              ;; 066F:  FD EC
 bool hl                ;; 066F:  CC
 bool hl'               ;; 066F:  76 CC
 bool ix                ;; 066F:  DD CC
 bool iy                ;; 066F:  FD CC
 mul                    ;; 0677:  F7
 uma                    ;; 0677:  ED C0
 ums                    ;; 0677:  ED C8
 ex (sp), hl'           ;; 067B:  76 ED 54
 ex de', hl             ;; 0680:  E3
 ex de, hl'             ;; 0680:  76 EB
 ex de', hl'            ;; 0680:  76 E3
 rl de                  ;; 07C4:  F3
 rr de                  ;; 07C4:  FB
 rr hl                  ;; 07C4:  FC
 rr ix                  ;; 07C4:  DD FC
 rr iy                  ;; 07C4:  FD FC
 ldisr                  ;; 0B8C:  ED 90
 lddsr                  ;; 0B8C:  ED 98
 lsdr                   ;; 0B8C:  ED F8
 lsir                   ;; 0B8C:  ED F0
 lsddr                  ;; 0B8C:  ED D8
 lsidr                  ;; 0B8C:  ED D0
 altd                   ;; 0B98:  76
 ld a, xpc              ;; 0B98:  ED 77
 ld a', xpc             ;; 0B98:  76 ED 77
 ld xpc, a              ;; 0B98:  ED 67
 rdmode                 ;; 0B98:  ED 7F
 setusr                 ;; 0B98:  ED 6F
 sures                  ;; 0B98:  ED 7D
 syscall                ;; 0B98:  ED 75
 jp lz, 0               ;; 0C3A:  E2 00 00
 jp lz, 291             ;; 0C3A:  E2 23 01
 jp lz, 17767           ;; 0C3A:  E2 67 45
 jp lz, 35243           ;; 0C3A:  E2 AB 89
 jp lz, 52719           ;; 0C3A:  E2 EF CD
 jp lz, 65535           ;; 0C3A:  E2 FF FF
 jp lo, 0               ;; 0C3A:  EA 00 00
 jp lo, 291             ;; 0C3A:  EA 23 01
 jp lo, 17767           ;; 0C3A:  EA 67 45
 jp lo, 35243           ;; 0C3A:  EA AB 89
 jp lo, 52719           ;; 0C3A:  EA EF CD
 jp lo, 65535           ;; 0C3A:  EA FF FF
 djnz b', ASMPC         ;; 0C43:  76 10 FE
 ret lz                 ;; 0CF8:  E0
 ret lo                 ;; 0CF8:  E8
 ioe                    ;; 0DF0:  DB
 ioi                    ;; 0DF0:  D3
 ipset 0                ;; 0E10:  ED 46
 ipset 1                ;; 0E10:  ED 56
 ipset 2                ;; 0E10:  ED 4E
 ipset 3                ;; 0E10:  ED 5E
 ipres                  ;; 0E10:  ED 5D
 ld iir, a              ;; 0E18:  ED 4F
 ld a, iir              ;; 0E18:  ED 5F
 ld a', iir             ;; 0E18:  76 ED 5F
 ld eir, a              ;; 0E18:  ED 47
 ld a, eir              ;; 0E18:  ED 57
 ld a', eir             ;; 0E18:  76 ED 57
 idet                   ;; 0E1C:  5B
