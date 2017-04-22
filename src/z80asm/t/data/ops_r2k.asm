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
 LD (HL + -128), HL     ;; 011D:  DD F4 80
 LD (HL + 0), HL        ;; 0120:  DD F4 00
 LD (HL + 127), HL      ;; 0123:  DD F4 7F
 LD (ix + -128), HL     ;; 0126:  F4 80
 LD (ix + 0), HL        ;; 0128:  F4 00
 LD (ix + 127), HL      ;; 012A:  F4 7F
 LD (iy + -128), HL     ;; 012C:  FD F4 80
 LD (iy + 0), HL        ;; 012F:  FD F4 00
 LD (iy + 127), HL      ;; 0132:  FD F4 7F
 LD (SP + 0), HL        ;; 0135:  D4 00
 LD (SP + 85), HL       ;; 0137:  D4 55
 LD (SP + 170), HL      ;; 0139:  D4 AA
 LD (SP + 255), HL      ;; 013B:  D4 FF
 LD (SP + 0), IX        ;; 013D:  DD D4 00
 LD (SP + 85), IX       ;; 0140:  DD D4 55
 LD (SP + 170), IX      ;; 0143:  DD D4 AA
 LD (SP + 255), IX      ;; 0146:  DD D4 FF
 LD (SP + 0), IY        ;; 0149:  FD D4 00
 LD (SP + 85), IY       ;; 014C:  FD D4 55
 LD (SP + 170), IY      ;; 014F:  FD D4 AA
 LD (SP + 255), IY      ;; 0152:  FD D4 FF
 EX DE, HL              ;; 0155:  EB
 EX AF, AF'             ;; 0156:  08
 EXX                    ;; 0157:  D9
 EX (SP), HL            ;; 0158:  ED 54
 EX (SP), IX            ;; 015A:  DD E3
 EX (SP), IY            ;; 015C:  FD E3
 EX DE', HL             ;; 015E:  E3
 EX DE, HL'             ;; 015F:  76 EB
 EX DE', HL'            ;; 0161:  76 E3
 LDI                    ;; 0163:  ED A0
 LDIR                   ;; 0165:  ED B0
 LDD                    ;; 0167:  ED A8
 LDDR                   ;; 0169:  ED B8
 ADD A, B               ;; 016B:  80
 ADC A, B               ;; 016C:  88
 SUB B                  ;; 016D:  90
 SBC A, B               ;; 016E:  98
 AND B                  ;; 016F:  A0
 XOR B                  ;; 0170:  A8
 OR B                   ;; 0171:  B0
 CP B                   ;; 0172:  B8
 ADD A, C               ;; 0173:  81
 ADC A, C               ;; 0174:  89
 SUB C                  ;; 0175:  91
 SBC A, C               ;; 0176:  99
 AND C                  ;; 0177:  A1
 XOR C                  ;; 0178:  A9
 OR C                   ;; 0179:  B1
 CP C                   ;; 017A:  B9
 ADD A, D               ;; 017B:  82
 ADC A, D               ;; 017C:  8A
 SUB D                  ;; 017D:  92
 SBC A, D               ;; 017E:  9A
 AND D                  ;; 017F:  A2
 XOR D                  ;; 0180:  AA
 OR D                   ;; 0181:  B2
 CP D                   ;; 0182:  BA
 ADD A, E               ;; 0183:  83
 ADC A, E               ;; 0184:  8B
 SUB E                  ;; 0185:  93
 SBC A, E               ;; 0186:  9B
 AND E                  ;; 0187:  A3
 XOR E                  ;; 0188:  AB
 OR E                   ;; 0189:  B3
 CP E                   ;; 018A:  BB
 ADD A, H               ;; 018B:  84
 ADC A, H               ;; 018C:  8C
 SUB H                  ;; 018D:  94
 SBC A, H               ;; 018E:  9C
 AND H                  ;; 018F:  A4
 XOR H                  ;; 0190:  AC
 OR H                   ;; 0191:  B4
 CP H                   ;; 0192:  BC
 ADD A, L               ;; 0193:  85
 ADC A, L               ;; 0194:  8D
 SUB L                  ;; 0195:  95
 SBC A, L               ;; 0196:  9D
 AND L                  ;; 0197:  A5
 XOR L                  ;; 0198:  AD
 OR L                   ;; 0199:  B5
 CP L                   ;; 019A:  BD
 ADD A, A               ;; 019B:  87
 ADC A, A               ;; 019C:  8F
 SUB A                  ;; 019D:  97
 SBC A, A               ;; 019E:  9F
 AND A                  ;; 019F:  A7
 XOR A                  ;; 01A0:  AF
 OR A                   ;; 01A1:  B7
 CP A                   ;; 01A2:  BF
 ADD A, 0               ;; 01A3:  C6 00
 ADD A, 85              ;; 01A5:  C6 55
 ADD A, 170             ;; 01A7:  C6 AA
 ADD A, 255             ;; 01A9:  C6 FF
 ADC A, 0               ;; 01AB:  CE 00
 ADC A, 85              ;; 01AD:  CE 55
 ADC A, 170             ;; 01AF:  CE AA
 ADC A, 255             ;; 01B1:  CE FF
 SUB 0                  ;; 01B3:  D6 00
 SUB 85                 ;; 01B5:  D6 55
 SUB 170                ;; 01B7:  D6 AA
 SUB 255                ;; 01B9:  D6 FF
 SBC A, 0               ;; 01BB:  DE 00
 SBC A, 85              ;; 01BD:  DE 55
 SBC A, 170             ;; 01BF:  DE AA
 SBC A, 255             ;; 01C1:  DE FF
 AND 0                  ;; 01C3:  E6 00
 AND 85                 ;; 01C5:  E6 55
 AND 170                ;; 01C7:  E6 AA
 AND 255                ;; 01C9:  E6 FF
 XOR 0                  ;; 01CB:  EE 00
 XOR 85                 ;; 01CD:  EE 55
 XOR 170                ;; 01CF:  EE AA
 XOR 255                ;; 01D1:  EE FF
 OR 0                   ;; 01D3:  F6 00
 OR 85                  ;; 01D5:  F6 55
 OR 170                 ;; 01D7:  F6 AA
 OR 255                 ;; 01D9:  F6 FF
 CP 0                   ;; 01DB:  FE 00
 CP 85                  ;; 01DD:  FE 55
 CP 170                 ;; 01DF:  FE AA
 CP 255                 ;; 01E1:  FE FF
 ADD A, (HL)            ;; 01E3:  86
 ADC A, (HL)            ;; 01E4:  8E
 SUB (HL)               ;; 01E5:  96
 SBC A, (HL)            ;; 01E6:  9E
 AND (HL)               ;; 01E7:  A6
 XOR (HL)               ;; 01E8:  AE
 OR (HL)                ;; 01E9:  B6
 CP (HL)                ;; 01EA:  BE
 ADD A, (IX + -128)     ;; 01EB:  DD 86 80
 ADD A, (IX + 0)        ;; 01EE:  DD 86 00
 ADD A, (IX + 127)      ;; 01F1:  DD 86 7F
 ADC A, (IX + -128)     ;; 01F4:  DD 8E 80
 ADC A, (IX + 0)        ;; 01F7:  DD 8E 00
 ADC A, (IX + 127)      ;; 01FA:  DD 8E 7F
 SUB (IX + -128)        ;; 01FD:  DD 96 80
 SUB (IX + 0)           ;; 0200:  DD 96 00
 SUB (IX + 127)         ;; 0203:  DD 96 7F
 SBC A, (IX + -128)     ;; 0206:  DD 9E 80
 SBC A, (IX + 0)        ;; 0209:  DD 9E 00
 SBC A, (IX + 127)      ;; 020C:  DD 9E 7F
 AND (IX + -128)        ;; 020F:  DD A6 80
 AND (IX + 0)           ;; 0212:  DD A6 00
 AND (IX + 127)         ;; 0215:  DD A6 7F
 XOR (IX + -128)        ;; 0218:  DD AE 80
 XOR (IX + 0)           ;; 021B:  DD AE 00
 XOR (IX + 127)         ;; 021E:  DD AE 7F
 OR (IX + -128)         ;; 0221:  DD B6 80
 OR (IX + 0)            ;; 0224:  DD B6 00
 OR (IX + 127)          ;; 0227:  DD B6 7F
 CP (IX + -128)         ;; 022A:  DD BE 80
 CP (IX + 0)            ;; 022D:  DD BE 00
 CP (IX + 127)          ;; 0230:  DD BE 7F
 ADD A, (IY + -128)     ;; 0233:  FD 86 80
 ADD A, (IY + 0)        ;; 0236:  FD 86 00
 ADD A, (IY + 127)      ;; 0239:  FD 86 7F
 ADC A, (IY + -128)     ;; 023C:  FD 8E 80
 ADC A, (IY + 0)        ;; 023F:  FD 8E 00
 ADC A, (IY + 127)      ;; 0242:  FD 8E 7F
 SUB (IY + -128)        ;; 0245:  FD 96 80
 SUB (IY + 0)           ;; 0248:  FD 96 00
 SUB (IY + 127)         ;; 024B:  FD 96 7F
 SBC A, (IY + -128)     ;; 024E:  FD 9E 80
 SBC A, (IY + 0)        ;; 0251:  FD 9E 00
 SBC A, (IY + 127)      ;; 0254:  FD 9E 7F
 AND (IY + -128)        ;; 0257:  FD A6 80
 AND (IY + 0)           ;; 025A:  FD A6 00
 AND (IY + 127)         ;; 025D:  FD A6 7F
 XOR (IY + -128)        ;; 0260:  FD AE 80
 XOR (IY + 0)           ;; 0263:  FD AE 00
 XOR (IY + 127)         ;; 0266:  FD AE 7F
 OR (IY + -128)         ;; 0269:  FD B6 80
 OR (IY + 0)            ;; 026C:  FD B6 00
 OR (IY + 127)          ;; 026F:  FD B6 7F
 CP (IY + -128)         ;; 0272:  FD BE 80
 CP (IY + 0)            ;; 0275:  FD BE 00
 CP (IY + 127)          ;; 0278:  FD BE 7F
 INC B                  ;; 027B:  04
 INC C                  ;; 027C:  0C
 INC D                  ;; 027D:  14
 INC E                  ;; 027E:  1C
 INC H                  ;; 027F:  24
 INC L                  ;; 0280:  2C
 INC A                  ;; 0281:  3C
 INC (HL)               ;; 0282:  34
 INC (IX + -128)        ;; 0283:  DD 34 80
 INC (IX + 0)           ;; 0286:  DD 34 00
 INC (IX + 127)         ;; 0289:  DD 34 7F
 INC (IY + -128)        ;; 028C:  FD 34 80
 INC (IY + 0)           ;; 028F:  FD 34 00
 INC (IY + 127)         ;; 0292:  FD 34 7F
 DEC B                  ;; 0295:  05
 DEC C                  ;; 0296:  0D
 DEC D                  ;; 0297:  15
 DEC E                  ;; 0298:  1D
 DEC H                  ;; 0299:  25
 DEC L                  ;; 029A:  2D
 DEC A                  ;; 029B:  3D
 DEC (HL)               ;; 029C:  35
 DEC (IX + -128)        ;; 029D:  DD 35 80
 DEC (IX + 0)           ;; 02A0:  DD 35 00
 DEC (IX + 127)         ;; 02A3:  DD 35 7F
 DEC (IY + -128)        ;; 02A6:  FD 35 80
 DEC (IY + 0)           ;; 02A9:  FD 35 00
 DEC (IY + 127)         ;; 02AC:  FD 35 7F
 TST B                  ;; 02AF:  ED 04
 TST C                  ;; 02B1:  ED 0C
 TST D                  ;; 02B3:  ED 14
 TST E                  ;; 02B5:  ED 1C
 TST H                  ;; 02B7:  ED 24
 TST L                  ;; 02B9:  ED 2C
 TST A                  ;; 02BB:  ED 3C
 TST 0                  ;; 02BD:  ED 64 00
 TST 85                 ;; 02C0:  ED 64 55
 TST 170                ;; 02C3:  ED 64 AA
 TST 255                ;; 02C6:  ED 64 FF
 TST (HL)               ;; 02C9:  ED 34
 CPL                    ;; 02CB:  2F
 NEG                    ;; 02CC:  ED 44
 CCF                    ;; 02CE:  3F
 SCF                    ;; 02CF:  37
 NOP                    ;; 02D0:  00
 ALTD                   ;; 02D1:  76
 LD A, XPC              ;; 02D2:  ED 77
 LD XPC, A              ;; 02D4:  ED 67
 ADD HL, BC             ;; 02D6:  09
 ADD HL, DE             ;; 02D7:  19
 ADD HL, HL             ;; 02D8:  29
 ADD HL, SP             ;; 02D9:  39
 ADD IX, BC             ;; 02DA:  DD 09
 ADD IY, BC             ;; 02DC:  FD 09
 ADD IX, DE             ;; 02DE:  DD 19
 ADD IY, DE             ;; 02E0:  FD 19
 ADD IX, IX             ;; 02E2:  DD 29
 ADD IY, IY             ;; 02E4:  FD 29
 ADD IX, SP             ;; 02E6:  DD 39
 ADD IY, SP             ;; 02E8:  FD 39
 ADD SP, -128           ;; 02EA:  27 80
 ADD SP, 0              ;; 02EC:  27 00
 ADD SP, 127            ;; 02EE:  27 7F
 ADC HL, BC             ;; 02F0:  ED 4A
 ADC HL, DE             ;; 02F2:  ED 5A
 ADC HL, HL             ;; 02F4:  ED 6A
 ADC HL, SP             ;; 02F6:  ED 7A
 SBC HL, BC             ;; 02F8:  ED 42
 SBC HL, DE             ;; 02FA:  ED 52
 SBC HL, HL             ;; 02FC:  ED 62
 SBC HL, SP             ;; 02FE:  ED 72
 AND HL, DE             ;; 0300:  DC
 AND IX, DE             ;; 0301:  DD DC
 AND IY, DE             ;; 0303:  FD DC
 BOOL HL                ;; 0305:  CC
 BOOL IX                ;; 0306:  DD CC
 BOOL IY                ;; 0308:  FD CC
 INC BC                 ;; 030A:  03
 INC DE                 ;; 030B:  13
 INC HL                 ;; 030C:  23
 INC SP                 ;; 030D:  33
 INC IX                 ;; 030E:  DD 23
 INC IY                 ;; 0310:  FD 23
 DEC BC                 ;; 0312:  0B
 DEC DE                 ;; 0313:  1B
 DEC HL                 ;; 0314:  2B
 DEC SP                 ;; 0315:  3B
 DEC IX                 ;; 0316:  DD 2B
 DEC IY                 ;; 0318:  FD 2B
 MLT BC                 ;; 031A:  ED 4C
 MLT DE                 ;; 031C:  ED 5C
 MLT HL                 ;; 031E:  ED 6C
 RLCA                   ;; 0320:  07
 RRCA                   ;; 0321:  0F
 RLA                    ;; 0322:  17
 RRA                    ;; 0323:  1F
 RLC B                  ;; 0324:  CB 00
 RRC B                  ;; 0326:  CB 08
 RL B                   ;; 0328:  CB 10
 RR B                   ;; 032A:  CB 18
 SLA B                  ;; 032C:  CB 20
 SRA B                  ;; 032E:  CB 28
 SRL B                  ;; 0330:  CB 38
 RLC C                  ;; 0332:  CB 01
 RRC C                  ;; 0334:  CB 09
 RL C                   ;; 0336:  CB 11
 RR C                   ;; 0338:  CB 19
 SLA C                  ;; 033A:  CB 21
 SRA C                  ;; 033C:  CB 29
 SRL C                  ;; 033E:  CB 39
 RLC D                  ;; 0340:  CB 02
 RRC D                  ;; 0342:  CB 0A
 RL D                   ;; 0344:  CB 12
 RR D                   ;; 0346:  CB 1A
 SLA D                  ;; 0348:  CB 22
 SRA D                  ;; 034A:  CB 2A
 SRL D                  ;; 034C:  CB 3A
 RLC E                  ;; 034E:  CB 03
 RRC E                  ;; 0350:  CB 0B
 RL E                   ;; 0352:  CB 13
 RR E                   ;; 0354:  CB 1B
 SLA E                  ;; 0356:  CB 23
 SRA E                  ;; 0358:  CB 2B
 SRL E                  ;; 035A:  CB 3B
 RLC H                  ;; 035C:  CB 04
 RRC H                  ;; 035E:  CB 0C
 RL H                   ;; 0360:  CB 14
 RR H                   ;; 0362:  CB 1C
 SLA H                  ;; 0364:  CB 24
 SRA H                  ;; 0366:  CB 2C
 SRL H                  ;; 0368:  CB 3C
 RLC L                  ;; 036A:  CB 05
 RRC L                  ;; 036C:  CB 0D
 RL L                   ;; 036E:  CB 15
 RR L                   ;; 0370:  CB 1D
 SLA L                  ;; 0372:  CB 25
 SRA L                  ;; 0374:  CB 2D
 SRL L                  ;; 0376:  CB 3D
 RLC A                  ;; 0378:  CB 07
 RRC A                  ;; 037A:  CB 0F
 RL A                   ;; 037C:  CB 17
 RR A                   ;; 037E:  CB 1F
 SLA A                  ;; 0380:  CB 27
 SRA A                  ;; 0382:  CB 2F
 SRL A                  ;; 0384:  CB 3F
 RLC (HL)               ;; 0386:  CB 06
 RRC (HL)               ;; 0388:  CB 0E
 RL (HL)                ;; 038A:  CB 16
 RR (HL)                ;; 038C:  CB 1E
 SLA (HL)               ;; 038E:  CB 26
 SRA (HL)               ;; 0390:  CB 2E
 SRL (HL)               ;; 0392:  CB 3E
 RLC (IX + -128)        ;; 0394:  DD CB 80 06
 RLC (IX + 0)           ;; 0398:  DD CB 00 06
 RLC (IX + 127)         ;; 039C:  DD CB 7F 06
 RRC (IX + -128)        ;; 03A0:  DD CB 80 0E
 RRC (IX + 0)           ;; 03A4:  DD CB 00 0E
 RRC (IX + 127)         ;; 03A8:  DD CB 7F 0E
 RL (IX + -128)         ;; 03AC:  DD CB 80 16
 RL (IX + 0)            ;; 03B0:  DD CB 00 16
 RL (IX + 127)          ;; 03B4:  DD CB 7F 16
 RR (IX + -128)         ;; 03B8:  DD CB 80 1E
 RR (IX + 0)            ;; 03BC:  DD CB 00 1E
 RR (IX + 127)          ;; 03C0:  DD CB 7F 1E
 SLA (IX + -128)        ;; 03C4:  DD CB 80 26
 SLA (IX + 0)           ;; 03C8:  DD CB 00 26
 SLA (IX + 127)         ;; 03CC:  DD CB 7F 26
 SRA (IX + -128)        ;; 03D0:  DD CB 80 2E
 SRA (IX + 0)           ;; 03D4:  DD CB 00 2E
 SRA (IX + 127)         ;; 03D8:  DD CB 7F 2E
 SRL (IX + -128)        ;; 03DC:  DD CB 80 3E
 SRL (IX + 0)           ;; 03E0:  DD CB 00 3E
 SRL (IX + 127)         ;; 03E4:  DD CB 7F 3E
 RLC (IY + -128)        ;; 03E8:  FD CB 80 06
 RLC (IY + 0)           ;; 03EC:  FD CB 00 06
 RLC (IY + 127)         ;; 03F0:  FD CB 7F 06
 RRC (IY + -128)        ;; 03F4:  FD CB 80 0E
 RRC (IY + 0)           ;; 03F8:  FD CB 00 0E
 RRC (IY + 127)         ;; 03FC:  FD CB 7F 0E
 RL (IY + -128)         ;; 0400:  FD CB 80 16
 RL (IY + 0)            ;; 0404:  FD CB 00 16
 RL (IY + 127)          ;; 0408:  FD CB 7F 16
 RR (IY + -128)         ;; 040C:  FD CB 80 1E
 RR (IY + 0)            ;; 0410:  FD CB 00 1E
 RR (IY + 127)          ;; 0414:  FD CB 7F 1E
 SLA (IY + -128)        ;; 0418:  FD CB 80 26
 SLA (IY + 0)           ;; 041C:  FD CB 00 26
 SLA (IY + 127)         ;; 0420:  FD CB 7F 26
 SRA (IY + -128)        ;; 0424:  FD CB 80 2E
 SRA (IY + 0)           ;; 0428:  FD CB 00 2E
 SRA (IY + 127)         ;; 042C:  FD CB 7F 2E
 SRL (IY + -128)        ;; 0430:  FD CB 80 3E
 SRL (IY + 0)           ;; 0434:  FD CB 00 3E
 SRL (IY + 127)         ;; 0438:  FD CB 7F 3E
 BIT 0, B               ;; 043C:  CB 40
 BIT 1, B               ;; 043E:  CB 48
 BIT 2, B               ;; 0440:  CB 50
 BIT 3, B               ;; 0442:  CB 58
 BIT 4, B               ;; 0444:  CB 60
 BIT 5, B               ;; 0446:  CB 68
 BIT 6, B               ;; 0448:  CB 70
 BIT 7, B               ;; 044A:  CB 78
 RES 0, B               ;; 044C:  CB 80
 RES 1, B               ;; 044E:  CB 88
 RES 2, B               ;; 0450:  CB 90
 RES 3, B               ;; 0452:  CB 98
 RES 4, B               ;; 0454:  CB A0
 RES 5, B               ;; 0456:  CB A8
 RES 6, B               ;; 0458:  CB B0
 RES 7, B               ;; 045A:  CB B8
 SET 0, B               ;; 045C:  CB C0
 SET 1, B               ;; 045E:  CB C8
 SET 2, B               ;; 0460:  CB D0
 SET 3, B               ;; 0462:  CB D8
 SET 4, B               ;; 0464:  CB E0
 SET 5, B               ;; 0466:  CB E8
 SET 6, B               ;; 0468:  CB F0
 SET 7, B               ;; 046A:  CB F8
 BIT 0, C               ;; 046C:  CB 41
 BIT 1, C               ;; 046E:  CB 49
 BIT 2, C               ;; 0470:  CB 51
 BIT 3, C               ;; 0472:  CB 59
 BIT 4, C               ;; 0474:  CB 61
 BIT 5, C               ;; 0476:  CB 69
 BIT 6, C               ;; 0478:  CB 71
 BIT 7, C               ;; 047A:  CB 79
 RES 0, C               ;; 047C:  CB 81
 RES 1, C               ;; 047E:  CB 89
 RES 2, C               ;; 0480:  CB 91
 RES 3, C               ;; 0482:  CB 99
 RES 4, C               ;; 0484:  CB A1
 RES 5, C               ;; 0486:  CB A9
 RES 6, C               ;; 0488:  CB B1
 RES 7, C               ;; 048A:  CB B9
 SET 0, C               ;; 048C:  CB C1
 SET 1, C               ;; 048E:  CB C9
 SET 2, C               ;; 0490:  CB D1
 SET 3, C               ;; 0492:  CB D9
 SET 4, C               ;; 0494:  CB E1
 SET 5, C               ;; 0496:  CB E9
 SET 6, C               ;; 0498:  CB F1
 SET 7, C               ;; 049A:  CB F9
 BIT 0, D               ;; 049C:  CB 42
 BIT 1, D               ;; 049E:  CB 4A
 BIT 2, D               ;; 04A0:  CB 52
 BIT 3, D               ;; 04A2:  CB 5A
 BIT 4, D               ;; 04A4:  CB 62
 BIT 5, D               ;; 04A6:  CB 6A
 BIT 6, D               ;; 04A8:  CB 72
 BIT 7, D               ;; 04AA:  CB 7A
 RES 0, D               ;; 04AC:  CB 82
 RES 1, D               ;; 04AE:  CB 8A
 RES 2, D               ;; 04B0:  CB 92
 RES 3, D               ;; 04B2:  CB 9A
 RES 4, D               ;; 04B4:  CB A2
 RES 5, D               ;; 04B6:  CB AA
 RES 6, D               ;; 04B8:  CB B2
 RES 7, D               ;; 04BA:  CB BA
 SET 0, D               ;; 04BC:  CB C2
 SET 1, D               ;; 04BE:  CB CA
 SET 2, D               ;; 04C0:  CB D2
 SET 3, D               ;; 04C2:  CB DA
 SET 4, D               ;; 04C4:  CB E2
 SET 5, D               ;; 04C6:  CB EA
 SET 6, D               ;; 04C8:  CB F2
 SET 7, D               ;; 04CA:  CB FA
 BIT 0, E               ;; 04CC:  CB 43
 BIT 1, E               ;; 04CE:  CB 4B
 BIT 2, E               ;; 04D0:  CB 53
 BIT 3, E               ;; 04D2:  CB 5B
 BIT 4, E               ;; 04D4:  CB 63
 BIT 5, E               ;; 04D6:  CB 6B
 BIT 6, E               ;; 04D8:  CB 73
 BIT 7, E               ;; 04DA:  CB 7B
 RES 0, E               ;; 04DC:  CB 83
 RES 1, E               ;; 04DE:  CB 8B
 RES 2, E               ;; 04E0:  CB 93
 RES 3, E               ;; 04E2:  CB 9B
 RES 4, E               ;; 04E4:  CB A3
 RES 5, E               ;; 04E6:  CB AB
 RES 6, E               ;; 04E8:  CB B3
 RES 7, E               ;; 04EA:  CB BB
 SET 0, E               ;; 04EC:  CB C3
 SET 1, E               ;; 04EE:  CB CB
 SET 2, E               ;; 04F0:  CB D3
 SET 3, E               ;; 04F2:  CB DB
 SET 4, E               ;; 04F4:  CB E3
 SET 5, E               ;; 04F6:  CB EB
 SET 6, E               ;; 04F8:  CB F3
 SET 7, E               ;; 04FA:  CB FB
 BIT 0, H               ;; 04FC:  CB 44
 BIT 1, H               ;; 04FE:  CB 4C
 BIT 2, H               ;; 0500:  CB 54
 BIT 3, H               ;; 0502:  CB 5C
 BIT 4, H               ;; 0504:  CB 64
 BIT 5, H               ;; 0506:  CB 6C
 BIT 6, H               ;; 0508:  CB 74
 BIT 7, H               ;; 050A:  CB 7C
 RES 0, H               ;; 050C:  CB 84
 RES 1, H               ;; 050E:  CB 8C
 RES 2, H               ;; 0510:  CB 94
 RES 3, H               ;; 0512:  CB 9C
 RES 4, H               ;; 0514:  CB A4
 RES 5, H               ;; 0516:  CB AC
 RES 6, H               ;; 0518:  CB B4
 RES 7, H               ;; 051A:  CB BC
 SET 0, H               ;; 051C:  CB C4
 SET 1, H               ;; 051E:  CB CC
 SET 2, H               ;; 0520:  CB D4
 SET 3, H               ;; 0522:  CB DC
 SET 4, H               ;; 0524:  CB E4
 SET 5, H               ;; 0526:  CB EC
 SET 6, H               ;; 0528:  CB F4
 SET 7, H               ;; 052A:  CB FC
 BIT 0, L               ;; 052C:  CB 45
 BIT 1, L               ;; 052E:  CB 4D
 BIT 2, L               ;; 0530:  CB 55
 BIT 3, L               ;; 0532:  CB 5D
 BIT 4, L               ;; 0534:  CB 65
 BIT 5, L               ;; 0536:  CB 6D
 BIT 6, L               ;; 0538:  CB 75
 BIT 7, L               ;; 053A:  CB 7D
 RES 0, L               ;; 053C:  CB 85
 RES 1, L               ;; 053E:  CB 8D
 RES 2, L               ;; 0540:  CB 95
 RES 3, L               ;; 0542:  CB 9D
 RES 4, L               ;; 0544:  CB A5
 RES 5, L               ;; 0546:  CB AD
 RES 6, L               ;; 0548:  CB B5
 RES 7, L               ;; 054A:  CB BD
 SET 0, L               ;; 054C:  CB C5
 SET 1, L               ;; 054E:  CB CD
 SET 2, L               ;; 0550:  CB D5
 SET 3, L               ;; 0552:  CB DD
 SET 4, L               ;; 0554:  CB E5
 SET 5, L               ;; 0556:  CB ED
 SET 6, L               ;; 0558:  CB F5
 SET 7, L               ;; 055A:  CB FD
 BIT 0, A               ;; 055C:  CB 47
 BIT 1, A               ;; 055E:  CB 4F
 BIT 2, A               ;; 0560:  CB 57
 BIT 3, A               ;; 0562:  CB 5F
 BIT 4, A               ;; 0564:  CB 67
 BIT 5, A               ;; 0566:  CB 6F
 BIT 6, A               ;; 0568:  CB 77
 BIT 7, A               ;; 056A:  CB 7F
 RES 0, A               ;; 056C:  CB 87
 RES 1, A               ;; 056E:  CB 8F
 RES 2, A               ;; 0570:  CB 97
 RES 3, A               ;; 0572:  CB 9F
 RES 4, A               ;; 0574:  CB A7
 RES 5, A               ;; 0576:  CB AF
 RES 6, A               ;; 0578:  CB B7
 RES 7, A               ;; 057A:  CB BF
 SET 0, A               ;; 057C:  CB C7
 SET 1, A               ;; 057E:  CB CF
 SET 2, A               ;; 0580:  CB D7
 SET 3, A               ;; 0582:  CB DF
 SET 4, A               ;; 0584:  CB E7
 SET 5, A               ;; 0586:  CB EF
 SET 6, A               ;; 0588:  CB F7
 SET 7, A               ;; 058A:  CB FF
 BIT 0, (HL)            ;; 058C:  CB 46
 BIT 1, (HL)            ;; 058E:  CB 4E
 BIT 2, (HL)            ;; 0590:  CB 56
 BIT 3, (HL)            ;; 0592:  CB 5E
 BIT 4, (HL)            ;; 0594:  CB 66
 BIT 5, (HL)            ;; 0596:  CB 6E
 BIT 6, (HL)            ;; 0598:  CB 76
 BIT 7, (HL)            ;; 059A:  CB 7E
 RES 0, (HL)            ;; 059C:  CB 86
 RES 1, (HL)            ;; 059E:  CB 8E
 RES 2, (HL)            ;; 05A0:  CB 96
 RES 3, (HL)            ;; 05A2:  CB 9E
 RES 4, (HL)            ;; 05A4:  CB A6
 RES 5, (HL)            ;; 05A6:  CB AE
 RES 6, (HL)            ;; 05A8:  CB B6
 RES 7, (HL)            ;; 05AA:  CB BE
 SET 0, (HL)            ;; 05AC:  CB C6
 SET 1, (HL)            ;; 05AE:  CB CE
 SET 2, (HL)            ;; 05B0:  CB D6
 SET 3, (HL)            ;; 05B2:  CB DE
 SET 4, (HL)            ;; 05B4:  CB E6
 SET 5, (HL)            ;; 05B6:  CB EE
 SET 6, (HL)            ;; 05B8:  CB F6
 SET 7, (HL)            ;; 05BA:  CB FE
 BIT 0, (IX + -128)     ;; 05BC:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 05C0:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 05C4:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 05C8:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 05CC:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 05D0:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 05D4:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 05D8:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 05DC:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 05E0:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 05E4:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 05E8:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 05EC:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 05F0:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 05F4:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 05F8:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 05FC:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 0600:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 0604:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 0608:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 060C:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 0610:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 0614:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 0618:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 061C:  DD CB 80 86
 RES 1, (IX + -128)     ;; 0620:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 0624:  DD CB 80 96
 RES 3, (IX + -128)     ;; 0628:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 062C:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 0630:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 0634:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 0638:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 063C:  DD CB 00 86
 RES 1, (IX + 0)        ;; 0640:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 0644:  DD CB 00 96
 RES 3, (IX + 0)        ;; 0648:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 064C:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 0650:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 0654:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 0658:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 065C:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 0660:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 0664:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 0668:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 066C:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 0670:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 0674:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0678:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 067C:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 0680:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 0684:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0688:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 068C:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 0690:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 0694:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0698:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 069C:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 06A0:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 06A4:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 06A8:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 06AC:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 06B0:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 06B4:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 06B8:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 06BC:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 06C0:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 06C4:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 06C8:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 06CC:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 06D0:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 06D4:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 06D8:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 06DC:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 06E0:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 06E4:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 06E8:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 06EC:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 06F0:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 06F4:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 06F8:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 06FC:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 0700:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 0704:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 0708:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 070C:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 0710:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 0714:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 0718:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 071C:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 0720:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 0724:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 0728:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 072C:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 0730:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 0734:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 0738:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 073C:  FD CB 80 86
 RES 1, (IY + -128)     ;; 0740:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 0744:  FD CB 80 96
 RES 3, (IY + -128)     ;; 0748:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 074C:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 0750:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 0754:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 0758:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 075C:  FD CB 00 86
 RES 1, (IY + 0)        ;; 0760:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 0764:  FD CB 00 96
 RES 3, (IY + 0)        ;; 0768:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 076C:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 0770:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 0774:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0778:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 077C:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 0780:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 0784:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0788:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 078C:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 0790:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 0794:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0798:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 079C:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 07A0:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 07A4:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 07A8:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 07AC:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 07B0:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 07B4:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 07B8:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 07BC:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 07C0:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 07C4:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 07C8:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 07CC:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 07D0:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 07D4:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 07D8:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 07DC:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 07E0:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 07E4:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 07E8:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 07EC:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 07F0:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 07F4:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 07F8:  FD CB 7F FE
 JP 0                   ;; 07FC:  C3 00 00
 JP 4660                ;; 07FF:  C3 34 12
 JP 52719               ;; 0802:  C3 EF CD
 JP 65535               ;; 0805:  C3 FF FF
 JP NZ, 0               ;; 0808:  C2 00 00
 JP NZ, 4660            ;; 080B:  C2 34 12
 JP NZ, 52719           ;; 080E:  C2 EF CD
 JP NZ, 65535           ;; 0811:  C2 FF FF
 JP Z, 0                ;; 0814:  CA 00 00
 JP Z, 4660             ;; 0817:  CA 34 12
 JP Z, 52719            ;; 081A:  CA EF CD
 JP Z, 65535            ;; 081D:  CA FF FF
 JP NC, 0               ;; 0820:  D2 00 00
 JP NC, 4660            ;; 0823:  D2 34 12
 JP NC, 52719           ;; 0826:  D2 EF CD
 JP NC, 65535           ;; 0829:  D2 FF FF
 JP C, 0                ;; 082C:  DA 00 00
 JP C, 4660             ;; 082F:  DA 34 12
 JP C, 52719            ;; 0832:  DA EF CD
 JP C, 65535            ;; 0835:  DA FF FF
 JP PO, 0               ;; 0838:  E2 00 00
 JP PO, 4660            ;; 083B:  E2 34 12
 JP PO, 52719           ;; 083E:  E2 EF CD
 JP PO, 65535           ;; 0841:  E2 FF FF
 JP PE, 0               ;; 0844:  EA 00 00
 JP PE, 4660            ;; 0847:  EA 34 12
 JP PE, 52719           ;; 084A:  EA EF CD
 JP PE, 65535           ;; 084D:  EA FF FF
 JP P, 0                ;; 0850:  F2 00 00
 JP P, 4660             ;; 0853:  F2 34 12
 JP P, 52719            ;; 0856:  F2 EF CD
 JP P, 65535            ;; 0859:  F2 FF FF
 JP M, 0                ;; 085C:  FA 00 00
 JP M, 4660             ;; 085F:  FA 34 12
 JP M, 52719            ;; 0862:  FA EF CD
 JP M, 65535            ;; 0865:  FA FF FF
 JP LZ, 0               ;; 0868:  E2 00 00
 JP LZ, 4660            ;; 086B:  E2 34 12
 JP LZ, 52719           ;; 086E:  E2 EF CD
 JP LZ, 65535           ;; 0871:  E2 FF FF
 JP LO, 0               ;; 0874:  EA 00 00
 JP LO, 4660            ;; 0877:  EA 34 12
 JP LO, 52719           ;; 087A:  EA EF CD
 JP LO, 65535           ;; 087D:  EA FF FF
 JR ASMPC+2             ;; 0880:  18 00
 JR NZ, ASMPC+2         ;; 0882:  20 00
 JR Z, ASMPC+2          ;; 0884:  28 00
 JR NC, ASMPC+2         ;; 0886:  30 00
 JR C, ASMPC+2          ;; 0888:  38 00
 JP (HL)                ;; 088A:  E9
 JP (IX)                ;; 088B:  DD E9
 JP (IY)                ;; 088D:  FD E9
 DJNZ ASMPC+2           ;; 088F:  10 00
 CALL 0                 ;; 0891:  CD 00 00
 CALL 4660              ;; 0894:  CD 34 12
 CALL 52719             ;; 0897:  CD EF CD
 CALL 65535             ;; 089A:  CD FF FF
 RET                    ;; 089D:  C9
 RET NZ                 ;; 089E:  C0
 RET Z                  ;; 089F:  C8
 RET NC                 ;; 08A0:  D0
 RET C                  ;; 08A1:  D8
 RET PO                 ;; 08A2:  E0
 RET PE                 ;; 08A3:  E8
 RET P                  ;; 08A4:  F0
 RET M                  ;; 08A5:  F8
 RET LZ                 ;; 08A6:  E0
 RET LO                 ;; 08A7:  E8
 RST 16                 ;; 08A8:  D7
 RST 24                 ;; 08A9:  DF
 RST 32                 ;; 08AA:  E7
 RST 40                 ;; 08AB:  EF
 RST 56                 ;; 08AC:  FF
 IOE                    ;; 08AD:  DB
 IOI                    ;; 08AE:  D3
 IPSET 0                ;; 08AF:  ED 46
 IPSET 1                ;; 08B1:  ED 56
 IPSET 2                ;; 08B3:  ED 4E
 IPSET 3                ;; 08B5:  ED 5E
 IPRES                  ;; 08B7:  ED 5D
 LD IIR, A              ;; 08B9:  ED 47
 LD A, IIR              ;; 08BB:  ED 57
 LD EIR, A              ;; 08BD:  ED 4F
 LD A, EIR              ;; 08BF:  ED 5F
 RETI                   ;; 08C1:  ED 4D
 ld b, b                ;; 08C3:  40
 ld b, c                ;; 08C4:  41
 ld b, d                ;; 08C5:  42
 ld b, e                ;; 08C6:  43
 ld b, h                ;; 08C7:  44
 ld b, l                ;; 08C8:  45
 ld b, a                ;; 08C9:  47
 ld c, b                ;; 08CA:  48
 ld c, c                ;; 08CB:  49
 ld c, d                ;; 08CC:  4A
 ld c, e                ;; 08CD:  4B
 ld c, h                ;; 08CE:  4C
 ld c, l                ;; 08CF:  4D
 ld c, a                ;; 08D0:  4F
 ld d, b                ;; 08D1:  50
 ld d, c                ;; 08D2:  51
 ld d, d                ;; 08D3:  52
 ld d, e                ;; 08D4:  53
 ld d, h                ;; 08D5:  54
 ld d, l                ;; 08D6:  55
 ld d, a                ;; 08D7:  57
 ld e, b                ;; 08D8:  58
 ld e, c                ;; 08D9:  59
 ld e, d                ;; 08DA:  5A
 ld e, e                ;; 08DB:  5B
 ld e, h                ;; 08DC:  5C
 ld e, l                ;; 08DD:  5D
 ld e, a                ;; 08DE:  5F
 ld h, b                ;; 08DF:  60
 ld h, c                ;; 08E0:  61
 ld h, d                ;; 08E1:  62
 ld h, e                ;; 08E2:  63
 ld h, h                ;; 08E3:  64
 ld h, l                ;; 08E4:  65
 ld h, a                ;; 08E5:  67
 ld l, b                ;; 08E6:  68
 ld l, c                ;; 08E7:  69
 ld l, d                ;; 08E8:  6A
 ld l, e                ;; 08E9:  6B
 ld l, h                ;; 08EA:  6C
 ld l, l                ;; 08EB:  6D
 ld l, a                ;; 08EC:  6F
 ld a, b                ;; 08ED:  78
 ld a, c                ;; 08EE:  79
 ld a, d                ;; 08EF:  7A
 ld a, e                ;; 08F0:  7B
 ld a, h                ;; 08F1:  7C
 ld a, l                ;; 08F2:  7D
 ld a, a                ;; 08F3:  7F
 ld b, 0                ;; 08F4:  06 00
 ld b, 85               ;; 08F6:  06 55
 ld b, 170              ;; 08F8:  06 AA
 ld b, 255              ;; 08FA:  06 FF
 ld c, 0                ;; 08FC:  0E 00
 ld c, 85               ;; 08FE:  0E 55
 ld c, 170              ;; 0900:  0E AA
 ld c, 255              ;; 0902:  0E FF
 ld d, 0                ;; 0904:  16 00
 ld d, 85               ;; 0906:  16 55
 ld d, 170              ;; 0908:  16 AA
 ld d, 255              ;; 090A:  16 FF
 ld e, 0                ;; 090C:  1E 00
 ld e, 85               ;; 090E:  1E 55
 ld e, 170              ;; 0910:  1E AA
 ld e, 255              ;; 0912:  1E FF
 ld h, 0                ;; 0914:  26 00
 ld h, 85               ;; 0916:  26 55
 ld h, 170              ;; 0918:  26 AA
 ld h, 255              ;; 091A:  26 FF
 ld l, 0                ;; 091C:  2E 00
 ld l, 85               ;; 091E:  2E 55
 ld l, 170              ;; 0920:  2E AA
 ld l, 255              ;; 0922:  2E FF
 ld a, 0                ;; 0924:  3E 00
 ld a, 85               ;; 0926:  3E 55
 ld a, 170              ;; 0928:  3E AA
 ld a, 255              ;; 092A:  3E FF
 ld b, (hl)             ;; 092C:  46
 ld c, (hl)             ;; 092D:  4E
 ld d, (hl)             ;; 092E:  56
 ld e, (hl)             ;; 092F:  5E
 ld h, (hl)             ;; 0930:  66
 ld l, (hl)             ;; 0931:  6E
 ld a, (hl)             ;; 0932:  7E
 ld b, (ix + -128)      ;; 0933:  DD 46 80
 ld b, (ix + 0)         ;; 0936:  DD 46 00
 ld b, (ix + 127)       ;; 0939:  DD 46 7F
 ld c, (ix + -128)      ;; 093C:  DD 4E 80
 ld c, (ix + 0)         ;; 093F:  DD 4E 00
 ld c, (ix + 127)       ;; 0942:  DD 4E 7F
 ld d, (ix + -128)      ;; 0945:  DD 56 80
 ld d, (ix + 0)         ;; 0948:  DD 56 00
 ld d, (ix + 127)       ;; 094B:  DD 56 7F
 ld e, (ix + -128)      ;; 094E:  DD 5E 80
 ld e, (ix + 0)         ;; 0951:  DD 5E 00
 ld e, (ix + 127)       ;; 0954:  DD 5E 7F
 ld h, (ix + -128)      ;; 0957:  DD 66 80
 ld h, (ix + 0)         ;; 095A:  DD 66 00
 ld h, (ix + 127)       ;; 095D:  DD 66 7F
 ld l, (ix + -128)      ;; 0960:  DD 6E 80
 ld l, (ix + 0)         ;; 0963:  DD 6E 00
 ld l, (ix + 127)       ;; 0966:  DD 6E 7F
 ld a, (ix + -128)      ;; 0969:  DD 7E 80
 ld a, (ix + 0)         ;; 096C:  DD 7E 00
 ld a, (ix + 127)       ;; 096F:  DD 7E 7F
 ld b, (iy + -128)      ;; 0972:  FD 46 80
 ld b, (iy + 0)         ;; 0975:  FD 46 00
 ld b, (iy + 127)       ;; 0978:  FD 46 7F
 ld c, (iy + -128)      ;; 097B:  FD 4E 80
 ld c, (iy + 0)         ;; 097E:  FD 4E 00
 ld c, (iy + 127)       ;; 0981:  FD 4E 7F
 ld d, (iy + -128)      ;; 0984:  FD 56 80
 ld d, (iy + 0)         ;; 0987:  FD 56 00
 ld d, (iy + 127)       ;; 098A:  FD 56 7F
 ld e, (iy + -128)      ;; 098D:  FD 5E 80
 ld e, (iy + 0)         ;; 0990:  FD 5E 00
 ld e, (iy + 127)       ;; 0993:  FD 5E 7F
 ld h, (iy + -128)      ;; 0996:  FD 66 80
 ld h, (iy + 0)         ;; 0999:  FD 66 00
 ld h, (iy + 127)       ;; 099C:  FD 66 7F
 ld l, (iy + -128)      ;; 099F:  FD 6E 80
 ld l, (iy + 0)         ;; 09A2:  FD 6E 00
 ld l, (iy + 127)       ;; 09A5:  FD 6E 7F
 ld a, (iy + -128)      ;; 09A8:  FD 7E 80
 ld a, (iy + 0)         ;; 09AB:  FD 7E 00
 ld a, (iy + 127)       ;; 09AE:  FD 7E 7F
 ld (hl), b             ;; 09B1:  70
 ld (hl), c             ;; 09B2:  71
 ld (hl), d             ;; 09B3:  72
 ld (hl), e             ;; 09B4:  73
 ld (hl), h             ;; 09B5:  74
 ld (hl), l             ;; 09B6:  75
 ld (hl), a             ;; 09B7:  77
 ld (ix + -128), b      ;; 09B8:  DD 70 80
 ld (ix + 0), b         ;; 09BB:  DD 70 00
 ld (ix + 127), b       ;; 09BE:  DD 70 7F
 ld (ix + -128), c      ;; 09C1:  DD 71 80
 ld (ix + 0), c         ;; 09C4:  DD 71 00
 ld (ix + 127), c       ;; 09C7:  DD 71 7F
 ld (ix + -128), d      ;; 09CA:  DD 72 80
 ld (ix + 0), d         ;; 09CD:  DD 72 00
 ld (ix + 127), d       ;; 09D0:  DD 72 7F
 ld (ix + -128), e      ;; 09D3:  DD 73 80
 ld (ix + 0), e         ;; 09D6:  DD 73 00
 ld (ix + 127), e       ;; 09D9:  DD 73 7F
 ld (ix + -128), h      ;; 09DC:  DD 74 80
 ld (ix + 0), h         ;; 09DF:  DD 74 00
 ld (ix + 127), h       ;; 09E2:  DD 74 7F
 ld (ix + -128), l      ;; 09E5:  DD 75 80
 ld (ix + 0), l         ;; 09E8:  DD 75 00
 ld (ix + 127), l       ;; 09EB:  DD 75 7F
 ld (ix + -128), a      ;; 09EE:  DD 77 80
 ld (ix + 0), a         ;; 09F1:  DD 77 00
 ld (ix + 127), a       ;; 09F4:  DD 77 7F
 ld (iy + -128), b      ;; 09F7:  FD 70 80
 ld (iy + 0), b         ;; 09FA:  FD 70 00
 ld (iy + 127), b       ;; 09FD:  FD 70 7F
 ld (iy + -128), c      ;; 0A00:  FD 71 80
 ld (iy + 0), c         ;; 0A03:  FD 71 00
 ld (iy + 127), c       ;; 0A06:  FD 71 7F
 ld (iy + -128), d      ;; 0A09:  FD 72 80
 ld (iy + 0), d         ;; 0A0C:  FD 72 00
 ld (iy + 127), d       ;; 0A0F:  FD 72 7F
 ld (iy + -128), e      ;; 0A12:  FD 73 80
 ld (iy + 0), e         ;; 0A15:  FD 73 00
 ld (iy + 127), e       ;; 0A18:  FD 73 7F
 ld (iy + -128), h      ;; 0A1B:  FD 74 80
 ld (iy + 0), h         ;; 0A1E:  FD 74 00
 ld (iy + 127), h       ;; 0A21:  FD 74 7F
 ld (iy + -128), l      ;; 0A24:  FD 75 80
 ld (iy + 0), l         ;; 0A27:  FD 75 00
 ld (iy + 127), l       ;; 0A2A:  FD 75 7F
 ld (iy + -128), a      ;; 0A2D:  FD 77 80
 ld (iy + 0), a         ;; 0A30:  FD 77 00
 ld (iy + 127), a       ;; 0A33:  FD 77 7F
 ld (hl), 0             ;; 0A36:  36 00
 ld (hl), 85            ;; 0A38:  36 55
 ld (hl), 170           ;; 0A3A:  36 AA
 ld (hl), 255           ;; 0A3C:  36 FF
 ld (ix + -128), 0      ;; 0A3E:  DD 36 80 00
 ld (ix + 0), 0         ;; 0A42:  DD 36 00 00
 ld (ix + 127), 0       ;; 0A46:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0A4A:  DD 36 80 55
 ld (ix + 0), 85        ;; 0A4E:  DD 36 00 55
 ld (ix + 127), 85      ;; 0A52:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0A56:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0A5A:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0A5E:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0A62:  DD 36 80 FF
 ld (ix + 0), 255       ;; 0A66:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0A6A:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0A6E:  FD 36 80 00
 ld (iy + 0), 0         ;; 0A72:  FD 36 00 00
 ld (iy + 127), 0       ;; 0A76:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0A7A:  FD 36 80 55
 ld (iy + 0), 85        ;; 0A7E:  FD 36 00 55
 ld (iy + 127), 85      ;; 0A82:  FD 36 7F 55
 ld (iy + -128), 170    ;; 0A86:  FD 36 80 AA
 ld (iy + 0), 170       ;; 0A8A:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0A8E:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0A92:  FD 36 80 FF
 ld (iy + 0), 255       ;; 0A96:  FD 36 00 FF
 ld (iy + 127), 255     ;; 0A9A:  FD 36 7F FF
 ld a, (bc)             ;; 0A9E:  0A
 ld a, (de)             ;; 0A9F:  1A
 ld (bc), a             ;; 0AA0:  02
 ld (de), a             ;; 0AA1:  12
 ld a, (0)              ;; 0AA2:  3A 00 00
 ld a, (291)            ;; 0AA5:  3A 23 01
 ld a, (17767)          ;; 0AA8:  3A 67 45
 ld a, (35243)          ;; 0AAB:  3A AB 89
 ld a, (52719)          ;; 0AAE:  3A EF CD
 ld a, (65535)          ;; 0AB1:  3A FF FF
 ld (0), a              ;; 0AB4:  32 00 00
 ld (291), a            ;; 0AB7:  32 23 01
 ld (17767), a          ;; 0ABA:  32 67 45
 ld (35243), a          ;; 0ABD:  32 AB 89
 ld (52719), a          ;; 0AC0:  32 EF CD
 ld (65535), a          ;; 0AC3:  32 FF FF
 ld bc', bc             ;; 0AC6:  ED 49
 ld bc', de             ;; 0AC8:  ED 41
 ld de', bc             ;; 0ACA:  ED 59
 ld de', de             ;; 0ACC:  ED 51
 ld hl', bc             ;; 0ACE:  ED 69
 ld hl', de             ;; 0AD0:  ED 61
