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
 LD IIR, A              ;; 01FF:  ED 47
 LD A, IIR              ;; 01FF:  ED 57
 LD EIR, A              ;; 01FF:  ED 4F
 LD A, EIR              ;; 01FF:  ED 5F
 ADD A, IXH             ;; 036C:  DD 84
 ADC A, IXH             ;; 036C:  DD 8C
 SUB IXH                ;; 036C:  DD 94
 SBC A, IXH             ;; 036C:  DD 9C
 AND IXH                ;; 036C:  DD A4
 XOR IXH                ;; 036C:  DD AC
 OR IXH                 ;; 036C:  DD B4
 CP IXH                 ;; 036C:  DD BC
 ADD A, IXL             ;; 036C:  DD 85
 ADC A, IXL             ;; 036C:  DD 8D
 SUB IXL                ;; 036C:  DD 95
 SBC A, IXL             ;; 036C:  DD 9D
 AND IXL                ;; 036C:  DD A5
 XOR IXL                ;; 036C:  DD AD
 OR IXL                 ;; 036C:  DD B5
 CP IXL                 ;; 036C:  DD BD
 ADD A, IYH             ;; 036C:  FD 84
 ADC A, IYH             ;; 036C:  FD 8C
 SUB IYH                ;; 036C:  FD 94
 SBC A, IYH             ;; 036C:  FD 9C
 AND IYH                ;; 036C:  FD A4
 XOR IYH                ;; 036C:  FD AC
 OR IYH                 ;; 036C:  FD B4
 CP IYH                 ;; 036C:  FD BC
 ADD A, IYL             ;; 036C:  FD 85
 ADC A, IYL             ;; 036C:  FD 8D
 SUB IYL                ;; 036C:  FD 95
 SBC A, IYL             ;; 036C:  FD 9D
 AND IYL                ;; 036C:  FD A5
 XOR IYL                ;; 036C:  FD AD
 OR IYL                 ;; 036C:  FD B5
 CP IYL                 ;; 036C:  FD BD
