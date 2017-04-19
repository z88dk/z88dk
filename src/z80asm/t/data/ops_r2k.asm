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
 EX (SP), HL            ;; 0317:  ED 54
 EX (SP), IX            ;; 0319:  DD E3
 EX (SP), IY            ;; 031B:  FD E3
 EX DE', HL             ;; 031D:  E3
 EX DE, HL'             ;; 031E:  76 EB
 EX DE', HL'            ;; 0320:  76 E3
 LDI                    ;; 0322:  ED A0
 LDIR                   ;; 0324:  ED B0
 LDD                    ;; 0326:  ED A8
 LDDR                   ;; 0328:  ED B8
 ADD A, B               ;; 032A:  80
 ADC A, B               ;; 032B:  88
 SUB B                  ;; 032C:  90
 SBC A, B               ;; 032D:  98
 AND B                  ;; 032E:  A0
 XOR B                  ;; 032F:  A8
 OR B                   ;; 0330:  B0
 CP B                   ;; 0331:  B8
 ADD A, C               ;; 0332:  81
 ADC A, C               ;; 0333:  89
 SUB C                  ;; 0334:  91
 SBC A, C               ;; 0335:  99
 AND C                  ;; 0336:  A1
 XOR C                  ;; 0337:  A9
 OR C                   ;; 0338:  B1
 CP C                   ;; 0339:  B9
 ADD A, D               ;; 033A:  82
 ADC A, D               ;; 033B:  8A
 SUB D                  ;; 033C:  92
 SBC A, D               ;; 033D:  9A
 AND D                  ;; 033E:  A2
 XOR D                  ;; 033F:  AA
 OR D                   ;; 0340:  B2
 CP D                   ;; 0341:  BA
 ADD A, E               ;; 0342:  83
 ADC A, E               ;; 0343:  8B
 SUB E                  ;; 0344:  93
 SBC A, E               ;; 0345:  9B
 AND E                  ;; 0346:  A3
 XOR E                  ;; 0347:  AB
 OR E                   ;; 0348:  B3
 CP E                   ;; 0349:  BB
 ADD A, H               ;; 034A:  84
 ADC A, H               ;; 034B:  8C
 SUB H                  ;; 034C:  94
 SBC A, H               ;; 034D:  9C
 AND H                  ;; 034E:  A4
 XOR H                  ;; 034F:  AC
 OR H                   ;; 0350:  B4
 CP H                   ;; 0351:  BC
 ADD A, L               ;; 0352:  85
 ADC A, L               ;; 0353:  8D
 SUB L                  ;; 0354:  95
 SBC A, L               ;; 0355:  9D
 AND L                  ;; 0356:  A5
 XOR L                  ;; 0357:  AD
 OR L                   ;; 0358:  B5
 CP L                   ;; 0359:  BD
 ADD A, A               ;; 035A:  87
 ADC A, A               ;; 035B:  8F
 SUB A                  ;; 035C:  97
 SBC A, A               ;; 035D:  9F
 AND A                  ;; 035E:  A7
 XOR A                  ;; 035F:  AF
 OR A                   ;; 0360:  B7
 CP A                   ;; 0361:  BF
 ADD A, 0               ;; 0362:  C6 00
 ADD A, 85              ;; 0364:  C6 55
 ADD A, 170             ;; 0366:  C6 AA
 ADD A, 255             ;; 0368:  C6 FF
 ADC A, 0               ;; 036A:  CE 00
 ADC A, 85              ;; 036C:  CE 55
 ADC A, 170             ;; 036E:  CE AA
 ADC A, 255             ;; 0370:  CE FF
 SUB 0                  ;; 0372:  D6 00
 SUB 85                 ;; 0374:  D6 55
 SUB 170                ;; 0376:  D6 AA
 SUB 255                ;; 0378:  D6 FF
 SBC A, 0               ;; 037A:  DE 00
 SBC A, 85              ;; 037C:  DE 55
 SBC A, 170             ;; 037E:  DE AA
 SBC A, 255             ;; 0380:  DE FF
 AND 0                  ;; 0382:  E6 00
 AND 85                 ;; 0384:  E6 55
 AND 170                ;; 0386:  E6 AA
 AND 255                ;; 0388:  E6 FF
 XOR 0                  ;; 038A:  EE 00
 XOR 85                 ;; 038C:  EE 55
 XOR 170                ;; 038E:  EE AA
 XOR 255                ;; 0390:  EE FF
 OR 0                   ;; 0392:  F6 00
 OR 85                  ;; 0394:  F6 55
 OR 170                 ;; 0396:  F6 AA
 OR 255                 ;; 0398:  F6 FF
 CP 0                   ;; 039A:  FE 00
 CP 85                  ;; 039C:  FE 55
 CP 170                 ;; 039E:  FE AA
 CP 255                 ;; 03A0:  FE FF
 ADD A, (HL)            ;; 03A2:  86
 ADC A, (HL)            ;; 03A3:  8E
 SUB (HL)               ;; 03A4:  96
 SBC A, (HL)            ;; 03A5:  9E
 AND (HL)               ;; 03A6:  A6
 XOR (HL)               ;; 03A7:  AE
 OR (HL)                ;; 03A8:  B6
 CP (HL)                ;; 03A9:  BE
 ADD A, (IX + -128)     ;; 03AA:  DD 86 80
 ADD A, (IX + 0)        ;; 03AD:  DD 86 00
 ADD A, (IX + 127)      ;; 03B0:  DD 86 7F
 ADC A, (IX + -128)     ;; 03B3:  DD 8E 80
 ADC A, (IX + 0)        ;; 03B6:  DD 8E 00
 ADC A, (IX + 127)      ;; 03B9:  DD 8E 7F
 SUB (IX + -128)        ;; 03BC:  DD 96 80
 SUB (IX + 0)           ;; 03BF:  DD 96 00
 SUB (IX + 127)         ;; 03C2:  DD 96 7F
 SBC A, (IX + -128)     ;; 03C5:  DD 9E 80
 SBC A, (IX + 0)        ;; 03C8:  DD 9E 00
 SBC A, (IX + 127)      ;; 03CB:  DD 9E 7F
 AND (IX + -128)        ;; 03CE:  DD A6 80
 AND (IX + 0)           ;; 03D1:  DD A6 00
 AND (IX + 127)         ;; 03D4:  DD A6 7F
 XOR (IX + -128)        ;; 03D7:  DD AE 80
 XOR (IX + 0)           ;; 03DA:  DD AE 00
 XOR (IX + 127)         ;; 03DD:  DD AE 7F
 OR (IX + -128)         ;; 03E0:  DD B6 80
 OR (IX + 0)            ;; 03E3:  DD B6 00
 OR (IX + 127)          ;; 03E6:  DD B6 7F
 CP (IX + -128)         ;; 03E9:  DD BE 80
 CP (IX + 0)            ;; 03EC:  DD BE 00
 CP (IX + 127)          ;; 03EF:  DD BE 7F
 ADD A, (IY + -128)     ;; 03F2:  FD 86 80
 ADD A, (IY + 0)        ;; 03F5:  FD 86 00
 ADD A, (IY + 127)      ;; 03F8:  FD 86 7F
 ADC A, (IY + -128)     ;; 03FB:  FD 8E 80
 ADC A, (IY + 0)        ;; 03FE:  FD 8E 00
 ADC A, (IY + 127)      ;; 0401:  FD 8E 7F
 SUB (IY + -128)        ;; 0404:  FD 96 80
 SUB (IY + 0)           ;; 0407:  FD 96 00
 SUB (IY + 127)         ;; 040A:  FD 96 7F
 SBC A, (IY + -128)     ;; 040D:  FD 9E 80
 SBC A, (IY + 0)        ;; 0410:  FD 9E 00
 SBC A, (IY + 127)      ;; 0413:  FD 9E 7F
 AND (IY + -128)        ;; 0416:  FD A6 80
 AND (IY + 0)           ;; 0419:  FD A6 00
 AND (IY + 127)         ;; 041C:  FD A6 7F
 XOR (IY + -128)        ;; 041F:  FD AE 80
 XOR (IY + 0)           ;; 0422:  FD AE 00
 XOR (IY + 127)         ;; 0425:  FD AE 7F
 OR (IY + -128)         ;; 0428:  FD B6 80
 OR (IY + 0)            ;; 042B:  FD B6 00
 OR (IY + 127)          ;; 042E:  FD B6 7F
 CP (IY + -128)         ;; 0431:  FD BE 80
 CP (IY + 0)            ;; 0434:  FD BE 00
 CP (IY + 127)          ;; 0437:  FD BE 7F
 INC B                  ;; 043A:  04
 INC C                  ;; 043B:  0C
 INC D                  ;; 043C:  14
 INC E                  ;; 043D:  1C
 INC H                  ;; 043E:  24
 INC L                  ;; 043F:  2C
 INC A                  ;; 0440:  3C
 INC (HL)               ;; 0441:  34
 INC (IX + -128)        ;; 0442:  DD 34 80
 INC (IX + 0)           ;; 0445:  DD 34 00
 INC (IX + 127)         ;; 0448:  DD 34 7F
 INC (IY + -128)        ;; 044B:  FD 34 80
 INC (IY + 0)           ;; 044E:  FD 34 00
 INC (IY + 127)         ;; 0451:  FD 34 7F
 DEC B                  ;; 0454:  05
 DEC C                  ;; 0455:  0D
 DEC D                  ;; 0456:  15
 DEC E                  ;; 0457:  1D
 DEC H                  ;; 0458:  25
 DEC L                  ;; 0459:  2D
 DEC A                  ;; 045A:  3D
 DEC (HL)               ;; 045B:  35
 DEC (IX + -128)        ;; 045C:  DD 35 80
 DEC (IX + 0)           ;; 045F:  DD 35 00
 DEC (IX + 127)         ;; 0462:  DD 35 7F
 DEC (IY + -128)        ;; 0465:  FD 35 80
 DEC (IY + 0)           ;; 0468:  FD 35 00
 DEC (IY + 127)         ;; 046B:  FD 35 7F
 TST B                  ;; 046E:  ED 04
 TST C                  ;; 0470:  ED 0C
 TST D                  ;; 0472:  ED 14
 TST E                  ;; 0474:  ED 1C
 TST H                  ;; 0476:  ED 24
 TST L                  ;; 0478:  ED 2C
 TST A                  ;; 047A:  ED 3C
 TST 0                  ;; 047C:  ED 64 00
 TST 85                 ;; 047F:  ED 64 55
 TST 170                ;; 0482:  ED 64 AA
 TST 255                ;; 0485:  ED 64 FF
 TST (HL)               ;; 0488:  ED 34
 CPL                    ;; 048A:  2F
 NEG                    ;; 048B:  ED 44
 CCF                    ;; 048D:  3F
 SCF                    ;; 048E:  37
 NOP                    ;; 048F:  00
 ALTD                   ;; 0490:  76
 ADD HL, BC             ;; 0491:  09
 ADD HL, DE             ;; 0492:  19
 ADD HL, HL             ;; 0493:  29
 ADD HL, SP             ;; 0494:  39
 ADD IX, BC             ;; 0495:  DD 09
 ADD IY, BC             ;; 0497:  FD 09
 ADD IX, DE             ;; 0499:  DD 19
 ADD IY, DE             ;; 049B:  FD 19
 ADD IX, IX             ;; 049D:  DD 29
 ADD IY, IY             ;; 049F:  FD 29
 ADD IX, SP             ;; 04A1:  DD 39
 ADD IY, SP             ;; 04A3:  FD 39
 ADD SP, -128           ;; 04A5:  27 80
 ADD SP, 0              ;; 04A7:  27 00
 ADD SP, 127            ;; 04A9:  27 7F
 ADC HL, BC             ;; 04AB:  ED 4A
 ADC HL, DE             ;; 04AD:  ED 5A
 ADC HL, HL             ;; 04AF:  ED 6A
 ADC HL, SP             ;; 04B1:  ED 7A
 SBC HL, BC             ;; 04B3:  ED 42
 SBC HL, DE             ;; 04B5:  ED 52
 SBC HL, HL             ;; 04B7:  ED 62
 SBC HL, SP             ;; 04B9:  ED 72
 AND HL, DE             ;; 04BB:  DC
 AND IX, DE             ;; 04BC:  DD DC
 AND IY, DE             ;; 04BE:  FD DC
 BOOL HL                ;; 04C0:  CC
 BOOL IX                ;; 04C1:  DD CC
 BOOL IY                ;; 04C3:  FD CC
 INC BC                 ;; 04C5:  03
 INC DE                 ;; 04C6:  13
 INC HL                 ;; 04C7:  23
 INC SP                 ;; 04C8:  33
 INC IX                 ;; 04C9:  DD 23
 INC IY                 ;; 04CB:  FD 23
 DEC BC                 ;; 04CD:  0B
 DEC DE                 ;; 04CE:  1B
 DEC HL                 ;; 04CF:  2B
 DEC SP                 ;; 04D0:  3B
 DEC IX                 ;; 04D1:  DD 2B
 DEC IY                 ;; 04D3:  FD 2B
 MLT BC                 ;; 04D5:  ED 4C
 MLT DE                 ;; 04D7:  ED 5C
 MLT HL                 ;; 04D9:  ED 6C
 RLCA                   ;; 04DB:  07
 RRCA                   ;; 04DC:  0F
 RLA                    ;; 04DD:  17
 RRA                    ;; 04DE:  1F
 RLC B                  ;; 04DF:  CB 00
 RRC B                  ;; 04E1:  CB 08
 RL B                   ;; 04E3:  CB 10
 RR B                   ;; 04E5:  CB 18
 SLA B                  ;; 04E7:  CB 20
 SRA B                  ;; 04E9:  CB 28
 SRL B                  ;; 04EB:  CB 38
 RLC C                  ;; 04ED:  CB 01
 RRC C                  ;; 04EF:  CB 09
 RL C                   ;; 04F1:  CB 11
 RR C                   ;; 04F3:  CB 19
 SLA C                  ;; 04F5:  CB 21
 SRA C                  ;; 04F7:  CB 29
 SRL C                  ;; 04F9:  CB 39
 RLC D                  ;; 04FB:  CB 02
 RRC D                  ;; 04FD:  CB 0A
 RL D                   ;; 04FF:  CB 12
 RR D                   ;; 0501:  CB 1A
 SLA D                  ;; 0503:  CB 22
 SRA D                  ;; 0505:  CB 2A
 SRL D                  ;; 0507:  CB 3A
 RLC E                  ;; 0509:  CB 03
 RRC E                  ;; 050B:  CB 0B
 RL E                   ;; 050D:  CB 13
 RR E                   ;; 050F:  CB 1B
 SLA E                  ;; 0511:  CB 23
 SRA E                  ;; 0513:  CB 2B
 SRL E                  ;; 0515:  CB 3B
 RLC H                  ;; 0517:  CB 04
 RRC H                  ;; 0519:  CB 0C
 RL H                   ;; 051B:  CB 14
 RR H                   ;; 051D:  CB 1C
 SLA H                  ;; 051F:  CB 24
 SRA H                  ;; 0521:  CB 2C
 SRL H                  ;; 0523:  CB 3C
 RLC L                  ;; 0525:  CB 05
 RRC L                  ;; 0527:  CB 0D
 RL L                   ;; 0529:  CB 15
 RR L                   ;; 052B:  CB 1D
 SLA L                  ;; 052D:  CB 25
 SRA L                  ;; 052F:  CB 2D
 SRL L                  ;; 0531:  CB 3D
 RLC A                  ;; 0533:  CB 07
 RRC A                  ;; 0535:  CB 0F
 RL A                   ;; 0537:  CB 17
 RR A                   ;; 0539:  CB 1F
 SLA A                  ;; 053B:  CB 27
 SRA A                  ;; 053D:  CB 2F
 SRL A                  ;; 053F:  CB 3F
 RLC (HL)               ;; 0541:  CB 06
 RRC (HL)               ;; 0543:  CB 0E
 RL (HL)                ;; 0545:  CB 16
 RR (HL)                ;; 0547:  CB 1E
 SLA (HL)               ;; 0549:  CB 26
 SRA (HL)               ;; 054B:  CB 2E
 SRL (HL)               ;; 054D:  CB 3E
 RLC (IX + -128)        ;; 054F:  DD CB 80 06
 RLC (IX + 0)           ;; 0553:  DD CB 00 06
 RLC (IX + 127)         ;; 0557:  DD CB 7F 06
 RRC (IX + -128)        ;; 055B:  DD CB 80 0E
 RRC (IX + 0)           ;; 055F:  DD CB 00 0E
 RRC (IX + 127)         ;; 0563:  DD CB 7F 0E
 RL (IX + -128)         ;; 0567:  DD CB 80 16
 RL (IX + 0)            ;; 056B:  DD CB 00 16
 RL (IX + 127)          ;; 056F:  DD CB 7F 16
 RR (IX + -128)         ;; 0573:  DD CB 80 1E
 RR (IX + 0)            ;; 0577:  DD CB 00 1E
 RR (IX + 127)          ;; 057B:  DD CB 7F 1E
 SLA (IX + -128)        ;; 057F:  DD CB 80 26
 SLA (IX + 0)           ;; 0583:  DD CB 00 26
 SLA (IX + 127)         ;; 0587:  DD CB 7F 26
 SRA (IX + -128)        ;; 058B:  DD CB 80 2E
 SRA (IX + 0)           ;; 058F:  DD CB 00 2E
 SRA (IX + 127)         ;; 0593:  DD CB 7F 2E
 SRL (IX + -128)        ;; 0597:  DD CB 80 3E
 SRL (IX + 0)           ;; 059B:  DD CB 00 3E
 SRL (IX + 127)         ;; 059F:  DD CB 7F 3E
 RLC (IY + -128)        ;; 05A3:  FD CB 80 06
 RLC (IY + 0)           ;; 05A7:  FD CB 00 06
 RLC (IY + 127)         ;; 05AB:  FD CB 7F 06
 RRC (IY + -128)        ;; 05AF:  FD CB 80 0E
 RRC (IY + 0)           ;; 05B3:  FD CB 00 0E
 RRC (IY + 127)         ;; 05B7:  FD CB 7F 0E
 RL (IY + -128)         ;; 05BB:  FD CB 80 16
 RL (IY + 0)            ;; 05BF:  FD CB 00 16
 RL (IY + 127)          ;; 05C3:  FD CB 7F 16
 RR (IY + -128)         ;; 05C7:  FD CB 80 1E
 RR (IY + 0)            ;; 05CB:  FD CB 00 1E
 RR (IY + 127)          ;; 05CF:  FD CB 7F 1E
 SLA (IY + -128)        ;; 05D3:  FD CB 80 26
 SLA (IY + 0)           ;; 05D7:  FD CB 00 26
 SLA (IY + 127)         ;; 05DB:  FD CB 7F 26
 SRA (IY + -128)        ;; 05DF:  FD CB 80 2E
 SRA (IY + 0)           ;; 05E3:  FD CB 00 2E
 SRA (IY + 127)         ;; 05E7:  FD CB 7F 2E
 SRL (IY + -128)        ;; 05EB:  FD CB 80 3E
 SRL (IY + 0)           ;; 05EF:  FD CB 00 3E
 SRL (IY + 127)         ;; 05F3:  FD CB 7F 3E
 BIT 0, B               ;; 05F7:  CB 40
 BIT 1, B               ;; 05F9:  CB 48
 BIT 2, B               ;; 05FB:  CB 50
 BIT 3, B               ;; 05FD:  CB 58
 BIT 4, B               ;; 05FF:  CB 60
 BIT 5, B               ;; 0601:  CB 68
 BIT 6, B               ;; 0603:  CB 70
 BIT 7, B               ;; 0605:  CB 78
 RES 0, B               ;; 0607:  CB 80
 RES 1, B               ;; 0609:  CB 88
 RES 2, B               ;; 060B:  CB 90
 RES 3, B               ;; 060D:  CB 98
 RES 4, B               ;; 060F:  CB A0
 RES 5, B               ;; 0611:  CB A8
 RES 6, B               ;; 0613:  CB B0
 RES 7, B               ;; 0615:  CB B8
 SET 0, B               ;; 0617:  CB C0
 SET 1, B               ;; 0619:  CB C8
 SET 2, B               ;; 061B:  CB D0
 SET 3, B               ;; 061D:  CB D8
 SET 4, B               ;; 061F:  CB E0
 SET 5, B               ;; 0621:  CB E8
 SET 6, B               ;; 0623:  CB F0
 SET 7, B               ;; 0625:  CB F8
 BIT 0, C               ;; 0627:  CB 41
 BIT 1, C               ;; 0629:  CB 49
 BIT 2, C               ;; 062B:  CB 51
 BIT 3, C               ;; 062D:  CB 59
 BIT 4, C               ;; 062F:  CB 61
 BIT 5, C               ;; 0631:  CB 69
 BIT 6, C               ;; 0633:  CB 71
 BIT 7, C               ;; 0635:  CB 79
 RES 0, C               ;; 0637:  CB 81
 RES 1, C               ;; 0639:  CB 89
 RES 2, C               ;; 063B:  CB 91
 RES 3, C               ;; 063D:  CB 99
 RES 4, C               ;; 063F:  CB A1
 RES 5, C               ;; 0641:  CB A9
 RES 6, C               ;; 0643:  CB B1
 RES 7, C               ;; 0645:  CB B9
 SET 0, C               ;; 0647:  CB C1
 SET 1, C               ;; 0649:  CB C9
 SET 2, C               ;; 064B:  CB D1
 SET 3, C               ;; 064D:  CB D9
 SET 4, C               ;; 064F:  CB E1
 SET 5, C               ;; 0651:  CB E9
 SET 6, C               ;; 0653:  CB F1
 SET 7, C               ;; 0655:  CB F9
 BIT 0, D               ;; 0657:  CB 42
 BIT 1, D               ;; 0659:  CB 4A
 BIT 2, D               ;; 065B:  CB 52
 BIT 3, D               ;; 065D:  CB 5A
 BIT 4, D               ;; 065F:  CB 62
 BIT 5, D               ;; 0661:  CB 6A
 BIT 6, D               ;; 0663:  CB 72
 BIT 7, D               ;; 0665:  CB 7A
 RES 0, D               ;; 0667:  CB 82
 RES 1, D               ;; 0669:  CB 8A
 RES 2, D               ;; 066B:  CB 92
 RES 3, D               ;; 066D:  CB 9A
 RES 4, D               ;; 066F:  CB A2
 RES 5, D               ;; 0671:  CB AA
 RES 6, D               ;; 0673:  CB B2
 RES 7, D               ;; 0675:  CB BA
 SET 0, D               ;; 0677:  CB C2
 SET 1, D               ;; 0679:  CB CA
 SET 2, D               ;; 067B:  CB D2
 SET 3, D               ;; 067D:  CB DA
 SET 4, D               ;; 067F:  CB E2
 SET 5, D               ;; 0681:  CB EA
 SET 6, D               ;; 0683:  CB F2
 SET 7, D               ;; 0685:  CB FA
 BIT 0, E               ;; 0687:  CB 43
 BIT 1, E               ;; 0689:  CB 4B
 BIT 2, E               ;; 068B:  CB 53
 BIT 3, E               ;; 068D:  CB 5B
 BIT 4, E               ;; 068F:  CB 63
 BIT 5, E               ;; 0691:  CB 6B
 BIT 6, E               ;; 0693:  CB 73
 BIT 7, E               ;; 0695:  CB 7B
 RES 0, E               ;; 0697:  CB 83
 RES 1, E               ;; 0699:  CB 8B
 RES 2, E               ;; 069B:  CB 93
 RES 3, E               ;; 069D:  CB 9B
 RES 4, E               ;; 069F:  CB A3
 RES 5, E               ;; 06A1:  CB AB
 RES 6, E               ;; 06A3:  CB B3
 RES 7, E               ;; 06A5:  CB BB
 SET 0, E               ;; 06A7:  CB C3
 SET 1, E               ;; 06A9:  CB CB
 SET 2, E               ;; 06AB:  CB D3
 SET 3, E               ;; 06AD:  CB DB
 SET 4, E               ;; 06AF:  CB E3
 SET 5, E               ;; 06B1:  CB EB
 SET 6, E               ;; 06B3:  CB F3
 SET 7, E               ;; 06B5:  CB FB
 BIT 0, H               ;; 06B7:  CB 44
 BIT 1, H               ;; 06B9:  CB 4C
 BIT 2, H               ;; 06BB:  CB 54
 BIT 3, H               ;; 06BD:  CB 5C
 BIT 4, H               ;; 06BF:  CB 64
 BIT 5, H               ;; 06C1:  CB 6C
 BIT 6, H               ;; 06C3:  CB 74
 BIT 7, H               ;; 06C5:  CB 7C
 RES 0, H               ;; 06C7:  CB 84
 RES 1, H               ;; 06C9:  CB 8C
 RES 2, H               ;; 06CB:  CB 94
 RES 3, H               ;; 06CD:  CB 9C
 RES 4, H               ;; 06CF:  CB A4
 RES 5, H               ;; 06D1:  CB AC
 RES 6, H               ;; 06D3:  CB B4
 RES 7, H               ;; 06D5:  CB BC
 SET 0, H               ;; 06D7:  CB C4
 SET 1, H               ;; 06D9:  CB CC
 SET 2, H               ;; 06DB:  CB D4
 SET 3, H               ;; 06DD:  CB DC
 SET 4, H               ;; 06DF:  CB E4
 SET 5, H               ;; 06E1:  CB EC
 SET 6, H               ;; 06E3:  CB F4
 SET 7, H               ;; 06E5:  CB FC
 BIT 0, L               ;; 06E7:  CB 45
 BIT 1, L               ;; 06E9:  CB 4D
 BIT 2, L               ;; 06EB:  CB 55
 BIT 3, L               ;; 06ED:  CB 5D
 BIT 4, L               ;; 06EF:  CB 65
 BIT 5, L               ;; 06F1:  CB 6D
 BIT 6, L               ;; 06F3:  CB 75
 BIT 7, L               ;; 06F5:  CB 7D
 RES 0, L               ;; 06F7:  CB 85
 RES 1, L               ;; 06F9:  CB 8D
 RES 2, L               ;; 06FB:  CB 95
 RES 3, L               ;; 06FD:  CB 9D
 RES 4, L               ;; 06FF:  CB A5
 RES 5, L               ;; 0701:  CB AD
 RES 6, L               ;; 0703:  CB B5
 RES 7, L               ;; 0705:  CB BD
 SET 0, L               ;; 0707:  CB C5
 SET 1, L               ;; 0709:  CB CD
 SET 2, L               ;; 070B:  CB D5
 SET 3, L               ;; 070D:  CB DD
 SET 4, L               ;; 070F:  CB E5
 SET 5, L               ;; 0711:  CB ED
 SET 6, L               ;; 0713:  CB F5
 SET 7, L               ;; 0715:  CB FD
 BIT 0, A               ;; 0717:  CB 47
 BIT 1, A               ;; 0719:  CB 4F
 BIT 2, A               ;; 071B:  CB 57
 BIT 3, A               ;; 071D:  CB 5F
 BIT 4, A               ;; 071F:  CB 67
 BIT 5, A               ;; 0721:  CB 6F
 BIT 6, A               ;; 0723:  CB 77
 BIT 7, A               ;; 0725:  CB 7F
 RES 0, A               ;; 0727:  CB 87
 RES 1, A               ;; 0729:  CB 8F
 RES 2, A               ;; 072B:  CB 97
 RES 3, A               ;; 072D:  CB 9F
 RES 4, A               ;; 072F:  CB A7
 RES 5, A               ;; 0731:  CB AF
 RES 6, A               ;; 0733:  CB B7
 RES 7, A               ;; 0735:  CB BF
 SET 0, A               ;; 0737:  CB C7
 SET 1, A               ;; 0739:  CB CF
 SET 2, A               ;; 073B:  CB D7
 SET 3, A               ;; 073D:  CB DF
 SET 4, A               ;; 073F:  CB E7
 SET 5, A               ;; 0741:  CB EF
 SET 6, A               ;; 0743:  CB F7
 SET 7, A               ;; 0745:  CB FF
 BIT 0, (HL)            ;; 0747:  CB 46
 BIT 1, (HL)            ;; 0749:  CB 4E
 BIT 2, (HL)            ;; 074B:  CB 56
 BIT 3, (HL)            ;; 074D:  CB 5E
 BIT 4, (HL)            ;; 074F:  CB 66
 BIT 5, (HL)            ;; 0751:  CB 6E
 BIT 6, (HL)            ;; 0753:  CB 76
 BIT 7, (HL)            ;; 0755:  CB 7E
 RES 0, (HL)            ;; 0757:  CB 86
 RES 1, (HL)            ;; 0759:  CB 8E
 RES 2, (HL)            ;; 075B:  CB 96
 RES 3, (HL)            ;; 075D:  CB 9E
 RES 4, (HL)            ;; 075F:  CB A6
 RES 5, (HL)            ;; 0761:  CB AE
 RES 6, (HL)            ;; 0763:  CB B6
 RES 7, (HL)            ;; 0765:  CB BE
 SET 0, (HL)            ;; 0767:  CB C6
 SET 1, (HL)            ;; 0769:  CB CE
 SET 2, (HL)            ;; 076B:  CB D6
 SET 3, (HL)            ;; 076D:  CB DE
 SET 4, (HL)            ;; 076F:  CB E6
 SET 5, (HL)            ;; 0771:  CB EE
 SET 6, (HL)            ;; 0773:  CB F6
 SET 7, (HL)            ;; 0775:  CB FE
 BIT 0, (IX + -128)     ;; 0777:  DD CB 80 46
 BIT 1, (IX + -128)     ;; 077B:  DD CB 80 4E
 BIT 2, (IX + -128)     ;; 077F:  DD CB 80 56
 BIT 3, (IX + -128)     ;; 0783:  DD CB 80 5E
 BIT 4, (IX + -128)     ;; 0787:  DD CB 80 66
 BIT 5, (IX + -128)     ;; 078B:  DD CB 80 6E
 BIT 6, (IX + -128)     ;; 078F:  DD CB 80 76
 BIT 7, (IX + -128)     ;; 0793:  DD CB 80 7E
 BIT 0, (IX + 0)        ;; 0797:  DD CB 00 46
 BIT 1, (IX + 0)        ;; 079B:  DD CB 00 4E
 BIT 2, (IX + 0)        ;; 079F:  DD CB 00 56
 BIT 3, (IX + 0)        ;; 07A3:  DD CB 00 5E
 BIT 4, (IX + 0)        ;; 07A7:  DD CB 00 66
 BIT 5, (IX + 0)        ;; 07AB:  DD CB 00 6E
 BIT 6, (IX + 0)        ;; 07AF:  DD CB 00 76
 BIT 7, (IX + 0)        ;; 07B3:  DD CB 00 7E
 BIT 0, (IX + 127)      ;; 07B7:  DD CB 7F 46
 BIT 1, (IX + 127)      ;; 07BB:  DD CB 7F 4E
 BIT 2, (IX + 127)      ;; 07BF:  DD CB 7F 56
 BIT 3, (IX + 127)      ;; 07C3:  DD CB 7F 5E
 BIT 4, (IX + 127)      ;; 07C7:  DD CB 7F 66
 BIT 5, (IX + 127)      ;; 07CB:  DD CB 7F 6E
 BIT 6, (IX + 127)      ;; 07CF:  DD CB 7F 76
 BIT 7, (IX + 127)      ;; 07D3:  DD CB 7F 7E
 RES 0, (IX + -128)     ;; 07D7:  DD CB 80 86
 RES 1, (IX + -128)     ;; 07DB:  DD CB 80 8E
 RES 2, (IX + -128)     ;; 07DF:  DD CB 80 96
 RES 3, (IX + -128)     ;; 07E3:  DD CB 80 9E
 RES 4, (IX + -128)     ;; 07E7:  DD CB 80 A6
 RES 5, (IX + -128)     ;; 07EB:  DD CB 80 AE
 RES 6, (IX + -128)     ;; 07EF:  DD CB 80 B6
 RES 7, (IX + -128)     ;; 07F3:  DD CB 80 BE
 RES 0, (IX + 0)        ;; 07F7:  DD CB 00 86
 RES 1, (IX + 0)        ;; 07FB:  DD CB 00 8E
 RES 2, (IX + 0)        ;; 07FF:  DD CB 00 96
 RES 3, (IX + 0)        ;; 0803:  DD CB 00 9E
 RES 4, (IX + 0)        ;; 0807:  DD CB 00 A6
 RES 5, (IX + 0)        ;; 080B:  DD CB 00 AE
 RES 6, (IX + 0)        ;; 080F:  DD CB 00 B6
 RES 7, (IX + 0)        ;; 0813:  DD CB 00 BE
 RES 0, (IX + 127)      ;; 0817:  DD CB 7F 86
 RES 1, (IX + 127)      ;; 081B:  DD CB 7F 8E
 RES 2, (IX + 127)      ;; 081F:  DD CB 7F 96
 RES 3, (IX + 127)      ;; 0823:  DD CB 7F 9E
 RES 4, (IX + 127)      ;; 0827:  DD CB 7F A6
 RES 5, (IX + 127)      ;; 082B:  DD CB 7F AE
 RES 6, (IX + 127)      ;; 082F:  DD CB 7F B6
 RES 7, (IX + 127)      ;; 0833:  DD CB 7F BE
 SET 0, (IX + -128)     ;; 0837:  DD CB 80 C6
 SET 1, (IX + -128)     ;; 083B:  DD CB 80 CE
 SET 2, (IX + -128)     ;; 083F:  DD CB 80 D6
 SET 3, (IX + -128)     ;; 0843:  DD CB 80 DE
 SET 4, (IX + -128)     ;; 0847:  DD CB 80 E6
 SET 5, (IX + -128)     ;; 084B:  DD CB 80 EE
 SET 6, (IX + -128)     ;; 084F:  DD CB 80 F6
 SET 7, (IX + -128)     ;; 0853:  DD CB 80 FE
 SET 0, (IX + 0)        ;; 0857:  DD CB 00 C6
 SET 1, (IX + 0)        ;; 085B:  DD CB 00 CE
 SET 2, (IX + 0)        ;; 085F:  DD CB 00 D6
 SET 3, (IX + 0)        ;; 0863:  DD CB 00 DE
 SET 4, (IX + 0)        ;; 0867:  DD CB 00 E6
 SET 5, (IX + 0)        ;; 086B:  DD CB 00 EE
 SET 6, (IX + 0)        ;; 086F:  DD CB 00 F6
 SET 7, (IX + 0)        ;; 0873:  DD CB 00 FE
 SET 0, (IX + 127)      ;; 0877:  DD CB 7F C6
 SET 1, (IX + 127)      ;; 087B:  DD CB 7F CE
 SET 2, (IX + 127)      ;; 087F:  DD CB 7F D6
 SET 3, (IX + 127)      ;; 0883:  DD CB 7F DE
 SET 4, (IX + 127)      ;; 0887:  DD CB 7F E6
 SET 5, (IX + 127)      ;; 088B:  DD CB 7F EE
 SET 6, (IX + 127)      ;; 088F:  DD CB 7F F6
 SET 7, (IX + 127)      ;; 0893:  DD CB 7F FE
 BIT 0, (IY + -128)     ;; 0897:  FD CB 80 46
 BIT 1, (IY + -128)     ;; 089B:  FD CB 80 4E
 BIT 2, (IY + -128)     ;; 089F:  FD CB 80 56
 BIT 3, (IY + -128)     ;; 08A3:  FD CB 80 5E
 BIT 4, (IY + -128)     ;; 08A7:  FD CB 80 66
 BIT 5, (IY + -128)     ;; 08AB:  FD CB 80 6E
 BIT 6, (IY + -128)     ;; 08AF:  FD CB 80 76
 BIT 7, (IY + -128)     ;; 08B3:  FD CB 80 7E
 BIT 0, (IY + 0)        ;; 08B7:  FD CB 00 46
 BIT 1, (IY + 0)        ;; 08BB:  FD CB 00 4E
 BIT 2, (IY + 0)        ;; 08BF:  FD CB 00 56
 BIT 3, (IY + 0)        ;; 08C3:  FD CB 00 5E
 BIT 4, (IY + 0)        ;; 08C7:  FD CB 00 66
 BIT 5, (IY + 0)        ;; 08CB:  FD CB 00 6E
 BIT 6, (IY + 0)        ;; 08CF:  FD CB 00 76
 BIT 7, (IY + 0)        ;; 08D3:  FD CB 00 7E
 BIT 0, (IY + 127)      ;; 08D7:  FD CB 7F 46
 BIT 1, (IY + 127)      ;; 08DB:  FD CB 7F 4E
 BIT 2, (IY + 127)      ;; 08DF:  FD CB 7F 56
 BIT 3, (IY + 127)      ;; 08E3:  FD CB 7F 5E
 BIT 4, (IY + 127)      ;; 08E7:  FD CB 7F 66
 BIT 5, (IY + 127)      ;; 08EB:  FD CB 7F 6E
 BIT 6, (IY + 127)      ;; 08EF:  FD CB 7F 76
 BIT 7, (IY + 127)      ;; 08F3:  FD CB 7F 7E
 RES 0, (IY + -128)     ;; 08F7:  FD CB 80 86
 RES 1, (IY + -128)     ;; 08FB:  FD CB 80 8E
 RES 2, (IY + -128)     ;; 08FF:  FD CB 80 96
 RES 3, (IY + -128)     ;; 0903:  FD CB 80 9E
 RES 4, (IY + -128)     ;; 0907:  FD CB 80 A6
 RES 5, (IY + -128)     ;; 090B:  FD CB 80 AE
 RES 6, (IY + -128)     ;; 090F:  FD CB 80 B6
 RES 7, (IY + -128)     ;; 0913:  FD CB 80 BE
 RES 0, (IY + 0)        ;; 0917:  FD CB 00 86
 RES 1, (IY + 0)        ;; 091B:  FD CB 00 8E
 RES 2, (IY + 0)        ;; 091F:  FD CB 00 96
 RES 3, (IY + 0)        ;; 0923:  FD CB 00 9E
 RES 4, (IY + 0)        ;; 0927:  FD CB 00 A6
 RES 5, (IY + 0)        ;; 092B:  FD CB 00 AE
 RES 6, (IY + 0)        ;; 092F:  FD CB 00 B6
 RES 7, (IY + 0)        ;; 0933:  FD CB 00 BE
 RES 0, (IY + 127)      ;; 0937:  FD CB 7F 86
 RES 1, (IY + 127)      ;; 093B:  FD CB 7F 8E
 RES 2, (IY + 127)      ;; 093F:  FD CB 7F 96
 RES 3, (IY + 127)      ;; 0943:  FD CB 7F 9E
 RES 4, (IY + 127)      ;; 0947:  FD CB 7F A6
 RES 5, (IY + 127)      ;; 094B:  FD CB 7F AE
 RES 6, (IY + 127)      ;; 094F:  FD CB 7F B6
 RES 7, (IY + 127)      ;; 0953:  FD CB 7F BE
 SET 0, (IY + -128)     ;; 0957:  FD CB 80 C6
 SET 1, (IY + -128)     ;; 095B:  FD CB 80 CE
 SET 2, (IY + -128)     ;; 095F:  FD CB 80 D6
 SET 3, (IY + -128)     ;; 0963:  FD CB 80 DE
 SET 4, (IY + -128)     ;; 0967:  FD CB 80 E6
 SET 5, (IY + -128)     ;; 096B:  FD CB 80 EE
 SET 6, (IY + -128)     ;; 096F:  FD CB 80 F6
 SET 7, (IY + -128)     ;; 0973:  FD CB 80 FE
 SET 0, (IY + 0)        ;; 0977:  FD CB 00 C6
 SET 1, (IY + 0)        ;; 097B:  FD CB 00 CE
 SET 2, (IY + 0)        ;; 097F:  FD CB 00 D6
 SET 3, (IY + 0)        ;; 0983:  FD CB 00 DE
 SET 4, (IY + 0)        ;; 0987:  FD CB 00 E6
 SET 5, (IY + 0)        ;; 098B:  FD CB 00 EE
 SET 6, (IY + 0)        ;; 098F:  FD CB 00 F6
 SET 7, (IY + 0)        ;; 0993:  FD CB 00 FE
 SET 0, (IY + 127)      ;; 0997:  FD CB 7F C6
 SET 1, (IY + 127)      ;; 099B:  FD CB 7F CE
 SET 2, (IY + 127)      ;; 099F:  FD CB 7F D6
 SET 3, (IY + 127)      ;; 09A3:  FD CB 7F DE
 SET 4, (IY + 127)      ;; 09A7:  FD CB 7F E6
 SET 5, (IY + 127)      ;; 09AB:  FD CB 7F EE
 SET 6, (IY + 127)      ;; 09AF:  FD CB 7F F6
 SET 7, (IY + 127)      ;; 09B3:  FD CB 7F FE
 JP 0                   ;; 09B7:  C3 00 00
 JP 4660                ;; 09BA:  C3 34 12
 JP 52719               ;; 09BD:  C3 EF CD
 JP 65535               ;; 09C0:  C3 FF FF
 JP NZ, 0               ;; 09C3:  C2 00 00
 JP NZ, 4660            ;; 09C6:  C2 34 12
 JP NZ, 52719           ;; 09C9:  C2 EF CD
 JP NZ, 65535           ;; 09CC:  C2 FF FF
 JP Z, 0                ;; 09CF:  CA 00 00
 JP Z, 4660             ;; 09D2:  CA 34 12
 JP Z, 52719            ;; 09D5:  CA EF CD
 JP Z, 65535            ;; 09D8:  CA FF FF
 JP NC, 0               ;; 09DB:  D2 00 00
 JP NC, 4660            ;; 09DE:  D2 34 12
 JP NC, 52719           ;; 09E1:  D2 EF CD
 JP NC, 65535           ;; 09E4:  D2 FF FF
 JP C, 0                ;; 09E7:  DA 00 00
 JP C, 4660             ;; 09EA:  DA 34 12
 JP C, 52719            ;; 09ED:  DA EF CD
 JP C, 65535            ;; 09F0:  DA FF FF
 JP PO, 0               ;; 09F3:  E2 00 00
 JP PO, 4660            ;; 09F6:  E2 34 12
 JP PO, 52719           ;; 09F9:  E2 EF CD
 JP PO, 65535           ;; 09FC:  E2 FF FF
 JP PE, 0               ;; 09FF:  EA 00 00
 JP PE, 4660            ;; 0A02:  EA 34 12
 JP PE, 52719           ;; 0A05:  EA EF CD
 JP PE, 65535           ;; 0A08:  EA FF FF
 JP P, 0                ;; 0A0B:  F2 00 00
 JP P, 4660             ;; 0A0E:  F2 34 12
 JP P, 52719            ;; 0A11:  F2 EF CD
 JP P, 65535            ;; 0A14:  F2 FF FF
 JP M, 0                ;; 0A17:  FA 00 00
 JP M, 4660             ;; 0A1A:  FA 34 12
 JP M, 52719            ;; 0A1D:  FA EF CD
 JP M, 65535            ;; 0A20:  FA FF FF
 JP LZ, 0               ;; 0A23:  E2 00 00
 JP LZ, 4660            ;; 0A26:  E2 34 12
 JP LZ, 52719           ;; 0A29:  E2 EF CD
 JP LZ, 65535           ;; 0A2C:  E2 FF FF
 JP LO, 0               ;; 0A2F:  EA 00 00
 JP LO, 4660            ;; 0A32:  EA 34 12
 JP LO, 52719           ;; 0A35:  EA EF CD
 JP LO, 65535           ;; 0A38:  EA FF FF
 JR ASMPC+2             ;; 0A3B:  18 00
 JR NZ, ASMPC+2         ;; 0A3D:  20 00
 JR Z, ASMPC+2          ;; 0A3F:  28 00
 JR NC, ASMPC+2         ;; 0A41:  30 00
 JR C, ASMPC+2          ;; 0A43:  38 00
 JP (HL)                ;; 0A45:  E9
 JP (IX)                ;; 0A46:  DD E9
 JP (IY)                ;; 0A48:  FD E9
 DJNZ ASMPC+2           ;; 0A4A:  10 00
 CALL 0                 ;; 0A4C:  CD 00 00
 CALL 4660              ;; 0A4F:  CD 34 12
 CALL 52719             ;; 0A52:  CD EF CD
 CALL 65535             ;; 0A55:  CD FF FF
 RET                    ;; 0A58:  C9
 RET NZ                 ;; 0A59:  C0
 RET Z                  ;; 0A5A:  C8
 RET NC                 ;; 0A5B:  D0
 RET C                  ;; 0A5C:  D8
 RET PO                 ;; 0A5D:  E0
 RET PE                 ;; 0A5E:  E8
 RET P                  ;; 0A5F:  F0
 RET M                  ;; 0A60:  F8
 RET LZ                 ;; 0A61:  E0
 RET LO                 ;; 0A62:  E8
 RST 16                 ;; 0A63:  D7
 RST 24                 ;; 0A64:  DF
 RST 32                 ;; 0A65:  E7
 RST 40                 ;; 0A66:  EF
 RST 56                 ;; 0A67:  FF
 IOE                    ;; 0A68:  DB
 IOI                    ;; 0A69:  D3
 IPSET 0                ;; 0A6A:  ED 46
 IPSET 1                ;; 0A6C:  ED 56
 IPSET 2                ;; 0A6E:  ED 4E
 IPSET 3                ;; 0A70:  ED 5E
 IPRES                  ;; 0A72:  ED 5D
 LD IIR, A              ;; 0A74:  ED 47
 LD A, IIR              ;; 0A76:  ED 57
 LD EIR, A              ;; 0A78:  ED 4F
 LD A, EIR              ;; 0A7A:  ED 5F
 RETI                   ;; 0A7C:  ED 4D
