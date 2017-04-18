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
 EX DE', HL             ;; 031C:  E3
 EX DE, HL'             ;; 031C:  76 EB
 EX DE', HL'            ;; 031C:  76 E3
 ADD A, IXH             ;; 0364:  DD 84
 ADC A, IXH             ;; 0364:  DD 8C
 SUB IXH                ;; 0364:  DD 94
 SBC A, IXH             ;; 0364:  DD 9C
 AND IXH                ;; 0364:  DD A4
 XOR IXH                ;; 0364:  DD AC
 OR IXH                 ;; 0364:  DD B4
 CP IXH                 ;; 0364:  DD BC
 ADD A, IXL             ;; 0364:  DD 85
 ADC A, IXL             ;; 0364:  DD 8D
 SUB IXL                ;; 0364:  DD 95
 SBC A, IXL             ;; 0364:  DD 9D
 AND IXL                ;; 0364:  DD A5
 XOR IXL                ;; 0364:  DD AD
 OR IXL                 ;; 0364:  DD B5
 CP IXL                 ;; 0364:  DD BD
 ADD A, IYH             ;; 0364:  FD 84
 ADC A, IYH             ;; 0364:  FD 8C
 SUB IYH                ;; 0364:  FD 94
 SBC A, IYH             ;; 0364:  FD 9C
 AND IYH                ;; 0364:  FD A4
 XOR IYH                ;; 0364:  FD AC
 OR IYH                 ;; 0364:  FD B4
 CP IYH                 ;; 0364:  FD BC
 ADD A, IYL             ;; 0364:  FD 85
 ADC A, IYL             ;; 0364:  FD 8D
 SUB IYL                ;; 0364:  FD 95
 SBC A, IYL             ;; 0364:  FD 9D
 AND IYL                ;; 0364:  FD A5
 XOR IYL                ;; 0364:  FD AD
 OR IYL                 ;; 0364:  FD B5
 CP IYL                 ;; 0364:  FD BD
 ALTD                   ;; 049A:  76
 ADD SP, -128           ;; 04AE:  27 80
 ADD SP, 0              ;; 04AE:  27 00
 ADD SP, 127            ;; 04AE:  27 7F
 AND HL, DE             ;; 04BE:  DC
 AND IX, DE             ;; 04BE:  DD DC
 AND IY, DE             ;; 04BE:  FD DC
 BOOL HL                ;; 04BE:  CC
 BOOL IX                ;; 04BE:  DD CC
 BOOL IY                ;; 04BE:  FD CC
 JP LZ, 0               ;; 0A46:  E2 00 00
 JP LZ, 4660            ;; 0A46:  E2 34 12
 JP LZ, 52719           ;; 0A46:  E2 EF CD
 JP LZ, 65535           ;; 0A46:  E2 FF FF
 JP LO, 0               ;; 0A46:  EA 00 00
 JP LO, 4660            ;; 0A46:  EA 34 12
 JP LO, 52719           ;; 0A46:  EA EF CD
 JP LO, 65535           ;; 0A46:  EA FF FF
 RET LZ                 ;; 0AB4:  E0
 RET LO                 ;; 0AB4:  E8
 IOE                    ;; 0BB4:  DB
 IOI                    ;; 0BB4:  D3
 IPSET 0                ;; 0BBC:  ED 46
 IPSET 1                ;; 0BBC:  ED 56
 IPSET 2                ;; 0BBC:  ED 4E
 IPSET 3                ;; 0BBC:  ED 5E
 IPRES                  ;; 0BBC:  ED 5D
 LD IIR, A              ;; 0BC4:  ED 47
 LD A, IIR              ;; 0BC4:  ED 57
 LD EIR, A              ;; 0BC4:  ED 4F
 LD A, EIR              ;; 0BC4:  ED 5F
 IDET                   ;; 0BC8:  5B
