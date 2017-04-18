 LD B, B                ;; 0000:  40
 LD B, C                ;; 0001:  41
 LD B, D                ;; 0002:  42
 LD B, E                ;; 0003:  43
 LD B, H                ;; 0004:  44
 LD B, L                ;; 0005:  45
 LD B, A                ;; 0006:  47
 LD C, B                ;; 0007:  48
 LD C, C                ;; 0008:  49
 LD C, D                ;; 0009:  4A
 LD C, E                ;; 000A:  4B
 LD C, H                ;; 000B:  4C
 LD C, L                ;; 000C:  4D
 LD C, A                ;; 000D:  4F
 LD D, B                ;; 000E:  50
 LD D, C                ;; 000F:  51
 LD D, D                ;; 0010:  52
 LD D, E                ;; 0011:  53
 LD D, H                ;; 0012:  54
 LD D, L                ;; 0013:  55
 LD D, A                ;; 0014:  57
 LD E, B                ;; 0015:  58
 LD E, C                ;; 0016:  59
 LD E, D                ;; 0017:  5A
 LD E, E                ;; 0018:  5B
 LD E, H                ;; 0019:  5C
 LD E, L                ;; 001A:  5D
 LD E, A                ;; 001B:  5F
 LD H, B                ;; 001C:  60
 LD H, C                ;; 001D:  61
 LD H, D                ;; 001E:  62
 LD H, E                ;; 001F:  63
 LD H, H                ;; 0020:  64
 LD H, L                ;; 0021:  65
 LD H, A                ;; 0022:  67
 LD L, B                ;; 0023:  68
 LD L, C                ;; 0024:  69
 LD L, D                ;; 0025:  6A
 LD L, E                ;; 0026:  6B
 LD L, H                ;; 0027:  6C
 LD L, L                ;; 0028:  6D
 LD L, A                ;; 0029:  6F
 LD A, B                ;; 002A:  78
 LD A, C                ;; 002B:  79
 LD A, D                ;; 002C:  7A
 LD A, E                ;; 002D:  7B
 LD A, H                ;; 002E:  7C
 LD A, L                ;; 002F:  7D
 LD A, A                ;; 0030:  7F
 LD B, 0                ;; 0031:  06 00
 LD B, 85               ;; 0033:  06 55
 LD B, 170              ;; 0035:  06 AA
 LD B, 255              ;; 0037:  06 FF
 LD C, 0                ;; 0039:  0E 00
 LD C, 85               ;; 003B:  0E 55
 LD C, 170              ;; 003D:  0E AA
 LD C, 255              ;; 003F:  0E FF
 LD D, 0                ;; 0041:  16 00
 LD D, 85               ;; 0043:  16 55
 LD D, 170              ;; 0045:  16 AA
 LD D, 255              ;; 0047:  16 FF
 LD E, 0                ;; 0049:  1E 00
 LD E, 85               ;; 004B:  1E 55
 LD E, 170              ;; 004D:  1E AA
 LD E, 255              ;; 004F:  1E FF
 LD H, 0                ;; 0051:  26 00
 LD H, 85               ;; 0053:  26 55
 LD H, 170              ;; 0055:  26 AA
 LD H, 255              ;; 0057:  26 FF
 LD L, 0                ;; 0059:  2E 00
 LD L, 85               ;; 005B:  2E 55
 LD L, 170              ;; 005D:  2E AA
 LD L, 255              ;; 005F:  2E FF
 LD A, 0                ;; 0061:  3E 00
 LD A, 85               ;; 0063:  3E 55
 LD A, 170              ;; 0065:  3E AA
 LD A, 255              ;; 0067:  3E FF
 LD B, (HL)             ;; 0069:  46
 LD C, (HL)             ;; 006A:  4E
 LD D, (HL)             ;; 006B:  56
 LD E, (HL)             ;; 006C:  5E
 LD H, (HL)             ;; 006D:  66
 LD L, (HL)             ;; 006E:  6E
 LD A, (HL)             ;; 006F:  7E
 LD B, (IX + -128)      ;; 0070:  DD 46 80
 LD B, (IX + 0)         ;; 0073:  DD 46 00
 LD B, (IX + 127)       ;; 0076:  DD 46 7F
 LD B, (IY + -128)      ;; 0079:  FD 46 80
 LD B, (IY + 0)         ;; 007C:  FD 46 00
 LD B, (IY + 127)       ;; 007F:  FD 46 7F
 LD C, (IX + -128)      ;; 0082:  DD 4E 80
 LD C, (IX + 0)         ;; 0085:  DD 4E 00
 LD C, (IX + 127)       ;; 0088:  DD 4E 7F
 LD C, (IY + -128)      ;; 008B:  FD 4E 80
 LD C, (IY + 0)         ;; 008E:  FD 4E 00
 LD C, (IY + 127)       ;; 0091:  FD 4E 7F
 LD D, (IX + -128)      ;; 0094:  DD 56 80
 LD D, (IX + 0)         ;; 0097:  DD 56 00
 LD D, (IX + 127)       ;; 009A:  DD 56 7F
 LD D, (IY + -128)      ;; 009D:  FD 56 80
 LD D, (IY + 0)         ;; 00A0:  FD 56 00
 LD D, (IY + 127)       ;; 00A3:  FD 56 7F
 LD E, (IX + -128)      ;; 00A6:  DD 5E 80
 LD E, (IX + 0)         ;; 00A9:  DD 5E 00
 LD E, (IX + 127)       ;; 00AC:  DD 5E 7F
 LD E, (IY + -128)      ;; 00AF:  FD 5E 80
 LD E, (IY + 0)         ;; 00B2:  FD 5E 00
 LD E, (IY + 127)       ;; 00B5:  FD 5E 7F
 LD H, (IX + -128)      ;; 00B8:  DD 66 80
 LD H, (IX + 0)         ;; 00BB:  DD 66 00
 LD H, (IX + 127)       ;; 00BE:  DD 66 7F
 LD H, (IY + -128)      ;; 00C1:  FD 66 80
 LD H, (IY + 0)         ;; 00C4:  FD 66 00
 LD H, (IY + 127)       ;; 00C7:  FD 66 7F
 LD L, (IX + -128)      ;; 00CA:  DD 6E 80
 LD L, (IX + 0)         ;; 00CD:  DD 6E 00
 LD L, (IX + 127)       ;; 00D0:  DD 6E 7F
 LD L, (IY + -128)      ;; 00D3:  FD 6E 80
 LD L, (IY + 0)         ;; 00D6:  FD 6E 00
 LD L, (IY + 127)       ;; 00D9:  FD 6E 7F
 LD A, (IX + -128)      ;; 00DC:  DD 7E 80
 LD A, (IX + 0)         ;; 00DF:  DD 7E 00
 LD A, (IX + 127)       ;; 00E2:  DD 7E 7F
 LD A, (IY + -128)      ;; 00E5:  FD 7E 80
 LD A, (IY + 0)         ;; 00E8:  FD 7E 00
 LD A, (IY + 127)       ;; 00EB:  FD 7E 7F
 LD (HL), B             ;; 00EE:  70
 LD (HL), C             ;; 00EF:  71
 LD (HL), D             ;; 00F0:  72
 LD (HL), E             ;; 00F1:  73
 LD (HL), H             ;; 00F2:  74
 LD (HL), L             ;; 00F3:  75
 LD (HL), A             ;; 00F4:  77
 LD (IX + -128), B      ;; 00F5:  DD 70 80
 LD (IX + 0), B         ;; 00F8:  DD 70 00
 LD (IX + 127), B       ;; 00FB:  DD 70 7F
 LD (IY + -128), B      ;; 00FE:  FD 70 80
 LD (IY + 0), B         ;; 0101:  FD 70 00
 LD (IY + 127), B       ;; 0104:  FD 70 7F
 LD (IX + -128), C      ;; 0107:  DD 71 80
 LD (IX + 0), C         ;; 010A:  DD 71 00
 LD (IX + 127), C       ;; 010D:  DD 71 7F
 LD (IY + -128), C      ;; 0110:  FD 71 80
 LD (IY + 0), C         ;; 0113:  FD 71 00
 LD (IY + 127), C       ;; 0116:  FD 71 7F
 LD (IX + -128), D      ;; 0119:  DD 72 80
 LD (IX + 0), D         ;; 011C:  DD 72 00
 LD (IX + 127), D       ;; 011F:  DD 72 7F
 LD (IY + -128), D      ;; 0122:  FD 72 80
 LD (IY + 0), D         ;; 0125:  FD 72 00
 LD (IY + 127), D       ;; 0128:  FD 72 7F
 LD (IX + -128), E      ;; 012B:  DD 73 80
 LD (IX + 0), E         ;; 012E:  DD 73 00
 LD (IX + 127), E       ;; 0131:  DD 73 7F
 LD (IY + -128), E      ;; 0134:  FD 73 80
 LD (IY + 0), E         ;; 0137:  FD 73 00
 LD (IY + 127), E       ;; 013A:  FD 73 7F
 LD (IX + -128), H      ;; 013D:  DD 74 80
 LD (IX + 0), H         ;; 0140:  DD 74 00
 LD (IX + 127), H       ;; 0143:  DD 74 7F
 LD (IY + -128), H      ;; 0146:  FD 74 80
 LD (IY + 0), H         ;; 0149:  FD 74 00
 LD (IY + 127), H       ;; 014C:  FD 74 7F
 LD (IX + -128), L      ;; 014F:  DD 75 80
 LD (IX + 0), L         ;; 0152:  DD 75 00
 LD (IX + 127), L       ;; 0155:  DD 75 7F
 LD (IY + -128), L      ;; 0158:  FD 75 80
 LD (IY + 0), L         ;; 015B:  FD 75 00
 LD (IY + 127), L       ;; 015E:  FD 75 7F
 LD (IX + -128), A      ;; 0161:  DD 77 80
 LD (IX + 0), A         ;; 0164:  DD 77 00
 LD (IX + 127), A       ;; 0167:  DD 77 7F
 LD (IY + -128), A      ;; 016A:  FD 77 80
 LD (IY + 0), A         ;; 016D:  FD 77 00
 LD (IY + 127), A       ;; 0170:  FD 77 7F
 LD (HL), 0             ;; 0173:  36 00
 LD (HL), 85            ;; 0175:  36 55
 LD (HL), 170           ;; 0177:  36 AA
 LD (HL), 255           ;; 0179:  36 FF
 LD (IX + -128), 0      ;; 017B:  DD 36 80 00
 LD (IX + 0), 0         ;; 017F:  DD 36 00 00
 LD (IX + 127), 0       ;; 0183:  DD 36 7F 00
 LD (IX + -128), 85     ;; 0187:  DD 36 80 55
 LD (IX + 0), 85        ;; 018B:  DD 36 00 55
 LD (IX + 127), 85      ;; 018F:  DD 36 7F 55
 LD (IX + -128), 170    ;; 0193:  DD 36 80 AA
 LD (IX + 0), 170       ;; 0197:  DD 36 00 AA
 LD (IX + 127), 170     ;; 019B:  DD 36 7F AA
 LD (IX + -128), 255    ;; 019F:  DD 36 80 FF
 LD (IX + 0), 255       ;; 01A3:  DD 36 00 FF
 LD (IX + 127), 255     ;; 01A7:  DD 36 7F FF
 LD (IY + -128), 0      ;; 01AB:  FD 36 80 00
 LD (IY + 0), 0         ;; 01AF:  FD 36 00 00
 LD (IY + 127), 0       ;; 01B3:  FD 36 7F 00
 LD (IY + -128), 85     ;; 01B7:  FD 36 80 55
 LD (IY + 0), 85        ;; 01BB:  FD 36 00 55
 LD (IY + 127), 85      ;; 01BF:  FD 36 7F 55
 LD (IY + -128), 170    ;; 01C3:  FD 36 80 AA
 LD (IY + 0), 170       ;; 01C7:  FD 36 00 AA
 LD (IY + 127), 170     ;; 01CB:  FD 36 7F AA
 LD (IY + -128), 255    ;; 01CF:  FD 36 80 FF
 LD (IY + 0), 255       ;; 01D3:  FD 36 00 FF
 LD (IY + 127), 255     ;; 01D7:  FD 36 7F FF
 LD A, (BC)             ;; 01DB:  0A
 LD A, (DE)             ;; 01DC:  1A
 LD A, (0)              ;; 01DD:  3A 00 00
 LD A, (4660)           ;; 01E0:  3A 34 12
 LD A, (52719)          ;; 01E3:  3A EF CD
 LD A, (65535)          ;; 01E6:  3A FF FF
 LD (BC), A             ;; 01E9:  02
 LD (DE), A             ;; 01EA:  12
 LD (0), A              ;; 01EB:  32 00 00
 LD (4660), A           ;; 01EE:  32 34 12
 LD (52719), A          ;; 01F1:  32 EF CD
 LD (65535), A          ;; 01F4:  32 FF FF
 LD BC, 0               ;; 01F7:  01 00 00
 LD BC, 4660            ;; 01FA:  01 34 12
 LD BC, 52719           ;; 01FD:  01 EF CD
 LD BC, 65535           ;; 0200:  01 FF FF
 LD DE, 0               ;; 0203:  11 00 00
 LD DE, 4660            ;; 0206:  11 34 12
 LD DE, 52719           ;; 0209:  11 EF CD
 LD DE, 65535           ;; 020C:  11 FF FF
 LD HL, 0               ;; 020F:  21 00 00
 LD HL, 4660            ;; 0212:  21 34 12
 LD HL, 52719           ;; 0215:  21 EF CD
 LD HL, 65535           ;; 0218:  21 FF FF
 LD SP, 0               ;; 021B:  31 00 00
 LD SP, 4660            ;; 021E:  31 34 12
 LD SP, 52719           ;; 0221:  31 EF CD
 LD SP, 65535           ;; 0224:  31 FF FF
 LD IX, 0               ;; 0227:  DD 21 00 00
 LD IX, 4660            ;; 022B:  DD 21 34 12
 LD IX, 52719           ;; 022F:  DD 21 EF CD
 LD IX, 65535           ;; 0233:  DD 21 FF FF
 LD IY, 0               ;; 0237:  FD 21 00 00
 LD IY, 4660            ;; 023B:  FD 21 34 12
 LD IY, 52719           ;; 023F:  FD 21 EF CD
 LD IY, 65535           ;; 0243:  FD 21 FF FF
 LD HL, (0)             ;; 0247:  2A 00 00
 LD HL, (4660)          ;; 024A:  2A 34 12
 LD HL, (52719)         ;; 024D:  2A EF CD
 LD HL, (65535)         ;; 0250:  2A FF FF
 LD IX, (0)             ;; 0253:  DD 2A 00 00
 LD IX, (4660)          ;; 0257:  DD 2A 34 12
 LD IX, (52719)         ;; 025B:  DD 2A EF CD
 LD IX, (65535)         ;; 025F:  DD 2A FF FF
 LD IY, (0)             ;; 0263:  FD 2A 00 00
 LD IY, (4660)          ;; 0267:  FD 2A 34 12
 LD IY, (52719)         ;; 026B:  FD 2A EF CD
 LD IY, (65535)         ;; 026F:  FD 2A FF FF
 LD BC, (0)             ;; 0273:  ED 4B 00 00
 LD BC, (4660)          ;; 0277:  ED 4B 34 12
 LD BC, (52719)         ;; 027B:  ED 4B EF CD
 LD BC, (65535)         ;; 027F:  ED 4B FF FF
 LD DE, (0)             ;; 0283:  ED 5B 00 00
 LD DE, (4660)          ;; 0287:  ED 5B 34 12
 LD DE, (52719)         ;; 028B:  ED 5B EF CD
 LD DE, (65535)         ;; 028F:  ED 5B FF FF
 LD SP, (0)             ;; 0293:  ED 7B 00 00
 LD SP, (4660)          ;; 0297:  ED 7B 34 12
 LD SP, (52719)         ;; 029B:  ED 7B EF CD
 LD SP, (65535)         ;; 029F:  ED 7B FF FF
 LD (0), HL             ;; 02A3:  22 00 00
 LD (4660), HL          ;; 02A6:  22 34 12
 LD (52719), HL         ;; 02A9:  22 EF CD
 LD (65535), HL         ;; 02AC:  22 FF FF
 LD (0), IX             ;; 02AF:  DD 22 00 00
 LD (4660), IX          ;; 02B3:  DD 22 34 12
 LD (52719), IX         ;; 02B7:  DD 22 EF CD
 LD (65535), IX         ;; 02BB:  DD 22 FF FF
 LD (0), IY             ;; 02BF:  FD 22 00 00
 LD (4660), IY          ;; 02C3:  FD 22 34 12
 LD (52719), IY         ;; 02C7:  FD 22 EF CD
 LD (65535), IY         ;; 02CB:  FD 22 FF FF
 LD (0), BC             ;; 02CF:  ED 43 00 00
 LD (4660), BC          ;; 02D3:  ED 43 34 12
 LD (52719), BC         ;; 02D7:  ED 43 EF CD
 LD (65535), BC         ;; 02DB:  ED 43 FF FF
 LD (0), DE             ;; 02DF:  ED 53 00 00
 LD (4660), DE          ;; 02E3:  ED 53 34 12
 LD (52719), DE         ;; 02E7:  ED 53 EF CD
 LD (65535), DE         ;; 02EB:  ED 53 FF FF
 LD (0), SP             ;; 02EF:  ED 73 00 00
 LD (4660), SP          ;; 02F3:  ED 73 34 12
 LD (52719), SP         ;; 02F7:  ED 73 EF CD
 LD (65535), SP         ;; 02FB:  ED 73 FF FF
 LD SP, HL              ;; 02FF:  F9
 LD SP, IX              ;; 0300:  DD F9
 LD SP, IY              ;; 0302:  FD F9
 PUSH BC                ;; 0304:  C5
 PUSH DE                ;; 0305:  D5
 PUSH HL                ;; 0306:  E5
 PUSH AF                ;; 0307:  F5
 PUSH IX                ;; 0308:  DD E5
 PUSH IY                ;; 030A:  FD E5
 POP BC                 ;; 030C:  C1
 POP DE                 ;; 030D:  D1
 POP HL                 ;; 030E:  E1
 POP AF                 ;; 030F:  F1
 POP IX                 ;; 0310:  DD E1
 POP IY                 ;; 0312:  FD E1
 EX DE, HL              ;; 0314:  EB
 EX AF, AF'             ;; 0315:  08
 EXX                    ;; 0316:  D9
 EX (SP), HL            ;; 0317:  E3
 EX (SP), IX            ;; 0318:  DD E3
 EX (SP), IY            ;; 031A:  FD E3
 LDI                    ;; 031C:  ED A0
 LDIR                   ;; 031E:  ED B0
 LDD                    ;; 0320:  ED A8
 LDDR                   ;; 0322:  ED B8
 CPI                    ;; 0324:  ED A1
 CPIR                   ;; 0326:  ED B1
 CPD                    ;; 0328:  ED A9
 CPDR                   ;; 032A:  ED B9
 ADD A, B               ;; 032C:  80
 ADC A, B               ;; 032D:  88
 SUB B                  ;; 032E:  90
 SBC A, B               ;; 032F:  98
 AND B                  ;; 0330:  A0
 XOR B                  ;; 0331:  A8
 OR B                   ;; 0332:  B0
 CP B                   ;; 0333:  B8
 ADD A, C               ;; 0334:  81
 ADC A, C               ;; 0335:  89
 SUB C                  ;; 0336:  91
 SBC A, C               ;; 0337:  99
 AND C                  ;; 0338:  A1
 XOR C                  ;; 0339:  A9
 OR C                   ;; 033A:  B1
 CP C                   ;; 033B:  B9
 ADD A, D               ;; 033C:  82
 ADC A, D               ;; 033D:  8A
 SUB D                  ;; 033E:  92
 SBC A, D               ;; 033F:  9A
 AND D                  ;; 0340:  A2
 XOR D                  ;; 0341:  AA
 OR D                   ;; 0342:  B2
 CP D                   ;; 0343:  BA
 ADD A, E               ;; 0344:  83
 ADC A, E               ;; 0345:  8B
 SUB E                  ;; 0346:  93
 SBC A, E               ;; 0347:  9B
 AND E                  ;; 0348:  A3
 XOR E                  ;; 0349:  AB
 OR E                   ;; 034A:  B3
 CP E                   ;; 034B:  BB
 ADD A, H               ;; 034C:  84
 ADC A, H               ;; 034D:  8C
 SUB H                  ;; 034E:  94
 SBC A, H               ;; 034F:  9C
 AND H                  ;; 0350:  A4
 XOR H                  ;; 0351:  AC
 OR H                   ;; 0352:  B4
 CP H                   ;; 0353:  BC
 ADD A, L               ;; 0354:  85
 ADC A, L               ;; 0355:  8D
 SUB L                  ;; 0356:  95
 SBC A, L               ;; 0357:  9D
 AND L                  ;; 0358:  A5
 XOR L                  ;; 0359:  AD
 OR L                   ;; 035A:  B5
 CP L                   ;; 035B:  BD
 ADD A, A               ;; 035C:  87
 ADC A, A               ;; 035D:  8F
 SUB A                  ;; 035E:  97
 SBC A, A               ;; 035F:  9F
 AND A                  ;; 0360:  A7
 XOR A                  ;; 0361:  AF
 OR A                   ;; 0362:  B7
 CP A                   ;; 0363:  BF
 ADD A, 0               ;; 0364:  C6 00
 ADD A, 85              ;; 0366:  C6 55
 ADD A, 170             ;; 0368:  C6 AA
 ADD A, 255             ;; 036A:  C6 FF
 ADC A, 0               ;; 036C:  CE 00
 ADC A, 85              ;; 036E:  CE 55
 ADC A, 170             ;; 0370:  CE AA
 ADC A, 255             ;; 0372:  CE FF
 SUB 0                  ;; 0374:  D6 00
 SUB 85                 ;; 0376:  D6 55
 SUB 170                ;; 0378:  D6 AA
 SUB 255                ;; 037A:  D6 FF
 SBC A, 0               ;; 037C:  DE 00
 SBC A, 85              ;; 037E:  DE 55
 SBC A, 170             ;; 0380:  DE AA
 SBC A, 255             ;; 0382:  DE FF
 AND 0                  ;; 0384:  E6 00
 AND 85                 ;; 0386:  E6 55
 AND 170                ;; 0388:  E6 AA
 AND 255                ;; 038A:  E6 FF
 XOR 0                  ;; 038C:  EE 00
 XOR 85                 ;; 038E:  EE 55
 XOR 170                ;; 0390:  EE AA
 XOR 255                ;; 0392:  EE FF
 OR 0                   ;; 0394:  F6 00
 OR 85                  ;; 0396:  F6 55
 OR 170                 ;; 0398:  F6 AA
 OR 255                 ;; 039A:  F6 FF
 CP 0                   ;; 039C:  FE 00
 CP 85                  ;; 039E:  FE 55
 CP 170                 ;; 03A0:  FE AA
 CP 255                 ;; 03A2:  FE FF
 ADD A, (HL)            ;; 03A4:  86
 ADC A, (HL)            ;; 03A5:  8E
 SUB (HL)               ;; 03A6:  96
 SBC A, (HL)            ;; 03A7:  9E
 AND (HL)               ;; 03A8:  A6
 XOR (HL)               ;; 03A9:  AE
 OR (HL)                ;; 03AA:  B6
 CP (HL)                ;; 03AB:  BE
 ADD A, (IX + -128)     ;; 03AC:  DD 86 80
 ADD A, (IX + 0)        ;; 03AF:  DD 86 00
 ADD A, (IX + 127)      ;; 03B2:  DD 86 7F
 ADC A, (IX + -128)     ;; 03B5:  DD 8E 80
 ADC A, (IX + 0)        ;; 03B8:  DD 8E 00
 ADC A, (IX + 127)      ;; 03BB:  DD 8E 7F
 SUB (IX + -128)        ;; 03BE:  DD 96 80
 SUB (IX + 0)           ;; 03C1:  DD 96 00
 SUB (IX + 127)         ;; 03C4:  DD 96 7F
 SBC A, (IX + -128)     ;; 03C7:  DD 9E 80
 SBC A, (IX + 0)        ;; 03CA:  DD 9E 00
 SBC A, (IX + 127)      ;; 03CD:  DD 9E 7F
 AND (IX + -128)        ;; 03D0:  DD A6 80
 AND (IX + 0)           ;; 03D3:  DD A6 00
 AND (IX + 127)         ;; 03D6:  DD A6 7F
 XOR (IX + -128)        ;; 03D9:  DD AE 80
 XOR (IX + 0)           ;; 03DC:  DD AE 00
 XOR (IX + 127)         ;; 03DF:  DD AE 7F
 OR (IX + -128)         ;; 03E2:  DD B6 80
 OR (IX + 0)            ;; 03E5:  DD B6 00
 OR (IX + 127)          ;; 03E8:  DD B6 7F
 CP (IX + -128)         ;; 03EB:  DD BE 80
 CP (IX + 0)            ;; 03EE:  DD BE 00
 CP (IX + 127)          ;; 03F1:  DD BE 7F
 ADD A, (IY + -128)     ;; 03F4:  FD 86 80
 ADD A, (IY + 0)        ;; 03F7:  FD 86 00
 ADD A, (IY + 127)      ;; 03FA:  FD 86 7F
 ADC A, (IY + -128)     ;; 03FD:  FD 8E 80
 ADC A, (IY + 0)        ;; 0400:  FD 8E 00
 ADC A, (IY + 127)      ;; 0403:  FD 8E 7F
 SUB (IY + -128)        ;; 0406:  FD 96 80
 SUB (IY + 0)           ;; 0409:  FD 96 00
 SUB (IY + 127)         ;; 040C:  FD 96 7F
 SBC A, (IY + -128)     ;; 040F:  FD 9E 80
 SBC A, (IY + 0)        ;; 0412:  FD 9E 00
 SBC A, (IY + 127)      ;; 0415:  FD 9E 7F
 AND (IY + -128)        ;; 0418:  FD A6 80
 AND (IY + 0)           ;; 041B:  FD A6 00
 AND (IY + 127)         ;; 041E:  FD A6 7F
 XOR (IY + -128)        ;; 0421:  FD AE 80
 XOR (IY + 0)           ;; 0424:  FD AE 00
 XOR (IY + 127)         ;; 0427:  FD AE 7F
 OR (IY + -128)         ;; 042A:  FD B6 80
 OR (IY + 0)            ;; 042D:  FD B6 00
 OR (IY + 127)          ;; 0430:  FD B6 7F
 CP (IY + -128)         ;; 0433:  FD BE 80
 CP (IY + 0)            ;; 0436:  FD BE 00
 CP (IY + 127)          ;; 0439:  FD BE 7F
 INC B                  ;; 043C:  04
 INC C                  ;; 043D:  0C
 INC D                  ;; 043E:  14
 INC E                  ;; 043F:  1C
 INC H                  ;; 0440:  24
 INC L                  ;; 0441:  2C
 INC A                  ;; 0442:  3C
 INC (HL)               ;; 0443:  34
 INC (IX + -128)        ;; 0444:  DD 34 80
 INC (IX + 0)           ;; 0447:  DD 34 00
 INC (IX + 127)         ;; 044A:  DD 34 7F
 INC (IY + -128)        ;; 044D:  FD 34 80
 INC (IY + 0)           ;; 0450:  FD 34 00
 INC (IY + 127)         ;; 0453:  FD 34 7F
 DEC B                  ;; 0456:  05
 DEC C                  ;; 0457:  0D
 DEC D                  ;; 0458:  15
 DEC E                  ;; 0459:  1D
 DEC H                  ;; 045A:  25
 DEC L                  ;; 045B:  2D
 DEC A                  ;; 045C:  3D
 DEC (HL)               ;; 045D:  35
 DEC (IX + -128)        ;; 045E:  DD 35 80
 DEC (IX + 0)           ;; 0461:  DD 35 00
 DEC (IX + 127)         ;; 0464:  DD 35 7F
 DEC (IY + -128)        ;; 0467:  FD 35 80
 DEC (IY + 0)           ;; 046A:  FD 35 00
 DEC (IY + 127)         ;; 046D:  FD 35 7F
 TST B                  ;; 0470:  ED 04
 TST C                  ;; 0472:  ED 0C
 TST D                  ;; 0474:  ED 14
 TST E                  ;; 0476:  ED 1C
 TST H                  ;; 0478:  ED 24
 TST L                  ;; 047A:  ED 2C
 TST A                  ;; 047C:  ED 3C
 TST 0                  ;; 047E:  ED 64 00
 TST 85                 ;; 0481:  ED 64 55
 TST 170                ;; 0484:  ED 64 AA
 TST 255                ;; 0487:  ED 64 FF
 TST (HL)               ;; 048A:  ED 34
 DAA                    ;; 048C:  27
 RLD                    ;; 048D:  ED 6F
 RRD                    ;; 048F:  ED 67
 CPL                    ;; 0491:  2F
 NEG                    ;; 0492:  ED 44
 CCF                    ;; 0494:  3F
 SCF                    ;; 0495:  37
 NOP                    ;; 0496:  00
 HALT                   ;; 0497:  76
 SLP                    ;; 0498:  ED 76
 ADD HL, BC             ;; 049A:  09
 ADD HL, DE             ;; 049B:  19
 ADD HL, HL             ;; 049C:  29
 ADD HL, SP             ;; 049D:  39
 ADD IX, BC             ;; 049E:  DD 09
 ADD IY, BC             ;; 04A0:  FD 09
 ADD IX, DE             ;; 04A2:  DD 19
 ADD IY, DE             ;; 04A4:  FD 19
 ADD IX, IX             ;; 04A6:  DD 29
 ADD IY, IY             ;; 04A8:  FD 29
 ADD IX, SP             ;; 04AA:  DD 39
 ADD IY, SP             ;; 04AC:  FD 39
 ADC HL, BC             ;; 04AE:  ED 4A
 ADC HL, DE             ;; 04B0:  ED 5A
 ADC HL, HL             ;; 04B2:  ED 6A
 ADC HL, SP             ;; 04B4:  ED 7A
 SBC HL, BC             ;; 04B6:  ED 42
 SBC HL, DE             ;; 04B8:  ED 52
 SBC HL, HL             ;; 04BA:  ED 62
 SBC HL, SP             ;; 04BC:  ED 72
 INC BC                 ;; 04BE:  03
 INC DE                 ;; 04BF:  13
 INC HL                 ;; 04C0:  23
 INC SP                 ;; 04C1:  33
 INC IX                 ;; 04C2:  DD 23
 INC IY                 ;; 04C4:  FD 23
 DEC BC                 ;; 04C6:  0B
 DEC DE                 ;; 04C7:  1B
 DEC HL                 ;; 04C8:  2B
 DEC SP                 ;; 04C9:  3B
 DEC IX                 ;; 04CA:  DD 2B
 DEC IY                 ;; 04CC:  FD 2B
 MLT BC                 ;; 04CE:  ED 4C
 MLT DE                 ;; 04D0:  ED 5C
 MLT HL                 ;; 04D2:  ED 6C
 MLT SP                 ;; 04D4:  ED 7C
 RLCA                   ;; 04D6:  07
 RRCA                   ;; 04D7:  0F
 RLA                    ;; 04D8:  17
 RRA                    ;; 04D9:  1F
 RLC B                  ;; 04DA:  CB 00
 RRC B                  ;; 04DC:  CB 08
 RL B                   ;; 04DE:  CB 10
 RR B                   ;; 04E0:  CB 18
 SLA B                  ;; 04E2:  CB 20
 SRA B                  ;; 04E4:  CB 28
 SRL B                  ;; 04E6:  CB 38
 RLC C                  ;; 04E8:  CB 01
 RRC C                  ;; 04EA:  CB 09
 RL C                   ;; 04EC:  CB 11
 RR C                   ;; 04EE:  CB 19
 SLA C                  ;; 04F0:  CB 21
 SRA C                  ;; 04F2:  CB 29
 SRL C                  ;; 04F4:  CB 39
 RLC D                  ;; 04F6:  CB 02
 RRC D                  ;; 04F8:  CB 0A
 RL D                   ;; 04FA:  CB 12
 RR D                   ;; 04FC:  CB 1A
 SLA D                  ;; 04FE:  CB 22
 SRA D                  ;; 0500:  CB 2A
 SRL D                  ;; 0502:  CB 3A
 RLC E                  ;; 0504:  CB 03
 RRC E                  ;; 0506:  CB 0B
 RL E                   ;; 0508:  CB 13
 RR E                   ;; 050A:  CB 1B
 SLA E                  ;; 050C:  CB 23
 SRA E                  ;; 050E:  CB 2B
 SRL E                  ;; 0510:  CB 3B
 RLC H                  ;; 0512:  CB 04
 RRC H                  ;; 0514:  CB 0C
 RL H                   ;; 0516:  CB 14
 RR H                   ;; 0518:  CB 1C
 SLA H                  ;; 051A:  CB 24
 SRA H                  ;; 051C:  CB 2C
 SRL H                  ;; 051E:  CB 3C
 RLC L                  ;; 0520:  CB 05
 RRC L                  ;; 0522:  CB 0D
 RL L                   ;; 0524:  CB 15
 RR L                   ;; 0526:  CB 1D
 SLA L                  ;; 0528:  CB 25
 SRA L                  ;; 052A:  CB 2D
 SRL L                  ;; 052C:  CB 3D
 RLC A                  ;; 052E:  CB 07
 RRC A                  ;; 0530:  CB 0F
 RL A                   ;; 0532:  CB 17
 RR A                   ;; 0534:  CB 1F
 SLA A                  ;; 0536:  CB 27
 SRA A                  ;; 0538:  CB 2F
 SRL A                  ;; 053A:  CB 3F
 SLL B                  ;; 053C:  CB 30
 SLL C                  ;; 053E:  CB 31
 SLL D                  ;; 0540:  CB 32
 SLL E                  ;; 0542:  CB 33
 SLL H                  ;; 0544:  CB 34
 SLL L                  ;; 0546:  CB 35
 SLL A                  ;; 0548:  CB 37
 RLC (HL)               ;; 054A:  CB 06
 RRC (HL)               ;; 054C:  CB 0E
 RL (HL)                ;; 054E:  CB 16
 RR (HL)                ;; 0550:  CB 1E
 SLA (HL)               ;; 0552:  CB 26
 SRA (HL)               ;; 0554:  CB 2E
 SRL (HL)               ;; 0556:  CB 3E
 SLL (HL)               ;; 0558:  CB 36
 RLC (IX + -128)        ;; 055A:  DD CB 80 06
 RLC (IX + 0)           ;; 055E:  DD CB 00 06
 RLC (IX + 127)         ;; 0562:  DD CB 7F 06
 RRC (IX + -128)        ;; 0566:  DD CB 80 0E
 RRC (IX + 0)           ;; 056A:  DD CB 00 0E
 RRC (IX + 127)         ;; 056E:  DD CB 7F 0E
 RL (IX + -128)         ;; 0572:  DD CB 80 16
 RL (IX + 0)            ;; 0576:  DD CB 00 16
 RL (IX + 127)          ;; 057A:  DD CB 7F 16
 RR (IX + -128)         ;; 057E:  DD CB 80 1E
 RR (IX + 0)            ;; 0582:  DD CB 00 1E
 RR (IX + 127)          ;; 0586:  DD CB 7F 1E
 SLA (IX + -128)        ;; 058A:  DD CB 80 26
 SLA (IX + 0)           ;; 058E:  DD CB 00 26
 SLA (IX + 127)         ;; 0592:  DD CB 7F 26
 SRA (IX + -128)        ;; 0596:  DD CB 80 2E
 SRA (IX + 0)           ;; 059A:  DD CB 00 2E
 SRA (IX + 127)         ;; 059E:  DD CB 7F 2E
 SRL (IX + -128)        ;; 05A2:  DD CB 80 3E
 SRL (IX + 0)           ;; 05A6:  DD CB 00 3E
 SRL (IX + 127)         ;; 05AA:  DD CB 7F 3E
 RLC (IY + -128)        ;; 05AE:  FD CB 80 06
 RLC (IY + 0)           ;; 05B2:  FD CB 00 06
 RLC (IY + 127)         ;; 05B6:  FD CB 7F 06
 RRC (IY + -128)        ;; 05BA:  FD CB 80 0E
 RRC (IY + 0)           ;; 05BE:  FD CB 00 0E
 RRC (IY + 127)         ;; 05C2:  FD CB 7F 0E
 RL (IY + -128)         ;; 05C6:  FD CB 80 16
 RL (IY + 0)            ;; 05CA:  FD CB 00 16
 RL (IY + 127)          ;; 05CE:  FD CB 7F 16
 RR (IY + -128)         ;; 05D2:  FD CB 80 1E
 RR (IY + 0)            ;; 05D6:  FD CB 00 1E
 RR (IY + 127)          ;; 05DA:  FD CB 7F 1E
 SLA (IY + -128)        ;; 05DE:  FD CB 80 26
 SLA (IY + 0)           ;; 05E2:  FD CB 00 26
 SLA (IY + 127)         ;; 05E6:  FD CB 7F 26
 SRA (IY + -128)        ;; 05EA:  FD CB 80 2E
 SRA (IY + 0)           ;; 05EE:  FD CB 00 2E
 SRA (IY + 127)         ;; 05F2:  FD CB 7F 2E
 SRL (IY + -128)        ;; 05F6:  FD CB 80 3E
 SRL (IY + 0)           ;; 05FA:  FD CB 00 3E
 SRL (IY + 127)         ;; 05FE:  FD CB 7F 3E
 SLL (IX + -128)        ;; 0602:  DD CB 80 36
 SLL (IX + 0)           ;; 0606:  DD CB 00 36
 SLL (IX + 127)         ;; 060A:  DD CB 7F 36
 SLL (IY + -128)        ;; 060E:  FD CB 80 36
 SLL (IY + 0)           ;; 0612:  FD CB 00 36
 SLL (IY + 127)         ;; 0616:  FD CB 7F 36
 BIT 0, B               ;; 061A:  CB 40
 BIT 1, B               ;; 061C:  CB 48
 BIT 2, B               ;; 061E:  CB 50
 BIT 3, B               ;; 0620:  CB 58
 BIT 4, B               ;; 0622:  CB 60
 BIT 5, B               ;; 0624:  CB 68
 BIT 6, B               ;; 0626:  CB 70
 BIT 7, B               ;; 0628:  CB 78
 RES 0, B               ;; 062A:  CB 80
 RES 1, B               ;; 062C:  CB 88
 RES 2, B               ;; 062E:  CB 90
 RES 3, B               ;; 0630:  CB 98
 RES 4, B               ;; 0632:  CB A0
 RES 5, B               ;; 0634:  CB A8
 RES 6, B               ;; 0636:  CB B0
 RES 7, B               ;; 0638:  CB B8
 SET 0, B               ;; 063A:  CB C0
 SET 1, B               ;; 063C:  CB C8
 SET 2, B               ;; 063E:  CB D0
 SET 3, B               ;; 0640:  CB D8
 SET 4, B               ;; 0642:  CB E0
 SET 5, B               ;; 0644:  CB E8
 SET 6, B               ;; 0646:  CB F0
 SET 7, B               ;; 0648:  CB F8
 BIT 0, C               ;; 064A:  CB 41
 BIT 1, C               ;; 064C:  CB 49
 BIT 2, C               ;; 064E:  CB 51
 BIT 3, C               ;; 0650:  CB 59
 BIT 4, C               ;; 0652:  CB 61
 BIT 5, C               ;; 0654:  CB 69
 BIT 6, C               ;; 0656:  CB 71
 BIT 7, C               ;; 0658:  CB 79
 RES 0, C               ;; 065A:  CB 81
 RES 1, C               ;; 065C:  CB 89
 RES 2, C               ;; 065E:  CB 91
 RES 3, C               ;; 0660:  CB 99
 RES 4, C               ;; 0662:  CB A1
 RES 5, C               ;; 0664:  CB A9
 RES 6, C               ;; 0666:  CB B1
 RES 7, C               ;; 0668:  CB B9
 SET 0, C               ;; 066A:  CB C1
 SET 1, C               ;; 066C:  CB C9
 SET 2, C               ;; 066E:  CB D1
 SET 3, C               ;; 0670:  CB D9
 SET 4, C               ;; 0672:  CB E1
 SET 5, C               ;; 0674:  CB E9
 SET 6, C               ;; 0676:  CB F1
 SET 7, C               ;; 0678:  CB F9
 BIT 0, D               ;; 067A:  CB 42
 BIT 1, D               ;; 067C:  CB 4A
 BIT 2, D               ;; 067E:  CB 52
 BIT 3, D               ;; 0680:  CB 5A
 BIT 4, D               ;; 0682:  CB 62
 BIT 5, D               ;; 0684:  CB 6A
 BIT 6, D               ;; 0686:  CB 72
 BIT 7, D               ;; 0688:  CB 7A
 RES 0, D               ;; 068A:  CB 82
 RES 1, D               ;; 068C:  CB 8A
 RES 2, D               ;; 068E:  CB 92
 RES 3, D               ;; 0690:  CB 9A
 RES 4, D               ;; 0692:  CB A2
 RES 5, D               ;; 0694:  CB AA
 RES 6, D               ;; 0696:  CB B2
 RES 7, D               ;; 0698:  CB BA
 SET 0, D               ;; 069A:  CB C2
 SET 1, D               ;; 069C:  CB CA
 SET 2, D               ;; 069E:  CB D2
 SET 3, D               ;; 06A0:  CB DA
 SET 4, D               ;; 06A2:  CB E2
 SET 5, D               ;; 06A4:  CB EA
 SET 6, D               ;; 06A6:  CB F2
 SET 7, D               ;; 06A8:  CB FA
 BIT 0, E               ;; 06AA:  CB 43
 BIT 1, E               ;; 06AC:  CB 4B
 BIT 2, E               ;; 06AE:  CB 53
 BIT 3, E               ;; 06B0:  CB 5B
 BIT 4, E               ;; 06B2:  CB 63
 BIT 5, E               ;; 06B4:  CB 6B
 BIT 6, E               ;; 06B6:  CB 73
 BIT 7, E               ;; 06B8:  CB 7B
 RES 0, E               ;; 06BA:  CB 83
 RES 1, E               ;; 06BC:  CB 8B
 RES 2, E               ;; 06BE:  CB 93
 RES 3, E               ;; 06C0:  CB 9B
 RES 4, E               ;; 06C2:  CB A3
 RES 5, E               ;; 06C4:  CB AB
 RES 6, E               ;; 06C6:  CB B3
 RES 7, E               ;; 06C8:  CB BB
 SET 0, E               ;; 06CA:  CB C3
 SET 1, E               ;; 06CC:  CB CB
 SET 2, E               ;; 06CE:  CB D3
 SET 3, E               ;; 06D0:  CB DB
 SET 4, E               ;; 06D2:  CB E3
 SET 5, E               ;; 06D4:  CB EB
 SET 6, E               ;; 06D6:  CB F3
 SET 7, E               ;; 06D8:  CB FB
 BIT 0, H               ;; 06DA:  CB 44
 BIT 1, H               ;; 06DC:  CB 4C
 BIT 2, H               ;; 06DE:  CB 54
 BIT 3, H               ;; 06E0:  CB 5C
 BIT 4, H               ;; 06E2:  CB 64
 BIT 5, H               ;; 06E4:  CB 6C
 BIT 6, H               ;; 06E6:  CB 74
 BIT 7, H               ;; 06E8:  CB 7C
 RES 0, H               ;; 06EA:  CB 84
 RES 1, H               ;; 06EC:  CB 8C
 RES 2, H               ;; 06EE:  CB 94
 RES 3, H               ;; 06F0:  CB 9C
 RES 4, H               ;; 06F2:  CB A4
 RES 5, H               ;; 06F4:  CB AC
 RES 6, H               ;; 06F6:  CB B4
 RES 7, H               ;; 06F8:  CB BC
 SET 0, H               ;; 06FA:  CB C4
 SET 1, H               ;; 06FC:  CB CC
 SET 2, H               ;; 06FE:  CB D4
 SET 3, H               ;; 0700:  CB DC
 SET 4, H               ;; 0702:  CB E4
 SET 5, H               ;; 0704:  CB EC
 SET 6, H               ;; 0706:  CB F4
 SET 7, H               ;; 0708:  CB FC
 BIT 0, L               ;; 070A:  CB 45
 BIT 1, L               ;; 070C:  CB 4D
 BIT 2, L               ;; 070E:  CB 55
 BIT 3, L               ;; 0710:  CB 5D
 BIT 4, L               ;; 0712:  CB 65
 BIT 5, L               ;; 0714:  CB 6D
 BIT 6, L               ;; 0716:  CB 75
 BIT 7, L               ;; 0718:  CB 7D
 RES 0, L               ;; 071A:  CB 85
 RES 1, L               ;; 071C:  CB 8D
 RES 2, L               ;; 071E:  CB 95
 RES 3, L               ;; 0720:  CB 9D
 RES 4, L               ;; 0722:  CB A5
 RES 5, L               ;; 0724:  CB AD
 RES 6, L               ;; 0726:  CB B5
 RES 7, L               ;; 0728:  CB BD
 SET 0, L               ;; 072A:  CB C5
 SET 1, L               ;; 072C:  CB CD
 SET 2, L               ;; 072E:  CB D5
 SET 3, L               ;; 0730:  CB DD
 SET 4, L               ;; 0732:  CB E5
 SET 5, L               ;; 0734:  CB ED
 SET 6, L               ;; 0736:  CB F5
 SET 7, L               ;; 0738:  CB FD
 BIT 0, A               ;; 073A:  CB 47
 BIT 1, A               ;; 073C:  CB 4F
 BIT 2, A               ;; 073E:  CB 57
 BIT 3, A               ;; 0740:  CB 5F
 BIT 4, A               ;; 0742:  CB 67
 BIT 5, A               ;; 0744:  CB 6F
 BIT 6, A               ;; 0746:  CB 77
 BIT 7, A               ;; 0748:  CB 7F
 RES 0, A               ;; 074A:  CB 87
 RES 1, A               ;; 074C:  CB 8F
 RES 2, A               ;; 074E:  CB 97
 RES 3, A               ;; 0750:  CB 9F
 RES 4, A               ;; 0752:  CB A7
 RES 5, A               ;; 0754:  CB AF
 RES 6, A               ;; 0756:  CB B7
 RES 7, A               ;; 0758:  CB BF
 SET 0, A               ;; 075A:  CB C7
 SET 1, A               ;; 075C:  CB CF
 SET 2, A               ;; 075E:  CB D7
 SET 3, A               ;; 0760:  CB DF
 SET 4, A               ;; 0762:  CB E7
 SET 5, A               ;; 0764:  CB EF
 SET 6, A               ;; 0766:  CB F7
 SET 7, A               ;; 0768:  CB FF
 BIT 0, (HL)            ;; 076A:  CB 46
 BIT 1, (HL)            ;; 076C:  CB 4E
 BIT 2, (HL)            ;; 076E:  CB 56
 BIT 3, (HL)            ;; 0770:  CB 5E
 BIT 4, (HL)            ;; 0772:  CB 66
 BIT 5, (HL)            ;; 0774:  CB 6E
 BIT 6, (HL)            ;; 0776:  CB 76
 BIT 7, (HL)            ;; 0778:  CB 7E
 RES 0, (HL)            ;; 077A:  CB 86
 RES 1, (HL)            ;; 077C:  CB 8E
 RES 2, (HL)            ;; 077E:  CB 96
 RES 3, (HL)            ;; 0780:  CB 9E
 RES 4, (HL)            ;; 0782:  CB A6
 RES 5, (HL)            ;; 0784:  CB AE
 RES 6, (HL)            ;; 0786:  CB B6
 RES 7, (HL)            ;; 0788:  CB BE
 SET 0, (HL)            ;; 078A:  CB C6
 SET 1, (HL)            ;; 078C:  CB CE
 SET 2, (HL)            ;; 078E:  CB D6
 SET 3, (HL)            ;; 0790:  CB DE
 SET 4, (HL)            ;; 0792:  CB E6
 SET 5, (HL)            ;; 0794:  CB EE
 SET 6, (HL)            ;; 0796:  CB F6
 SET 7, (HL)            ;; 0798:  CB FE
 BIT 0, (IX + -128)     ;; 079A:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 079E:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 07A2:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 07A6:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 07AA:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 07AE:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 07B2:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 07B6:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 07BA:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 07BE:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 07C2:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 07C6:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 07CA:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 07CE:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 07D2:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 07D6:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 07DA:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 07DE:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 07E2:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 07E6:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 07EA:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 07EE:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 07F2:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 07F6:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 07FA:  DD CB 80 86
 RES 1, (IX + -128)     ;; 07FE:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 0802:  DD CB 80 96
 RES 3, (IX + -128)     ;; 0806:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 080A:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 080E:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 0812:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 0816:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 081A:  DD CB 00 86
 RES 1, (IX + 0)        ;; 081E:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 0822:  DD CB 00 96
 RES 3, (IX + 0)        ;; 0826:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 082A:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 082E:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 0832:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 0836:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 083A:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 083E:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 0842:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 0846:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 084A:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 084E:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 0852:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0856:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 085A:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 085E:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 0862:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0866:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 086A:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 086E:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 0872:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0876:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 087A:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 087E:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 0882:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 0886:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 088A:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 088E:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 0892:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 0896:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 089A:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 089E:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 08A2:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 08A6:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 08AA:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 08AE:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 08B2:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 08B6:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 08BA:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 08BE:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 08C2:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 08C6:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 08CA:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 08CE:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 08D2:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 08D6:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 08DA:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 08DE:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 08E2:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 08E6:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 08EA:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 08EE:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 08F2:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 08F6:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 08FA:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 08FE:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 0902:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 0906:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 090A:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 090E:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 0912:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 0916:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 091A:  FD CB 80 86
 RES 1, (IY + -128)     ;; 091E:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 0922:  FD CB 80 96
 RES 3, (IY + -128)     ;; 0926:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 092A:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 092E:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 0932:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 0936:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 093A:  FD CB 00 86
 RES 1, (IY + 0)        ;; 093E:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 0942:  FD CB 00 96
 RES 3, (IY + 0)        ;; 0946:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 094A:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 094E:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 0952:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0956:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 095A:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 095E:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 0962:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0966:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 096A:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 096E:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 0972:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0976:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 097A:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 097E:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 0982:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 0986:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 098A:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 098E:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 0992:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 0996:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 099A:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 099E:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 09A2:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 09A6:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 09AA:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 09AE:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 09B2:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 09B6:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 09BA:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 09BE:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 09C2:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 09C6:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 09CA:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 09CE:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 09D2:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 09D6:  FD CB 7F FE
 JP 0                   ;; 09DA:  C3 00 00
 JP 4660                ;; 09DD:  C3 34 12
 JP 52719               ;; 09E0:  C3 EF CD
 JP 65535               ;; 09E3:  C3 FF FF
 JP NZ, 0               ;; 09E6:  C2 00 00
 JP NZ, 4660            ;; 09E9:  C2 34 12
 JP NZ, 52719           ;; 09EC:  C2 EF CD
 JP NZ, 65535           ;; 09EF:  C2 FF FF
 JP Z, 0                ;; 09F2:  CA 00 00
 JP Z, 4660             ;; 09F5:  CA 34 12
 JP Z, 52719            ;; 09F8:  CA EF CD
 JP Z, 65535            ;; 09FB:  CA FF FF
 JP NC, 0               ;; 09FE:  D2 00 00
 JP NC, 4660            ;; 0A01:  D2 34 12
 JP NC, 52719           ;; 0A04:  D2 EF CD
 JP NC, 65535           ;; 0A07:  D2 FF FF
 JP C, 0                ;; 0A0A:  DA 00 00
 JP C, 4660             ;; 0A0D:  DA 34 12
 JP C, 52719            ;; 0A10:  DA EF CD
 JP C, 65535            ;; 0A13:  DA FF FF
 JP P, 0                ;; 0A16:  F2 00 00
 JP P, 4660             ;; 0A19:  F2 34 12
 JP P, 52719            ;; 0A1C:  F2 EF CD
 JP P, 65535            ;; 0A1F:  F2 FF FF
 JP M, 0                ;; 0A22:  FA 00 00
 JP M, 4660             ;; 0A25:  FA 34 12
 JP M, 52719            ;; 0A28:  FA EF CD
 JP M, 65535            ;; 0A2B:  FA FF FF
 JP PO, 0               ;; 0A2E:  E2 00 00
 JP PO, 4660            ;; 0A31:  E2 34 12
 JP PO, 52719           ;; 0A34:  E2 EF CD
 JP PO, 65535           ;; 0A37:  E2 FF FF
 JP PE, 0               ;; 0A3A:  EA 00 00
 JP PE, 4660            ;; 0A3D:  EA 34 12
 JP PE, 52719           ;; 0A40:  EA EF CD
 JP PE, 65535           ;; 0A43:  EA FF FF
 JR ASMPC+2             ;; 0A46:  18 00
 JR NZ, ASMPC+2         ;; 0A48:  20 00
 JR Z, ASMPC+2          ;; 0A4A:  28 00
 JR NC, ASMPC+2         ;; 0A4C:  30 00
 JR C, ASMPC+2          ;; 0A4E:  38 00
 JP (HL)                ;; 0A50:  E9
 JP (IX)                ;; 0A51:  DD E9
 JP (IY)                ;; 0A53:  FD E9
 DJNZ ASMPC+2           ;; 0A55:  10 00
 CALL 0                 ;; 0A57:  CD 00 00
 CALL 4660              ;; 0A5A:  CD 34 12
 CALL 52719             ;; 0A5D:  CD EF CD
 CALL 65535             ;; 0A60:  CD FF FF
 CALL NZ, 0             ;; 0A63:  C4 00 00
 CALL NZ, 4660          ;; 0A66:  C4 34 12
 CALL NZ, 52719         ;; 0A69:  C4 EF CD
 CALL NZ, 65535         ;; 0A6C:  C4 FF FF
 CALL Z, 0              ;; 0A6F:  CC 00 00
 CALL Z, 4660           ;; 0A72:  CC 34 12
 CALL Z, 52719          ;; 0A75:  CC EF CD
 CALL Z, 65535          ;; 0A78:  CC FF FF
 CALL NC, 0             ;; 0A7B:  D4 00 00
 CALL NC, 4660          ;; 0A7E:  D4 34 12
 CALL NC, 52719         ;; 0A81:  D4 EF CD
 CALL NC, 65535         ;; 0A84:  D4 FF FF
 CALL C, 0              ;; 0A87:  DC 00 00
 CALL C, 4660           ;; 0A8A:  DC 34 12
 CALL C, 52719          ;; 0A8D:  DC EF CD
 CALL C, 65535          ;; 0A90:  DC FF FF
 CALL P, 0              ;; 0A93:  F4 00 00
 CALL P, 4660           ;; 0A96:  F4 34 12
 CALL P, 52719          ;; 0A99:  F4 EF CD
 CALL P, 65535          ;; 0A9C:  F4 FF FF
 CALL M, 0              ;; 0A9F:  FC 00 00
 CALL M, 4660           ;; 0AA2:  FC 34 12
 CALL M, 52719          ;; 0AA5:  FC EF CD
 CALL M, 65535          ;; 0AA8:  FC FF FF
 RET                    ;; 0AAB:  C9
 RET NZ                 ;; 0AAC:  C0
 RET Z                  ;; 0AAD:  C8
 RET NC                 ;; 0AAE:  D0
 RET C                  ;; 0AAF:  D8
 RET P                  ;; 0AB0:  F0
 RET M                  ;; 0AB1:  F8
 RET PO                 ;; 0AB2:  E0
 RET PE                 ;; 0AB3:  E8
 RST 16                 ;; 0AB4:  D7
 RST 24                 ;; 0AB5:  DF
 RST 32                 ;; 0AB6:  E7
 RST 40                 ;; 0AB7:  EF
 RST 56                 ;; 0AB8:  FF
 RST 0                  ;; 0AB9:  C7
 RST 8                  ;; 0ABA:  CF
 RST 48                 ;; 0ABB:  F7
 IN A, (0)              ;; 0ABC:  DB 00
 IN A, (85)             ;; 0ABE:  DB 55
 IN A, (170)            ;; 0AC0:  DB AA
 IN A, (255)            ;; 0AC2:  DB FF
 IN B, (C)              ;; 0AC4:  ED 40
 IN C, (C)              ;; 0AC6:  ED 48
 IN D, (C)              ;; 0AC8:  ED 50
 IN E, (C)              ;; 0ACA:  ED 58
 IN H, (C)              ;; 0ACC:  ED 60
 IN L, (C)              ;; 0ACE:  ED 68
 IN A, (C)              ;; 0AD0:  ED 78
 INI                    ;; 0AD2:  ED A2
 INIR                   ;; 0AD4:  ED B2
 IND                    ;; 0AD6:  ED AA
 INDR                   ;; 0AD8:  ED BA
 OUT (0), A             ;; 0ADA:  D3 00
 OUT (85), A            ;; 0ADC:  D3 55
 OUT (170), A           ;; 0ADE:  D3 AA
 OUT (255), A           ;; 0AE0:  D3 FF
 OUT (C), B             ;; 0AE2:  ED 41
 OUT (C), C             ;; 0AE4:  ED 49
 OUT (C), D             ;; 0AE6:  ED 51
 OUT (C), E             ;; 0AE8:  ED 59
 OUT (C), H             ;; 0AEA:  ED 61
 OUT (C), L             ;; 0AEC:  ED 69
 OUT (C), A             ;; 0AEE:  ED 79
 OUTI                   ;; 0AF0:  ED A3
 OTIR                   ;; 0AF2:  ED B3
 OUTD                   ;; 0AF4:  ED AB
 OTDR                   ;; 0AF6:  ED BB
 IN0 B, (0)             ;; 0AF8:  ED 00 00
 IN0 B, (85)            ;; 0AFB:  ED 00 55
 IN0 B, (170)           ;; 0AFE:  ED 00 AA
 IN0 B, (255)           ;; 0B01:  ED 00 FF
 IN0 C, (0)             ;; 0B04:  ED 08 00
 IN0 C, (85)            ;; 0B07:  ED 08 55
 IN0 C, (170)           ;; 0B0A:  ED 08 AA
 IN0 C, (255)           ;; 0B0D:  ED 08 FF
 IN0 D, (0)             ;; 0B10:  ED 10 00
 IN0 D, (85)            ;; 0B13:  ED 10 55
 IN0 D, (170)           ;; 0B16:  ED 10 AA
 IN0 D, (255)           ;; 0B19:  ED 10 FF
 IN0 E, (0)             ;; 0B1C:  ED 18 00
 IN0 E, (85)            ;; 0B1F:  ED 18 55
 IN0 E, (170)           ;; 0B22:  ED 18 AA
 IN0 E, (255)           ;; 0B25:  ED 18 FF
 IN0 H, (0)             ;; 0B28:  ED 20 00
 IN0 H, (85)            ;; 0B2B:  ED 20 55
 IN0 H, (170)           ;; 0B2E:  ED 20 AA
 IN0 H, (255)           ;; 0B31:  ED 20 FF
 IN0 L, (0)             ;; 0B34:  ED 28 00
 IN0 L, (85)            ;; 0B37:  ED 28 55
 IN0 L, (170)           ;; 0B3A:  ED 28 AA
 IN0 L, (255)           ;; 0B3D:  ED 28 FF
 IN0 A, (0)             ;; 0B40:  ED 38 00
 IN0 A, (85)            ;; 0B43:  ED 38 55
 IN0 A, (170)           ;; 0B46:  ED 38 AA
 IN0 A, (255)           ;; 0B49:  ED 38 FF
 OUT0 (0), B            ;; 0B4C:  ED 01 00
 OUT0 (85), B           ;; 0B4F:  ED 01 55
 OUT0 (170), B          ;; 0B52:  ED 01 AA
 OUT0 (255), B          ;; 0B55:  ED 01 FF
 OUT0 (0), C            ;; 0B58:  ED 09 00
 OUT0 (85), C           ;; 0B5B:  ED 09 55
 OUT0 (170), C          ;; 0B5E:  ED 09 AA
 OUT0 (255), C          ;; 0B61:  ED 09 FF
 OUT0 (0), D            ;; 0B64:  ED 11 00
 OUT0 (85), D           ;; 0B67:  ED 11 55
 OUT0 (170), D          ;; 0B6A:  ED 11 AA
 OUT0 (255), D          ;; 0B6D:  ED 11 FF
 OUT0 (0), E            ;; 0B70:  ED 19 00
 OUT0 (85), E           ;; 0B73:  ED 19 55
 OUT0 (170), E          ;; 0B76:  ED 19 AA
 OUT0 (255), E          ;; 0B79:  ED 19 FF
 OUT0 (0), H            ;; 0B7C:  ED 21 00
 OUT0 (85), H           ;; 0B7F:  ED 21 55
 OUT0 (170), H          ;; 0B82:  ED 21 AA
 OUT0 (255), H          ;; 0B85:  ED 21 FF
 OUT0 (0), L            ;; 0B88:  ED 29 00
 OUT0 (85), L           ;; 0B8B:  ED 29 55
 OUT0 (170), L          ;; 0B8E:  ED 29 AA
 OUT0 (255), L          ;; 0B91:  ED 29 FF
 OUT0 (0), A            ;; 0B94:  ED 39 00
 OUT0 (85), A           ;; 0B97:  ED 39 55
 OUT0 (170), A          ;; 0B9A:  ED 39 AA
 OUT0 (255), A          ;; 0B9D:  ED 39 FF
 OTDM                   ;; 0BA0:  ED 8B
 OTDMR                  ;; 0BA2:  ED 9B
 OTIM                   ;; 0BA4:  ED 83
 OTIMR                  ;; 0BA6:  ED 93
 TSTIO 0                ;; 0BA8:  ED 74 00
 TSTIO 85               ;; 0BAB:  ED 74 55
 TSTIO 170              ;; 0BAE:  ED 74 AA
 TSTIO 255              ;; 0BB1:  ED 74 FF
 DI                     ;; 0BB4:  F3
 EI                     ;; 0BB5:  FB
 IM 0                   ;; 0BB6:  ED 46
 IM 1                   ;; 0BB8:  ED 56
 IM 2                   ;; 0BBA:  ED 5E
 LD I, A                ;; 0BBC:  ED 47
 LD A, I                ;; 0BBE:  ED 57
 LD R, A                ;; 0BC0:  ED 4F
 LD A, R                ;; 0BC2:  ED 5F
 RETI                   ;; 0BC4:  ED 4D
 RETN                   ;; 0BC6:  ED 45
