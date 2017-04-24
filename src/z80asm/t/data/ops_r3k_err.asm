 CPI                    ;; 0000:  ED A1
 CPIR                   ;; 0000:  ED B1
 CPD                    ;; 0000:  ED A9
 CPDR                   ;; 0000:  ED B9
 ADD A, IXH             ;; 0038:  DD 84
 ADC A, IXH             ;; 0038:  DD 8C
 SUB IXH                ;; 0038:  DD 94
 SBC A, IXH             ;; 0038:  DD 9C
 AND IXH                ;; 0038:  DD A4
 XOR IXH                ;; 0038:  DD AC
 OR IXH                 ;; 0038:  DD B4
 CP IXH                 ;; 0038:  DD BC
 ADD A, IXL             ;; 0038:  DD 85
 ADC A, IXL             ;; 0038:  DD 8D
 SUB IXL                ;; 0038:  DD 95
 SBC A, IXL             ;; 0038:  DD 9D
 AND IXL                ;; 0038:  DD A5
 XOR IXL                ;; 0038:  DD AD
 OR IXL                 ;; 0038:  DD B5
 CP IXL                 ;; 0038:  DD BD
 ADD A, IYH             ;; 0038:  FD 84
 ADC A, IYH             ;; 0038:  FD 8C
 SUB IYH                ;; 0038:  FD 94
 SBC A, IYH             ;; 0038:  FD 9C
 AND IYH                ;; 0038:  FD A4
 XOR IYH                ;; 0038:  FD AC
 OR IYH                 ;; 0038:  FD B4
 CP IYH                 ;; 0038:  FD BC
 ADD A, IYL             ;; 0038:  FD 85
 ADC A, IYL             ;; 0038:  FD 8D
 SUB IYL                ;; 0038:  FD 95
 SBC A, IYL             ;; 0038:  FD 9D
 AND IYL                ;; 0038:  FD A5
 XOR IYL                ;; 0038:  FD AD
 OR IYL                 ;; 0038:  FD B5
 CP IYL                 ;; 0038:  FD BD
 DAA                    ;; 0160:  27
 RLD                    ;; 0160:  ED 6F
 RRD                    ;; 0160:  ED 67
 HALT                   ;; 0166:  76
 SLP                    ;; 0166:  ED 76
 MLT SP                 ;; 01B5:  ED 7C
 SLL B                  ;; 021B:  CB 30
 SLL C                  ;; 021B:  CB 31
 SLL D                  ;; 021B:  CB 32
 SLL E                  ;; 021B:  CB 33
 SLL H                  ;; 021B:  CB 34
 SLL L                  ;; 021B:  CB 35
 SLL A                  ;; 021B:  CB 37
 SLL (HL)               ;; 0229:  CB 36
 SLL (IX + -128)        ;; 02D1:  DD CB 80 36
 SLL (IX + 0)           ;; 02D1:  DD CB 00 36
 SLL (IX + 127)         ;; 02D1:  DD CB 7F 36
 SLL (IY + -128)        ;; 02D1:  FD CB 80 36
 SLL (IY + 0)           ;; 02D1:  FD CB 00 36
 SLL (IY + 127)         ;; 02D1:  FD CB 7F 36
 CALL NZ, 0             ;; 0732:  C4 00 00
 CALL NZ, 4660          ;; 0732:  C4 34 12
 CALL NZ, 52719         ;; 0732:  C4 EF CD
 CALL NZ, 65535         ;; 0732:  C4 FF FF
 CALL Z, 0              ;; 0732:  CC 00 00
 CALL Z, 4660           ;; 0732:  CC 34 12
 CALL Z, 52719          ;; 0732:  CC EF CD
 CALL Z, 65535          ;; 0732:  CC FF FF
 CALL NC, 0             ;; 0732:  D4 00 00
 CALL NC, 4660          ;; 0732:  D4 34 12
 CALL NC, 52719         ;; 0732:  D4 EF CD
 CALL NC, 65535         ;; 0732:  D4 FF FF
 CALL C, 0              ;; 0732:  DC 00 00
 CALL C, 4660           ;; 0732:  DC 34 12
 CALL C, 52719          ;; 0732:  DC EF CD
 CALL C, 65535          ;; 0732:  DC FF FF
 CALL PO, 0             ;; 0732:  E4 00 00
 CALL PO, 4660          ;; 0732:  E4 34 12
 CALL PO, 52719         ;; 0732:  E4 EF CD
 CALL PO, 65535         ;; 0732:  E4 FF FF
 CALL PE, 0             ;; 0732:  EC 00 00
 CALL PE, 4660          ;; 0732:  EC 34 12
 CALL PE, 52719         ;; 0732:  EC EF CD
 CALL PE, 65535         ;; 0732:  EC FF FF
 CALL P, 0              ;; 0732:  F4 00 00
 CALL P, 4660           ;; 0732:  F4 34 12
 CALL P, 52719          ;; 0732:  F4 EF CD
 CALL P, 65535          ;; 0732:  F4 FF FF
 CALL M, 0              ;; 0732:  FC 00 00
 CALL M, 4660           ;; 0732:  FC 34 12
 CALL M, 52719          ;; 0732:  FC EF CD
 CALL M, 65535          ;; 0732:  FC FF FF
 RST 0                  ;; 0742:  C7
 RST 8                  ;; 0742:  CF
 RST 48                 ;; 0742:  F7
 IN A, (0)              ;; 0742:  DB 00
 IN A, (85)             ;; 0742:  DB 55
 IN A, (170)            ;; 0742:  DB AA
 IN A, (255)            ;; 0742:  DB FF
 IN B, (C)              ;; 0742:  ED 40
 IN C, (C)              ;; 0742:  ED 48
 IN D, (C)              ;; 0742:  ED 50
 IN E, (C)              ;; 0742:  ED 58
 IN H, (C)              ;; 0742:  ED 60
 IN L, (C)              ;; 0742:  ED 68
 IN A, (C)              ;; 0742:  ED 78
 INI                    ;; 0742:  ED A2
 INIR                   ;; 0742:  ED B2
 IND                    ;; 0742:  ED AA
 INDR                   ;; 0742:  ED BA
 OUT (0), A             ;; 0742:  D3 00
 OUT (85), A            ;; 0742:  D3 55
 OUT (170), A           ;; 0742:  D3 AA
 OUT (255), A           ;; 0742:  D3 FF
 OUT (C), B             ;; 0742:  ED 41
 OUT (C), C             ;; 0742:  ED 49
 OUT (C), D             ;; 0742:  ED 51
 OUT (C), E             ;; 0742:  ED 59
 OUT (C), H             ;; 0742:  ED 61
 OUT (C), L             ;; 0742:  ED 69
 OUT (C), A             ;; 0742:  ED 79
 OUTI                   ;; 0742:  ED A3
 OTIR                   ;; 0742:  ED B3
 OUTD                   ;; 0742:  ED AB
 OTDR                   ;; 0742:  ED BB
 IN0 B, (0)             ;; 0742:  ED 00 00
 IN0 B, (85)            ;; 0742:  ED 00 55
 IN0 B, (170)           ;; 0742:  ED 00 AA
 IN0 B, (255)           ;; 0742:  ED 00 FF
 IN0 C, (0)             ;; 0742:  ED 08 00
 IN0 C, (85)            ;; 0742:  ED 08 55
 IN0 C, (170)           ;; 0742:  ED 08 AA
 IN0 C, (255)           ;; 0742:  ED 08 FF
 IN0 D, (0)             ;; 0742:  ED 10 00
 IN0 D, (85)            ;; 0742:  ED 10 55
 IN0 D, (170)           ;; 0742:  ED 10 AA
 IN0 D, (255)           ;; 0742:  ED 10 FF
 IN0 E, (0)             ;; 0742:  ED 18 00
 IN0 E, (85)            ;; 0742:  ED 18 55
 IN0 E, (170)           ;; 0742:  ED 18 AA
 IN0 E, (255)           ;; 0742:  ED 18 FF
 IN0 H, (0)             ;; 0742:  ED 20 00
 IN0 H, (85)            ;; 0742:  ED 20 55
 IN0 H, (170)           ;; 0742:  ED 20 AA
 IN0 H, (255)           ;; 0742:  ED 20 FF
 IN0 L, (0)             ;; 0742:  ED 28 00
 IN0 L, (85)            ;; 0742:  ED 28 55
 IN0 L, (170)           ;; 0742:  ED 28 AA
 IN0 L, (255)           ;; 0742:  ED 28 FF
 IN0 A, (0)             ;; 0742:  ED 38 00
 IN0 A, (85)            ;; 0742:  ED 38 55
 IN0 A, (170)           ;; 0742:  ED 38 AA
 IN0 A, (255)           ;; 0742:  ED 38 FF
 OUT0 (0), B            ;; 0742:  ED 01 00
 OUT0 (85), B           ;; 0742:  ED 01 55
 OUT0 (170), B          ;; 0742:  ED 01 AA
 OUT0 (255), B          ;; 0742:  ED 01 FF
 OUT0 (0), C            ;; 0742:  ED 09 00
 OUT0 (85), C           ;; 0742:  ED 09 55
 OUT0 (170), C          ;; 0742:  ED 09 AA
 OUT0 (255), C          ;; 0742:  ED 09 FF
 OUT0 (0), D            ;; 0742:  ED 11 00
 OUT0 (85), D           ;; 0742:  ED 11 55
 OUT0 (170), D          ;; 0742:  ED 11 AA
 OUT0 (255), D          ;; 0742:  ED 11 FF
 OUT0 (0), E            ;; 0742:  ED 19 00
 OUT0 (85), E           ;; 0742:  ED 19 55
 OUT0 (170), E          ;; 0742:  ED 19 AA
 OUT0 (255), E          ;; 0742:  ED 19 FF
 OUT0 (0), H            ;; 0742:  ED 21 00
 OUT0 (85), H           ;; 0742:  ED 21 55
 OUT0 (170), H          ;; 0742:  ED 21 AA
 OUT0 (255), H          ;; 0742:  ED 21 FF
 OUT0 (0), L            ;; 0742:  ED 29 00
 OUT0 (85), L           ;; 0742:  ED 29 55
 OUT0 (170), L          ;; 0742:  ED 29 AA
 OUT0 (255), L          ;; 0742:  ED 29 FF
 OUT0 (0), A            ;; 0742:  ED 39 00
 OUT0 (85), A           ;; 0742:  ED 39 55
 OUT0 (170), A          ;; 0742:  ED 39 AA
 OUT0 (255), A          ;; 0742:  ED 39 FF
 OTDM                   ;; 0742:  ED 8B
 OTDMR                  ;; 0742:  ED 9B
 OTIM                   ;; 0742:  ED 83
 OTIMR                  ;; 0742:  ED 93
 TSTIO 0                ;; 0742:  ED 74 00
 TSTIO 85               ;; 0742:  ED 74 55
 TSTIO 170              ;; 0742:  ED 74 AA
 TSTIO 255              ;; 0742:  ED 74 FF
 DI                     ;; 0744:  F3
 EI                     ;; 0744:  FB
 IM 0                   ;; 0744:  ED 46
 IM 1                   ;; 0744:  ED 56
 IM 2                   ;; 0744:  ED 5E
 LD I, A                ;; 074E:  ED 47
 LD A, I                ;; 074E:  ED 57
 LD R, A                ;; 074E:  ED 4F
 LD A, R                ;; 074E:  ED 5F
 RETN                   ;; 0758:  ED 45
 ld b, ixh              ;; 078A:  DD 44
 ld b, ixl              ;; 078A:  DD 45
 ld c, ixh              ;; 078A:  DD 4C
 ld c, ixl              ;; 078A:  DD 4D
 ld d, ixh              ;; 078A:  DD 54
 ld d, ixl              ;; 078A:  DD 55
 ld e, ixh              ;; 078A:  DD 5C
 ld e, ixl              ;; 078A:  DD 5D
 ld ixh, ixh            ;; 078A:  DD 64
 ld ixh, ixl            ;; 078A:  DD 65
 ld ixl, ixh            ;; 078A:  DD 6C
 ld ixl, ixl            ;; 078A:  DD 6D
 ld a, ixh              ;; 078A:  DD 7C
 ld a, ixl              ;; 078A:  DD 7D
 ld b, iyh              ;; 078A:  FD 44
 ld b, iyl              ;; 078A:  FD 45
 ld c, iyh              ;; 078A:  FD 4C
 ld c, iyl              ;; 078A:  FD 4D
 ld d, iyh              ;; 078A:  FD 54
 ld d, iyl              ;; 078A:  FD 55
 ld e, iyh              ;; 078A:  FD 5C
 ld e, iyl              ;; 078A:  FD 5D
 ld iyh, iyh            ;; 078A:  FD 64
 ld iyh, iyl            ;; 078A:  FD 65
 ld iyl, iyh            ;; 078A:  FD 6C
 ld iyl, iyl            ;; 078A:  FD 6D
 ld a, iyh              ;; 078A:  FD 7C
 ld a, iyl              ;; 078A:  FD 7D
 ld ixh, 0              ;; 07C2:  DD 26 00
 ld ixh, 85             ;; 07C2:  DD 26 55
 ld ixh, 170            ;; 07C2:  DD 26 AA
 ld ixh, 255            ;; 07C2:  DD 26 FF
 ld ixl, 0              ;; 07C2:  DD 2E 00
 ld ixl, 85             ;; 07C2:  DD 2E 55
 ld ixl, 170            ;; 07C2:  DD 2E AA
 ld ixl, 255            ;; 07C2:  DD 2E FF
 ld iyh, 0              ;; 07C2:  FD 26 00
 ld iyh, 85             ;; 07C2:  FD 26 55
 ld iyh, 170            ;; 07C2:  FD 26 AA
 ld iyh, 255            ;; 07C2:  FD 26 FF
 ld iyl, 0              ;; 07C2:  FD 2E 00
 ld iyl, 85             ;; 07C2:  FD 2E 55
 ld iyl, 170            ;; 07C2:  FD 2E AA
 ld iyl, 255            ;; 07C2:  FD 2E FF
 cpi                    ;; 0B58:  ED A1
 cpir                   ;; 0B58:  ED B1
 cpd                    ;; 0B58:  ED A9
 cpdr                   ;; 0B58:  ED B9
