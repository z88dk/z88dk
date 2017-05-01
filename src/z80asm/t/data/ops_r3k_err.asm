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
 daa                    ;; 06B8:  27
 rld                    ;; 06B8:  ED 6F
 rrd                    ;; 06B8:  ED 67
 mlt sp                 ;; 0AEC:  ED 7C
 sll b                  ;; 0B77:  CB 30
 sll c                  ;; 0B77:  CB 31
 sll d                  ;; 0B77:  CB 32
 sll e                  ;; 0B77:  CB 33
 sll h                  ;; 0B77:  CB 34
 sll l                  ;; 0B77:  CB 35
 sll (hl)               ;; 0B77:  CB 36
 sll a                  ;; 0B77:  CB 37
 sll (ix+-128)          ;; 0BCB:  DD CB 80 36
 sll (ix)               ;; 0BCB:  DD CB 00 36
 sll (ix+127)           ;; 0BCB:  DD CB 7F 36
 sll (iy+-128)          ;; 0C1F:  FD CB 80 36
 sll (iy)               ;; 0C1F:  FD CB 00 36
 sll (iy+127)           ;; 0C1F:  FD CB 7F 36
 cpi                    ;; 1150:  ED A1
 cpir                   ;; 1150:  ED B1
 cpd                    ;; 1150:  ED A9
 cpdr                   ;; 1150:  ED B9
 halt                   ;; 1151:  76
 slp                    ;; 1151:  ED 76
 call nz, 0             ;; 124E:  C4 00 00
 call nz, 291           ;; 124E:  C4 23 01
 call nz, 17767         ;; 124E:  C4 67 45
 call nz, 35243         ;; 124E:  C4 AB 89
 call nz, 52719         ;; 124E:  C4 EF CD
 call nz, 65535         ;; 124E:  C4 FF FF
 call z, 0              ;; 124E:  CC 00 00
 call z, 291            ;; 124E:  CC 23 01
 call z, 17767          ;; 124E:  CC 67 45
 call z, 35243          ;; 124E:  CC AB 89
 call z, 52719          ;; 124E:  CC EF CD
 call z, 65535          ;; 124E:  CC FF FF
 call nc, 0             ;; 124E:  D4 00 00
 call nc, 291           ;; 124E:  D4 23 01
 call nc, 17767         ;; 124E:  D4 67 45
 call nc, 35243         ;; 124E:  D4 AB 89
 call nc, 52719         ;; 124E:  D4 EF CD
 call nc, 65535         ;; 124E:  D4 FF FF
 call c, 0              ;; 124E:  DC 00 00
 call c, 291            ;; 124E:  DC 23 01
 call c, 17767          ;; 124E:  DC 67 45
 call c, 35243          ;; 124E:  DC AB 89
 call c, 52719          ;; 124E:  DC EF CD
 call c, 65535          ;; 124E:  DC FF FF
 call po, 0             ;; 124E:  E4 00 00
 call po, 291           ;; 124E:  E4 23 01
 call po, 17767         ;; 124E:  E4 67 45
 call po, 35243         ;; 124E:  E4 AB 89
 call po, 52719         ;; 124E:  E4 EF CD
 call po, 65535         ;; 124E:  E4 FF FF
 call pe, 0             ;; 124E:  EC 00 00
 call pe, 291           ;; 124E:  EC 23 01
 call pe, 17767         ;; 124E:  EC 67 45
 call pe, 35243         ;; 124E:  EC AB 89
 call pe, 52719         ;; 124E:  EC EF CD
 call pe, 65535         ;; 124E:  EC FF FF
 call p, 0              ;; 124E:  F4 00 00
 call p, 291            ;; 124E:  F4 23 01
 call p, 17767          ;; 124E:  F4 67 45
 call p, 35243          ;; 124E:  F4 AB 89
 call p, 52719          ;; 124E:  F4 EF CD
 call p, 65535          ;; 124E:  F4 FF FF
 call m, 0              ;; 124E:  FC 00 00
 call m, 291            ;; 124E:  FC 23 01
 call m, 17767          ;; 124E:  FC 67 45
 call m, 35243          ;; 124E:  FC AB 89
 call m, 52719          ;; 124E:  FC EF CD
 call m, 65535          ;; 124E:  FC FF FF
 rst 0                  ;; 125E:  C7
 rst 8                  ;; 125E:  CF
 rst 48                 ;; 125E:  F7
 in a, (0)              ;; 125E:  DB 00
 in a, (85)             ;; 125E:  DB 55
 in a, (170)            ;; 125E:  DB AA
 in a, (255)            ;; 125E:  DB FF
 in b, (c)              ;; 125E:  ED 40
 in c, (c)              ;; 125E:  ED 48
 in d, (c)              ;; 125E:  ED 50
 in e, (c)              ;; 125E:  ED 58
 in h, (c)              ;; 125E:  ED 60
 in l, (c)              ;; 125E:  ED 68
 in f, (c)              ;; 125E:  ED 70
 in a, (c)              ;; 125E:  ED 78
 in0 b, (0)             ;; 125E:  ED 00 00
 in0 b, (85)            ;; 125E:  ED 00 55
 in0 b, (170)           ;; 125E:  ED 00 AA
 in0 b, (255)           ;; 125E:  ED 00 FF
 in0 c, (0)             ;; 125E:  ED 08 00
 in0 c, (85)            ;; 125E:  ED 08 55
 in0 c, (170)           ;; 125E:  ED 08 AA
 in0 c, (255)           ;; 125E:  ED 08 FF
 in0 d, (0)             ;; 125E:  ED 10 00
 in0 d, (85)            ;; 125E:  ED 10 55
 in0 d, (170)           ;; 125E:  ED 10 AA
 in0 d, (255)           ;; 125E:  ED 10 FF
 in0 e, (0)             ;; 125E:  ED 18 00
 in0 e, (85)            ;; 125E:  ED 18 55
 in0 e, (170)           ;; 125E:  ED 18 AA
 in0 e, (255)           ;; 125E:  ED 18 FF
 in0 h, (0)             ;; 125E:  ED 20 00
 in0 h, (85)            ;; 125E:  ED 20 55
 in0 h, (170)           ;; 125E:  ED 20 AA
 in0 h, (255)           ;; 125E:  ED 20 FF
 in0 l, (0)             ;; 125E:  ED 28 00
 in0 l, (85)            ;; 125E:  ED 28 55
 in0 l, (170)           ;; 125E:  ED 28 AA
 in0 l, (255)           ;; 125E:  ED 28 FF
 in0 f, (0)             ;; 125E:  ED 30 00
 in0 f, (85)            ;; 125E:  ED 30 55
 in0 f, (170)           ;; 125E:  ED 30 AA
 in0 f, (255)           ;; 125E:  ED 30 FF
 in0 a, (0)             ;; 125E:  ED 38 00
 in0 a, (85)            ;; 125E:  ED 38 55
 in0 a, (170)           ;; 125E:  ED 38 AA
 in0 a, (255)           ;; 125E:  ED 38 FF
 out (0), a             ;; 125E:  D3 00
 out (85), a            ;; 125E:  D3 55
 out (170), a           ;; 125E:  D3 AA
 out (255), a           ;; 125E:  D3 FF
 out (c), b             ;; 125E:  ED 41
 out (c), c             ;; 125E:  ED 49
 out (c), d             ;; 125E:  ED 51
 out (c), e             ;; 125E:  ED 59
 out (c), h             ;; 125E:  ED 61
 out (c), l             ;; 125E:  ED 69
 out (c), 0             ;; 125E:  ED 71
 out (c), a             ;; 125E:  ED 79
 out0 (0), b            ;; 125E:  ED 01 00
 out0 (85), b           ;; 125E:  ED 01 55
 out0 (170), b          ;; 125E:  ED 01 AA
 out0 (255), b          ;; 125E:  ED 01 FF
 out0 (0), c            ;; 125E:  ED 09 00
 out0 (85), c           ;; 125E:  ED 09 55
 out0 (170), c          ;; 125E:  ED 09 AA
 out0 (255), c          ;; 125E:  ED 09 FF
 out0 (0), d            ;; 125E:  ED 11 00
 out0 (85), d           ;; 125E:  ED 11 55
 out0 (170), d          ;; 125E:  ED 11 AA
 out0 (255), d          ;; 125E:  ED 11 FF
 out0 (0), e            ;; 125E:  ED 19 00
 out0 (85), e           ;; 125E:  ED 19 55
 out0 (170), e          ;; 125E:  ED 19 AA
 out0 (255), e          ;; 125E:  ED 19 FF
 out0 (0), h            ;; 125E:  ED 21 00
 out0 (85), h           ;; 125E:  ED 21 55
 out0 (170), h          ;; 125E:  ED 21 AA
 out0 (255), h          ;; 125E:  ED 21 FF
 out0 (0), l            ;; 125E:  ED 29 00
 out0 (85), l           ;; 125E:  ED 29 55
 out0 (170), l          ;; 125E:  ED 29 AA
 out0 (255), l          ;; 125E:  ED 29 FF
 out0 (0), a            ;; 125E:  ED 39 00
 out0 (85), a           ;; 125E:  ED 39 55
 out0 (170), a          ;; 125E:  ED 39 AA
 out0 (255), a          ;; 125E:  ED 39 FF
 tstio 0                ;; 125E:  ED 74 00
 tstio 85               ;; 125E:  ED 74 55
 tstio 170              ;; 125E:  ED 74 AA
 tstio 255              ;; 125E:  ED 74 FF
 ini                    ;; 1260:  ED A2
 inir                   ;; 1260:  ED B2
 ind                    ;; 1260:  ED AA
 indr                   ;; 1260:  ED BA
 outi                   ;; 1260:  ED A3
 otir                   ;; 1260:  ED B3
 outd                   ;; 1260:  ED AB
 otdr                   ;; 1260:  ED BB
 otdm                   ;; 1260:  ED 8B
 otdmr                  ;; 1260:  ED 9B
 otim                   ;; 1260:  ED 83
 otimr                  ;; 1260:  ED 93
 di                     ;; 1260:  F3
 ei                     ;; 1260:  FB
 im 0                   ;; 1260:  ED 46
 im 1                   ;; 1260:  ED 56
 im 2                   ;; 1260:  ED 5E
 ld i, a                ;; 126A:  ED 47
 ld a, i                ;; 126A:  ED 57
 ld r, a                ;; 126A:  ED 4F
 ld a, r                ;; 126A:  ED 5F
 retn                   ;; 127A:  ED 45
