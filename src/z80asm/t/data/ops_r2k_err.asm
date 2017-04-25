 ld b, ixh              ;; 0093:  DD 44
 ld b, ixl              ;; 0093:  DD 45
 ld c, ixh              ;; 0093:  DD 4C
 ld c, ixl              ;; 0093:  DD 4D
 ld d, ixh              ;; 0093:  DD 54
 ld d, ixl              ;; 0093:  DD 55
 ld e, ixh              ;; 0093:  DD 5C
 ld e, ixl              ;; 0093:  DD 5D
 ld ixh, ixh            ;; 0093:  DD 64
 ld ixh, ixl            ;; 0093:  DD 65
 ld ixl, ixh            ;; 0093:  DD 6C
 ld ixl, ixl            ;; 0093:  DD 6D
 ld a, ixh              ;; 0093:  DD 7C
 ld a, ixl              ;; 0093:  DD 7D
 ld b, iyh              ;; 0093:  FD 44
 ld b, iyl              ;; 0093:  FD 45
 ld c, iyh              ;; 0093:  FD 4C
 ld c, iyl              ;; 0093:  FD 4D
 ld d, iyh              ;; 0093:  FD 54
 ld d, iyl              ;; 0093:  FD 55
 ld e, iyh              ;; 0093:  FD 5C
 ld e, iyl              ;; 0093:  FD 5D
 ld iyh, iyh            ;; 0093:  FD 64
 ld iyh, iyl            ;; 0093:  FD 65
 ld iyl, iyh            ;; 0093:  FD 6C
 ld iyl, iyl            ;; 0093:  FD 6D
 ld a, iyh              ;; 0093:  FD 7C
 ld a, iyl              ;; 0093:  FD 7D
 ld ixh, 0              ;; 00CB:  DD 26 00
 ld ixh, 85             ;; 00CB:  DD 26 55
 ld ixh, 170            ;; 00CB:  DD 26 AA
 ld ixh, 255            ;; 00CB:  DD 26 FF
 ld ixl, 0              ;; 00CB:  DD 2E 00
 ld ixl, 85             ;; 00CB:  DD 2E 55
 ld ixl, 170            ;; 00CB:  DD 2E AA
 ld ixl, 255            ;; 00CB:  DD 2E FF
 ld iyh, 0              ;; 00CB:  FD 26 00
 ld iyh, 85             ;; 00CB:  FD 26 55
 ld iyh, 170            ;; 00CB:  FD 26 AA
 ld iyh, 255            ;; 00CB:  FD 26 FF
 ld iyl, 0              ;; 00CB:  FD 2E 00
 ld iyl, 85             ;; 00CB:  FD 2E 55
 ld iyl, 170            ;; 00CB:  FD 2E AA
 ld iyl, 255            ;; 00CB:  FD 2E FF
 add a, ixh             ;; 04D7:  DD 84
 add a, ixl             ;; 04D7:  DD 85
 adc a, ixh             ;; 04D7:  DD 8C
 adc a, ixl             ;; 04D7:  DD 8D
 sub a, ixh             ;; 04D7:  DD 94
 sub a, ixl             ;; 04D7:  DD 95
 sbc a, ixh             ;; 04D7:  DD 9C
 sbc a, ixl             ;; 04D7:  DD 9D
 and a, ixh             ;; 04D7:  DD A4
 and a, ixl             ;; 04D7:  DD A5
 xor a, ixh             ;; 04D7:  DD AC
 xor a, ixl             ;; 04D7:  DD AD
 or a, ixh              ;; 04D7:  DD B4
 or a, ixl              ;; 04D7:  DD B5
 cp a, ixh              ;; 04D7:  DD BC
 cp a, ixl              ;; 04D7:  DD BD
 add ixh                ;; 04D7:  DD 84
 add ixl                ;; 04D7:  DD 85
 adc ixh                ;; 04D7:  DD 8C
 adc ixl                ;; 04D7:  DD 8D
 sub ixh                ;; 04D7:  DD 94
 sub ixl                ;; 04D7:  DD 95
 sbc ixh                ;; 04D7:  DD 9C
 sbc ixl                ;; 04D7:  DD 9D
 and ixh                ;; 04D7:  DD A4
 and ixl                ;; 04D7:  DD A5
 xor ixh                ;; 04D7:  DD AC
 xor ixl                ;; 04D7:  DD AD
 or ixh                 ;; 04D7:  DD B4
 or ixl                 ;; 04D7:  DD B5
 cp ixh                 ;; 04D7:  DD BC
 cp ixl                 ;; 04D7:  DD BD
 add a, iyh             ;; 04D7:  FD 84
 add a, iyl             ;; 04D7:  FD 85
 adc a, iyh             ;; 04D7:  FD 8C
 adc a, iyl             ;; 04D7:  FD 8D
 sub a, iyh             ;; 04D7:  FD 94
 sub a, iyl             ;; 04D7:  FD 95
 sbc a, iyh             ;; 04D7:  FD 9C
 sbc a, iyl             ;; 04D7:  FD 9D
 and a, iyh             ;; 04D7:  FD A4
 and a, iyl             ;; 04D7:  FD A5
 xor a, iyh             ;; 04D7:  FD AC
 xor a, iyl             ;; 04D7:  FD AD
 or a, iyh              ;; 04D7:  FD B4
 or a, iyl              ;; 04D7:  FD B5
 cp a, iyh              ;; 04D7:  FD BC
 cp a, iyl              ;; 04D7:  FD BD
 add iyh                ;; 04D7:  FD 84
 add iyl                ;; 04D7:  FD 85
 adc iyh                ;; 04D7:  FD 8C
 adc iyl                ;; 04D7:  FD 8D
 sub iyh                ;; 04D7:  FD 94
 sub iyl                ;; 04D7:  FD 95
 sbc iyh                ;; 04D7:  FD 9C
 sbc iyl                ;; 04D7:  FD 9D
 and iyh                ;; 04D7:  FD A4
 and iyl                ;; 04D7:  FD A5
 xor iyh                ;; 04D7:  FD AC
 xor iyl                ;; 04D7:  FD AD
 or iyh                 ;; 04D7:  FD B4
 or iyl                 ;; 04D7:  FD B5
 cp iyh                 ;; 04D7:  FD BC
 cp iyl                 ;; 04D7:  FD BD
 inc ixh                ;; 0699:  DD 24
 inc ixl                ;; 0699:  DD 2C
 dec ixh                ;; 0699:  DD 25
 dec ixl                ;; 0699:  DD 2D
 inc iyh                ;; 0699:  FD 24
 inc iyl                ;; 0699:  FD 2C
 dec iyh                ;; 0699:  FD 25
 dec iyl                ;; 0699:  FD 2D
 daa                    ;; 06F7:  27
 rld                    ;; 06F7:  ED 6F
 rrd                    ;; 06F7:  ED 67
 push su                ;; 0936:  ED 66
 pop su                 ;; 0940:  ED 6E
 mlt sp                 ;; 0B14:  ED 7C
 uma                    ;; 0B15:  ED C0
 ums                    ;; 0B15:  ED C8
 sll b                  ;; 0B9B:  CB 30
 sll c                  ;; 0B9B:  CB 31
 sll d                  ;; 0B9B:  CB 32
 sll e                  ;; 0B9B:  CB 33
 sll h                  ;; 0B9B:  CB 34
 sll l                  ;; 0B9B:  CB 35
 sll (hl)               ;; 0B9B:  CB 36
 sll a                  ;; 0B9B:  CB 37
 sll (ix+-128)          ;; 0BEF:  DD CB 80 36
 sll (ix+0)             ;; 0BEF:  DD CB 00 36
 sll (ix+127)           ;; 0BEF:  DD CB 7F 36
 sll (iy+-128)          ;; 0C43:  FD CB 80 36
 sll (iy+0)             ;; 0C43:  FD CB 00 36
 sll (iy+127)           ;; 0C43:  FD CB 7F 36
 ldisr                  ;; 1012:  ED 90
 lddsr                  ;; 1012:  ED 98
 lsdr                   ;; 1012:  ED F8
 lsir                   ;; 1012:  ED F0
 lsddr                  ;; 1012:  ED D8
 lsidr                  ;; 1012:  ED D0
 cpi                    ;; 1012:  ED A1
 cpir                   ;; 1012:  ED B1
 cpd                    ;; 1012:  ED A9
 cpdr                   ;; 1012:  ED B9
 halt                   ;; 1013:  76
 slp                    ;; 1013:  ED 76
 rdmode                 ;; 101B:  ED 7F
 setusr                 ;; 101B:  ED 6F
 sures                  ;; 101B:  ED 7D
 syscall                ;; 101B:  ED 75
 call nz, 0             ;; 1109:  C4 00 00
 call nz, 291           ;; 1109:  C4 23 01
 call nz, 17767         ;; 1109:  C4 67 45
 call nz, 35243         ;; 1109:  C4 AB 89
 call nz, 52719         ;; 1109:  C4 EF CD
 call nz, 65535         ;; 1109:  C4 FF FF
 call z, 0              ;; 1109:  CC 00 00
 call z, 291            ;; 1109:  CC 23 01
 call z, 17767          ;; 1109:  CC 67 45
 call z, 35243          ;; 1109:  CC AB 89
 call z, 52719          ;; 1109:  CC EF CD
 call z, 65535          ;; 1109:  CC FF FF
 call nc, 0             ;; 1109:  D4 00 00
 call nc, 291           ;; 1109:  D4 23 01
 call nc, 17767         ;; 1109:  D4 67 45
 call nc, 35243         ;; 1109:  D4 AB 89
 call nc, 52719         ;; 1109:  D4 EF CD
 call nc, 65535         ;; 1109:  D4 FF FF
 call c, 0              ;; 1109:  DC 00 00
 call c, 291            ;; 1109:  DC 23 01
 call c, 17767          ;; 1109:  DC 67 45
 call c, 35243          ;; 1109:  DC AB 89
 call c, 52719          ;; 1109:  DC EF CD
 call c, 65535          ;; 1109:  DC FF FF
 call po, 0             ;; 1109:  E4 00 00
 call po, 291           ;; 1109:  E4 23 01
 call po, 17767         ;; 1109:  E4 67 45
 call po, 35243         ;; 1109:  E4 AB 89
 call po, 52719         ;; 1109:  E4 EF CD
 call po, 65535         ;; 1109:  E4 FF FF
 call pe, 0             ;; 1109:  EC 00 00
 call pe, 291           ;; 1109:  EC 23 01
 call pe, 17767         ;; 1109:  EC 67 45
 call pe, 35243         ;; 1109:  EC AB 89
 call pe, 52719         ;; 1109:  EC EF CD
 call pe, 65535         ;; 1109:  EC FF FF
 call p, 0              ;; 1109:  F4 00 00
 call p, 291            ;; 1109:  F4 23 01
 call p, 17767          ;; 1109:  F4 67 45
 call p, 35243          ;; 1109:  F4 AB 89
 call p, 52719          ;; 1109:  F4 EF CD
 call p, 65535          ;; 1109:  F4 FF FF
 call m, 0              ;; 1109:  FC 00 00
 call m, 291            ;; 1109:  FC 23 01
 call m, 17767          ;; 1109:  FC 67 45
 call m, 35243          ;; 1109:  FC AB 89
 call m, 52719          ;; 1109:  FC EF CD
 call m, 65535          ;; 1109:  FC FF FF
 rst 0                  ;; 1119:  C7
 rst 8                  ;; 1119:  CF
 rst 48                 ;; 1119:  F7
 in a, (0)              ;; 1119:  DB 00
 in a, (85)             ;; 1119:  DB 55
 in a, (170)            ;; 1119:  DB AA
 in a, (255)            ;; 1119:  DB FF
 in b, (c)              ;; 1119:  ED 40
 in c, (c)              ;; 1119:  ED 48
 in d, (c)              ;; 1119:  ED 50
 in e, (c)              ;; 1119:  ED 58
 in h, (c)              ;; 1119:  ED 60
 in l, (c)              ;; 1119:  ED 68
 in f, (c)              ;; 1119:  ED 70
 in a, (c)              ;; 1119:  ED 78
 in0 b, (0)             ;; 1119:  ED 00 00
 in0 b, (85)            ;; 1119:  ED 00 55
 in0 b, (170)           ;; 1119:  ED 00 AA
 in0 b, (255)           ;; 1119:  ED 00 FF
 in0 c, (0)             ;; 1119:  ED 08 00
 in0 c, (85)            ;; 1119:  ED 08 55
 in0 c, (170)           ;; 1119:  ED 08 AA
 in0 c, (255)           ;; 1119:  ED 08 FF
 in0 d, (0)             ;; 1119:  ED 10 00
 in0 d, (85)            ;; 1119:  ED 10 55
 in0 d, (170)           ;; 1119:  ED 10 AA
 in0 d, (255)           ;; 1119:  ED 10 FF
 in0 e, (0)             ;; 1119:  ED 18 00
 in0 e, (85)            ;; 1119:  ED 18 55
 in0 e, (170)           ;; 1119:  ED 18 AA
 in0 e, (255)           ;; 1119:  ED 18 FF
 in0 h, (0)             ;; 1119:  ED 20 00
 in0 h, (85)            ;; 1119:  ED 20 55
 in0 h, (170)           ;; 1119:  ED 20 AA
 in0 h, (255)           ;; 1119:  ED 20 FF
 in0 l, (0)             ;; 1119:  ED 28 00
 in0 l, (85)            ;; 1119:  ED 28 55
 in0 l, (170)           ;; 1119:  ED 28 AA
 in0 l, (255)           ;; 1119:  ED 28 FF
 in0 f, (0)             ;; 1119:  ED 30 00
 in0 f, (85)            ;; 1119:  ED 30 55
 in0 f, (170)           ;; 1119:  ED 30 AA
 in0 f, (255)           ;; 1119:  ED 30 FF
 in0 a, (0)             ;; 1119:  ED 38 00
 in0 a, (85)            ;; 1119:  ED 38 55
 in0 a, (170)           ;; 1119:  ED 38 AA
 in0 a, (255)           ;; 1119:  ED 38 FF
 out (0), a             ;; 1119:  D3 00
 out (85), a            ;; 1119:  D3 55
 out (170), a           ;; 1119:  D3 AA
 out (255), a           ;; 1119:  D3 FF
 out (c), b             ;; 1119:  ED 41
 out (c), c             ;; 1119:  ED 49
 out (c), d             ;; 1119:  ED 51
 out (c), e             ;; 1119:  ED 59
 out (c), h             ;; 1119:  ED 61
 out (c), l             ;; 1119:  ED 69
 out (c), 0             ;; 1119:  ED 71
 out (c), a             ;; 1119:  ED 79
 out0 (0), b            ;; 1119:  ED 01 00
 out0 (85), b           ;; 1119:  ED 01 55
 out0 (170), b          ;; 1119:  ED 01 AA
 out0 (255), b          ;; 1119:  ED 01 FF
 out0 (0), c            ;; 1119:  ED 09 00
 out0 (85), c           ;; 1119:  ED 09 55
 out0 (170), c          ;; 1119:  ED 09 AA
 out0 (255), c          ;; 1119:  ED 09 FF
 out0 (0), d            ;; 1119:  ED 11 00
 out0 (85), d           ;; 1119:  ED 11 55
 out0 (170), d          ;; 1119:  ED 11 AA
 out0 (255), d          ;; 1119:  ED 11 FF
 out0 (0), e            ;; 1119:  ED 19 00
 out0 (85), e           ;; 1119:  ED 19 55
 out0 (170), e          ;; 1119:  ED 19 AA
 out0 (255), e          ;; 1119:  ED 19 FF
 out0 (0), h            ;; 1119:  ED 21 00
 out0 (85), h           ;; 1119:  ED 21 55
 out0 (170), h          ;; 1119:  ED 21 AA
 out0 (255), h          ;; 1119:  ED 21 FF
 out0 (0), l            ;; 1119:  ED 29 00
 out0 (85), l           ;; 1119:  ED 29 55
 out0 (170), l          ;; 1119:  ED 29 AA
 out0 (255), l          ;; 1119:  ED 29 FF
 out0 (0), a            ;; 1119:  ED 39 00
 out0 (85), a           ;; 1119:  ED 39 55
 out0 (170), a          ;; 1119:  ED 39 AA
 out0 (255), a          ;; 1119:  ED 39 FF
 tstio 0                ;; 1119:  ED 74 00
 tstio 85               ;; 1119:  ED 74 55
 tstio 170              ;; 1119:  ED 74 AA
 tstio 255              ;; 1119:  ED 74 FF
 ini                    ;; 111B:  ED A2
 inir                   ;; 111B:  ED B2
 ind                    ;; 111B:  ED AA
 indr                   ;; 111B:  ED BA
 outi                   ;; 111B:  ED A3
 otir                   ;; 111B:  ED B3
 outd                   ;; 111B:  ED AB
 otdr                   ;; 111B:  ED BB
 otdm                   ;; 111B:  ED 8B
 otdmr                  ;; 111B:  ED 9B
 otim                   ;; 111B:  ED 83
 otimr                  ;; 111B:  ED 93
 di                     ;; 111B:  F3
 ei                     ;; 111B:  FB
 im 0                   ;; 111B:  ED 46
 im 1                   ;; 111B:  ED 56
 im 2                   ;; 111B:  ED 5E
 ld i, a                ;; 1125:  ED 47
 ld a, i                ;; 1125:  ED 57
 ld r, a                ;; 1125:  ED 4F
 ld a, r                ;; 1125:  ED 5F
 retn                   ;; 1135:  ED 45
 idet                   ;; 1135:  5B
