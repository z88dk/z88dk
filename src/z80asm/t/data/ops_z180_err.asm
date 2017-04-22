 LD (HL + -128), HL     ;; 011D:  DD F4 80
 LD (HL + 0), HL        ;; 011D:  DD F4 00
 LD (HL + 127), HL      ;; 011D:  DD F4 7F
 LD (ix + -128), HL     ;; 011D:  F4 80
 LD (ix + 0), HL        ;; 011D:  F4 00
 LD (ix + 127), HL      ;; 011D:  F4 7F
 LD (iy + -128), HL     ;; 011D:  FD F4 80
 LD (iy + 0), HL        ;; 011D:  FD F4 00
 LD (iy + 127), HL      ;; 011D:  FD F4 7F
 LD (SP + 0), HL        ;; 011D:  D4 00
 LD (SP + 85), HL       ;; 011D:  D4 55
 LD (SP + 170), HL      ;; 011D:  D4 AA
 LD (SP + 255), HL      ;; 011D:  D4 FF
 LD (SP + 0), IX        ;; 011D:  DD D4 00
 LD (SP + 85), IX       ;; 011D:  DD D4 55
 LD (SP + 170), IX      ;; 011D:  DD D4 AA
 LD (SP + 255), IX      ;; 011D:  DD D4 FF
 LD (SP + 0), IY        ;; 011D:  FD D4 00
 LD (SP + 85), IY       ;; 011D:  FD D4 55
 LD (SP + 170), IY      ;; 011D:  FD D4 AA
 LD (SP + 255), IY      ;; 011D:  FD D4 FF
 EX DE', HL             ;; 0125:  E3
 EX DE, HL'             ;; 0125:  76 EB
 EX DE', HL'            ;; 0125:  76 E3
 ADD A, IXH             ;; 016D:  DD 84
 ADC A, IXH             ;; 016D:  DD 8C
 SUB IXH                ;; 016D:  DD 94
 SBC A, IXH             ;; 016D:  DD 9C
 AND IXH                ;; 016D:  DD A4
 XOR IXH                ;; 016D:  DD AC
 OR IXH                 ;; 016D:  DD B4
 CP IXH                 ;; 016D:  DD BC
 ADD A, IXL             ;; 016D:  DD 85
 ADC A, IXL             ;; 016D:  DD 8D
 SUB IXL                ;; 016D:  DD 95
 SBC A, IXL             ;; 016D:  DD 9D
 AND IXL                ;; 016D:  DD A5
 XOR IXL                ;; 016D:  DD AD
 OR IXL                 ;; 016D:  DD B5
 CP IXL                 ;; 016D:  DD BD
 ADD A, IYH             ;; 016D:  FD 84
 ADC A, IYH             ;; 016D:  FD 8C
 SUB IYH                ;; 016D:  FD 94
 SBC A, IYH             ;; 016D:  FD 9C
 AND IYH                ;; 016D:  FD A4
 XOR IYH                ;; 016D:  FD AC
 OR IYH                 ;; 016D:  FD B4
 CP IYH                 ;; 016D:  FD BC
 ADD A, IYL             ;; 016D:  FD 85
 ADC A, IYL             ;; 016D:  FD 8D
 SUB IYL                ;; 016D:  FD 95
 SBC A, IYL             ;; 016D:  FD 9D
 AND IYL                ;; 016D:  FD A5
 XOR IYL                ;; 016D:  FD AD
 OR IYL                 ;; 016D:  FD B5
 CP IYL                 ;; 016D:  FD BD
 ALTD                   ;; 02A3:  76
 LD A, XPC              ;; 02A3:  ED 77
 LD XPC, A              ;; 02A3:  ED 67
 ADD SP, -128           ;; 02B7:  27 80
 ADD SP, 0              ;; 02B7:  27 00
 ADD SP, 127            ;; 02B7:  27 7F
 AND HL, DE             ;; 02C7:  DC
 AND IX, DE             ;; 02C7:  DD DC
 AND IY, DE             ;; 02C7:  FD DC
 BOOL HL                ;; 02C7:  CC
 BOOL IX                ;; 02C7:  DD CC
 BOOL IY                ;; 02C7:  FD CC
 JP LZ, 0               ;; 084F:  E2 00 00
 JP LZ, 4660            ;; 084F:  E2 34 12
 JP LZ, 52719           ;; 084F:  E2 EF CD
 JP LZ, 65535           ;; 084F:  E2 FF FF
 JP LO, 0               ;; 084F:  EA 00 00
 JP LO, 4660            ;; 084F:  EA 34 12
 JP LO, 52719           ;; 084F:  EA EF CD
 JP LO, 65535           ;; 084F:  EA FF FF
 RET LZ                 ;; 08D5:  E0
 RET LO                 ;; 08D5:  E8
 IOE                    ;; 09D5:  DB
 IOI                    ;; 09D5:  D3
 IPSET 0                ;; 09DD:  ED 46
 IPSET 1                ;; 09DD:  ED 56
 IPSET 2                ;; 09DD:  ED 4E
 IPSET 3                ;; 09DD:  ED 5E
 IPRES                  ;; 09DD:  ED 5D
 LD IIR, A              ;; 09E5:  ED 47
 LD A, IIR              ;; 09E5:  ED 57
 LD EIR, A              ;; 09E5:  ED 4F
 LD A, EIR              ;; 09E5:  ED 5F
 IDET                   ;; 09E9:  5B
 ld b, ixh              ;; 0A1A:  DD 44
 ld b, ixl              ;; 0A1A:  DD 45
 ld c, ixh              ;; 0A1A:  DD 4C
 ld c, ixl              ;; 0A1A:  DD 4D
 ld d, ixh              ;; 0A1A:  DD 54
 ld d, ixl              ;; 0A1A:  DD 55
 ld e, ixh              ;; 0A1A:  DD 5C
 ld e, ixl              ;; 0A1A:  DD 5D
 ld ixh, ixh            ;; 0A1A:  DD 64
 ld ixh, ixl            ;; 0A1A:  DD 65
 ld ixl, ixh            ;; 0A1A:  DD 6C
 ld ixl, ixl            ;; 0A1A:  DD 6D
 ld a, ixh              ;; 0A1A:  DD 7C
 ld a, ixl              ;; 0A1A:  DD 7D
 ld b, iyh              ;; 0A1A:  FD 44
 ld b, iyl              ;; 0A1A:  FD 45
 ld c, iyh              ;; 0A1A:  FD 4C
 ld c, iyl              ;; 0A1A:  FD 4D
 ld d, iyh              ;; 0A1A:  FD 54
 ld d, iyl              ;; 0A1A:  FD 55
 ld e, iyh              ;; 0A1A:  FD 5C
 ld e, iyl              ;; 0A1A:  FD 5D
 ld iyh, iyh            ;; 0A1A:  FD 64
 ld iyh, iyl            ;; 0A1A:  FD 65
 ld iyl, iyh            ;; 0A1A:  FD 6C
 ld iyl, iyl            ;; 0A1A:  FD 6D
 ld a, iyh              ;; 0A1A:  FD 7C
 ld a, iyl              ;; 0A1A:  FD 7D
 ld ixh, 0              ;; 0A52:  DD 26 00
 ld ixh, 85             ;; 0A52:  DD 26 55
 ld ixh, 170            ;; 0A52:  DD 26 AA
 ld ixh, 255            ;; 0A52:  DD 26 FF
 ld ixl, 0              ;; 0A52:  DD 2E 00
 ld ixl, 85             ;; 0A52:  DD 2E 55
 ld ixl, 170            ;; 0A52:  DD 2E AA
 ld ixl, 255            ;; 0A52:  DD 2E FF
 ld iyh, 0              ;; 0A52:  FD 26 00
 ld iyh, 85             ;; 0A52:  FD 26 55
 ld iyh, 170            ;; 0A52:  FD 26 AA
 ld iyh, 255            ;; 0A52:  FD 26 FF
 ld iyl, 0              ;; 0A52:  FD 2E 00
 ld iyl, 85             ;; 0A52:  FD 2E 55
 ld iyl, 170            ;; 0A52:  FD 2E AA
 ld iyl, 255            ;; 0A52:  FD 2E FF
 ld bc', bc             ;; 0BEC:  ED 49
 ld bc', de             ;; 0BEC:  ED 41
 ld de', bc             ;; 0BEC:  ED 59
 ld de', de             ;; 0BEC:  ED 51
 ld hl', bc             ;; 0BEC:  ED 69
 ld hl', de             ;; 0BEC:  ED 61
