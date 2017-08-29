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
 ld ixh, 0              ;; 008C:  DD 26 00
 ld ixh, 85             ;; 008C:  DD 26 55
 ld ixh, 170            ;; 008C:  DD 26 AA
 ld ixh, 255            ;; 008C:  DD 26 FF
 ld ixl, 0              ;; 008C:  DD 2E 00
 ld ixl, 85             ;; 008C:  DD 2E 55
 ld ixl, 170            ;; 008C:  DD 2E AA
 ld ixl, 255            ;; 008C:  DD 2E FF
 ld iyh, 0              ;; 008C:  FD 26 00
 ld iyh, 85             ;; 008C:  FD 26 55
 ld iyh, 170            ;; 008C:  FD 26 AA
 ld iyh, 255            ;; 008C:  FD 26 FF
 ld iyl, 0              ;; 008C:  FD 2E 00
 ld iyl, 85             ;; 008C:  FD 2E 55
 ld iyl, 170            ;; 008C:  FD 2E AA
 ld iyl, 255            ;; 008C:  FD 2E FF
 add a, ixh             ;; 0498:  DD 84
 add a, ixl             ;; 0498:  DD 85
 adc a, ixh             ;; 0498:  DD 8C
 adc a, ixl             ;; 0498:  DD 8D
 sub a, ixh             ;; 0498:  DD 94
 sub a, ixl             ;; 0498:  DD 95
 sbc a, ixh             ;; 0498:  DD 9C
 sbc a, ixl             ;; 0498:  DD 9D
 and a, ixh             ;; 0498:  DD A4
 and a, ixl             ;; 0498:  DD A5
 xor a, ixh             ;; 0498:  DD AC
 xor a, ixl             ;; 0498:  DD AD
 or a, ixh              ;; 0498:  DD B4
 or a, ixl              ;; 0498:  DD B5
 cp a, ixh              ;; 0498:  DD BC
 cp a, ixl              ;; 0498:  DD BD
 add ixh                ;; 0498:  DD 84
 add ixl                ;; 0498:  DD 85
 adc ixh                ;; 0498:  DD 8C
 adc ixl                ;; 0498:  DD 8D
 sub ixh                ;; 0498:  DD 94
 sub ixl                ;; 0498:  DD 95
 sbc ixh                ;; 0498:  DD 9C
 sbc ixl                ;; 0498:  DD 9D
 and ixh                ;; 0498:  DD A4
 and ixl                ;; 0498:  DD A5
 xor ixh                ;; 0498:  DD AC
 xor ixl                ;; 0498:  DD AD
 or ixh                 ;; 0498:  DD B4
 or ixl                 ;; 0498:  DD B5
 cp ixh                 ;; 0498:  DD BC
 cp ixl                 ;; 0498:  DD BD
 add a, iyh             ;; 0498:  FD 84
 add a, iyl             ;; 0498:  FD 85
 adc a, iyh             ;; 0498:  FD 8C
 adc a, iyl             ;; 0498:  FD 8D
 sub a, iyh             ;; 0498:  FD 94
 sub a, iyl             ;; 0498:  FD 95
 sbc a, iyh             ;; 0498:  FD 9C
 sbc a, iyl             ;; 0498:  FD 9D
 and a, iyh             ;; 0498:  FD A4
 and a, iyl             ;; 0498:  FD A5
 xor a, iyh             ;; 0498:  FD AC
 xor a, iyl             ;; 0498:  FD AD
 or a, iyh              ;; 0498:  FD B4
 or a, iyl              ;; 0498:  FD B5
 cp a, iyh              ;; 0498:  FD BC
 cp a, iyl              ;; 0498:  FD BD
 add iyh                ;; 0498:  FD 84
 add iyl                ;; 0498:  FD 85
 adc iyh                ;; 0498:  FD 8C
 adc iyl                ;; 0498:  FD 8D
 sub iyh                ;; 0498:  FD 94
 sub iyl                ;; 0498:  FD 95
 sbc iyh                ;; 0498:  FD 9C
 sbc iyl                ;; 0498:  FD 9D
 and iyh                ;; 0498:  FD A4
 and iyl                ;; 0498:  FD A5
 xor iyh                ;; 0498:  FD AC
 xor iyl                ;; 0498:  FD AD
 or iyh                 ;; 0498:  FD B4
 or iyl                 ;; 0498:  FD B5
 cp iyh                 ;; 0498:  FD BC
 cp iyl                 ;; 0498:  FD BD
 inc ixh                ;; 065A:  DD 24
 inc ixl                ;; 065A:  DD 2C
 dec ixh                ;; 065A:  DD 25
 dec ixl                ;; 065A:  DD 2D
 inc iyh                ;; 065A:  FD 24
 inc iyl                ;; 065A:  FD 2C
 dec iyh                ;; 065A:  FD 25
 dec iyl                ;; 065A:  FD 2D
 tst a, b               ;; 0680:  ED 04
 tst a, c               ;; 0680:  ED 0C
 tst a, d               ;; 0680:  ED 14
 tst a, e               ;; 0680:  ED 1C
 tst a, h               ;; 0680:  ED 24
 tst a, l               ;; 0680:  ED 2C
 tst a, a               ;; 0680:  ED 3C
 tst b                  ;; 0680:  ED 04
 tst c                  ;; 0680:  ED 0C
 tst d                  ;; 0680:  ED 14
 tst e                  ;; 0680:  ED 1C
 tst h                  ;; 0680:  ED 24
 tst l                  ;; 0680:  ED 2C
 tst a                  ;; 0680:  ED 3C
 tst a, 0               ;; 0680:  ED 64 00
 tst a, 85              ;; 0680:  ED 64 55
 tst a, 170             ;; 0680:  ED 64 AA
 tst a, 255             ;; 0680:  ED 64 FF
 tst 0                  ;; 0680:  ED 64 00
 tst 85                 ;; 0680:  ED 64 55
 tst 170                ;; 0680:  ED 64 AA
 tst 255                ;; 0680:  ED 64 FF
 tst a, (hl)            ;; 0680:  ED 34
 tst (hl)               ;; 0680:  ED 34
 daa                    ;; 0680:  27
 push su                ;; 08CA:  ED 66
 pop su                 ;; 08DC:  ED 6E
 mlt sp                 ;; 0AB0:  ED 7C
 uma                    ;; 0AB1:  ED C0
 ums                    ;; 0AB1:  ED C8
 sll b                  ;; 0B37:  CB 30
 sll c                  ;; 0B37:  CB 31
 sll d                  ;; 0B37:  CB 32
 sll e                  ;; 0B37:  CB 33
 sll h                  ;; 0B37:  CB 34
 sll l                  ;; 0B37:  CB 35
 sll (hl)               ;; 0B37:  CB 36
 sll a                  ;; 0B37:  CB 37
 sll (ix+-128)          ;; 0B8B:  DD CB 80 36
 sll (ix)               ;; 0B8B:  DD CB 00 36
 sll (ix+127)           ;; 0B8B:  DD CB 7F 36
 sll (iy+-128)          ;; 0BDF:  FD CB 80 36
 sll (iy)               ;; 0BDF:  FD CB 00 36
 sll (iy+127)           ;; 0BDF:  FD CB 7F 36
 ldisr                  ;; 1104:  ED 90
 lddsr                  ;; 1104:  ED 98
 lsdr                   ;; 1104:  ED F8
 lsir                   ;; 1104:  ED F0
 lsddr                  ;; 1104:  ED D8
 lsidr                  ;; 1104:  ED D0
 halt                   ;; 1105:  76
 slp                    ;; 1105:  ED 76
 rdmode                 ;; 110C:  ED 7F
 setusr                 ;; 110C:  ED 6F
 sures                  ;; 110C:  ED 7D
 syscall                ;; 110C:  ED 75
 in a, (0)              ;; 120A:  DB 00
 in a, (85)             ;; 120A:  DB 55
 in a, (170)            ;; 120A:  DB AA
 in a, (255)            ;; 120A:  DB FF
 in b, (c)              ;; 120A:  ED 40
 in c, (c)              ;; 120A:  ED 48
 in d, (c)              ;; 120A:  ED 50
 in e, (c)              ;; 120A:  ED 58
 in h, (c)              ;; 120A:  ED 60
 in l, (c)              ;; 120A:  ED 68
 in f, (c)              ;; 120A:  ED 70
 in a, (c)              ;; 120A:  ED 78
 in0 b, (0)             ;; 120A:  ED 00 00
 in0 b, (85)            ;; 120A:  ED 00 55
 in0 b, (170)           ;; 120A:  ED 00 AA
 in0 b, (255)           ;; 120A:  ED 00 FF
 in0 c, (0)             ;; 120A:  ED 08 00
 in0 c, (85)            ;; 120A:  ED 08 55
 in0 c, (170)           ;; 120A:  ED 08 AA
 in0 c, (255)           ;; 120A:  ED 08 FF
 in0 d, (0)             ;; 120A:  ED 10 00
 in0 d, (85)            ;; 120A:  ED 10 55
 in0 d, (170)           ;; 120A:  ED 10 AA
 in0 d, (255)           ;; 120A:  ED 10 FF
 in0 e, (0)             ;; 120A:  ED 18 00
 in0 e, (85)            ;; 120A:  ED 18 55
 in0 e, (170)           ;; 120A:  ED 18 AA
 in0 e, (255)           ;; 120A:  ED 18 FF
 in0 h, (0)             ;; 120A:  ED 20 00
 in0 h, (85)            ;; 120A:  ED 20 55
 in0 h, (170)           ;; 120A:  ED 20 AA
 in0 h, (255)           ;; 120A:  ED 20 FF
 in0 l, (0)             ;; 120A:  ED 28 00
 in0 l, (85)            ;; 120A:  ED 28 55
 in0 l, (170)           ;; 120A:  ED 28 AA
 in0 l, (255)           ;; 120A:  ED 28 FF
 in0 f, (0)             ;; 120A:  ED 30 00
 in0 f, (85)            ;; 120A:  ED 30 55
 in0 f, (170)           ;; 120A:  ED 30 AA
 in0 f, (255)           ;; 120A:  ED 30 FF
 in0 a, (0)             ;; 120A:  ED 38 00
 in0 a, (85)            ;; 120A:  ED 38 55
 in0 a, (170)           ;; 120A:  ED 38 AA
 in0 a, (255)           ;; 120A:  ED 38 FF
 out (0), a             ;; 120A:  D3 00
 out (85), a            ;; 120A:  D3 55
 out (170), a           ;; 120A:  D3 AA
 out (255), a           ;; 120A:  D3 FF
 out (c), b             ;; 120A:  ED 41
 out (c), c             ;; 120A:  ED 49
 out (c), d             ;; 120A:  ED 51
 out (c), e             ;; 120A:  ED 59
 out (c), h             ;; 120A:  ED 61
 out (c), l             ;; 120A:  ED 69
 out (c), 0             ;; 120A:  ED 71
 out (c), a             ;; 120A:  ED 79
 out0 (0), b            ;; 120A:  ED 01 00
 out0 (85), b           ;; 120A:  ED 01 55
 out0 (170), b          ;; 120A:  ED 01 AA
 out0 (255), b          ;; 120A:  ED 01 FF
 out0 (0), c            ;; 120A:  ED 09 00
 out0 (85), c           ;; 120A:  ED 09 55
 out0 (170), c          ;; 120A:  ED 09 AA
 out0 (255), c          ;; 120A:  ED 09 FF
 out0 (0), d            ;; 120A:  ED 11 00
 out0 (85), d           ;; 120A:  ED 11 55
 out0 (170), d          ;; 120A:  ED 11 AA
 out0 (255), d          ;; 120A:  ED 11 FF
 out0 (0), e            ;; 120A:  ED 19 00
 out0 (85), e           ;; 120A:  ED 19 55
 out0 (170), e          ;; 120A:  ED 19 AA
 out0 (255), e          ;; 120A:  ED 19 FF
 out0 (0), h            ;; 120A:  ED 21 00
 out0 (85), h           ;; 120A:  ED 21 55
 out0 (170), h          ;; 120A:  ED 21 AA
 out0 (255), h          ;; 120A:  ED 21 FF
 out0 (0), l            ;; 120A:  ED 29 00
 out0 (85), l           ;; 120A:  ED 29 55
 out0 (170), l          ;; 120A:  ED 29 AA
 out0 (255), l          ;; 120A:  ED 29 FF
 out0 (0), a            ;; 120A:  ED 39 00
 out0 (85), a           ;; 120A:  ED 39 55
 out0 (170), a          ;; 120A:  ED 39 AA
 out0 (255), a          ;; 120A:  ED 39 FF
 tstio 0                ;; 120A:  ED 74 00
 tstio 85               ;; 120A:  ED 74 55
 tstio 170              ;; 120A:  ED 74 AA
 tstio 255              ;; 120A:  ED 74 FF
 ini                    ;; 120A:  ED A2
 inir                   ;; 120A:  ED B2
 ind                    ;; 120A:  ED AA
 indr                   ;; 120A:  ED BA
 outi                   ;; 120A:  ED A3
 otir                   ;; 120A:  ED B3
 outd                   ;; 120A:  ED AB
 otdr                   ;; 120A:  ED BB
 otdm                   ;; 120A:  ED 8B
 otdmr                  ;; 120A:  ED 9B
 otim                   ;; 120A:  ED 83
 otimr                  ;; 120A:  ED 93
 di                     ;; 120A:  F3
 ei                     ;; 120A:  FB
 im 0                   ;; 120A:  ED 46
 im 1                   ;; 120A:  ED 56
 im 2                   ;; 120A:  ED 5E
 ld i, a                ;; 1214:  ED 47
 ld a, i                ;; 1214:  ED 57
 ld r, a                ;; 1214:  ED 4F
 ld a, r                ;; 1214:  ED 5F
 retn                   ;; 1224:  ED 45
 idet                   ;; 1224:  5B
