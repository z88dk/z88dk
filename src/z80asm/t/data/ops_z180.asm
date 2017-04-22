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
 ADD A, 0               ;; 016D:  C6 00
 ADD A, 85              ;; 016F:  C6 55
 ADD A, 170             ;; 0171:  C6 AA
 ADD A, 255             ;; 0173:  C6 FF
 ADC A, 0               ;; 0175:  CE 00
 ADC A, 85              ;; 0177:  CE 55
 ADC A, 170             ;; 0179:  CE AA
 ADC A, 255             ;; 017B:  CE FF
 SUB 0                  ;; 017D:  D6 00
 SUB 85                 ;; 017F:  D6 55
 SUB 170                ;; 0181:  D6 AA
 SUB 255                ;; 0183:  D6 FF
 SBC A, 0               ;; 0185:  DE 00
 SBC A, 85              ;; 0187:  DE 55
 SBC A, 170             ;; 0189:  DE AA
 SBC A, 255             ;; 018B:  DE FF
 AND 0                  ;; 018D:  E6 00
 AND 85                 ;; 018F:  E6 55
 AND 170                ;; 0191:  E6 AA
 AND 255                ;; 0193:  E6 FF
 XOR 0                  ;; 0195:  EE 00
 XOR 85                 ;; 0197:  EE 55
 XOR 170                ;; 0199:  EE AA
 XOR 255                ;; 019B:  EE FF
 OR 0                   ;; 019D:  F6 00
 OR 85                  ;; 019F:  F6 55
 OR 170                 ;; 01A1:  F6 AA
 OR 255                 ;; 01A3:  F6 FF
 CP 0                   ;; 01A5:  FE 00
 CP 85                  ;; 01A7:  FE 55
 CP 170                 ;; 01A9:  FE AA
 CP 255                 ;; 01AB:  FE FF
 ADD A, (HL)            ;; 01AD:  86
 ADC A, (HL)            ;; 01AE:  8E
 SUB (HL)               ;; 01AF:  96
 SBC A, (HL)            ;; 01B0:  9E
 AND (HL)               ;; 01B1:  A6
 XOR (HL)               ;; 01B2:  AE
 OR (HL)                ;; 01B3:  B6
 CP (HL)                ;; 01B4:  BE
 ADD A, (IX + -128)     ;; 01B5:  DD 86 80
 ADD A, (IX + 0)        ;; 01B8:  DD 86 00
 ADD A, (IX + 127)      ;; 01BB:  DD 86 7F
 ADC A, (IX + -128)     ;; 01BE:  DD 8E 80
 ADC A, (IX + 0)        ;; 01C1:  DD 8E 00
 ADC A, (IX + 127)      ;; 01C4:  DD 8E 7F
 SUB (IX + -128)        ;; 01C7:  DD 96 80
 SUB (IX + 0)           ;; 01CA:  DD 96 00
 SUB (IX + 127)         ;; 01CD:  DD 96 7F
 SBC A, (IX + -128)     ;; 01D0:  DD 9E 80
 SBC A, (IX + 0)        ;; 01D3:  DD 9E 00
 SBC A, (IX + 127)      ;; 01D6:  DD 9E 7F
 AND (IX + -128)        ;; 01D9:  DD A6 80
 AND (IX + 0)           ;; 01DC:  DD A6 00
 AND (IX + 127)         ;; 01DF:  DD A6 7F
 XOR (IX + -128)        ;; 01E2:  DD AE 80
 XOR (IX + 0)           ;; 01E5:  DD AE 00
 XOR (IX + 127)         ;; 01E8:  DD AE 7F
 OR (IX + -128)         ;; 01EB:  DD B6 80
 OR (IX + 0)            ;; 01EE:  DD B6 00
 OR (IX + 127)          ;; 01F1:  DD B6 7F
 CP (IX + -128)         ;; 01F4:  DD BE 80
 CP (IX + 0)            ;; 01F7:  DD BE 00
 CP (IX + 127)          ;; 01FA:  DD BE 7F
 ADD A, (IY + -128)     ;; 01FD:  FD 86 80
 ADD A, (IY + 0)        ;; 0200:  FD 86 00
 ADD A, (IY + 127)      ;; 0203:  FD 86 7F
 ADC A, (IY + -128)     ;; 0206:  FD 8E 80
 ADC A, (IY + 0)        ;; 0209:  FD 8E 00
 ADC A, (IY + 127)      ;; 020C:  FD 8E 7F
 SUB (IY + -128)        ;; 020F:  FD 96 80
 SUB (IY + 0)           ;; 0212:  FD 96 00
 SUB (IY + 127)         ;; 0215:  FD 96 7F
 SBC A, (IY + -128)     ;; 0218:  FD 9E 80
 SBC A, (IY + 0)        ;; 021B:  FD 9E 00
 SBC A, (IY + 127)      ;; 021E:  FD 9E 7F
 AND (IY + -128)        ;; 0221:  FD A6 80
 AND (IY + 0)           ;; 0224:  FD A6 00
 AND (IY + 127)         ;; 0227:  FD A6 7F
 XOR (IY + -128)        ;; 022A:  FD AE 80
 XOR (IY + 0)           ;; 022D:  FD AE 00
 XOR (IY + 127)         ;; 0230:  FD AE 7F
 OR (IY + -128)         ;; 0233:  FD B6 80
 OR (IY + 0)            ;; 0236:  FD B6 00
 OR (IY + 127)          ;; 0239:  FD B6 7F
 CP (IY + -128)         ;; 023C:  FD BE 80
 CP (IY + 0)            ;; 023F:  FD BE 00
 CP (IY + 127)          ;; 0242:  FD BE 7F
 INC B                  ;; 0245:  04
 INC C                  ;; 0246:  0C
 INC D                  ;; 0247:  14
 INC E                  ;; 0248:  1C
 INC H                  ;; 0249:  24
 INC L                  ;; 024A:  2C
 INC A                  ;; 024B:  3C
 INC (HL)               ;; 024C:  34
 INC (IX + -128)        ;; 024D:  DD 34 80
 INC (IX + 0)           ;; 0250:  DD 34 00
 INC (IX + 127)         ;; 0253:  DD 34 7F
 INC (IY + -128)        ;; 0256:  FD 34 80
 INC (IY + 0)           ;; 0259:  FD 34 00
 INC (IY + 127)         ;; 025C:  FD 34 7F
 DEC B                  ;; 025F:  05
 DEC C                  ;; 0260:  0D
 DEC D                  ;; 0261:  15
 DEC E                  ;; 0262:  1D
 DEC H                  ;; 0263:  25
 DEC L                  ;; 0264:  2D
 DEC A                  ;; 0265:  3D
 DEC (HL)               ;; 0266:  35
 DEC (IX + -128)        ;; 0267:  DD 35 80
 DEC (IX + 0)           ;; 026A:  DD 35 00
 DEC (IX + 127)         ;; 026D:  DD 35 7F
 DEC (IY + -128)        ;; 0270:  FD 35 80
 DEC (IY + 0)           ;; 0273:  FD 35 00
 DEC (IY + 127)         ;; 0276:  FD 35 7F
 TST B                  ;; 0279:  ED 04
 TST C                  ;; 027B:  ED 0C
 TST D                  ;; 027D:  ED 14
 TST E                  ;; 027F:  ED 1C
 TST H                  ;; 0281:  ED 24
 TST L                  ;; 0283:  ED 2C
 TST A                  ;; 0285:  ED 3C
 TST 0                  ;; 0287:  ED 64 00
 TST 85                 ;; 028A:  ED 64 55
 TST 170                ;; 028D:  ED 64 AA
 TST 255                ;; 0290:  ED 64 FF
 TST (HL)               ;; 0293:  ED 34
 DAA                    ;; 0295:  27
 RLD                    ;; 0296:  ED 6F
 RRD                    ;; 0298:  ED 67
 CPL                    ;; 029A:  2F
 NEG                    ;; 029B:  ED 44
 CCF                    ;; 029D:  3F
 SCF                    ;; 029E:  37
 NOP                    ;; 029F:  00
 HALT                   ;; 02A0:  76
 SLP                    ;; 02A1:  ED 76
 ADD HL, BC             ;; 02A3:  09
 ADD HL, DE             ;; 02A4:  19
 ADD HL, HL             ;; 02A5:  29
 ADD HL, SP             ;; 02A6:  39
 ADD IX, BC             ;; 02A7:  DD 09
 ADD IY, BC             ;; 02A9:  FD 09
 ADD IX, DE             ;; 02AB:  DD 19
 ADD IY, DE             ;; 02AD:  FD 19
 ADD IX, IX             ;; 02AF:  DD 29
 ADD IY, IY             ;; 02B1:  FD 29
 ADD IX, SP             ;; 02B3:  DD 39
 ADD IY, SP             ;; 02B5:  FD 39
 ADC HL, BC             ;; 02B7:  ED 4A
 ADC HL, DE             ;; 02B9:  ED 5A
 ADC HL, HL             ;; 02BB:  ED 6A
 ADC HL, SP             ;; 02BD:  ED 7A
 SBC HL, BC             ;; 02BF:  ED 42
 SBC HL, DE             ;; 02C1:  ED 52
 SBC HL, HL             ;; 02C3:  ED 62
 SBC HL, SP             ;; 02C5:  ED 72
 INC BC                 ;; 02C7:  03
 INC DE                 ;; 02C8:  13
 INC HL                 ;; 02C9:  23
 INC SP                 ;; 02CA:  33
 INC IX                 ;; 02CB:  DD 23
 INC IY                 ;; 02CD:  FD 23
 DEC BC                 ;; 02CF:  0B
 DEC DE                 ;; 02D0:  1B
 DEC HL                 ;; 02D1:  2B
 DEC SP                 ;; 02D2:  3B
 DEC IX                 ;; 02D3:  DD 2B
 DEC IY                 ;; 02D5:  FD 2B
 MLT BC                 ;; 02D7:  ED 4C
 MLT DE                 ;; 02D9:  ED 5C
 MLT HL                 ;; 02DB:  ED 6C
 MLT SP                 ;; 02DD:  ED 7C
 RLCA                   ;; 02DF:  07
 RRCA                   ;; 02E0:  0F
 RLA                    ;; 02E1:  17
 RRA                    ;; 02E2:  1F
 RLC B                  ;; 02E3:  CB 00
 RRC B                  ;; 02E5:  CB 08
 RL B                   ;; 02E7:  CB 10
 RR B                   ;; 02E9:  CB 18
 SLA B                  ;; 02EB:  CB 20
 SRA B                  ;; 02ED:  CB 28
 SRL B                  ;; 02EF:  CB 38
 RLC C                  ;; 02F1:  CB 01
 RRC C                  ;; 02F3:  CB 09
 RL C                   ;; 02F5:  CB 11
 RR C                   ;; 02F7:  CB 19
 SLA C                  ;; 02F9:  CB 21
 SRA C                  ;; 02FB:  CB 29
 SRL C                  ;; 02FD:  CB 39
 RLC D                  ;; 02FF:  CB 02
 RRC D                  ;; 0301:  CB 0A
 RL D                   ;; 0303:  CB 12
 RR D                   ;; 0305:  CB 1A
 SLA D                  ;; 0307:  CB 22
 SRA D                  ;; 0309:  CB 2A
 SRL D                  ;; 030B:  CB 3A
 RLC E                  ;; 030D:  CB 03
 RRC E                  ;; 030F:  CB 0B
 RL E                   ;; 0311:  CB 13
 RR E                   ;; 0313:  CB 1B
 SLA E                  ;; 0315:  CB 23
 SRA E                  ;; 0317:  CB 2B
 SRL E                  ;; 0319:  CB 3B
 RLC H                  ;; 031B:  CB 04
 RRC H                  ;; 031D:  CB 0C
 RL H                   ;; 031F:  CB 14
 RR H                   ;; 0321:  CB 1C
 SLA H                  ;; 0323:  CB 24
 SRA H                  ;; 0325:  CB 2C
 SRL H                  ;; 0327:  CB 3C
 RLC L                  ;; 0329:  CB 05
 RRC L                  ;; 032B:  CB 0D
 RL L                   ;; 032D:  CB 15
 RR L                   ;; 032F:  CB 1D
 SLA L                  ;; 0331:  CB 25
 SRA L                  ;; 0333:  CB 2D
 SRL L                  ;; 0335:  CB 3D
 RLC A                  ;; 0337:  CB 07
 RRC A                  ;; 0339:  CB 0F
 RL A                   ;; 033B:  CB 17
 RR A                   ;; 033D:  CB 1F
 SLA A                  ;; 033F:  CB 27
 SRA A                  ;; 0341:  CB 2F
 SRL A                  ;; 0343:  CB 3F
 SLL B                  ;; 0345:  CB 30
 SLL C                  ;; 0347:  CB 31
 SLL D                  ;; 0349:  CB 32
 SLL E                  ;; 034B:  CB 33
 SLL H                  ;; 034D:  CB 34
 SLL L                  ;; 034F:  CB 35
 SLL A                  ;; 0351:  CB 37
 RLC (HL)               ;; 0353:  CB 06
 RRC (HL)               ;; 0355:  CB 0E
 RL (HL)                ;; 0357:  CB 16
 RR (HL)                ;; 0359:  CB 1E
 SLA (HL)               ;; 035B:  CB 26
 SRA (HL)               ;; 035D:  CB 2E
 SRL (HL)               ;; 035F:  CB 3E
 SLL (HL)               ;; 0361:  CB 36
 RLC (IX + -128)        ;; 0363:  DD CB 80 06
 RLC (IX + 0)           ;; 0367:  DD CB 00 06
 RLC (IX + 127)         ;; 036B:  DD CB 7F 06
 RRC (IX + -128)        ;; 036F:  DD CB 80 0E
 RRC (IX + 0)           ;; 0373:  DD CB 00 0E
 RRC (IX + 127)         ;; 0377:  DD CB 7F 0E
 RL (IX + -128)         ;; 037B:  DD CB 80 16
 RL (IX + 0)            ;; 037F:  DD CB 00 16
 RL (IX + 127)          ;; 0383:  DD CB 7F 16
 RR (IX + -128)         ;; 0387:  DD CB 80 1E
 RR (IX + 0)            ;; 038B:  DD CB 00 1E
 RR (IX + 127)          ;; 038F:  DD CB 7F 1E
 SLA (IX + -128)        ;; 0393:  DD CB 80 26
 SLA (IX + 0)           ;; 0397:  DD CB 00 26
 SLA (IX + 127)         ;; 039B:  DD CB 7F 26
 SRA (IX + -128)        ;; 039F:  DD CB 80 2E
 SRA (IX + 0)           ;; 03A3:  DD CB 00 2E
 SRA (IX + 127)         ;; 03A7:  DD CB 7F 2E
 SRL (IX + -128)        ;; 03AB:  DD CB 80 3E
 SRL (IX + 0)           ;; 03AF:  DD CB 00 3E
 SRL (IX + 127)         ;; 03B3:  DD CB 7F 3E
 RLC (IY + -128)        ;; 03B7:  FD CB 80 06
 RLC (IY + 0)           ;; 03BB:  FD CB 00 06
 RLC (IY + 127)         ;; 03BF:  FD CB 7F 06
 RRC (IY + -128)        ;; 03C3:  FD CB 80 0E
 RRC (IY + 0)           ;; 03C7:  FD CB 00 0E
 RRC (IY + 127)         ;; 03CB:  FD CB 7F 0E
 RL (IY + -128)         ;; 03CF:  FD CB 80 16
 RL (IY + 0)            ;; 03D3:  FD CB 00 16
 RL (IY + 127)          ;; 03D7:  FD CB 7F 16
 RR (IY + -128)         ;; 03DB:  FD CB 80 1E
 RR (IY + 0)            ;; 03DF:  FD CB 00 1E
 RR (IY + 127)          ;; 03E3:  FD CB 7F 1E
 SLA (IY + -128)        ;; 03E7:  FD CB 80 26
 SLA (IY + 0)           ;; 03EB:  FD CB 00 26
 SLA (IY + 127)         ;; 03EF:  FD CB 7F 26
 SRA (IY + -128)        ;; 03F3:  FD CB 80 2E
 SRA (IY + 0)           ;; 03F7:  FD CB 00 2E
 SRA (IY + 127)         ;; 03FB:  FD CB 7F 2E
 SRL (IY + -128)        ;; 03FF:  FD CB 80 3E
 SRL (IY + 0)           ;; 0403:  FD CB 00 3E
 SRL (IY + 127)         ;; 0407:  FD CB 7F 3E
 SLL (IX + -128)        ;; 040B:  DD CB 80 36
 SLL (IX + 0)           ;; 040F:  DD CB 00 36
 SLL (IX + 127)         ;; 0413:  DD CB 7F 36
 SLL (IY + -128)        ;; 0417:  FD CB 80 36
 SLL (IY + 0)           ;; 041B:  FD CB 00 36
 SLL (IY + 127)         ;; 041F:  FD CB 7F 36
 BIT 0, B               ;; 0423:  CB 40
 BIT 1, B               ;; 0425:  CB 48
 BIT 2, B               ;; 0427:  CB 50
 BIT 3, B               ;; 0429:  CB 58
 BIT 4, B               ;; 042B:  CB 60
 BIT 5, B               ;; 042D:  CB 68
 BIT 6, B               ;; 042F:  CB 70
 BIT 7, B               ;; 0431:  CB 78
 RES 0, B               ;; 0433:  CB 80
 RES 1, B               ;; 0435:  CB 88
 RES 2, B               ;; 0437:  CB 90
 RES 3, B               ;; 0439:  CB 98
 RES 4, B               ;; 043B:  CB A0
 RES 5, B               ;; 043D:  CB A8
 RES 6, B               ;; 043F:  CB B0
 RES 7, B               ;; 0441:  CB B8
 SET 0, B               ;; 0443:  CB C0
 SET 1, B               ;; 0445:  CB C8
 SET 2, B               ;; 0447:  CB D0
 SET 3, B               ;; 0449:  CB D8
 SET 4, B               ;; 044B:  CB E0
 SET 5, B               ;; 044D:  CB E8
 SET 6, B               ;; 044F:  CB F0
 SET 7, B               ;; 0451:  CB F8
 BIT 0, C               ;; 0453:  CB 41
 BIT 1, C               ;; 0455:  CB 49
 BIT 2, C               ;; 0457:  CB 51
 BIT 3, C               ;; 0459:  CB 59
 BIT 4, C               ;; 045B:  CB 61
 BIT 5, C               ;; 045D:  CB 69
 BIT 6, C               ;; 045F:  CB 71
 BIT 7, C               ;; 0461:  CB 79
 RES 0, C               ;; 0463:  CB 81
 RES 1, C               ;; 0465:  CB 89
 RES 2, C               ;; 0467:  CB 91
 RES 3, C               ;; 0469:  CB 99
 RES 4, C               ;; 046B:  CB A1
 RES 5, C               ;; 046D:  CB A9
 RES 6, C               ;; 046F:  CB B1
 RES 7, C               ;; 0471:  CB B9
 SET 0, C               ;; 0473:  CB C1
 SET 1, C               ;; 0475:  CB C9
 SET 2, C               ;; 0477:  CB D1
 SET 3, C               ;; 0479:  CB D9
 SET 4, C               ;; 047B:  CB E1
 SET 5, C               ;; 047D:  CB E9
 SET 6, C               ;; 047F:  CB F1
 SET 7, C               ;; 0481:  CB F9
 BIT 0, D               ;; 0483:  CB 42
 BIT 1, D               ;; 0485:  CB 4A
 BIT 2, D               ;; 0487:  CB 52
 BIT 3, D               ;; 0489:  CB 5A
 BIT 4, D               ;; 048B:  CB 62
 BIT 5, D               ;; 048D:  CB 6A
 BIT 6, D               ;; 048F:  CB 72
 BIT 7, D               ;; 0491:  CB 7A
 RES 0, D               ;; 0493:  CB 82
 RES 1, D               ;; 0495:  CB 8A
 RES 2, D               ;; 0497:  CB 92
 RES 3, D               ;; 0499:  CB 9A
 RES 4, D               ;; 049B:  CB A2
 RES 5, D               ;; 049D:  CB AA
 RES 6, D               ;; 049F:  CB B2
 RES 7, D               ;; 04A1:  CB BA
 SET 0, D               ;; 04A3:  CB C2
 SET 1, D               ;; 04A5:  CB CA
 SET 2, D               ;; 04A7:  CB D2
 SET 3, D               ;; 04A9:  CB DA
 SET 4, D               ;; 04AB:  CB E2
 SET 5, D               ;; 04AD:  CB EA
 SET 6, D               ;; 04AF:  CB F2
 SET 7, D               ;; 04B1:  CB FA
 BIT 0, E               ;; 04B3:  CB 43
 BIT 1, E               ;; 04B5:  CB 4B
 BIT 2, E               ;; 04B7:  CB 53
 BIT 3, E               ;; 04B9:  CB 5B
 BIT 4, E               ;; 04BB:  CB 63
 BIT 5, E               ;; 04BD:  CB 6B
 BIT 6, E               ;; 04BF:  CB 73
 BIT 7, E               ;; 04C1:  CB 7B
 RES 0, E               ;; 04C3:  CB 83
 RES 1, E               ;; 04C5:  CB 8B
 RES 2, E               ;; 04C7:  CB 93
 RES 3, E               ;; 04C9:  CB 9B
 RES 4, E               ;; 04CB:  CB A3
 RES 5, E               ;; 04CD:  CB AB
 RES 6, E               ;; 04CF:  CB B3
 RES 7, E               ;; 04D1:  CB BB
 SET 0, E               ;; 04D3:  CB C3
 SET 1, E               ;; 04D5:  CB CB
 SET 2, E               ;; 04D7:  CB D3
 SET 3, E               ;; 04D9:  CB DB
 SET 4, E               ;; 04DB:  CB E3
 SET 5, E               ;; 04DD:  CB EB
 SET 6, E               ;; 04DF:  CB F3
 SET 7, E               ;; 04E1:  CB FB
 BIT 0, H               ;; 04E3:  CB 44
 BIT 1, H               ;; 04E5:  CB 4C
 BIT 2, H               ;; 04E7:  CB 54
 BIT 3, H               ;; 04E9:  CB 5C
 BIT 4, H               ;; 04EB:  CB 64
 BIT 5, H               ;; 04ED:  CB 6C
 BIT 6, H               ;; 04EF:  CB 74
 BIT 7, H               ;; 04F1:  CB 7C
 RES 0, H               ;; 04F3:  CB 84
 RES 1, H               ;; 04F5:  CB 8C
 RES 2, H               ;; 04F7:  CB 94
 RES 3, H               ;; 04F9:  CB 9C
 RES 4, H               ;; 04FB:  CB A4
 RES 5, H               ;; 04FD:  CB AC
 RES 6, H               ;; 04FF:  CB B4
 RES 7, H               ;; 0501:  CB BC
 SET 0, H               ;; 0503:  CB C4
 SET 1, H               ;; 0505:  CB CC
 SET 2, H               ;; 0507:  CB D4
 SET 3, H               ;; 0509:  CB DC
 SET 4, H               ;; 050B:  CB E4
 SET 5, H               ;; 050D:  CB EC
 SET 6, H               ;; 050F:  CB F4
 SET 7, H               ;; 0511:  CB FC
 BIT 0, L               ;; 0513:  CB 45
 BIT 1, L               ;; 0515:  CB 4D
 BIT 2, L               ;; 0517:  CB 55
 BIT 3, L               ;; 0519:  CB 5D
 BIT 4, L               ;; 051B:  CB 65
 BIT 5, L               ;; 051D:  CB 6D
 BIT 6, L               ;; 051F:  CB 75
 BIT 7, L               ;; 0521:  CB 7D
 RES 0, L               ;; 0523:  CB 85
 RES 1, L               ;; 0525:  CB 8D
 RES 2, L               ;; 0527:  CB 95
 RES 3, L               ;; 0529:  CB 9D
 RES 4, L               ;; 052B:  CB A5
 RES 5, L               ;; 052D:  CB AD
 RES 6, L               ;; 052F:  CB B5
 RES 7, L               ;; 0531:  CB BD
 SET 0, L               ;; 0533:  CB C5
 SET 1, L               ;; 0535:  CB CD
 SET 2, L               ;; 0537:  CB D5
 SET 3, L               ;; 0539:  CB DD
 SET 4, L               ;; 053B:  CB E5
 SET 5, L               ;; 053D:  CB ED
 SET 6, L               ;; 053F:  CB F5
 SET 7, L               ;; 0541:  CB FD
 BIT 0, A               ;; 0543:  CB 47
 BIT 1, A               ;; 0545:  CB 4F
 BIT 2, A               ;; 0547:  CB 57
 BIT 3, A               ;; 0549:  CB 5F
 BIT 4, A               ;; 054B:  CB 67
 BIT 5, A               ;; 054D:  CB 6F
 BIT 6, A               ;; 054F:  CB 77
 BIT 7, A               ;; 0551:  CB 7F
 RES 0, A               ;; 0553:  CB 87
 RES 1, A               ;; 0555:  CB 8F
 RES 2, A               ;; 0557:  CB 97
 RES 3, A               ;; 0559:  CB 9F
 RES 4, A               ;; 055B:  CB A7
 RES 5, A               ;; 055D:  CB AF
 RES 6, A               ;; 055F:  CB B7
 RES 7, A               ;; 0561:  CB BF
 SET 0, A               ;; 0563:  CB C7
 SET 1, A               ;; 0565:  CB CF
 SET 2, A               ;; 0567:  CB D7
 SET 3, A               ;; 0569:  CB DF
 SET 4, A               ;; 056B:  CB E7
 SET 5, A               ;; 056D:  CB EF
 SET 6, A               ;; 056F:  CB F7
 SET 7, A               ;; 0571:  CB FF
 BIT 0, (HL)            ;; 0573:  CB 46
 BIT 1, (HL)            ;; 0575:  CB 4E
 BIT 2, (HL)            ;; 0577:  CB 56
 BIT 3, (HL)            ;; 0579:  CB 5E
 BIT 4, (HL)            ;; 057B:  CB 66
 BIT 5, (HL)            ;; 057D:  CB 6E
 BIT 6, (HL)            ;; 057F:  CB 76
 BIT 7, (HL)            ;; 0581:  CB 7E
 RES 0, (HL)            ;; 0583:  CB 86
 RES 1, (HL)            ;; 0585:  CB 8E
 RES 2, (HL)            ;; 0587:  CB 96
 RES 3, (HL)            ;; 0589:  CB 9E
 RES 4, (HL)            ;; 058B:  CB A6
 RES 5, (HL)            ;; 058D:  CB AE
 RES 6, (HL)            ;; 058F:  CB B6
 RES 7, (HL)            ;; 0591:  CB BE
 SET 0, (HL)            ;; 0593:  CB C6
 SET 1, (HL)            ;; 0595:  CB CE
 SET 2, (HL)            ;; 0597:  CB D6
 SET 3, (HL)            ;; 0599:  CB DE
 SET 4, (HL)            ;; 059B:  CB E6
 SET 5, (HL)            ;; 059D:  CB EE
 SET 6, (HL)            ;; 059F:  CB F6
 SET 7, (HL)            ;; 05A1:  CB FE
 BIT 0, (IX + -128)     ;; 05A3:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 05A7:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 05AB:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 05AF:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 05B3:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 05B7:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 05BB:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 05BF:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 05C3:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 05C7:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 05CB:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 05CF:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 05D3:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 05D7:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 05DB:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 05DF:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 05E3:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 05E7:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 05EB:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 05EF:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 05F3:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 05F7:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 05FB:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 05FF:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 0603:  DD CB 80 86
 RES 1, (IX + -128)     ;; 0607:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 060B:  DD CB 80 96
 RES 3, (IX + -128)     ;; 060F:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 0613:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 0617:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 061B:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 061F:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 0623:  DD CB 00 86
 RES 1, (IX + 0)        ;; 0627:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 062B:  DD CB 00 96
 RES 3, (IX + 0)        ;; 062F:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 0633:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 0637:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 063B:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 063F:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 0643:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 0647:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 064B:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 064F:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 0653:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 0657:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 065B:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 065F:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0663:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 0667:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 066B:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 066F:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0673:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 0677:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 067B:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 067F:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0683:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 0687:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 068B:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 068F:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0693:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 0697:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 069B:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 069F:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 06A3:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 06A7:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 06AB:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 06AF:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 06B3:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 06B7:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 06BB:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 06BF:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 06C3:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 06C7:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 06CB:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 06CF:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 06D3:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 06D7:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 06DB:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 06DF:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 06E3:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 06E7:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 06EB:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 06EF:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 06F3:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 06F7:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 06FB:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 06FF:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 0703:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 0707:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 070B:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 070F:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 0713:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 0717:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 071B:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 071F:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 0723:  FD CB 80 86
 RES 1, (IY + -128)     ;; 0727:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 072B:  FD CB 80 96
 RES 3, (IY + -128)     ;; 072F:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 0733:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 0737:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 073B:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 073F:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 0743:  FD CB 00 86
 RES 1, (IY + 0)        ;; 0747:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 074B:  FD CB 00 96
 RES 3, (IY + 0)        ;; 074F:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 0753:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 0757:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 075B:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 075F:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0763:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 0767:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 076B:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 076F:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0773:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 0777:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 077B:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 077F:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0783:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 0787:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 078B:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 078F:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0793:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 0797:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 079B:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 079F:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 07A3:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 07A7:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 07AB:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 07AF:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 07B3:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 07B7:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 07BB:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 07BF:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 07C3:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 07C7:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 07CB:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 07CF:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 07D3:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 07D7:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 07DB:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 07DF:  FD CB 7F FE
 JP 0                   ;; 07E3:  C3 00 00
 JP 4660                ;; 07E6:  C3 34 12
 JP 52719               ;; 07E9:  C3 EF CD
 JP 65535               ;; 07EC:  C3 FF FF
 JP NZ, 0               ;; 07EF:  C2 00 00
 JP NZ, 4660            ;; 07F2:  C2 34 12
 JP NZ, 52719           ;; 07F5:  C2 EF CD
 JP NZ, 65535           ;; 07F8:  C2 FF FF
 JP Z, 0                ;; 07FB:  CA 00 00
 JP Z, 4660             ;; 07FE:  CA 34 12
 JP Z, 52719            ;; 0801:  CA EF CD
 JP Z, 65535            ;; 0804:  CA FF FF
 JP NC, 0               ;; 0807:  D2 00 00
 JP NC, 4660            ;; 080A:  D2 34 12
 JP NC, 52719           ;; 080D:  D2 EF CD
 JP NC, 65535           ;; 0810:  D2 FF FF
 JP C, 0                ;; 0813:  DA 00 00
 JP C, 4660             ;; 0816:  DA 34 12
 JP C, 52719            ;; 0819:  DA EF CD
 JP C, 65535            ;; 081C:  DA FF FF
 JP PO, 0               ;; 081F:  E2 00 00
 JP PO, 4660            ;; 0822:  E2 34 12
 JP PO, 52719           ;; 0825:  E2 EF CD
 JP PO, 65535           ;; 0828:  E2 FF FF
 JP PE, 0               ;; 082B:  EA 00 00
 JP PE, 4660            ;; 082E:  EA 34 12
 JP PE, 52719           ;; 0831:  EA EF CD
 JP PE, 65535           ;; 0834:  EA FF FF
 JP P, 0                ;; 0837:  F2 00 00
 JP P, 4660             ;; 083A:  F2 34 12
 JP P, 52719            ;; 083D:  F2 EF CD
 JP P, 65535            ;; 0840:  F2 FF FF
 JP M, 0                ;; 0843:  FA 00 00
 JP M, 4660             ;; 0846:  FA 34 12
 JP M, 52719            ;; 0849:  FA EF CD
 JP M, 65535            ;; 084C:  FA FF FF
 JR ASMPC+2             ;; 084F:  18 00
 JR NZ, ASMPC+2         ;; 0851:  20 00
 JR Z, ASMPC+2          ;; 0853:  28 00
 JR NC, ASMPC+2         ;; 0855:  30 00
 JR C, ASMPC+2          ;; 0857:  38 00
 JP (HL)                ;; 0859:  E9
 JP (IX)                ;; 085A:  DD E9
 JP (IY)                ;; 085C:  FD E9
 DJNZ ASMPC+2           ;; 085E:  10 00
 CALL 0                 ;; 0860:  CD 00 00
 CALL 4660              ;; 0863:  CD 34 12
 CALL 52719             ;; 0866:  CD EF CD
 CALL 65535             ;; 0869:  CD FF FF
 CALL NZ, 0             ;; 086C:  C4 00 00
 CALL NZ, 4660          ;; 086F:  C4 34 12
 CALL NZ, 52719         ;; 0872:  C4 EF CD
 CALL NZ, 65535         ;; 0875:  C4 FF FF
 CALL Z, 0              ;; 0878:  CC 00 00
 CALL Z, 4660           ;; 087B:  CC 34 12
 CALL Z, 52719          ;; 087E:  CC EF CD
 CALL Z, 65535          ;; 0881:  CC FF FF
 CALL NC, 0             ;; 0884:  D4 00 00
 CALL NC, 4660          ;; 0887:  D4 34 12
 CALL NC, 52719         ;; 088A:  D4 EF CD
 CALL NC, 65535         ;; 088D:  D4 FF FF
 CALL C, 0              ;; 0890:  DC 00 00
 CALL C, 4660           ;; 0893:  DC 34 12
 CALL C, 52719          ;; 0896:  DC EF CD
 CALL C, 65535          ;; 0899:  DC FF FF
 CALL PO, 0             ;; 089C:  E4 00 00
 CALL PO, 4660          ;; 089F:  E4 34 12
 CALL PO, 52719         ;; 08A2:  E4 EF CD
 CALL PO, 65535         ;; 08A5:  E4 FF FF
 CALL PE, 0             ;; 08A8:  EC 00 00
 CALL PE, 4660          ;; 08AB:  EC 34 12
 CALL PE, 52719         ;; 08AE:  EC EF CD
 CALL PE, 65535         ;; 08B1:  EC FF FF
 CALL P, 0              ;; 08B4:  F4 00 00
 CALL P, 4660           ;; 08B7:  F4 34 12
 CALL P, 52719          ;; 08BA:  F4 EF CD
 CALL P, 65535          ;; 08BD:  F4 FF FF
 CALL M, 0              ;; 08C0:  FC 00 00
 CALL M, 4660           ;; 08C3:  FC 34 12
 CALL M, 52719          ;; 08C6:  FC EF CD
 CALL M, 65535          ;; 08C9:  FC FF FF
 RET                    ;; 08CC:  C9
 RET NZ                 ;; 08CD:  C0
 RET Z                  ;; 08CE:  C8
 RET NC                 ;; 08CF:  D0
 RET C                  ;; 08D0:  D8
 RET PO                 ;; 08D1:  E0
 RET PE                 ;; 08D2:  E8
 RET P                  ;; 08D3:  F0
 RET M                  ;; 08D4:  F8
 RST 16                 ;; 08D5:  D7
 RST 24                 ;; 08D6:  DF
 RST 32                 ;; 08D7:  E7
 RST 40                 ;; 08D8:  EF
 RST 56                 ;; 08D9:  FF
 RST 0                  ;; 08DA:  C7
 RST 8                  ;; 08DB:  CF
 RST 48                 ;; 08DC:  F7
 IN A, (0)              ;; 08DD:  DB 00
 IN A, (85)             ;; 08DF:  DB 55
 IN A, (170)            ;; 08E1:  DB AA
 IN A, (255)            ;; 08E3:  DB FF
 IN B, (C)              ;; 08E5:  ED 40
 IN C, (C)              ;; 08E7:  ED 48
 IN D, (C)              ;; 08E9:  ED 50
 IN E, (C)              ;; 08EB:  ED 58
 IN H, (C)              ;; 08ED:  ED 60
 IN L, (C)              ;; 08EF:  ED 68
 IN A, (C)              ;; 08F1:  ED 78
 INI                    ;; 08F3:  ED A2
 INIR                   ;; 08F5:  ED B2
 IND                    ;; 08F7:  ED AA
 INDR                   ;; 08F9:  ED BA
 OUT (0), A             ;; 08FB:  D3 00
 OUT (85), A            ;; 08FD:  D3 55
 OUT (170), A           ;; 08FF:  D3 AA
 OUT (255), A           ;; 0901:  D3 FF
 OUT (C), B             ;; 0903:  ED 41
 OUT (C), C             ;; 0905:  ED 49
 OUT (C), D             ;; 0907:  ED 51
 OUT (C), E             ;; 0909:  ED 59
 OUT (C), H             ;; 090B:  ED 61
 OUT (C), L             ;; 090D:  ED 69
 OUT (C), A             ;; 090F:  ED 79
 OUTI                   ;; 0911:  ED A3
 OTIR                   ;; 0913:  ED B3
 OUTD                   ;; 0915:  ED AB
 OTDR                   ;; 0917:  ED BB
 IN0 B, (0)             ;; 0919:  ED 00 00
 IN0 B, (85)            ;; 091C:  ED 00 55
 IN0 B, (170)           ;; 091F:  ED 00 AA
 IN0 B, (255)           ;; 0922:  ED 00 FF
 IN0 C, (0)             ;; 0925:  ED 08 00
 IN0 C, (85)            ;; 0928:  ED 08 55
 IN0 C, (170)           ;; 092B:  ED 08 AA
 IN0 C, (255)           ;; 092E:  ED 08 FF
 IN0 D, (0)             ;; 0931:  ED 10 00
 IN0 D, (85)            ;; 0934:  ED 10 55
 IN0 D, (170)           ;; 0937:  ED 10 AA
 IN0 D, (255)           ;; 093A:  ED 10 FF
 IN0 E, (0)             ;; 093D:  ED 18 00
 IN0 E, (85)            ;; 0940:  ED 18 55
 IN0 E, (170)           ;; 0943:  ED 18 AA
 IN0 E, (255)           ;; 0946:  ED 18 FF
 IN0 H, (0)             ;; 0949:  ED 20 00
 IN0 H, (85)            ;; 094C:  ED 20 55
 IN0 H, (170)           ;; 094F:  ED 20 AA
 IN0 H, (255)           ;; 0952:  ED 20 FF
 IN0 L, (0)             ;; 0955:  ED 28 00
 IN0 L, (85)            ;; 0958:  ED 28 55
 IN0 L, (170)           ;; 095B:  ED 28 AA
 IN0 L, (255)           ;; 095E:  ED 28 FF
 IN0 A, (0)             ;; 0961:  ED 38 00
 IN0 A, (85)            ;; 0964:  ED 38 55
 IN0 A, (170)           ;; 0967:  ED 38 AA
 IN0 A, (255)           ;; 096A:  ED 38 FF
 OUT0 (0), B            ;; 096D:  ED 01 00
 OUT0 (85), B           ;; 0970:  ED 01 55
 OUT0 (170), B          ;; 0973:  ED 01 AA
 OUT0 (255), B          ;; 0976:  ED 01 FF
 OUT0 (0), C            ;; 0979:  ED 09 00
 OUT0 (85), C           ;; 097C:  ED 09 55
 OUT0 (170), C          ;; 097F:  ED 09 AA
 OUT0 (255), C          ;; 0982:  ED 09 FF
 OUT0 (0), D            ;; 0985:  ED 11 00
 OUT0 (85), D           ;; 0988:  ED 11 55
 OUT0 (170), D          ;; 098B:  ED 11 AA
 OUT0 (255), D          ;; 098E:  ED 11 FF
 OUT0 (0), E            ;; 0991:  ED 19 00
 OUT0 (85), E           ;; 0994:  ED 19 55
 OUT0 (170), E          ;; 0997:  ED 19 AA
 OUT0 (255), E          ;; 099A:  ED 19 FF
 OUT0 (0), H            ;; 099D:  ED 21 00
 OUT0 (85), H           ;; 09A0:  ED 21 55
 OUT0 (170), H          ;; 09A3:  ED 21 AA
 OUT0 (255), H          ;; 09A6:  ED 21 FF
 OUT0 (0), L            ;; 09A9:  ED 29 00
 OUT0 (85), L           ;; 09AC:  ED 29 55
 OUT0 (170), L          ;; 09AF:  ED 29 AA
 OUT0 (255), L          ;; 09B2:  ED 29 FF
 OUT0 (0), A            ;; 09B5:  ED 39 00
 OUT0 (85), A           ;; 09B8:  ED 39 55
 OUT0 (170), A          ;; 09BB:  ED 39 AA
 OUT0 (255), A          ;; 09BE:  ED 39 FF
 OTDM                   ;; 09C1:  ED 8B
 OTDMR                  ;; 09C3:  ED 9B
 OTIM                   ;; 09C5:  ED 83
 OTIMR                  ;; 09C7:  ED 93
 TSTIO 0                ;; 09C9:  ED 74 00
 TSTIO 85               ;; 09CC:  ED 74 55
 TSTIO 170              ;; 09CF:  ED 74 AA
 TSTIO 255              ;; 09D2:  ED 74 FF
 DI                     ;; 09D5:  F3
 EI                     ;; 09D6:  FB
 IM 0                   ;; 09D7:  ED 46
 IM 1                   ;; 09D9:  ED 56
 IM 2                   ;; 09DB:  ED 5E
 LD I, A                ;; 09DD:  ED 47
 LD A, I                ;; 09DF:  ED 57
 LD R, A                ;; 09E1:  ED 4F
 LD A, R                ;; 09E3:  ED 5F
 RETI                   ;; 09E5:  ED 4D
 RETN                   ;; 09E7:  ED 45
 ld b, b                ;; 09E9:  40
 ld b, c                ;; 09EA:  41
 ld b, d                ;; 09EB:  42
 ld b, e                ;; 09EC:  43
 ld b, h                ;; 09ED:  44
 ld b, l                ;; 09EE:  45
 ld b, a                ;; 09EF:  47
 ld c, b                ;; 09F0:  48
 ld c, c                ;; 09F1:  49
 ld c, d                ;; 09F2:  4A
 ld c, e                ;; 09F3:  4B
 ld c, h                ;; 09F4:  4C
 ld c, l                ;; 09F5:  4D
 ld c, a                ;; 09F6:  4F
 ld d, b                ;; 09F7:  50
 ld d, c                ;; 09F8:  51
 ld d, d                ;; 09F9:  52
 ld d, e                ;; 09FA:  53
 ld d, h                ;; 09FB:  54
 ld d, l                ;; 09FC:  55
 ld d, a                ;; 09FD:  57
 ld e, b                ;; 09FE:  58
 ld e, c                ;; 09FF:  59
 ld e, d                ;; 0A00:  5A
 ld e, e                ;; 0A01:  5B
 ld e, h                ;; 0A02:  5C
 ld e, l                ;; 0A03:  5D
 ld e, a                ;; 0A04:  5F
 ld h, b                ;; 0A05:  60
 ld h, c                ;; 0A06:  61
 ld h, d                ;; 0A07:  62
 ld h, e                ;; 0A08:  63
 ld h, h                ;; 0A09:  64
 ld h, l                ;; 0A0A:  65
 ld h, a                ;; 0A0B:  67
 ld l, b                ;; 0A0C:  68
 ld l, c                ;; 0A0D:  69
 ld l, d                ;; 0A0E:  6A
 ld l, e                ;; 0A0F:  6B
 ld l, h                ;; 0A10:  6C
 ld l, l                ;; 0A11:  6D
 ld l, a                ;; 0A12:  6F
 ld a, b                ;; 0A13:  78
 ld a, c                ;; 0A14:  79
 ld a, d                ;; 0A15:  7A
 ld a, e                ;; 0A16:  7B
 ld a, h                ;; 0A17:  7C
 ld a, l                ;; 0A18:  7D
 ld a, a                ;; 0A19:  7F
 ld b, 0                ;; 0A1A:  06 00
 ld b, 85               ;; 0A1C:  06 55
 ld b, 170              ;; 0A1E:  06 AA
 ld b, 255              ;; 0A20:  06 FF
 ld c, 0                ;; 0A22:  0E 00
 ld c, 85               ;; 0A24:  0E 55
 ld c, 170              ;; 0A26:  0E AA
 ld c, 255              ;; 0A28:  0E FF
 ld d, 0                ;; 0A2A:  16 00
 ld d, 85               ;; 0A2C:  16 55
 ld d, 170              ;; 0A2E:  16 AA
 ld d, 255              ;; 0A30:  16 FF
 ld e, 0                ;; 0A32:  1E 00
 ld e, 85               ;; 0A34:  1E 55
 ld e, 170              ;; 0A36:  1E AA
 ld e, 255              ;; 0A38:  1E FF
 ld h, 0                ;; 0A3A:  26 00
 ld h, 85               ;; 0A3C:  26 55
 ld h, 170              ;; 0A3E:  26 AA
 ld h, 255              ;; 0A40:  26 FF
 ld l, 0                ;; 0A42:  2E 00
 ld l, 85               ;; 0A44:  2E 55
 ld l, 170              ;; 0A46:  2E AA
 ld l, 255              ;; 0A48:  2E FF
 ld a, 0                ;; 0A4A:  3E 00
 ld a, 85               ;; 0A4C:  3E 55
 ld a, 170              ;; 0A4E:  3E AA
 ld a, 255              ;; 0A50:  3E FF
 ld b, (hl)             ;; 0A52:  46
 ld c, (hl)             ;; 0A53:  4E
 ld d, (hl)             ;; 0A54:  56
 ld e, (hl)             ;; 0A55:  5E
 ld h, (hl)             ;; 0A56:  66
 ld l, (hl)             ;; 0A57:  6E
 ld a, (hl)             ;; 0A58:  7E
 ld b, (ix + -128)      ;; 0A59:  DD 46 80
 ld b, (ix + 0)         ;; 0A5C:  DD 46 00
 ld b, (ix + 127)       ;; 0A5F:  DD 46 7F
 ld c, (ix + -128)      ;; 0A62:  DD 4E 80
 ld c, (ix + 0)         ;; 0A65:  DD 4E 00
 ld c, (ix + 127)       ;; 0A68:  DD 4E 7F
 ld d, (ix + -128)      ;; 0A6B:  DD 56 80
 ld d, (ix + 0)         ;; 0A6E:  DD 56 00
 ld d, (ix + 127)       ;; 0A71:  DD 56 7F
 ld e, (ix + -128)      ;; 0A74:  DD 5E 80
 ld e, (ix + 0)         ;; 0A77:  DD 5E 00
 ld e, (ix + 127)       ;; 0A7A:  DD 5E 7F
 ld h, (ix + -128)      ;; 0A7D:  DD 66 80
 ld h, (ix + 0)         ;; 0A80:  DD 66 00
 ld h, (ix + 127)       ;; 0A83:  DD 66 7F
 ld l, (ix + -128)      ;; 0A86:  DD 6E 80
 ld l, (ix + 0)         ;; 0A89:  DD 6E 00
 ld l, (ix + 127)       ;; 0A8C:  DD 6E 7F
 ld a, (ix + -128)      ;; 0A8F:  DD 7E 80
 ld a, (ix + 0)         ;; 0A92:  DD 7E 00
 ld a, (ix + 127)       ;; 0A95:  DD 7E 7F
 ld b, (iy + -128)      ;; 0A98:  FD 46 80
 ld b, (iy + 0)         ;; 0A9B:  FD 46 00
 ld b, (iy + 127)       ;; 0A9E:  FD 46 7F
 ld c, (iy + -128)      ;; 0AA1:  FD 4E 80
 ld c, (iy + 0)         ;; 0AA4:  FD 4E 00
 ld c, (iy + 127)       ;; 0AA7:  FD 4E 7F
 ld d, (iy + -128)      ;; 0AAA:  FD 56 80
 ld d, (iy + 0)         ;; 0AAD:  FD 56 00
 ld d, (iy + 127)       ;; 0AB0:  FD 56 7F
 ld e, (iy + -128)      ;; 0AB3:  FD 5E 80
 ld e, (iy + 0)         ;; 0AB6:  FD 5E 00
 ld e, (iy + 127)       ;; 0AB9:  FD 5E 7F
 ld h, (iy + -128)      ;; 0ABC:  FD 66 80
 ld h, (iy + 0)         ;; 0ABF:  FD 66 00
 ld h, (iy + 127)       ;; 0AC2:  FD 66 7F
 ld l, (iy + -128)      ;; 0AC5:  FD 6E 80
 ld l, (iy + 0)         ;; 0AC8:  FD 6E 00
 ld l, (iy + 127)       ;; 0ACB:  FD 6E 7F
 ld a, (iy + -128)      ;; 0ACE:  FD 7E 80
 ld a, (iy + 0)         ;; 0AD1:  FD 7E 00
 ld a, (iy + 127)       ;; 0AD4:  FD 7E 7F
 ld (hl), b             ;; 0AD7:  70
 ld (hl), c             ;; 0AD8:  71
 ld (hl), d             ;; 0AD9:  72
 ld (hl), e             ;; 0ADA:  73
 ld (hl), h             ;; 0ADB:  74
 ld (hl), l             ;; 0ADC:  75
 ld (hl), a             ;; 0ADD:  77
 ld (ix + -128), b      ;; 0ADE:  DD 70 80
 ld (ix + 0), b         ;; 0AE1:  DD 70 00
 ld (ix + 127), b       ;; 0AE4:  DD 70 7F
 ld (ix + -128), c      ;; 0AE7:  DD 71 80
 ld (ix + 0), c         ;; 0AEA:  DD 71 00
 ld (ix + 127), c       ;; 0AED:  DD 71 7F
 ld (ix + -128), d      ;; 0AF0:  DD 72 80
 ld (ix + 0), d         ;; 0AF3:  DD 72 00
 ld (ix + 127), d       ;; 0AF6:  DD 72 7F
 ld (ix + -128), e      ;; 0AF9:  DD 73 80
 ld (ix + 0), e         ;; 0AFC:  DD 73 00
 ld (ix + 127), e       ;; 0AFF:  DD 73 7F
 ld (ix + -128), h      ;; 0B02:  DD 74 80
 ld (ix + 0), h         ;; 0B05:  DD 74 00
 ld (ix + 127), h       ;; 0B08:  DD 74 7F
 ld (ix + -128), l      ;; 0B0B:  DD 75 80
 ld (ix + 0), l         ;; 0B0E:  DD 75 00
 ld (ix + 127), l       ;; 0B11:  DD 75 7F
 ld (ix + -128), a      ;; 0B14:  DD 77 80
 ld (ix + 0), a         ;; 0B17:  DD 77 00
 ld (ix + 127), a       ;; 0B1A:  DD 77 7F
 ld (iy + -128), b      ;; 0B1D:  FD 70 80
 ld (iy + 0), b         ;; 0B20:  FD 70 00
 ld (iy + 127), b       ;; 0B23:  FD 70 7F
 ld (iy + -128), c      ;; 0B26:  FD 71 80
 ld (iy + 0), c         ;; 0B29:  FD 71 00
 ld (iy + 127), c       ;; 0B2C:  FD 71 7F
 ld (iy + -128), d      ;; 0B2F:  FD 72 80
 ld (iy + 0), d         ;; 0B32:  FD 72 00
 ld (iy + 127), d       ;; 0B35:  FD 72 7F
 ld (iy + -128), e      ;; 0B38:  FD 73 80
 ld (iy + 0), e         ;; 0B3B:  FD 73 00
 ld (iy + 127), e       ;; 0B3E:  FD 73 7F
 ld (iy + -128), h      ;; 0B41:  FD 74 80
 ld (iy + 0), h         ;; 0B44:  FD 74 00
 ld (iy + 127), h       ;; 0B47:  FD 74 7F
 ld (iy + -128), l      ;; 0B4A:  FD 75 80
 ld (iy + 0), l         ;; 0B4D:  FD 75 00
 ld (iy + 127), l       ;; 0B50:  FD 75 7F
 ld (iy + -128), a      ;; 0B53:  FD 77 80
 ld (iy + 0), a         ;; 0B56:  FD 77 00
 ld (iy + 127), a       ;; 0B59:  FD 77 7F
 ld (hl), 0             ;; 0B5C:  36 00
 ld (hl), 85            ;; 0B5E:  36 55
 ld (hl), 170           ;; 0B60:  36 AA
 ld (hl), 255           ;; 0B62:  36 FF
 ld (ix + -128), 0      ;; 0B64:  DD 36 80 00
 ld (ix + 0), 0         ;; 0B68:  DD 36 00 00
 ld (ix + 127), 0       ;; 0B6C:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0B70:  DD 36 80 55
 ld (ix + 0), 85        ;; 0B74:  DD 36 00 55
 ld (ix + 127), 85      ;; 0B78:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0B7C:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0B80:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0B84:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0B88:  DD 36 80 FF
 ld (ix + 0), 255       ;; 0B8C:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0B90:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0B94:  FD 36 80 00
 ld (iy + 0), 0         ;; 0B98:  FD 36 00 00
 ld (iy + 127), 0       ;; 0B9C:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0BA0:  FD 36 80 55
 ld (iy + 0), 85        ;; 0BA4:  FD 36 00 55
 ld (iy + 127), 85      ;; 0BA8:  FD 36 7F 55
 ld (iy + -128), 170    ;; 0BAC:  FD 36 80 AA
 ld (iy + 0), 170       ;; 0BB0:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0BB4:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0BB8:  FD 36 80 FF
 ld (iy + 0), 255       ;; 0BBC:  FD 36 00 FF
 ld (iy + 127), 255     ;; 0BC0:  FD 36 7F FF
 ld a, (bc)             ;; 0BC4:  0A
 ld a, (de)             ;; 0BC5:  1A
 ld (bc), a             ;; 0BC6:  02
 ld (de), a             ;; 0BC7:  12
 ld a, (0)              ;; 0BC8:  3A 00 00
 ld a, (291)            ;; 0BCB:  3A 23 01
 ld a, (17767)          ;; 0BCE:  3A 67 45
 ld a, (35243)          ;; 0BD1:  3A AB 89
 ld a, (52719)          ;; 0BD4:  3A EF CD
 ld a, (65535)          ;; 0BD7:  3A FF FF
 ld (0), a              ;; 0BDA:  32 00 00
 ld (291), a            ;; 0BDD:  32 23 01
 ld (17767), a          ;; 0BE0:  32 67 45
 ld (35243), a          ;; 0BE3:  32 AB 89
 ld (52719), a          ;; 0BE6:  32 EF CD
 ld (65535), a          ;; 0BE9:  32 FF FF
