 adc (42)               ;; CE 2A
 adc (hl)               ;; 8E
 adc (ix)               ;; DD 8E 00
 adc (ix+127)           ;; DD 8E 7F
 adc (iy)               ;; FD 8E 00
 adc (iy+127)           ;; FD 8E 7F
 adc 42                 ;; CE 2A
 adc a                  ;; 8F
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
 adc a, ixh             ;; DD 8C
 adc a, ixl             ;; DD 8D
 adc a, iyh             ;; FD 8C
 adc a, iyl             ;; FD 8D
 adc a, l               ;; 8D
 adc b                  ;; 88
 adc c                  ;; 89
 adc d                  ;; 8A
 adc e                  ;; 8B
 adc h                  ;; 8C
 adc ixh                ;; DD 8C
 adc ixl                ;; DD 8D
 adc iyh                ;; FD 8C
 adc iyl                ;; FD 8D
 adc l                  ;; 8D
 add (42)               ;; C6 2A
 add (hl)               ;; 86
 add (ix)               ;; DD 86 00
 add (ix+127)           ;; DD 86 7F
 add (iy)               ;; FD 86 00
 add (iy+127)           ;; FD 86 7F
 add 42                 ;; C6 2A
 add a                  ;; 87
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
 add a, ixh             ;; DD 84
 add a, ixl             ;; DD 85
 add a, iyh             ;; FD 84
 add a, iyl             ;; FD 85
 add a, l               ;; 85
 add b                  ;; 80
 add c                  ;; 81
 add d                  ;; 82
 add e                  ;; 83
 add h                  ;; 84
 add ixh                ;; DD 84
 add ixl                ;; DD 85
 add iyh                ;; FD 84
 add iyl                ;; FD 85
 add l                  ;; 85
 and (42)               ;; E6 2A
 and (hl)               ;; A6
 and (ix)               ;; DD A6 00
 and (ix+127)           ;; DD A6 7F
 and (iy)               ;; FD A6 00
 and (iy+127)           ;; FD A6 7F
 and 42                 ;; E6 2A
 and a                  ;; A7
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
 and a, ixh             ;; DD A4
 and a, ixl             ;; DD A5
 and a, iyh             ;; FD A4
 and a, iyl             ;; FD A5
 and a, l               ;; A5
 and b                  ;; A0
 and c                  ;; A1
 and d                  ;; A2
 and e                  ;; A3
 and h                  ;; A4
 and ixh                ;; DD A4
 and ixl                ;; DD A5
 and iyh                ;; FD A4
 and iyl                ;; FD A5
 and l                  ;; A5
 ccf                    ;; 3F
 ccf f                  ;; 3F
 cp (42)                ;; FE 2A
 cp (hl)                ;; BE
 cp (ix)                ;; DD BE 00
 cp (ix+127)            ;; DD BE 7F
 cp (iy)                ;; FD BE 00
 cp (iy+127)            ;; FD BE 7F
 cp 42                  ;; FE 2A
 cp a                   ;; BF
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
 cp a, ixh              ;; DD BC
 cp a, ixl              ;; DD BD
 cp a, iyh              ;; FD BC
 cp a, iyl              ;; FD BD
 cp a, l                ;; BD
 cp b                   ;; B8
 cp c                   ;; B9
 cp d                   ;; BA
 cp e                   ;; BB
 cp h                   ;; BC
 cp ixh                 ;; DD BC
 cp ixl                 ;; DD BD
 cp iyh                 ;; FD BC
 cp iyl                 ;; FD BD
 cp l                   ;; BD
 cpl                    ;; 2F
 cpl a                  ;; 2F
 daa                    ;; 27
 dec (hl)               ;; 35
 dec (ix)               ;; DD 35 00
 dec (ix+127)           ;; DD 35 7F
 dec (iy)               ;; FD 35 00
 dec (iy+127)           ;; FD 35 7F
 dec a                  ;; 3D
 dec b                  ;; 05
 dec c                  ;; 0D
 dec d                  ;; 15
 dec e                  ;; 1D
 dec h                  ;; 25
 dec ixh                ;; DD 25
 dec ixl                ;; DD 2D
 dec iyh                ;; FD 25
 dec iyl                ;; FD 2D
 dec l                  ;; 2D
 inc (hl)               ;; 34
 inc (ix)               ;; DD 34 00
 inc (ix+127)           ;; DD 34 7F
 inc (iy)               ;; FD 34 00
 inc (iy+127)           ;; FD 34 7F
 inc a                  ;; 3C
 inc b                  ;; 04
 inc c                  ;; 0C
 inc d                  ;; 14
 inc e                  ;; 1C
 inc h                  ;; 24
 inc ixh                ;; DD 24
 inc ixl                ;; DD 2C
 inc iyh                ;; FD 24
 inc iyl                ;; FD 2C
 inc l                  ;; 2C
 ld (4660), bc          ;; ED 43 34 12
 ld (4660), de          ;; ED 53 34 12
 ld (4660), hl          ;; 22 34 12
 ld (4660), ix          ;; DD 22 34 12
 ld (4660), iy          ;; FD 22 34 12
 ld (4660), sp          ;; ED 73 34 12
 ld bc, (4660)          ;; ED 4B 34 12
 ld bc, 4660            ;; 01 34 12
 ld de, (4660)          ;; ED 5B 34 12
 ld de, 4660            ;; 11 34 12
 ld hl, (4660)          ;; 2A 34 12
 ld hl, 4660            ;; 21 34 12
 ld ix, (4660)          ;; DD 2A 34 12
 ld ix, 4660            ;; DD 21 34 12
 ld iy, (4660)          ;; FD 2A 34 12
 ld iy, 4660            ;; FD 21 34 12
 ld sp, (4660)          ;; ED 7B 34 12
 ld sp, 4660            ;; 31 34 12
 ld sp, hl              ;; F9
 ld sp, ix              ;; DD F9
 ld sp, iy              ;; FD F9
 neg                    ;; ED 44
 neg a                  ;; ED 44
 or (42)                ;; F6 2A
 or (hl)                ;; B6
 or (ix)                ;; DD B6 00
 or (ix+127)            ;; DD B6 7F
 or (iy)                ;; FD B6 00
 or (iy+127)            ;; FD B6 7F
 or 42                  ;; F6 2A
 or a                   ;; B7
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
 or a, ixh              ;; DD B4
 or a, ixl              ;; DD B5
 or a, iyh              ;; FD B4
 or a, iyl              ;; FD B5
 or a, l                ;; B5
 or b                   ;; B0
 or c                   ;; B1
 or d                   ;; B2
 or e                   ;; B3
 or h                   ;; B4
 or ixh                 ;; DD B4
 or ixl                 ;; DD B5
 or iyh                 ;; FD B4
 or iyl                 ;; FD B5
 or l                   ;; B5
 pop af                 ;; F1
 pop bc                 ;; C1
 pop de                 ;; D1
 pop hl                 ;; E1
 pop ix                 ;; DD E1
 pop iy                 ;; FD E1
 push af                ;; F5
 push bc                ;; C5
 push de                ;; D5
 push hl                ;; E5
 push ix                ;; DD E5
 push iy                ;; FD E5
 rld                    ;; ED 6F
 rrd                    ;; ED 67
 sbc (42)               ;; DE 2A
 sbc (hl)               ;; 9E
 sbc (ix)               ;; DD 9E 00
 sbc (ix+127)           ;; DD 9E 7F
 sbc (iy)               ;; FD 9E 00
 sbc (iy+127)           ;; FD 9E 7F
 sbc 42                 ;; DE 2A
 sbc a                  ;; 9F
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
 sbc a, ixh             ;; DD 9C
 sbc a, ixl             ;; DD 9D
 sbc a, iyh             ;; FD 9C
 sbc a, iyl             ;; FD 9D
 sbc a, l               ;; 9D
 sbc b                  ;; 98
 sbc c                  ;; 99
 sbc d                  ;; 9A
 sbc e                  ;; 9B
 sbc h                  ;; 9C
 sbc ixh                ;; DD 9C
 sbc ixl                ;; DD 9D
 sbc iyh                ;; FD 9C
 sbc iyl                ;; FD 9D
 sbc l                  ;; 9D
 scf                    ;; 37
 scf f                  ;; 37
 sub (42)               ;; D6 2A
 sub (hl)               ;; 96
 sub (ix)               ;; DD 96 00
 sub (ix+127)           ;; DD 96 7F
 sub (iy)               ;; FD 96 00
 sub (iy+127)           ;; FD 96 7F
 sub 42                 ;; D6 2A
 sub a                  ;; 97
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
 sub a, ixh             ;; DD 94
 sub a, ixl             ;; DD 95
 sub a, iyh             ;; FD 94
 sub a, iyl             ;; FD 95
 sub a, l               ;; 95
 sub b                  ;; 90
 sub c                  ;; 91
 sub d                  ;; 92
 sub e                  ;; 93
 sub h                  ;; 94
 sub ixh                ;; DD 94
 sub ixl                ;; DD 95
 sub iyh                ;; FD 94
 sub iyl                ;; FD 95
 sub l                  ;; 95
 xor (42)               ;; EE 2A
 xor (hl)               ;; AE
 xor (ix)               ;; DD AE 00
 xor (ix+127)           ;; DD AE 7F
 xor (iy)               ;; FD AE 00
 xor (iy+127)           ;; FD AE 7F
 xor 42                 ;; EE 2A
 xor a                  ;; AF
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
 xor a, ixh             ;; DD AC
 xor a, ixl             ;; DD AD
 xor a, iyh             ;; FD AC
 xor a, iyl             ;; FD AD
 xor a, l               ;; AD
 xor b                  ;; A8
 xor c                  ;; A9
 xor d                  ;; AA
 xor e                  ;; AB
 xor h                  ;; AC
 xor ixh                ;; DD AC
 xor ixl                ;; DD AD
 xor iyh                ;; FD AC
 xor iyl                ;; FD AD
 xor l                  ;; AD
