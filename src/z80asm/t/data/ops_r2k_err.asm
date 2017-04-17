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
 LD I, A                ;; 01F7:  ED 47
 LD A, I                ;; 01F7:  ED 57
 LD R, A                ;; 01F7:  ED 4F
 LD A, R                ;; 01F7:  ED 5F
 CPI                    ;; 032D:  ED A1
 CPIR                   ;; 032D:  ED B1
 CPD                    ;; 032D:  ED A9
 CPDR                   ;; 032D:  ED B9
 ADD A, IXH             ;; 0365:  DD 84
 ADC A, IXH             ;; 0365:  DD 8C
 SUB IXH                ;; 0365:  DD 94
 SBC A, IXH             ;; 0365:  DD 9C
 AND IXH                ;; 0365:  DD A4
 XOR IXH                ;; 0365:  DD AC
 OR IXH                 ;; 0365:  DD B4
 CP IXH                 ;; 0365:  DD BC
 ADD A, IXL             ;; 0365:  DD 85
 ADC A, IXL             ;; 0365:  DD 8D
 SUB IXL                ;; 0365:  DD 95
 SBC A, IXL             ;; 0365:  DD 9D
 AND IXL                ;; 0365:  DD A5
 XOR IXL                ;; 0365:  DD AD
 OR IXL                 ;; 0365:  DD B5
 CP IXL                 ;; 0365:  DD BD
 ADD A, IYH             ;; 0365:  FD 84
 ADC A, IYH             ;; 0365:  FD 8C
 SUB IYH                ;; 0365:  FD 94
 SBC A, IYH             ;; 0365:  FD 9C
 AND IYH                ;; 0365:  FD A4
 XOR IYH                ;; 0365:  FD AC
 OR IYH                 ;; 0365:  FD B4
 CP IYH                 ;; 0365:  FD BC
 ADD A, IYL             ;; 0365:  FD 85
 ADC A, IYL             ;; 0365:  FD 8D
 SUB IYL                ;; 0365:  FD 95
 SBC A, IYL             ;; 0365:  FD 9D
 AND IYL                ;; 0365:  FD A5
 XOR IYL                ;; 0365:  FD AD
 OR IYL                 ;; 0365:  FD B5
 CP IYL                 ;; 0365:  FD BD
 DAA                    ;; 0471:  27
 HALT                   ;; 0477:  76
 DI                     ;; 0477:  F3
 EI                     ;; 0477:  FB
 IM 0                   ;; 0477:  ED 46
 IM 1                   ;; 0477:  ED 56
 IM 2                   ;; 0477:  ED 5E
 SLL B                  ;; 04BB:  CB 30
 SLL C                  ;; 04C9:  CB 31
 SLL D                  ;; 04D7:  CB 32
 SLL E                  ;; 04E5:  CB 33
 SLL H                  ;; 04F3:  CB 34
 SLL L                  ;; 0501:  CB 35
 SLL A                  ;; 050F:  CB 37
 SLL (HL)               ;; 051D:  CB 36
 SLL (IX + -128)        ;; 0567:  DD CB 80 36
 SLL (IX + 0)           ;; 0567:  DD CB 00 36
 SLL (IX + 127)         ;; 0567:  DD CB 7F 36
 SLL (IY + -128)        ;; 05BB:  FD CB 80 36
 SLL (IY + 0)           ;; 05BB:  FD CB 00 36
 SLL (IY + 127)         ;; 05BB:  FD CB 7F 36
 RLD                    ;; 05C7:  ED 6F
 RRD                    ;; 05C7:  ED 67
 CALL NZ, 0             ;; 0A10:  C4 00 00
 CALL NZ, 4660          ;; 0A10:  C4 34 12
 CALL NZ, 52719         ;; 0A10:  C4 EF CD
 CALL NZ, 65535         ;; 0A10:  C4 FF FF
 CALL Z, 0              ;; 0A10:  CC 00 00
 CALL Z, 4660           ;; 0A10:  CC 34 12
 CALL Z, 52719          ;; 0A10:  CC EF CD
 CALL Z, 65535          ;; 0A10:  CC FF FF
 CALL NC, 0             ;; 0A10:  D4 00 00
 CALL NC, 4660          ;; 0A10:  D4 34 12
 CALL NC, 52719         ;; 0A10:  D4 EF CD
 CALL NC, 65535         ;; 0A10:  D4 FF FF
 CALL C, 0              ;; 0A10:  DC 00 00
 CALL C, 4660           ;; 0A10:  DC 34 12
 CALL C, 52719          ;; 0A10:  DC EF CD
 CALL C, 65535          ;; 0A10:  DC FF FF
 CALL PO, 0             ;; 0A10:  E4 00 00
 CALL PO, 4660          ;; 0A10:  E4 34 12
 CALL PO, 52719         ;; 0A10:  E4 EF CD
 CALL PO, 65535         ;; 0A10:  E4 FF FF
 CALL PE, 0             ;; 0A10:  EC 00 00
 CALL PE, 4660          ;; 0A10:  EC 34 12
 CALL PE, 52719         ;; 0A10:  EC EF CD
 CALL PE, 65535         ;; 0A10:  EC FF FF
 CALL P, 0              ;; 0A10:  F4 00 00
 CALL P, 4660           ;; 0A10:  F4 34 12
 CALL P, 52719          ;; 0A10:  F4 EF CD
 CALL P, 65535          ;; 0A10:  F4 FF FF
 CALL M, 0              ;; 0A10:  FC 00 00
 CALL M, 4660           ;; 0A10:  FC 34 12
 CALL M, 52719          ;; 0A10:  FC EF CD
 CALL M, 65535          ;; 0A10:  FC FF FF
 RETN                   ;; 0A1B:  ED 45
 RST 0                  ;; 0A1B:  C7
 RST 8                  ;; 0A1B:  CF
 RST 48                 ;; 0A1F:  F7
 IN A, (0)              ;; 0A20:  DB 00
 IN A, (85)             ;; 0A20:  DB 55
 IN A, (170)            ;; 0A20:  DB AA
 IN A, (255)            ;; 0A20:  DB FF
 IN B, (C)              ;; 0A20:  ED 40
 IN C, (C)              ;; 0A20:  ED 48
 IN D, (C)              ;; 0A20:  ED 50
 IN E, (C)              ;; 0A20:  ED 58
 IN H, (C)              ;; 0A20:  ED 60
 IN L, (C)              ;; 0A20:  ED 68
 IN A, (C)              ;; 0A20:  ED 78
 INI                    ;; 0A20:  ED A2
 INIR                   ;; 0A20:  ED B2
 IND                    ;; 0A20:  ED AA
 INDR                   ;; 0A20:  ED BA
 OUT (0), A             ;; 0A20:  D3 00
 OUT (85), A            ;; 0A20:  D3 55
 OUT (170), A           ;; 0A20:  D3 AA
 OUT (255), A           ;; 0A20:  D3 FF
 OUT (C), B             ;; 0A20:  ED 41
 OUT (C), C             ;; 0A20:  ED 49
 OUT (C), D             ;; 0A20:  ED 51
 OUT (C), E             ;; 0A20:  ED 59
 OUT (C), H             ;; 0A20:  ED 61
 OUT (C), L             ;; 0A20:  ED 69
 OUT (C), A             ;; 0A20:  ED 79
 OUTI                   ;; 0A20:  ED A3
 OTIR                   ;; 0A20:  ED B3
 OUTD                   ;; 0A20:  ED AB
 OTDR                   ;; 0A20:  ED BB
 MLT SP                 ;; 0A26:  ED 7C
 IN0 B, (0)             ;; 0A42:  ED 00 00
 IN0 B, (85)            ;; 0A42:  ED 00 55
 IN0 B, (170)           ;; 0A42:  ED 00 AA
 IN0 B, (255)           ;; 0A42:  ED 00 FF
 IN0 C, (0)             ;; 0A42:  ED 08 00
 IN0 C, (85)            ;; 0A42:  ED 08 55
 IN0 C, (170)           ;; 0A42:  ED 08 AA
 IN0 C, (255)           ;; 0A42:  ED 08 FF
 IN0 D, (0)             ;; 0A42:  ED 10 00
 IN0 D, (85)            ;; 0A42:  ED 10 55
 IN0 D, (170)           ;; 0A42:  ED 10 AA
 IN0 D, (255)           ;; 0A42:  ED 10 FF
 IN0 E, (0)             ;; 0A42:  ED 18 00
 IN0 E, (85)            ;; 0A42:  ED 18 55
 IN0 E, (170)           ;; 0A42:  ED 18 AA
 IN0 E, (255)           ;; 0A42:  ED 18 FF
 IN0 H, (0)             ;; 0A42:  ED 20 00
 IN0 H, (85)            ;; 0A42:  ED 20 55
 IN0 H, (170)           ;; 0A42:  ED 20 AA
 IN0 H, (255)           ;; 0A42:  ED 20 FF
 IN0 L, (0)             ;; 0A42:  ED 28 00
 IN0 L, (85)            ;; 0A42:  ED 28 55
 IN0 L, (170)           ;; 0A42:  ED 28 AA
 IN0 L, (255)           ;; 0A42:  ED 28 FF
 IN0 A, (0)             ;; 0A42:  ED 38 00
 IN0 A, (85)            ;; 0A42:  ED 38 55
 IN0 A, (170)           ;; 0A42:  ED 38 AA
 IN0 A, (255)           ;; 0A42:  ED 38 FF
 OUT0 (0), B            ;; 0A42:  ED 01 00
 OUT0 (85), B           ;; 0A42:  ED 01 55
 OUT0 (170), B          ;; 0A42:  ED 01 AA
 OUT0 (255), B          ;; 0A42:  ED 01 FF
 OUT0 (0), C            ;; 0A42:  ED 09 00
 OUT0 (85), C           ;; 0A42:  ED 09 55
 OUT0 (170), C          ;; 0A42:  ED 09 AA
 OUT0 (255), C          ;; 0A42:  ED 09 FF
 OUT0 (0), D            ;; 0A42:  ED 11 00
 OUT0 (85), D           ;; 0A42:  ED 11 55
 OUT0 (170), D          ;; 0A42:  ED 11 AA
 OUT0 (255), D          ;; 0A42:  ED 11 FF
 OUT0 (0), E            ;; 0A42:  ED 19 00
 OUT0 (85), E           ;; 0A42:  ED 19 55
 OUT0 (170), E          ;; 0A42:  ED 19 AA
 OUT0 (255), E          ;; 0A42:  ED 19 FF
 OUT0 (0), H            ;; 0A42:  ED 21 00
 OUT0 (85), H           ;; 0A42:  ED 21 55
 OUT0 (170), H          ;; 0A42:  ED 21 AA
 OUT0 (255), H          ;; 0A42:  ED 21 FF
 OUT0 (0), L            ;; 0A42:  ED 29 00
 OUT0 (85), L           ;; 0A42:  ED 29 55
 OUT0 (170), L          ;; 0A42:  ED 29 AA
 OUT0 (255), L          ;; 0A42:  ED 29 FF
 OUT0 (0), A            ;; 0A42:  ED 39 00
 OUT0 (85), A           ;; 0A42:  ED 39 55
 OUT0 (170), A          ;; 0A42:  ED 39 AA
 OUT0 (255), A          ;; 0A42:  ED 39 FF
 OTDM                   ;; 0A42:  ED 8B
 OTDMR                  ;; 0A42:  ED 9B
 OTIM                   ;; 0A42:  ED 83
 OTIMR                  ;; 0A42:  ED 93
 TSTIO 0                ;; 0A42:  ED 74 00
 TSTIO 85               ;; 0A42:  ED 74 55
 TSTIO 170              ;; 0A42:  ED 74 AA
 TSTIO 255              ;; 0A42:  ED 74 FF
 SLP                    ;; 0A42:  ED 76
 IDET                   ;; 0A5A:  5B
