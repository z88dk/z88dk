 ADD A, B               ;; 0000:  80
 ADC A, B               ;; 0001:  88
 SUB B                  ;; 0002:  90
 SBC A, B               ;; 0003:  98
 AND B                  ;; 0004:  A0
 XOR B                  ;; 0005:  A8
 OR B                   ;; 0006:  B0
 CP B                   ;; 0007:  B8
 ADD A, C               ;; 0008:  81
 ADC A, C               ;; 0009:  89
 SUB C                  ;; 000A:  91
 SBC A, C               ;; 000B:  99
 AND C                  ;; 000C:  A1
 XOR C                  ;; 000D:  A9
 OR C                   ;; 000E:  B1
 CP C                   ;; 000F:  B9
 ADD A, D               ;; 0010:  82
 ADC A, D               ;; 0011:  8A
 SUB D                  ;; 0012:  92
 SBC A, D               ;; 0013:  9A
 AND D                  ;; 0014:  A2
 XOR D                  ;; 0015:  AA
 OR D                   ;; 0016:  B2
 CP D                   ;; 0017:  BA
 ADD A, E               ;; 0018:  83
 ADC A, E               ;; 0019:  8B
 SUB E                  ;; 001A:  93
 SBC A, E               ;; 001B:  9B
 AND E                  ;; 001C:  A3
 XOR E                  ;; 001D:  AB
 OR E                   ;; 001E:  B3
 CP E                   ;; 001F:  BB
 ADD A, H               ;; 0020:  84
 ADC A, H               ;; 0021:  8C
 SUB H                  ;; 0022:  94
 SBC A, H               ;; 0023:  9C
 AND H                  ;; 0024:  A4
 XOR H                  ;; 0025:  AC
 OR H                   ;; 0026:  B4
 CP H                   ;; 0027:  BC
 ADD A, L               ;; 0028:  85
 ADC A, L               ;; 0029:  8D
 SUB L                  ;; 002A:  95
 SBC A, L               ;; 002B:  9D
 AND L                  ;; 002C:  A5
 XOR L                  ;; 002D:  AD
 OR L                   ;; 002E:  B5
 CP L                   ;; 002F:  BD
 ADD A, A               ;; 0030:  87
 ADC A, A               ;; 0031:  8F
 SUB A                  ;; 0032:  97
 SBC A, A               ;; 0033:  9F
 AND A                  ;; 0034:  A7
 XOR A                  ;; 0035:  AF
 OR A                   ;; 0036:  B7
 CP A                   ;; 0037:  BF
 ADD A, 0               ;; 0038:  C6 00
 ADD A, 85              ;; 003A:  C6 55
 ADD A, 170             ;; 003C:  C6 AA
 ADD A, 255             ;; 003E:  C6 FF
 ADC A, 0               ;; 0040:  CE 00
 ADC A, 85              ;; 0042:  CE 55
 ADC A, 170             ;; 0044:  CE AA
 ADC A, 255             ;; 0046:  CE FF
 SUB 0                  ;; 0048:  D6 00
 SUB 85                 ;; 004A:  D6 55
 SUB 170                ;; 004C:  D6 AA
 SUB 255                ;; 004E:  D6 FF
 SBC A, 0               ;; 0050:  DE 00
 SBC A, 85              ;; 0052:  DE 55
 SBC A, 170             ;; 0054:  DE AA
 SBC A, 255             ;; 0056:  DE FF
 AND 0                  ;; 0058:  E6 00
 AND 85                 ;; 005A:  E6 55
 AND 170                ;; 005C:  E6 AA
 AND 255                ;; 005E:  E6 FF
 XOR 0                  ;; 0060:  EE 00
 XOR 85                 ;; 0062:  EE 55
 XOR 170                ;; 0064:  EE AA
 XOR 255                ;; 0066:  EE FF
 OR 0                   ;; 0068:  F6 00
 OR 85                  ;; 006A:  F6 55
 OR 170                 ;; 006C:  F6 AA
 OR 255                 ;; 006E:  F6 FF
 CP 0                   ;; 0070:  FE 00
 CP 85                  ;; 0072:  FE 55
 CP 170                 ;; 0074:  FE AA
 CP 255                 ;; 0076:  FE FF
 ADD A, (HL)            ;; 0078:  86
 ADC A, (HL)            ;; 0079:  8E
 SUB (HL)               ;; 007A:  96
 SBC A, (HL)            ;; 007B:  9E
 AND (HL)               ;; 007C:  A6
 XOR (HL)               ;; 007D:  AE
 OR (HL)                ;; 007E:  B6
 CP (HL)                ;; 007F:  BE
 ADD A, (IX + -128)     ;; 0080:  DD 86 80
 ADD A, (IX + 0)        ;; 0083:  DD 86 00
 ADD A, (IX + 127)      ;; 0086:  DD 86 7F
 ADC A, (IX + -128)     ;; 0089:  DD 8E 80
 ADC A, (IX + 0)        ;; 008C:  DD 8E 00
 ADC A, (IX + 127)      ;; 008F:  DD 8E 7F
 SUB (IX + -128)        ;; 0092:  DD 96 80
 SUB (IX + 0)           ;; 0095:  DD 96 00
 SUB (IX + 127)         ;; 0098:  DD 96 7F
 SBC A, (IX + -128)     ;; 009B:  DD 9E 80
 SBC A, (IX + 0)        ;; 009E:  DD 9E 00
 SBC A, (IX + 127)      ;; 00A1:  DD 9E 7F
 AND (IX + -128)        ;; 00A4:  DD A6 80
 AND (IX + 0)           ;; 00A7:  DD A6 00
 AND (IX + 127)         ;; 00AA:  DD A6 7F
 XOR (IX + -128)        ;; 00AD:  DD AE 80
 XOR (IX + 0)           ;; 00B0:  DD AE 00
 XOR (IX + 127)         ;; 00B3:  DD AE 7F
 OR (IX + -128)         ;; 00B6:  DD B6 80
 OR (IX + 0)            ;; 00B9:  DD B6 00
 OR (IX + 127)          ;; 00BC:  DD B6 7F
 CP (IX + -128)         ;; 00BF:  DD BE 80
 CP (IX + 0)            ;; 00C2:  DD BE 00
 CP (IX + 127)          ;; 00C5:  DD BE 7F
 ADD A, (IY + -128)     ;; 00C8:  FD 86 80
 ADD A, (IY + 0)        ;; 00CB:  FD 86 00
 ADD A, (IY + 127)      ;; 00CE:  FD 86 7F
 ADC A, (IY + -128)     ;; 00D1:  FD 8E 80
 ADC A, (IY + 0)        ;; 00D4:  FD 8E 00
 ADC A, (IY + 127)      ;; 00D7:  FD 8E 7F
 SUB (IY + -128)        ;; 00DA:  FD 96 80
 SUB (IY + 0)           ;; 00DD:  FD 96 00
 SUB (IY + 127)         ;; 00E0:  FD 96 7F
 SBC A, (IY + -128)     ;; 00E3:  FD 9E 80
 SBC A, (IY + 0)        ;; 00E6:  FD 9E 00
 SBC A, (IY + 127)      ;; 00E9:  FD 9E 7F
 AND (IY + -128)        ;; 00EC:  FD A6 80
 AND (IY + 0)           ;; 00EF:  FD A6 00
 AND (IY + 127)         ;; 00F2:  FD A6 7F
 XOR (IY + -128)        ;; 00F5:  FD AE 80
 XOR (IY + 0)           ;; 00F8:  FD AE 00
 XOR (IY + 127)         ;; 00FB:  FD AE 7F
 OR (IY + -128)         ;; 00FE:  FD B6 80
 OR (IY + 0)            ;; 0101:  FD B6 00
 OR (IY + 127)          ;; 0104:  FD B6 7F
 CP (IY + -128)         ;; 0107:  FD BE 80
 CP (IY + 0)            ;; 010A:  FD BE 00
 CP (IY + 127)          ;; 010D:  FD BE 7F
 INC B                  ;; 0110:  04
 INC C                  ;; 0111:  0C
 INC D                  ;; 0112:  14
 INC E                  ;; 0113:  1C
 INC H                  ;; 0114:  24
 INC L                  ;; 0115:  2C
 INC A                  ;; 0116:  3C
 INC (HL)               ;; 0117:  34
 INC (IX + -128)        ;; 0118:  DD 34 80
 INC (IX + 0)           ;; 011B:  DD 34 00
 INC (IX + 127)         ;; 011E:  DD 34 7F
 INC (IY + -128)        ;; 0121:  FD 34 80
 INC (IY + 0)           ;; 0124:  FD 34 00
 INC (IY + 127)         ;; 0127:  FD 34 7F
 DEC B                  ;; 012A:  05
 DEC C                  ;; 012B:  0D
 DEC D                  ;; 012C:  15
 DEC E                  ;; 012D:  1D
 DEC H                  ;; 012E:  25
 DEC L                  ;; 012F:  2D
 DEC A                  ;; 0130:  3D
 DEC (HL)               ;; 0131:  35
 DEC (IX + -128)        ;; 0132:  DD 35 80
 DEC (IX + 0)           ;; 0135:  DD 35 00
 DEC (IX + 127)         ;; 0138:  DD 35 7F
 DEC (IY + -128)        ;; 013B:  FD 35 80
 DEC (IY + 0)           ;; 013E:  FD 35 00
 DEC (IY + 127)         ;; 0141:  FD 35 7F
 TST B                  ;; 0144:  ED 04
 TST C                  ;; 0146:  ED 0C
 TST D                  ;; 0148:  ED 14
 TST E                  ;; 014A:  ED 1C
 TST H                  ;; 014C:  ED 24
 TST L                  ;; 014E:  ED 2C
 TST A                  ;; 0150:  ED 3C
 TST 0                  ;; 0152:  ED 64 00
 TST 85                 ;; 0155:  ED 64 55
 TST 170                ;; 0158:  ED 64 AA
 TST 255                ;; 015B:  ED 64 FF
 TST (HL)               ;; 015E:  ED 34
 CPL                    ;; 0160:  2F
 NEG                    ;; 0161:  ED 44
 CCF                    ;; 0163:  3F
 SCF                    ;; 0164:  37
 NOP                    ;; 0165:  00
 ALTD                   ;; 0166:  76
 LD A, XPC              ;; 0167:  ED 77
 LD XPC, A              ;; 0169:  ED 67
 ADD HL, BC             ;; 016B:  09
 ADD HL, DE             ;; 016C:  19
 ADD HL, HL             ;; 016D:  29
 ADD HL, SP             ;; 016E:  39
 ADD IX, BC             ;; 016F:  DD 09
 ADD IY, BC             ;; 0171:  FD 09
 ADD IX, DE             ;; 0173:  DD 19
 ADD IY, DE             ;; 0175:  FD 19
 ADD IX, IX             ;; 0177:  DD 29
 ADD IY, IY             ;; 0179:  FD 29
 ADD IX, SP             ;; 017B:  DD 39
 ADD IY, SP             ;; 017D:  FD 39
 ADD SP, -128           ;; 017F:  27 80
 ADD SP, 0              ;; 0181:  27 00
 ADD SP, 127            ;; 0183:  27 7F
 ADC HL, BC             ;; 0185:  ED 4A
 ADC HL, DE             ;; 0187:  ED 5A
 ADC HL, HL             ;; 0189:  ED 6A
 ADC HL, SP             ;; 018B:  ED 7A
 SBC HL, BC             ;; 018D:  ED 42
 SBC HL, DE             ;; 018F:  ED 52
 SBC HL, HL             ;; 0191:  ED 62
 SBC HL, SP             ;; 0193:  ED 72
 AND HL, DE             ;; 0195:  DC
 AND IX, DE             ;; 0196:  DD DC
 AND IY, DE             ;; 0198:  FD DC
 BOOL HL                ;; 019A:  CC
 BOOL IX                ;; 019B:  DD CC
 BOOL IY                ;; 019D:  FD CC
 INC BC                 ;; 019F:  03
 INC DE                 ;; 01A0:  13
 INC HL                 ;; 01A1:  23
 INC SP                 ;; 01A2:  33
 INC IX                 ;; 01A3:  DD 23
 INC IY                 ;; 01A5:  FD 23
 DEC BC                 ;; 01A7:  0B
 DEC DE                 ;; 01A8:  1B
 DEC HL                 ;; 01A9:  2B
 DEC SP                 ;; 01AA:  3B
 DEC IX                 ;; 01AB:  DD 2B
 DEC IY                 ;; 01AD:  FD 2B
 MLT BC                 ;; 01AF:  ED 4C
 MLT DE                 ;; 01B1:  ED 5C
 MLT HL                 ;; 01B3:  ED 6C
 RLCA                   ;; 01B5:  07
 RRCA                   ;; 01B6:  0F
 RLA                    ;; 01B7:  17
 RRA                    ;; 01B8:  1F
 RLC B                  ;; 01B9:  CB 00
 RRC B                  ;; 01BB:  CB 08
 RL B                   ;; 01BD:  CB 10
 RR B                   ;; 01BF:  CB 18
 SLA B                  ;; 01C1:  CB 20
 SRA B                  ;; 01C3:  CB 28
 SRL B                  ;; 01C5:  CB 38
 RLC C                  ;; 01C7:  CB 01
 RRC C                  ;; 01C9:  CB 09
 RL C                   ;; 01CB:  CB 11
 RR C                   ;; 01CD:  CB 19
 SLA C                  ;; 01CF:  CB 21
 SRA C                  ;; 01D1:  CB 29
 SRL C                  ;; 01D3:  CB 39
 RLC D                  ;; 01D5:  CB 02
 RRC D                  ;; 01D7:  CB 0A
 RL D                   ;; 01D9:  CB 12
 RR D                   ;; 01DB:  CB 1A
 SLA D                  ;; 01DD:  CB 22
 SRA D                  ;; 01DF:  CB 2A
 SRL D                  ;; 01E1:  CB 3A
 RLC E                  ;; 01E3:  CB 03
 RRC E                  ;; 01E5:  CB 0B
 RL E                   ;; 01E7:  CB 13
 RR E                   ;; 01E9:  CB 1B
 SLA E                  ;; 01EB:  CB 23
 SRA E                  ;; 01ED:  CB 2B
 SRL E                  ;; 01EF:  CB 3B
 RLC H                  ;; 01F1:  CB 04
 RRC H                  ;; 01F3:  CB 0C
 RL H                   ;; 01F5:  CB 14
 RR H                   ;; 01F7:  CB 1C
 SLA H                  ;; 01F9:  CB 24
 SRA H                  ;; 01FB:  CB 2C
 SRL H                  ;; 01FD:  CB 3C
 RLC L                  ;; 01FF:  CB 05
 RRC L                  ;; 0201:  CB 0D
 RL L                   ;; 0203:  CB 15
 RR L                   ;; 0205:  CB 1D
 SLA L                  ;; 0207:  CB 25
 SRA L                  ;; 0209:  CB 2D
 SRL L                  ;; 020B:  CB 3D
 RLC A                  ;; 020D:  CB 07
 RRC A                  ;; 020F:  CB 0F
 RL A                   ;; 0211:  CB 17
 RR A                   ;; 0213:  CB 1F
 SLA A                  ;; 0215:  CB 27
 SRA A                  ;; 0217:  CB 2F
 SRL A                  ;; 0219:  CB 3F
 RLC (HL)               ;; 021B:  CB 06
 RRC (HL)               ;; 021D:  CB 0E
 RL (HL)                ;; 021F:  CB 16
 RR (HL)                ;; 0221:  CB 1E
 SLA (HL)               ;; 0223:  CB 26
 SRA (HL)               ;; 0225:  CB 2E
 SRL (HL)               ;; 0227:  CB 3E
 RLC (IX + -128)        ;; 0229:  DD CB 80 06
 RLC (IX + 0)           ;; 022D:  DD CB 00 06
 RLC (IX + 127)         ;; 0231:  DD CB 7F 06
 RRC (IX + -128)        ;; 0235:  DD CB 80 0E
 RRC (IX + 0)           ;; 0239:  DD CB 00 0E
 RRC (IX + 127)         ;; 023D:  DD CB 7F 0E
 RL (IX + -128)         ;; 0241:  DD CB 80 16
 RL (IX + 0)            ;; 0245:  DD CB 00 16
 RL (IX + 127)          ;; 0249:  DD CB 7F 16
 RR (IX + -128)         ;; 024D:  DD CB 80 1E
 RR (IX + 0)            ;; 0251:  DD CB 00 1E
 RR (IX + 127)          ;; 0255:  DD CB 7F 1E
 SLA (IX + -128)        ;; 0259:  DD CB 80 26
 SLA (IX + 0)           ;; 025D:  DD CB 00 26
 SLA (IX + 127)         ;; 0261:  DD CB 7F 26
 SRA (IX + -128)        ;; 0265:  DD CB 80 2E
 SRA (IX + 0)           ;; 0269:  DD CB 00 2E
 SRA (IX + 127)         ;; 026D:  DD CB 7F 2E
 SRL (IX + -128)        ;; 0271:  DD CB 80 3E
 SRL (IX + 0)           ;; 0275:  DD CB 00 3E
 SRL (IX + 127)         ;; 0279:  DD CB 7F 3E
 RLC (IY + -128)        ;; 027D:  FD CB 80 06
 RLC (IY + 0)           ;; 0281:  FD CB 00 06
 RLC (IY + 127)         ;; 0285:  FD CB 7F 06
 RRC (IY + -128)        ;; 0289:  FD CB 80 0E
 RRC (IY + 0)           ;; 028D:  FD CB 00 0E
 RRC (IY + 127)         ;; 0291:  FD CB 7F 0E
 RL (IY + -128)         ;; 0295:  FD CB 80 16
 RL (IY + 0)            ;; 0299:  FD CB 00 16
 RL (IY + 127)          ;; 029D:  FD CB 7F 16
 RR (IY + -128)         ;; 02A1:  FD CB 80 1E
 RR (IY + 0)            ;; 02A5:  FD CB 00 1E
 RR (IY + 127)          ;; 02A9:  FD CB 7F 1E
 SLA (IY + -128)        ;; 02AD:  FD CB 80 26
 SLA (IY + 0)           ;; 02B1:  FD CB 00 26
 SLA (IY + 127)         ;; 02B5:  FD CB 7F 26
 SRA (IY + -128)        ;; 02B9:  FD CB 80 2E
 SRA (IY + 0)           ;; 02BD:  FD CB 00 2E
 SRA (IY + 127)         ;; 02C1:  FD CB 7F 2E
 SRL (IY + -128)        ;; 02C5:  FD CB 80 3E
 SRL (IY + 0)           ;; 02C9:  FD CB 00 3E
 SRL (IY + 127)         ;; 02CD:  FD CB 7F 3E
 BIT 0, B               ;; 02D1:  CB 40
 BIT 1, B               ;; 02D3:  CB 48
 BIT 2, B               ;; 02D5:  CB 50
 BIT 3, B               ;; 02D7:  CB 58
 BIT 4, B               ;; 02D9:  CB 60
 BIT 5, B               ;; 02DB:  CB 68
 BIT 6, B               ;; 02DD:  CB 70
 BIT 7, B               ;; 02DF:  CB 78
 RES 0, B               ;; 02E1:  CB 80
 RES 1, B               ;; 02E3:  CB 88
 RES 2, B               ;; 02E5:  CB 90
 RES 3, B               ;; 02E7:  CB 98
 RES 4, B               ;; 02E9:  CB A0
 RES 5, B               ;; 02EB:  CB A8
 RES 6, B               ;; 02ED:  CB B0
 RES 7, B               ;; 02EF:  CB B8
 SET 0, B               ;; 02F1:  CB C0
 SET 1, B               ;; 02F3:  CB C8
 SET 2, B               ;; 02F5:  CB D0
 SET 3, B               ;; 02F7:  CB D8
 SET 4, B               ;; 02F9:  CB E0
 SET 5, B               ;; 02FB:  CB E8
 SET 6, B               ;; 02FD:  CB F0
 SET 7, B               ;; 02FF:  CB F8
 BIT 0, C               ;; 0301:  CB 41
 BIT 1, C               ;; 0303:  CB 49
 BIT 2, C               ;; 0305:  CB 51
 BIT 3, C               ;; 0307:  CB 59
 BIT 4, C               ;; 0309:  CB 61
 BIT 5, C               ;; 030B:  CB 69
 BIT 6, C               ;; 030D:  CB 71
 BIT 7, C               ;; 030F:  CB 79
 RES 0, C               ;; 0311:  CB 81
 RES 1, C               ;; 0313:  CB 89
 RES 2, C               ;; 0315:  CB 91
 RES 3, C               ;; 0317:  CB 99
 RES 4, C               ;; 0319:  CB A1
 RES 5, C               ;; 031B:  CB A9
 RES 6, C               ;; 031D:  CB B1
 RES 7, C               ;; 031F:  CB B9
 SET 0, C               ;; 0321:  CB C1
 SET 1, C               ;; 0323:  CB C9
 SET 2, C               ;; 0325:  CB D1
 SET 3, C               ;; 0327:  CB D9
 SET 4, C               ;; 0329:  CB E1
 SET 5, C               ;; 032B:  CB E9
 SET 6, C               ;; 032D:  CB F1
 SET 7, C               ;; 032F:  CB F9
 BIT 0, D               ;; 0331:  CB 42
 BIT 1, D               ;; 0333:  CB 4A
 BIT 2, D               ;; 0335:  CB 52
 BIT 3, D               ;; 0337:  CB 5A
 BIT 4, D               ;; 0339:  CB 62
 BIT 5, D               ;; 033B:  CB 6A
 BIT 6, D               ;; 033D:  CB 72
 BIT 7, D               ;; 033F:  CB 7A
 RES 0, D               ;; 0341:  CB 82
 RES 1, D               ;; 0343:  CB 8A
 RES 2, D               ;; 0345:  CB 92
 RES 3, D               ;; 0347:  CB 9A
 RES 4, D               ;; 0349:  CB A2
 RES 5, D               ;; 034B:  CB AA
 RES 6, D               ;; 034D:  CB B2
 RES 7, D               ;; 034F:  CB BA
 SET 0, D               ;; 0351:  CB C2
 SET 1, D               ;; 0353:  CB CA
 SET 2, D               ;; 0355:  CB D2
 SET 3, D               ;; 0357:  CB DA
 SET 4, D               ;; 0359:  CB E2
 SET 5, D               ;; 035B:  CB EA
 SET 6, D               ;; 035D:  CB F2
 SET 7, D               ;; 035F:  CB FA
 BIT 0, E               ;; 0361:  CB 43
 BIT 1, E               ;; 0363:  CB 4B
 BIT 2, E               ;; 0365:  CB 53
 BIT 3, E               ;; 0367:  CB 5B
 BIT 4, E               ;; 0369:  CB 63
 BIT 5, E               ;; 036B:  CB 6B
 BIT 6, E               ;; 036D:  CB 73
 BIT 7, E               ;; 036F:  CB 7B
 RES 0, E               ;; 0371:  CB 83
 RES 1, E               ;; 0373:  CB 8B
 RES 2, E               ;; 0375:  CB 93
 RES 3, E               ;; 0377:  CB 9B
 RES 4, E               ;; 0379:  CB A3
 RES 5, E               ;; 037B:  CB AB
 RES 6, E               ;; 037D:  CB B3
 RES 7, E               ;; 037F:  CB BB
 SET 0, E               ;; 0381:  CB C3
 SET 1, E               ;; 0383:  CB CB
 SET 2, E               ;; 0385:  CB D3
 SET 3, E               ;; 0387:  CB DB
 SET 4, E               ;; 0389:  CB E3
 SET 5, E               ;; 038B:  CB EB
 SET 6, E               ;; 038D:  CB F3
 SET 7, E               ;; 038F:  CB FB
 BIT 0, H               ;; 0391:  CB 44
 BIT 1, H               ;; 0393:  CB 4C
 BIT 2, H               ;; 0395:  CB 54
 BIT 3, H               ;; 0397:  CB 5C
 BIT 4, H               ;; 0399:  CB 64
 BIT 5, H               ;; 039B:  CB 6C
 BIT 6, H               ;; 039D:  CB 74
 BIT 7, H               ;; 039F:  CB 7C
 RES 0, H               ;; 03A1:  CB 84
 RES 1, H               ;; 03A3:  CB 8C
 RES 2, H               ;; 03A5:  CB 94
 RES 3, H               ;; 03A7:  CB 9C
 RES 4, H               ;; 03A9:  CB A4
 RES 5, H               ;; 03AB:  CB AC
 RES 6, H               ;; 03AD:  CB B4
 RES 7, H               ;; 03AF:  CB BC
 SET 0, H               ;; 03B1:  CB C4
 SET 1, H               ;; 03B3:  CB CC
 SET 2, H               ;; 03B5:  CB D4
 SET 3, H               ;; 03B7:  CB DC
 SET 4, H               ;; 03B9:  CB E4
 SET 5, H               ;; 03BB:  CB EC
 SET 6, H               ;; 03BD:  CB F4
 SET 7, H               ;; 03BF:  CB FC
 BIT 0, L               ;; 03C1:  CB 45
 BIT 1, L               ;; 03C3:  CB 4D
 BIT 2, L               ;; 03C5:  CB 55
 BIT 3, L               ;; 03C7:  CB 5D
 BIT 4, L               ;; 03C9:  CB 65
 BIT 5, L               ;; 03CB:  CB 6D
 BIT 6, L               ;; 03CD:  CB 75
 BIT 7, L               ;; 03CF:  CB 7D
 RES 0, L               ;; 03D1:  CB 85
 RES 1, L               ;; 03D3:  CB 8D
 RES 2, L               ;; 03D5:  CB 95
 RES 3, L               ;; 03D7:  CB 9D
 RES 4, L               ;; 03D9:  CB A5
 RES 5, L               ;; 03DB:  CB AD
 RES 6, L               ;; 03DD:  CB B5
 RES 7, L               ;; 03DF:  CB BD
 SET 0, L               ;; 03E1:  CB C5
 SET 1, L               ;; 03E3:  CB CD
 SET 2, L               ;; 03E5:  CB D5
 SET 3, L               ;; 03E7:  CB DD
 SET 4, L               ;; 03E9:  CB E5
 SET 5, L               ;; 03EB:  CB ED
 SET 6, L               ;; 03ED:  CB F5
 SET 7, L               ;; 03EF:  CB FD
 BIT 0, A               ;; 03F1:  CB 47
 BIT 1, A               ;; 03F3:  CB 4F
 BIT 2, A               ;; 03F5:  CB 57
 BIT 3, A               ;; 03F7:  CB 5F
 BIT 4, A               ;; 03F9:  CB 67
 BIT 5, A               ;; 03FB:  CB 6F
 BIT 6, A               ;; 03FD:  CB 77
 BIT 7, A               ;; 03FF:  CB 7F
 RES 0, A               ;; 0401:  CB 87
 RES 1, A               ;; 0403:  CB 8F
 RES 2, A               ;; 0405:  CB 97
 RES 3, A               ;; 0407:  CB 9F
 RES 4, A               ;; 0409:  CB A7
 RES 5, A               ;; 040B:  CB AF
 RES 6, A               ;; 040D:  CB B7
 RES 7, A               ;; 040F:  CB BF
 SET 0, A               ;; 0411:  CB C7
 SET 1, A               ;; 0413:  CB CF
 SET 2, A               ;; 0415:  CB D7
 SET 3, A               ;; 0417:  CB DF
 SET 4, A               ;; 0419:  CB E7
 SET 5, A               ;; 041B:  CB EF
 SET 6, A               ;; 041D:  CB F7
 SET 7, A               ;; 041F:  CB FF
 BIT 0, (HL)            ;; 0421:  CB 46
 BIT 1, (HL)            ;; 0423:  CB 4E
 BIT 2, (HL)            ;; 0425:  CB 56
 BIT 3, (HL)            ;; 0427:  CB 5E
 BIT 4, (HL)            ;; 0429:  CB 66
 BIT 5, (HL)            ;; 042B:  CB 6E
 BIT 6, (HL)            ;; 042D:  CB 76
 BIT 7, (HL)            ;; 042F:  CB 7E
 RES 0, (HL)            ;; 0431:  CB 86
 RES 1, (HL)            ;; 0433:  CB 8E
 RES 2, (HL)            ;; 0435:  CB 96
 RES 3, (HL)            ;; 0437:  CB 9E
 RES 4, (HL)            ;; 0439:  CB A6
 RES 5, (HL)            ;; 043B:  CB AE
 RES 6, (HL)            ;; 043D:  CB B6
 RES 7, (HL)            ;; 043F:  CB BE
 SET 0, (HL)            ;; 0441:  CB C6
 SET 1, (HL)            ;; 0443:  CB CE
 SET 2, (HL)            ;; 0445:  CB D6
 SET 3, (HL)            ;; 0447:  CB DE
 SET 4, (HL)            ;; 0449:  CB E6
 SET 5, (HL)            ;; 044B:  CB EE
 SET 6, (HL)            ;; 044D:  CB F6
 SET 7, (HL)            ;; 044F:  CB FE
 BIT 0, (IX + -128)     ;; 0451:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 0455:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 0459:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 045D:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 0461:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 0465:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 0469:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 046D:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 0471:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 0475:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 0479:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 047D:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 0481:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 0485:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 0489:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 048D:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 0491:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 0495:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 0499:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 049D:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 04A1:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 04A5:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 04A9:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 04AD:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 04B1:  DD CB 80 86
 RES 1, (IX + -128)     ;; 04B5:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 04B9:  DD CB 80 96
 RES 3, (IX + -128)     ;; 04BD:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 04C1:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 04C5:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 04C9:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 04CD:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 04D1:  DD CB 00 86
 RES 1, (IX + 0)        ;; 04D5:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 04D9:  DD CB 00 96
 RES 3, (IX + 0)        ;; 04DD:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 04E1:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 04E5:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 04E9:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 04ED:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 04F1:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 04F5:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 04F9:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 04FD:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 0501:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 0505:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 0509:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 050D:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0511:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 0515:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 0519:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 051D:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0521:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 0525:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 0529:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 052D:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0531:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 0535:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 0539:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 053D:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0541:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 0545:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 0549:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 054D:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 0551:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 0555:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 0559:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 055D:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 0561:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 0565:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 0569:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 056D:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 0571:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 0575:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 0579:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 057D:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 0581:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 0585:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 0589:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 058D:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 0591:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 0595:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 0599:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 059D:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 05A1:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 05A5:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 05A9:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 05AD:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 05B1:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 05B5:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 05B9:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 05BD:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 05C1:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 05C5:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 05C9:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 05CD:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 05D1:  FD CB 80 86
 RES 1, (IY + -128)     ;; 05D5:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 05D9:  FD CB 80 96
 RES 3, (IY + -128)     ;; 05DD:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 05E1:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 05E5:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 05E9:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 05ED:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 05F1:  FD CB 00 86
 RES 1, (IY + 0)        ;; 05F5:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 05F9:  FD CB 00 96
 RES 3, (IY + 0)        ;; 05FD:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 0601:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 0605:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 0609:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 060D:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0611:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 0615:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 0619:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 061D:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0621:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 0625:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 0629:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 062D:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0631:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 0635:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 0639:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 063D:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0641:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 0645:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 0649:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 064D:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 0651:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 0655:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 0659:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 065D:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 0661:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 0665:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 0669:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 066D:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 0671:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 0675:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 0679:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 067D:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 0681:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 0685:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 0689:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 068D:  FD CB 7F FE
 JP 0                   ;; 0691:  C3 00 00
 JP 4660                ;; 0694:  C3 34 12
 JP 52719               ;; 0697:  C3 EF CD
 JP 65535               ;; 069A:  C3 FF FF
 JP NZ, 0               ;; 069D:  C2 00 00
 JP NZ, 4660            ;; 06A0:  C2 34 12
 JP NZ, 52719           ;; 06A3:  C2 EF CD
 JP NZ, 65535           ;; 06A6:  C2 FF FF
 JP Z, 0                ;; 06A9:  CA 00 00
 JP Z, 4660             ;; 06AC:  CA 34 12
 JP Z, 52719            ;; 06AF:  CA EF CD
 JP Z, 65535            ;; 06B2:  CA FF FF
 JP NC, 0               ;; 06B5:  D2 00 00
 JP NC, 4660            ;; 06B8:  D2 34 12
 JP NC, 52719           ;; 06BB:  D2 EF CD
 JP NC, 65535           ;; 06BE:  D2 FF FF
 JP C, 0                ;; 06C1:  DA 00 00
 JP C, 4660             ;; 06C4:  DA 34 12
 JP C, 52719            ;; 06C7:  DA EF CD
 JP C, 65535            ;; 06CA:  DA FF FF
 JP PO, 0               ;; 06CD:  E2 00 00
 JP PO, 4660            ;; 06D0:  E2 34 12
 JP PO, 52719           ;; 06D3:  E2 EF CD
 JP PO, 65535           ;; 06D6:  E2 FF FF
 JP PE, 0               ;; 06D9:  EA 00 00
 JP PE, 4660            ;; 06DC:  EA 34 12
 JP PE, 52719           ;; 06DF:  EA EF CD
 JP PE, 65535           ;; 06E2:  EA FF FF
 JP P, 0                ;; 06E5:  F2 00 00
 JP P, 4660             ;; 06E8:  F2 34 12
 JP P, 52719            ;; 06EB:  F2 EF CD
 JP P, 65535            ;; 06EE:  F2 FF FF
 JP M, 0                ;; 06F1:  FA 00 00
 JP M, 4660             ;; 06F4:  FA 34 12
 JP M, 52719            ;; 06F7:  FA EF CD
 JP M, 65535            ;; 06FA:  FA FF FF
 JP LZ, 0               ;; 06FD:  E2 00 00
 JP LZ, 4660            ;; 0700:  E2 34 12
 JP LZ, 52719           ;; 0703:  E2 EF CD
 JP LZ, 65535           ;; 0706:  E2 FF FF
 JP LO, 0               ;; 0709:  EA 00 00
 JP LO, 4660            ;; 070C:  EA 34 12
 JP LO, 52719           ;; 070F:  EA EF CD
 JP LO, 65535           ;; 0712:  EA FF FF
 JR ASMPC+2             ;; 0715:  18 00
 JR NZ, ASMPC+2         ;; 0717:  20 00
 JR Z, ASMPC+2          ;; 0719:  28 00
 JR NC, ASMPC+2         ;; 071B:  30 00
 JR C, ASMPC+2          ;; 071D:  38 00
 JP (HL)                ;; 071F:  E9
 JP (IX)                ;; 0720:  DD E9
 JP (IY)                ;; 0722:  FD E9
 DJNZ ASMPC+2           ;; 0724:  10 00
 CALL 0                 ;; 0726:  CD 00 00
 CALL 4660              ;; 0729:  CD 34 12
 CALL 52719             ;; 072C:  CD EF CD
 CALL 65535             ;; 072F:  CD FF FF
 RET                    ;; 0732:  C9
 RET NZ                 ;; 0733:  C0
 RET Z                  ;; 0734:  C8
 RET NC                 ;; 0735:  D0
 RET C                  ;; 0736:  D8
 RET PO                 ;; 0737:  E0
 RET PE                 ;; 0738:  E8
 RET P                  ;; 0739:  F0
 RET M                  ;; 073A:  F8
 RET LZ                 ;; 073B:  E0
 RET LO                 ;; 073C:  E8
 RST 16                 ;; 073D:  D7
 RST 24                 ;; 073E:  DF
 RST 32                 ;; 073F:  E7
 RST 40                 ;; 0740:  EF
 RST 56                 ;; 0741:  FF
 IOE                    ;; 0742:  DB
 IOI                    ;; 0743:  D3
 IPSET 0                ;; 0744:  ED 46
 IPSET 1                ;; 0746:  ED 56
 IPSET 2                ;; 0748:  ED 4E
 IPSET 3                ;; 074A:  ED 5E
 IPRES                  ;; 074C:  ED 5D
 LD IIR, A              ;; 074E:  ED 47
 LD A, IIR              ;; 0750:  ED 57
 LD EIR, A              ;; 0752:  ED 4F
 LD A, EIR              ;; 0754:  ED 5F
 RETI                   ;; 0756:  ED 4D
 ld b, b                ;; 0758:  40
 ld b, c                ;; 0759:  41
 ld b, d                ;; 075A:  42
 ld b, e                ;; 075B:  43
 ld b, h                ;; 075C:  44
 ld b, l                ;; 075D:  45
 ld b, a                ;; 075E:  47
 ld c, b                ;; 075F:  48
 ld c, c                ;; 0760:  49
 ld c, d                ;; 0761:  4A
 ld c, e                ;; 0762:  4B
 ld c, h                ;; 0763:  4C
 ld c, l                ;; 0764:  4D
 ld c, a                ;; 0765:  4F
 ld d, b                ;; 0766:  50
 ld d, c                ;; 0767:  51
 ld d, d                ;; 0768:  52
 ld d, e                ;; 0769:  53
 ld d, h                ;; 076A:  54
 ld d, l                ;; 076B:  55
 ld d, a                ;; 076C:  57
 ld e, b                ;; 076D:  58
 ld e, c                ;; 076E:  59
 ld e, d                ;; 076F:  5A
 ld e, e                ;; 0770:  5B
 ld e, h                ;; 0771:  5C
 ld e, l                ;; 0772:  5D
 ld e, a                ;; 0773:  5F
 ld h, b                ;; 0774:  60
 ld h, c                ;; 0775:  61
 ld h, d                ;; 0776:  62
 ld h, e                ;; 0777:  63
 ld h, h                ;; 0778:  64
 ld h, l                ;; 0779:  65
 ld h, a                ;; 077A:  67
 ld l, b                ;; 077B:  68
 ld l, c                ;; 077C:  69
 ld l, d                ;; 077D:  6A
 ld l, e                ;; 077E:  6B
 ld l, h                ;; 077F:  6C
 ld l, l                ;; 0780:  6D
 ld l, a                ;; 0781:  6F
 ld a, b                ;; 0782:  78
 ld a, c                ;; 0783:  79
 ld a, d                ;; 0784:  7A
 ld a, e                ;; 0785:  7B
 ld a, h                ;; 0786:  7C
 ld a, l                ;; 0787:  7D
 ld a, a                ;; 0788:  7F
 ld b, 0                ;; 0789:  06 00
 ld b, 85               ;; 078B:  06 55
 ld b, 170              ;; 078D:  06 AA
 ld b, 255              ;; 078F:  06 FF
 ld c, 0                ;; 0791:  0E 00
 ld c, 85               ;; 0793:  0E 55
 ld c, 170              ;; 0795:  0E AA
 ld c, 255              ;; 0797:  0E FF
 ld d, 0                ;; 0799:  16 00
 ld d, 85               ;; 079B:  16 55
 ld d, 170              ;; 079D:  16 AA
 ld d, 255              ;; 079F:  16 FF
 ld e, 0                ;; 07A1:  1E 00
 ld e, 85               ;; 07A3:  1E 55
 ld e, 170              ;; 07A5:  1E AA
 ld e, 255              ;; 07A7:  1E FF
 ld h, 0                ;; 07A9:  26 00
 ld h, 85               ;; 07AB:  26 55
 ld h, 170              ;; 07AD:  26 AA
 ld h, 255              ;; 07AF:  26 FF
 ld l, 0                ;; 07B1:  2E 00
 ld l, 85               ;; 07B3:  2E 55
 ld l, 170              ;; 07B5:  2E AA
 ld l, 255              ;; 07B7:  2E FF
 ld a, 0                ;; 07B9:  3E 00
 ld a, 85               ;; 07BB:  3E 55
 ld a, 170              ;; 07BD:  3E AA
 ld a, 255              ;; 07BF:  3E FF
 ld b, (hl)             ;; 07C1:  46
 ld c, (hl)             ;; 07C2:  4E
 ld d, (hl)             ;; 07C3:  56
 ld e, (hl)             ;; 07C4:  5E
 ld h, (hl)             ;; 07C5:  66
 ld l, (hl)             ;; 07C6:  6E
 ld a, (hl)             ;; 07C7:  7E
 ld b, (ix + -128)      ;; 07C8:  DD 46 80
 ld b, (ix + 0)         ;; 07CB:  DD 46 00
 ld b, (ix + 127)       ;; 07CE:  DD 46 7F
 ld c, (ix + -128)      ;; 07D1:  DD 4E 80
 ld c, (ix + 0)         ;; 07D4:  DD 4E 00
 ld c, (ix + 127)       ;; 07D7:  DD 4E 7F
 ld d, (ix + -128)      ;; 07DA:  DD 56 80
 ld d, (ix + 0)         ;; 07DD:  DD 56 00
 ld d, (ix + 127)       ;; 07E0:  DD 56 7F
 ld e, (ix + -128)      ;; 07E3:  DD 5E 80
 ld e, (ix + 0)         ;; 07E6:  DD 5E 00
 ld e, (ix + 127)       ;; 07E9:  DD 5E 7F
 ld h, (ix + -128)      ;; 07EC:  DD 66 80
 ld h, (ix + 0)         ;; 07EF:  DD 66 00
 ld h, (ix + 127)       ;; 07F2:  DD 66 7F
 ld l, (ix + -128)      ;; 07F5:  DD 6E 80
 ld l, (ix + 0)         ;; 07F8:  DD 6E 00
 ld l, (ix + 127)       ;; 07FB:  DD 6E 7F
 ld a, (ix + -128)      ;; 07FE:  DD 7E 80
 ld a, (ix + 0)         ;; 0801:  DD 7E 00
 ld a, (ix + 127)       ;; 0804:  DD 7E 7F
 ld b, (iy + -128)      ;; 0807:  FD 46 80
 ld b, (iy + 0)         ;; 080A:  FD 46 00
 ld b, (iy + 127)       ;; 080D:  FD 46 7F
 ld c, (iy + -128)      ;; 0810:  FD 4E 80
 ld c, (iy + 0)         ;; 0813:  FD 4E 00
 ld c, (iy + 127)       ;; 0816:  FD 4E 7F
 ld d, (iy + -128)      ;; 0819:  FD 56 80
 ld d, (iy + 0)         ;; 081C:  FD 56 00
 ld d, (iy + 127)       ;; 081F:  FD 56 7F
 ld e, (iy + -128)      ;; 0822:  FD 5E 80
 ld e, (iy + 0)         ;; 0825:  FD 5E 00
 ld e, (iy + 127)       ;; 0828:  FD 5E 7F
 ld h, (iy + -128)      ;; 082B:  FD 66 80
 ld h, (iy + 0)         ;; 082E:  FD 66 00
 ld h, (iy + 127)       ;; 0831:  FD 66 7F
 ld l, (iy + -128)      ;; 0834:  FD 6E 80
 ld l, (iy + 0)         ;; 0837:  FD 6E 00
 ld l, (iy + 127)       ;; 083A:  FD 6E 7F
 ld a, (iy + -128)      ;; 083D:  FD 7E 80
 ld a, (iy + 0)         ;; 0840:  FD 7E 00
 ld a, (iy + 127)       ;; 0843:  FD 7E 7F
 ld (hl), b             ;; 0846:  70
 ld (hl), c             ;; 0847:  71
 ld (hl), d             ;; 0848:  72
 ld (hl), e             ;; 0849:  73
 ld (hl), h             ;; 084A:  74
 ld (hl), l             ;; 084B:  75
 ld (hl), a             ;; 084C:  77
 ld (ix + -128), b      ;; 084D:  DD 70 80
 ld (ix + 0), b         ;; 0850:  DD 70 00
 ld (ix + 127), b       ;; 0853:  DD 70 7F
 ld (ix + -128), c      ;; 0856:  DD 71 80
 ld (ix + 0), c         ;; 0859:  DD 71 00
 ld (ix + 127), c       ;; 085C:  DD 71 7F
 ld (ix + -128), d      ;; 085F:  DD 72 80
 ld (ix + 0), d         ;; 0862:  DD 72 00
 ld (ix + 127), d       ;; 0865:  DD 72 7F
 ld (ix + -128), e      ;; 0868:  DD 73 80
 ld (ix + 0), e         ;; 086B:  DD 73 00
 ld (ix + 127), e       ;; 086E:  DD 73 7F
 ld (ix + -128), h      ;; 0871:  DD 74 80
 ld (ix + 0), h         ;; 0874:  DD 74 00
 ld (ix + 127), h       ;; 0877:  DD 74 7F
 ld (ix + -128), l      ;; 087A:  DD 75 80
 ld (ix + 0), l         ;; 087D:  DD 75 00
 ld (ix + 127), l       ;; 0880:  DD 75 7F
 ld (ix + -128), a      ;; 0883:  DD 77 80
 ld (ix + 0), a         ;; 0886:  DD 77 00
 ld (ix + 127), a       ;; 0889:  DD 77 7F
 ld (iy + -128), b      ;; 088C:  FD 70 80
 ld (iy + 0), b         ;; 088F:  FD 70 00
 ld (iy + 127), b       ;; 0892:  FD 70 7F
 ld (iy + -128), c      ;; 0895:  FD 71 80
 ld (iy + 0), c         ;; 0898:  FD 71 00
 ld (iy + 127), c       ;; 089B:  FD 71 7F
 ld (iy + -128), d      ;; 089E:  FD 72 80
 ld (iy + 0), d         ;; 08A1:  FD 72 00
 ld (iy + 127), d       ;; 08A4:  FD 72 7F
 ld (iy + -128), e      ;; 08A7:  FD 73 80
 ld (iy + 0), e         ;; 08AA:  FD 73 00
 ld (iy + 127), e       ;; 08AD:  FD 73 7F
 ld (iy + -128), h      ;; 08B0:  FD 74 80
 ld (iy + 0), h         ;; 08B3:  FD 74 00
 ld (iy + 127), h       ;; 08B6:  FD 74 7F
 ld (iy + -128), l      ;; 08B9:  FD 75 80
 ld (iy + 0), l         ;; 08BC:  FD 75 00
 ld (iy + 127), l       ;; 08BF:  FD 75 7F
 ld (iy + -128), a      ;; 08C2:  FD 77 80
 ld (iy + 0), a         ;; 08C5:  FD 77 00
 ld (iy + 127), a       ;; 08C8:  FD 77 7F
 ld (hl), 0             ;; 08CB:  36 00
 ld (hl), 85            ;; 08CD:  36 55
 ld (hl), 170           ;; 08CF:  36 AA
 ld (hl), 255           ;; 08D1:  36 FF
 ld (ix + -128), 0      ;; 08D3:  DD 36 80 00
 ld (ix + 0), 0         ;; 08D7:  DD 36 00 00
 ld (ix + 127), 0       ;; 08DB:  DD 36 7F 00
 ld (ix + -128), 85     ;; 08DF:  DD 36 80 55
 ld (ix + 0), 85        ;; 08E3:  DD 36 00 55
 ld (ix + 127), 85      ;; 08E7:  DD 36 7F 55
 ld (ix + -128), 170    ;; 08EB:  DD 36 80 AA
 ld (ix + 0), 170       ;; 08EF:  DD 36 00 AA
 ld (ix + 127), 170     ;; 08F3:  DD 36 7F AA
 ld (ix + -128), 255    ;; 08F7:  DD 36 80 FF
 ld (ix + 0), 255       ;; 08FB:  DD 36 00 FF
 ld (ix + 127), 255     ;; 08FF:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0903:  FD 36 80 00
 ld (iy + 0), 0         ;; 0907:  FD 36 00 00
 ld (iy + 127), 0       ;; 090B:  FD 36 7F 00
 ld (iy + -128), 85     ;; 090F:  FD 36 80 55
 ld (iy + 0), 85        ;; 0913:  FD 36 00 55
 ld (iy + 127), 85      ;; 0917:  FD 36 7F 55
 ld (iy + -128), 170    ;; 091B:  FD 36 80 AA
 ld (iy + 0), 170       ;; 091F:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0923:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0927:  FD 36 80 FF
 ld (iy + 0), 255       ;; 092B:  FD 36 00 FF
 ld (iy + 127), 255     ;; 092F:  FD 36 7F FF
 ld a, (bc)             ;; 0933:  0A
 ld a, (de)             ;; 0934:  1A
 ld (bc), a             ;; 0935:  02
 ld (de), a             ;; 0936:  12
 ld a, (0)              ;; 0937:  3A 00 00
 ld a, (291)            ;; 093A:  3A 23 01
 ld a, (17767)          ;; 093D:  3A 67 45
 ld a, (35243)          ;; 0940:  3A AB 89
 ld a, (52719)          ;; 0943:  3A EF CD
 ld a, (65535)          ;; 0946:  3A FF FF
 ld (0), a              ;; 0949:  32 00 00
 ld (291), a            ;; 094C:  32 23 01
 ld (17767), a          ;; 094F:  32 67 45
 ld (35243), a          ;; 0952:  32 AB 89
 ld (52719), a          ;; 0955:  32 EF CD
 ld (65535), a          ;; 0958:  32 FF FF
 ld bc, 0               ;; 095B:  01 00 00
 ld bc, 291             ;; 095E:  01 23 01
 ld bc, 17767           ;; 0961:  01 67 45
 ld bc, 35243           ;; 0964:  01 AB 89
 ld bc, 52719           ;; 0967:  01 EF CD
 ld bc, 65535           ;; 096A:  01 FF FF
 ld de, 0               ;; 096D:  11 00 00
 ld de, 291             ;; 0970:  11 23 01
 ld de, 17767           ;; 0973:  11 67 45
 ld de, 35243           ;; 0976:  11 AB 89
 ld de, 52719           ;; 0979:  11 EF CD
 ld de, 65535           ;; 097C:  11 FF FF
 ld hl, 0               ;; 097F:  21 00 00
 ld hl, 291             ;; 0982:  21 23 01
 ld hl, 17767           ;; 0985:  21 67 45
 ld hl, 35243           ;; 0988:  21 AB 89
 ld hl, 52719           ;; 098B:  21 EF CD
 ld hl, 65535           ;; 098E:  21 FF FF
 ld sp, 0               ;; 0991:  31 00 00
 ld sp, 291             ;; 0994:  31 23 01
 ld sp, 17767           ;; 0997:  31 67 45
 ld sp, 35243           ;; 099A:  31 AB 89
 ld sp, 52719           ;; 099D:  31 EF CD
 ld sp, 65535           ;; 09A0:  31 FF FF
 ld ix, 0               ;; 09A3:  DD 21 00 00
 ld ix, 291             ;; 09A7:  DD 21 23 01
 ld ix, 17767           ;; 09AB:  DD 21 67 45
 ld ix, 35243           ;; 09AF:  DD 21 AB 89
 ld ix, 52719           ;; 09B3:  DD 21 EF CD
 ld ix, 65535           ;; 09B7:  DD 21 FF FF
 ld iy, 0               ;; 09BB:  FD 21 00 00
 ld iy, 291             ;; 09BF:  FD 21 23 01
 ld iy, 17767           ;; 09C3:  FD 21 67 45
 ld iy, 35243           ;; 09C7:  FD 21 AB 89
 ld iy, 52719           ;; 09CB:  FD 21 EF CD
 ld iy, 65535           ;; 09CF:  FD 21 FF FF
 ld hl, (0)             ;; 09D3:  2A 00 00
 ld hl, (291)           ;; 09D6:  2A 23 01
 ld hl, (17767)         ;; 09D9:  2A 67 45
 ld hl, (35243)         ;; 09DC:  2A AB 89
 ld hl, (52719)         ;; 09DF:  2A EF CD
 ld hl, (65535)         ;; 09E2:  2A FF FF
 ld ix, (0)             ;; 09E5:  DD 2A 00 00
 ld ix, (291)           ;; 09E9:  DD 2A 23 01
 ld ix, (17767)         ;; 09ED:  DD 2A 67 45
 ld ix, (35243)         ;; 09F1:  DD 2A AB 89
 ld ix, (52719)         ;; 09F5:  DD 2A EF CD
 ld ix, (65535)         ;; 09F9:  DD 2A FF FF
 ld iy, (0)             ;; 09FD:  FD 2A 00 00
 ld iy, (291)           ;; 0A01:  FD 2A 23 01
 ld iy, (17767)         ;; 0A05:  FD 2A 67 45
 ld iy, (35243)         ;; 0A09:  FD 2A AB 89
 ld iy, (52719)         ;; 0A0D:  FD 2A EF CD
 ld iy, (65535)         ;; 0A11:  FD 2A FF FF
 ld (0), hl             ;; 0A15:  22 00 00
 ld (291), hl           ;; 0A18:  22 23 01
 ld (17767), hl         ;; 0A1B:  22 67 45
 ld (35243), hl         ;; 0A1E:  22 AB 89
 ld (52719), hl         ;; 0A21:  22 EF CD
 ld (65535), hl         ;; 0A24:  22 FF FF
 ld (0), ix             ;; 0A27:  DD 22 00 00
 ld (291), ix           ;; 0A2B:  DD 22 23 01
 ld (17767), ix         ;; 0A2F:  DD 22 67 45
 ld (35243), ix         ;; 0A33:  DD 22 AB 89
 ld (52719), ix         ;; 0A37:  DD 22 EF CD
 ld (65535), ix         ;; 0A3B:  DD 22 FF FF
 ld (0), iy             ;; 0A3F:  FD 22 00 00
 ld (291), iy           ;; 0A43:  FD 22 23 01
 ld (17767), iy         ;; 0A47:  FD 22 67 45
 ld (35243), iy         ;; 0A4B:  FD 22 AB 89
 ld (52719), iy         ;; 0A4F:  FD 22 EF CD
 ld (65535), iy         ;; 0A53:  FD 22 FF FF
 LD bc, (0)             ;; 0A57:  ED 4B 00 00
 LD bc, (291)           ;; 0A5B:  ED 4B 23 01
 LD bc, (17767)         ;; 0A5F:  ED 4B 67 45
 LD bc, (35243)         ;; 0A63:  ED 4B AB 89
 LD bc, (52719)         ;; 0A67:  ED 4B EF CD
 LD bc, (65535)         ;; 0A6B:  ED 4B FF FF
 LD de, (0)             ;; 0A6F:  ED 5B 00 00
 LD de, (291)           ;; 0A73:  ED 5B 23 01
 LD de, (17767)         ;; 0A77:  ED 5B 67 45
 LD de, (35243)         ;; 0A7B:  ED 5B AB 89
 LD de, (52719)         ;; 0A7F:  ED 5B EF CD
 LD de, (65535)         ;; 0A83:  ED 5B FF FF
 LD sp, (0)             ;; 0A87:  ED 7B 00 00
 LD sp, (291)           ;; 0A8B:  ED 7B 23 01
 LD sp, (17767)         ;; 0A8F:  ED 7B 67 45
 LD sp, (35243)         ;; 0A93:  ED 7B AB 89
 LD sp, (52719)         ;; 0A97:  ED 7B EF CD
 LD sp, (65535)         ;; 0A9B:  ED 7B FF FF
 LD (0), bc             ;; 0A9F:  ED 43 00 00
 LD (291), bc           ;; 0AA3:  ED 43 23 01
 LD (17767), bc         ;; 0AA7:  ED 43 67 45
 LD (35243), bc         ;; 0AAB:  ED 43 AB 89
 LD (52719), bc         ;; 0AAF:  ED 43 EF CD
 LD (65535), bc         ;; 0AB3:  ED 43 FF FF
 LD (0), de             ;; 0AB7:  ED 53 00 00
 LD (291), de           ;; 0ABB:  ED 53 23 01
 LD (17767), de         ;; 0ABF:  ED 53 67 45
 LD (35243), de         ;; 0AC3:  ED 53 AB 89
 LD (52719), de         ;; 0AC7:  ED 53 EF CD
 LD (65535), de         ;; 0ACB:  ED 53 FF FF
 LD (0), sp             ;; 0ACF:  ED 73 00 00
 LD (291), sp           ;; 0AD3:  ED 73 23 01
 LD (17767), sp         ;; 0AD7:  ED 73 67 45
 LD (35243), sp         ;; 0ADB:  ED 73 AB 89
 LD (52719), sp         ;; 0ADF:  ED 73 EF CD
 LD (65535), sp         ;; 0AE3:  ED 73 FF FF
 ld sp, hl              ;; 0AE7:  F9
 ld sp, ix              ;; 0AE8:  DD F9
 ld sp, iy              ;; 0AEA:  FD F9
 push bc                ;; 0AEC:  C5
 push de                ;; 0AED:  D5
 push hl                ;; 0AEE:  E5
 push af                ;; 0AEF:  F5
 push ix                ;; 0AF0:  DD E5
 push iy                ;; 0AF2:  FD E5
 pop bc                 ;; 0AF4:  C1
 pop de                 ;; 0AF5:  D1
 pop hl                 ;; 0AF6:  E1
 pop af                 ;; 0AF7:  F1
 pop ix                 ;; 0AF8:  DD E1
 pop iy                 ;; 0AFA:  FD E1
 ld (hl + -128), hl     ;; 0AFC:  DD F4 80
 ld (hl + 0), hl        ;; 0AFF:  DD F4 00
 ld (hl + 127), hl      ;; 0B02:  DD F4 7F
 ld (ix + -128), hl     ;; 0B05:  F4 80
 ld (ix + 0), hl        ;; 0B07:  F4 00
 ld (ix + 127), hl      ;; 0B09:  F4 7F
 ld (iy + -128), hl     ;; 0B0B:  FD F4 80
 ld (iy + 0), hl        ;; 0B0E:  FD F4 00
 ld (iy + 127), hl      ;; 0B11:  FD F4 7F
 ld (sp + 0), hl        ;; 0B14:  D4 00
 ld (sp + 85), hl       ;; 0B16:  D4 55
 ld (sp + 170), hl      ;; 0B18:  D4 AA
 ld (sp + 255), hl      ;; 0B1A:  D4 FF
 ld (sp + 0), ix        ;; 0B1C:  DD D4 00
 ld (sp + 85), ix       ;; 0B1F:  DD D4 55
 ld (sp + 170), ix      ;; 0B22:  DD D4 AA
 ld (sp + 255), ix      ;; 0B25:  DD D4 FF
 ld (sp + 0), iy        ;; 0B28:  FD D4 00
 ld (sp + 85), iy       ;; 0B2B:  FD D4 55
 ld (sp + 170), iy      ;; 0B2E:  FD D4 AA
 ld (sp + 255), iy      ;; 0B31:  FD D4 FF
 ld bc', bc             ;; 0B34:  ED 49
 ld bc', de             ;; 0B36:  ED 41
 ld de', bc             ;; 0B38:  ED 59
 ld de', de             ;; 0B3A:  ED 51
 ld hl', bc             ;; 0B3C:  ED 69
 ld hl', de             ;; 0B3E:  ED 61
 ex af, af              ;; 0B40:  08
 ex af, af'             ;; 0B41:  08
 exx                    ;; 0B42:  D9
 ex (sp), hl            ;; 0B43:  ED 54
 ex (sp), ix            ;; 0B45:  DD E3
 ex (sp), iy            ;; 0B47:  FD E3
 ex de, hl              ;; 0B49:  EB
 ex de', hl             ;; 0B4A:  E3
 ex de, hl'             ;; 0B4B:  76 EB
 ex de', hl'            ;; 0B4D:  76 E3
 ldi                    ;; 0B4F:  ED A0
 ldir                   ;; 0B51:  ED B0
 ldd                    ;; 0B53:  ED A8
 lddr                   ;; 0B55:  ED B8
