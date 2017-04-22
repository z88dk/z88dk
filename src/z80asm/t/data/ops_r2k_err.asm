 CPI                    ;; 016B:  ED A1
 CPIR                   ;; 016B:  ED B1
 CPD                    ;; 016B:  ED A9
 CPDR                   ;; 016B:  ED B9
 ADD A, IXH             ;; 01A3:  DD 84
 ADC A, IXH             ;; 01A3:  DD 8C
 SUB IXH                ;; 01A3:  DD 94
 SBC A, IXH             ;; 01A3:  DD 9C
 AND IXH                ;; 01A3:  DD A4
 XOR IXH                ;; 01A3:  DD AC
 OR IXH                 ;; 01A3:  DD B4
 CP IXH                 ;; 01A3:  DD BC
 ADD A, IXL             ;; 01A3:  DD 85
 ADC A, IXL             ;; 01A3:  DD 8D
 SUB IXL                ;; 01A3:  DD 95
 SBC A, IXL             ;; 01A3:  DD 9D
 AND IXL                ;; 01A3:  DD A5
 XOR IXL                ;; 01A3:  DD AD
 OR IXL                 ;; 01A3:  DD B5
 CP IXL                 ;; 01A3:  DD BD
 ADD A, IYH             ;; 01A3:  FD 84
 ADC A, IYH             ;; 01A3:  FD 8C
 SUB IYH                ;; 01A3:  FD 94
 SBC A, IYH             ;; 01A3:  FD 9C
 AND IYH                ;; 01A3:  FD A4
 XOR IYH                ;; 01A3:  FD AC
 OR IYH                 ;; 01A3:  FD B4
 CP IYH                 ;; 01A3:  FD BC
 ADD A, IYL             ;; 01A3:  FD 85
 ADC A, IYL             ;; 01A3:  FD 8D
 SUB IYL                ;; 01A3:  FD 95
 SBC A, IYL             ;; 01A3:  FD 9D
 AND IYL                ;; 01A3:  FD A5
 XOR IYL                ;; 01A3:  FD AD
 OR IYL                 ;; 01A3:  FD B5
 CP IYL                 ;; 01A3:  FD BD
 DAA                    ;; 02CB:  27
 RLD                    ;; 02CB:  ED 6F
 RRD                    ;; 02CB:  ED 67
 HALT                   ;; 02D1:  76
 SLP                    ;; 02D1:  ED 76
 MLT SP                 ;; 0320:  ED 7C
 SLL B                  ;; 0386:  CB 30
 SLL C                  ;; 0386:  CB 31
 SLL D                  ;; 0386:  CB 32
 SLL E                  ;; 0386:  CB 33
 SLL H                  ;; 0386:  CB 34
 SLL L                  ;; 0386:  CB 35
 SLL A                  ;; 0386:  CB 37
 SLL (HL)               ;; 0394:  CB 36
 SLL (IX + -128)        ;; 043C:  DD CB 80 36
 SLL (IX + 0)           ;; 043C:  DD CB 00 36
 SLL (IX + 127)         ;; 043C:  DD CB 7F 36
 SLL (IY + -128)        ;; 043C:  FD CB 80 36
 SLL (IY + 0)           ;; 043C:  FD CB 00 36
 SLL (IY + 127)         ;; 043C:  FD CB 7F 36
 CALL NZ, 0             ;; 089D:  C4 00 00
 CALL NZ, 4660          ;; 089D:  C4 34 12
 CALL NZ, 52719         ;; 089D:  C4 EF CD
 CALL NZ, 65535         ;; 089D:  C4 FF FF
 CALL Z, 0              ;; 089D:  CC 00 00
 CALL Z, 4660           ;; 089D:  CC 34 12
 CALL Z, 52719          ;; 089D:  CC EF CD
 CALL Z, 65535          ;; 089D:  CC FF FF
 CALL NC, 0             ;; 089D:  D4 00 00
 CALL NC, 4660          ;; 089D:  D4 34 12
 CALL NC, 52719         ;; 089D:  D4 EF CD
 CALL NC, 65535         ;; 089D:  D4 FF FF
 CALL C, 0              ;; 089D:  DC 00 00
 CALL C, 4660           ;; 089D:  DC 34 12
 CALL C, 52719          ;; 089D:  DC EF CD
 CALL C, 65535          ;; 089D:  DC FF FF
 CALL PO, 0             ;; 089D:  E4 00 00
 CALL PO, 4660          ;; 089D:  E4 34 12
 CALL PO, 52719         ;; 089D:  E4 EF CD
 CALL PO, 65535         ;; 089D:  E4 FF FF
 CALL PE, 0             ;; 089D:  EC 00 00
 CALL PE, 4660          ;; 089D:  EC 34 12
 CALL PE, 52719         ;; 089D:  EC EF CD
 CALL PE, 65535         ;; 089D:  EC FF FF
 CALL P, 0              ;; 089D:  F4 00 00
 CALL P, 4660           ;; 089D:  F4 34 12
 CALL P, 52719          ;; 089D:  F4 EF CD
 CALL P, 65535          ;; 089D:  F4 FF FF
 CALL M, 0              ;; 089D:  FC 00 00
 CALL M, 4660           ;; 089D:  FC 34 12
 CALL M, 52719          ;; 089D:  FC EF CD
 CALL M, 65535          ;; 089D:  FC FF FF
 RST 0                  ;; 08AD:  C7
 RST 8                  ;; 08AD:  CF
 RST 48                 ;; 08AD:  F7
 IN A, (0)              ;; 08AD:  DB 00
 IN A, (85)             ;; 08AD:  DB 55
 IN A, (170)            ;; 08AD:  DB AA
 IN A, (255)            ;; 08AD:  DB FF
 IN B, (C)              ;; 08AD:  ED 40
 IN C, (C)              ;; 08AD:  ED 48
 IN D, (C)              ;; 08AD:  ED 50
 IN E, (C)              ;; 08AD:  ED 58
 IN H, (C)              ;; 08AD:  ED 60
 IN L, (C)              ;; 08AD:  ED 68
 IN A, (C)              ;; 08AD:  ED 78
 INI                    ;; 08AD:  ED A2
 INIR                   ;; 08AD:  ED B2
 IND                    ;; 08AD:  ED AA
 INDR                   ;; 08AD:  ED BA
 OUT (0), A             ;; 08AD:  D3 00
 OUT (85), A            ;; 08AD:  D3 55
 OUT (170), A           ;; 08AD:  D3 AA
 OUT (255), A           ;; 08AD:  D3 FF
 OUT (C), B             ;; 08AD:  ED 41
 OUT (C), C             ;; 08AD:  ED 49
 OUT (C), D             ;; 08AD:  ED 51
 OUT (C), E             ;; 08AD:  ED 59
 OUT (C), H             ;; 08AD:  ED 61
 OUT (C), L             ;; 08AD:  ED 69
 OUT (C), A             ;; 08AD:  ED 79
 OUTI                   ;; 08AD:  ED A3
 OTIR                   ;; 08AD:  ED B3
 OUTD                   ;; 08AD:  ED AB
 OTDR                   ;; 08AD:  ED BB
 IN0 B, (0)             ;; 08AD:  ED 00 00
 IN0 B, (85)            ;; 08AD:  ED 00 55
 IN0 B, (170)           ;; 08AD:  ED 00 AA
 IN0 B, (255)           ;; 08AD:  ED 00 FF
 IN0 C, (0)             ;; 08AD:  ED 08 00
 IN0 C, (85)            ;; 08AD:  ED 08 55
 IN0 C, (170)           ;; 08AD:  ED 08 AA
 IN0 C, (255)           ;; 08AD:  ED 08 FF
 IN0 D, (0)             ;; 08AD:  ED 10 00
 IN0 D, (85)            ;; 08AD:  ED 10 55
 IN0 D, (170)           ;; 08AD:  ED 10 AA
 IN0 D, (255)           ;; 08AD:  ED 10 FF
 IN0 E, (0)             ;; 08AD:  ED 18 00
 IN0 E, (85)            ;; 08AD:  ED 18 55
 IN0 E, (170)           ;; 08AD:  ED 18 AA
 IN0 E, (255)           ;; 08AD:  ED 18 FF
 IN0 H, (0)             ;; 08AD:  ED 20 00
 IN0 H, (85)            ;; 08AD:  ED 20 55
 IN0 H, (170)           ;; 08AD:  ED 20 AA
 IN0 H, (255)           ;; 08AD:  ED 20 FF
 IN0 L, (0)             ;; 08AD:  ED 28 00
 IN0 L, (85)            ;; 08AD:  ED 28 55
 IN0 L, (170)           ;; 08AD:  ED 28 AA
 IN0 L, (255)           ;; 08AD:  ED 28 FF
 IN0 A, (0)             ;; 08AD:  ED 38 00
 IN0 A, (85)            ;; 08AD:  ED 38 55
 IN0 A, (170)           ;; 08AD:  ED 38 AA
 IN0 A, (255)           ;; 08AD:  ED 38 FF
 OUT0 (0), B            ;; 08AD:  ED 01 00
 OUT0 (85), B           ;; 08AD:  ED 01 55
 OUT0 (170), B          ;; 08AD:  ED 01 AA
 OUT0 (255), B          ;; 08AD:  ED 01 FF
 OUT0 (0), C            ;; 08AD:  ED 09 00
 OUT0 (85), C           ;; 08AD:  ED 09 55
 OUT0 (170), C          ;; 08AD:  ED 09 AA
 OUT0 (255), C          ;; 08AD:  ED 09 FF
 OUT0 (0), D            ;; 08AD:  ED 11 00
 OUT0 (85), D           ;; 08AD:  ED 11 55
 OUT0 (170), D          ;; 08AD:  ED 11 AA
 OUT0 (255), D          ;; 08AD:  ED 11 FF
 OUT0 (0), E            ;; 08AD:  ED 19 00
 OUT0 (85), E           ;; 08AD:  ED 19 55
 OUT0 (170), E          ;; 08AD:  ED 19 AA
 OUT0 (255), E          ;; 08AD:  ED 19 FF
 OUT0 (0), H            ;; 08AD:  ED 21 00
 OUT0 (85), H           ;; 08AD:  ED 21 55
 OUT0 (170), H          ;; 08AD:  ED 21 AA
 OUT0 (255), H          ;; 08AD:  ED 21 FF
 OUT0 (0), L            ;; 08AD:  ED 29 00
 OUT0 (85), L           ;; 08AD:  ED 29 55
 OUT0 (170), L          ;; 08AD:  ED 29 AA
 OUT0 (255), L          ;; 08AD:  ED 29 FF
 OUT0 (0), A            ;; 08AD:  ED 39 00
 OUT0 (85), A           ;; 08AD:  ED 39 55
 OUT0 (170), A          ;; 08AD:  ED 39 AA
 OUT0 (255), A          ;; 08AD:  ED 39 FF
 OTDM                   ;; 08AD:  ED 8B
 OTDMR                  ;; 08AD:  ED 9B
 OTIM                   ;; 08AD:  ED 83
 OTIMR                  ;; 08AD:  ED 93
 TSTIO 0                ;; 08AD:  ED 74 00
 TSTIO 85               ;; 08AD:  ED 74 55
 TSTIO 170              ;; 08AD:  ED 74 AA
 TSTIO 255              ;; 08AD:  ED 74 FF
 DI                     ;; 08AF:  F3
 EI                     ;; 08AF:  FB
 IM 0                   ;; 08AF:  ED 46
 IM 1                   ;; 08AF:  ED 56
 IM 2                   ;; 08AF:  ED 5E
 LD I, A                ;; 08B9:  ED 47
 LD A, I                ;; 08B9:  ED 57
 LD R, A                ;; 08B9:  ED 4F
 LD A, R                ;; 08B9:  ED 5F
 RETN                   ;; 08C3:  ED 45
 IDET                   ;; 08C3:  5B
 ld b, ixh              ;; 08F4:  DD 44
 ld b, ixl              ;; 08F4:  DD 45
 ld c, ixh              ;; 08F4:  DD 4C
 ld c, ixl              ;; 08F4:  DD 4D
 ld d, ixh              ;; 08F4:  DD 54
 ld d, ixl              ;; 08F4:  DD 55
 ld e, ixh              ;; 08F4:  DD 5C
 ld e, ixl              ;; 08F4:  DD 5D
 ld ixh, ixh            ;; 08F4:  DD 64
 ld ixh, ixl            ;; 08F4:  DD 65
 ld ixl, ixh            ;; 08F4:  DD 6C
 ld ixl, ixl            ;; 08F4:  DD 6D
 ld a, ixh              ;; 08F4:  DD 7C
 ld a, ixl              ;; 08F4:  DD 7D
 ld b, iyh              ;; 08F4:  FD 44
 ld b, iyl              ;; 08F4:  FD 45
 ld c, iyh              ;; 08F4:  FD 4C
 ld c, iyl              ;; 08F4:  FD 4D
 ld d, iyh              ;; 08F4:  FD 54
 ld d, iyl              ;; 08F4:  FD 55
 ld e, iyh              ;; 08F4:  FD 5C
 ld e, iyl              ;; 08F4:  FD 5D
 ld iyh, iyh            ;; 08F4:  FD 64
 ld iyh, iyl            ;; 08F4:  FD 65
 ld iyl, iyh            ;; 08F4:  FD 6C
 ld iyl, iyl            ;; 08F4:  FD 6D
 ld a, iyh              ;; 08F4:  FD 7C
 ld a, iyl              ;; 08F4:  FD 7D
 ld ixh, 0              ;; 092C:  DD 26 00
 ld ixh, 85             ;; 092C:  DD 26 55
 ld ixh, 170            ;; 092C:  DD 26 AA
 ld ixh, 255            ;; 092C:  DD 26 FF
 ld ixl, 0              ;; 092C:  DD 2E 00
 ld ixl, 85             ;; 092C:  DD 2E 55
 ld ixl, 170            ;; 092C:  DD 2E AA
 ld ixl, 255            ;; 092C:  DD 2E FF
 ld iyh, 0              ;; 092C:  FD 26 00
 ld iyh, 85             ;; 092C:  FD 26 55
 ld iyh, 170            ;; 092C:  FD 26 AA
 ld iyh, 255            ;; 092C:  FD 26 FF
 ld iyl, 0              ;; 092C:  FD 2E 00
 ld iyl, 85             ;; 092C:  FD 2E 55
 ld iyl, 170            ;; 092C:  FD 2E AA
 ld iyl, 255            ;; 092C:  FD 2E FF
