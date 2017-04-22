 LD BC, 0               ;; 0000:  01 00 00
 LD BC, 4660            ;; 0003:  01 34 12
 LD BC, 52719           ;; 0006:  01 EF CD
 LD BC, 65535           ;; 0009:  01 FF FF
 LD DE, 0               ;; 000C:  11 00 00
 LD DE, 4660            ;; 000F:  11 34 12
 LD DE, 52719           ;; 0012:  11 EF CD
 LD DE, 65535           ;; 0015:  11 FF FF
 LD HL, 0               ;; 0018:  21 00 00
 LD HL, 4660            ;; 001B:  21 34 12
 LD HL, 52719           ;; 001E:  21 EF CD
 LD HL, 65535           ;; 0021:  21 FF FF
 LD SP, 0               ;; 0024:  31 00 00
 LD SP, 4660            ;; 0027:  31 34 12
 LD SP, 52719           ;; 002A:  31 EF CD
 LD SP, 65535           ;; 002D:  31 FF FF
 LD IX, 0               ;; 0030:  DD 21 00 00
 LD IX, 4660            ;; 0034:  DD 21 34 12
 LD IX, 52719           ;; 0038:  DD 21 EF CD
 LD IX, 65535           ;; 003C:  DD 21 FF FF
 LD IY, 0               ;; 0040:  FD 21 00 00
 LD IY, 4660            ;; 0044:  FD 21 34 12
 LD IY, 52719           ;; 0048:  FD 21 EF CD
 LD IY, 65535           ;; 004C:  FD 21 FF FF
 LD HL, (0)             ;; 0050:  2A 00 00
 LD HL, (4660)          ;; 0053:  2A 34 12
 LD HL, (52719)         ;; 0056:  2A EF CD
 LD HL, (65535)         ;; 0059:  2A FF FF
 LD IX, (0)             ;; 005C:  DD 2A 00 00
 LD IX, (4660)          ;; 0060:  DD 2A 34 12
 LD IX, (52719)         ;; 0064:  DD 2A EF CD
 LD IX, (65535)         ;; 0068:  DD 2A FF FF
 LD IY, (0)             ;; 006C:  FD 2A 00 00
 LD IY, (4660)          ;; 0070:  FD 2A 34 12
 LD IY, (52719)         ;; 0074:  FD 2A EF CD
 LD IY, (65535)         ;; 0078:  FD 2A FF FF
 LD BC, (0)             ;; 007C:  ED 4B 00 00
 LD BC, (4660)          ;; 0080:  ED 4B 34 12
 LD BC, (52719)         ;; 0084:  ED 4B EF CD
 LD BC, (65535)         ;; 0088:  ED 4B FF FF
 LD DE, (0)             ;; 008C:  ED 5B 00 00
 LD DE, (4660)          ;; 0090:  ED 5B 34 12
 LD DE, (52719)         ;; 0094:  ED 5B EF CD
 LD DE, (65535)         ;; 0098:  ED 5B FF FF
 LD SP, (0)             ;; 009C:  ED 7B 00 00
 LD SP, (4660)          ;; 00A0:  ED 7B 34 12
 LD SP, (52719)         ;; 00A4:  ED 7B EF CD
 LD SP, (65535)         ;; 00A8:  ED 7B FF FF
 LD (0), HL             ;; 00AC:  22 00 00
 LD (4660), HL          ;; 00AF:  22 34 12
 LD (52719), HL         ;; 00B2:  22 EF CD
 LD (65535), HL         ;; 00B5:  22 FF FF
 LD (0), IX             ;; 00B8:  DD 22 00 00
 LD (4660), IX          ;; 00BC:  DD 22 34 12
 LD (52719), IX         ;; 00C0:  DD 22 EF CD
 LD (65535), IX         ;; 00C4:  DD 22 FF FF
 LD (0), IY             ;; 00C8:  FD 22 00 00
 LD (4660), IY          ;; 00CC:  FD 22 34 12
 LD (52719), IY         ;; 00D0:  FD 22 EF CD
 LD (65535), IY         ;; 00D4:  FD 22 FF FF
 LD (0), BC             ;; 00D8:  ED 43 00 00
 LD (4660), BC          ;; 00DC:  ED 43 34 12
 LD (52719), BC         ;; 00E0:  ED 43 EF CD
 LD (65535), BC         ;; 00E4:  ED 43 FF FF
 LD (0), DE             ;; 00E8:  ED 53 00 00
 LD (4660), DE          ;; 00EC:  ED 53 34 12
 LD (52719), DE         ;; 00F0:  ED 53 EF CD
 LD (65535), DE         ;; 00F4:  ED 53 FF FF
 LD (0), SP             ;; 00F8:  ED 73 00 00
 LD (4660), SP          ;; 00FC:  ED 73 34 12
 LD (52719), SP         ;; 0100:  ED 73 EF CD
 LD (65535), SP         ;; 0104:  ED 73 FF FF
 LD SP, HL              ;; 0108:  F9
 LD SP, IX              ;; 0109:  DD F9
 LD SP, IY              ;; 010B:  FD F9
 PUSH BC                ;; 010D:  C5
 PUSH DE                ;; 010E:  D5
 PUSH HL                ;; 010F:  E5
 PUSH AF                ;; 0110:  F5
 PUSH IX                ;; 0111:  DD E5
 PUSH IY                ;; 0113:  FD E5
 POP BC                 ;; 0115:  C1
 POP DE                 ;; 0116:  D1
 POP HL                 ;; 0117:  E1
 POP AF                 ;; 0118:  F1
 POP IX                 ;; 0119:  DD E1
 POP IY                 ;; 011B:  FD E1
 EX DE, HL              ;; 011D:  EB
 EX AF, AF'             ;; 011E:  08
 EXX                    ;; 011F:  D9
 EX (SP), HL            ;; 0120:  E3
 EX (SP), IX            ;; 0121:  DD E3
 EX (SP), IY            ;; 0123:  FD E3
 LDI                    ;; 0125:  ED A0
 LDIR                   ;; 0127:  ED B0
 LDD                    ;; 0129:  ED A8
 LDDR                   ;; 012B:  ED B8
 CPI                    ;; 012D:  ED A1
 CPIR                   ;; 012F:  ED B1
 CPD                    ;; 0131:  ED A9
 CPDR                   ;; 0133:  ED B9
 ADD A, B               ;; 0135:  80
 ADC A, B               ;; 0136:  88
 SUB B                  ;; 0137:  90
 SBC A, B               ;; 0138:  98
 AND B                  ;; 0139:  A0
 XOR B                  ;; 013A:  A8
 OR B                   ;; 013B:  B0
 CP B                   ;; 013C:  B8
 ADD A, C               ;; 013D:  81
 ADC A, C               ;; 013E:  89
 SUB C                  ;; 013F:  91
 SBC A, C               ;; 0140:  99
 AND C                  ;; 0141:  A1
 XOR C                  ;; 0142:  A9
 OR C                   ;; 0143:  B1
 CP C                   ;; 0144:  B9
 ADD A, D               ;; 0145:  82
 ADC A, D               ;; 0146:  8A
 SUB D                  ;; 0147:  92
 SBC A, D               ;; 0148:  9A
 AND D                  ;; 0149:  A2
 XOR D                  ;; 014A:  AA
 OR D                   ;; 014B:  B2
 CP D                   ;; 014C:  BA
 ADD A, E               ;; 014D:  83
 ADC A, E               ;; 014E:  8B
 SUB E                  ;; 014F:  93
 SBC A, E               ;; 0150:  9B
 AND E                  ;; 0151:  A3
 XOR E                  ;; 0152:  AB
 OR E                   ;; 0153:  B3
 CP E                   ;; 0154:  BB
 ADD A, H               ;; 0155:  84
 ADC A, H               ;; 0156:  8C
 SUB H                  ;; 0157:  94
 SBC A, H               ;; 0158:  9C
 AND H                  ;; 0159:  A4
 XOR H                  ;; 015A:  AC
 OR H                   ;; 015B:  B4
 CP H                   ;; 015C:  BC
 ADD A, L               ;; 015D:  85
 ADC A, L               ;; 015E:  8D
 SUB L                  ;; 015F:  95
 SBC A, L               ;; 0160:  9D
 AND L                  ;; 0161:  A5
 XOR L                  ;; 0162:  AD
 OR L                   ;; 0163:  B5
 CP L                   ;; 0164:  BD
 ADD A, A               ;; 0165:  87
 ADC A, A               ;; 0166:  8F
 SUB A                  ;; 0167:  97
 SBC A, A               ;; 0168:  9F
 AND A                  ;; 0169:  A7
 XOR A                  ;; 016A:  AF
 OR A                   ;; 016B:  B7
 CP A                   ;; 016C:  BF
 ADD A, IXH             ;; 016D:  DD 84
 ADC A, IXH             ;; 016F:  DD 8C
 SUB IXH                ;; 0171:  DD 94
 SBC A, IXH             ;; 0173:  DD 9C
 AND IXH                ;; 0175:  DD A4
 XOR IXH                ;; 0177:  DD AC
 OR IXH                 ;; 0179:  DD B4
 CP IXH                 ;; 017B:  DD BC
 ADD A, IXL             ;; 017D:  DD 85
 ADC A, IXL             ;; 017F:  DD 8D
 SUB IXL                ;; 0181:  DD 95
 SBC A, IXL             ;; 0183:  DD 9D
 AND IXL                ;; 0185:  DD A5
 XOR IXL                ;; 0187:  DD AD
 OR IXL                 ;; 0189:  DD B5
 CP IXL                 ;; 018B:  DD BD
 ADD A, IYH             ;; 018D:  FD 84
 ADC A, IYH             ;; 018F:  FD 8C
 SUB IYH                ;; 0191:  FD 94
 SBC A, IYH             ;; 0193:  FD 9C
 AND IYH                ;; 0195:  FD A4
 XOR IYH                ;; 0197:  FD AC
 OR IYH                 ;; 0199:  FD B4
 CP IYH                 ;; 019B:  FD BC
 ADD A, IYL             ;; 019D:  FD 85
 ADC A, IYL             ;; 019F:  FD 8D
 SUB IYL                ;; 01A1:  FD 95
 SBC A, IYL             ;; 01A3:  FD 9D
 AND IYL                ;; 01A5:  FD A5
 XOR IYL                ;; 01A7:  FD AD
 OR IYL                 ;; 01A9:  FD B5
 CP IYL                 ;; 01AB:  FD BD
 ADD A, 0               ;; 01AD:  C6 00
 ADD A, 85              ;; 01AF:  C6 55
 ADD A, 170             ;; 01B1:  C6 AA
 ADD A, 255             ;; 01B3:  C6 FF
 ADC A, 0               ;; 01B5:  CE 00
 ADC A, 85              ;; 01B7:  CE 55
 ADC A, 170             ;; 01B9:  CE AA
 ADC A, 255             ;; 01BB:  CE FF
 SUB 0                  ;; 01BD:  D6 00
 SUB 85                 ;; 01BF:  D6 55
 SUB 170                ;; 01C1:  D6 AA
 SUB 255                ;; 01C3:  D6 FF
 SBC A, 0               ;; 01C5:  DE 00
 SBC A, 85              ;; 01C7:  DE 55
 SBC A, 170             ;; 01C9:  DE AA
 SBC A, 255             ;; 01CB:  DE FF
 AND 0                  ;; 01CD:  E6 00
 AND 85                 ;; 01CF:  E6 55
 AND 170                ;; 01D1:  E6 AA
 AND 255                ;; 01D3:  E6 FF
 XOR 0                  ;; 01D5:  EE 00
 XOR 85                 ;; 01D7:  EE 55
 XOR 170                ;; 01D9:  EE AA
 XOR 255                ;; 01DB:  EE FF
 OR 0                   ;; 01DD:  F6 00
 OR 85                  ;; 01DF:  F6 55
 OR 170                 ;; 01E1:  F6 AA
 OR 255                 ;; 01E3:  F6 FF
 CP 0                   ;; 01E5:  FE 00
 CP 85                  ;; 01E7:  FE 55
 CP 170                 ;; 01E9:  FE AA
 CP 255                 ;; 01EB:  FE FF
 ADD A, (HL)            ;; 01ED:  86
 ADC A, (HL)            ;; 01EE:  8E
 SUB (HL)               ;; 01EF:  96
 SBC A, (HL)            ;; 01F0:  9E
 AND (HL)               ;; 01F1:  A6
 XOR (HL)               ;; 01F2:  AE
 OR (HL)                ;; 01F3:  B6
 CP (HL)                ;; 01F4:  BE
 ADD A, (IX + -128)     ;; 01F5:  DD 86 80
 ADD A, (IX + 0)        ;; 01F8:  DD 86 00
 ADD A, (IX + 127)      ;; 01FB:  DD 86 7F
 ADC A, (IX + -128)     ;; 01FE:  DD 8E 80
 ADC A, (IX + 0)        ;; 0201:  DD 8E 00
 ADC A, (IX + 127)      ;; 0204:  DD 8E 7F
 SUB (IX + -128)        ;; 0207:  DD 96 80
 SUB (IX + 0)           ;; 020A:  DD 96 00
 SUB (IX + 127)         ;; 020D:  DD 96 7F
 SBC A, (IX + -128)     ;; 0210:  DD 9E 80
 SBC A, (IX + 0)        ;; 0213:  DD 9E 00
 SBC A, (IX + 127)      ;; 0216:  DD 9E 7F
 AND (IX + -128)        ;; 0219:  DD A6 80
 AND (IX + 0)           ;; 021C:  DD A6 00
 AND (IX + 127)         ;; 021F:  DD A6 7F
 XOR (IX + -128)        ;; 0222:  DD AE 80
 XOR (IX + 0)           ;; 0225:  DD AE 00
 XOR (IX + 127)         ;; 0228:  DD AE 7F
 OR (IX + -128)         ;; 022B:  DD B6 80
 OR (IX + 0)            ;; 022E:  DD B6 00
 OR (IX + 127)          ;; 0231:  DD B6 7F
 CP (IX + -128)         ;; 0234:  DD BE 80
 CP (IX + 0)            ;; 0237:  DD BE 00
 CP (IX + 127)          ;; 023A:  DD BE 7F
 ADD A, (IY + -128)     ;; 023D:  FD 86 80
 ADD A, (IY + 0)        ;; 0240:  FD 86 00
 ADD A, (IY + 127)      ;; 0243:  FD 86 7F
 ADC A, (IY + -128)     ;; 0246:  FD 8E 80
 ADC A, (IY + 0)        ;; 0249:  FD 8E 00
 ADC A, (IY + 127)      ;; 024C:  FD 8E 7F
 SUB (IY + -128)        ;; 024F:  FD 96 80
 SUB (IY + 0)           ;; 0252:  FD 96 00
 SUB (IY + 127)         ;; 0255:  FD 96 7F
 SBC A, (IY + -128)     ;; 0258:  FD 9E 80
 SBC A, (IY + 0)        ;; 025B:  FD 9E 00
 SBC A, (IY + 127)      ;; 025E:  FD 9E 7F
 AND (IY + -128)        ;; 0261:  FD A6 80
 AND (IY + 0)           ;; 0264:  FD A6 00
 AND (IY + 127)         ;; 0267:  FD A6 7F
 XOR (IY + -128)        ;; 026A:  FD AE 80
 XOR (IY + 0)           ;; 026D:  FD AE 00
 XOR (IY + 127)         ;; 0270:  FD AE 7F
 OR (IY + -128)         ;; 0273:  FD B6 80
 OR (IY + 0)            ;; 0276:  FD B6 00
 OR (IY + 127)          ;; 0279:  FD B6 7F
 CP (IY + -128)         ;; 027C:  FD BE 80
 CP (IY + 0)            ;; 027F:  FD BE 00
 CP (IY + 127)          ;; 0282:  FD BE 7F
 INC B                  ;; 0285:  04
 INC C                  ;; 0286:  0C
 INC D                  ;; 0287:  14
 INC E                  ;; 0288:  1C
 INC H                  ;; 0289:  24
 INC L                  ;; 028A:  2C
 INC A                  ;; 028B:  3C
 INC (HL)               ;; 028C:  34
 INC (IX + -128)        ;; 028D:  DD 34 80
 INC (IX + 0)           ;; 0290:  DD 34 00
 INC (IX + 127)         ;; 0293:  DD 34 7F
 INC (IY + -128)        ;; 0296:  FD 34 80
 INC (IY + 0)           ;; 0299:  FD 34 00
 INC (IY + 127)         ;; 029C:  FD 34 7F
 DEC B                  ;; 029F:  05
 DEC C                  ;; 02A0:  0D
 DEC D                  ;; 02A1:  15
 DEC E                  ;; 02A2:  1D
 DEC H                  ;; 02A3:  25
 DEC L                  ;; 02A4:  2D
 DEC A                  ;; 02A5:  3D
 DEC (HL)               ;; 02A6:  35
 DEC (IX + -128)        ;; 02A7:  DD 35 80
 DEC (IX + 0)           ;; 02AA:  DD 35 00
 DEC (IX + 127)         ;; 02AD:  DD 35 7F
 DEC (IY + -128)        ;; 02B0:  FD 35 80
 DEC (IY + 0)           ;; 02B3:  FD 35 00
 DEC (IY + 127)         ;; 02B6:  FD 35 7F
 DAA                    ;; 02B9:  27
 RLD                    ;; 02BA:  ED 6F
 RRD                    ;; 02BC:  ED 67
 CPL                    ;; 02BE:  2F
 NEG                    ;; 02BF:  ED 44
 CCF                    ;; 02C1:  3F
 SCF                    ;; 02C2:  37
 NOP                    ;; 02C3:  00
 HALT                   ;; 02C4:  76
 ADD HL, BC             ;; 02C5:  09
 ADD HL, DE             ;; 02C6:  19
 ADD HL, HL             ;; 02C7:  29
 ADD HL, SP             ;; 02C8:  39
 ADD IX, BC             ;; 02C9:  DD 09
 ADD IY, BC             ;; 02CB:  FD 09
 ADD IX, DE             ;; 02CD:  DD 19
 ADD IY, DE             ;; 02CF:  FD 19
 ADD IX, IX             ;; 02D1:  DD 29
 ADD IY, IY             ;; 02D3:  FD 29
 ADD IX, SP             ;; 02D5:  DD 39
 ADD IY, SP             ;; 02D7:  FD 39
 ADC HL, BC             ;; 02D9:  ED 4A
 ADC HL, DE             ;; 02DB:  ED 5A
 ADC HL, HL             ;; 02DD:  ED 6A
 ADC HL, SP             ;; 02DF:  ED 7A
 SBC HL, BC             ;; 02E1:  ED 42
 SBC HL, DE             ;; 02E3:  ED 52
 SBC HL, HL             ;; 02E5:  ED 62
 SBC HL, SP             ;; 02E7:  ED 72
 INC BC                 ;; 02E9:  03
 INC DE                 ;; 02EA:  13
 INC HL                 ;; 02EB:  23
 INC SP                 ;; 02EC:  33
 INC IX                 ;; 02ED:  DD 23
 INC IY                 ;; 02EF:  FD 23
 DEC BC                 ;; 02F1:  0B
 DEC DE                 ;; 02F2:  1B
 DEC HL                 ;; 02F3:  2B
 DEC SP                 ;; 02F4:  3B
 DEC IX                 ;; 02F5:  DD 2B
 DEC IY                 ;; 02F7:  FD 2B
 RLCA                   ;; 02F9:  07
 RRCA                   ;; 02FA:  0F
 RLA                    ;; 02FB:  17
 RRA                    ;; 02FC:  1F
 RLC B                  ;; 02FD:  CB 00
 RRC B                  ;; 02FF:  CB 08
 RL B                   ;; 0301:  CB 10
 RR B                   ;; 0303:  CB 18
 SLA B                  ;; 0305:  CB 20
 SRA B                  ;; 0307:  CB 28
 SRL B                  ;; 0309:  CB 38
 RLC C                  ;; 030B:  CB 01
 RRC C                  ;; 030D:  CB 09
 RL C                   ;; 030F:  CB 11
 RR C                   ;; 0311:  CB 19
 SLA C                  ;; 0313:  CB 21
 SRA C                  ;; 0315:  CB 29
 SRL C                  ;; 0317:  CB 39
 RLC D                  ;; 0319:  CB 02
 RRC D                  ;; 031B:  CB 0A
 RL D                   ;; 031D:  CB 12
 RR D                   ;; 031F:  CB 1A
 SLA D                  ;; 0321:  CB 22
 SRA D                  ;; 0323:  CB 2A
 SRL D                  ;; 0325:  CB 3A
 RLC E                  ;; 0327:  CB 03
 RRC E                  ;; 0329:  CB 0B
 RL E                   ;; 032B:  CB 13
 RR E                   ;; 032D:  CB 1B
 SLA E                  ;; 032F:  CB 23
 SRA E                  ;; 0331:  CB 2B
 SRL E                  ;; 0333:  CB 3B
 RLC H                  ;; 0335:  CB 04
 RRC H                  ;; 0337:  CB 0C
 RL H                   ;; 0339:  CB 14
 RR H                   ;; 033B:  CB 1C
 SLA H                  ;; 033D:  CB 24
 SRA H                  ;; 033F:  CB 2C
 SRL H                  ;; 0341:  CB 3C
 RLC L                  ;; 0343:  CB 05
 RRC L                  ;; 0345:  CB 0D
 RL L                   ;; 0347:  CB 15
 RR L                   ;; 0349:  CB 1D
 SLA L                  ;; 034B:  CB 25
 SRA L                  ;; 034D:  CB 2D
 SRL L                  ;; 034F:  CB 3D
 RLC A                  ;; 0351:  CB 07
 RRC A                  ;; 0353:  CB 0F
 RL A                   ;; 0355:  CB 17
 RR A                   ;; 0357:  CB 1F
 SLA A                  ;; 0359:  CB 27
 SRA A                  ;; 035B:  CB 2F
 SRL A                  ;; 035D:  CB 3F
 SLL B                  ;; 035F:  CB 30
 SLL C                  ;; 0361:  CB 31
 SLL D                  ;; 0363:  CB 32
 SLL E                  ;; 0365:  CB 33
 SLL H                  ;; 0367:  CB 34
 SLL L                  ;; 0369:  CB 35
 SLL A                  ;; 036B:  CB 37
 RLC (HL)               ;; 036D:  CB 06
 RRC (HL)               ;; 036F:  CB 0E
 RL (HL)                ;; 0371:  CB 16
 RR (HL)                ;; 0373:  CB 1E
 SLA (HL)               ;; 0375:  CB 26
 SRA (HL)               ;; 0377:  CB 2E
 SRL (HL)               ;; 0379:  CB 3E
 SLL (HL)               ;; 037B:  CB 36
 RLC (IX + -128)        ;; 037D:  DD CB 80 06
 RLC (IX + 0)           ;; 0381:  DD CB 00 06
 RLC (IX + 127)         ;; 0385:  DD CB 7F 06
 RRC (IX + -128)        ;; 0389:  DD CB 80 0E
 RRC (IX + 0)           ;; 038D:  DD CB 00 0E
 RRC (IX + 127)         ;; 0391:  DD CB 7F 0E
 RL (IX + -128)         ;; 0395:  DD CB 80 16
 RL (IX + 0)            ;; 0399:  DD CB 00 16
 RL (IX + 127)          ;; 039D:  DD CB 7F 16
 RR (IX + -128)         ;; 03A1:  DD CB 80 1E
 RR (IX + 0)            ;; 03A5:  DD CB 00 1E
 RR (IX + 127)          ;; 03A9:  DD CB 7F 1E
 SLA (IX + -128)        ;; 03AD:  DD CB 80 26
 SLA (IX + 0)           ;; 03B1:  DD CB 00 26
 SLA (IX + 127)         ;; 03B5:  DD CB 7F 26
 SRA (IX + -128)        ;; 03B9:  DD CB 80 2E
 SRA (IX + 0)           ;; 03BD:  DD CB 00 2E
 SRA (IX + 127)         ;; 03C1:  DD CB 7F 2E
 SRL (IX + -128)        ;; 03C5:  DD CB 80 3E
 SRL (IX + 0)           ;; 03C9:  DD CB 00 3E
 SRL (IX + 127)         ;; 03CD:  DD CB 7F 3E
 RLC (IY + -128)        ;; 03D1:  FD CB 80 06
 RLC (IY + 0)           ;; 03D5:  FD CB 00 06
 RLC (IY + 127)         ;; 03D9:  FD CB 7F 06
 RRC (IY + -128)        ;; 03DD:  FD CB 80 0E
 RRC (IY + 0)           ;; 03E1:  FD CB 00 0E
 RRC (IY + 127)         ;; 03E5:  FD CB 7F 0E
 RL (IY + -128)         ;; 03E9:  FD CB 80 16
 RL (IY + 0)            ;; 03ED:  FD CB 00 16
 RL (IY + 127)          ;; 03F1:  FD CB 7F 16
 RR (IY + -128)         ;; 03F5:  FD CB 80 1E
 RR (IY + 0)            ;; 03F9:  FD CB 00 1E
 RR (IY + 127)          ;; 03FD:  FD CB 7F 1E
 SLA (IY + -128)        ;; 0401:  FD CB 80 26
 SLA (IY + 0)           ;; 0405:  FD CB 00 26
 SLA (IY + 127)         ;; 0409:  FD CB 7F 26
 SRA (IY + -128)        ;; 040D:  FD CB 80 2E
 SRA (IY + 0)           ;; 0411:  FD CB 00 2E
 SRA (IY + 127)         ;; 0415:  FD CB 7F 2E
 SRL (IY + -128)        ;; 0419:  FD CB 80 3E
 SRL (IY + 0)           ;; 041D:  FD CB 00 3E
 SRL (IY + 127)         ;; 0421:  FD CB 7F 3E
 SLL (IX + -128)        ;; 0425:  DD CB 80 36
 SLL (IX + 0)           ;; 0429:  DD CB 00 36
 SLL (IX + 127)         ;; 042D:  DD CB 7F 36
 SLL (IY + -128)        ;; 0431:  FD CB 80 36
 SLL (IY + 0)           ;; 0435:  FD CB 00 36
 SLL (IY + 127)         ;; 0439:  FD CB 7F 36
 BIT 0, B               ;; 043D:  CB 40
 BIT 1, B               ;; 043F:  CB 48
 BIT 2, B               ;; 0441:  CB 50
 BIT 3, B               ;; 0443:  CB 58
 BIT 4, B               ;; 0445:  CB 60
 BIT 5, B               ;; 0447:  CB 68
 BIT 6, B               ;; 0449:  CB 70
 BIT 7, B               ;; 044B:  CB 78
 RES 0, B               ;; 044D:  CB 80
 RES 1, B               ;; 044F:  CB 88
 RES 2, B               ;; 0451:  CB 90
 RES 3, B               ;; 0453:  CB 98
 RES 4, B               ;; 0455:  CB A0
 RES 5, B               ;; 0457:  CB A8
 RES 6, B               ;; 0459:  CB B0
 RES 7, B               ;; 045B:  CB B8
 SET 0, B               ;; 045D:  CB C0
 SET 1, B               ;; 045F:  CB C8
 SET 2, B               ;; 0461:  CB D0
 SET 3, B               ;; 0463:  CB D8
 SET 4, B               ;; 0465:  CB E0
 SET 5, B               ;; 0467:  CB E8
 SET 6, B               ;; 0469:  CB F0
 SET 7, B               ;; 046B:  CB F8
 BIT 0, C               ;; 046D:  CB 41
 BIT 1, C               ;; 046F:  CB 49
 BIT 2, C               ;; 0471:  CB 51
 BIT 3, C               ;; 0473:  CB 59
 BIT 4, C               ;; 0475:  CB 61
 BIT 5, C               ;; 0477:  CB 69
 BIT 6, C               ;; 0479:  CB 71
 BIT 7, C               ;; 047B:  CB 79
 RES 0, C               ;; 047D:  CB 81
 RES 1, C               ;; 047F:  CB 89
 RES 2, C               ;; 0481:  CB 91
 RES 3, C               ;; 0483:  CB 99
 RES 4, C               ;; 0485:  CB A1
 RES 5, C               ;; 0487:  CB A9
 RES 6, C               ;; 0489:  CB B1
 RES 7, C               ;; 048B:  CB B9
 SET 0, C               ;; 048D:  CB C1
 SET 1, C               ;; 048F:  CB C9
 SET 2, C               ;; 0491:  CB D1
 SET 3, C               ;; 0493:  CB D9
 SET 4, C               ;; 0495:  CB E1
 SET 5, C               ;; 0497:  CB E9
 SET 6, C               ;; 0499:  CB F1
 SET 7, C               ;; 049B:  CB F9
 BIT 0, D               ;; 049D:  CB 42
 BIT 1, D               ;; 049F:  CB 4A
 BIT 2, D               ;; 04A1:  CB 52
 BIT 3, D               ;; 04A3:  CB 5A
 BIT 4, D               ;; 04A5:  CB 62
 BIT 5, D               ;; 04A7:  CB 6A
 BIT 6, D               ;; 04A9:  CB 72
 BIT 7, D               ;; 04AB:  CB 7A
 RES 0, D               ;; 04AD:  CB 82
 RES 1, D               ;; 04AF:  CB 8A
 RES 2, D               ;; 04B1:  CB 92
 RES 3, D               ;; 04B3:  CB 9A
 RES 4, D               ;; 04B5:  CB A2
 RES 5, D               ;; 04B7:  CB AA
 RES 6, D               ;; 04B9:  CB B2
 RES 7, D               ;; 04BB:  CB BA
 SET 0, D               ;; 04BD:  CB C2
 SET 1, D               ;; 04BF:  CB CA
 SET 2, D               ;; 04C1:  CB D2
 SET 3, D               ;; 04C3:  CB DA
 SET 4, D               ;; 04C5:  CB E2
 SET 5, D               ;; 04C7:  CB EA
 SET 6, D               ;; 04C9:  CB F2
 SET 7, D               ;; 04CB:  CB FA
 BIT 0, E               ;; 04CD:  CB 43
 BIT 1, E               ;; 04CF:  CB 4B
 BIT 2, E               ;; 04D1:  CB 53
 BIT 3, E               ;; 04D3:  CB 5B
 BIT 4, E               ;; 04D5:  CB 63
 BIT 5, E               ;; 04D7:  CB 6B
 BIT 6, E               ;; 04D9:  CB 73
 BIT 7, E               ;; 04DB:  CB 7B
 RES 0, E               ;; 04DD:  CB 83
 RES 1, E               ;; 04DF:  CB 8B
 RES 2, E               ;; 04E1:  CB 93
 RES 3, E               ;; 04E3:  CB 9B
 RES 4, E               ;; 04E5:  CB A3
 RES 5, E               ;; 04E7:  CB AB
 RES 6, E               ;; 04E9:  CB B3
 RES 7, E               ;; 04EB:  CB BB
 SET 0, E               ;; 04ED:  CB C3
 SET 1, E               ;; 04EF:  CB CB
 SET 2, E               ;; 04F1:  CB D3
 SET 3, E               ;; 04F3:  CB DB
 SET 4, E               ;; 04F5:  CB E3
 SET 5, E               ;; 04F7:  CB EB
 SET 6, E               ;; 04F9:  CB F3
 SET 7, E               ;; 04FB:  CB FB
 BIT 0, H               ;; 04FD:  CB 44
 BIT 1, H               ;; 04FF:  CB 4C
 BIT 2, H               ;; 0501:  CB 54
 BIT 3, H               ;; 0503:  CB 5C
 BIT 4, H               ;; 0505:  CB 64
 BIT 5, H               ;; 0507:  CB 6C
 BIT 6, H               ;; 0509:  CB 74
 BIT 7, H               ;; 050B:  CB 7C
 RES 0, H               ;; 050D:  CB 84
 RES 1, H               ;; 050F:  CB 8C
 RES 2, H               ;; 0511:  CB 94
 RES 3, H               ;; 0513:  CB 9C
 RES 4, H               ;; 0515:  CB A4
 RES 5, H               ;; 0517:  CB AC
 RES 6, H               ;; 0519:  CB B4
 RES 7, H               ;; 051B:  CB BC
 SET 0, H               ;; 051D:  CB C4
 SET 1, H               ;; 051F:  CB CC
 SET 2, H               ;; 0521:  CB D4
 SET 3, H               ;; 0523:  CB DC
 SET 4, H               ;; 0525:  CB E4
 SET 5, H               ;; 0527:  CB EC
 SET 6, H               ;; 0529:  CB F4
 SET 7, H               ;; 052B:  CB FC
 BIT 0, L               ;; 052D:  CB 45
 BIT 1, L               ;; 052F:  CB 4D
 BIT 2, L               ;; 0531:  CB 55
 BIT 3, L               ;; 0533:  CB 5D
 BIT 4, L               ;; 0535:  CB 65
 BIT 5, L               ;; 0537:  CB 6D
 BIT 6, L               ;; 0539:  CB 75
 BIT 7, L               ;; 053B:  CB 7D
 RES 0, L               ;; 053D:  CB 85
 RES 1, L               ;; 053F:  CB 8D
 RES 2, L               ;; 0541:  CB 95
 RES 3, L               ;; 0543:  CB 9D
 RES 4, L               ;; 0545:  CB A5
 RES 5, L               ;; 0547:  CB AD
 RES 6, L               ;; 0549:  CB B5
 RES 7, L               ;; 054B:  CB BD
 SET 0, L               ;; 054D:  CB C5
 SET 1, L               ;; 054F:  CB CD
 SET 2, L               ;; 0551:  CB D5
 SET 3, L               ;; 0553:  CB DD
 SET 4, L               ;; 0555:  CB E5
 SET 5, L               ;; 0557:  CB ED
 SET 6, L               ;; 0559:  CB F5
 SET 7, L               ;; 055B:  CB FD
 BIT 0, A               ;; 055D:  CB 47
 BIT 1, A               ;; 055F:  CB 4F
 BIT 2, A               ;; 0561:  CB 57
 BIT 3, A               ;; 0563:  CB 5F
 BIT 4, A               ;; 0565:  CB 67
 BIT 5, A               ;; 0567:  CB 6F
 BIT 6, A               ;; 0569:  CB 77
 BIT 7, A               ;; 056B:  CB 7F
 RES 0, A               ;; 056D:  CB 87
 RES 1, A               ;; 056F:  CB 8F
 RES 2, A               ;; 0571:  CB 97
 RES 3, A               ;; 0573:  CB 9F
 RES 4, A               ;; 0575:  CB A7
 RES 5, A               ;; 0577:  CB AF
 RES 6, A               ;; 0579:  CB B7
 RES 7, A               ;; 057B:  CB BF
 SET 0, A               ;; 057D:  CB C7
 SET 1, A               ;; 057F:  CB CF
 SET 2, A               ;; 0581:  CB D7
 SET 3, A               ;; 0583:  CB DF
 SET 4, A               ;; 0585:  CB E7
 SET 5, A               ;; 0587:  CB EF
 SET 6, A               ;; 0589:  CB F7
 SET 7, A               ;; 058B:  CB FF
 BIT 0, (HL)            ;; 058D:  CB 46
 BIT 1, (HL)            ;; 058F:  CB 4E
 BIT 2, (HL)            ;; 0591:  CB 56
 BIT 3, (HL)            ;; 0593:  CB 5E
 BIT 4, (HL)            ;; 0595:  CB 66
 BIT 5, (HL)            ;; 0597:  CB 6E
 BIT 6, (HL)            ;; 0599:  CB 76
 BIT 7, (HL)            ;; 059B:  CB 7E
 RES 0, (HL)            ;; 059D:  CB 86
 RES 1, (HL)            ;; 059F:  CB 8E
 RES 2, (HL)            ;; 05A1:  CB 96
 RES 3, (HL)            ;; 05A3:  CB 9E
 RES 4, (HL)            ;; 05A5:  CB A6
 RES 5, (HL)            ;; 05A7:  CB AE
 RES 6, (HL)            ;; 05A9:  CB B6
 RES 7, (HL)            ;; 05AB:  CB BE
 SET 0, (HL)            ;; 05AD:  CB C6
 SET 1, (HL)            ;; 05AF:  CB CE
 SET 2, (HL)            ;; 05B1:  CB D6
 SET 3, (HL)            ;; 05B3:  CB DE
 SET 4, (HL)            ;; 05B5:  CB E6
 SET 5, (HL)            ;; 05B7:  CB EE
 SET 6, (HL)            ;; 05B9:  CB F6
 SET 7, (HL)            ;; 05BB:  CB FE
 BIT 0, (IX + -128)     ;; 05BD:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 05C1:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 05C5:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 05C9:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 05CD:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 05D1:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 05D5:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 05D9:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 05DD:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 05E1:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 05E5:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 05E9:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 05ED:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 05F1:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 05F5:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 05F9:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 05FD:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 0601:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 0605:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 0609:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 060D:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 0611:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 0615:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 0619:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 061D:  DD CB 80 86
 RES 1, (IX + -128)     ;; 0621:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 0625:  DD CB 80 96
 RES 3, (IX + -128)     ;; 0629:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 062D:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 0631:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 0635:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 0639:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 063D:  DD CB 00 86
 RES 1, (IX + 0)        ;; 0641:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 0645:  DD CB 00 96
 RES 3, (IX + 0)        ;; 0649:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 064D:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 0651:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 0655:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 0659:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 065D:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 0661:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 0665:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 0669:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 066D:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 0671:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 0675:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0679:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 067D:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 0681:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 0685:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0689:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 068D:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 0691:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 0695:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0699:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 069D:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 06A1:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 06A5:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 06A9:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 06AD:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 06B1:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 06B5:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 06B9:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 06BD:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 06C1:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 06C5:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 06C9:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 06CD:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 06D1:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 06D5:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 06D9:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 06DD:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 06E1:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 06E5:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 06E9:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 06ED:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 06F1:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 06F5:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 06F9:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 06FD:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 0701:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 0705:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 0709:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 070D:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 0711:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 0715:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 0719:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 071D:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 0721:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 0725:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 0729:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 072D:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 0731:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 0735:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 0739:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 073D:  FD CB 80 86
 RES 1, (IY + -128)     ;; 0741:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 0745:  FD CB 80 96
 RES 3, (IY + -128)     ;; 0749:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 074D:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 0751:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 0755:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 0759:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 075D:  FD CB 00 86
 RES 1, (IY + 0)        ;; 0761:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 0765:  FD CB 00 96
 RES 3, (IY + 0)        ;; 0769:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 076D:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 0771:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 0775:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0779:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 077D:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 0781:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 0785:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0789:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 078D:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 0791:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 0795:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0799:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 079D:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 07A1:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 07A5:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 07A9:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 07AD:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 07B1:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 07B5:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 07B9:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 07BD:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 07C1:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 07C5:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 07C9:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 07CD:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 07D1:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 07D5:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 07D9:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 07DD:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 07E1:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 07E5:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 07E9:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 07ED:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 07F1:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 07F5:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 07F9:  FD CB 7F FE
 JP 0                   ;; 07FD:  C3 00 00
 JP 4660                ;; 0800:  C3 34 12
 JP 52719               ;; 0803:  C3 EF CD
 JP 65535               ;; 0806:  C3 FF FF
 JP NZ, 0               ;; 0809:  C2 00 00
 JP NZ, 4660            ;; 080C:  C2 34 12
 JP NZ, 52719           ;; 080F:  C2 EF CD
 JP NZ, 65535           ;; 0812:  C2 FF FF
 JP Z, 0                ;; 0815:  CA 00 00
 JP Z, 4660             ;; 0818:  CA 34 12
 JP Z, 52719            ;; 081B:  CA EF CD
 JP Z, 65535            ;; 081E:  CA FF FF
 JP NC, 0               ;; 0821:  D2 00 00
 JP NC, 4660            ;; 0824:  D2 34 12
 JP NC, 52719           ;; 0827:  D2 EF CD
 JP NC, 65535           ;; 082A:  D2 FF FF
 JP C, 0                ;; 082D:  DA 00 00
 JP C, 4660             ;; 0830:  DA 34 12
 JP C, 52719            ;; 0833:  DA EF CD
 JP C, 65535            ;; 0836:  DA FF FF
 JP PO, 0               ;; 0839:  E2 00 00
 JP PO, 4660            ;; 083C:  E2 34 12
 JP PO, 52719           ;; 083F:  E2 EF CD
 JP PO, 65535           ;; 0842:  E2 FF FF
 JP PE, 0               ;; 0845:  EA 00 00
 JP PE, 4660            ;; 0848:  EA 34 12
 JP PE, 52719           ;; 084B:  EA EF CD
 JP PE, 65535           ;; 084E:  EA FF FF
 JP P, 0                ;; 0851:  F2 00 00
 JP P, 4660             ;; 0854:  F2 34 12
 JP P, 52719            ;; 0857:  F2 EF CD
 JP P, 65535            ;; 085A:  F2 FF FF
 JP M, 0                ;; 085D:  FA 00 00
 JP M, 4660             ;; 0860:  FA 34 12
 JP M, 52719            ;; 0863:  FA EF CD
 JP M, 65535            ;; 0866:  FA FF FF
 JR ASMPC+2             ;; 0869:  18 00
 JR NZ, ASMPC+2         ;; 086B:  20 00
 JR Z, ASMPC+2          ;; 086D:  28 00
 JR NC, ASMPC+2         ;; 086F:  30 00
 JR C, ASMPC+2          ;; 0871:  38 00
 JP (HL)                ;; 0873:  E9
 JP (IX)                ;; 0874:  DD E9
 JP (IY)                ;; 0876:  FD E9
 DJNZ ASMPC+2           ;; 0878:  10 00
 CALL 0                 ;; 087A:  CD 00 00
 CALL 4660              ;; 087D:  CD 34 12
 CALL 52719             ;; 0880:  CD EF CD
 CALL 65535             ;; 0883:  CD FF FF
 CALL NZ, 0             ;; 0886:  C4 00 00
 CALL NZ, 4660          ;; 0889:  C4 34 12
 CALL NZ, 52719         ;; 088C:  C4 EF CD
 CALL NZ, 65535         ;; 088F:  C4 FF FF
 CALL Z, 0              ;; 0892:  CC 00 00
 CALL Z, 4660           ;; 0895:  CC 34 12
 CALL Z, 52719          ;; 0898:  CC EF CD
 CALL Z, 65535          ;; 089B:  CC FF FF
 CALL NC, 0             ;; 089E:  D4 00 00
 CALL NC, 4660          ;; 08A1:  D4 34 12
 CALL NC, 52719         ;; 08A4:  D4 EF CD
 CALL NC, 65535         ;; 08A7:  D4 FF FF
 CALL C, 0              ;; 08AA:  DC 00 00
 CALL C, 4660           ;; 08AD:  DC 34 12
 CALL C, 52719          ;; 08B0:  DC EF CD
 CALL C, 65535          ;; 08B3:  DC FF FF
 CALL PO, 0             ;; 08B6:  E4 00 00
 CALL PO, 4660          ;; 08B9:  E4 34 12
 CALL PO, 52719         ;; 08BC:  E4 EF CD
 CALL PO, 65535         ;; 08BF:  E4 FF FF
 CALL PE, 0             ;; 08C2:  EC 00 00
 CALL PE, 4660          ;; 08C5:  EC 34 12
 CALL PE, 52719         ;; 08C8:  EC EF CD
 CALL PE, 65535         ;; 08CB:  EC FF FF
 CALL P, 0              ;; 08CE:  F4 00 00
 CALL P, 4660           ;; 08D1:  F4 34 12
 CALL P, 52719          ;; 08D4:  F4 EF CD
 CALL P, 65535          ;; 08D7:  F4 FF FF
 CALL M, 0              ;; 08DA:  FC 00 00
 CALL M, 4660           ;; 08DD:  FC 34 12
 CALL M, 52719          ;; 08E0:  FC EF CD
 CALL M, 65535          ;; 08E3:  FC FF FF
 RET                    ;; 08E6:  C9
 RET NZ                 ;; 08E7:  C0
 RET Z                  ;; 08E8:  C8
 RET NC                 ;; 08E9:  D0
 RET C                  ;; 08EA:  D8
 RET PO                 ;; 08EB:  E0
 RET PE                 ;; 08EC:  E8
 RET P                  ;; 08ED:  F0
 RET M                  ;; 08EE:  F8
 RST 16                 ;; 08EF:  D7
 RST 24                 ;; 08F0:  DF
 RST 32                 ;; 08F1:  E7
 RST 40                 ;; 08F2:  EF
 RST 56                 ;; 08F3:  FF
 RST 0                  ;; 08F4:  C7
 RST 8                  ;; 08F5:  CF
 RST 48                 ;; 08F6:  F7
 IN A, (0)              ;; 08F7:  DB 00
 IN A, (85)             ;; 08F9:  DB 55
 IN A, (170)            ;; 08FB:  DB AA
 IN A, (255)            ;; 08FD:  DB FF
 IN B, (C)              ;; 08FF:  ED 40
 IN C, (C)              ;; 0901:  ED 48
 IN D, (C)              ;; 0903:  ED 50
 IN E, (C)              ;; 0905:  ED 58
 IN H, (C)              ;; 0907:  ED 60
 IN L, (C)              ;; 0909:  ED 68
 IN A, (C)              ;; 090B:  ED 78
 INI                    ;; 090D:  ED A2
 INIR                   ;; 090F:  ED B2
 IND                    ;; 0911:  ED AA
 INDR                   ;; 0913:  ED BA
 OUT (0), A             ;; 0915:  D3 00
 OUT (85), A            ;; 0917:  D3 55
 OUT (170), A           ;; 0919:  D3 AA
 OUT (255), A           ;; 091B:  D3 FF
 OUT (C), B             ;; 091D:  ED 41
 OUT (C), C             ;; 091F:  ED 49
 OUT (C), D             ;; 0921:  ED 51
 OUT (C), E             ;; 0923:  ED 59
 OUT (C), H             ;; 0925:  ED 61
 OUT (C), L             ;; 0927:  ED 69
 OUT (C), A             ;; 0929:  ED 79
 OUTI                   ;; 092B:  ED A3
 OTIR                   ;; 092D:  ED B3
 OUTD                   ;; 092F:  ED AB
 OTDR                   ;; 0931:  ED BB
 DI                     ;; 0933:  F3
 EI                     ;; 0934:  FB
 IM 0                   ;; 0935:  ED 46
 IM 1                   ;; 0937:  ED 56
 IM 2                   ;; 0939:  ED 5E
 LD I, A                ;; 093B:  ED 47
 LD A, I                ;; 093D:  ED 57
 LD R, A                ;; 093F:  ED 4F
 LD A, R                ;; 0941:  ED 5F
 RETI                   ;; 0943:  ED 4D
 RETN                   ;; 0945:  ED 45
 ld b, b                ;; 0947:  40
 ld b, c                ;; 0948:  41
 ld b, d                ;; 0949:  42
 ld b, e                ;; 094A:  43
 ld b, h                ;; 094B:  44
 ld b, l                ;; 094C:  45
 ld b, a                ;; 094D:  47
 ld c, b                ;; 094E:  48
 ld c, c                ;; 094F:  49
 ld c, d                ;; 0950:  4A
 ld c, e                ;; 0951:  4B
 ld c, h                ;; 0952:  4C
 ld c, l                ;; 0953:  4D
 ld c, a                ;; 0954:  4F
 ld d, b                ;; 0955:  50
 ld d, c                ;; 0956:  51
 ld d, d                ;; 0957:  52
 ld d, e                ;; 0958:  53
 ld d, h                ;; 0959:  54
 ld d, l                ;; 095A:  55
 ld d, a                ;; 095B:  57
 ld e, b                ;; 095C:  58
 ld e, c                ;; 095D:  59
 ld e, d                ;; 095E:  5A
 ld e, e                ;; 095F:  5B
 ld e, h                ;; 0960:  5C
 ld e, l                ;; 0961:  5D
 ld e, a                ;; 0962:  5F
 ld h, b                ;; 0963:  60
 ld h, c                ;; 0964:  61
 ld h, d                ;; 0965:  62
 ld h, e                ;; 0966:  63
 ld h, h                ;; 0967:  64
 ld h, l                ;; 0968:  65
 ld h, a                ;; 0969:  67
 ld l, b                ;; 096A:  68
 ld l, c                ;; 096B:  69
 ld l, d                ;; 096C:  6A
 ld l, e                ;; 096D:  6B
 ld l, h                ;; 096E:  6C
 ld l, l                ;; 096F:  6D
 ld l, a                ;; 0970:  6F
 ld a, b                ;; 0971:  78
 ld a, c                ;; 0972:  79
 ld a, d                ;; 0973:  7A
 ld a, e                ;; 0974:  7B
 ld a, h                ;; 0975:  7C
 ld a, l                ;; 0976:  7D
 ld a, a                ;; 0977:  7F
 ld b, ixh              ;; 0978:  DD 44
 ld b, ixl              ;; 097A:  DD 45
 ld c, ixh              ;; 097C:  DD 4C
 ld c, ixl              ;; 097E:  DD 4D
 ld d, ixh              ;; 0980:  DD 54
 ld d, ixl              ;; 0982:  DD 55
 ld e, ixh              ;; 0984:  DD 5C
 ld e, ixl              ;; 0986:  DD 5D
 ld ixh, ixh            ;; 0988:  DD 64
 ld ixh, ixl            ;; 098A:  DD 65
 ld ixl, ixh            ;; 098C:  DD 6C
 ld ixl, ixl            ;; 098E:  DD 6D
 ld a, ixh              ;; 0990:  DD 7C
 ld a, ixl              ;; 0992:  DD 7D
 ld b, iyh              ;; 0994:  FD 44
 ld b, iyl              ;; 0996:  FD 45
 ld c, iyh              ;; 0998:  FD 4C
 ld c, iyl              ;; 099A:  FD 4D
 ld d, iyh              ;; 099C:  FD 54
 ld d, iyl              ;; 099E:  FD 55
 ld e, iyh              ;; 09A0:  FD 5C
 ld e, iyl              ;; 09A2:  FD 5D
 ld iyh, iyh            ;; 09A4:  FD 64
 ld iyh, iyl            ;; 09A6:  FD 65
 ld iyl, iyh            ;; 09A8:  FD 6C
 ld iyl, iyl            ;; 09AA:  FD 6D
 ld a, iyh              ;; 09AC:  FD 7C
 ld a, iyl              ;; 09AE:  FD 7D
 ld b, 0                ;; 09B0:  06 00
 ld b, 85               ;; 09B2:  06 55
 ld b, 170              ;; 09B4:  06 AA
 ld b, 255              ;; 09B6:  06 FF
 ld c, 0                ;; 09B8:  0E 00
 ld c, 85               ;; 09BA:  0E 55
 ld c, 170              ;; 09BC:  0E AA
 ld c, 255              ;; 09BE:  0E FF
 ld d, 0                ;; 09C0:  16 00
 ld d, 85               ;; 09C2:  16 55
 ld d, 170              ;; 09C4:  16 AA
 ld d, 255              ;; 09C6:  16 FF
 ld e, 0                ;; 09C8:  1E 00
 ld e, 85               ;; 09CA:  1E 55
 ld e, 170              ;; 09CC:  1E AA
 ld e, 255              ;; 09CE:  1E FF
 ld h, 0                ;; 09D0:  26 00
 ld h, 85               ;; 09D2:  26 55
 ld h, 170              ;; 09D4:  26 AA
 ld h, 255              ;; 09D6:  26 FF
 ld l, 0                ;; 09D8:  2E 00
 ld l, 85               ;; 09DA:  2E 55
 ld l, 170              ;; 09DC:  2E AA
 ld l, 255              ;; 09DE:  2E FF
 ld a, 0                ;; 09E0:  3E 00
 ld a, 85               ;; 09E2:  3E 55
 ld a, 170              ;; 09E4:  3E AA
 ld a, 255              ;; 09E6:  3E FF
 ld ixh, 0              ;; 09E8:  DD 26 00
 ld ixh, 85             ;; 09EB:  DD 26 55
 ld ixh, 170            ;; 09EE:  DD 26 AA
 ld ixh, 255            ;; 09F1:  DD 26 FF
 ld ixl, 0              ;; 09F4:  DD 2E 00
 ld ixl, 85             ;; 09F7:  DD 2E 55
 ld ixl, 170            ;; 09FA:  DD 2E AA
 ld ixl, 255            ;; 09FD:  DD 2E FF
 ld iyh, 0              ;; 0A00:  FD 26 00
 ld iyh, 85             ;; 0A03:  FD 26 55
 ld iyh, 170            ;; 0A06:  FD 26 AA
 ld iyh, 255            ;; 0A09:  FD 26 FF
 ld iyl, 0              ;; 0A0C:  FD 2E 00
 ld iyl, 85             ;; 0A0F:  FD 2E 55
 ld iyl, 170            ;; 0A12:  FD 2E AA
 ld iyl, 255            ;; 0A15:  FD 2E FF
 ld b, (hl)             ;; 0A18:  46
 ld c, (hl)             ;; 0A19:  4E
 ld d, (hl)             ;; 0A1A:  56
 ld e, (hl)             ;; 0A1B:  5E
 ld h, (hl)             ;; 0A1C:  66
 ld l, (hl)             ;; 0A1D:  6E
 ld a, (hl)             ;; 0A1E:  7E
 ld b, (ix + -128)      ;; 0A1F:  DD 46 80
 ld b, (ix + 0)         ;; 0A22:  DD 46 00
 ld b, (ix + 127)       ;; 0A25:  DD 46 7F
 ld c, (ix + -128)      ;; 0A28:  DD 4E 80
 ld c, (ix + 0)         ;; 0A2B:  DD 4E 00
 ld c, (ix + 127)       ;; 0A2E:  DD 4E 7F
 ld d, (ix + -128)      ;; 0A31:  DD 56 80
 ld d, (ix + 0)         ;; 0A34:  DD 56 00
 ld d, (ix + 127)       ;; 0A37:  DD 56 7F
 ld e, (ix + -128)      ;; 0A3A:  DD 5E 80
 ld e, (ix + 0)         ;; 0A3D:  DD 5E 00
 ld e, (ix + 127)       ;; 0A40:  DD 5E 7F
 ld h, (ix + -128)      ;; 0A43:  DD 66 80
 ld h, (ix + 0)         ;; 0A46:  DD 66 00
 ld h, (ix + 127)       ;; 0A49:  DD 66 7F
 ld l, (ix + -128)      ;; 0A4C:  DD 6E 80
 ld l, (ix + 0)         ;; 0A4F:  DD 6E 00
 ld l, (ix + 127)       ;; 0A52:  DD 6E 7F
 ld a, (ix + -128)      ;; 0A55:  DD 7E 80
 ld a, (ix + 0)         ;; 0A58:  DD 7E 00
 ld a, (ix + 127)       ;; 0A5B:  DD 7E 7F
 ld b, (iy + -128)      ;; 0A5E:  FD 46 80
 ld b, (iy + 0)         ;; 0A61:  FD 46 00
 ld b, (iy + 127)       ;; 0A64:  FD 46 7F
 ld c, (iy + -128)      ;; 0A67:  FD 4E 80
 ld c, (iy + 0)         ;; 0A6A:  FD 4E 00
 ld c, (iy + 127)       ;; 0A6D:  FD 4E 7F
 ld d, (iy + -128)      ;; 0A70:  FD 56 80
 ld d, (iy + 0)         ;; 0A73:  FD 56 00
 ld d, (iy + 127)       ;; 0A76:  FD 56 7F
 ld e, (iy + -128)      ;; 0A79:  FD 5E 80
 ld e, (iy + 0)         ;; 0A7C:  FD 5E 00
 ld e, (iy + 127)       ;; 0A7F:  FD 5E 7F
 ld h, (iy + -128)      ;; 0A82:  FD 66 80
 ld h, (iy + 0)         ;; 0A85:  FD 66 00
 ld h, (iy + 127)       ;; 0A88:  FD 66 7F
 ld l, (iy + -128)      ;; 0A8B:  FD 6E 80
 ld l, (iy + 0)         ;; 0A8E:  FD 6E 00
 ld l, (iy + 127)       ;; 0A91:  FD 6E 7F
 ld a, (iy + -128)      ;; 0A94:  FD 7E 80
 ld a, (iy + 0)         ;; 0A97:  FD 7E 00
 ld a, (iy + 127)       ;; 0A9A:  FD 7E 7F
 ld (hl), b             ;; 0A9D:  70
 ld (hl), c             ;; 0A9E:  71
 ld (hl), d             ;; 0A9F:  72
 ld (hl), e             ;; 0AA0:  73
 ld (hl), h             ;; 0AA1:  74
 ld (hl), l             ;; 0AA2:  75
 ld (hl), a             ;; 0AA3:  77
 ld (ix + -128), b      ;; 0AA4:  DD 70 80
 ld (ix + 0), b         ;; 0AA7:  DD 70 00
 ld (ix + 127), b       ;; 0AAA:  DD 70 7F
 ld (ix + -128), c      ;; 0AAD:  DD 71 80
 ld (ix + 0), c         ;; 0AB0:  DD 71 00
 ld (ix + 127), c       ;; 0AB3:  DD 71 7F
 ld (ix + -128), d      ;; 0AB6:  DD 72 80
 ld (ix + 0), d         ;; 0AB9:  DD 72 00
 ld (ix + 127), d       ;; 0ABC:  DD 72 7F
 ld (ix + -128), e      ;; 0ABF:  DD 73 80
 ld (ix + 0), e         ;; 0AC2:  DD 73 00
 ld (ix + 127), e       ;; 0AC5:  DD 73 7F
 ld (ix + -128), h      ;; 0AC8:  DD 74 80
 ld (ix + 0), h         ;; 0ACB:  DD 74 00
 ld (ix + 127), h       ;; 0ACE:  DD 74 7F
 ld (ix + -128), l      ;; 0AD1:  DD 75 80
 ld (ix + 0), l         ;; 0AD4:  DD 75 00
 ld (ix + 127), l       ;; 0AD7:  DD 75 7F
 ld (ix + -128), a      ;; 0ADA:  DD 77 80
 ld (ix + 0), a         ;; 0ADD:  DD 77 00
 ld (ix + 127), a       ;; 0AE0:  DD 77 7F
 ld (iy + -128), b      ;; 0AE3:  FD 70 80
 ld (iy + 0), b         ;; 0AE6:  FD 70 00
 ld (iy + 127), b       ;; 0AE9:  FD 70 7F
 ld (iy + -128), c      ;; 0AEC:  FD 71 80
 ld (iy + 0), c         ;; 0AEF:  FD 71 00
 ld (iy + 127), c       ;; 0AF2:  FD 71 7F
 ld (iy + -128), d      ;; 0AF5:  FD 72 80
 ld (iy + 0), d         ;; 0AF8:  FD 72 00
 ld (iy + 127), d       ;; 0AFB:  FD 72 7F
 ld (iy + -128), e      ;; 0AFE:  FD 73 80
 ld (iy + 0), e         ;; 0B01:  FD 73 00
 ld (iy + 127), e       ;; 0B04:  FD 73 7F
 ld (iy + -128), h      ;; 0B07:  FD 74 80
 ld (iy + 0), h         ;; 0B0A:  FD 74 00
 ld (iy + 127), h       ;; 0B0D:  FD 74 7F
 ld (iy + -128), l      ;; 0B10:  FD 75 80
 ld (iy + 0), l         ;; 0B13:  FD 75 00
 ld (iy + 127), l       ;; 0B16:  FD 75 7F
 ld (iy + -128), a      ;; 0B19:  FD 77 80
 ld (iy + 0), a         ;; 0B1C:  FD 77 00
 ld (iy + 127), a       ;; 0B1F:  FD 77 7F
 ld (hl), 0             ;; 0B22:  36 00
 ld (hl), 85            ;; 0B24:  36 55
 ld (hl), 170           ;; 0B26:  36 AA
 ld (hl), 255           ;; 0B28:  36 FF
 ld (ix + -128), 0      ;; 0B2A:  DD 36 80 00
 ld (ix + 0), 0         ;; 0B2E:  DD 36 00 00
 ld (ix + 127), 0       ;; 0B32:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0B36:  DD 36 80 55
 ld (ix + 0), 85        ;; 0B3A:  DD 36 00 55
 ld (ix + 127), 85      ;; 0B3E:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0B42:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0B46:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0B4A:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0B4E:  DD 36 80 FF
 ld (ix + 0), 255       ;; 0B52:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0B56:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0B5A:  FD 36 80 00
 ld (iy + 0), 0         ;; 0B5E:  FD 36 00 00
 ld (iy + 127), 0       ;; 0B62:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0B66:  FD 36 80 55
 ld (iy + 0), 85        ;; 0B6A:  FD 36 00 55
 ld (iy + 127), 85      ;; 0B6E:  FD 36 7F 55
 ld (iy + -128), 170    ;; 0B72:  FD 36 80 AA
 ld (iy + 0), 170       ;; 0B76:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0B7A:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0B7E:  FD 36 80 FF
 ld (iy + 0), 255       ;; 0B82:  FD 36 00 FF
 ld (iy + 127), 255     ;; 0B86:  FD 36 7F FF
 ld a, (bc)             ;; 0B8A:  0A
 ld a, (de)             ;; 0B8B:  1A
 ld (bc), a             ;; 0B8C:  02
 ld (de), a             ;; 0B8D:  12
 ld a, (0)              ;; 0B8E:  3A 00 00
 ld a, (291)            ;; 0B91:  3A 23 01
 ld a, (17767)          ;; 0B94:  3A 67 45
 ld a, (35243)          ;; 0B97:  3A AB 89
 ld a, (52719)          ;; 0B9A:  3A EF CD
 ld a, (65535)          ;; 0B9D:  3A FF FF
 ld (0), a              ;; 0BA0:  32 00 00
 ld (291), a            ;; 0BA3:  32 23 01
 ld (17767), a          ;; 0BA6:  32 67 45
 ld (35243), a          ;; 0BA9:  32 AB 89
 ld (52719), a          ;; 0BAC:  32 EF CD
 ld (65535), a          ;; 0BAF:  32 FF FF
