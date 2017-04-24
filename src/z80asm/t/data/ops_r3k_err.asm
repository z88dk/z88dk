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
 inc ixh                ;; 0431:  DD 24
 inc ixl                ;; 0431:  DD 2C
 dec ixh                ;; 0431:  DD 25
 dec ixl                ;; 0431:  DD 2D
 inc iyh                ;; 0431:  FD 24
 inc iyl                ;; 0431:  FD 2C
 dec iyh                ;; 0431:  FD 25
 dec iyl                ;; 0431:  FD 2D
 daa                    ;; 048F:  27
 rld                    ;; 048F:  ED 6F
 rrd                    ;; 048F:  ED 67
 mlt sp                 ;; 07AC:  ED 7C
 sll b                  ;; 0834:  CB 30
 sll c                  ;; 0834:  CB 31
 sll d                  ;; 0834:  CB 32
 sll e                  ;; 0834:  CB 33
 sll h                  ;; 0834:  CB 34
 sll l                  ;; 0834:  CB 35
 sll (hl)               ;; 0834:  CB 36
 sll a                  ;; 0834:  CB 37
 sll (ix+-128)          ;; 0888:  DD CB 80 36
 sll (ix+0)             ;; 0888:  DD CB 00 36
 sll (ix+127)           ;; 0888:  DD CB 7F 36
 sll (iy+-128)          ;; 08DC:  FD CB 80 36
 sll (iy+0)             ;; 08DC:  FD CB 00 36
 sll (iy+127)           ;; 08DC:  FD CB 7F 36
 cpi                    ;; 0CB7:  ED A1
 cpir                   ;; 0CB7:  ED B1
 cpd                    ;; 0CB7:  ED A9
 cpdr                   ;; 0CB7:  ED B9
 halt                   ;; 0CB8:  76
 slp                    ;; 0CB8:  ED 76
 call nz, 0             ;; 0DAE:  C4 00 00
 call nz, 291           ;; 0DAE:  C4 23 01
 call nz, 17767         ;; 0DAE:  C4 67 45
 call nz, 35243         ;; 0DAE:  C4 AB 89
 call nz, 52719         ;; 0DAE:  C4 EF CD
 call nz, 65535         ;; 0DAE:  C4 FF FF
 call z, 0              ;; 0DAE:  CC 00 00
 call z, 291            ;; 0DAE:  CC 23 01
 call z, 17767          ;; 0DAE:  CC 67 45
 call z, 35243          ;; 0DAE:  CC AB 89
 call z, 52719          ;; 0DAE:  CC EF CD
 call z, 65535          ;; 0DAE:  CC FF FF
 call nc, 0             ;; 0DAE:  D4 00 00
 call nc, 291           ;; 0DAE:  D4 23 01
 call nc, 17767         ;; 0DAE:  D4 67 45
 call nc, 35243         ;; 0DAE:  D4 AB 89
 call nc, 52719         ;; 0DAE:  D4 EF CD
 call nc, 65535         ;; 0DAE:  D4 FF FF
 call c, 0              ;; 0DAE:  DC 00 00
 call c, 291            ;; 0DAE:  DC 23 01
 call c, 17767          ;; 0DAE:  DC 67 45
 call c, 35243          ;; 0DAE:  DC AB 89
 call c, 52719          ;; 0DAE:  DC EF CD
 call c, 65535          ;; 0DAE:  DC FF FF
 call po, 0             ;; 0DAE:  E4 00 00
 call po, 291           ;; 0DAE:  E4 23 01
 call po, 17767         ;; 0DAE:  E4 67 45
 call po, 35243         ;; 0DAE:  E4 AB 89
 call po, 52719         ;; 0DAE:  E4 EF CD
 call po, 65535         ;; 0DAE:  E4 FF FF
 call pe, 0             ;; 0DAE:  EC 00 00
 call pe, 291           ;; 0DAE:  EC 23 01
 call pe, 17767         ;; 0DAE:  EC 67 45
 call pe, 35243         ;; 0DAE:  EC AB 89
 call pe, 52719         ;; 0DAE:  EC EF CD
 call pe, 65535         ;; 0DAE:  EC FF FF
 call p, 0              ;; 0DAE:  F4 00 00
 call p, 291            ;; 0DAE:  F4 23 01
 call p, 17767          ;; 0DAE:  F4 67 45
 call p, 35243          ;; 0DAE:  F4 AB 89
 call p, 52719          ;; 0DAE:  F4 EF CD
 call p, 65535          ;; 0DAE:  F4 FF FF
 call m, 0              ;; 0DAE:  FC 00 00
 call m, 291            ;; 0DAE:  FC 23 01
 call m, 17767          ;; 0DAE:  FC 67 45
 call m, 35243          ;; 0DAE:  FC AB 89
 call m, 52719          ;; 0DAE:  FC EF CD
 call m, 65535          ;; 0DAE:  FC FF FF
 rst 0                  ;; 0DBE:  C7
 rst 8                  ;; 0DBE:  CF
 rst 48                 ;; 0DBE:  F7
 in a, (0)              ;; 0DBE:  DB 00
 in a, (85)             ;; 0DBE:  DB 55
 in a, (170)            ;; 0DBE:  DB AA
 in a, (255)            ;; 0DBE:  DB FF
 in b, (c)              ;; 0DBE:  ED 40
 in c, (c)              ;; 0DBE:  ED 48
 in d, (c)              ;; 0DBE:  ED 50
 in e, (c)              ;; 0DBE:  ED 58
 in h, (c)              ;; 0DBE:  ED 60
 in l, (c)              ;; 0DBE:  ED 68
 in f, (c)              ;; 0DBE:  ED 70
 in a, (c)              ;; 0DBE:  ED 78
 in0 b, (0)             ;; 0DBE:  ED 00 00
 in0 b, (85)            ;; 0DBE:  ED 00 55
 in0 b, (170)           ;; 0DBE:  ED 00 AA
 in0 b, (255)           ;; 0DBE:  ED 00 FF
 in0 c, (0)             ;; 0DBE:  ED 08 00
 in0 c, (85)            ;; 0DBE:  ED 08 55
 in0 c, (170)           ;; 0DBE:  ED 08 AA
 in0 c, (255)           ;; 0DBE:  ED 08 FF
 in0 d, (0)             ;; 0DBE:  ED 10 00
 in0 d, (85)            ;; 0DBE:  ED 10 55
 in0 d, (170)           ;; 0DBE:  ED 10 AA
 in0 d, (255)           ;; 0DBE:  ED 10 FF
 in0 e, (0)             ;; 0DBE:  ED 18 00
 in0 e, (85)            ;; 0DBE:  ED 18 55
 in0 e, (170)           ;; 0DBE:  ED 18 AA
 in0 e, (255)           ;; 0DBE:  ED 18 FF
 in0 h, (0)             ;; 0DBE:  ED 20 00
 in0 h, (85)            ;; 0DBE:  ED 20 55
 in0 h, (170)           ;; 0DBE:  ED 20 AA
 in0 h, (255)           ;; 0DBE:  ED 20 FF
 in0 l, (0)             ;; 0DBE:  ED 28 00
 in0 l, (85)            ;; 0DBE:  ED 28 55
 in0 l, (170)           ;; 0DBE:  ED 28 AA
 in0 l, (255)           ;; 0DBE:  ED 28 FF
 in0 f, (0)             ;; 0DBE:  ED 30 00
 in0 f, (85)            ;; 0DBE:  ED 30 55
 in0 f, (170)           ;; 0DBE:  ED 30 AA
 in0 f, (255)           ;; 0DBE:  ED 30 FF
 in0 a, (0)             ;; 0DBE:  ED 38 00
 in0 a, (85)            ;; 0DBE:  ED 38 55
 in0 a, (170)           ;; 0DBE:  ED 38 AA
 in0 a, (255)           ;; 0DBE:  ED 38 FF
 out (0), a             ;; 0DBE:  D3 00
 out (85), a            ;; 0DBE:  D3 55
 out (170), a           ;; 0DBE:  D3 AA
 out (255), a           ;; 0DBE:  D3 FF
 out (c), b             ;; 0DBE:  ED 41
 out (c), c             ;; 0DBE:  ED 49
 out (c), d             ;; 0DBE:  ED 51
 out (c), e             ;; 0DBE:  ED 59
 out (c), h             ;; 0DBE:  ED 61
 out (c), l             ;; 0DBE:  ED 69
 out (c), 0             ;; 0DBE:  ED 71
 out (c), a             ;; 0DBE:  ED 79
 out0 (0), b            ;; 0DBE:  ED 01 00
 out0 (85), b           ;; 0DBE:  ED 01 55
 out0 (170), b          ;; 0DBE:  ED 01 AA
 out0 (255), b          ;; 0DBE:  ED 01 FF
 out0 (0), c            ;; 0DBE:  ED 09 00
 out0 (85), c           ;; 0DBE:  ED 09 55
 out0 (170), c          ;; 0DBE:  ED 09 AA
 out0 (255), c          ;; 0DBE:  ED 09 FF
 out0 (0), d            ;; 0DBE:  ED 11 00
 out0 (85), d           ;; 0DBE:  ED 11 55
 out0 (170), d          ;; 0DBE:  ED 11 AA
 out0 (255), d          ;; 0DBE:  ED 11 FF
 out0 (0), e            ;; 0DBE:  ED 19 00
 out0 (85), e           ;; 0DBE:  ED 19 55
 out0 (170), e          ;; 0DBE:  ED 19 AA
 out0 (255), e          ;; 0DBE:  ED 19 FF
 out0 (0), h            ;; 0DBE:  ED 21 00
 out0 (85), h           ;; 0DBE:  ED 21 55
 out0 (170), h          ;; 0DBE:  ED 21 AA
 out0 (255), h          ;; 0DBE:  ED 21 FF
 out0 (0), l            ;; 0DBE:  ED 29 00
 out0 (85), l           ;; 0DBE:  ED 29 55
 out0 (170), l          ;; 0DBE:  ED 29 AA
 out0 (255), l          ;; 0DBE:  ED 29 FF
 out0 (0), a            ;; 0DBE:  ED 39 00
 out0 (85), a           ;; 0DBE:  ED 39 55
 out0 (170), a          ;; 0DBE:  ED 39 AA
 out0 (255), a          ;; 0DBE:  ED 39 FF
 tstio 0                ;; 0DBE:  ED 74 00
 tstio 85               ;; 0DBE:  ED 74 55
 tstio 170              ;; 0DBE:  ED 74 AA
 tstio 255              ;; 0DBE:  ED 74 FF
 ini                    ;; 0DC0:  ED A2
 inir                   ;; 0DC0:  ED B2
 ind                    ;; 0DC0:  ED AA
 indr                   ;; 0DC0:  ED BA
 outi                   ;; 0DC0:  ED A3
 otir                   ;; 0DC0:  ED B3
 outd                   ;; 0DC0:  ED AB
 otdr                   ;; 0DC0:  ED BB
 otdm                   ;; 0DC0:  ED 8B
 otdmr                  ;; 0DC0:  ED 9B
 otim                   ;; 0DC0:  ED 83
 otimr                  ;; 0DC0:  ED 93
 di                     ;; 0DC0:  F3
 ei                     ;; 0DC0:  FB
 im 0                   ;; 0DC0:  ED 46
 im 1                   ;; 0DC0:  ED 56
 im 2                   ;; 0DC0:  ED 5E
 ld i, a                ;; 0DCA:  ED 47
 ld a, i                ;; 0DCA:  ED 57
 ld r, a                ;; 0DCA:  ED 4F
 ld a, r                ;; 0DCA:  ED 5F
 retn                   ;; 0DD4:  ED 45
