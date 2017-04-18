 LD B, IXH              ;; 0031:  DD 44
 LD B, IXL              ;; 0031:  DD 45
 LD B, IYH              ;; 0031:  FD 44
 LD B, IYL              ;; 0031:  FD 45
 LD C, IXH              ;; 0031:  DD 4C
 LD C, IXL              ;; 0031:  DD 4D
 LD C, IYH              ;; 0031:  FD 4C
 LD C, IYL              ;; 0031:  FD 4D
 LD D, IXH              ;; 0031:  DD 54
 LD D, IXL              ;; 0031:  DD 55
 LD D, IYH              ;; 0031:  FD 54
 LD D, IYL              ;; 0031:  FD 55
 LD E, IXH              ;; 0031:  DD 5C
 LD E, IXL              ;; 0031:  DD 5D
 LD E, IYH              ;; 0031:  FD 5C
 LD E, IYL              ;; 0031:  FD 5D
 LD IXH, IXH            ;; 0031:  DD 64
 LD IXH, IXL            ;; 0031:  DD 65
 LD IYH, IYH            ;; 0031:  FD 64
 LD IYH, IYL            ;; 0031:  FD 65
 LD IXL, IXH            ;; 0031:  DD 6C
 LD IXL, IXL            ;; 0031:  DD 6D
 LD IYL, IYH            ;; 0031:  FD 6C
 LD IYL, IYL            ;; 0031:  FD 6D
 LD A, IXH              ;; 0031:  DD 7C
 LD A, IXL              ;; 0031:  DD 7D
 LD A, IYH              ;; 0031:  FD 7C
 LD A, IYL              ;; 0031:  FD 7D
 LD IXH, 0              ;; 0069:  DD 26 00
 LD IXH, 85             ;; 0069:  DD 26 55
 LD IXH, 170            ;; 0069:  DD 26 AA
 LD IXH, 255            ;; 0069:  DD 26 FF
 LD IXL, 0              ;; 0069:  DD 2E 00
 LD IXL, 85             ;; 0069:  DD 2E 55
 LD IXL, 170            ;; 0069:  DD 2E AA
 LD IXL, 255            ;; 0069:  DD 2E FF
 LD IYH, 0              ;; 0069:  FD 26 00
 LD IYH, 85             ;; 0069:  FD 26 55
 LD IYH, 170            ;; 0069:  FD 26 AA
 LD IYH, 255            ;; 0069:  FD 26 FF
 LD IYL, 0              ;; 0069:  FD 2E 00
 LD IYL, 85             ;; 0069:  FD 2E 55
 LD IYL, 170            ;; 0069:  FD 2E AA
 LD IYL, 255            ;; 0069:  FD 2E FF
 CPI                    ;; 032A:  ED A1
 CPIR                   ;; 032A:  ED B1
 CPD                    ;; 032A:  ED A9
 CPDR                   ;; 032A:  ED B9
 ADD A, IXH             ;; 0362:  DD 84
 ADC A, IXH             ;; 0362:  DD 8C
 SUB IXH                ;; 0362:  DD 94
 SBC A, IXH             ;; 0362:  DD 9C
 AND IXH                ;; 0362:  DD A4
 XOR IXH                ;; 0362:  DD AC
 OR IXH                 ;; 0362:  DD B4
 CP IXH                 ;; 0362:  DD BC
 ADD A, IXL             ;; 0362:  DD 85
 ADC A, IXL             ;; 0362:  DD 8D
 SUB IXL                ;; 0362:  DD 95
 SBC A, IXL             ;; 0362:  DD 9D
 AND IXL                ;; 0362:  DD A5
 XOR IXL                ;; 0362:  DD AD
 OR IXL                 ;; 0362:  DD B5
 CP IXL                 ;; 0362:  DD BD
 ADD A, IYH             ;; 0362:  FD 84
 ADC A, IYH             ;; 0362:  FD 8C
 SUB IYH                ;; 0362:  FD 94
 SBC A, IYH             ;; 0362:  FD 9C
 AND IYH                ;; 0362:  FD A4
 XOR IYH                ;; 0362:  FD AC
 OR IYH                 ;; 0362:  FD B4
 CP IYH                 ;; 0362:  FD BC
 ADD A, IYL             ;; 0362:  FD 85
 ADC A, IYL             ;; 0362:  FD 8D
 SUB IYL                ;; 0362:  FD 95
 SBC A, IYL             ;; 0362:  FD 9D
 AND IYL                ;; 0362:  FD A5
 XOR IYL                ;; 0362:  FD AD
 OR IYL                 ;; 0362:  FD B5
 CP IYL                 ;; 0362:  FD BD
 DAA                    ;; 048A:  27
 RLD                    ;; 048A:  ED 6F
 RRD                    ;; 048A:  ED 67
 HALT                   ;; 0490:  76
 SLP                    ;; 0490:  ED 76
 MLT SP                 ;; 04DB:  ED 7C
 SLL B                  ;; 0541:  CB 30
 SLL C                  ;; 0541:  CB 31
 SLL D                  ;; 0541:  CB 32
 SLL E                  ;; 0541:  CB 33
 SLL H                  ;; 0541:  CB 34
 SLL L                  ;; 0541:  CB 35
 SLL A                  ;; 0541:  CB 37
 SLL (HL)               ;; 054F:  CB 36
 SLL (IX + -128)        ;; 05F7:  DD CB 80 36
 SLL (IX + 0)           ;; 05F7:  DD CB 00 36
 SLL (IX + 127)         ;; 05F7:  DD CB 7F 36
 SLL (IY + -128)        ;; 05F7:  FD CB 80 36
 SLL (IY + 0)           ;; 05F7:  FD CB 00 36
 SLL (IY + 127)         ;; 05F7:  FD CB 7F 36
 JP PO, 0               ;; 0A0B:  E2 00 00
 JP PO, 4660            ;; 0A0B:  E2 34 12
 JP PO, 52719           ;; 0A0B:  E2 EF CD
 JP PO, 65535           ;; 0A0B:  E2 FF FF
 JP PE, 0               ;; 0A0B:  EA 00 00
 JP PE, 4660            ;; 0A0B:  EA 34 12
 JP PE, 52719           ;; 0A0B:  EA EF CD
 JP PE, 65535           ;; 0A0B:  EA FF FF
 CALL NZ, 0             ;; 0A40:  C4 00 00
 CALL NZ, 4660          ;; 0A40:  C4 34 12
 CALL NZ, 52719         ;; 0A40:  C4 EF CD
 CALL NZ, 65535         ;; 0A40:  C4 FF FF
 CALL Z, 0              ;; 0A40:  CC 00 00
 CALL Z, 4660           ;; 0A40:  CC 34 12
 CALL Z, 52719          ;; 0A40:  CC EF CD
 CALL Z, 65535          ;; 0A40:  CC FF FF
 CALL NC, 0             ;; 0A40:  D4 00 00
 CALL NC, 4660          ;; 0A40:  D4 34 12
 CALL NC, 52719         ;; 0A40:  D4 EF CD
 CALL NC, 65535         ;; 0A40:  D4 FF FF
 CALL C, 0              ;; 0A40:  DC 00 00
 CALL C, 4660           ;; 0A40:  DC 34 12
 CALL C, 52719          ;; 0A40:  DC EF CD
 CALL C, 65535          ;; 0A40:  DC FF FF
 CALL P, 0              ;; 0A40:  F4 00 00
 CALL P, 4660           ;; 0A40:  F4 34 12
 CALL P, 52719          ;; 0A40:  F4 EF CD
 CALL P, 65535          ;; 0A40:  F4 FF FF
 CALL M, 0              ;; 0A40:  FC 00 00
 CALL M, 4660           ;; 0A40:  FC 34 12
 CALL M, 52719          ;; 0A40:  FC EF CD
 CALL M, 65535          ;; 0A40:  FC FF FF
 RET PO                 ;; 0A47:  E0
 RET PE                 ;; 0A47:  E8
 RST 0                  ;; 0A4E:  C7
 RST 8                  ;; 0A4E:  CF
 RST 48                 ;; 0A4E:  F7
 IN A, (0)              ;; 0A4E:  DB 00
 IN A, (85)             ;; 0A4E:  DB 55
 IN A, (170)            ;; 0A4E:  DB AA
 IN A, (255)            ;; 0A4E:  DB FF
 IN B, (C)              ;; 0A4E:  ED 40
 IN C, (C)              ;; 0A4E:  ED 48
 IN D, (C)              ;; 0A4E:  ED 50
 IN E, (C)              ;; 0A4E:  ED 58
 IN H, (C)              ;; 0A4E:  ED 60
 IN L, (C)              ;; 0A4E:  ED 68
 IN A, (C)              ;; 0A4E:  ED 78
 INI                    ;; 0A4E:  ED A2
 INIR                   ;; 0A4E:  ED B2
 IND                    ;; 0A4E:  ED AA
 INDR                   ;; 0A4E:  ED BA
 OUT (0), A             ;; 0A4E:  D3 00
 OUT (85), A            ;; 0A4E:  D3 55
 OUT (170), A           ;; 0A4E:  D3 AA
 OUT (255), A           ;; 0A4E:  D3 FF
 OUT (C), B             ;; 0A4E:  ED 41
 OUT (C), C             ;; 0A4E:  ED 49
 OUT (C), D             ;; 0A4E:  ED 51
 OUT (C), E             ;; 0A4E:  ED 59
 OUT (C), H             ;; 0A4E:  ED 61
 OUT (C), L             ;; 0A4E:  ED 69
 OUT (C), A             ;; 0A4E:  ED 79
 OUTI                   ;; 0A4E:  ED A3
 OTIR                   ;; 0A4E:  ED B3
 OUTD                   ;; 0A4E:  ED AB
 OTDR                   ;; 0A4E:  ED BB
 IN0 B, (0)             ;; 0A4E:  ED 00 00
 IN0 B, (85)            ;; 0A4E:  ED 00 55
 IN0 B, (170)           ;; 0A4E:  ED 00 AA
 IN0 B, (255)           ;; 0A4E:  ED 00 FF
 IN0 C, (0)             ;; 0A4E:  ED 08 00
 IN0 C, (85)            ;; 0A4E:  ED 08 55
 IN0 C, (170)           ;; 0A4E:  ED 08 AA
 IN0 C, (255)           ;; 0A4E:  ED 08 FF
 IN0 D, (0)             ;; 0A4E:  ED 10 00
 IN0 D, (85)            ;; 0A4E:  ED 10 55
 IN0 D, (170)           ;; 0A4E:  ED 10 AA
 IN0 D, (255)           ;; 0A4E:  ED 10 FF
 IN0 E, (0)             ;; 0A4E:  ED 18 00
 IN0 E, (85)            ;; 0A4E:  ED 18 55
 IN0 E, (170)           ;; 0A4E:  ED 18 AA
 IN0 E, (255)           ;; 0A4E:  ED 18 FF
 IN0 H, (0)             ;; 0A4E:  ED 20 00
 IN0 H, (85)            ;; 0A4E:  ED 20 55
 IN0 H, (170)           ;; 0A4E:  ED 20 AA
 IN0 H, (255)           ;; 0A4E:  ED 20 FF
 IN0 L, (0)             ;; 0A4E:  ED 28 00
 IN0 L, (85)            ;; 0A4E:  ED 28 55
 IN0 L, (170)           ;; 0A4E:  ED 28 AA
 IN0 L, (255)           ;; 0A4E:  ED 28 FF
 IN0 A, (0)             ;; 0A4E:  ED 38 00
 IN0 A, (85)            ;; 0A4E:  ED 38 55
 IN0 A, (170)           ;; 0A4E:  ED 38 AA
 IN0 A, (255)           ;; 0A4E:  ED 38 FF
 OUT0 (0), B            ;; 0A4E:  ED 01 00
 OUT0 (85), B           ;; 0A4E:  ED 01 55
 OUT0 (170), B          ;; 0A4E:  ED 01 AA
 OUT0 (255), B          ;; 0A4E:  ED 01 FF
 OUT0 (0), C            ;; 0A4E:  ED 09 00
 OUT0 (85), C           ;; 0A4E:  ED 09 55
 OUT0 (170), C          ;; 0A4E:  ED 09 AA
 OUT0 (255), C          ;; 0A4E:  ED 09 FF
 OUT0 (0), D            ;; 0A4E:  ED 11 00
 OUT0 (85), D           ;; 0A4E:  ED 11 55
 OUT0 (170), D          ;; 0A4E:  ED 11 AA
 OUT0 (255), D          ;; 0A4E:  ED 11 FF
 OUT0 (0), E            ;; 0A4E:  ED 19 00
 OUT0 (85), E           ;; 0A4E:  ED 19 55
 OUT0 (170), E          ;; 0A4E:  ED 19 AA
 OUT0 (255), E          ;; 0A4E:  ED 19 FF
 OUT0 (0), H            ;; 0A4E:  ED 21 00
 OUT0 (85), H           ;; 0A4E:  ED 21 55
 OUT0 (170), H          ;; 0A4E:  ED 21 AA
 OUT0 (255), H          ;; 0A4E:  ED 21 FF
 OUT0 (0), L            ;; 0A4E:  ED 29 00
 OUT0 (85), L           ;; 0A4E:  ED 29 55
 OUT0 (170), L          ;; 0A4E:  ED 29 AA
 OUT0 (255), L          ;; 0A4E:  ED 29 FF
 OUT0 (0), A            ;; 0A4E:  ED 39 00
 OUT0 (85), A           ;; 0A4E:  ED 39 55
 OUT0 (170), A          ;; 0A4E:  ED 39 AA
 OUT0 (255), A          ;; 0A4E:  ED 39 FF
 OTDM                   ;; 0A4E:  ED 8B
 OTDMR                  ;; 0A4E:  ED 9B
 OTIM                   ;; 0A4E:  ED 83
 OTIMR                  ;; 0A4E:  ED 93
 TSTIO 0                ;; 0A4E:  ED 74 00
 TSTIO 85               ;; 0A4E:  ED 74 55
 TSTIO 170              ;; 0A4E:  ED 74 AA
 TSTIO 255              ;; 0A4E:  ED 74 FF
 DI                     ;; 0A50:  F3
 EI                     ;; 0A50:  FB
 IM 0                   ;; 0A50:  ED 46
 IM 1                   ;; 0A50:  ED 56
 IM 2                   ;; 0A50:  ED 5E
 LD I, A                ;; 0A5A:  ED 47
 LD A, I                ;; 0A5A:  ED 57
 LD R, A                ;; 0A5A:  ED 4F
 LD A, R                ;; 0A5A:  ED 5F
 RETN                   ;; 0A64:  ED 45
