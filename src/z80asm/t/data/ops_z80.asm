 CPI                    ;; 0000:  ED A1
 CPIR                   ;; 0002:  ED B1
 CPD                    ;; 0004:  ED A9
 CPDR                   ;; 0006:  ED B9
 ADD A, B               ;; 0008:  80
 ADC A, B               ;; 0009:  88
 SUB B                  ;; 000A:  90
 SBC A, B               ;; 000B:  98
 AND B                  ;; 000C:  A0
 XOR B                  ;; 000D:  A8
 OR B                   ;; 000E:  B0
 CP B                   ;; 000F:  B8
 ADD A, C               ;; 0010:  81
 ADC A, C               ;; 0011:  89
 SUB C                  ;; 0012:  91
 SBC A, C               ;; 0013:  99
 AND C                  ;; 0014:  A1
 XOR C                  ;; 0015:  A9
 OR C                   ;; 0016:  B1
 CP C                   ;; 0017:  B9
 ADD A, D               ;; 0018:  82
 ADC A, D               ;; 0019:  8A
 SUB D                  ;; 001A:  92
 SBC A, D               ;; 001B:  9A
 AND D                  ;; 001C:  A2
 XOR D                  ;; 001D:  AA
 OR D                   ;; 001E:  B2
 CP D                   ;; 001F:  BA
 ADD A, E               ;; 0020:  83
 ADC A, E               ;; 0021:  8B
 SUB E                  ;; 0022:  93
 SBC A, E               ;; 0023:  9B
 AND E                  ;; 0024:  A3
 XOR E                  ;; 0025:  AB
 OR E                   ;; 0026:  B3
 CP E                   ;; 0027:  BB
 ADD A, H               ;; 0028:  84
 ADC A, H               ;; 0029:  8C
 SUB H                  ;; 002A:  94
 SBC A, H               ;; 002B:  9C
 AND H                  ;; 002C:  A4
 XOR H                  ;; 002D:  AC
 OR H                   ;; 002E:  B4
 CP H                   ;; 002F:  BC
 ADD A, L               ;; 0030:  85
 ADC A, L               ;; 0031:  8D
 SUB L                  ;; 0032:  95
 SBC A, L               ;; 0033:  9D
 AND L                  ;; 0034:  A5
 XOR L                  ;; 0035:  AD
 OR L                   ;; 0036:  B5
 CP L                   ;; 0037:  BD
 ADD A, A               ;; 0038:  87
 ADC A, A               ;; 0039:  8F
 SUB A                  ;; 003A:  97
 SBC A, A               ;; 003B:  9F
 AND A                  ;; 003C:  A7
 XOR A                  ;; 003D:  AF
 OR A                   ;; 003E:  B7
 CP A                   ;; 003F:  BF
 ADD A, IXH             ;; 0040:  DD 84
 ADC A, IXH             ;; 0042:  DD 8C
 SUB IXH                ;; 0044:  DD 94
 SBC A, IXH             ;; 0046:  DD 9C
 AND IXH                ;; 0048:  DD A4
 XOR IXH                ;; 004A:  DD AC
 OR IXH                 ;; 004C:  DD B4
 CP IXH                 ;; 004E:  DD BC
 ADD A, IXL             ;; 0050:  DD 85
 ADC A, IXL             ;; 0052:  DD 8D
 SUB IXL                ;; 0054:  DD 95
 SBC A, IXL             ;; 0056:  DD 9D
 AND IXL                ;; 0058:  DD A5
 XOR IXL                ;; 005A:  DD AD
 OR IXL                 ;; 005C:  DD B5
 CP IXL                 ;; 005E:  DD BD
 ADD A, IYH             ;; 0060:  FD 84
 ADC A, IYH             ;; 0062:  FD 8C
 SUB IYH                ;; 0064:  FD 94
 SBC A, IYH             ;; 0066:  FD 9C
 AND IYH                ;; 0068:  FD A4
 XOR IYH                ;; 006A:  FD AC
 OR IYH                 ;; 006C:  FD B4
 CP IYH                 ;; 006E:  FD BC
 ADD A, IYL             ;; 0070:  FD 85
 ADC A, IYL             ;; 0072:  FD 8D
 SUB IYL                ;; 0074:  FD 95
 SBC A, IYL             ;; 0076:  FD 9D
 AND IYL                ;; 0078:  FD A5
 XOR IYL                ;; 007A:  FD AD
 OR IYL                 ;; 007C:  FD B5
 CP IYL                 ;; 007E:  FD BD
 ADD A, 0               ;; 0080:  C6 00
 ADD A, 85              ;; 0082:  C6 55
 ADD A, 170             ;; 0084:  C6 AA
 ADD A, 255             ;; 0086:  C6 FF
 ADC A, 0               ;; 0088:  CE 00
 ADC A, 85              ;; 008A:  CE 55
 ADC A, 170             ;; 008C:  CE AA
 ADC A, 255             ;; 008E:  CE FF
 SUB 0                  ;; 0090:  D6 00
 SUB 85                 ;; 0092:  D6 55
 SUB 170                ;; 0094:  D6 AA
 SUB 255                ;; 0096:  D6 FF
 SBC A, 0               ;; 0098:  DE 00
 SBC A, 85              ;; 009A:  DE 55
 SBC A, 170             ;; 009C:  DE AA
 SBC A, 255             ;; 009E:  DE FF
 AND 0                  ;; 00A0:  E6 00
 AND 85                 ;; 00A2:  E6 55
 AND 170                ;; 00A4:  E6 AA
 AND 255                ;; 00A6:  E6 FF
 XOR 0                  ;; 00A8:  EE 00
 XOR 85                 ;; 00AA:  EE 55
 XOR 170                ;; 00AC:  EE AA
 XOR 255                ;; 00AE:  EE FF
 OR 0                   ;; 00B0:  F6 00
 OR 85                  ;; 00B2:  F6 55
 OR 170                 ;; 00B4:  F6 AA
 OR 255                 ;; 00B6:  F6 FF
 CP 0                   ;; 00B8:  FE 00
 CP 85                  ;; 00BA:  FE 55
 CP 170                 ;; 00BC:  FE AA
 CP 255                 ;; 00BE:  FE FF
 ADD A, (HL)            ;; 00C0:  86
 ADC A, (HL)            ;; 00C1:  8E
 SUB (HL)               ;; 00C2:  96
 SBC A, (HL)            ;; 00C3:  9E
 AND (HL)               ;; 00C4:  A6
 XOR (HL)               ;; 00C5:  AE
 OR (HL)                ;; 00C6:  B6
 CP (HL)                ;; 00C7:  BE
 ADD A, (IX + -128)     ;; 00C8:  DD 86 80
 ADD A, (IX + 0)        ;; 00CB:  DD 86 00
 ADD A, (IX + 127)      ;; 00CE:  DD 86 7F
 ADC A, (IX + -128)     ;; 00D1:  DD 8E 80
 ADC A, (IX + 0)        ;; 00D4:  DD 8E 00
 ADC A, (IX + 127)      ;; 00D7:  DD 8E 7F
 SUB (IX + -128)        ;; 00DA:  DD 96 80
 SUB (IX + 0)           ;; 00DD:  DD 96 00
 SUB (IX + 127)         ;; 00E0:  DD 96 7F
 SBC A, (IX + -128)     ;; 00E3:  DD 9E 80
 SBC A, (IX + 0)        ;; 00E6:  DD 9E 00
 SBC A, (IX + 127)      ;; 00E9:  DD 9E 7F
 AND (IX + -128)        ;; 00EC:  DD A6 80
 AND (IX + 0)           ;; 00EF:  DD A6 00
 AND (IX + 127)         ;; 00F2:  DD A6 7F
 XOR (IX + -128)        ;; 00F5:  DD AE 80
 XOR (IX + 0)           ;; 00F8:  DD AE 00
 XOR (IX + 127)         ;; 00FB:  DD AE 7F
 OR (IX + -128)         ;; 00FE:  DD B6 80
 OR (IX + 0)            ;; 0101:  DD B6 00
 OR (IX + 127)          ;; 0104:  DD B6 7F
 CP (IX + -128)         ;; 0107:  DD BE 80
 CP (IX + 0)            ;; 010A:  DD BE 00
 CP (IX + 127)          ;; 010D:  DD BE 7F
 ADD A, (IY + -128)     ;; 0110:  FD 86 80
 ADD A, (IY + 0)        ;; 0113:  FD 86 00
 ADD A, (IY + 127)      ;; 0116:  FD 86 7F
 ADC A, (IY + -128)     ;; 0119:  FD 8E 80
 ADC A, (IY + 0)        ;; 011C:  FD 8E 00
 ADC A, (IY + 127)      ;; 011F:  FD 8E 7F
 SUB (IY + -128)        ;; 0122:  FD 96 80
 SUB (IY + 0)           ;; 0125:  FD 96 00
 SUB (IY + 127)         ;; 0128:  FD 96 7F
 SBC A, (IY + -128)     ;; 012B:  FD 9E 80
 SBC A, (IY + 0)        ;; 012E:  FD 9E 00
 SBC A, (IY + 127)      ;; 0131:  FD 9E 7F
 AND (IY + -128)        ;; 0134:  FD A6 80
 AND (IY + 0)           ;; 0137:  FD A6 00
 AND (IY + 127)         ;; 013A:  FD A6 7F
 XOR (IY + -128)        ;; 013D:  FD AE 80
 XOR (IY + 0)           ;; 0140:  FD AE 00
 XOR (IY + 127)         ;; 0143:  FD AE 7F
 OR (IY + -128)         ;; 0146:  FD B6 80
 OR (IY + 0)            ;; 0149:  FD B6 00
 OR (IY + 127)          ;; 014C:  FD B6 7F
 CP (IY + -128)         ;; 014F:  FD BE 80
 CP (IY + 0)            ;; 0152:  FD BE 00
 CP (IY + 127)          ;; 0155:  FD BE 7F
 INC B                  ;; 0158:  04
 INC C                  ;; 0159:  0C
 INC D                  ;; 015A:  14
 INC E                  ;; 015B:  1C
 INC H                  ;; 015C:  24
 INC L                  ;; 015D:  2C
 INC A                  ;; 015E:  3C
 INC (HL)               ;; 015F:  34
 INC (IX + -128)        ;; 0160:  DD 34 80
 INC (IX + 0)           ;; 0163:  DD 34 00
 INC (IX + 127)         ;; 0166:  DD 34 7F
 INC (IY + -128)        ;; 0169:  FD 34 80
 INC (IY + 0)           ;; 016C:  FD 34 00
 INC (IY + 127)         ;; 016F:  FD 34 7F
 DEC B                  ;; 0172:  05
 DEC C                  ;; 0173:  0D
 DEC D                  ;; 0174:  15
 DEC E                  ;; 0175:  1D
 DEC H                  ;; 0176:  25
 DEC L                  ;; 0177:  2D
 DEC A                  ;; 0178:  3D
 DEC (HL)               ;; 0179:  35
 DEC (IX + -128)        ;; 017A:  DD 35 80
 DEC (IX + 0)           ;; 017D:  DD 35 00
 DEC (IX + 127)         ;; 0180:  DD 35 7F
 DEC (IY + -128)        ;; 0183:  FD 35 80
 DEC (IY + 0)           ;; 0186:  FD 35 00
 DEC (IY + 127)         ;; 0189:  FD 35 7F
 DAA                    ;; 018C:  27
 RLD                    ;; 018D:  ED 6F
 RRD                    ;; 018F:  ED 67
 CPL                    ;; 0191:  2F
 NEG                    ;; 0192:  ED 44
 CCF                    ;; 0194:  3F
 SCF                    ;; 0195:  37
 NOP                    ;; 0196:  00
 HALT                   ;; 0197:  76
 ADD HL, BC             ;; 0198:  09
 ADD HL, DE             ;; 0199:  19
 ADD HL, HL             ;; 019A:  29
 ADD HL, SP             ;; 019B:  39
 ADD IX, BC             ;; 019C:  DD 09
 ADD IY, BC             ;; 019E:  FD 09
 ADD IX, DE             ;; 01A0:  DD 19
 ADD IY, DE             ;; 01A2:  FD 19
 ADD IX, IX             ;; 01A4:  DD 29
 ADD IY, IY             ;; 01A6:  FD 29
 ADD IX, SP             ;; 01A8:  DD 39
 ADD IY, SP             ;; 01AA:  FD 39
 ADC HL, BC             ;; 01AC:  ED 4A
 ADC HL, DE             ;; 01AE:  ED 5A
 ADC HL, HL             ;; 01B0:  ED 6A
 ADC HL, SP             ;; 01B2:  ED 7A
 SBC HL, BC             ;; 01B4:  ED 42
 SBC HL, DE             ;; 01B6:  ED 52
 SBC HL, HL             ;; 01B8:  ED 62
 SBC HL, SP             ;; 01BA:  ED 72
 INC BC                 ;; 01BC:  03
 INC DE                 ;; 01BD:  13
 INC HL                 ;; 01BE:  23
 INC SP                 ;; 01BF:  33
 INC IX                 ;; 01C0:  DD 23
 INC IY                 ;; 01C2:  FD 23
 DEC BC                 ;; 01C4:  0B
 DEC DE                 ;; 01C5:  1B
 DEC HL                 ;; 01C6:  2B
 DEC SP                 ;; 01C7:  3B
 DEC IX                 ;; 01C8:  DD 2B
 DEC IY                 ;; 01CA:  FD 2B
 RLCA                   ;; 01CC:  07
 RRCA                   ;; 01CD:  0F
 RLA                    ;; 01CE:  17
 RRA                    ;; 01CF:  1F
 RLC B                  ;; 01D0:  CB 00
 RRC B                  ;; 01D2:  CB 08
 RL B                   ;; 01D4:  CB 10
 RR B                   ;; 01D6:  CB 18
 SLA B                  ;; 01D8:  CB 20
 SRA B                  ;; 01DA:  CB 28
 SRL B                  ;; 01DC:  CB 38
 RLC C                  ;; 01DE:  CB 01
 RRC C                  ;; 01E0:  CB 09
 RL C                   ;; 01E2:  CB 11
 RR C                   ;; 01E4:  CB 19
 SLA C                  ;; 01E6:  CB 21
 SRA C                  ;; 01E8:  CB 29
 SRL C                  ;; 01EA:  CB 39
 RLC D                  ;; 01EC:  CB 02
 RRC D                  ;; 01EE:  CB 0A
 RL D                   ;; 01F0:  CB 12
 RR D                   ;; 01F2:  CB 1A
 SLA D                  ;; 01F4:  CB 22
 SRA D                  ;; 01F6:  CB 2A
 SRL D                  ;; 01F8:  CB 3A
 RLC E                  ;; 01FA:  CB 03
 RRC E                  ;; 01FC:  CB 0B
 RL E                   ;; 01FE:  CB 13
 RR E                   ;; 0200:  CB 1B
 SLA E                  ;; 0202:  CB 23
 SRA E                  ;; 0204:  CB 2B
 SRL E                  ;; 0206:  CB 3B
 RLC H                  ;; 0208:  CB 04
 RRC H                  ;; 020A:  CB 0C
 RL H                   ;; 020C:  CB 14
 RR H                   ;; 020E:  CB 1C
 SLA H                  ;; 0210:  CB 24
 SRA H                  ;; 0212:  CB 2C
 SRL H                  ;; 0214:  CB 3C
 RLC L                  ;; 0216:  CB 05
 RRC L                  ;; 0218:  CB 0D
 RL L                   ;; 021A:  CB 15
 RR L                   ;; 021C:  CB 1D
 SLA L                  ;; 021E:  CB 25
 SRA L                  ;; 0220:  CB 2D
 SRL L                  ;; 0222:  CB 3D
 RLC A                  ;; 0224:  CB 07
 RRC A                  ;; 0226:  CB 0F
 RL A                   ;; 0228:  CB 17
 RR A                   ;; 022A:  CB 1F
 SLA A                  ;; 022C:  CB 27
 SRA A                  ;; 022E:  CB 2F
 SRL A                  ;; 0230:  CB 3F
 SLL B                  ;; 0232:  CB 30
 SLL C                  ;; 0234:  CB 31
 SLL D                  ;; 0236:  CB 32
 SLL E                  ;; 0238:  CB 33
 SLL H                  ;; 023A:  CB 34
 SLL L                  ;; 023C:  CB 35
 SLL A                  ;; 023E:  CB 37
 RLC (HL)               ;; 0240:  CB 06
 RRC (HL)               ;; 0242:  CB 0E
 RL (HL)                ;; 0244:  CB 16
 RR (HL)                ;; 0246:  CB 1E
 SLA (HL)               ;; 0248:  CB 26
 SRA (HL)               ;; 024A:  CB 2E
 SRL (HL)               ;; 024C:  CB 3E
 SLL (HL)               ;; 024E:  CB 36
 RLC (IX + -128)        ;; 0250:  DD CB 80 06
 RLC (IX + 0)           ;; 0254:  DD CB 00 06
 RLC (IX + 127)         ;; 0258:  DD CB 7F 06
 RRC (IX + -128)        ;; 025C:  DD CB 80 0E
 RRC (IX + 0)           ;; 0260:  DD CB 00 0E
 RRC (IX + 127)         ;; 0264:  DD CB 7F 0E
 RL (IX + -128)         ;; 0268:  DD CB 80 16
 RL (IX + 0)            ;; 026C:  DD CB 00 16
 RL (IX + 127)          ;; 0270:  DD CB 7F 16
 RR (IX + -128)         ;; 0274:  DD CB 80 1E
 RR (IX + 0)            ;; 0278:  DD CB 00 1E
 RR (IX + 127)          ;; 027C:  DD CB 7F 1E
 SLA (IX + -128)        ;; 0280:  DD CB 80 26
 SLA (IX + 0)           ;; 0284:  DD CB 00 26
 SLA (IX + 127)         ;; 0288:  DD CB 7F 26
 SRA (IX + -128)        ;; 028C:  DD CB 80 2E
 SRA (IX + 0)           ;; 0290:  DD CB 00 2E
 SRA (IX + 127)         ;; 0294:  DD CB 7F 2E
 SRL (IX + -128)        ;; 0298:  DD CB 80 3E
 SRL (IX + 0)           ;; 029C:  DD CB 00 3E
 SRL (IX + 127)         ;; 02A0:  DD CB 7F 3E
 RLC (IY + -128)        ;; 02A4:  FD CB 80 06
 RLC (IY + 0)           ;; 02A8:  FD CB 00 06
 RLC (IY + 127)         ;; 02AC:  FD CB 7F 06
 RRC (IY + -128)        ;; 02B0:  FD CB 80 0E
 RRC (IY + 0)           ;; 02B4:  FD CB 00 0E
 RRC (IY + 127)         ;; 02B8:  FD CB 7F 0E
 RL (IY + -128)         ;; 02BC:  FD CB 80 16
 RL (IY + 0)            ;; 02C0:  FD CB 00 16
 RL (IY + 127)          ;; 02C4:  FD CB 7F 16
 RR (IY + -128)         ;; 02C8:  FD CB 80 1E
 RR (IY + 0)            ;; 02CC:  FD CB 00 1E
 RR (IY + 127)          ;; 02D0:  FD CB 7F 1E
 SLA (IY + -128)        ;; 02D4:  FD CB 80 26
 SLA (IY + 0)           ;; 02D8:  FD CB 00 26
 SLA (IY + 127)         ;; 02DC:  FD CB 7F 26
 SRA (IY + -128)        ;; 02E0:  FD CB 80 2E
 SRA (IY + 0)           ;; 02E4:  FD CB 00 2E
 SRA (IY + 127)         ;; 02E8:  FD CB 7F 2E
 SRL (IY + -128)        ;; 02EC:  FD CB 80 3E
 SRL (IY + 0)           ;; 02F0:  FD CB 00 3E
 SRL (IY + 127)         ;; 02F4:  FD CB 7F 3E
 SLL (IX + -128)        ;; 02F8:  DD CB 80 36
 SLL (IX + 0)           ;; 02FC:  DD CB 00 36
 SLL (IX + 127)         ;; 0300:  DD CB 7F 36
 SLL (IY + -128)        ;; 0304:  FD CB 80 36
 SLL (IY + 0)           ;; 0308:  FD CB 00 36
 SLL (IY + 127)         ;; 030C:  FD CB 7F 36
 BIT 0, B               ;; 0310:  CB 40
 BIT 1, B               ;; 0312:  CB 48
 BIT 2, B               ;; 0314:  CB 50
 BIT 3, B               ;; 0316:  CB 58
 BIT 4, B               ;; 0318:  CB 60
 BIT 5, B               ;; 031A:  CB 68
 BIT 6, B               ;; 031C:  CB 70
 BIT 7, B               ;; 031E:  CB 78
 RES 0, B               ;; 0320:  CB 80
 RES 1, B               ;; 0322:  CB 88
 RES 2, B               ;; 0324:  CB 90
 RES 3, B               ;; 0326:  CB 98
 RES 4, B               ;; 0328:  CB A0
 RES 5, B               ;; 032A:  CB A8
 RES 6, B               ;; 032C:  CB B0
 RES 7, B               ;; 032E:  CB B8
 SET 0, B               ;; 0330:  CB C0
 SET 1, B               ;; 0332:  CB C8
 SET 2, B               ;; 0334:  CB D0
 SET 3, B               ;; 0336:  CB D8
 SET 4, B               ;; 0338:  CB E0
 SET 5, B               ;; 033A:  CB E8
 SET 6, B               ;; 033C:  CB F0
 SET 7, B               ;; 033E:  CB F8
 BIT 0, C               ;; 0340:  CB 41
 BIT 1, C               ;; 0342:  CB 49
 BIT 2, C               ;; 0344:  CB 51
 BIT 3, C               ;; 0346:  CB 59
 BIT 4, C               ;; 0348:  CB 61
 BIT 5, C               ;; 034A:  CB 69
 BIT 6, C               ;; 034C:  CB 71
 BIT 7, C               ;; 034E:  CB 79
 RES 0, C               ;; 0350:  CB 81
 RES 1, C               ;; 0352:  CB 89
 RES 2, C               ;; 0354:  CB 91
 RES 3, C               ;; 0356:  CB 99
 RES 4, C               ;; 0358:  CB A1
 RES 5, C               ;; 035A:  CB A9
 RES 6, C               ;; 035C:  CB B1
 RES 7, C               ;; 035E:  CB B9
 SET 0, C               ;; 0360:  CB C1
 SET 1, C               ;; 0362:  CB C9
 SET 2, C               ;; 0364:  CB D1
 SET 3, C               ;; 0366:  CB D9
 SET 4, C               ;; 0368:  CB E1
 SET 5, C               ;; 036A:  CB E9
 SET 6, C               ;; 036C:  CB F1
 SET 7, C               ;; 036E:  CB F9
 BIT 0, D               ;; 0370:  CB 42
 BIT 1, D               ;; 0372:  CB 4A
 BIT 2, D               ;; 0374:  CB 52
 BIT 3, D               ;; 0376:  CB 5A
 BIT 4, D               ;; 0378:  CB 62
 BIT 5, D               ;; 037A:  CB 6A
 BIT 6, D               ;; 037C:  CB 72
 BIT 7, D               ;; 037E:  CB 7A
 RES 0, D               ;; 0380:  CB 82
 RES 1, D               ;; 0382:  CB 8A
 RES 2, D               ;; 0384:  CB 92
 RES 3, D               ;; 0386:  CB 9A
 RES 4, D               ;; 0388:  CB A2
 RES 5, D               ;; 038A:  CB AA
 RES 6, D               ;; 038C:  CB B2
 RES 7, D               ;; 038E:  CB BA
 SET 0, D               ;; 0390:  CB C2
 SET 1, D               ;; 0392:  CB CA
 SET 2, D               ;; 0394:  CB D2
 SET 3, D               ;; 0396:  CB DA
 SET 4, D               ;; 0398:  CB E2
 SET 5, D               ;; 039A:  CB EA
 SET 6, D               ;; 039C:  CB F2
 SET 7, D               ;; 039E:  CB FA
 BIT 0, E               ;; 03A0:  CB 43
 BIT 1, E               ;; 03A2:  CB 4B
 BIT 2, E               ;; 03A4:  CB 53
 BIT 3, E               ;; 03A6:  CB 5B
 BIT 4, E               ;; 03A8:  CB 63
 BIT 5, E               ;; 03AA:  CB 6B
 BIT 6, E               ;; 03AC:  CB 73
 BIT 7, E               ;; 03AE:  CB 7B
 RES 0, E               ;; 03B0:  CB 83
 RES 1, E               ;; 03B2:  CB 8B
 RES 2, E               ;; 03B4:  CB 93
 RES 3, E               ;; 03B6:  CB 9B
 RES 4, E               ;; 03B8:  CB A3
 RES 5, E               ;; 03BA:  CB AB
 RES 6, E               ;; 03BC:  CB B3
 RES 7, E               ;; 03BE:  CB BB
 SET 0, E               ;; 03C0:  CB C3
 SET 1, E               ;; 03C2:  CB CB
 SET 2, E               ;; 03C4:  CB D3
 SET 3, E               ;; 03C6:  CB DB
 SET 4, E               ;; 03C8:  CB E3
 SET 5, E               ;; 03CA:  CB EB
 SET 6, E               ;; 03CC:  CB F3
 SET 7, E               ;; 03CE:  CB FB
 BIT 0, H               ;; 03D0:  CB 44
 BIT 1, H               ;; 03D2:  CB 4C
 BIT 2, H               ;; 03D4:  CB 54
 BIT 3, H               ;; 03D6:  CB 5C
 BIT 4, H               ;; 03D8:  CB 64
 BIT 5, H               ;; 03DA:  CB 6C
 BIT 6, H               ;; 03DC:  CB 74
 BIT 7, H               ;; 03DE:  CB 7C
 RES 0, H               ;; 03E0:  CB 84
 RES 1, H               ;; 03E2:  CB 8C
 RES 2, H               ;; 03E4:  CB 94
 RES 3, H               ;; 03E6:  CB 9C
 RES 4, H               ;; 03E8:  CB A4
 RES 5, H               ;; 03EA:  CB AC
 RES 6, H               ;; 03EC:  CB B4
 RES 7, H               ;; 03EE:  CB BC
 SET 0, H               ;; 03F0:  CB C4
 SET 1, H               ;; 03F2:  CB CC
 SET 2, H               ;; 03F4:  CB D4
 SET 3, H               ;; 03F6:  CB DC
 SET 4, H               ;; 03F8:  CB E4
 SET 5, H               ;; 03FA:  CB EC
 SET 6, H               ;; 03FC:  CB F4
 SET 7, H               ;; 03FE:  CB FC
 BIT 0, L               ;; 0400:  CB 45
 BIT 1, L               ;; 0402:  CB 4D
 BIT 2, L               ;; 0404:  CB 55
 BIT 3, L               ;; 0406:  CB 5D
 BIT 4, L               ;; 0408:  CB 65
 BIT 5, L               ;; 040A:  CB 6D
 BIT 6, L               ;; 040C:  CB 75
 BIT 7, L               ;; 040E:  CB 7D
 RES 0, L               ;; 0410:  CB 85
 RES 1, L               ;; 0412:  CB 8D
 RES 2, L               ;; 0414:  CB 95
 RES 3, L               ;; 0416:  CB 9D
 RES 4, L               ;; 0418:  CB A5
 RES 5, L               ;; 041A:  CB AD
 RES 6, L               ;; 041C:  CB B5
 RES 7, L               ;; 041E:  CB BD
 SET 0, L               ;; 0420:  CB C5
 SET 1, L               ;; 0422:  CB CD
 SET 2, L               ;; 0424:  CB D5
 SET 3, L               ;; 0426:  CB DD
 SET 4, L               ;; 0428:  CB E5
 SET 5, L               ;; 042A:  CB ED
 SET 6, L               ;; 042C:  CB F5
 SET 7, L               ;; 042E:  CB FD
 BIT 0, A               ;; 0430:  CB 47
 BIT 1, A               ;; 0432:  CB 4F
 BIT 2, A               ;; 0434:  CB 57
 BIT 3, A               ;; 0436:  CB 5F
 BIT 4, A               ;; 0438:  CB 67
 BIT 5, A               ;; 043A:  CB 6F
 BIT 6, A               ;; 043C:  CB 77
 BIT 7, A               ;; 043E:  CB 7F
 RES 0, A               ;; 0440:  CB 87
 RES 1, A               ;; 0442:  CB 8F
 RES 2, A               ;; 0444:  CB 97
 RES 3, A               ;; 0446:  CB 9F
 RES 4, A               ;; 0448:  CB A7
 RES 5, A               ;; 044A:  CB AF
 RES 6, A               ;; 044C:  CB B7
 RES 7, A               ;; 044E:  CB BF
 SET 0, A               ;; 0450:  CB C7
 SET 1, A               ;; 0452:  CB CF
 SET 2, A               ;; 0454:  CB D7
 SET 3, A               ;; 0456:  CB DF
 SET 4, A               ;; 0458:  CB E7
 SET 5, A               ;; 045A:  CB EF
 SET 6, A               ;; 045C:  CB F7
 SET 7, A               ;; 045E:  CB FF
 BIT 0, (HL)            ;; 0460:  CB 46
 BIT 1, (HL)            ;; 0462:  CB 4E
 BIT 2, (HL)            ;; 0464:  CB 56
 BIT 3, (HL)            ;; 0466:  CB 5E
 BIT 4, (HL)            ;; 0468:  CB 66
 BIT 5, (HL)            ;; 046A:  CB 6E
 BIT 6, (HL)            ;; 046C:  CB 76
 BIT 7, (HL)            ;; 046E:  CB 7E
 RES 0, (HL)            ;; 0470:  CB 86
 RES 1, (HL)            ;; 0472:  CB 8E
 RES 2, (HL)            ;; 0474:  CB 96
 RES 3, (HL)            ;; 0476:  CB 9E
 RES 4, (HL)            ;; 0478:  CB A6
 RES 5, (HL)            ;; 047A:  CB AE
 RES 6, (HL)            ;; 047C:  CB B6
 RES 7, (HL)            ;; 047E:  CB BE
 SET 0, (HL)            ;; 0480:  CB C6
 SET 1, (HL)            ;; 0482:  CB CE
 SET 2, (HL)            ;; 0484:  CB D6
 SET 3, (HL)            ;; 0486:  CB DE
 SET 4, (HL)            ;; 0488:  CB E6
 SET 5, (HL)            ;; 048A:  CB EE
 SET 6, (HL)            ;; 048C:  CB F6
 SET 7, (HL)            ;; 048E:  CB FE
 BIT 0, (IX + -128)     ;; 0490:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 0494:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 0498:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 049C:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 04A0:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 04A4:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 04A8:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 04AC:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 04B0:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 04B4:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 04B8:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 04BC:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 04C0:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 04C4:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 04C8:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 04CC:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 04D0:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 04D4:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 04D8:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 04DC:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 04E0:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 04E4:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 04E8:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 04EC:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 04F0:  DD CB 80 86
 RES 1, (IX + -128)     ;; 04F4:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 04F8:  DD CB 80 96
 RES 3, (IX + -128)     ;; 04FC:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 0500:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 0504:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 0508:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 050C:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 0510:  DD CB 00 86
 RES 1, (IX + 0)        ;; 0514:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 0518:  DD CB 00 96
 RES 3, (IX + 0)        ;; 051C:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 0520:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 0524:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 0528:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 052C:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 0530:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 0534:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 0538:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 053C:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 0540:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 0544:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 0548:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 054C:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0550:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 0554:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 0558:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 055C:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0560:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 0564:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 0568:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 056C:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0570:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 0574:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 0578:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 057C:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0580:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 0584:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 0588:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 058C:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 0590:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 0594:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 0598:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 059C:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 05A0:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 05A4:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 05A8:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 05AC:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 05B0:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 05B4:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 05B8:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 05BC:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 05C0:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 05C4:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 05C8:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 05CC:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 05D0:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 05D4:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 05D8:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 05DC:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 05E0:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 05E4:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 05E8:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 05EC:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 05F0:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 05F4:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 05F8:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 05FC:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 0600:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 0604:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 0608:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 060C:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 0610:  FD CB 80 86
 RES 1, (IY + -128)     ;; 0614:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 0618:  FD CB 80 96
 RES 3, (IY + -128)     ;; 061C:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 0620:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 0624:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 0628:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 062C:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 0630:  FD CB 00 86
 RES 1, (IY + 0)        ;; 0634:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 0638:  FD CB 00 96
 RES 3, (IY + 0)        ;; 063C:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 0640:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 0644:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 0648:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 064C:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0650:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 0654:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 0658:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 065C:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0660:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 0664:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 0668:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 066C:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0670:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 0674:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 0678:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 067C:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0680:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 0684:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 0688:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 068C:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 0690:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 0694:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 0698:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 069C:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 06A0:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 06A4:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 06A8:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 06AC:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 06B0:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 06B4:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 06B8:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 06BC:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 06C0:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 06C4:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 06C8:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 06CC:  FD CB 7F FE
 JP 0                   ;; 06D0:  C3 00 00
 JP 4660                ;; 06D3:  C3 34 12
 JP 52719               ;; 06D6:  C3 EF CD
 JP 65535               ;; 06D9:  C3 FF FF
 JP NZ, 0               ;; 06DC:  C2 00 00
 JP NZ, 4660            ;; 06DF:  C2 34 12
 JP NZ, 52719           ;; 06E2:  C2 EF CD
 JP NZ, 65535           ;; 06E5:  C2 FF FF
 JP Z, 0                ;; 06E8:  CA 00 00
 JP Z, 4660             ;; 06EB:  CA 34 12
 JP Z, 52719            ;; 06EE:  CA EF CD
 JP Z, 65535            ;; 06F1:  CA FF FF
 JP NC, 0               ;; 06F4:  D2 00 00
 JP NC, 4660            ;; 06F7:  D2 34 12
 JP NC, 52719           ;; 06FA:  D2 EF CD
 JP NC, 65535           ;; 06FD:  D2 FF FF
 JP C, 0                ;; 0700:  DA 00 00
 JP C, 4660             ;; 0703:  DA 34 12
 JP C, 52719            ;; 0706:  DA EF CD
 JP C, 65535            ;; 0709:  DA FF FF
 JP PO, 0               ;; 070C:  E2 00 00
 JP PO, 4660            ;; 070F:  E2 34 12
 JP PO, 52719           ;; 0712:  E2 EF CD
 JP PO, 65535           ;; 0715:  E2 FF FF
 JP PE, 0               ;; 0718:  EA 00 00
 JP PE, 4660            ;; 071B:  EA 34 12
 JP PE, 52719           ;; 071E:  EA EF CD
 JP PE, 65535           ;; 0721:  EA FF FF
 JP P, 0                ;; 0724:  F2 00 00
 JP P, 4660             ;; 0727:  F2 34 12
 JP P, 52719            ;; 072A:  F2 EF CD
 JP P, 65535            ;; 072D:  F2 FF FF
 JP M, 0                ;; 0730:  FA 00 00
 JP M, 4660             ;; 0733:  FA 34 12
 JP M, 52719            ;; 0736:  FA EF CD
 JP M, 65535            ;; 0739:  FA FF FF
 JR ASMPC+2             ;; 073C:  18 00
 JR NZ, ASMPC+2         ;; 073E:  20 00
 JR Z, ASMPC+2          ;; 0740:  28 00
 JR NC, ASMPC+2         ;; 0742:  30 00
 JR C, ASMPC+2          ;; 0744:  38 00
 JP (HL)                ;; 0746:  E9
 JP (IX)                ;; 0747:  DD E9
 JP (IY)                ;; 0749:  FD E9
 DJNZ ASMPC+2           ;; 074B:  10 00
 CALL 0                 ;; 074D:  CD 00 00
 CALL 4660              ;; 0750:  CD 34 12
 CALL 52719             ;; 0753:  CD EF CD
 CALL 65535             ;; 0756:  CD FF FF
 CALL NZ, 0             ;; 0759:  C4 00 00
 CALL NZ, 4660          ;; 075C:  C4 34 12
 CALL NZ, 52719         ;; 075F:  C4 EF CD
 CALL NZ, 65535         ;; 0762:  C4 FF FF
 CALL Z, 0              ;; 0765:  CC 00 00
 CALL Z, 4660           ;; 0768:  CC 34 12
 CALL Z, 52719          ;; 076B:  CC EF CD
 CALL Z, 65535          ;; 076E:  CC FF FF
 CALL NC, 0             ;; 0771:  D4 00 00
 CALL NC, 4660          ;; 0774:  D4 34 12
 CALL NC, 52719         ;; 0777:  D4 EF CD
 CALL NC, 65535         ;; 077A:  D4 FF FF
 CALL C, 0              ;; 077D:  DC 00 00
 CALL C, 4660           ;; 0780:  DC 34 12
 CALL C, 52719          ;; 0783:  DC EF CD
 CALL C, 65535          ;; 0786:  DC FF FF
 CALL PO, 0             ;; 0789:  E4 00 00
 CALL PO, 4660          ;; 078C:  E4 34 12
 CALL PO, 52719         ;; 078F:  E4 EF CD
 CALL PO, 65535         ;; 0792:  E4 FF FF
 CALL PE, 0             ;; 0795:  EC 00 00
 CALL PE, 4660          ;; 0798:  EC 34 12
 CALL PE, 52719         ;; 079B:  EC EF CD
 CALL PE, 65535         ;; 079E:  EC FF FF
 CALL P, 0              ;; 07A1:  F4 00 00
 CALL P, 4660           ;; 07A4:  F4 34 12
 CALL P, 52719          ;; 07A7:  F4 EF CD
 CALL P, 65535          ;; 07AA:  F4 FF FF
 CALL M, 0              ;; 07AD:  FC 00 00
 CALL M, 4660           ;; 07B0:  FC 34 12
 CALL M, 52719          ;; 07B3:  FC EF CD
 CALL M, 65535          ;; 07B6:  FC FF FF
 RET                    ;; 07B9:  C9
 RET NZ                 ;; 07BA:  C0
 RET Z                  ;; 07BB:  C8
 RET NC                 ;; 07BC:  D0
 RET C                  ;; 07BD:  D8
 RET PO                 ;; 07BE:  E0
 RET PE                 ;; 07BF:  E8
 RET P                  ;; 07C0:  F0
 RET M                  ;; 07C1:  F8
 RST 16                 ;; 07C2:  D7
 RST 24                 ;; 07C3:  DF
 RST 32                 ;; 07C4:  E7
 RST 40                 ;; 07C5:  EF
 RST 56                 ;; 07C6:  FF
 RST 0                  ;; 07C7:  C7
 RST 8                  ;; 07C8:  CF
 RST 48                 ;; 07C9:  F7
 IN A, (0)              ;; 07CA:  DB 00
 IN A, (85)             ;; 07CC:  DB 55
 IN A, (170)            ;; 07CE:  DB AA
 IN A, (255)            ;; 07D0:  DB FF
 IN B, (C)              ;; 07D2:  ED 40
 IN C, (C)              ;; 07D4:  ED 48
 IN D, (C)              ;; 07D6:  ED 50
 IN E, (C)              ;; 07D8:  ED 58
 IN H, (C)              ;; 07DA:  ED 60
 IN L, (C)              ;; 07DC:  ED 68
 IN A, (C)              ;; 07DE:  ED 78
 INI                    ;; 07E0:  ED A2
 INIR                   ;; 07E2:  ED B2
 IND                    ;; 07E4:  ED AA
 INDR                   ;; 07E6:  ED BA
 OUT (0), A             ;; 07E8:  D3 00
 OUT (85), A            ;; 07EA:  D3 55
 OUT (170), A           ;; 07EC:  D3 AA
 OUT (255), A           ;; 07EE:  D3 FF
 OUT (C), B             ;; 07F0:  ED 41
 OUT (C), C             ;; 07F2:  ED 49
 OUT (C), D             ;; 07F4:  ED 51
 OUT (C), E             ;; 07F6:  ED 59
 OUT (C), H             ;; 07F8:  ED 61
 OUT (C), L             ;; 07FA:  ED 69
 OUT (C), A             ;; 07FC:  ED 79
 OUTI                   ;; 07FE:  ED A3
 OTIR                   ;; 0800:  ED B3
 OUTD                   ;; 0802:  ED AB
 OTDR                   ;; 0804:  ED BB
 DI                     ;; 0806:  F3
 EI                     ;; 0807:  FB
 IM 0                   ;; 0808:  ED 46
 IM 1                   ;; 080A:  ED 56
 IM 2                   ;; 080C:  ED 5E
 LD I, A                ;; 080E:  ED 47
 LD A, I                ;; 0810:  ED 57
 LD R, A                ;; 0812:  ED 4F
 LD A, R                ;; 0814:  ED 5F
 RETI                   ;; 0816:  ED 4D
 RETN                   ;; 0818:  ED 45
 ld b, b                ;; 081A:  40
 ld b, c                ;; 081B:  41
 ld b, d                ;; 081C:  42
 ld b, e                ;; 081D:  43
 ld b, h                ;; 081E:  44
 ld b, l                ;; 081F:  45
 ld b, a                ;; 0820:  47
 ld c, b                ;; 0821:  48
 ld c, c                ;; 0822:  49
 ld c, d                ;; 0823:  4A
 ld c, e                ;; 0824:  4B
 ld c, h                ;; 0825:  4C
 ld c, l                ;; 0826:  4D
 ld c, a                ;; 0827:  4F
 ld d, b                ;; 0828:  50
 ld d, c                ;; 0829:  51
 ld d, d                ;; 082A:  52
 ld d, e                ;; 082B:  53
 ld d, h                ;; 082C:  54
 ld d, l                ;; 082D:  55
 ld d, a                ;; 082E:  57
 ld e, b                ;; 082F:  58
 ld e, c                ;; 0830:  59
 ld e, d                ;; 0831:  5A
 ld e, e                ;; 0832:  5B
 ld e, h                ;; 0833:  5C
 ld e, l                ;; 0834:  5D
 ld e, a                ;; 0835:  5F
 ld h, b                ;; 0836:  60
 ld h, c                ;; 0837:  61
 ld h, d                ;; 0838:  62
 ld h, e                ;; 0839:  63
 ld h, h                ;; 083A:  64
 ld h, l                ;; 083B:  65
 ld h, a                ;; 083C:  67
 ld l, b                ;; 083D:  68
 ld l, c                ;; 083E:  69
 ld l, d                ;; 083F:  6A
 ld l, e                ;; 0840:  6B
 ld l, h                ;; 0841:  6C
 ld l, l                ;; 0842:  6D
 ld l, a                ;; 0843:  6F
 ld a, b                ;; 0844:  78
 ld a, c                ;; 0845:  79
 ld a, d                ;; 0846:  7A
 ld a, e                ;; 0847:  7B
 ld a, h                ;; 0848:  7C
 ld a, l                ;; 0849:  7D
 ld a, a                ;; 084A:  7F
 ld b, ixh              ;; 084B:  DD 44
 ld b, ixl              ;; 084D:  DD 45
 ld c, ixh              ;; 084F:  DD 4C
 ld c, ixl              ;; 0851:  DD 4D
 ld d, ixh              ;; 0853:  DD 54
 ld d, ixl              ;; 0855:  DD 55
 ld e, ixh              ;; 0857:  DD 5C
 ld e, ixl              ;; 0859:  DD 5D
 ld ixh, ixh            ;; 085B:  DD 64
 ld ixh, ixl            ;; 085D:  DD 65
 ld ixl, ixh            ;; 085F:  DD 6C
 ld ixl, ixl            ;; 0861:  DD 6D
 ld a, ixh              ;; 0863:  DD 7C
 ld a, ixl              ;; 0865:  DD 7D
 ld b, iyh              ;; 0867:  FD 44
 ld b, iyl              ;; 0869:  FD 45
 ld c, iyh              ;; 086B:  FD 4C
 ld c, iyl              ;; 086D:  FD 4D
 ld d, iyh              ;; 086F:  FD 54
 ld d, iyl              ;; 0871:  FD 55
 ld e, iyh              ;; 0873:  FD 5C
 ld e, iyl              ;; 0875:  FD 5D
 ld iyh, iyh            ;; 0877:  FD 64
 ld iyh, iyl            ;; 0879:  FD 65
 ld iyl, iyh            ;; 087B:  FD 6C
 ld iyl, iyl            ;; 087D:  FD 6D
 ld a, iyh              ;; 087F:  FD 7C
 ld a, iyl              ;; 0881:  FD 7D
 ld b, 0                ;; 0883:  06 00
 ld b, 85               ;; 0885:  06 55
 ld b, 170              ;; 0887:  06 AA
 ld b, 255              ;; 0889:  06 FF
 ld c, 0                ;; 088B:  0E 00
 ld c, 85               ;; 088D:  0E 55
 ld c, 170              ;; 088F:  0E AA
 ld c, 255              ;; 0891:  0E FF
 ld d, 0                ;; 0893:  16 00
 ld d, 85               ;; 0895:  16 55
 ld d, 170              ;; 0897:  16 AA
 ld d, 255              ;; 0899:  16 FF
 ld e, 0                ;; 089B:  1E 00
 ld e, 85               ;; 089D:  1E 55
 ld e, 170              ;; 089F:  1E AA
 ld e, 255              ;; 08A1:  1E FF
 ld h, 0                ;; 08A3:  26 00
 ld h, 85               ;; 08A5:  26 55
 ld h, 170              ;; 08A7:  26 AA
 ld h, 255              ;; 08A9:  26 FF
 ld l, 0                ;; 08AB:  2E 00
 ld l, 85               ;; 08AD:  2E 55
 ld l, 170              ;; 08AF:  2E AA
 ld l, 255              ;; 08B1:  2E FF
 ld a, 0                ;; 08B3:  3E 00
 ld a, 85               ;; 08B5:  3E 55
 ld a, 170              ;; 08B7:  3E AA
 ld a, 255              ;; 08B9:  3E FF
 ld ixh, 0              ;; 08BB:  DD 26 00
 ld ixh, 85             ;; 08BE:  DD 26 55
 ld ixh, 170            ;; 08C1:  DD 26 AA
 ld ixh, 255            ;; 08C4:  DD 26 FF
 ld ixl, 0              ;; 08C7:  DD 2E 00
 ld ixl, 85             ;; 08CA:  DD 2E 55
 ld ixl, 170            ;; 08CD:  DD 2E AA
 ld ixl, 255            ;; 08D0:  DD 2E FF
 ld iyh, 0              ;; 08D3:  FD 26 00
 ld iyh, 85             ;; 08D6:  FD 26 55
 ld iyh, 170            ;; 08D9:  FD 26 AA
 ld iyh, 255            ;; 08DC:  FD 26 FF
 ld iyl, 0              ;; 08DF:  FD 2E 00
 ld iyl, 85             ;; 08E2:  FD 2E 55
 ld iyl, 170            ;; 08E5:  FD 2E AA
 ld iyl, 255            ;; 08E8:  FD 2E FF
 ld b, (hl)             ;; 08EB:  46
 ld c, (hl)             ;; 08EC:  4E
 ld d, (hl)             ;; 08ED:  56
 ld e, (hl)             ;; 08EE:  5E
 ld h, (hl)             ;; 08EF:  66
 ld l, (hl)             ;; 08F0:  6E
 ld a, (hl)             ;; 08F1:  7E
 ld b, (ix + -128)      ;; 08F2:  DD 46 80
 ld b, (ix + 0)         ;; 08F5:  DD 46 00
 ld b, (ix + 127)       ;; 08F8:  DD 46 7F
 ld c, (ix + -128)      ;; 08FB:  DD 4E 80
 ld c, (ix + 0)         ;; 08FE:  DD 4E 00
 ld c, (ix + 127)       ;; 0901:  DD 4E 7F
 ld d, (ix + -128)      ;; 0904:  DD 56 80
 ld d, (ix + 0)         ;; 0907:  DD 56 00
 ld d, (ix + 127)       ;; 090A:  DD 56 7F
 ld e, (ix + -128)      ;; 090D:  DD 5E 80
 ld e, (ix + 0)         ;; 0910:  DD 5E 00
 ld e, (ix + 127)       ;; 0913:  DD 5E 7F
 ld h, (ix + -128)      ;; 0916:  DD 66 80
 ld h, (ix + 0)         ;; 0919:  DD 66 00
 ld h, (ix + 127)       ;; 091C:  DD 66 7F
 ld l, (ix + -128)      ;; 091F:  DD 6E 80
 ld l, (ix + 0)         ;; 0922:  DD 6E 00
 ld l, (ix + 127)       ;; 0925:  DD 6E 7F
 ld a, (ix + -128)      ;; 0928:  DD 7E 80
 ld a, (ix + 0)         ;; 092B:  DD 7E 00
 ld a, (ix + 127)       ;; 092E:  DD 7E 7F
 ld b, (iy + -128)      ;; 0931:  FD 46 80
 ld b, (iy + 0)         ;; 0934:  FD 46 00
 ld b, (iy + 127)       ;; 0937:  FD 46 7F
 ld c, (iy + -128)      ;; 093A:  FD 4E 80
 ld c, (iy + 0)         ;; 093D:  FD 4E 00
 ld c, (iy + 127)       ;; 0940:  FD 4E 7F
 ld d, (iy + -128)      ;; 0943:  FD 56 80
 ld d, (iy + 0)         ;; 0946:  FD 56 00
 ld d, (iy + 127)       ;; 0949:  FD 56 7F
 ld e, (iy + -128)      ;; 094C:  FD 5E 80
 ld e, (iy + 0)         ;; 094F:  FD 5E 00
 ld e, (iy + 127)       ;; 0952:  FD 5E 7F
 ld h, (iy + -128)      ;; 0955:  FD 66 80
 ld h, (iy + 0)         ;; 0958:  FD 66 00
 ld h, (iy + 127)       ;; 095B:  FD 66 7F
 ld l, (iy + -128)      ;; 095E:  FD 6E 80
 ld l, (iy + 0)         ;; 0961:  FD 6E 00
 ld l, (iy + 127)       ;; 0964:  FD 6E 7F
 ld a, (iy + -128)      ;; 0967:  FD 7E 80
 ld a, (iy + 0)         ;; 096A:  FD 7E 00
 ld a, (iy + 127)       ;; 096D:  FD 7E 7F
 ld (hl), b             ;; 0970:  70
 ld (hl), c             ;; 0971:  71
 ld (hl), d             ;; 0972:  72
 ld (hl), e             ;; 0973:  73
 ld (hl), h             ;; 0974:  74
 ld (hl), l             ;; 0975:  75
 ld (hl), a             ;; 0976:  77
 ld (ix + -128), b      ;; 0977:  DD 70 80
 ld (ix + 0), b         ;; 097A:  DD 70 00
 ld (ix + 127), b       ;; 097D:  DD 70 7F
 ld (ix + -128), c      ;; 0980:  DD 71 80
 ld (ix + 0), c         ;; 0983:  DD 71 00
 ld (ix + 127), c       ;; 0986:  DD 71 7F
 ld (ix + -128), d      ;; 0989:  DD 72 80
 ld (ix + 0), d         ;; 098C:  DD 72 00
 ld (ix + 127), d       ;; 098F:  DD 72 7F
 ld (ix + -128), e      ;; 0992:  DD 73 80
 ld (ix + 0), e         ;; 0995:  DD 73 00
 ld (ix + 127), e       ;; 0998:  DD 73 7F
 ld (ix + -128), h      ;; 099B:  DD 74 80
 ld (ix + 0), h         ;; 099E:  DD 74 00
 ld (ix + 127), h       ;; 09A1:  DD 74 7F
 ld (ix + -128), l      ;; 09A4:  DD 75 80
 ld (ix + 0), l         ;; 09A7:  DD 75 00
 ld (ix + 127), l       ;; 09AA:  DD 75 7F
 ld (ix + -128), a      ;; 09AD:  DD 77 80
 ld (ix + 0), a         ;; 09B0:  DD 77 00
 ld (ix + 127), a       ;; 09B3:  DD 77 7F
 ld (iy + -128), b      ;; 09B6:  FD 70 80
 ld (iy + 0), b         ;; 09B9:  FD 70 00
 ld (iy + 127), b       ;; 09BC:  FD 70 7F
 ld (iy + -128), c      ;; 09BF:  FD 71 80
 ld (iy + 0), c         ;; 09C2:  FD 71 00
 ld (iy + 127), c       ;; 09C5:  FD 71 7F
 ld (iy + -128), d      ;; 09C8:  FD 72 80
 ld (iy + 0), d         ;; 09CB:  FD 72 00
 ld (iy + 127), d       ;; 09CE:  FD 72 7F
 ld (iy + -128), e      ;; 09D1:  FD 73 80
 ld (iy + 0), e         ;; 09D4:  FD 73 00
 ld (iy + 127), e       ;; 09D7:  FD 73 7F
 ld (iy + -128), h      ;; 09DA:  FD 74 80
 ld (iy + 0), h         ;; 09DD:  FD 74 00
 ld (iy + 127), h       ;; 09E0:  FD 74 7F
 ld (iy + -128), l      ;; 09E3:  FD 75 80
 ld (iy + 0), l         ;; 09E6:  FD 75 00
 ld (iy + 127), l       ;; 09E9:  FD 75 7F
 ld (iy + -128), a      ;; 09EC:  FD 77 80
 ld (iy + 0), a         ;; 09EF:  FD 77 00
 ld (iy + 127), a       ;; 09F2:  FD 77 7F
 ld (hl), 0             ;; 09F5:  36 00
 ld (hl), 85            ;; 09F7:  36 55
 ld (hl), 170           ;; 09F9:  36 AA
 ld (hl), 255           ;; 09FB:  36 FF
 ld (ix + -128), 0      ;; 09FD:  DD 36 80 00
 ld (ix + 0), 0         ;; 0A01:  DD 36 00 00
 ld (ix + 127), 0       ;; 0A05:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0A09:  DD 36 80 55
 ld (ix + 0), 85        ;; 0A0D:  DD 36 00 55
 ld (ix + 127), 85      ;; 0A11:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0A15:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0A19:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0A1D:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0A21:  DD 36 80 FF
 ld (ix + 0), 255       ;; 0A25:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0A29:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0A2D:  FD 36 80 00
 ld (iy + 0), 0         ;; 0A31:  FD 36 00 00
 ld (iy + 127), 0       ;; 0A35:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0A39:  FD 36 80 55
 ld (iy + 0), 85        ;; 0A3D:  FD 36 00 55
 ld (iy + 127), 85      ;; 0A41:  FD 36 7F 55
 ld (iy + -128), 170    ;; 0A45:  FD 36 80 AA
 ld (iy + 0), 170       ;; 0A49:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0A4D:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0A51:  FD 36 80 FF
 ld (iy + 0), 255       ;; 0A55:  FD 36 00 FF
 ld (iy + 127), 255     ;; 0A59:  FD 36 7F FF
 ld a, (bc)             ;; 0A5D:  0A
 ld a, (de)             ;; 0A5E:  1A
 ld (bc), a             ;; 0A5F:  02
 ld (de), a             ;; 0A60:  12
 ld a, (0)              ;; 0A61:  3A 00 00
 ld a, (291)            ;; 0A64:  3A 23 01
 ld a, (17767)          ;; 0A67:  3A 67 45
 ld a, (35243)          ;; 0A6A:  3A AB 89
 ld a, (52719)          ;; 0A6D:  3A EF CD
 ld a, (65535)          ;; 0A70:  3A FF FF
 ld (0), a              ;; 0A73:  32 00 00
 ld (291), a            ;; 0A76:  32 23 01
 ld (17767), a          ;; 0A79:  32 67 45
 ld (35243), a          ;; 0A7C:  32 AB 89
 ld (52719), a          ;; 0A7F:  32 EF CD
 ld (65535), a          ;; 0A82:  32 FF FF
 ld bc, 0               ;; 0A85:  01 00 00
 ld bc, 291             ;; 0A88:  01 23 01
 ld bc, 17767           ;; 0A8B:  01 67 45
 ld bc, 35243           ;; 0A8E:  01 AB 89
 ld bc, 52719           ;; 0A91:  01 EF CD
 ld bc, 65535           ;; 0A94:  01 FF FF
 ld de, 0               ;; 0A97:  11 00 00
 ld de, 291             ;; 0A9A:  11 23 01
 ld de, 17767           ;; 0A9D:  11 67 45
 ld de, 35243           ;; 0AA0:  11 AB 89
 ld de, 52719           ;; 0AA3:  11 EF CD
 ld de, 65535           ;; 0AA6:  11 FF FF
 ld hl, 0               ;; 0AA9:  21 00 00
 ld hl, 291             ;; 0AAC:  21 23 01
 ld hl, 17767           ;; 0AAF:  21 67 45
 ld hl, 35243           ;; 0AB2:  21 AB 89
 ld hl, 52719           ;; 0AB5:  21 EF CD
 ld hl, 65535           ;; 0AB8:  21 FF FF
 ld sp, 0               ;; 0ABB:  31 00 00
 ld sp, 291             ;; 0ABE:  31 23 01
 ld sp, 17767           ;; 0AC1:  31 67 45
 ld sp, 35243           ;; 0AC4:  31 AB 89
 ld sp, 52719           ;; 0AC7:  31 EF CD
 ld sp, 65535           ;; 0ACA:  31 FF FF
 ld ix, 0               ;; 0ACD:  DD 21 00 00
 ld ix, 291             ;; 0AD1:  DD 21 23 01
 ld ix, 17767           ;; 0AD5:  DD 21 67 45
 ld ix, 35243           ;; 0AD9:  DD 21 AB 89
 ld ix, 52719           ;; 0ADD:  DD 21 EF CD
 ld ix, 65535           ;; 0AE1:  DD 21 FF FF
 ld iy, 0               ;; 0AE5:  FD 21 00 00
 ld iy, 291             ;; 0AE9:  FD 21 23 01
 ld iy, 17767           ;; 0AED:  FD 21 67 45
 ld iy, 35243           ;; 0AF1:  FD 21 AB 89
 ld iy, 52719           ;; 0AF5:  FD 21 EF CD
 ld iy, 65535           ;; 0AF9:  FD 21 FF FF
 ld hl, (0)             ;; 0AFD:  2A 00 00
 ld hl, (291)           ;; 0B00:  2A 23 01
 ld hl, (17767)         ;; 0B03:  2A 67 45
 ld hl, (35243)         ;; 0B06:  2A AB 89
 ld hl, (52719)         ;; 0B09:  2A EF CD
 ld hl, (65535)         ;; 0B0C:  2A FF FF
 ld ix, (0)             ;; 0B0F:  DD 2A 00 00
 ld ix, (291)           ;; 0B13:  DD 2A 23 01
 ld ix, (17767)         ;; 0B17:  DD 2A 67 45
 ld ix, (35243)         ;; 0B1B:  DD 2A AB 89
 ld ix, (52719)         ;; 0B1F:  DD 2A EF CD
 ld ix, (65535)         ;; 0B23:  DD 2A FF FF
 ld iy, (0)             ;; 0B27:  FD 2A 00 00
 ld iy, (291)           ;; 0B2B:  FD 2A 23 01
 ld iy, (17767)         ;; 0B2F:  FD 2A 67 45
 ld iy, (35243)         ;; 0B33:  FD 2A AB 89
 ld iy, (52719)         ;; 0B37:  FD 2A EF CD
 ld iy, (65535)         ;; 0B3B:  FD 2A FF FF
 ld (0), hl             ;; 0B3F:  22 00 00
 ld (291), hl           ;; 0B42:  22 23 01
 ld (17767), hl         ;; 0B45:  22 67 45
 ld (35243), hl         ;; 0B48:  22 AB 89
 ld (52719), hl         ;; 0B4B:  22 EF CD
 ld (65535), hl         ;; 0B4E:  22 FF FF
 ld (0), ix             ;; 0B51:  DD 22 00 00
 ld (291), ix           ;; 0B55:  DD 22 23 01
 ld (17767), ix         ;; 0B59:  DD 22 67 45
 ld (35243), ix         ;; 0B5D:  DD 22 AB 89
 ld (52719), ix         ;; 0B61:  DD 22 EF CD
 ld (65535), ix         ;; 0B65:  DD 22 FF FF
 ld (0), iy             ;; 0B69:  FD 22 00 00
 ld (291), iy           ;; 0B6D:  FD 22 23 01
 ld (17767), iy         ;; 0B71:  FD 22 67 45
 ld (35243), iy         ;; 0B75:  FD 22 AB 89
 ld (52719), iy         ;; 0B79:  FD 22 EF CD
 ld (65535), iy         ;; 0B7D:  FD 22 FF FF
 LD bc, (0)             ;; 0B81:  ED 4B 00 00
 LD bc, (291)           ;; 0B85:  ED 4B 23 01
 LD bc, (17767)         ;; 0B89:  ED 4B 67 45
 LD bc, (35243)         ;; 0B8D:  ED 4B AB 89
 LD bc, (52719)         ;; 0B91:  ED 4B EF CD
 LD bc, (65535)         ;; 0B95:  ED 4B FF FF
 LD de, (0)             ;; 0B99:  ED 5B 00 00
 LD de, (291)           ;; 0B9D:  ED 5B 23 01
 LD de, (17767)         ;; 0BA1:  ED 5B 67 45
 LD de, (35243)         ;; 0BA5:  ED 5B AB 89
 LD de, (52719)         ;; 0BA9:  ED 5B EF CD
 LD de, (65535)         ;; 0BAD:  ED 5B FF FF
 LD sp, (0)             ;; 0BB1:  ED 7B 00 00
 LD sp, (291)           ;; 0BB5:  ED 7B 23 01
 LD sp, (17767)         ;; 0BB9:  ED 7B 67 45
 LD sp, (35243)         ;; 0BBD:  ED 7B AB 89
 LD sp, (52719)         ;; 0BC1:  ED 7B EF CD
 LD sp, (65535)         ;; 0BC5:  ED 7B FF FF
 LD (0), bc             ;; 0BC9:  ED 43 00 00
 LD (291), bc           ;; 0BCD:  ED 43 23 01
 LD (17767), bc         ;; 0BD1:  ED 43 67 45
 LD (35243), bc         ;; 0BD5:  ED 43 AB 89
 LD (52719), bc         ;; 0BD9:  ED 43 EF CD
 LD (65535), bc         ;; 0BDD:  ED 43 FF FF
 LD (0), de             ;; 0BE1:  ED 53 00 00
 LD (291), de           ;; 0BE5:  ED 53 23 01
 LD (17767), de         ;; 0BE9:  ED 53 67 45
 LD (35243), de         ;; 0BED:  ED 53 AB 89
 LD (52719), de         ;; 0BF1:  ED 53 EF CD
 LD (65535), de         ;; 0BF5:  ED 53 FF FF
 LD (0), sp             ;; 0BF9:  ED 73 00 00
 LD (291), sp           ;; 0BFD:  ED 73 23 01
 LD (17767), sp         ;; 0C01:  ED 73 67 45
 LD (35243), sp         ;; 0C05:  ED 73 AB 89
 LD (52719), sp         ;; 0C09:  ED 73 EF CD
 LD (65535), sp         ;; 0C0D:  ED 73 FF FF
 ld sp, hl              ;; 0C11:  F9
 ld sp, ix              ;; 0C12:  DD F9
 ld sp, iy              ;; 0C14:  FD F9
 push bc                ;; 0C16:  C5
 push de                ;; 0C17:  D5
 push hl                ;; 0C18:  E5
 push af                ;; 0C19:  F5
 push ix                ;; 0C1A:  DD E5
 push iy                ;; 0C1C:  FD E5
 pop bc                 ;; 0C1E:  C1
 pop de                 ;; 0C1F:  D1
 pop hl                 ;; 0C20:  E1
 pop af                 ;; 0C21:  F1
 pop ix                 ;; 0C22:  DD E1
 pop iy                 ;; 0C24:  FD E1
 ex af, af              ;; 0C26:  08
 ex af, af'             ;; 0C27:  08
 exx                    ;; 0C28:  D9
 ex (sp), hl            ;; 0C29:  E3
 ex (sp), ix            ;; 0C2A:  DD E3
 ex (sp), iy            ;; 0C2C:  FD E3
 ex de, hl              ;; 0C2E:  EB
 ldi                    ;; 0C2F:  ED A0
 ldir                   ;; 0C31:  ED B0
 ldd                    ;; 0C33:  ED A8
 lddr                   ;; 0C35:  ED B8
 cpi                    ;; 0C37:  ED A1
 cpir                   ;; 0C39:  ED B1
 cpd                    ;; 0C3B:  ED A9
 cpdr                   ;; 0C3D:  ED B9
