 ADD A, IXH             ;; 0040:  DD 84
 ADC A, IXH             ;; 0040:  DD 8C
 SUB IXH                ;; 0040:  DD 94
 SBC A, IXH             ;; 0040:  DD 9C
 AND IXH                ;; 0040:  DD A4
 XOR IXH                ;; 0040:  DD AC
 OR IXH                 ;; 0040:  DD B4
 CP IXH                 ;; 0040:  DD BC
 ADD A, IXL             ;; 0040:  DD 85
 ADC A, IXL             ;; 0040:  DD 8D
 SUB IXL                ;; 0040:  DD 95
 SBC A, IXL             ;; 0040:  DD 9D
 AND IXL                ;; 0040:  DD A5
 XOR IXL                ;; 0040:  DD AD
 OR IXL                 ;; 0040:  DD B5
 CP IXL                 ;; 0040:  DD BD
 ADD A, IYH             ;; 0040:  FD 84
 ADC A, IYH             ;; 0040:  FD 8C
 SUB IYH                ;; 0040:  FD 94
 SBC A, IYH             ;; 0040:  FD 9C
 AND IYH                ;; 0040:  FD A4
 XOR IYH                ;; 0040:  FD AC
 OR IYH                 ;; 0040:  FD B4
 CP IYH                 ;; 0040:  FD BC
 ADD A, IYL             ;; 0040:  FD 85
 ADC A, IYL             ;; 0040:  FD 8D
 SUB IYL                ;; 0040:  FD 95
 SBC A, IYL             ;; 0040:  FD 9D
 AND IYL                ;; 0040:  FD A5
 XOR IYL                ;; 0040:  FD AD
 OR IYL                 ;; 0040:  FD B5
 CP IYL                 ;; 0040:  FD BD
 ALTD                   ;; 0176:  76
 LD A, XPC              ;; 0176:  ED 77
 LD XPC, A              ;; 0176:  ED 67
 ADD SP, -128           ;; 018A:  27 80
 ADD SP, 0              ;; 018A:  27 00
 ADD SP, 127            ;; 018A:  27 7F
 AND HL, DE             ;; 019A:  DC
 AND IX, DE             ;; 019A:  DD DC
 AND IY, DE             ;; 019A:  FD DC
 BOOL HL                ;; 019A:  CC
 BOOL IX                ;; 019A:  DD CC
 BOOL IY                ;; 019A:  FD CC
 JP LZ, 0               ;; 0722:  E2 00 00
 JP LZ, 4660            ;; 0722:  E2 34 12
 JP LZ, 52719           ;; 0722:  E2 EF CD
 JP LZ, 65535           ;; 0722:  E2 FF FF
 JP LO, 0               ;; 0722:  EA 00 00
 JP LO, 4660            ;; 0722:  EA 34 12
 JP LO, 52719           ;; 0722:  EA EF CD
 JP LO, 65535           ;; 0722:  EA FF FF
 RET LZ                 ;; 07A8:  E0
 RET LO                 ;; 07A8:  E8
 IOE                    ;; 08A8:  DB
 IOI                    ;; 08A8:  D3
 IPSET 0                ;; 08B0:  ED 46
 IPSET 1                ;; 08B0:  ED 56
 IPSET 2                ;; 08B0:  ED 4E
 IPSET 3                ;; 08B0:  ED 5E
 IPRES                  ;; 08B0:  ED 5D
 LD IIR, A              ;; 08B8:  ED 47
 LD A, IIR              ;; 08B8:  ED 57
 LD EIR, A              ;; 08B8:  ED 4F
 LD A, EIR              ;; 08B8:  ED 5F
 IDET                   ;; 08BC:  5B
 ld b, ixh              ;; 08ED:  DD 44
 ld b, ixl              ;; 08ED:  DD 45
 ld c, ixh              ;; 08ED:  DD 4C
 ld c, ixl              ;; 08ED:  DD 4D
 ld d, ixh              ;; 08ED:  DD 54
 ld d, ixl              ;; 08ED:  DD 55
 ld e, ixh              ;; 08ED:  DD 5C
 ld e, ixl              ;; 08ED:  DD 5D
 ld ixh, ixh            ;; 08ED:  DD 64
 ld ixh, ixl            ;; 08ED:  DD 65
 ld ixl, ixh            ;; 08ED:  DD 6C
 ld ixl, ixl            ;; 08ED:  DD 6D
 ld a, ixh              ;; 08ED:  DD 7C
 ld a, ixl              ;; 08ED:  DD 7D
 ld b, iyh              ;; 08ED:  FD 44
 ld b, iyl              ;; 08ED:  FD 45
 ld c, iyh              ;; 08ED:  FD 4C
 ld c, iyl              ;; 08ED:  FD 4D
 ld d, iyh              ;; 08ED:  FD 54
 ld d, iyl              ;; 08ED:  FD 55
 ld e, iyh              ;; 08ED:  FD 5C
 ld e, iyl              ;; 08ED:  FD 5D
 ld iyh, iyh            ;; 08ED:  FD 64
 ld iyh, iyl            ;; 08ED:  FD 65
 ld iyl, iyh            ;; 08ED:  FD 6C
 ld iyl, iyl            ;; 08ED:  FD 6D
 ld a, iyh              ;; 08ED:  FD 7C
 ld a, iyl              ;; 08ED:  FD 7D
 ld ixh, 0              ;; 0925:  DD 26 00
 ld ixh, 85             ;; 0925:  DD 26 55
 ld ixh, 170            ;; 0925:  DD 26 AA
 ld ixh, 255            ;; 0925:  DD 26 FF
 ld ixl, 0              ;; 0925:  DD 2E 00
 ld ixl, 85             ;; 0925:  DD 2E 55
 ld ixl, 170            ;; 0925:  DD 2E AA
 ld ixl, 255            ;; 0925:  DD 2E FF
 ld iyh, 0              ;; 0925:  FD 26 00
 ld iyh, 85             ;; 0925:  FD 26 55
 ld iyh, 170            ;; 0925:  FD 26 AA
 ld iyh, 255            ;; 0925:  FD 26 FF
 ld iyl, 0              ;; 0925:  FD 2E 00
 ld iyl, 85             ;; 0925:  FD 2E 55
 ld iyl, 170            ;; 0925:  FD 2E AA
 ld iyl, 255            ;; 0925:  FD 2E FF
 ld (hl + -128), hl     ;; 0C60:  DD F4 80
 ld (hl + 0), hl        ;; 0C60:  DD F4 00
 ld (hl + 127), hl      ;; 0C60:  DD F4 7F
 ld (ix + -128), hl     ;; 0C60:  F4 80
 ld (ix + 0), hl        ;; 0C60:  F4 00
 ld (ix + 127), hl      ;; 0C60:  F4 7F
 ld (iy + -128), hl     ;; 0C60:  FD F4 80
 ld (iy + 0), hl        ;; 0C60:  FD F4 00
 ld (iy + 127), hl      ;; 0C60:  FD F4 7F
 ld (sp + 0), hl        ;; 0C60:  D4 00
 ld (sp + 85), hl       ;; 0C60:  D4 55
 ld (sp + 170), hl      ;; 0C60:  D4 AA
 ld (sp + 255), hl      ;; 0C60:  D4 FF
 ld (sp + 0), ix        ;; 0C60:  DD D4 00
 ld (sp + 85), ix       ;; 0C60:  DD D4 55
 ld (sp + 170), ix      ;; 0C60:  DD D4 AA
 ld (sp + 255), ix      ;; 0C60:  DD D4 FF
 ld (sp + 0), iy        ;; 0C60:  FD D4 00
 ld (sp + 85), iy       ;; 0C60:  FD D4 55
 ld (sp + 170), iy      ;; 0C60:  FD D4 AA
 ld (sp + 255), iy      ;; 0C60:  FD D4 FF
 ld bc', bc             ;; 0C60:  ED 49
 ld bc', de             ;; 0C60:  ED 41
 ld de', bc             ;; 0C60:  ED 59
 ld de', de             ;; 0C60:  ED 51
 ld hl', bc             ;; 0C60:  ED 69
 ld hl', de             ;; 0C60:  ED 61
 ex de', hl             ;; 0C69:  E3
 ex de, hl'             ;; 0C69:  76 EB
 ex de', hl'            ;; 0C69:  76 E3
