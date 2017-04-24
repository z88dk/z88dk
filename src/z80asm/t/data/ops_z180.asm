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
 ADD A, 0               ;; 0040:  C6 00
 ADD A, 85              ;; 0042:  C6 55
 ADD A, 170             ;; 0044:  C6 AA
 ADD A, 255             ;; 0046:  C6 FF
 ADC A, 0               ;; 0048:  CE 00
 ADC A, 85              ;; 004A:  CE 55
 ADC A, 170             ;; 004C:  CE AA
 ADC A, 255             ;; 004E:  CE FF
 SUB 0                  ;; 0050:  D6 00
 SUB 85                 ;; 0052:  D6 55
 SUB 170                ;; 0054:  D6 AA
 SUB 255                ;; 0056:  D6 FF
 SBC A, 0               ;; 0058:  DE 00
 SBC A, 85              ;; 005A:  DE 55
 SBC A, 170             ;; 005C:  DE AA
 SBC A, 255             ;; 005E:  DE FF
 AND 0                  ;; 0060:  E6 00
 AND 85                 ;; 0062:  E6 55
 AND 170                ;; 0064:  E6 AA
 AND 255                ;; 0066:  E6 FF
 XOR 0                  ;; 0068:  EE 00
 XOR 85                 ;; 006A:  EE 55
 XOR 170                ;; 006C:  EE AA
 XOR 255                ;; 006E:  EE FF
 OR 0                   ;; 0070:  F6 00
 OR 85                  ;; 0072:  F6 55
 OR 170                 ;; 0074:  F6 AA
 OR 255                 ;; 0076:  F6 FF
 CP 0                   ;; 0078:  FE 00
 CP 85                  ;; 007A:  FE 55
 CP 170                 ;; 007C:  FE AA
 CP 255                 ;; 007E:  FE FF
 ADD A, (HL)            ;; 0080:  86
 ADC A, (HL)            ;; 0081:  8E
 SUB (HL)               ;; 0082:  96
 SBC A, (HL)            ;; 0083:  9E
 AND (HL)               ;; 0084:  A6
 XOR (HL)               ;; 0085:  AE
 OR (HL)                ;; 0086:  B6
 CP (HL)                ;; 0087:  BE
 ADD A, (IX + -128)     ;; 0088:  DD 86 80
 ADD A, (IX + 0)        ;; 008B:  DD 86 00
 ADD A, (IX + 127)      ;; 008E:  DD 86 7F
 ADC A, (IX + -128)     ;; 0091:  DD 8E 80
 ADC A, (IX + 0)        ;; 0094:  DD 8E 00
 ADC A, (IX + 127)      ;; 0097:  DD 8E 7F
 SUB (IX + -128)        ;; 009A:  DD 96 80
 SUB (IX + 0)           ;; 009D:  DD 96 00
 SUB (IX + 127)         ;; 00A0:  DD 96 7F
 SBC A, (IX + -128)     ;; 00A3:  DD 9E 80
 SBC A, (IX + 0)        ;; 00A6:  DD 9E 00
 SBC A, (IX + 127)      ;; 00A9:  DD 9E 7F
 AND (IX + -128)        ;; 00AC:  DD A6 80
 AND (IX + 0)           ;; 00AF:  DD A6 00
 AND (IX + 127)         ;; 00B2:  DD A6 7F
 XOR (IX + -128)        ;; 00B5:  DD AE 80
 XOR (IX + 0)           ;; 00B8:  DD AE 00
 XOR (IX + 127)         ;; 00BB:  DD AE 7F
 OR (IX + -128)         ;; 00BE:  DD B6 80
 OR (IX + 0)            ;; 00C1:  DD B6 00
 OR (IX + 127)          ;; 00C4:  DD B6 7F
 CP (IX + -128)         ;; 00C7:  DD BE 80
 CP (IX + 0)            ;; 00CA:  DD BE 00
 CP (IX + 127)          ;; 00CD:  DD BE 7F
 ADD A, (IY + -128)     ;; 00D0:  FD 86 80
 ADD A, (IY + 0)        ;; 00D3:  FD 86 00
 ADD A, (IY + 127)      ;; 00D6:  FD 86 7F
 ADC A, (IY + -128)     ;; 00D9:  FD 8E 80
 ADC A, (IY + 0)        ;; 00DC:  FD 8E 00
 ADC A, (IY + 127)      ;; 00DF:  FD 8E 7F
 SUB (IY + -128)        ;; 00E2:  FD 96 80
 SUB (IY + 0)           ;; 00E5:  FD 96 00
 SUB (IY + 127)         ;; 00E8:  FD 96 7F
 SBC A, (IY + -128)     ;; 00EB:  FD 9E 80
 SBC A, (IY + 0)        ;; 00EE:  FD 9E 00
 SBC A, (IY + 127)      ;; 00F1:  FD 9E 7F
 AND (IY + -128)        ;; 00F4:  FD A6 80
 AND (IY + 0)           ;; 00F7:  FD A6 00
 AND (IY + 127)         ;; 00FA:  FD A6 7F
 XOR (IY + -128)        ;; 00FD:  FD AE 80
 XOR (IY + 0)           ;; 0100:  FD AE 00
 XOR (IY + 127)         ;; 0103:  FD AE 7F
 OR (IY + -128)         ;; 0106:  FD B6 80
 OR (IY + 0)            ;; 0109:  FD B6 00
 OR (IY + 127)          ;; 010C:  FD B6 7F
 CP (IY + -128)         ;; 010F:  FD BE 80
 CP (IY + 0)            ;; 0112:  FD BE 00
 CP (IY + 127)          ;; 0115:  FD BE 7F
 INC B                  ;; 0118:  04
 INC C                  ;; 0119:  0C
 INC D                  ;; 011A:  14
 INC E                  ;; 011B:  1C
 INC H                  ;; 011C:  24
 INC L                  ;; 011D:  2C
 INC A                  ;; 011E:  3C
 INC (HL)               ;; 011F:  34
 INC (IX + -128)        ;; 0120:  DD 34 80
 INC (IX + 0)           ;; 0123:  DD 34 00
 INC (IX + 127)         ;; 0126:  DD 34 7F
 INC (IY + -128)        ;; 0129:  FD 34 80
 INC (IY + 0)           ;; 012C:  FD 34 00
 INC (IY + 127)         ;; 012F:  FD 34 7F
 DEC B                  ;; 0132:  05
 DEC C                  ;; 0133:  0D
 DEC D                  ;; 0134:  15
 DEC E                  ;; 0135:  1D
 DEC H                  ;; 0136:  25
 DEC L                  ;; 0137:  2D
 DEC A                  ;; 0138:  3D
 DEC (HL)               ;; 0139:  35
 DEC (IX + -128)        ;; 013A:  DD 35 80
 DEC (IX + 0)           ;; 013D:  DD 35 00
 DEC (IX + 127)         ;; 0140:  DD 35 7F
 DEC (IY + -128)        ;; 0143:  FD 35 80
 DEC (IY + 0)           ;; 0146:  FD 35 00
 DEC (IY + 127)         ;; 0149:  FD 35 7F
 TST B                  ;; 014C:  ED 04
 TST C                  ;; 014E:  ED 0C
 TST D                  ;; 0150:  ED 14
 TST E                  ;; 0152:  ED 1C
 TST H                  ;; 0154:  ED 24
 TST L                  ;; 0156:  ED 2C
 TST A                  ;; 0158:  ED 3C
 TST 0                  ;; 015A:  ED 64 00
 TST 85                 ;; 015D:  ED 64 55
 TST 170                ;; 0160:  ED 64 AA
 TST 255                ;; 0163:  ED 64 FF
 TST (HL)               ;; 0166:  ED 34
 DAA                    ;; 0168:  27
 RLD                    ;; 0169:  ED 6F
 RRD                    ;; 016B:  ED 67
 CPL                    ;; 016D:  2F
 NEG                    ;; 016E:  ED 44
 CCF                    ;; 0170:  3F
 SCF                    ;; 0171:  37
 NOP                    ;; 0172:  00
 HALT                   ;; 0173:  76
 SLP                    ;; 0174:  ED 76
 ADD HL, BC             ;; 0176:  09
 ADD HL, DE             ;; 0177:  19
 ADD HL, HL             ;; 0178:  29
 ADD HL, SP             ;; 0179:  39
 ADD IX, BC             ;; 017A:  DD 09
 ADD IY, BC             ;; 017C:  FD 09
 ADD IX, DE             ;; 017E:  DD 19
 ADD IY, DE             ;; 0180:  FD 19
 ADD IX, IX             ;; 0182:  DD 29
 ADD IY, IY             ;; 0184:  FD 29
 ADD IX, SP             ;; 0186:  DD 39
 ADD IY, SP             ;; 0188:  FD 39
 ADC HL, BC             ;; 018A:  ED 4A
 ADC HL, DE             ;; 018C:  ED 5A
 ADC HL, HL             ;; 018E:  ED 6A
 ADC HL, SP             ;; 0190:  ED 7A
 SBC HL, BC             ;; 0192:  ED 42
 SBC HL, DE             ;; 0194:  ED 52
 SBC HL, HL             ;; 0196:  ED 62
 SBC HL, SP             ;; 0198:  ED 72
 INC BC                 ;; 019A:  03
 INC DE                 ;; 019B:  13
 INC HL                 ;; 019C:  23
 INC SP                 ;; 019D:  33
 INC IX                 ;; 019E:  DD 23
 INC IY                 ;; 01A0:  FD 23
 DEC BC                 ;; 01A2:  0B
 DEC DE                 ;; 01A3:  1B
 DEC HL                 ;; 01A4:  2B
 DEC SP                 ;; 01A5:  3B
 DEC IX                 ;; 01A6:  DD 2B
 DEC IY                 ;; 01A8:  FD 2B
 MLT BC                 ;; 01AA:  ED 4C
 MLT DE                 ;; 01AC:  ED 5C
 MLT HL                 ;; 01AE:  ED 6C
 MLT SP                 ;; 01B0:  ED 7C
 RLCA                   ;; 01B2:  07
 RRCA                   ;; 01B3:  0F
 RLA                    ;; 01B4:  17
 RRA                    ;; 01B5:  1F
 RLC B                  ;; 01B6:  CB 00
 RRC B                  ;; 01B8:  CB 08
 RL B                   ;; 01BA:  CB 10
 RR B                   ;; 01BC:  CB 18
 SLA B                  ;; 01BE:  CB 20
 SRA B                  ;; 01C0:  CB 28
 SRL B                  ;; 01C2:  CB 38
 RLC C                  ;; 01C4:  CB 01
 RRC C                  ;; 01C6:  CB 09
 RL C                   ;; 01C8:  CB 11
 RR C                   ;; 01CA:  CB 19
 SLA C                  ;; 01CC:  CB 21
 SRA C                  ;; 01CE:  CB 29
 SRL C                  ;; 01D0:  CB 39
 RLC D                  ;; 01D2:  CB 02
 RRC D                  ;; 01D4:  CB 0A
 RL D                   ;; 01D6:  CB 12
 RR D                   ;; 01D8:  CB 1A
 SLA D                  ;; 01DA:  CB 22
 SRA D                  ;; 01DC:  CB 2A
 SRL D                  ;; 01DE:  CB 3A
 RLC E                  ;; 01E0:  CB 03
 RRC E                  ;; 01E2:  CB 0B
 RL E                   ;; 01E4:  CB 13
 RR E                   ;; 01E6:  CB 1B
 SLA E                  ;; 01E8:  CB 23
 SRA E                  ;; 01EA:  CB 2B
 SRL E                  ;; 01EC:  CB 3B
 RLC H                  ;; 01EE:  CB 04
 RRC H                  ;; 01F0:  CB 0C
 RL H                   ;; 01F2:  CB 14
 RR H                   ;; 01F4:  CB 1C
 SLA H                  ;; 01F6:  CB 24
 SRA H                  ;; 01F8:  CB 2C
 SRL H                  ;; 01FA:  CB 3C
 RLC L                  ;; 01FC:  CB 05
 RRC L                  ;; 01FE:  CB 0D
 RL L                   ;; 0200:  CB 15
 RR L                   ;; 0202:  CB 1D
 SLA L                  ;; 0204:  CB 25
 SRA L                  ;; 0206:  CB 2D
 SRL L                  ;; 0208:  CB 3D
 RLC A                  ;; 020A:  CB 07
 RRC A                  ;; 020C:  CB 0F
 RL A                   ;; 020E:  CB 17
 RR A                   ;; 0210:  CB 1F
 SLA A                  ;; 0212:  CB 27
 SRA A                  ;; 0214:  CB 2F
 SRL A                  ;; 0216:  CB 3F
 SLL B                  ;; 0218:  CB 30
 SLL C                  ;; 021A:  CB 31
 SLL D                  ;; 021C:  CB 32
 SLL E                  ;; 021E:  CB 33
 SLL H                  ;; 0220:  CB 34
 SLL L                  ;; 0222:  CB 35
 SLL A                  ;; 0224:  CB 37
 RLC (HL)               ;; 0226:  CB 06
 RRC (HL)               ;; 0228:  CB 0E
 RL (HL)                ;; 022A:  CB 16
 RR (HL)                ;; 022C:  CB 1E
 SLA (HL)               ;; 022E:  CB 26
 SRA (HL)               ;; 0230:  CB 2E
 SRL (HL)               ;; 0232:  CB 3E
 SLL (HL)               ;; 0234:  CB 36
 RLC (IX + -128)        ;; 0236:  DD CB 80 06
 RLC (IX + 0)           ;; 023A:  DD CB 00 06
 RLC (IX + 127)         ;; 023E:  DD CB 7F 06
 RRC (IX + -128)        ;; 0242:  DD CB 80 0E
 RRC (IX + 0)           ;; 0246:  DD CB 00 0E
 RRC (IX + 127)         ;; 024A:  DD CB 7F 0E
 RL (IX + -128)         ;; 024E:  DD CB 80 16
 RL (IX + 0)            ;; 0252:  DD CB 00 16
 RL (IX + 127)          ;; 0256:  DD CB 7F 16
 RR (IX + -128)         ;; 025A:  DD CB 80 1E
 RR (IX + 0)            ;; 025E:  DD CB 00 1E
 RR (IX + 127)          ;; 0262:  DD CB 7F 1E
 SLA (IX + -128)        ;; 0266:  DD CB 80 26
 SLA (IX + 0)           ;; 026A:  DD CB 00 26
 SLA (IX + 127)         ;; 026E:  DD CB 7F 26
 SRA (IX + -128)        ;; 0272:  DD CB 80 2E
 SRA (IX + 0)           ;; 0276:  DD CB 00 2E
 SRA (IX + 127)         ;; 027A:  DD CB 7F 2E
 SRL (IX + -128)        ;; 027E:  DD CB 80 3E
 SRL (IX + 0)           ;; 0282:  DD CB 00 3E
 SRL (IX + 127)         ;; 0286:  DD CB 7F 3E
 RLC (IY + -128)        ;; 028A:  FD CB 80 06
 RLC (IY + 0)           ;; 028E:  FD CB 00 06
 RLC (IY + 127)         ;; 0292:  FD CB 7F 06
 RRC (IY + -128)        ;; 0296:  FD CB 80 0E
 RRC (IY + 0)           ;; 029A:  FD CB 00 0E
 RRC (IY + 127)         ;; 029E:  FD CB 7F 0E
 RL (IY + -128)         ;; 02A2:  FD CB 80 16
 RL (IY + 0)            ;; 02A6:  FD CB 00 16
 RL (IY + 127)          ;; 02AA:  FD CB 7F 16
 RR (IY + -128)         ;; 02AE:  FD CB 80 1E
 RR (IY + 0)            ;; 02B2:  FD CB 00 1E
 RR (IY + 127)          ;; 02B6:  FD CB 7F 1E
 SLA (IY + -128)        ;; 02BA:  FD CB 80 26
 SLA (IY + 0)           ;; 02BE:  FD CB 00 26
 SLA (IY + 127)         ;; 02C2:  FD CB 7F 26
 SRA (IY + -128)        ;; 02C6:  FD CB 80 2E
 SRA (IY + 0)           ;; 02CA:  FD CB 00 2E
 SRA (IY + 127)         ;; 02CE:  FD CB 7F 2E
 SRL (IY + -128)        ;; 02D2:  FD CB 80 3E
 SRL (IY + 0)           ;; 02D6:  FD CB 00 3E
 SRL (IY + 127)         ;; 02DA:  FD CB 7F 3E
 SLL (IX + -128)        ;; 02DE:  DD CB 80 36
 SLL (IX + 0)           ;; 02E2:  DD CB 00 36
 SLL (IX + 127)         ;; 02E6:  DD CB 7F 36
 SLL (IY + -128)        ;; 02EA:  FD CB 80 36
 SLL (IY + 0)           ;; 02EE:  FD CB 00 36
 SLL (IY + 127)         ;; 02F2:  FD CB 7F 36
 BIT 0, B               ;; 02F6:  CB 40
 BIT 1, B               ;; 02F8:  CB 48
 BIT 2, B               ;; 02FA:  CB 50
 BIT 3, B               ;; 02FC:  CB 58
 BIT 4, B               ;; 02FE:  CB 60
 BIT 5, B               ;; 0300:  CB 68
 BIT 6, B               ;; 0302:  CB 70
 BIT 7, B               ;; 0304:  CB 78
 RES 0, B               ;; 0306:  CB 80
 RES 1, B               ;; 0308:  CB 88
 RES 2, B               ;; 030A:  CB 90
 RES 3, B               ;; 030C:  CB 98
 RES 4, B               ;; 030E:  CB A0
 RES 5, B               ;; 0310:  CB A8
 RES 6, B               ;; 0312:  CB B0
 RES 7, B               ;; 0314:  CB B8
 SET 0, B               ;; 0316:  CB C0
 SET 1, B               ;; 0318:  CB C8
 SET 2, B               ;; 031A:  CB D0
 SET 3, B               ;; 031C:  CB D8
 SET 4, B               ;; 031E:  CB E0
 SET 5, B               ;; 0320:  CB E8
 SET 6, B               ;; 0322:  CB F0
 SET 7, B               ;; 0324:  CB F8
 BIT 0, C               ;; 0326:  CB 41
 BIT 1, C               ;; 0328:  CB 49
 BIT 2, C               ;; 032A:  CB 51
 BIT 3, C               ;; 032C:  CB 59
 BIT 4, C               ;; 032E:  CB 61
 BIT 5, C               ;; 0330:  CB 69
 BIT 6, C               ;; 0332:  CB 71
 BIT 7, C               ;; 0334:  CB 79
 RES 0, C               ;; 0336:  CB 81
 RES 1, C               ;; 0338:  CB 89
 RES 2, C               ;; 033A:  CB 91
 RES 3, C               ;; 033C:  CB 99
 RES 4, C               ;; 033E:  CB A1
 RES 5, C               ;; 0340:  CB A9
 RES 6, C               ;; 0342:  CB B1
 RES 7, C               ;; 0344:  CB B9
 SET 0, C               ;; 0346:  CB C1
 SET 1, C               ;; 0348:  CB C9
 SET 2, C               ;; 034A:  CB D1
 SET 3, C               ;; 034C:  CB D9
 SET 4, C               ;; 034E:  CB E1
 SET 5, C               ;; 0350:  CB E9
 SET 6, C               ;; 0352:  CB F1
 SET 7, C               ;; 0354:  CB F9
 BIT 0, D               ;; 0356:  CB 42
 BIT 1, D               ;; 0358:  CB 4A
 BIT 2, D               ;; 035A:  CB 52
 BIT 3, D               ;; 035C:  CB 5A
 BIT 4, D               ;; 035E:  CB 62
 BIT 5, D               ;; 0360:  CB 6A
 BIT 6, D               ;; 0362:  CB 72
 BIT 7, D               ;; 0364:  CB 7A
 RES 0, D               ;; 0366:  CB 82
 RES 1, D               ;; 0368:  CB 8A
 RES 2, D               ;; 036A:  CB 92
 RES 3, D               ;; 036C:  CB 9A
 RES 4, D               ;; 036E:  CB A2
 RES 5, D               ;; 0370:  CB AA
 RES 6, D               ;; 0372:  CB B2
 RES 7, D               ;; 0374:  CB BA
 SET 0, D               ;; 0376:  CB C2
 SET 1, D               ;; 0378:  CB CA
 SET 2, D               ;; 037A:  CB D2
 SET 3, D               ;; 037C:  CB DA
 SET 4, D               ;; 037E:  CB E2
 SET 5, D               ;; 0380:  CB EA
 SET 6, D               ;; 0382:  CB F2
 SET 7, D               ;; 0384:  CB FA
 BIT 0, E               ;; 0386:  CB 43
 BIT 1, E               ;; 0388:  CB 4B
 BIT 2, E               ;; 038A:  CB 53
 BIT 3, E               ;; 038C:  CB 5B
 BIT 4, E               ;; 038E:  CB 63
 BIT 5, E               ;; 0390:  CB 6B
 BIT 6, E               ;; 0392:  CB 73
 BIT 7, E               ;; 0394:  CB 7B
 RES 0, E               ;; 0396:  CB 83
 RES 1, E               ;; 0398:  CB 8B
 RES 2, E               ;; 039A:  CB 93
 RES 3, E               ;; 039C:  CB 9B
 RES 4, E               ;; 039E:  CB A3
 RES 5, E               ;; 03A0:  CB AB
 RES 6, E               ;; 03A2:  CB B3
 RES 7, E               ;; 03A4:  CB BB
 SET 0, E               ;; 03A6:  CB C3
 SET 1, E               ;; 03A8:  CB CB
 SET 2, E               ;; 03AA:  CB D3
 SET 3, E               ;; 03AC:  CB DB
 SET 4, E               ;; 03AE:  CB E3
 SET 5, E               ;; 03B0:  CB EB
 SET 6, E               ;; 03B2:  CB F3
 SET 7, E               ;; 03B4:  CB FB
 BIT 0, H               ;; 03B6:  CB 44
 BIT 1, H               ;; 03B8:  CB 4C
 BIT 2, H               ;; 03BA:  CB 54
 BIT 3, H               ;; 03BC:  CB 5C
 BIT 4, H               ;; 03BE:  CB 64
 BIT 5, H               ;; 03C0:  CB 6C
 BIT 6, H               ;; 03C2:  CB 74
 BIT 7, H               ;; 03C4:  CB 7C
 RES 0, H               ;; 03C6:  CB 84
 RES 1, H               ;; 03C8:  CB 8C
 RES 2, H               ;; 03CA:  CB 94
 RES 3, H               ;; 03CC:  CB 9C
 RES 4, H               ;; 03CE:  CB A4
 RES 5, H               ;; 03D0:  CB AC
 RES 6, H               ;; 03D2:  CB B4
 RES 7, H               ;; 03D4:  CB BC
 SET 0, H               ;; 03D6:  CB C4
 SET 1, H               ;; 03D8:  CB CC
 SET 2, H               ;; 03DA:  CB D4
 SET 3, H               ;; 03DC:  CB DC
 SET 4, H               ;; 03DE:  CB E4
 SET 5, H               ;; 03E0:  CB EC
 SET 6, H               ;; 03E2:  CB F4
 SET 7, H               ;; 03E4:  CB FC
 BIT 0, L               ;; 03E6:  CB 45
 BIT 1, L               ;; 03E8:  CB 4D
 BIT 2, L               ;; 03EA:  CB 55
 BIT 3, L               ;; 03EC:  CB 5D
 BIT 4, L               ;; 03EE:  CB 65
 BIT 5, L               ;; 03F0:  CB 6D
 BIT 6, L               ;; 03F2:  CB 75
 BIT 7, L               ;; 03F4:  CB 7D
 RES 0, L               ;; 03F6:  CB 85
 RES 1, L               ;; 03F8:  CB 8D
 RES 2, L               ;; 03FA:  CB 95
 RES 3, L               ;; 03FC:  CB 9D
 RES 4, L               ;; 03FE:  CB A5
 RES 5, L               ;; 0400:  CB AD
 RES 6, L               ;; 0402:  CB B5
 RES 7, L               ;; 0404:  CB BD
 SET 0, L               ;; 0406:  CB C5
 SET 1, L               ;; 0408:  CB CD
 SET 2, L               ;; 040A:  CB D5
 SET 3, L               ;; 040C:  CB DD
 SET 4, L               ;; 040E:  CB E5
 SET 5, L               ;; 0410:  CB ED
 SET 6, L               ;; 0412:  CB F5
 SET 7, L               ;; 0414:  CB FD
 BIT 0, A               ;; 0416:  CB 47
 BIT 1, A               ;; 0418:  CB 4F
 BIT 2, A               ;; 041A:  CB 57
 BIT 3, A               ;; 041C:  CB 5F
 BIT 4, A               ;; 041E:  CB 67
 BIT 5, A               ;; 0420:  CB 6F
 BIT 6, A               ;; 0422:  CB 77
 BIT 7, A               ;; 0424:  CB 7F
 RES 0, A               ;; 0426:  CB 87
 RES 1, A               ;; 0428:  CB 8F
 RES 2, A               ;; 042A:  CB 97
 RES 3, A               ;; 042C:  CB 9F
 RES 4, A               ;; 042E:  CB A7
 RES 5, A               ;; 0430:  CB AF
 RES 6, A               ;; 0432:  CB B7
 RES 7, A               ;; 0434:  CB BF
 SET 0, A               ;; 0436:  CB C7
 SET 1, A               ;; 0438:  CB CF
 SET 2, A               ;; 043A:  CB D7
 SET 3, A               ;; 043C:  CB DF
 SET 4, A               ;; 043E:  CB E7
 SET 5, A               ;; 0440:  CB EF
 SET 6, A               ;; 0442:  CB F7
 SET 7, A               ;; 0444:  CB FF
 BIT 0, (HL)            ;; 0446:  CB 46
 BIT 1, (HL)            ;; 0448:  CB 4E
 BIT 2, (HL)            ;; 044A:  CB 56
 BIT 3, (HL)            ;; 044C:  CB 5E
 BIT 4, (HL)            ;; 044E:  CB 66
 BIT 5, (HL)            ;; 0450:  CB 6E
 BIT 6, (HL)            ;; 0452:  CB 76
 BIT 7, (HL)            ;; 0454:  CB 7E
 RES 0, (HL)            ;; 0456:  CB 86
 RES 1, (HL)            ;; 0458:  CB 8E
 RES 2, (HL)            ;; 045A:  CB 96
 RES 3, (HL)            ;; 045C:  CB 9E
 RES 4, (HL)            ;; 045E:  CB A6
 RES 5, (HL)            ;; 0460:  CB AE
 RES 6, (HL)            ;; 0462:  CB B6
 RES 7, (HL)            ;; 0464:  CB BE
 SET 0, (HL)            ;; 0466:  CB C6
 SET 1, (HL)            ;; 0468:  CB CE
 SET 2, (HL)            ;; 046A:  CB D6
 SET 3, (HL)            ;; 046C:  CB DE
 SET 4, (HL)            ;; 046E:  CB E6
 SET 5, (HL)            ;; 0470:  CB EE
 SET 6, (HL)            ;; 0472:  CB F6
 SET 7, (HL)            ;; 0474:  CB FE
 BIT 0, (IX + -128)     ;; 0476:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 047A:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 047E:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 0482:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 0486:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 048A:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 048E:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 0492:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 0496:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 049A:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 049E:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 04A2:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 04A6:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 04AA:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 04AE:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 04B2:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 04B6:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 04BA:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 04BE:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 04C2:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 04C6:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 04CA:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 04CE:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 04D2:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 04D6:  DD CB 80 86
 RES 1, (IX + -128)     ;; 04DA:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 04DE:  DD CB 80 96
 RES 3, (IX + -128)     ;; 04E2:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 04E6:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 04EA:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 04EE:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 04F2:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 04F6:  DD CB 00 86
 RES 1, (IX + 0)        ;; 04FA:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 04FE:  DD CB 00 96
 RES 3, (IX + 0)        ;; 0502:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 0506:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 050A:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 050E:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 0512:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 0516:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 051A:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 051E:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 0522:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 0526:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 052A:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 052E:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0532:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0536:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 053A:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 053E:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0542:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0546:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 054A:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 054E:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0552:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0556:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 055A:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 055E:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 0562:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0566:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 056A:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 056E:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 0572:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 0576:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 057A:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 057E:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 0582:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 0586:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 058A:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 058E:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 0592:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 0596:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 059A:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 059E:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 05A2:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 05A6:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 05AA:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 05AE:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 05B2:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 05B6:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 05BA:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 05BE:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 05C2:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 05C6:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 05CA:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 05CE:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 05D2:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 05D6:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 05DA:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 05DE:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 05E2:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 05E6:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 05EA:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 05EE:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 05F2:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 05F6:  FD CB 80 86
 RES 1, (IY + -128)     ;; 05FA:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 05FE:  FD CB 80 96
 RES 3, (IY + -128)     ;; 0602:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 0606:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 060A:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 060E:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 0612:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 0616:  FD CB 00 86
 RES 1, (IY + 0)        ;; 061A:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 061E:  FD CB 00 96
 RES 3, (IY + 0)        ;; 0622:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 0626:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 062A:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 062E:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0632:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0636:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 063A:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 063E:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0642:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0646:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 064A:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 064E:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0652:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0656:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 065A:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 065E:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 0662:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0666:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 066A:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 066E:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 0672:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 0676:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 067A:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 067E:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 0682:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 0686:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 068A:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 068E:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 0692:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 0696:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 069A:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 069E:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 06A2:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 06A6:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 06AA:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 06AE:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 06B2:  FD CB 7F FE
 JP 0                   ;; 06B6:  C3 00 00
 JP 4660                ;; 06B9:  C3 34 12
 JP 52719               ;; 06BC:  C3 EF CD
 JP 65535               ;; 06BF:  C3 FF FF
 JP NZ, 0               ;; 06C2:  C2 00 00
 JP NZ, 4660            ;; 06C5:  C2 34 12
 JP NZ, 52719           ;; 06C8:  C2 EF CD
 JP NZ, 65535           ;; 06CB:  C2 FF FF
 JP Z, 0                ;; 06CE:  CA 00 00
 JP Z, 4660             ;; 06D1:  CA 34 12
 JP Z, 52719            ;; 06D4:  CA EF CD
 JP Z, 65535            ;; 06D7:  CA FF FF
 JP NC, 0               ;; 06DA:  D2 00 00
 JP NC, 4660            ;; 06DD:  D2 34 12
 JP NC, 52719           ;; 06E0:  D2 EF CD
 JP NC, 65535           ;; 06E3:  D2 FF FF
 JP C, 0                ;; 06E6:  DA 00 00
 JP C, 4660             ;; 06E9:  DA 34 12
 JP C, 52719            ;; 06EC:  DA EF CD
 JP C, 65535            ;; 06EF:  DA FF FF
 JP PO, 0               ;; 06F2:  E2 00 00
 JP PO, 4660            ;; 06F5:  E2 34 12
 JP PO, 52719           ;; 06F8:  E2 EF CD
 JP PO, 65535           ;; 06FB:  E2 FF FF
 JP PE, 0               ;; 06FE:  EA 00 00
 JP PE, 4660            ;; 0701:  EA 34 12
 JP PE, 52719           ;; 0704:  EA EF CD
 JP PE, 65535           ;; 0707:  EA FF FF
 JP P, 0                ;; 070A:  F2 00 00
 JP P, 4660             ;; 070D:  F2 34 12
 JP P, 52719            ;; 0710:  F2 EF CD
 JP P, 65535            ;; 0713:  F2 FF FF
 JP M, 0                ;; 0716:  FA 00 00
 JP M, 4660             ;; 0719:  FA 34 12
 JP M, 52719            ;; 071C:  FA EF CD
 JP M, 65535            ;; 071F:  FA FF FF
 JR ASMPC+2             ;; 0722:  18 00
 JR NZ, ASMPC+2         ;; 0724:  20 00
 JR Z, ASMPC+2          ;; 0726:  28 00
 JR NC, ASMPC+2         ;; 0728:  30 00
 JR C, ASMPC+2          ;; 072A:  38 00
 JP (HL)                ;; 072C:  E9
 JP (IX)                ;; 072D:  DD E9
 JP (IY)                ;; 072F:  FD E9
 DJNZ ASMPC+2           ;; 0731:  10 00
 CALL 0                 ;; 0733:  CD 00 00
 CALL 4660              ;; 0736:  CD 34 12
 CALL 52719             ;; 0739:  CD EF CD
 CALL 65535             ;; 073C:  CD FF FF
 CALL NZ, 0             ;; 073F:  C4 00 00
 CALL NZ, 4660          ;; 0742:  C4 34 12
 CALL NZ, 52719         ;; 0745:  C4 EF CD
 CALL NZ, 65535         ;; 0748:  C4 FF FF
 CALL Z, 0              ;; 074B:  CC 00 00
 CALL Z, 4660           ;; 074E:  CC 34 12
 CALL Z, 52719          ;; 0751:  CC EF CD
 CALL Z, 65535          ;; 0754:  CC FF FF
 CALL NC, 0             ;; 0757:  D4 00 00
 CALL NC, 4660          ;; 075A:  D4 34 12
 CALL NC, 52719         ;; 075D:  D4 EF CD
 CALL NC, 65535         ;; 0760:  D4 FF FF
 CALL C, 0              ;; 0763:  DC 00 00
 CALL C, 4660           ;; 0766:  DC 34 12
 CALL C, 52719          ;; 0769:  DC EF CD
 CALL C, 65535          ;; 076C:  DC FF FF
 CALL PO, 0             ;; 076F:  E4 00 00
 CALL PO, 4660          ;; 0772:  E4 34 12
 CALL PO, 52719         ;; 0775:  E4 EF CD
 CALL PO, 65535         ;; 0778:  E4 FF FF
 CALL PE, 0             ;; 077B:  EC 00 00
 CALL PE, 4660          ;; 077E:  EC 34 12
 CALL PE, 52719         ;; 0781:  EC EF CD
 CALL PE, 65535         ;; 0784:  EC FF FF
 CALL P, 0              ;; 0787:  F4 00 00
 CALL P, 4660           ;; 078A:  F4 34 12
 CALL P, 52719          ;; 078D:  F4 EF CD
 CALL P, 65535          ;; 0790:  F4 FF FF
 CALL M, 0              ;; 0793:  FC 00 00
 CALL M, 4660           ;; 0796:  FC 34 12
 CALL M, 52719          ;; 0799:  FC EF CD
 CALL M, 65535          ;; 079C:  FC FF FF
 RET                    ;; 079F:  C9
 RET NZ                 ;; 07A0:  C0
 RET Z                  ;; 07A1:  C8
 RET NC                 ;; 07A2:  D0
 RET C                  ;; 07A3:  D8
 RET PO                 ;; 07A4:  E0
 RET PE                 ;; 07A5:  E8
 RET P                  ;; 07A6:  F0
 RET M                  ;; 07A7:  F8
 RST 16                 ;; 07A8:  D7
 RST 24                 ;; 07A9:  DF
 RST 32                 ;; 07AA:  E7
 RST 40                 ;; 07AB:  EF
 RST 56                 ;; 07AC:  FF
 RST 0                  ;; 07AD:  C7
 RST 8                  ;; 07AE:  CF
 RST 48                 ;; 07AF:  F7
 IN A, (0)              ;; 07B0:  DB 00
 IN A, (85)             ;; 07B2:  DB 55
 IN A, (170)            ;; 07B4:  DB AA
 IN A, (255)            ;; 07B6:  DB FF
 IN B, (C)              ;; 07B8:  ED 40
 IN C, (C)              ;; 07BA:  ED 48
 IN D, (C)              ;; 07BC:  ED 50
 IN E, (C)              ;; 07BE:  ED 58
 IN H, (C)              ;; 07C0:  ED 60
 IN L, (C)              ;; 07C2:  ED 68
 IN A, (C)              ;; 07C4:  ED 78
 INI                    ;; 07C6:  ED A2
 INIR                   ;; 07C8:  ED B2
 IND                    ;; 07CA:  ED AA
 INDR                   ;; 07CC:  ED BA
 OUT (0), A             ;; 07CE:  D3 00
 OUT (85), A            ;; 07D0:  D3 55
 OUT (170), A           ;; 07D2:  D3 AA
 OUT (255), A           ;; 07D4:  D3 FF
 OUT (C), B             ;; 07D6:  ED 41
 OUT (C), C             ;; 07D8:  ED 49
 OUT (C), D             ;; 07DA:  ED 51
 OUT (C), E             ;; 07DC:  ED 59
 OUT (C), H             ;; 07DE:  ED 61
 OUT (C), L             ;; 07E0:  ED 69
 OUT (C), A             ;; 07E2:  ED 79
 OUTI                   ;; 07E4:  ED A3
 OTIR                   ;; 07E6:  ED B3
 OUTD                   ;; 07E8:  ED AB
 OTDR                   ;; 07EA:  ED BB
 IN0 B, (0)             ;; 07EC:  ED 00 00
 IN0 B, (85)            ;; 07EF:  ED 00 55
 IN0 B, (170)           ;; 07F2:  ED 00 AA
 IN0 B, (255)           ;; 07F5:  ED 00 FF
 IN0 C, (0)             ;; 07F8:  ED 08 00
 IN0 C, (85)            ;; 07FB:  ED 08 55
 IN0 C, (170)           ;; 07FE:  ED 08 AA
 IN0 C, (255)           ;; 0801:  ED 08 FF
 IN0 D, (0)             ;; 0804:  ED 10 00
 IN0 D, (85)            ;; 0807:  ED 10 55
 IN0 D, (170)           ;; 080A:  ED 10 AA
 IN0 D, (255)           ;; 080D:  ED 10 FF
 IN0 E, (0)             ;; 0810:  ED 18 00
 IN0 E, (85)            ;; 0813:  ED 18 55
 IN0 E, (170)           ;; 0816:  ED 18 AA
 IN0 E, (255)           ;; 0819:  ED 18 FF
 IN0 H, (0)             ;; 081C:  ED 20 00
 IN0 H, (85)            ;; 081F:  ED 20 55
 IN0 H, (170)           ;; 0822:  ED 20 AA
 IN0 H, (255)           ;; 0825:  ED 20 FF
 IN0 L, (0)             ;; 0828:  ED 28 00
 IN0 L, (85)            ;; 082B:  ED 28 55
 IN0 L, (170)           ;; 082E:  ED 28 AA
 IN0 L, (255)           ;; 0831:  ED 28 FF
 IN0 A, (0)             ;; 0834:  ED 38 00
 IN0 A, (85)            ;; 0837:  ED 38 55
 IN0 A, (170)           ;; 083A:  ED 38 AA
 IN0 A, (255)           ;; 083D:  ED 38 FF
 OUT0 (0), B            ;; 0840:  ED 01 00
 OUT0 (85), B           ;; 0843:  ED 01 55
 OUT0 (170), B          ;; 0846:  ED 01 AA
 OUT0 (255), B          ;; 0849:  ED 01 FF
 OUT0 (0), C            ;; 084C:  ED 09 00
 OUT0 (85), C           ;; 084F:  ED 09 55
 OUT0 (170), C          ;; 0852:  ED 09 AA
 OUT0 (255), C          ;; 0855:  ED 09 FF
 OUT0 (0), D            ;; 0858:  ED 11 00
 OUT0 (85), D           ;; 085B:  ED 11 55
 OUT0 (170), D          ;; 085E:  ED 11 AA
 OUT0 (255), D          ;; 0861:  ED 11 FF
 OUT0 (0), E            ;; 0864:  ED 19 00
 OUT0 (85), E           ;; 0867:  ED 19 55
 OUT0 (170), E          ;; 086A:  ED 19 AA
 OUT0 (255), E          ;; 086D:  ED 19 FF
 OUT0 (0), H            ;; 0870:  ED 21 00
 OUT0 (85), H           ;; 0873:  ED 21 55
 OUT0 (170), H          ;; 0876:  ED 21 AA
 OUT0 (255), H          ;; 0879:  ED 21 FF
 OUT0 (0), L            ;; 087C:  ED 29 00
 OUT0 (85), L           ;; 087F:  ED 29 55
 OUT0 (170), L          ;; 0882:  ED 29 AA
 OUT0 (255), L          ;; 0885:  ED 29 FF
 OUT0 (0), A            ;; 0888:  ED 39 00
 OUT0 (85), A           ;; 088B:  ED 39 55
 OUT0 (170), A          ;; 088E:  ED 39 AA
 OUT0 (255), A          ;; 0891:  ED 39 FF
 OTDM                   ;; 0894:  ED 8B
 OTDMR                  ;; 0896:  ED 9B
 OTIM                   ;; 0898:  ED 83
 OTIMR                  ;; 089A:  ED 93
 TSTIO 0                ;; 089C:  ED 74 00
 TSTIO 85               ;; 089F:  ED 74 55
 TSTIO 170              ;; 08A2:  ED 74 AA
 TSTIO 255              ;; 08A5:  ED 74 FF
 DI                     ;; 08A8:  F3
 EI                     ;; 08A9:  FB
 IM 0                   ;; 08AA:  ED 46
 IM 1                   ;; 08AC:  ED 56
 IM 2                   ;; 08AE:  ED 5E
 LD I, A                ;; 08B0:  ED 47
 LD A, I                ;; 08B2:  ED 57
 LD R, A                ;; 08B4:  ED 4F
 LD A, R                ;; 08B6:  ED 5F
 RETI                   ;; 08B8:  ED 4D
 RETN                   ;; 08BA:  ED 45
 ld b, b                ;; 08BC:  40
 ld b, c                ;; 08BD:  41
 ld b, d                ;; 08BE:  42
 ld b, e                ;; 08BF:  43
 ld b, h                ;; 08C0:  44
 ld b, l                ;; 08C1:  45
 ld b, a                ;; 08C2:  47
 ld c, b                ;; 08C3:  48
 ld c, c                ;; 08C4:  49
 ld c, d                ;; 08C5:  4A
 ld c, e                ;; 08C6:  4B
 ld c, h                ;; 08C7:  4C
 ld c, l                ;; 08C8:  4D
 ld c, a                ;; 08C9:  4F
 ld d, b                ;; 08CA:  50
 ld d, c                ;; 08CB:  51
 ld d, d                ;; 08CC:  52
 ld d, e                ;; 08CD:  53
 ld d, h                ;; 08CE:  54
 ld d, l                ;; 08CF:  55
 ld d, a                ;; 08D0:  57
 ld e, b                ;; 08D1:  58
 ld e, c                ;; 08D2:  59
 ld e, d                ;; 08D3:  5A
 ld e, e                ;; 08D4:  5B
 ld e, h                ;; 08D5:  5C
 ld e, l                ;; 08D6:  5D
 ld e, a                ;; 08D7:  5F
 ld h, b                ;; 08D8:  60
 ld h, c                ;; 08D9:  61
 ld h, d                ;; 08DA:  62
 ld h, e                ;; 08DB:  63
 ld h, h                ;; 08DC:  64
 ld h, l                ;; 08DD:  65
 ld h, a                ;; 08DE:  67
 ld l, b                ;; 08DF:  68
 ld l, c                ;; 08E0:  69
 ld l, d                ;; 08E1:  6A
 ld l, e                ;; 08E2:  6B
 ld l, h                ;; 08E3:  6C
 ld l, l                ;; 08E4:  6D
 ld l, a                ;; 08E5:  6F
 ld a, b                ;; 08E6:  78
 ld a, c                ;; 08E7:  79
 ld a, d                ;; 08E8:  7A
 ld a, e                ;; 08E9:  7B
 ld a, h                ;; 08EA:  7C
 ld a, l                ;; 08EB:  7D
 ld a, a                ;; 08EC:  7F
 ld b, 0                ;; 08ED:  06 00
 ld b, 85               ;; 08EF:  06 55
 ld b, 170              ;; 08F1:  06 AA
 ld b, 255              ;; 08F3:  06 FF
 ld c, 0                ;; 08F5:  0E 00
 ld c, 85               ;; 08F7:  0E 55
 ld c, 170              ;; 08F9:  0E AA
 ld c, 255              ;; 08FB:  0E FF
 ld d, 0                ;; 08FD:  16 00
 ld d, 85               ;; 08FF:  16 55
 ld d, 170              ;; 0901:  16 AA
 ld d, 255              ;; 0903:  16 FF
 ld e, 0                ;; 0905:  1E 00
 ld e, 85               ;; 0907:  1E 55
 ld e, 170              ;; 0909:  1E AA
 ld e, 255              ;; 090B:  1E FF
 ld h, 0                ;; 090D:  26 00
 ld h, 85               ;; 090F:  26 55
 ld h, 170              ;; 0911:  26 AA
 ld h, 255              ;; 0913:  26 FF
 ld l, 0                ;; 0915:  2E 00
 ld l, 85               ;; 0917:  2E 55
 ld l, 170              ;; 0919:  2E AA
 ld l, 255              ;; 091B:  2E FF
 ld a, 0                ;; 091D:  3E 00
 ld a, 85               ;; 091F:  3E 55
 ld a, 170              ;; 0921:  3E AA
 ld a, 255              ;; 0923:  3E FF
 ld b, (hl)             ;; 0925:  46
 ld c, (hl)             ;; 0926:  4E
 ld d, (hl)             ;; 0927:  56
 ld e, (hl)             ;; 0928:  5E
 ld h, (hl)             ;; 0929:  66
 ld l, (hl)             ;; 092A:  6E
 ld a, (hl)             ;; 092B:  7E
 ld b, (ix + -128)      ;; 092C:  DD 46 80
 ld b, (ix + 0)         ;; 092F:  DD 46 00
 ld b, (ix + 127)       ;; 0932:  DD 46 7F
 ld c, (ix + -128)      ;; 0935:  DD 4E 80
 ld c, (ix + 0)         ;; 0938:  DD 4E 00
 ld c, (ix + 127)       ;; 093B:  DD 4E 7F
 ld d, (ix + -128)      ;; 093E:  DD 56 80
 ld d, (ix + 0)         ;; 0941:  DD 56 00
 ld d, (ix + 127)       ;; 0944:  DD 56 7F
 ld e, (ix + -128)      ;; 0947:  DD 5E 80
 ld e, (ix + 0)         ;; 094A:  DD 5E 00
 ld e, (ix + 127)       ;; 094D:  DD 5E 7F
 ld h, (ix + -128)      ;; 0950:  DD 66 80
 ld h, (ix + 0)         ;; 0953:  DD 66 00
 ld h, (ix + 127)       ;; 0956:  DD 66 7F
 ld l, (ix + -128)      ;; 0959:  DD 6E 80
 ld l, (ix + 0)         ;; 095C:  DD 6E 00
 ld l, (ix + 127)       ;; 095F:  DD 6E 7F
 ld a, (ix + -128)      ;; 0962:  DD 7E 80
 ld a, (ix + 0)         ;; 0965:  DD 7E 00
 ld a, (ix + 127)       ;; 0968:  DD 7E 7F
 ld b, (iy + -128)      ;; 096B:  FD 46 80
 ld b, (iy + 0)         ;; 096E:  FD 46 00
 ld b, (iy + 127)       ;; 0971:  FD 46 7F
 ld c, (iy + -128)      ;; 0974:  FD 4E 80
 ld c, (iy + 0)         ;; 0977:  FD 4E 00
 ld c, (iy + 127)       ;; 097A:  FD 4E 7F
 ld d, (iy + -128)      ;; 097D:  FD 56 80
 ld d, (iy + 0)         ;; 0980:  FD 56 00
 ld d, (iy + 127)       ;; 0983:  FD 56 7F
 ld e, (iy + -128)      ;; 0986:  FD 5E 80
 ld e, (iy + 0)         ;; 0989:  FD 5E 00
 ld e, (iy + 127)       ;; 098C:  FD 5E 7F
 ld h, (iy + -128)      ;; 098F:  FD 66 80
 ld h, (iy + 0)         ;; 0992:  FD 66 00
 ld h, (iy + 127)       ;; 0995:  FD 66 7F
 ld l, (iy + -128)      ;; 0998:  FD 6E 80
 ld l, (iy + 0)         ;; 099B:  FD 6E 00
 ld l, (iy + 127)       ;; 099E:  FD 6E 7F
 ld a, (iy + -128)      ;; 09A1:  FD 7E 80
 ld a, (iy + 0)         ;; 09A4:  FD 7E 00
 ld a, (iy + 127)       ;; 09A7:  FD 7E 7F
 ld (hl), b             ;; 09AA:  70
 ld (hl), c             ;; 09AB:  71
 ld (hl), d             ;; 09AC:  72
 ld (hl), e             ;; 09AD:  73
 ld (hl), h             ;; 09AE:  74
 ld (hl), l             ;; 09AF:  75
 ld (hl), a             ;; 09B0:  77
 ld (ix + -128), b      ;; 09B1:  DD 70 80
 ld (ix + 0), b         ;; 09B4:  DD 70 00
 ld (ix + 127), b       ;; 09B7:  DD 70 7F
 ld (ix + -128), c      ;; 09BA:  DD 71 80
 ld (ix + 0), c         ;; 09BD:  DD 71 00
 ld (ix + 127), c       ;; 09C0:  DD 71 7F
 ld (ix + -128), d      ;; 09C3:  DD 72 80
 ld (ix + 0), d         ;; 09C6:  DD 72 00
 ld (ix + 127), d       ;; 09C9:  DD 72 7F
 ld (ix + -128), e      ;; 09CC:  DD 73 80
 ld (ix + 0), e         ;; 09CF:  DD 73 00
 ld (ix + 127), e       ;; 09D2:  DD 73 7F
 ld (ix + -128), h      ;; 09D5:  DD 74 80
 ld (ix + 0), h         ;; 09D8:  DD 74 00
 ld (ix + 127), h       ;; 09DB:  DD 74 7F
 ld (ix + -128), l      ;; 09DE:  DD 75 80
 ld (ix + 0), l         ;; 09E1:  DD 75 00
 ld (ix + 127), l       ;; 09E4:  DD 75 7F
 ld (ix + -128), a      ;; 09E7:  DD 77 80
 ld (ix + 0), a         ;; 09EA:  DD 77 00
 ld (ix + 127), a       ;; 09ED:  DD 77 7F
 ld (iy + -128), b      ;; 09F0:  FD 70 80
 ld (iy + 0), b         ;; 09F3:  FD 70 00
 ld (iy + 127), b       ;; 09F6:  FD 70 7F
 ld (iy + -128), c      ;; 09F9:  FD 71 80
 ld (iy + 0), c         ;; 09FC:  FD 71 00
 ld (iy + 127), c       ;; 09FF:  FD 71 7F
 ld (iy + -128), d      ;; 0A02:  FD 72 80
 ld (iy + 0), d         ;; 0A05:  FD 72 00
 ld (iy + 127), d       ;; 0A08:  FD 72 7F
 ld (iy + -128), e      ;; 0A0B:  FD 73 80
 ld (iy + 0), e         ;; 0A0E:  FD 73 00
 ld (iy + 127), e       ;; 0A11:  FD 73 7F
 ld (iy + -128), h      ;; 0A14:  FD 74 80
 ld (iy + 0), h         ;; 0A17:  FD 74 00
 ld (iy + 127), h       ;; 0A1A:  FD 74 7F
 ld (iy + -128), l      ;; 0A1D:  FD 75 80
 ld (iy + 0), l         ;; 0A20:  FD 75 00
 ld (iy + 127), l       ;; 0A23:  FD 75 7F
 ld (iy + -128), a      ;; 0A26:  FD 77 80
 ld (iy + 0), a         ;; 0A29:  FD 77 00
 ld (iy + 127), a       ;; 0A2C:  FD 77 7F
 ld (hl), 0             ;; 0A2F:  36 00
 ld (hl), 85            ;; 0A31:  36 55
 ld (hl), 170           ;; 0A33:  36 AA
 ld (hl), 255           ;; 0A35:  36 FF
 ld (ix + -128), 0      ;; 0A37:  DD 36 80 00
 ld (ix + 0), 0         ;; 0A3B:  DD 36 00 00
 ld (ix + 127), 0       ;; 0A3F:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0A43:  DD 36 80 55
 ld (ix + 0), 85        ;; 0A47:  DD 36 00 55
 ld (ix + 127), 85      ;; 0A4B:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0A4F:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0A53:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0A57:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0A5B:  DD 36 80 FF
 ld (ix + 0), 255       ;; 0A5F:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0A63:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0A67:  FD 36 80 00
 ld (iy + 0), 0         ;; 0A6B:  FD 36 00 00
 ld (iy + 127), 0       ;; 0A6F:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0A73:  FD 36 80 55
 ld (iy + 0), 85        ;; 0A77:  FD 36 00 55
 ld (iy + 127), 85      ;; 0A7B:  FD 36 7F 55
 ld (iy + -128), 170    ;; 0A7F:  FD 36 80 AA
 ld (iy + 0), 170       ;; 0A83:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0A87:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0A8B:  FD 36 80 FF
 ld (iy + 0), 255       ;; 0A8F:  FD 36 00 FF
 ld (iy + 127), 255     ;; 0A93:  FD 36 7F FF
 ld a, (bc)             ;; 0A97:  0A
 ld a, (de)             ;; 0A98:  1A
 ld (bc), a             ;; 0A99:  02
 ld (de), a             ;; 0A9A:  12
 ld a, (0)              ;; 0A9B:  3A 00 00
 ld a, (291)            ;; 0A9E:  3A 23 01
 ld a, (17767)          ;; 0AA1:  3A 67 45
 ld a, (35243)          ;; 0AA4:  3A AB 89
 ld a, (52719)          ;; 0AA7:  3A EF CD
 ld a, (65535)          ;; 0AAA:  3A FF FF
 ld (0), a              ;; 0AAD:  32 00 00
 ld (291), a            ;; 0AB0:  32 23 01
 ld (17767), a          ;; 0AB3:  32 67 45
 ld (35243), a          ;; 0AB6:  32 AB 89
 ld (52719), a          ;; 0AB9:  32 EF CD
 ld (65535), a          ;; 0ABC:  32 FF FF
 ld bc, 0               ;; 0ABF:  01 00 00
 ld bc, 291             ;; 0AC2:  01 23 01
 ld bc, 17767           ;; 0AC5:  01 67 45
 ld bc, 35243           ;; 0AC8:  01 AB 89
 ld bc, 52719           ;; 0ACB:  01 EF CD
 ld bc, 65535           ;; 0ACE:  01 FF FF
 ld de, 0               ;; 0AD1:  11 00 00
 ld de, 291             ;; 0AD4:  11 23 01
 ld de, 17767           ;; 0AD7:  11 67 45
 ld de, 35243           ;; 0ADA:  11 AB 89
 ld de, 52719           ;; 0ADD:  11 EF CD
 ld de, 65535           ;; 0AE0:  11 FF FF
 ld hl, 0               ;; 0AE3:  21 00 00
 ld hl, 291             ;; 0AE6:  21 23 01
 ld hl, 17767           ;; 0AE9:  21 67 45
 ld hl, 35243           ;; 0AEC:  21 AB 89
 ld hl, 52719           ;; 0AEF:  21 EF CD
 ld hl, 65535           ;; 0AF2:  21 FF FF
 ld sp, 0               ;; 0AF5:  31 00 00
 ld sp, 291             ;; 0AF8:  31 23 01
 ld sp, 17767           ;; 0AFB:  31 67 45
 ld sp, 35243           ;; 0AFE:  31 AB 89
 ld sp, 52719           ;; 0B01:  31 EF CD
 ld sp, 65535           ;; 0B04:  31 FF FF
 ld ix, 0               ;; 0B07:  DD 21 00 00
 ld ix, 291             ;; 0B0B:  DD 21 23 01
 ld ix, 17767           ;; 0B0F:  DD 21 67 45
 ld ix, 35243           ;; 0B13:  DD 21 AB 89
 ld ix, 52719           ;; 0B17:  DD 21 EF CD
 ld ix, 65535           ;; 0B1B:  DD 21 FF FF
 ld iy, 0               ;; 0B1F:  FD 21 00 00
 ld iy, 291             ;; 0B23:  FD 21 23 01
 ld iy, 17767           ;; 0B27:  FD 21 67 45
 ld iy, 35243           ;; 0B2B:  FD 21 AB 89
 ld iy, 52719           ;; 0B2F:  FD 21 EF CD
 ld iy, 65535           ;; 0B33:  FD 21 FF FF
 ld hl, (0)             ;; 0B37:  2A 00 00
 ld hl, (291)           ;; 0B3A:  2A 23 01
 ld hl, (17767)         ;; 0B3D:  2A 67 45
 ld hl, (35243)         ;; 0B40:  2A AB 89
 ld hl, (52719)         ;; 0B43:  2A EF CD
 ld hl, (65535)         ;; 0B46:  2A FF FF
 ld ix, (0)             ;; 0B49:  DD 2A 00 00
 ld ix, (291)           ;; 0B4D:  DD 2A 23 01
 ld ix, (17767)         ;; 0B51:  DD 2A 67 45
 ld ix, (35243)         ;; 0B55:  DD 2A AB 89
 ld ix, (52719)         ;; 0B59:  DD 2A EF CD
 ld ix, (65535)         ;; 0B5D:  DD 2A FF FF
 ld iy, (0)             ;; 0B61:  FD 2A 00 00
 ld iy, (291)           ;; 0B65:  FD 2A 23 01
 ld iy, (17767)         ;; 0B69:  FD 2A 67 45
 ld iy, (35243)         ;; 0B6D:  FD 2A AB 89
 ld iy, (52719)         ;; 0B71:  FD 2A EF CD
 ld iy, (65535)         ;; 0B75:  FD 2A FF FF
 ld (0), hl             ;; 0B79:  22 00 00
 ld (291), hl           ;; 0B7C:  22 23 01
 ld (17767), hl         ;; 0B7F:  22 67 45
 ld (35243), hl         ;; 0B82:  22 AB 89
 ld (52719), hl         ;; 0B85:  22 EF CD
 ld (65535), hl         ;; 0B88:  22 FF FF
 ld (0), ix             ;; 0B8B:  DD 22 00 00
 ld (291), ix           ;; 0B8F:  DD 22 23 01
 ld (17767), ix         ;; 0B93:  DD 22 67 45
 ld (35243), ix         ;; 0B97:  DD 22 AB 89
 ld (52719), ix         ;; 0B9B:  DD 22 EF CD
 ld (65535), ix         ;; 0B9F:  DD 22 FF FF
 ld (0), iy             ;; 0BA3:  FD 22 00 00
 ld (291), iy           ;; 0BA7:  FD 22 23 01
 ld (17767), iy         ;; 0BAB:  FD 22 67 45
 ld (35243), iy         ;; 0BAF:  FD 22 AB 89
 ld (52719), iy         ;; 0BB3:  FD 22 EF CD
 ld (65535), iy         ;; 0BB7:  FD 22 FF FF
 LD bc, (0)             ;; 0BBB:  ED 4B 00 00
 LD bc, (291)           ;; 0BBF:  ED 4B 23 01
 LD bc, (17767)         ;; 0BC3:  ED 4B 67 45
 LD bc, (35243)         ;; 0BC7:  ED 4B AB 89
 LD bc, (52719)         ;; 0BCB:  ED 4B EF CD
 LD bc, (65535)         ;; 0BCF:  ED 4B FF FF
 LD de, (0)             ;; 0BD3:  ED 5B 00 00
 LD de, (291)           ;; 0BD7:  ED 5B 23 01
 LD de, (17767)         ;; 0BDB:  ED 5B 67 45
 LD de, (35243)         ;; 0BDF:  ED 5B AB 89
 LD de, (52719)         ;; 0BE3:  ED 5B EF CD
 LD de, (65535)         ;; 0BE7:  ED 5B FF FF
 LD sp, (0)             ;; 0BEB:  ED 7B 00 00
 LD sp, (291)           ;; 0BEF:  ED 7B 23 01
 LD sp, (17767)         ;; 0BF3:  ED 7B 67 45
 LD sp, (35243)         ;; 0BF7:  ED 7B AB 89
 LD sp, (52719)         ;; 0BFB:  ED 7B EF CD
 LD sp, (65535)         ;; 0BFF:  ED 7B FF FF
 LD (0), bc             ;; 0C03:  ED 43 00 00
 LD (291), bc           ;; 0C07:  ED 43 23 01
 LD (17767), bc         ;; 0C0B:  ED 43 67 45
 LD (35243), bc         ;; 0C0F:  ED 43 AB 89
 LD (52719), bc         ;; 0C13:  ED 43 EF CD
 LD (65535), bc         ;; 0C17:  ED 43 FF FF
 LD (0), de             ;; 0C1B:  ED 53 00 00
 LD (291), de           ;; 0C1F:  ED 53 23 01
 LD (17767), de         ;; 0C23:  ED 53 67 45
 LD (35243), de         ;; 0C27:  ED 53 AB 89
 LD (52719), de         ;; 0C2B:  ED 53 EF CD
 LD (65535), de         ;; 0C2F:  ED 53 FF FF
 LD (0), sp             ;; 0C33:  ED 73 00 00
 LD (291), sp           ;; 0C37:  ED 73 23 01
 LD (17767), sp         ;; 0C3B:  ED 73 67 45
 LD (35243), sp         ;; 0C3F:  ED 73 AB 89
 LD (52719), sp         ;; 0C43:  ED 73 EF CD
 LD (65535), sp         ;; 0C47:  ED 73 FF FF
 ld sp, hl              ;; 0C4B:  F9
 ld sp, ix              ;; 0C4C:  DD F9
 ld sp, iy              ;; 0C4E:  FD F9
 push bc                ;; 0C50:  C5
 push de                ;; 0C51:  D5
 push hl                ;; 0C52:  E5
 push af                ;; 0C53:  F5
 push ix                ;; 0C54:  DD E5
 push iy                ;; 0C56:  FD E5
 pop bc                 ;; 0C58:  C1
 pop de                 ;; 0C59:  D1
 pop hl                 ;; 0C5A:  E1
 pop af                 ;; 0C5B:  F1
 pop ix                 ;; 0C5C:  DD E1
 pop iy                 ;; 0C5E:  FD E1
 ex af, af              ;; 0C60:  08
 ex af, af'             ;; 0C61:  08
 exx                    ;; 0C62:  D9
 ex (sp), hl            ;; 0C63:  E3
 ex (sp), ix            ;; 0C64:  DD E3
 ex (sp), iy            ;; 0C66:  FD E3
 ex de, hl              ;; 0C68:  EB
 ldi                    ;; 0C69:  ED A0
 ldir                   ;; 0C6B:  ED B0
 ldd                    ;; 0C6D:  ED A8
 lddr                   ;; 0C6F:  ED B8
 cpi                    ;; 0C71:  ED A1
 cpir                   ;; 0C73:  ED B1
 cpd                    ;; 0C75:  ED A9
 cpdr                   ;; 0C77:  ED B9
