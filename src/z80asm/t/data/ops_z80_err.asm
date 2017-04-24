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
 push ip                ;; 06F2:  ED 76
 push su                ;; 06F2:  ED 66
 pop ip                 ;; 06FA:  ED 7E
 pop su                 ;; 06FA:  ED 6E
 ld hl, ix              ;; 06FA:  DD 7C
 ld hl, iy              ;; 06FA:  FD 7C
 ld ix, hl              ;; 06FA:  DD 7D
 ld iy, hl              ;; 06FA:  FD 7D
 ld hl, (hl + -128)     ;; 06FA:  DD E4 80
 ld hl, (hl + 0)        ;; 06FA:  DD E4 00
 ld hl, (hl + 127)      ;; 06FA:  DD E4 7F
 ld hl, (ix + -128)     ;; 06FA:  E4 80
 ld hl, (ix + 0)        ;; 06FA:  E4 00
 ld hl, (ix + 127)      ;; 06FA:  E4 7F
 ld hl, (iy + -128)     ;; 06FA:  FD E4 80
 ld hl, (iy + 0)        ;; 06FA:  FD E4 00
 ld hl, (iy + 127)      ;; 06FA:  FD E4 7F
 ld (hl + -128), hl     ;; 06FA:  DD F4 80
 ld (hl + 0), hl        ;; 06FA:  DD F4 00
 ld (hl + 127), hl      ;; 06FA:  DD F4 7F
 ld (ix + -128), hl     ;; 06FA:  F4 80
 ld (ix + 0), hl        ;; 06FA:  F4 00
 ld (ix + 127), hl      ;; 06FA:  F4 7F
 ld (iy + -128), hl     ;; 06FA:  FD F4 80
 ld (iy + 0), hl        ;; 06FA:  FD F4 00
 ld (iy + 127), hl      ;; 06FA:  FD F4 7F
 ldp (0), hl            ;; 06FA:  ED 65 00 00
 ldp (291), hl          ;; 06FA:  ED 65 23 01
 ldp (17767), hl        ;; 06FA:  ED 65 67 45
 ldp (35243), hl        ;; 06FA:  ED 65 AB 89
 ldp (52719), hl        ;; 06FA:  ED 65 EF CD
 ldp (65535), hl        ;; 06FA:  ED 65 FF FF
 ldp (0), ix            ;; 06FA:  DD 65 00 00
 ldp (291), ix          ;; 06FA:  DD 65 23 01
 ldp (17767), ix        ;; 06FA:  DD 65 67 45
 ldp (35243), ix        ;; 06FA:  DD 65 AB 89
 ldp (52719), ix        ;; 06FA:  DD 65 EF CD
 ldp (65535), ix        ;; 06FA:  DD 65 FF FF
 ldp (0), iy            ;; 06FA:  FD 65 00 00
 ldp (291), iy          ;; 06FA:  FD 65 23 01
 ldp (17767), iy        ;; 06FA:  FD 65 67 45
 ldp (35243), iy        ;; 06FA:  FD 65 AB 89
 ldp (52719), iy        ;; 06FA:  FD 65 EF CD
 ldp (65535), iy        ;; 06FA:  FD 65 FF FF
 ldp hl, (0)            ;; 06FA:  ED 6D 00 00
 ldp hl, (291)          ;; 06FA:  ED 6D 23 01
 ldp hl, (17767)        ;; 06FA:  ED 6D 67 45
 ldp hl, (35243)        ;; 06FA:  ED 6D AB 89
 ldp hl, (52719)        ;; 06FA:  ED 6D EF CD
 ldp hl, (65535)        ;; 06FA:  ED 6D FF FF
 ldp ix, (0)            ;; 06FA:  DD 6D 00 00
 ldp ix, (291)          ;; 06FA:  DD 6D 23 01
 ldp ix, (17767)        ;; 06FA:  DD 6D 67 45
 ldp ix, (35243)        ;; 06FA:  DD 6D AB 89
 ldp ix, (52719)        ;; 06FA:  DD 6D EF CD
 ldp ix, (65535)        ;; 06FA:  DD 6D FF FF
 ldp iy, (0)            ;; 06FA:  FD 6D 00 00
 ldp iy, (291)          ;; 06FA:  FD 6D 23 01
 ldp iy, (17767)        ;; 06FA:  FD 6D 67 45
 ldp iy, (35243)        ;; 06FA:  FD 6D AB 89
 ldp iy, (52719)        ;; 06FA:  FD 6D EF CD
 ldp iy, (65535)        ;; 06FA:  FD 6D FF FF
 ldp (hl), hl           ;; 06FA:  ED 64
 ldp (ix), hl           ;; 06FA:  DD 64
 ldp (iy), hl           ;; 06FA:  FD 64
 ldp hl, (hl)           ;; 06FA:  ED 6C
 ldp hl, (ix)           ;; 06FA:  DD 6C
 ldp hl, (iy)           ;; 06FA:  FD 6C
 ld (sp + 0), hl        ;; 06FA:  D4 00
 ld (sp + 85), hl       ;; 06FA:  D4 55
 ld (sp + 170), hl      ;; 06FA:  D4 AA
 ld (sp + 255), hl      ;; 06FA:  D4 FF
 ld (sp + 0), ix        ;; 06FA:  DD D4 00
 ld (sp + 85), ix       ;; 06FA:  DD D4 55
 ld (sp + 170), ix      ;; 06FA:  DD D4 AA
 ld (sp + 255), ix      ;; 06FA:  DD D4 FF
 ld (sp + 0), iy        ;; 06FA:  FD D4 00
 ld (sp + 85), iy       ;; 06FA:  FD D4 55
 ld (sp + 170), iy      ;; 06FA:  FD D4 AA
 ld (sp + 255), iy      ;; 06FA:  FD D4 FF
 ld hl, (sp + 0)        ;; 06FA:  C4 00
 ld hl, (sp + 85)       ;; 06FA:  C4 55
 ld hl, (sp + 170)      ;; 06FA:  C4 AA
 ld hl, (sp + 255)      ;; 06FA:  C4 FF
 ld ix, (sp + 0)        ;; 06FA:  DD C4 00
 ld ix, (sp + 85)       ;; 06FA:  DD C4 55
 ld ix, (sp + 170)      ;; 06FA:  DD C4 AA
 ld ix, (sp + 255)      ;; 06FA:  DD C4 FF
 ld iy, (sp + 0)        ;; 06FA:  FD C4 00
 ld iy, (sp + 85)       ;; 06FA:  FD C4 55
 ld iy, (sp + 170)      ;; 06FA:  FD C4 AA
 ld iy, (sp + 255)      ;; 06FA:  FD C4 FF
 ld bc', bc             ;; 06FA:  ED 49
 ld bc', de             ;; 06FA:  ED 41
 ld de', bc             ;; 06FA:  ED 59
 ld de', de             ;; 06FA:  ED 51
 ld hl', bc             ;; 06FA:  ED 69
 ld hl', de             ;; 06FA:  ED 61
 add sp, -128           ;; 072E:  27 80
 add sp, 0              ;; 072E:  27 00
 add sp, 127            ;; 072E:  27 7F
 and hl, de             ;; 072E:  DC
 or hl, de              ;; 072E:  EC
 and ix, de             ;; 072E:  DD DC
 or ix, de              ;; 072E:  DD EC
 and iy, de             ;; 072E:  FD DC
 or iy, de              ;; 072E:  FD EC
 bool hl                ;; 072E:  CC
 bool ix                ;; 072E:  DD CC
 bool iy                ;; 072E:  FD CC
 mlt bc                 ;; 072E:  ED 4C
 mlt de                 ;; 072E:  ED 5C
 mlt hl                 ;; 072E:  ED 6C
 mlt sp                 ;; 072E:  ED 7C
 mul                    ;; 072E:  F7
 uma                    ;; 072E:  ED C0
 ums                    ;; 072E:  ED C8
 ex de', hl             ;; 0737:  E3
 ex de, hl'             ;; 0737:  76 EB
 ex de', hl'            ;; 0737:  76 E3
 rl de                  ;; 087B:  F3
 rr de                  ;; 087B:  FB
 rr hl                  ;; 087B:  FC
 rr ix                  ;; 087B:  DD FC
 rr iy                  ;; 087B:  FD FC
 ldisr                  ;; 0C43:  ED 90
 lddsr                  ;; 0C43:  ED 98
 lsdr                   ;; 0C43:  ED F8
 lsir                   ;; 0C43:  ED F0
 lsddr                  ;; 0C43:  ED D8
 lsidr                  ;; 0C43:  ED D0
 slp                    ;; 0C4D:  ED 76
 altd                   ;; 0C4D:  76
 ld a, xpc              ;; 0C4D:  ED 77
 ld xpc, a              ;; 0C4D:  ED 67
 rdmode                 ;; 0C4D:  ED 7F
 setusr                 ;; 0C4D:  ED 6F
 sures                  ;; 0C4D:  ED 7D
 syscall                ;; 0C4D:  ED 75
 jp lz, 0               ;; 0CEF:  E2 00 00
 jp lz, 291             ;; 0CEF:  E2 23 01
 jp lz, 17767           ;; 0CEF:  E2 67 45
 jp lz, 35243           ;; 0CEF:  E2 AB 89
 jp lz, 52719           ;; 0CEF:  E2 EF CD
 jp lz, 65535           ;; 0CEF:  E2 FF FF
 jp lo, 0               ;; 0CEF:  EA 00 00
 jp lo, 291             ;; 0CEF:  EA 23 01
 jp lo, 17767           ;; 0CEF:  EA 67 45
 jp lo, 35243           ;; 0CEF:  EA AB 89
 jp lo, 52719           ;; 0CEF:  EA EF CD
 jp lo, 65535           ;; 0CEF:  EA FF FF
 ret lz                 ;; 0DAB:  E0
 ret lo                 ;; 0DAB:  E8
 in0 b, (0)             ;; 0DCB:  ED 00 00
 in0 b, (85)            ;; 0DCB:  ED 00 55
 in0 b, (170)           ;; 0DCB:  ED 00 AA
 in0 b, (255)           ;; 0DCB:  ED 00 FF
 in0 c, (0)             ;; 0DCB:  ED 08 00
 in0 c, (85)            ;; 0DCB:  ED 08 55
 in0 c, (170)           ;; 0DCB:  ED 08 AA
 in0 c, (255)           ;; 0DCB:  ED 08 FF
 in0 d, (0)             ;; 0DCB:  ED 10 00
 in0 d, (85)            ;; 0DCB:  ED 10 55
 in0 d, (170)           ;; 0DCB:  ED 10 AA
 in0 d, (255)           ;; 0DCB:  ED 10 FF
 in0 e, (0)             ;; 0DCB:  ED 18 00
 in0 e, (85)            ;; 0DCB:  ED 18 55
 in0 e, (170)           ;; 0DCB:  ED 18 AA
 in0 e, (255)           ;; 0DCB:  ED 18 FF
 in0 h, (0)             ;; 0DCB:  ED 20 00
 in0 h, (85)            ;; 0DCB:  ED 20 55
 in0 h, (170)           ;; 0DCB:  ED 20 AA
 in0 h, (255)           ;; 0DCB:  ED 20 FF
 in0 l, (0)             ;; 0DCB:  ED 28 00
 in0 l, (85)            ;; 0DCB:  ED 28 55
 in0 l, (170)           ;; 0DCB:  ED 28 AA
 in0 l, (255)           ;; 0DCB:  ED 28 FF
 in0 f, (0)             ;; 0DCB:  ED 30 00
 in0 f, (85)            ;; 0DCB:  ED 30 55
 in0 f, (170)           ;; 0DCB:  ED 30 AA
 in0 f, (255)           ;; 0DCB:  ED 30 FF
 in0 a, (0)             ;; 0DCB:  ED 38 00
 in0 a, (85)            ;; 0DCB:  ED 38 55
 in0 a, (170)           ;; 0DCB:  ED 38 AA
 in0 a, (255)           ;; 0DCB:  ED 38 FF
 out0 (0), b            ;; 0DE3:  ED 01 00
 out0 (85), b           ;; 0DE3:  ED 01 55
 out0 (170), b          ;; 0DE3:  ED 01 AA
 out0 (255), b          ;; 0DE3:  ED 01 FF
 out0 (0), c            ;; 0DE3:  ED 09 00
 out0 (85), c           ;; 0DE3:  ED 09 55
 out0 (170), c          ;; 0DE3:  ED 09 AA
 out0 (255), c          ;; 0DE3:  ED 09 FF
 out0 (0), d            ;; 0DE3:  ED 11 00
 out0 (85), d           ;; 0DE3:  ED 11 55
 out0 (170), d          ;; 0DE3:  ED 11 AA
 out0 (255), d          ;; 0DE3:  ED 11 FF
 out0 (0), e            ;; 0DE3:  ED 19 00
 out0 (85), e           ;; 0DE3:  ED 19 55
 out0 (170), e          ;; 0DE3:  ED 19 AA
 out0 (255), e          ;; 0DE3:  ED 19 FF
 out0 (0), h            ;; 0DE3:  ED 21 00
 out0 (85), h           ;; 0DE3:  ED 21 55
 out0 (170), h          ;; 0DE3:  ED 21 AA
 out0 (255), h          ;; 0DE3:  ED 21 FF
 out0 (0), l            ;; 0DE3:  ED 29 00
 out0 (85), l           ;; 0DE3:  ED 29 55
 out0 (170), l          ;; 0DE3:  ED 29 AA
 out0 (255), l          ;; 0DE3:  ED 29 FF
 out0 (0), a            ;; 0DE3:  ED 39 00
 out0 (85), a           ;; 0DE3:  ED 39 55
 out0 (170), a          ;; 0DE3:  ED 39 AA
 out0 (255), a          ;; 0DE3:  ED 39 FF
 tstio 0                ;; 0DE3:  ED 74 00
 tstio 85               ;; 0DE3:  ED 74 55
 tstio 170              ;; 0DE3:  ED 74 AA
 tstio 255              ;; 0DE3:  ED 74 FF
 ioe                    ;; 0DE3:  DB
 ioi                    ;; 0DE3:  D3
 otdm                   ;; 0DF3:  ED 8B
 otdmr                  ;; 0DF3:  ED 9B
 otim                   ;; 0DF3:  ED 83
 otimr                  ;; 0DF3:  ED 93
 ipset 0                ;; 0DFB:  ED 46
 ipset 1                ;; 0DFB:  ED 56
 ipset 2                ;; 0DFB:  ED 4E
 ipset 3                ;; 0DFB:  ED 5E
 ipres                  ;; 0DFB:  ED 5D
 ld iir, a              ;; 0E03:  ED 4F
 ld a, iir              ;; 0E03:  ED 5F
 ld eir, a              ;; 0E03:  ED 47
 ld a, eir              ;; 0E03:  ED 57
 idet                   ;; 0E07:  5B
