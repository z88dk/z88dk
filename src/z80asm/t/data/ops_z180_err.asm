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
 push ip                ;; 0632:  ED 76
 push su                ;; 0632:  ED 66
 pop ip                 ;; 063A:  ED 7E
 pop su                 ;; 063A:  ED 6E
 ld hl, ix              ;; 063A:  DD 7C
 ld hl, iy              ;; 063A:  FD 7C
 ld ix, hl              ;; 063A:  DD 7D
 ld iy, hl              ;; 063A:  FD 7D
 ld hl, (hl + -128)     ;; 063A:  DD E4 80
 ld hl, (hl + 0)        ;; 063A:  DD E4 00
 ld hl, (hl + 127)      ;; 063A:  DD E4 7F
 ld hl, (ix + -128)     ;; 063A:  E4 80
 ld hl, (ix + 0)        ;; 063A:  E4 00
 ld hl, (ix + 127)      ;; 063A:  E4 7F
 ld hl, (iy + -128)     ;; 063A:  FD E4 80
 ld hl, (iy + 0)        ;; 063A:  FD E4 00
 ld hl, (iy + 127)      ;; 063A:  FD E4 7F
 ld (hl + -128), hl     ;; 063A:  DD F4 80
 ld (hl + 0), hl        ;; 063A:  DD F4 00
 ld (hl + 127), hl      ;; 063A:  DD F4 7F
 ld (ix + -128), hl     ;; 063A:  F4 80
 ld (ix + 0), hl        ;; 063A:  F4 00
 ld (ix + 127), hl      ;; 063A:  F4 7F
 ld (iy + -128), hl     ;; 063A:  FD F4 80
 ld (iy + 0), hl        ;; 063A:  FD F4 00
 ld (iy + 127), hl      ;; 063A:  FD F4 7F
 ldp (0), hl            ;; 063A:  ED 65 00 00
 ldp (291), hl          ;; 063A:  ED 65 23 01
 ldp (17767), hl        ;; 063A:  ED 65 67 45
 ldp (35243), hl        ;; 063A:  ED 65 AB 89
 ldp (52719), hl        ;; 063A:  ED 65 EF CD
 ldp (65535), hl        ;; 063A:  ED 65 FF FF
 ldp (0), ix            ;; 063A:  DD 65 00 00
 ldp (291), ix          ;; 063A:  DD 65 23 01
 ldp (17767), ix        ;; 063A:  DD 65 67 45
 ldp (35243), ix        ;; 063A:  DD 65 AB 89
 ldp (52719), ix        ;; 063A:  DD 65 EF CD
 ldp (65535), ix        ;; 063A:  DD 65 FF FF
 ldp (0), iy            ;; 063A:  FD 65 00 00
 ldp (291), iy          ;; 063A:  FD 65 23 01
 ldp (17767), iy        ;; 063A:  FD 65 67 45
 ldp (35243), iy        ;; 063A:  FD 65 AB 89
 ldp (52719), iy        ;; 063A:  FD 65 EF CD
 ldp (65535), iy        ;; 063A:  FD 65 FF FF
 ldp hl, (0)            ;; 063A:  ED 6D 00 00
 ldp hl, (291)          ;; 063A:  ED 6D 23 01
 ldp hl, (17767)        ;; 063A:  ED 6D 67 45
 ldp hl, (35243)        ;; 063A:  ED 6D AB 89
 ldp hl, (52719)        ;; 063A:  ED 6D EF CD
 ldp hl, (65535)        ;; 063A:  ED 6D FF FF
 ldp ix, (0)            ;; 063A:  DD 6D 00 00
 ldp ix, (291)          ;; 063A:  DD 6D 23 01
 ldp ix, (17767)        ;; 063A:  DD 6D 67 45
 ldp ix, (35243)        ;; 063A:  DD 6D AB 89
 ldp ix, (52719)        ;; 063A:  DD 6D EF CD
 ldp ix, (65535)        ;; 063A:  DD 6D FF FF
 ldp iy, (0)            ;; 063A:  FD 6D 00 00
 ldp iy, (291)          ;; 063A:  FD 6D 23 01
 ldp iy, (17767)        ;; 063A:  FD 6D 67 45
 ldp iy, (35243)        ;; 063A:  FD 6D AB 89
 ldp iy, (52719)        ;; 063A:  FD 6D EF CD
 ldp iy, (65535)        ;; 063A:  FD 6D FF FF
 ldp (hl), hl           ;; 063A:  ED 64
 ldp (ix), hl           ;; 063A:  DD 64
 ldp (iy), hl           ;; 063A:  FD 64
 ldp hl, (hl)           ;; 063A:  ED 6C
 ldp hl, (ix)           ;; 063A:  DD 6C
 ldp hl, (iy)           ;; 063A:  FD 6C
 ld (sp + 0), hl        ;; 063A:  D4 00
 ld (sp + 85), hl       ;; 063A:  D4 55
 ld (sp + 170), hl      ;; 063A:  D4 AA
 ld (sp + 255), hl      ;; 063A:  D4 FF
 ld (sp + 0), ix        ;; 063A:  DD D4 00
 ld (sp + 85), ix       ;; 063A:  DD D4 55
 ld (sp + 170), ix      ;; 063A:  DD D4 AA
 ld (sp + 255), ix      ;; 063A:  DD D4 FF
 ld (sp + 0), iy        ;; 063A:  FD D4 00
 ld (sp + 85), iy       ;; 063A:  FD D4 55
 ld (sp + 170), iy      ;; 063A:  FD D4 AA
 ld (sp + 255), iy      ;; 063A:  FD D4 FF
 ld hl, (sp + 0)        ;; 063A:  C4 00
 ld hl, (sp + 85)       ;; 063A:  C4 55
 ld hl, (sp + 170)      ;; 063A:  C4 AA
 ld hl, (sp + 255)      ;; 063A:  C4 FF
 ld ix, (sp + 0)        ;; 063A:  DD C4 00
 ld ix, (sp + 85)       ;; 063A:  DD C4 55
 ld ix, (sp + 170)      ;; 063A:  DD C4 AA
 ld ix, (sp + 255)      ;; 063A:  DD C4 FF
 ld iy, (sp + 0)        ;; 063A:  FD C4 00
 ld iy, (sp + 85)       ;; 063A:  FD C4 55
 ld iy, (sp + 170)      ;; 063A:  FD C4 AA
 ld iy, (sp + 255)      ;; 063A:  FD C4 FF
 ld bc', bc             ;; 063A:  ED 49
 ld bc', de             ;; 063A:  ED 41
 ld de', bc             ;; 063A:  ED 59
 ld de', de             ;; 063A:  ED 51
 ld hl', bc             ;; 063A:  ED 69
 ld hl', de             ;; 063A:  ED 61
 add sp, -128           ;; 066E:  27 80
 add sp, 0              ;; 066E:  27 00
 add sp, 127            ;; 066E:  27 7F
 and hl, de             ;; 066E:  DC
 or hl, de              ;; 066E:  EC
 and ix, de             ;; 066E:  DD DC
 or ix, de              ;; 066E:  DD EC
 and iy, de             ;; 066E:  FD DC
 or iy, de              ;; 066E:  FD EC
 bool hl                ;; 066E:  CC
 bool ix                ;; 066E:  DD CC
 bool iy                ;; 066E:  FD CC
 mul                    ;; 0676:  F7
 uma                    ;; 0676:  ED C0
 ums                    ;; 0676:  ED C8
 ex de', hl             ;; 067F:  E3
 ex de, hl'             ;; 067F:  76 EB
 ex de', hl'            ;; 067F:  76 E3
 rl de                  ;; 07C3:  F3
 rr de                  ;; 07C3:  FB
 rr hl                  ;; 07C3:  FC
 rr ix                  ;; 07C3:  DD FC
 rr iy                  ;; 07C3:  FD FC
 ldisr                  ;; 0B8B:  ED 90
 lddsr                  ;; 0B8B:  ED 98
 lsdr                   ;; 0B8B:  ED F8
 lsir                   ;; 0B8B:  ED F0
 lsddr                  ;; 0B8B:  ED D8
 lsidr                  ;; 0B8B:  ED D0
 altd                   ;; 0B97:  76
 ld a, xpc              ;; 0B97:  ED 77
 ld xpc, a              ;; 0B97:  ED 67
 rdmode                 ;; 0B97:  ED 7F
 setusr                 ;; 0B97:  ED 6F
 sures                  ;; 0B97:  ED 7D
 syscall                ;; 0B97:  ED 75
 jp lz, 0               ;; 0C39:  E2 00 00
 jp lz, 291             ;; 0C39:  E2 23 01
 jp lz, 17767           ;; 0C39:  E2 67 45
 jp lz, 35243           ;; 0C39:  E2 AB 89
 jp lz, 52719           ;; 0C39:  E2 EF CD
 jp lz, 65535           ;; 0C39:  E2 FF FF
 jp lo, 0               ;; 0C39:  EA 00 00
 jp lo, 291             ;; 0C39:  EA 23 01
 jp lo, 17767           ;; 0C39:  EA 67 45
 jp lo, 35243           ;; 0C39:  EA AB 89
 jp lo, 52719           ;; 0C39:  EA EF CD
 jp lo, 65535           ;; 0C39:  EA FF FF
 ret lz                 ;; 0CF5:  E0
 ret lo                 ;; 0CF5:  E8
 ioe                    ;; 0DED:  DB
 ioi                    ;; 0DED:  D3
 ipset 0                ;; 0E0D:  ED 46
 ipset 1                ;; 0E0D:  ED 56
 ipset 2                ;; 0E0D:  ED 4E
 ipset 3                ;; 0E0D:  ED 5E
 ipres                  ;; 0E0D:  ED 5D
 ld iir, a              ;; 0E15:  ED 4F
 ld a, iir              ;; 0E15:  ED 5F
 ld eir, a              ;; 0E15:  ED 47
 ld a, eir              ;; 0E15:  ED 57
 idet                   ;; 0E19:  5B
