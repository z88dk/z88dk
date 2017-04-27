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
 ld ixh, 0              ;; 011F:  DD 26 00
 ld ixh, 85             ;; 011F:  DD 26 55
 ld ixh, 170            ;; 011F:  DD 26 AA
 ld ixh, 255            ;; 011F:  DD 26 FF
 ld ixl, 0              ;; 011F:  DD 2E 00
 ld ixl, 85             ;; 011F:  DD 2E 55
 ld ixl, 170            ;; 011F:  DD 2E AA
 ld ixl, 255            ;; 011F:  DD 2E FF
 ld iyh, 0              ;; 011F:  FD 26 00
 ld iyh, 85             ;; 011F:  FD 26 55
 ld iyh, 170            ;; 011F:  FD 26 AA
 ld iyh, 255            ;; 011F:  FD 26 FF
 ld iyl, 0              ;; 011F:  FD 2E 00
 ld iyl, 85             ;; 011F:  FD 2E 55
 ld iyl, 170            ;; 011F:  FD 2E AA
 ld iyl, 255            ;; 011F:  FD 2E FF
 add a, ixh             ;; 052B:  DD 84
 add a, ixl             ;; 052B:  DD 85
 adc a, ixh             ;; 052B:  DD 8C
 adc a, ixl             ;; 052B:  DD 8D
 sub a, ixh             ;; 052B:  DD 94
 sub a, ixl             ;; 052B:  DD 95
 sbc a, ixh             ;; 052B:  DD 9C
 sbc a, ixl             ;; 052B:  DD 9D
 and a, ixh             ;; 052B:  DD A4
 and a, ixl             ;; 052B:  DD A5
 xor a, ixh             ;; 052B:  DD AC
 xor a, ixl             ;; 052B:  DD AD
 or a, ixh              ;; 052B:  DD B4
 or a, ixl              ;; 052B:  DD B5
 cp a, ixh              ;; 052B:  DD BC
 cp a, ixl              ;; 052B:  DD BD
 add ixh                ;; 052B:  DD 84
 add ixl                ;; 052B:  DD 85
 adc ixh                ;; 052B:  DD 8C
 adc ixl                ;; 052B:  DD 8D
 sub ixh                ;; 052B:  DD 94
 sub ixl                ;; 052B:  DD 95
 sbc ixh                ;; 052B:  DD 9C
 sbc ixl                ;; 052B:  DD 9D
 and ixh                ;; 052B:  DD A4
 and ixl                ;; 052B:  DD A5
 xor ixh                ;; 052B:  DD AC
 xor ixl                ;; 052B:  DD AD
 or ixh                 ;; 052B:  DD B4
 or ixl                 ;; 052B:  DD B5
 cp ixh                 ;; 052B:  DD BC
 cp ixl                 ;; 052B:  DD BD
 add a, iyh             ;; 052B:  FD 84
 add a, iyl             ;; 052B:  FD 85
 adc a, iyh             ;; 052B:  FD 8C
 adc a, iyl             ;; 052B:  FD 8D
 sub a, iyh             ;; 052B:  FD 94
 sub a, iyl             ;; 052B:  FD 95
 sbc a, iyh             ;; 052B:  FD 9C
 sbc a, iyl             ;; 052B:  FD 9D
 and a, iyh             ;; 052B:  FD A4
 and a, iyl             ;; 052B:  FD A5
 xor a, iyh             ;; 052B:  FD AC
 xor a, iyl             ;; 052B:  FD AD
 or a, iyh              ;; 052B:  FD B4
 or a, iyl              ;; 052B:  FD B5
 cp a, iyh              ;; 052B:  FD BC
 cp a, iyl              ;; 052B:  FD BD
 add iyh                ;; 052B:  FD 84
 add iyl                ;; 052B:  FD 85
 adc iyh                ;; 052B:  FD 8C
 adc iyl                ;; 052B:  FD 8D
 sub iyh                ;; 052B:  FD 94
 sub iyl                ;; 052B:  FD 95
 sbc iyh                ;; 052B:  FD 9C
 sbc iyl                ;; 052B:  FD 9D
 and iyh                ;; 052B:  FD A4
 and iyl                ;; 052B:  FD A5
 xor iyh                ;; 052B:  FD AC
 xor iyl                ;; 052B:  FD AD
 or iyh                 ;; 052B:  FD B4
 or iyl                 ;; 052B:  FD B5
 cp iyh                 ;; 052B:  FD BC
 cp iyl                 ;; 052B:  FD BD
 inc ixh                ;; 06ED:  DD 24
 inc ixl                ;; 06ED:  DD 2C
 dec ixh                ;; 06ED:  DD 25
 dec ixl                ;; 06ED:  DD 2D
 inc iyh                ;; 06ED:  FD 24
 inc iyl                ;; 06ED:  FD 2C
 dec iyh                ;; 06ED:  FD 25
 dec iyl                ;; 06ED:  FD 2D
 daa                    ;; 074B:  27
 rld                    ;; 074B:  ED 6F
 rrd                    ;; 074B:  ED 67
 push su                ;; 0995:  ED 66
 pop su                 ;; 09A7:  ED 6E
 mlt sp                 ;; 0B7B:  ED 7C
 uma                    ;; 0B7C:  ED C0
 ums                    ;; 0B7C:  ED C8
 sll b                  ;; 0C02:  CB 30
 sll c                  ;; 0C02:  CB 31
 sll d                  ;; 0C02:  CB 32
 sll e                  ;; 0C02:  CB 33
 sll h                  ;; 0C02:  CB 34
 sll l                  ;; 0C02:  CB 35
 sll (hl)               ;; 0C02:  CB 36
 sll a                  ;; 0C02:  CB 37
 sll (ix+-128)          ;; 0C56:  DD CB 80 36
 sll (ix)               ;; 0C56:  DD CB 00 36
 sll (ix+127)           ;; 0C56:  DD CB 7F 36
 sll (iy+-128)          ;; 0CAA:  FD CB 80 36
 sll (iy)               ;; 0CAA:  FD CB 00 36
 sll (iy+127)           ;; 0CAA:  FD CB 7F 36
 ldisr                  ;; 11CF:  ED 90
 lddsr                  ;; 11CF:  ED 98
 lsdr                   ;; 11CF:  ED F8
 lsir                   ;; 11CF:  ED F0
 lsddr                  ;; 11CF:  ED D8
 lsidr                  ;; 11CF:  ED D0
 cpi                    ;; 11CF:  ED A1
 cpir                   ;; 11CF:  ED B1
 cpd                    ;; 11CF:  ED A9
 cpdr                   ;; 11CF:  ED B9
 halt                   ;; 11D0:  76
 slp                    ;; 11D0:  ED 76
 rdmode                 ;; 11D8:  ED 7F
 setusr                 ;; 11D8:  ED 6F
 sures                  ;; 11D8:  ED 7D
 syscall                ;; 11D8:  ED 75
 call nz, 0             ;; 12C6:  C4 00 00
 call nz, 291           ;; 12C6:  C4 23 01
 call nz, 17767         ;; 12C6:  C4 67 45
 call nz, 35243         ;; 12C6:  C4 AB 89
 call nz, 52719         ;; 12C6:  C4 EF CD
 call nz, 65535         ;; 12C6:  C4 FF FF
 call z, 0              ;; 12C6:  CC 00 00
 call z, 291            ;; 12C6:  CC 23 01
 call z, 17767          ;; 12C6:  CC 67 45
 call z, 35243          ;; 12C6:  CC AB 89
 call z, 52719          ;; 12C6:  CC EF CD
 call z, 65535          ;; 12C6:  CC FF FF
 call nc, 0             ;; 12C6:  D4 00 00
 call nc, 291           ;; 12C6:  D4 23 01
 call nc, 17767         ;; 12C6:  D4 67 45
 call nc, 35243         ;; 12C6:  D4 AB 89
 call nc, 52719         ;; 12C6:  D4 EF CD
 call nc, 65535         ;; 12C6:  D4 FF FF
 call c, 0              ;; 12C6:  DC 00 00
 call c, 291            ;; 12C6:  DC 23 01
 call c, 17767          ;; 12C6:  DC 67 45
 call c, 35243          ;; 12C6:  DC AB 89
 call c, 52719          ;; 12C6:  DC EF CD
 call c, 65535          ;; 12C6:  DC FF FF
 call po, 0             ;; 12C6:  E4 00 00
 call po, 291           ;; 12C6:  E4 23 01
 call po, 17767         ;; 12C6:  E4 67 45
 call po, 35243         ;; 12C6:  E4 AB 89
 call po, 52719         ;; 12C6:  E4 EF CD
 call po, 65535         ;; 12C6:  E4 FF FF
 call pe, 0             ;; 12C6:  EC 00 00
 call pe, 291           ;; 12C6:  EC 23 01
 call pe, 17767         ;; 12C6:  EC 67 45
 call pe, 35243         ;; 12C6:  EC AB 89
 call pe, 52719         ;; 12C6:  EC EF CD
 call pe, 65535         ;; 12C6:  EC FF FF
 call p, 0              ;; 12C6:  F4 00 00
 call p, 291            ;; 12C6:  F4 23 01
 call p, 17767          ;; 12C6:  F4 67 45
 call p, 35243          ;; 12C6:  F4 AB 89
 call p, 52719          ;; 12C6:  F4 EF CD
 call p, 65535          ;; 12C6:  F4 FF FF
 call m, 0              ;; 12C6:  FC 00 00
 call m, 291            ;; 12C6:  FC 23 01
 call m, 17767          ;; 12C6:  FC 67 45
 call m, 35243          ;; 12C6:  FC AB 89
 call m, 52719          ;; 12C6:  FC EF CD
 call m, 65535          ;; 12C6:  FC FF FF
 rst 0                  ;; 12D6:  C7
 rst 8                  ;; 12D6:  CF
 rst 48                 ;; 12D6:  F7
 in a, (0)              ;; 12D6:  DB 00
 in a, (85)             ;; 12D6:  DB 55
 in a, (170)            ;; 12D6:  DB AA
 in a, (255)            ;; 12D6:  DB FF
 in b, (c)              ;; 12D6:  ED 40
 in c, (c)              ;; 12D6:  ED 48
 in d, (c)              ;; 12D6:  ED 50
 in e, (c)              ;; 12D6:  ED 58
 in h, (c)              ;; 12D6:  ED 60
 in l, (c)              ;; 12D6:  ED 68
 in f, (c)              ;; 12D6:  ED 70
 in a, (c)              ;; 12D6:  ED 78
 in0 b, (0)             ;; 12D6:  ED 00 00
 in0 b, (85)            ;; 12D6:  ED 00 55
 in0 b, (170)           ;; 12D6:  ED 00 AA
 in0 b, (255)           ;; 12D6:  ED 00 FF
 in0 c, (0)             ;; 12D6:  ED 08 00
 in0 c, (85)            ;; 12D6:  ED 08 55
 in0 c, (170)           ;; 12D6:  ED 08 AA
 in0 c, (255)           ;; 12D6:  ED 08 FF
 in0 d, (0)             ;; 12D6:  ED 10 00
 in0 d, (85)            ;; 12D6:  ED 10 55
 in0 d, (170)           ;; 12D6:  ED 10 AA
 in0 d, (255)           ;; 12D6:  ED 10 FF
 in0 e, (0)             ;; 12D6:  ED 18 00
 in0 e, (85)            ;; 12D6:  ED 18 55
 in0 e, (170)           ;; 12D6:  ED 18 AA
 in0 e, (255)           ;; 12D6:  ED 18 FF
 in0 h, (0)             ;; 12D6:  ED 20 00
 in0 h, (85)            ;; 12D6:  ED 20 55
 in0 h, (170)           ;; 12D6:  ED 20 AA
 in0 h, (255)           ;; 12D6:  ED 20 FF
 in0 l, (0)             ;; 12D6:  ED 28 00
 in0 l, (85)            ;; 12D6:  ED 28 55
 in0 l, (170)           ;; 12D6:  ED 28 AA
 in0 l, (255)           ;; 12D6:  ED 28 FF
 in0 f, (0)             ;; 12D6:  ED 30 00
 in0 f, (85)            ;; 12D6:  ED 30 55
 in0 f, (170)           ;; 12D6:  ED 30 AA
 in0 f, (255)           ;; 12D6:  ED 30 FF
 in0 a, (0)             ;; 12D6:  ED 38 00
 in0 a, (85)            ;; 12D6:  ED 38 55
 in0 a, (170)           ;; 12D6:  ED 38 AA
 in0 a, (255)           ;; 12D6:  ED 38 FF
 out (0), a             ;; 12D6:  D3 00
 out (85), a            ;; 12D6:  D3 55
 out (170), a           ;; 12D6:  D3 AA
 out (255), a           ;; 12D6:  D3 FF
 out (c), b             ;; 12D6:  ED 41
 out (c), c             ;; 12D6:  ED 49
 out (c), d             ;; 12D6:  ED 51
 out (c), e             ;; 12D6:  ED 59
 out (c), h             ;; 12D6:  ED 61
 out (c), l             ;; 12D6:  ED 69
 out (c), 0             ;; 12D6:  ED 71
 out (c), a             ;; 12D6:  ED 79
 out0 (0), b            ;; 12D6:  ED 01 00
 out0 (85), b           ;; 12D6:  ED 01 55
 out0 (170), b          ;; 12D6:  ED 01 AA
 out0 (255), b          ;; 12D6:  ED 01 FF
 out0 (0), c            ;; 12D6:  ED 09 00
 out0 (85), c           ;; 12D6:  ED 09 55
 out0 (170), c          ;; 12D6:  ED 09 AA
 out0 (255), c          ;; 12D6:  ED 09 FF
 out0 (0), d            ;; 12D6:  ED 11 00
 out0 (85), d           ;; 12D6:  ED 11 55
 out0 (170), d          ;; 12D6:  ED 11 AA
 out0 (255), d          ;; 12D6:  ED 11 FF
 out0 (0), e            ;; 12D6:  ED 19 00
 out0 (85), e           ;; 12D6:  ED 19 55
 out0 (170), e          ;; 12D6:  ED 19 AA
 out0 (255), e          ;; 12D6:  ED 19 FF
 out0 (0), h            ;; 12D6:  ED 21 00
 out0 (85), h           ;; 12D6:  ED 21 55
 out0 (170), h          ;; 12D6:  ED 21 AA
 out0 (255), h          ;; 12D6:  ED 21 FF
 out0 (0), l            ;; 12D6:  ED 29 00
 out0 (85), l           ;; 12D6:  ED 29 55
 out0 (170), l          ;; 12D6:  ED 29 AA
 out0 (255), l          ;; 12D6:  ED 29 FF
 out0 (0), a            ;; 12D6:  ED 39 00
 out0 (85), a           ;; 12D6:  ED 39 55
 out0 (170), a          ;; 12D6:  ED 39 AA
 out0 (255), a          ;; 12D6:  ED 39 FF
 tstio 0                ;; 12D6:  ED 74 00
 tstio 85               ;; 12D6:  ED 74 55
 tstio 170              ;; 12D6:  ED 74 AA
 tstio 255              ;; 12D6:  ED 74 FF
 ini                    ;; 12D8:  ED A2
 inir                   ;; 12D8:  ED B2
 ind                    ;; 12D8:  ED AA
 indr                   ;; 12D8:  ED BA
 outi                   ;; 12D8:  ED A3
 otir                   ;; 12D8:  ED B3
 outd                   ;; 12D8:  ED AB
 otdr                   ;; 12D8:  ED BB
 otdm                   ;; 12D8:  ED 8B
 otdmr                  ;; 12D8:  ED 9B
 otim                   ;; 12D8:  ED 83
 otimr                  ;; 12D8:  ED 93
 di                     ;; 12D8:  F3
 ei                     ;; 12D8:  FB
 im 0                   ;; 12D8:  ED 46
 im 1                   ;; 12D8:  ED 56
 im 2                   ;; 12D8:  ED 5E
 ld i, a                ;; 12E2:  ED 47
 ld a, i                ;; 12E2:  ED 57
 ld r, a                ;; 12E2:  ED 4F
 ld a, r                ;; 12E2:  ED 5F
 retn                   ;; 12F2:  ED 45
 idet                   ;; 12F2:  5B
