 ld b, 0                ;; 0000:  06 00
 ld b, 85               ;; 0002:  06 55
 ld b, 170              ;; 0004:  06 AA
 ld b, 255              ;; 0006:  06 FF
 ld c, 0                ;; 0008:  0E 00
 ld c, 85               ;; 000A:  0E 55
 ld c, 170              ;; 000C:  0E AA
 ld c, 255              ;; 000E:  0E FF
 ld d, 0                ;; 0010:  16 00
 ld d, 85               ;; 0012:  16 55
 ld d, 170              ;; 0014:  16 AA
 ld d, 255              ;; 0016:  16 FF
 ld e, 0                ;; 0018:  1E 00
 ld e, 85               ;; 001A:  1E 55
 ld e, 170              ;; 001C:  1E AA
 ld e, 255              ;; 001E:  1E FF
 ld h, 0                ;; 0020:  26 00
 ld h, 85               ;; 0022:  26 55
 ld h, 170              ;; 0024:  26 AA
 ld h, 255              ;; 0026:  26 FF
 ld l, 0                ;; 0028:  2E 00
 ld l, 85               ;; 002A:  2E 55
 ld l, 170              ;; 002C:  2E AA
 ld l, 255              ;; 002E:  2E FF
 ld a, 0                ;; 0030:  3E 00
 ld a, 85               ;; 0032:  3E 55
 ld a, 170              ;; 0034:  3E AA
 ld a, 255              ;; 0036:  3E FF
 ld b', 0               ;; 0038:  76 06 00
 ld b', 85              ;; 003B:  76 06 55
 ld b', 170             ;; 003E:  76 06 AA
 ld b', 255             ;; 0041:  76 06 FF
 ld c', 0               ;; 0044:  76 0E 00
 ld c', 85              ;; 0047:  76 0E 55
 ld c', 170             ;; 004A:  76 0E AA
 ld c', 255             ;; 004D:  76 0E FF
 ld d', 0               ;; 0050:  76 16 00
 ld d', 85              ;; 0053:  76 16 55
 ld d', 170             ;; 0056:  76 16 AA
 ld d', 255             ;; 0059:  76 16 FF
 ld e', 0               ;; 005C:  76 1E 00
 ld e', 85              ;; 005F:  76 1E 55
 ld e', 170             ;; 0062:  76 1E AA
 ld e', 255             ;; 0065:  76 1E FF
 ld h', 0               ;; 0068:  76 26 00
 ld h', 85              ;; 006B:  76 26 55
 ld h', 170             ;; 006E:  76 26 AA
 ld h', 255             ;; 0071:  76 26 FF
 ld l', 0               ;; 0074:  76 2E 00
 ld l', 85              ;; 0077:  76 2E 55
 ld l', 170             ;; 007A:  76 2E AA
 ld l', 255             ;; 007D:  76 2E FF
 ld a', 0               ;; 0080:  76 3E 00
 ld a', 85              ;; 0083:  76 3E 55
 ld a', 170             ;; 0086:  76 3E AA
 ld a', 255             ;; 0089:  76 3E FF
 ld b, (hl)             ;; 008C:  46
 ld c, (hl)             ;; 008D:  4E
 ld d, (hl)             ;; 008E:  56
 ld e, (hl)             ;; 008F:  5E
 ld h, (hl)             ;; 0090:  66
 ld l, (hl)             ;; 0091:  6E
 ld a, (hl)             ;; 0092:  7E
 ld b', (hl)            ;; 0093:  76 46
 ld c', (hl)            ;; 0095:  76 4E
 ld d', (hl)            ;; 0097:  76 56
 ld e', (hl)            ;; 0099:  76 5E
 ld h', (hl)            ;; 009B:  76 66
 ld l', (hl)            ;; 009D:  76 6E
 ld a', (hl)            ;; 009F:  76 7E
 ld b, (ix + -128)      ;; 00A1:  DD 46 80
 ld b, (ix)             ;; 00A4:  DD 46 00
 ld b, (ix + 127)       ;; 00A7:  DD 46 7F
 ld c, (ix + -128)      ;; 00AA:  DD 4E 80
 ld c, (ix)             ;; 00AD:  DD 4E 00
 ld c, (ix + 127)       ;; 00B0:  DD 4E 7F
 ld d, (ix + -128)      ;; 00B3:  DD 56 80
 ld d, (ix)             ;; 00B6:  DD 56 00
 ld d, (ix + 127)       ;; 00B9:  DD 56 7F
 ld e, (ix + -128)      ;; 00BC:  DD 5E 80
 ld e, (ix)             ;; 00BF:  DD 5E 00
 ld e, (ix + 127)       ;; 00C2:  DD 5E 7F
 ld h, (ix + -128)      ;; 00C5:  DD 66 80
 ld h, (ix)             ;; 00C8:  DD 66 00
 ld h, (ix + 127)       ;; 00CB:  DD 66 7F
 ld l, (ix + -128)      ;; 00CE:  DD 6E 80
 ld l, (ix)             ;; 00D1:  DD 6E 00
 ld l, (ix + 127)       ;; 00D4:  DD 6E 7F
 ld a, (ix + -128)      ;; 00D7:  DD 7E 80
 ld a, (ix)             ;; 00DA:  DD 7E 00
 ld a, (ix + 127)       ;; 00DD:  DD 7E 7F
 ld b', (ix + -128)     ;; 00E0:  76 DD 46 80
 ld b', (ix)            ;; 00E4:  76 DD 46 00
 ld b', (ix + 127)      ;; 00E8:  76 DD 46 7F
 ld c', (ix + -128)     ;; 00EC:  76 DD 4E 80
 ld c', (ix)            ;; 00F0:  76 DD 4E 00
 ld c', (ix + 127)      ;; 00F4:  76 DD 4E 7F
 ld d', (ix + -128)     ;; 00F8:  76 DD 56 80
 ld d', (ix)            ;; 00FC:  76 DD 56 00
 ld d', (ix + 127)      ;; 0100:  76 DD 56 7F
 ld e', (ix + -128)     ;; 0104:  76 DD 5E 80
 ld e', (ix)            ;; 0108:  76 DD 5E 00
 ld e', (ix + 127)      ;; 010C:  76 DD 5E 7F
 ld h', (ix + -128)     ;; 0110:  76 DD 66 80
 ld h', (ix)            ;; 0114:  76 DD 66 00
 ld h', (ix + 127)      ;; 0118:  76 DD 66 7F
 ld l', (ix + -128)     ;; 011C:  76 DD 6E 80
 ld l', (ix)            ;; 0120:  76 DD 6E 00
 ld l', (ix + 127)      ;; 0124:  76 DD 6E 7F
 ld a', (ix + -128)     ;; 0128:  76 DD 7E 80
 ld a', (ix)            ;; 012C:  76 DD 7E 00
 ld a', (ix + 127)      ;; 0130:  76 DD 7E 7F
 ld b, (iy + -128)      ;; 0134:  FD 46 80
 ld b, (iy)             ;; 0137:  FD 46 00
 ld b, (iy + 127)       ;; 013A:  FD 46 7F
 ld c, (iy + -128)      ;; 013D:  FD 4E 80
 ld c, (iy)             ;; 0140:  FD 4E 00
 ld c, (iy + 127)       ;; 0143:  FD 4E 7F
 ld d, (iy + -128)      ;; 0146:  FD 56 80
 ld d, (iy)             ;; 0149:  FD 56 00
 ld d, (iy + 127)       ;; 014C:  FD 56 7F
 ld e, (iy + -128)      ;; 014F:  FD 5E 80
 ld e, (iy)             ;; 0152:  FD 5E 00
 ld e, (iy + 127)       ;; 0155:  FD 5E 7F
 ld h, (iy + -128)      ;; 0158:  FD 66 80
 ld h, (iy)             ;; 015B:  FD 66 00
 ld h, (iy + 127)       ;; 015E:  FD 66 7F
 ld l, (iy + -128)      ;; 0161:  FD 6E 80
 ld l, (iy)             ;; 0164:  FD 6E 00
 ld l, (iy + 127)       ;; 0167:  FD 6E 7F
 ld a, (iy + -128)      ;; 016A:  FD 7E 80
 ld a, (iy)             ;; 016D:  FD 7E 00
 ld a, (iy + 127)       ;; 0170:  FD 7E 7F
 ld b', (iy + -128)     ;; 0173:  76 FD 46 80
 ld b', (iy)            ;; 0177:  76 FD 46 00
 ld b', (iy + 127)      ;; 017B:  76 FD 46 7F
 ld c', (iy + -128)     ;; 017F:  76 FD 4E 80
 ld c', (iy)            ;; 0183:  76 FD 4E 00
 ld c', (iy + 127)      ;; 0187:  76 FD 4E 7F
 ld d', (iy + -128)     ;; 018B:  76 FD 56 80
 ld d', (iy)            ;; 018F:  76 FD 56 00
 ld d', (iy + 127)      ;; 0193:  76 FD 56 7F
 ld e', (iy + -128)     ;; 0197:  76 FD 5E 80
 ld e', (iy)            ;; 019B:  76 FD 5E 00
 ld e', (iy + 127)      ;; 019F:  76 FD 5E 7F
 ld h', (iy + -128)     ;; 01A3:  76 FD 66 80
 ld h', (iy)            ;; 01A7:  76 FD 66 00
 ld h', (iy + 127)      ;; 01AB:  76 FD 66 7F
 ld l', (iy + -128)     ;; 01AF:  76 FD 6E 80
 ld l', (iy)            ;; 01B3:  76 FD 6E 00
 ld l', (iy + 127)      ;; 01B7:  76 FD 6E 7F
 ld a', (iy + -128)     ;; 01BB:  76 FD 7E 80
 ld a', (iy)            ;; 01BF:  76 FD 7E 00
 ld a', (iy + 127)      ;; 01C3:  76 FD 7E 7F
 ld (hl), b             ;; 01C7:  70
 ld (hl), c             ;; 01C8:  71
 ld (hl), d             ;; 01C9:  72
 ld (hl), e             ;; 01CA:  73
 ld (hl), h             ;; 01CB:  74
 ld (hl), l             ;; 01CC:  75
 ld (hl), a             ;; 01CD:  77
 ld (ix + -128), b      ;; 01CE:  DD 70 80
 ld (ix), b             ;; 01D1:  DD 70 00
 ld (ix + 127), b       ;; 01D4:  DD 70 7F
 ld (ix + -128), c      ;; 01D7:  DD 71 80
 ld (ix), c             ;; 01DA:  DD 71 00
 ld (ix + 127), c       ;; 01DD:  DD 71 7F
 ld (ix + -128), d      ;; 01E0:  DD 72 80
 ld (ix), d             ;; 01E3:  DD 72 00
 ld (ix + 127), d       ;; 01E6:  DD 72 7F
 ld (ix + -128), e      ;; 01E9:  DD 73 80
 ld (ix), e             ;; 01EC:  DD 73 00
 ld (ix + 127), e       ;; 01EF:  DD 73 7F
 ld (ix + -128), h      ;; 01F2:  DD 74 80
 ld (ix), h             ;; 01F5:  DD 74 00
 ld (ix + 127), h       ;; 01F8:  DD 74 7F
 ld (ix + -128), l      ;; 01FB:  DD 75 80
 ld (ix), l             ;; 01FE:  DD 75 00
 ld (ix + 127), l       ;; 0201:  DD 75 7F
 ld (ix + -128), a      ;; 0204:  DD 77 80
 ld (ix), a             ;; 0207:  DD 77 00
 ld (ix + 127), a       ;; 020A:  DD 77 7F
 ld (iy + -128), b      ;; 020D:  FD 70 80
 ld (iy), b             ;; 0210:  FD 70 00
 ld (iy + 127), b       ;; 0213:  FD 70 7F
 ld (iy + -128), c      ;; 0216:  FD 71 80
 ld (iy), c             ;; 0219:  FD 71 00
 ld (iy + 127), c       ;; 021C:  FD 71 7F
 ld (iy + -128), d      ;; 021F:  FD 72 80
 ld (iy), d             ;; 0222:  FD 72 00
 ld (iy + 127), d       ;; 0225:  FD 72 7F
 ld (iy + -128), e      ;; 0228:  FD 73 80
 ld (iy), e             ;; 022B:  FD 73 00
 ld (iy + 127), e       ;; 022E:  FD 73 7F
 ld (iy + -128), h      ;; 0231:  FD 74 80
 ld (iy), h             ;; 0234:  FD 74 00
 ld (iy + 127), h       ;; 0237:  FD 74 7F
 ld (iy + -128), l      ;; 023A:  FD 75 80
 ld (iy), l             ;; 023D:  FD 75 00
 ld (iy + 127), l       ;; 0240:  FD 75 7F
 ld (iy + -128), a      ;; 0243:  FD 77 80
 ld (iy), a             ;; 0246:  FD 77 00
 ld (iy + 127), a       ;; 0249:  FD 77 7F
 ld (hl), 0             ;; 024C:  36 00
 ld (hl), 85            ;; 024E:  36 55
 ld (hl), 170           ;; 0250:  36 AA
 ld (hl), 255           ;; 0252:  36 FF
 ld (ix + -128), 0      ;; 0254:  DD 36 80 00
 ld (ix), 0             ;; 0258:  DD 36 00 00
 ld (ix + 127), 0       ;; 025C:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0260:  DD 36 80 55
 ld (ix), 85            ;; 0264:  DD 36 00 55
 ld (ix + 127), 85      ;; 0268:  DD 36 7F 55
 ld (ix + -128), 170    ;; 026C:  DD 36 80 AA
 ld (ix), 170           ;; 0270:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0274:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0278:  DD 36 80 FF
 ld (ix), 255           ;; 027C:  DD 36 00 FF
 ld (ix + 127), 255     ;; 0280:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0284:  FD 36 80 00
 ld (iy), 0             ;; 0288:  FD 36 00 00
 ld (iy + 127), 0       ;; 028C:  FD 36 7F 00
 ld (iy + -128), 85     ;; 0290:  FD 36 80 55
 ld (iy), 85            ;; 0294:  FD 36 00 55
 ld (iy + 127), 85      ;; 0298:  FD 36 7F 55
 ld (iy + -128), 170    ;; 029C:  FD 36 80 AA
 ld (iy), 170           ;; 02A0:  FD 36 00 AA
 ld (iy + 127), 170     ;; 02A4:  FD 36 7F AA
 ld (iy + -128), 255    ;; 02A8:  FD 36 80 FF
 ld (iy), 255           ;; 02AC:  FD 36 00 FF
 ld (iy + 127), 255     ;; 02B0:  FD 36 7F FF
 ld a, (bc)             ;; 02B4:  0A
 ld a, (de)             ;; 02B5:  1A
 ld a', (bc)            ;; 02B6:  76 0A
 ld a', (de)            ;; 02B8:  76 1A
 ld (bc), a             ;; 02BA:  02
 ld (de), a             ;; 02BB:  12
 ld a, (0)              ;; 02BC:  3A 00 00
 ld a, (291)            ;; 02BF:  3A 23 01
 ld a, (17767)          ;; 02C2:  3A 67 45
 ld a, (35243)          ;; 02C5:  3A AB 89
 ld a, (52719)          ;; 02C8:  3A EF CD
 ld a, (65535)          ;; 02CB:  3A FF FF
 ld a', (0)             ;; 02CE:  76 3A 00 00
 ld a', (291)           ;; 02D2:  76 3A 23 01
 ld a', (17767)         ;; 02D6:  76 3A 67 45
 ld a', (35243)         ;; 02DA:  76 3A AB 89
 ld a', (52719)         ;; 02DE:  76 3A EF CD
 ld a', (65535)         ;; 02E2:  76 3A FF FF
 ld (0), a              ;; 02E6:  32 00 00
 ld (291), a            ;; 02E9:  32 23 01
 ld (17767), a          ;; 02EC:  32 67 45
 ld (35243), a          ;; 02EF:  32 AB 89
 ld (52719), a          ;; 02F2:  32 EF CD
 ld (65535), a          ;; 02F5:  32 FF FF
 add a, b               ;; 02F8:  80
 add a, c               ;; 02F9:  81
 add a, d               ;; 02FA:  82
 add a, e               ;; 02FB:  83
 add a, h               ;; 02FC:  84
 add a, l               ;; 02FD:  85
 add a, (hl)            ;; 02FE:  86
 add a, a               ;; 02FF:  87
 adc a, b               ;; 0300:  88
 adc a, c               ;; 0301:  89
 adc a, d               ;; 0302:  8A
 adc a, e               ;; 0303:  8B
 adc a, h               ;; 0304:  8C
 adc a, l               ;; 0305:  8D
 adc a, (hl)            ;; 0306:  8E
 adc a, a               ;; 0307:  8F
 sub a, b               ;; 0308:  90
 sub a, c               ;; 0309:  91
 sub a, d               ;; 030A:  92
 sub a, e               ;; 030B:  93
 sub a, h               ;; 030C:  94
 sub a, l               ;; 030D:  95
 sub a, (hl)            ;; 030E:  96
 sub a, a               ;; 030F:  97
 sbc a, b               ;; 0310:  98
 sbc a, c               ;; 0311:  99
 sbc a, d               ;; 0312:  9A
 sbc a, e               ;; 0313:  9B
 sbc a, h               ;; 0314:  9C
 sbc a, l               ;; 0315:  9D
 sbc a, (hl)            ;; 0316:  9E
 sbc a, a               ;; 0317:  9F
 and a, b               ;; 0318:  A0
 and a, c               ;; 0319:  A1
 and a, d               ;; 031A:  A2
 and a, e               ;; 031B:  A3
 and a, h               ;; 031C:  A4
 and a, l               ;; 031D:  A5
 and a, (hl)            ;; 031E:  A6
 and a, a               ;; 031F:  A7
 xor a, b               ;; 0320:  A8
 xor a, c               ;; 0321:  A9
 xor a, d               ;; 0322:  AA
 xor a, e               ;; 0323:  AB
 xor a, h               ;; 0324:  AC
 xor a, l               ;; 0325:  AD
 xor a, (hl)            ;; 0326:  AE
 xor a, a               ;; 0327:  AF
 or a, b                ;; 0328:  B0
 or a, c                ;; 0329:  B1
 or a, d                ;; 032A:  B2
 or a, e                ;; 032B:  B3
 or a, h                ;; 032C:  B4
 or a, l                ;; 032D:  B5
 or a, (hl)             ;; 032E:  B6
 or a, a                ;; 032F:  B7
 cp a, b                ;; 0330:  B8
 cp a, c                ;; 0331:  B9
 cp a, d                ;; 0332:  BA
 cp a, e                ;; 0333:  BB
 cp a, h                ;; 0334:  BC
 cp a, l                ;; 0335:  BD
 cp a, (hl)             ;; 0336:  BE
 cp a, a                ;; 0337:  BF
 add b                  ;; 0338:  80
 add c                  ;; 0339:  81
 add d                  ;; 033A:  82
 add e                  ;; 033B:  83
 add h                  ;; 033C:  84
 add l                  ;; 033D:  85
 add (hl)               ;; 033E:  86
 add a                  ;; 033F:  87
 adc b                  ;; 0340:  88
 adc c                  ;; 0341:  89
 adc d                  ;; 0342:  8A
 adc e                  ;; 0343:  8B
 adc h                  ;; 0344:  8C
 adc l                  ;; 0345:  8D
 adc (hl)               ;; 0346:  8E
 adc a                  ;; 0347:  8F
 sub b                  ;; 0348:  90
 sub c                  ;; 0349:  91
 sub d                  ;; 034A:  92
 sub e                  ;; 034B:  93
 sub h                  ;; 034C:  94
 sub l                  ;; 034D:  95
 sub (hl)               ;; 034E:  96
 sub a                  ;; 034F:  97
 sbc b                  ;; 0350:  98
 sbc c                  ;; 0351:  99
 sbc d                  ;; 0352:  9A
 sbc e                  ;; 0353:  9B
 sbc h                  ;; 0354:  9C
 sbc l                  ;; 0355:  9D
 sbc (hl)               ;; 0356:  9E
 sbc a                  ;; 0357:  9F
 and b                  ;; 0358:  A0
 and c                  ;; 0359:  A1
 and d                  ;; 035A:  A2
 and e                  ;; 035B:  A3
 and h                  ;; 035C:  A4
 and l                  ;; 035D:  A5
 and (hl)               ;; 035E:  A6
 and a                  ;; 035F:  A7
 xor b                  ;; 0360:  A8
 xor c                  ;; 0361:  A9
 xor d                  ;; 0362:  AA
 xor e                  ;; 0363:  AB
 xor h                  ;; 0364:  AC
 xor l                  ;; 0365:  AD
 xor (hl)               ;; 0366:  AE
 xor a                  ;; 0367:  AF
 or b                   ;; 0368:  B0
 or c                   ;; 0369:  B1
 or d                   ;; 036A:  B2
 or e                   ;; 036B:  B3
 or h                   ;; 036C:  B4
 or l                   ;; 036D:  B5
 or (hl)                ;; 036E:  B6
 or a                   ;; 036F:  B7
 cp b                   ;; 0370:  B8
 cp c                   ;; 0371:  B9
 cp d                   ;; 0372:  BA
 cp e                   ;; 0373:  BB
 cp h                   ;; 0374:  BC
 cp l                   ;; 0375:  BD
 cp (hl)                ;; 0376:  BE
 cp a                   ;; 0377:  BF
 add a, (ix+-128)       ;; 0378:  DD 86 80
 add a, (ix)            ;; 037B:  DD 86 00
 add a, (ix+127)        ;; 037E:  DD 86 7F
 adc a, (ix+-128)       ;; 0381:  DD 8E 80
 adc a, (ix)            ;; 0384:  DD 8E 00
 adc a, (ix+127)        ;; 0387:  DD 8E 7F
 sub a, (ix+-128)       ;; 038A:  DD 96 80
 sub a, (ix)            ;; 038D:  DD 96 00
 sub a, (ix+127)        ;; 0390:  DD 96 7F
 sbc a, (ix+-128)       ;; 0393:  DD 9E 80
 sbc a, (ix)            ;; 0396:  DD 9E 00
 sbc a, (ix+127)        ;; 0399:  DD 9E 7F
 and a, (ix+-128)       ;; 039C:  DD A6 80
 and a, (ix)            ;; 039F:  DD A6 00
 and a, (ix+127)        ;; 03A2:  DD A6 7F
 xor a, (ix+-128)       ;; 03A5:  DD AE 80
 xor a, (ix)            ;; 03A8:  DD AE 00
 xor a, (ix+127)        ;; 03AB:  DD AE 7F
 or a, (ix+-128)        ;; 03AE:  DD B6 80
 or a, (ix)             ;; 03B1:  DD B6 00
 or a, (ix+127)         ;; 03B4:  DD B6 7F
 cp a, (ix+-128)        ;; 03B7:  DD BE 80
 cp a, (ix)             ;; 03BA:  DD BE 00
 cp a, (ix+127)         ;; 03BD:  DD BE 7F
 add (ix+-128)          ;; 03C0:  DD 86 80
 add (ix)               ;; 03C3:  DD 86 00
 add (ix+127)           ;; 03C6:  DD 86 7F
 adc (ix+-128)          ;; 03C9:  DD 8E 80
 adc (ix)               ;; 03CC:  DD 8E 00
 adc (ix+127)           ;; 03CF:  DD 8E 7F
 sub (ix+-128)          ;; 03D2:  DD 96 80
 sub (ix)               ;; 03D5:  DD 96 00
 sub (ix+127)           ;; 03D8:  DD 96 7F
 sbc (ix+-128)          ;; 03DB:  DD 9E 80
 sbc (ix)               ;; 03DE:  DD 9E 00
 sbc (ix+127)           ;; 03E1:  DD 9E 7F
 and (ix+-128)          ;; 03E4:  DD A6 80
 and (ix)               ;; 03E7:  DD A6 00
 and (ix+127)           ;; 03EA:  DD A6 7F
 xor (ix+-128)          ;; 03ED:  DD AE 80
 xor (ix)               ;; 03F0:  DD AE 00
 xor (ix+127)           ;; 03F3:  DD AE 7F
 or (ix+-128)           ;; 03F6:  DD B6 80
 or (ix)                ;; 03F9:  DD B6 00
 or (ix+127)            ;; 03FC:  DD B6 7F
 cp (ix+-128)           ;; 03FF:  DD BE 80
 cp (ix)                ;; 0402:  DD BE 00
 cp (ix+127)            ;; 0405:  DD BE 7F
 add a, (iy+-128)       ;; 0408:  FD 86 80
 add a, (iy)            ;; 040B:  FD 86 00
 add a, (iy+127)        ;; 040E:  FD 86 7F
 adc a, (iy+-128)       ;; 0411:  FD 8E 80
 adc a, (iy)            ;; 0414:  FD 8E 00
 adc a, (iy+127)        ;; 0417:  FD 8E 7F
 sub a, (iy+-128)       ;; 041A:  FD 96 80
 sub a, (iy)            ;; 041D:  FD 96 00
 sub a, (iy+127)        ;; 0420:  FD 96 7F
 sbc a, (iy+-128)       ;; 0423:  FD 9E 80
 sbc a, (iy)            ;; 0426:  FD 9E 00
 sbc a, (iy+127)        ;; 0429:  FD 9E 7F
 and a, (iy+-128)       ;; 042C:  FD A6 80
 and a, (iy)            ;; 042F:  FD A6 00
 and a, (iy+127)        ;; 0432:  FD A6 7F
 xor a, (iy+-128)       ;; 0435:  FD AE 80
 xor a, (iy)            ;; 0438:  FD AE 00
 xor a, (iy+127)        ;; 043B:  FD AE 7F
 or a, (iy+-128)        ;; 043E:  FD B6 80
 or a, (iy)             ;; 0441:  FD B6 00
 or a, (iy+127)         ;; 0444:  FD B6 7F
 cp a, (iy+-128)        ;; 0447:  FD BE 80
 cp a, (iy)             ;; 044A:  FD BE 00
 cp a, (iy+127)         ;; 044D:  FD BE 7F
 add (iy+-128)          ;; 0450:  FD 86 80
 add (iy)               ;; 0453:  FD 86 00
 add (iy+127)           ;; 0456:  FD 86 7F
 adc (iy+-128)          ;; 0459:  FD 8E 80
 adc (iy)               ;; 045C:  FD 8E 00
 adc (iy+127)           ;; 045F:  FD 8E 7F
 sub (iy+-128)          ;; 0462:  FD 96 80
 sub (iy)               ;; 0465:  FD 96 00
 sub (iy+127)           ;; 0468:  FD 96 7F
 sbc (iy+-128)          ;; 046B:  FD 9E 80
 sbc (iy)               ;; 046E:  FD 9E 00
 sbc (iy+127)           ;; 0471:  FD 9E 7F
 and (iy+-128)          ;; 0474:  FD A6 80
 and (iy)               ;; 0477:  FD A6 00
 and (iy+127)           ;; 047A:  FD A6 7F
 xor (iy+-128)          ;; 047D:  FD AE 80
 xor (iy)               ;; 0480:  FD AE 00
 xor (iy+127)           ;; 0483:  FD AE 7F
 or (iy+-128)           ;; 0486:  FD B6 80
 or (iy)                ;; 0489:  FD B6 00
 or (iy+127)            ;; 048C:  FD B6 7F
 cp (iy+-128)           ;; 048F:  FD BE 80
 cp (iy)                ;; 0492:  FD BE 00
 cp (iy+127)            ;; 0495:  FD BE 7F
 add a, 0               ;; 0498:  C6 00
 add a, 85              ;; 049A:  C6 55
 add a, 170             ;; 049C:  C6 AA
 add a, 255             ;; 049E:  C6 FF
 adc a, 0               ;; 04A0:  CE 00
 adc a, 85              ;; 04A2:  CE 55
 adc a, 170             ;; 04A4:  CE AA
 adc a, 255             ;; 04A6:  CE FF
 sub a, 0               ;; 04A8:  D6 00
 sub a, 85              ;; 04AA:  D6 55
 sub a, 170             ;; 04AC:  D6 AA
 sub a, 255             ;; 04AE:  D6 FF
 sbc a, 0               ;; 04B0:  DE 00
 sbc a, 85              ;; 04B2:  DE 55
 sbc a, 170             ;; 04B4:  DE AA
 sbc a, 255             ;; 04B6:  DE FF
 and a, 0               ;; 04B8:  E6 00
 and a, 85              ;; 04BA:  E6 55
 and a, 170             ;; 04BC:  E6 AA
 and a, 255             ;; 04BE:  E6 FF
 xor a, 0               ;; 04C0:  EE 00
 xor a, 85              ;; 04C2:  EE 55
 xor a, 170             ;; 04C4:  EE AA
 xor a, 255             ;; 04C6:  EE FF
 or a, 0                ;; 04C8:  F6 00
 or a, 85               ;; 04CA:  F6 55
 or a, 170              ;; 04CC:  F6 AA
 or a, 255              ;; 04CE:  F6 FF
 cp a, 0                ;; 04D0:  FE 00
 cp a, 85               ;; 04D2:  FE 55
 cp a, 170              ;; 04D4:  FE AA
 cp a, 255              ;; 04D6:  FE FF
 add 0                  ;; 04D8:  C6 00
 add 85                 ;; 04DA:  C6 55
 add 170                ;; 04DC:  C6 AA
 add 255                ;; 04DE:  C6 FF
 adc 0                  ;; 04E0:  CE 00
 adc 85                 ;; 04E2:  CE 55
 adc 170                ;; 04E4:  CE AA
 adc 255                ;; 04E6:  CE FF
 sub 0                  ;; 04E8:  D6 00
 sub 85                 ;; 04EA:  D6 55
 sub 170                ;; 04EC:  D6 AA
 sub 255                ;; 04EE:  D6 FF
 sbc 0                  ;; 04F0:  DE 00
 sbc 85                 ;; 04F2:  DE 55
 sbc 170                ;; 04F4:  DE AA
 sbc 255                ;; 04F6:  DE FF
 and 0                  ;; 04F8:  E6 00
 and 85                 ;; 04FA:  E6 55
 and 170                ;; 04FC:  E6 AA
 and 255                ;; 04FE:  E6 FF
 xor 0                  ;; 0500:  EE 00
 xor 85                 ;; 0502:  EE 55
 xor 170                ;; 0504:  EE AA
 xor 255                ;; 0506:  EE FF
 or 0                   ;; 0508:  F6 00
 or 85                  ;; 050A:  F6 55
 or 170                 ;; 050C:  F6 AA
 or 255                 ;; 050E:  F6 FF
 cp 0                   ;; 0510:  FE 00
 cp 85                  ;; 0512:  FE 55
 cp 170                 ;; 0514:  FE AA
 cp 255                 ;; 0516:  FE FF
 add a', b              ;; 0518:  76 80
 add a', c              ;; 051A:  76 81
 add a', d              ;; 051C:  76 82
 add a', e              ;; 051E:  76 83
 add a', h              ;; 0520:  76 84
 add a', l              ;; 0522:  76 85
 add a', (hl)           ;; 0524:  76 86
 add a', a              ;; 0526:  76 87
 adc a', b              ;; 0528:  76 88
 adc a', c              ;; 052A:  76 89
 adc a', d              ;; 052C:  76 8A
 adc a', e              ;; 052E:  76 8B
 adc a', h              ;; 0530:  76 8C
 adc a', l              ;; 0532:  76 8D
 adc a', (hl)           ;; 0534:  76 8E
 adc a', a              ;; 0536:  76 8F
 sub a', b              ;; 0538:  76 90
 sub a', c              ;; 053A:  76 91
 sub a', d              ;; 053C:  76 92
 sub a', e              ;; 053E:  76 93
 sub a', h              ;; 0540:  76 94
 sub a', l              ;; 0542:  76 95
 sub a', (hl)           ;; 0544:  76 96
 sub a', a              ;; 0546:  76 97
 sbc a', b              ;; 0548:  76 98
 sbc a', c              ;; 054A:  76 99
 sbc a', d              ;; 054C:  76 9A
 sbc a', e              ;; 054E:  76 9B
 sbc a', h              ;; 0550:  76 9C
 sbc a', l              ;; 0552:  76 9D
 sbc a', (hl)           ;; 0554:  76 9E
 sbc a', a              ;; 0556:  76 9F
 and a', b              ;; 0558:  76 A0
 and a', c              ;; 055A:  76 A1
 and a', d              ;; 055C:  76 A2
 and a', e              ;; 055E:  76 A3
 and a', h              ;; 0560:  76 A4
 and a', l              ;; 0562:  76 A5
 and a', (hl)           ;; 0564:  76 A6
 and a', a              ;; 0566:  76 A7
 xor a', b              ;; 0568:  76 A8
 xor a', c              ;; 056A:  76 A9
 xor a', d              ;; 056C:  76 AA
 xor a', e              ;; 056E:  76 AB
 xor a', h              ;; 0570:  76 AC
 xor a', l              ;; 0572:  76 AD
 xor a', (hl)           ;; 0574:  76 AE
 xor a', a              ;; 0576:  76 AF
 or a', b               ;; 0578:  76 B0
 or a', c               ;; 057A:  76 B1
 or a', d               ;; 057C:  76 B2
 or a', e               ;; 057E:  76 B3
 or a', h               ;; 0580:  76 B4
 or a', l               ;; 0582:  76 B5
 or a', (hl)            ;; 0584:  76 B6
 or a', a               ;; 0586:  76 B7
 add a', (ix+-128)      ;; 0588:  76 DD 86 80
 add a', (ix)           ;; 058C:  76 DD 86 00
 add a', (ix+127)       ;; 0590:  76 DD 86 7F
 adc a', (ix+-128)      ;; 0594:  76 DD 8E 80
 adc a', (ix)           ;; 0598:  76 DD 8E 00
 adc a', (ix+127)       ;; 059C:  76 DD 8E 7F
 sub a', (ix+-128)      ;; 05A0:  76 DD 96 80
 sub a', (ix)           ;; 05A4:  76 DD 96 00
 sub a', (ix+127)       ;; 05A8:  76 DD 96 7F
 sbc a', (ix+-128)      ;; 05AC:  76 DD 9E 80
 sbc a', (ix)           ;; 05B0:  76 DD 9E 00
 sbc a', (ix+127)       ;; 05B4:  76 DD 9E 7F
 and a', (ix+-128)      ;; 05B8:  76 DD A6 80
 and a', (ix)           ;; 05BC:  76 DD A6 00
 and a', (ix+127)       ;; 05C0:  76 DD A6 7F
 xor a', (ix+-128)      ;; 05C4:  76 DD AE 80
 xor a', (ix)           ;; 05C8:  76 DD AE 00
 xor a', (ix+127)       ;; 05CC:  76 DD AE 7F
 or a', (ix+-128)       ;; 05D0:  76 DD B6 80
 or a', (ix)            ;; 05D4:  76 DD B6 00
 or a', (ix+127)        ;; 05D8:  76 DD B6 7F
 add a', 0              ;; 05DC:  76 C6 00
 add a', 85             ;; 05DF:  76 C6 55
 add a', 170            ;; 05E2:  76 C6 AA
 add a', 255            ;; 05E5:  76 C6 FF
 adc a', 0              ;; 05E8:  76 CE 00
 adc a', 85             ;; 05EB:  76 CE 55
 adc a', 170            ;; 05EE:  76 CE AA
 adc a', 255            ;; 05F1:  76 CE FF
 sub a', 0              ;; 05F4:  76 D6 00
 sub a', 85             ;; 05F7:  76 D6 55
 sub a', 170            ;; 05FA:  76 D6 AA
 sub a', 255            ;; 05FD:  76 D6 FF
 sbc a', 0              ;; 0600:  76 DE 00
 sbc a', 85             ;; 0603:  76 DE 55
 sbc a', 170            ;; 0606:  76 DE AA
 sbc a', 255            ;; 0609:  76 DE FF
 and a', 0              ;; 060C:  76 E6 00
 and a', 85             ;; 060F:  76 E6 55
 and a', 170            ;; 0612:  76 E6 AA
 and a', 255            ;; 0615:  76 E6 FF
 xor a', 0              ;; 0618:  76 EE 00
 xor a', 85             ;; 061B:  76 EE 55
 xor a', 170            ;; 061E:  76 EE AA
 xor a', 255            ;; 0621:  76 EE FF
 or a', 0               ;; 0624:  76 F6 00
 or a', 85              ;; 0627:  76 F6 55
 or a', 170             ;; 062A:  76 F6 AA
 or a', 255             ;; 062D:  76 F6 FF
 inc b                  ;; 0630:  04
 inc c                  ;; 0631:  0C
 inc d                  ;; 0632:  14
 inc e                  ;; 0633:  1C
 inc h                  ;; 0634:  24
 inc l                  ;; 0635:  2C
 inc a                  ;; 0636:  3C
 dec b                  ;; 0637:  05
 dec c                  ;; 0638:  0D
 dec d                  ;; 0639:  15
 dec e                  ;; 063A:  1D
 dec h                  ;; 063B:  25
 dec l                  ;; 063C:  2D
 dec a                  ;; 063D:  3D
 inc b'                 ;; 063E:  76 04
 inc c'                 ;; 0640:  76 0C
 inc d'                 ;; 0642:  76 14
 inc e'                 ;; 0644:  76 1C
 inc h'                 ;; 0646:  76 24
 inc l'                 ;; 0648:  76 2C
 inc a'                 ;; 064A:  76 3C
 dec b'                 ;; 064C:  76 05
 dec c'                 ;; 064E:  76 0D
 dec d'                 ;; 0650:  76 15
 dec e'                 ;; 0652:  76 1D
 dec h'                 ;; 0654:  76 25
 dec l'                 ;; 0656:  76 2D
 dec a'                 ;; 0658:  76 3D
 inc (hl)               ;; 065A:  34
 dec (hl)               ;; 065B:  35
 inc (ix + -128)        ;; 065C:  DD 34 80
 inc (ix)               ;; 065F:  DD 34 00
 inc (ix + 127)         ;; 0662:  DD 34 7F
 dec (ix + -128)        ;; 0665:  DD 35 80
 dec (ix)               ;; 0668:  DD 35 00
 dec (ix + 127)         ;; 066B:  DD 35 7F
 inc (iy + -128)        ;; 066E:  FD 34 80
 inc (iy)               ;; 0671:  FD 34 00
 inc (iy + 127)         ;; 0674:  FD 34 7F
 dec (iy + -128)        ;; 0677:  FD 35 80
 dec (iy)               ;; 067A:  FD 35 00
 dec (iy + 127)         ;; 067D:  FD 35 7F
 tst a, b               ;; 0680:  ED 04
 tst a, c               ;; 0682:  ED 0C
 tst a, d               ;; 0684:  ED 14
 tst a, e               ;; 0686:  ED 1C
 tst a, h               ;; 0688:  ED 24
 tst a, l               ;; 068A:  ED 2C
 tst a, a               ;; 068C:  ED 3C
 tst b                  ;; 068E:  ED 04
 tst c                  ;; 0690:  ED 0C
 tst d                  ;; 0692:  ED 14
 tst e                  ;; 0694:  ED 1C
 tst h                  ;; 0696:  ED 24
 tst l                  ;; 0698:  ED 2C
 tst a                  ;; 069A:  ED 3C
 tst a, 0               ;; 069C:  ED 64 00
 tst a, 85              ;; 069F:  ED 64 55
 tst a, 170             ;; 06A2:  ED 64 AA
 tst a, 255             ;; 06A5:  ED 64 FF
 tst 0                  ;; 06A8:  ED 64 00
 tst 85                 ;; 06AB:  ED 64 55
 tst 170                ;; 06AE:  ED 64 AA
 tst 255                ;; 06B1:  ED 64 FF
 tst a, (hl)            ;; 06B4:  ED 34
 tst (hl)               ;; 06B6:  ED 34
 cpl                    ;; 06B8:  2F
 cpl a                  ;; 06B9:  2F
 cpl a'                 ;; 06BA:  76 2F
 neg                    ;; 06BC:  ED 44
 neg a                  ;; 06BE:  ED 44
 neg a'                 ;; 06C0:  76 ED 44
 ccf                    ;; 06C3:  3F
 ccf f                  ;; 06C4:  3F
 ccf f'                 ;; 06C5:  76 3F
 scf                    ;; 06C7:  37
 scf f                  ;; 06C8:  37
 scf f'                 ;; 06C9:  76 37
 ld bc, 0               ;; 06CB:  01 00 00
 ld bc, 291             ;; 06CE:  01 23 01
 ld bc, 17767           ;; 06D1:  01 67 45
 ld bc, 35243           ;; 06D4:  01 AB 89
 ld bc, 52719           ;; 06D7:  01 EF CD
 ld bc, 65535           ;; 06DA:  01 FF FF
 ld de, 0               ;; 06DD:  11 00 00
 ld de, 291             ;; 06E0:  11 23 01
 ld de, 17767           ;; 06E3:  11 67 45
 ld de, 35243           ;; 06E6:  11 AB 89
 ld de, 52719           ;; 06E9:  11 EF CD
 ld de, 65535           ;; 06EC:  11 FF FF
 ld hl, 0               ;; 06EF:  21 00 00
 ld hl, 291             ;; 06F2:  21 23 01
 ld hl, 17767           ;; 06F5:  21 67 45
 ld hl, 35243           ;; 06F8:  21 AB 89
 ld hl, 52719           ;; 06FB:  21 EF CD
 ld hl, 65535           ;; 06FE:  21 FF FF
 ld sp, 0               ;; 0701:  31 00 00
 ld sp, 291             ;; 0704:  31 23 01
 ld sp, 17767           ;; 0707:  31 67 45
 ld sp, 35243           ;; 070A:  31 AB 89
 ld sp, 52719           ;; 070D:  31 EF CD
 ld sp, 65535           ;; 0710:  31 FF FF
 ld bc', 0              ;; 0713:  76 01 00 00
 ld bc', 291            ;; 0717:  76 01 23 01
 ld bc', 17767          ;; 071B:  76 01 67 45
 ld bc', 35243          ;; 071F:  76 01 AB 89
 ld bc', 52719          ;; 0723:  76 01 EF CD
 ld bc', 65535          ;; 0727:  76 01 FF FF
 ld de', 0              ;; 072B:  76 11 00 00
 ld de', 291            ;; 072F:  76 11 23 01
 ld de', 17767          ;; 0733:  76 11 67 45
 ld de', 35243          ;; 0737:  76 11 AB 89
 ld de', 52719          ;; 073B:  76 11 EF CD
 ld de', 65535          ;; 073F:  76 11 FF FF
 ld hl', 0              ;; 0743:  76 21 00 00
 ld hl', 291            ;; 0747:  76 21 23 01
 ld hl', 17767          ;; 074B:  76 21 67 45
 ld hl', 35243          ;; 074F:  76 21 AB 89
 ld hl', 52719          ;; 0753:  76 21 EF CD
 ld hl', 65535          ;; 0757:  76 21 FF FF
 ld ix, 0               ;; 075B:  DD 21 00 00
 ld ix, 291             ;; 075F:  DD 21 23 01
 ld ix, 17767           ;; 0763:  DD 21 67 45
 ld ix, 35243           ;; 0767:  DD 21 AB 89
 ld ix, 52719           ;; 076B:  DD 21 EF CD
 ld ix, 65535           ;; 076F:  DD 21 FF FF
 ld iy, 0               ;; 0773:  FD 21 00 00
 ld iy, 291             ;; 0777:  FD 21 23 01
 ld iy, 17767           ;; 077B:  FD 21 67 45
 ld iy, 35243           ;; 077F:  FD 21 AB 89
 ld iy, 52719           ;; 0783:  FD 21 EF CD
 ld iy, 65535           ;; 0787:  FD 21 FF FF
 ld hl, (0)             ;; 078B:  2A 00 00
 ld hl, (291)           ;; 078E:  2A 23 01
 ld hl, (17767)         ;; 0791:  2A 67 45
 ld hl, (35243)         ;; 0794:  2A AB 89
 ld hl, (52719)         ;; 0797:  2A EF CD
 ld hl, (65535)         ;; 079A:  2A FF FF
 ld hl', (0)            ;; 079D:  76 2A 00 00
 ld hl', (291)          ;; 07A1:  76 2A 23 01
 ld hl', (17767)        ;; 07A5:  76 2A 67 45
 ld hl', (35243)        ;; 07A9:  76 2A AB 89
 ld hl', (52719)        ;; 07AD:  76 2A EF CD
 ld hl', (65535)        ;; 07B1:  76 2A FF FF
 ld ix, (0)             ;; 07B5:  DD 2A 00 00
 ld ix, (291)           ;; 07B9:  DD 2A 23 01
 ld ix, (17767)         ;; 07BD:  DD 2A 67 45
 ld ix, (35243)         ;; 07C1:  DD 2A AB 89
 ld ix, (52719)         ;; 07C5:  DD 2A EF CD
 ld ix, (65535)         ;; 07C9:  DD 2A FF FF
 ld iy, (0)             ;; 07CD:  FD 2A 00 00
 ld iy, (291)           ;; 07D1:  FD 2A 23 01
 ld iy, (17767)         ;; 07D5:  FD 2A 67 45
 ld iy, (35243)         ;; 07D9:  FD 2A AB 89
 ld iy, (52719)         ;; 07DD:  FD 2A EF CD
 ld iy, (65535)         ;; 07E1:  FD 2A FF FF
 ld (0), hl             ;; 07E5:  22 00 00
 ld (291), hl           ;; 07E8:  22 23 01
 ld (17767), hl         ;; 07EB:  22 67 45
 ld (35243), hl         ;; 07EE:  22 AB 89
 ld (52719), hl         ;; 07F1:  22 EF CD
 ld (65535), hl         ;; 07F4:  22 FF FF
 ld (0), ix             ;; 07F7:  DD 22 00 00
 ld (291), ix           ;; 07FB:  DD 22 23 01
 ld (17767), ix         ;; 07FF:  DD 22 67 45
 ld (35243), ix         ;; 0803:  DD 22 AB 89
 ld (52719), ix         ;; 0807:  DD 22 EF CD
 ld (65535), ix         ;; 080B:  DD 22 FF FF
 ld (0), iy             ;; 080F:  FD 22 00 00
 ld (291), iy           ;; 0813:  FD 22 23 01
 ld (17767), iy         ;; 0817:  FD 22 67 45
 ld (35243), iy         ;; 081B:  FD 22 AB 89
 ld (52719), iy         ;; 081F:  FD 22 EF CD
 ld (65535), iy         ;; 0823:  FD 22 FF FF
 ld bc, (0)             ;; 0827:  ED 4B 00 00
 ld bc, (291)           ;; 082B:  ED 4B 23 01
 ld bc, (17767)         ;; 082F:  ED 4B 67 45
 ld bc, (35243)         ;; 0833:  ED 4B AB 89
 ld bc, (52719)         ;; 0837:  ED 4B EF CD
 ld bc, (65535)         ;; 083B:  ED 4B FF FF
 ld de, (0)             ;; 083F:  ED 5B 00 00
 ld de, (291)           ;; 0843:  ED 5B 23 01
 ld de, (17767)         ;; 0847:  ED 5B 67 45
 ld de, (35243)         ;; 084B:  ED 5B AB 89
 ld de, (52719)         ;; 084F:  ED 5B EF CD
 ld de, (65535)         ;; 0853:  ED 5B FF FF
 ld sp, (0)             ;; 0857:  ED 7B 00 00
 ld sp, (291)           ;; 085B:  ED 7B 23 01
 ld sp, (17767)         ;; 085F:  ED 7B 67 45
 ld sp, (35243)         ;; 0863:  ED 7B AB 89
 ld sp, (52719)         ;; 0867:  ED 7B EF CD
 ld sp, (65535)         ;; 086B:  ED 7B FF FF
 ld bc', (0)            ;; 086F:  76 ED 4B 00 00
 ld bc', (291)          ;; 0874:  76 ED 4B 23 01
 ld bc', (17767)        ;; 0879:  76 ED 4B 67 45
 ld bc', (35243)        ;; 087E:  76 ED 4B AB 89
 ld bc', (52719)        ;; 0883:  76 ED 4B EF CD
 ld bc', (65535)        ;; 0888:  76 ED 4B FF FF
 ld de', (0)            ;; 088D:  76 ED 5B 00 00
 ld de', (291)          ;; 0892:  76 ED 5B 23 01
 ld de', (17767)        ;; 0897:  76 ED 5B 67 45
 ld de', (35243)        ;; 089C:  76 ED 5B AB 89
 ld de', (52719)        ;; 08A1:  76 ED 5B EF CD
 ld de', (65535)        ;; 08A6:  76 ED 5B FF FF
 ld (0), bc             ;; 08AB:  ED 43 00 00
 ld (291), bc           ;; 08AF:  ED 43 23 01
 ld (17767), bc         ;; 08B3:  ED 43 67 45
 ld (35243), bc         ;; 08B7:  ED 43 AB 89
 ld (52719), bc         ;; 08BB:  ED 43 EF CD
 ld (65535), bc         ;; 08BF:  ED 43 FF FF
 ld (0), de             ;; 08C3:  ED 53 00 00
 ld (291), de           ;; 08C7:  ED 53 23 01
 ld (17767), de         ;; 08CB:  ED 53 67 45
 ld (35243), de         ;; 08CF:  ED 53 AB 89
 ld (52719), de         ;; 08D3:  ED 53 EF CD
 ld (65535), de         ;; 08D7:  ED 53 FF FF
 ld (0), sp             ;; 08DB:  ED 73 00 00
 ld (291), sp           ;; 08DF:  ED 73 23 01
 ld (17767), sp         ;; 08E3:  ED 73 67 45
 ld (35243), sp         ;; 08E7:  ED 73 AB 89
 ld (52719), sp         ;; 08EB:  ED 73 EF CD
 ld (65535), sp         ;; 08EF:  ED 73 FF FF
 ld sp, hl              ;; 08F3:  F9
 ld sp, ix              ;; 08F4:  DD F9
 ld sp, iy              ;; 08F6:  FD F9
 push bc                ;; 08F8:  C5
 push de                ;; 08F9:  D5
 push hl                ;; 08FA:  E5
 push af                ;; 08FB:  F5
 push ix                ;; 08FC:  DD E5
 push iy                ;; 08FE:  FD E5
 push ip                ;; 0900:  ED 76
 push su                ;; 0902:  ED 66
 pop bc                 ;; 0904:  C1
 pop de                 ;; 0905:  D1
 pop hl                 ;; 0906:  E1
 pop af                 ;; 0907:  F1
 pop bc'                ;; 0908:  76 C1
 pop de'                ;; 090A:  76 D1
 pop hl'                ;; 090C:  76 E1
 pop af'                ;; 090E:  76 F1
 pop ix                 ;; 0910:  DD E1
 pop iy                 ;; 0912:  FD E1
 pop ip                 ;; 0914:  ED 7E
 pop su                 ;; 0916:  ED 6E
 ld hl, ix              ;; 0918:  DD 7C
 ld hl', ix             ;; 091A:  76 DD 7C
 ld hl, iy              ;; 091D:  FD 7C
 ld hl', iy             ;; 091F:  76 FD 7C
 ld ix, hl              ;; 0922:  DD 7D
 ld iy, hl              ;; 0924:  FD 7D
 ld hl, (hl + -128)     ;; 0926:  DD E4 80
 ld hl, (hl)            ;; 0929:  DD E4 00
 ld hl, (hl + 127)      ;; 092C:  DD E4 7F
 ld hl', (hl + -128)    ;; 092F:  76 DD E4 80
 ld hl', (hl)           ;; 0933:  76 DD E4 00
 ld hl', (hl + 127)     ;; 0937:  76 DD E4 7F
 ld hl, (ix + -128)     ;; 093B:  E4 80
 ld hl, (ix)            ;; 093D:  E4 00
 ld hl, (ix + 127)      ;; 093F:  E4 7F
 ld hl', (ix + -128)    ;; 0941:  76 E4 80
 ld hl', (ix)           ;; 0944:  76 E4 00
 ld hl', (ix + 127)     ;; 0947:  76 E4 7F
 ld hl, (iy + -128)     ;; 094A:  FD E4 80
 ld hl, (iy)            ;; 094D:  FD E4 00
 ld hl, (iy + 127)      ;; 0950:  FD E4 7F
 ld hl', (iy + -128)    ;; 0953:  76 FD E4 80
 ld hl', (iy)           ;; 0957:  76 FD E4 00
 ld hl', (iy + 127)     ;; 095B:  76 FD E4 7F
 ld (hl + -128), hl     ;; 095F:  DD F4 80
 ld (hl), hl            ;; 0962:  DD F4 00
 ld (hl + 127), hl      ;; 0965:  DD F4 7F
 ld (ix + -128), hl     ;; 0968:  F4 80
 ld (ix), hl            ;; 096A:  F4 00
 ld (ix + 127), hl      ;; 096C:  F4 7F
 ld (iy + -128), hl     ;; 096E:  FD F4 80
 ld (iy), hl            ;; 0971:  FD F4 00
 ld (iy + 127), hl      ;; 0974:  FD F4 7F
 ldp (0), hl            ;; 0977:  ED 65 00 00
 ldp (291), hl          ;; 097B:  ED 65 23 01
 ldp (17767), hl        ;; 097F:  ED 65 67 45
 ldp (35243), hl        ;; 0983:  ED 65 AB 89
 ldp (52719), hl        ;; 0987:  ED 65 EF CD
 ldp (65535), hl        ;; 098B:  ED 65 FF FF
 ldp (0), ix            ;; 098F:  DD 65 00 00
 ldp (291), ix          ;; 0993:  DD 65 23 01
 ldp (17767), ix        ;; 0997:  DD 65 67 45
 ldp (35243), ix        ;; 099B:  DD 65 AB 89
 ldp (52719), ix        ;; 099F:  DD 65 EF CD
 ldp (65535), ix        ;; 09A3:  DD 65 FF FF
 ldp (0), iy            ;; 09A7:  FD 65 00 00
 ldp (291), iy          ;; 09AB:  FD 65 23 01
 ldp (17767), iy        ;; 09AF:  FD 65 67 45
 ldp (35243), iy        ;; 09B3:  FD 65 AB 89
 ldp (52719), iy        ;; 09B7:  FD 65 EF CD
 ldp (65535), iy        ;; 09BB:  FD 65 FF FF
 ldp hl, (0)            ;; 09BF:  ED 6D 00 00
 ldp hl, (291)          ;; 09C3:  ED 6D 23 01
 ldp hl, (17767)        ;; 09C7:  ED 6D 67 45
 ldp hl, (35243)        ;; 09CB:  ED 6D AB 89
 ldp hl, (52719)        ;; 09CF:  ED 6D EF CD
 ldp hl, (65535)        ;; 09D3:  ED 6D FF FF
 ldp ix, (0)            ;; 09D7:  DD 6D 00 00
 ldp ix, (291)          ;; 09DB:  DD 6D 23 01
 ldp ix, (17767)        ;; 09DF:  DD 6D 67 45
 ldp ix, (35243)        ;; 09E3:  DD 6D AB 89
 ldp ix, (52719)        ;; 09E7:  DD 6D EF CD
 ldp ix, (65535)        ;; 09EB:  DD 6D FF FF
 ldp iy, (0)            ;; 09EF:  FD 6D 00 00
 ldp iy, (291)          ;; 09F3:  FD 6D 23 01
 ldp iy, (17767)        ;; 09F7:  FD 6D 67 45
 ldp iy, (35243)        ;; 09FB:  FD 6D AB 89
 ldp iy, (52719)        ;; 09FF:  FD 6D EF CD
 ldp iy, (65535)        ;; 0A03:  FD 6D FF FF
 ldp (hl), hl           ;; 0A07:  ED 64
 ldp (ix), hl           ;; 0A09:  DD 64
 ldp (iy), hl           ;; 0A0B:  FD 64
 ldp hl, (hl)           ;; 0A0D:  ED 6C
 ldp hl, (ix)           ;; 0A0F:  DD 6C
 ldp hl, (iy)           ;; 0A11:  FD 6C
 ld (sp), hl            ;; 0A13:  D4 00
 ld (sp + 85), hl       ;; 0A15:  D4 55
 ld (sp + 170), hl      ;; 0A17:  D4 AA
 ld (sp + 255), hl      ;; 0A19:  D4 FF
 ld (sp), ix            ;; 0A1B:  DD D4 00
 ld (sp + 85), ix       ;; 0A1E:  DD D4 55
 ld (sp + 170), ix      ;; 0A21:  DD D4 AA
 ld (sp + 255), ix      ;; 0A24:  DD D4 FF
 ld (sp), iy            ;; 0A27:  FD D4 00
 ld (sp + 85), iy       ;; 0A2A:  FD D4 55
 ld (sp + 170), iy      ;; 0A2D:  FD D4 AA
 ld (sp + 255), iy      ;; 0A30:  FD D4 FF
 ld hl, (sp)            ;; 0A33:  C4 00
 ld hl, (sp + 85)       ;; 0A35:  C4 55
 ld hl, (sp + 170)      ;; 0A37:  C4 AA
 ld hl, (sp + 255)      ;; 0A39:  C4 FF
 ld hl', (sp)           ;; 0A3B:  76 C4 00
 ld hl', (sp + 85)      ;; 0A3E:  76 C4 55
 ld hl', (sp + 170)     ;; 0A41:  76 C4 AA
 ld hl', (sp + 255)     ;; 0A44:  76 C4 FF
 ld ix, (sp)            ;; 0A47:  DD C4 00
 ld ix, (sp + 85)       ;; 0A4A:  DD C4 55
 ld ix, (sp + 170)      ;; 0A4D:  DD C4 AA
 ld ix, (sp + 255)      ;; 0A50:  DD C4 FF
 ld iy, (sp)            ;; 0A53:  FD C4 00
 ld iy, (sp + 85)       ;; 0A56:  FD C4 55
 ld iy, (sp + 170)      ;; 0A59:  FD C4 AA
 ld iy, (sp + 255)      ;; 0A5C:  FD C4 FF
 ld bc', bc             ;; 0A5F:  ED 49
 ld bc', de             ;; 0A61:  ED 41
 ld de', bc             ;; 0A63:  ED 59
 ld de', de             ;; 0A65:  ED 51
 ld hl', bc             ;; 0A67:  ED 69
 ld hl', de             ;; 0A69:  ED 61
 add hl, bc             ;; 0A6B:  09
 add hl, de             ;; 0A6C:  19
 add hl, hl             ;; 0A6D:  29
 add hl, sp             ;; 0A6E:  39
 add hl', bc            ;; 0A6F:  76 09
 add hl', de            ;; 0A71:  76 19
 add hl', hl            ;; 0A73:  76 29
 add hl', sp            ;; 0A75:  76 39
 add ix, bc             ;; 0A77:  DD 09
 add ix, de             ;; 0A79:  DD 19
 add ix, ix             ;; 0A7B:  DD 29
 add ix, sp             ;; 0A7D:  DD 39
 add iy, bc             ;; 0A7F:  FD 09
 add iy, de             ;; 0A81:  FD 19
 add iy, iy             ;; 0A83:  FD 29
 add iy, sp             ;; 0A85:  FD 39
 sbc hl, bc             ;; 0A87:  ED 42
 sbc hl, de             ;; 0A89:  ED 52
 sbc hl, hl             ;; 0A8B:  ED 62
 sbc hl, sp             ;; 0A8D:  ED 72
 adc hl, bc             ;; 0A8F:  ED 4A
 adc hl, de             ;; 0A91:  ED 5A
 adc hl, hl             ;; 0A93:  ED 6A
 adc hl, sp             ;; 0A95:  ED 7A
 sbc hl', bc            ;; 0A97:  76 ED 42
 sbc hl', de            ;; 0A9A:  76 ED 52
 sbc hl', hl            ;; 0A9D:  76 ED 62
 sbc hl', sp            ;; 0AA0:  76 ED 72
 adc hl', bc            ;; 0AA3:  76 ED 4A
 adc hl', de            ;; 0AA6:  76 ED 5A
 adc hl', hl            ;; 0AA9:  76 ED 6A
 adc hl', sp            ;; 0AAC:  76 ED 7A
 inc bc                 ;; 0AAF:  03
 inc de                 ;; 0AB0:  13
 inc hl                 ;; 0AB1:  23
 inc sp                 ;; 0AB2:  33
 dec bc                 ;; 0AB3:  0B
 dec de                 ;; 0AB4:  1B
 dec hl                 ;; 0AB5:  2B
 dec sp                 ;; 0AB6:  3B
 inc bc'                ;; 0AB7:  76 03
 inc de'                ;; 0AB9:  76 13
 inc hl'                ;; 0ABB:  76 23
 dec bc'                ;; 0ABD:  76 0B
 dec de'                ;; 0ABF:  76 1B
 dec hl'                ;; 0AC1:  76 2B
 inc ix                 ;; 0AC3:  DD 23
 dec ix                 ;; 0AC5:  DD 2B
 inc iy                 ;; 0AC7:  FD 23
 dec iy                 ;; 0AC9:  FD 2B
 add sp, -128           ;; 0ACB:  27 80
 add sp, 0              ;; 0ACD:  27 00
 add sp, 127            ;; 0ACF:  27 7F
 and hl, de             ;; 0AD1:  DC
 or hl, de              ;; 0AD2:  EC
 and hl', de            ;; 0AD3:  76 DC
 or hl', de             ;; 0AD5:  76 EC
 and ix, de             ;; 0AD7:  DD DC
 or ix, de              ;; 0AD9:  DD EC
 and iy, de             ;; 0ADB:  FD DC
 or iy, de              ;; 0ADD:  FD EC
 bool hl                ;; 0ADF:  CC
 bool hl'               ;; 0AE0:  76 CC
 bool ix                ;; 0AE2:  DD CC
 bool iy                ;; 0AE4:  FD CC
 mlt bc                 ;; 0AE6:  ED 4C
 mlt de                 ;; 0AE8:  ED 5C
 mlt hl                 ;; 0AEA:  ED 6C
 mul                    ;; 0AEC:  F7
 uma                    ;; 0AED:  ED C0
 ums                    ;; 0AEF:  ED C8
 ex af, af              ;; 0AF1:  08
 ex af, af'             ;; 0AF2:  08
 exx                    ;; 0AF3:  D9
 ex (sp), hl            ;; 0AF4:  ED 54
 ex (sp), hl'           ;; 0AF6:  76 ED 54
 ex (sp), ix            ;; 0AF9:  DD E3
 ex (sp), iy            ;; 0AFB:  FD E3
 ex de, hl              ;; 0AFD:  EB
 ex de', hl             ;; 0AFE:  E3
 ex de, hl'             ;; 0AFF:  76 EB
 ex de', hl'            ;; 0B01:  76 E3
 rlca                   ;; 0B03:  07
 rrca                   ;; 0B04:  0F
 rla                    ;; 0B05:  17
 rra                    ;; 0B06:  1F
 rlc b                  ;; 0B07:  CB 00
 rlc c                  ;; 0B09:  CB 01
 rlc d                  ;; 0B0B:  CB 02
 rlc e                  ;; 0B0D:  CB 03
 rlc h                  ;; 0B0F:  CB 04
 rlc l                  ;; 0B11:  CB 05
 rlc (hl)               ;; 0B13:  CB 06
 rlc a                  ;; 0B15:  CB 07
 rrc b                  ;; 0B17:  CB 08
 rrc c                  ;; 0B19:  CB 09
 rrc d                  ;; 0B1B:  CB 0A
 rrc e                  ;; 0B1D:  CB 0B
 rrc h                  ;; 0B1F:  CB 0C
 rrc l                  ;; 0B21:  CB 0D
 rrc (hl)               ;; 0B23:  CB 0E
 rrc a                  ;; 0B25:  CB 0F
 rl b                   ;; 0B27:  CB 10
 rl c                   ;; 0B29:  CB 11
 rl d                   ;; 0B2B:  CB 12
 rl e                   ;; 0B2D:  CB 13
 rl h                   ;; 0B2F:  CB 14
 rl l                   ;; 0B31:  CB 15
 rl (hl)                ;; 0B33:  CB 16
 rl a                   ;; 0B35:  CB 17
 rr b                   ;; 0B37:  CB 18
 rr c                   ;; 0B39:  CB 19
 rr d                   ;; 0B3B:  CB 1A
 rr e                   ;; 0B3D:  CB 1B
 rr h                   ;; 0B3F:  CB 1C
 rr l                   ;; 0B41:  CB 1D
 rr (hl)                ;; 0B43:  CB 1E
 rr a                   ;; 0B45:  CB 1F
 sla b                  ;; 0B47:  CB 20
 sla c                  ;; 0B49:  CB 21
 sla d                  ;; 0B4B:  CB 22
 sla e                  ;; 0B4D:  CB 23
 sla h                  ;; 0B4F:  CB 24
 sla l                  ;; 0B51:  CB 25
 sla (hl)               ;; 0B53:  CB 26
 sla a                  ;; 0B55:  CB 27
 sra b                  ;; 0B57:  CB 28
 sra c                  ;; 0B59:  CB 29
 sra d                  ;; 0B5B:  CB 2A
 sra e                  ;; 0B5D:  CB 2B
 sra h                  ;; 0B5F:  CB 2C
 sra l                  ;; 0B61:  CB 2D
 sra (hl)               ;; 0B63:  CB 2E
 sra a                  ;; 0B65:  CB 2F
 srl b                  ;; 0B67:  CB 38
 srl c                  ;; 0B69:  CB 39
 srl d                  ;; 0B6B:  CB 3A
 srl e                  ;; 0B6D:  CB 3B
 srl h                  ;; 0B6F:  CB 3C
 srl l                  ;; 0B71:  CB 3D
 srl (hl)               ;; 0B73:  CB 3E
 srl a                  ;; 0B75:  CB 3F
 rlc (ix+-128)          ;; 0B77:  DD CB 80 06
 rlc (ix)               ;; 0B7B:  DD CB 00 06
 rlc (ix+127)           ;; 0B7F:  DD CB 7F 06
 rrc (ix+-128)          ;; 0B83:  DD CB 80 0E
 rrc (ix)               ;; 0B87:  DD CB 00 0E
 rrc (ix+127)           ;; 0B8B:  DD CB 7F 0E
 rl (ix+-128)           ;; 0B8F:  DD CB 80 16
 rl (ix)                ;; 0B93:  DD CB 00 16
 rl (ix+127)            ;; 0B97:  DD CB 7F 16
 rr (ix+-128)           ;; 0B9B:  DD CB 80 1E
 rr (ix)                ;; 0B9F:  DD CB 00 1E
 rr (ix+127)            ;; 0BA3:  DD CB 7F 1E
 sla (ix+-128)          ;; 0BA7:  DD CB 80 26
 sla (ix)               ;; 0BAB:  DD CB 00 26
 sla (ix+127)           ;; 0BAF:  DD CB 7F 26
 sra (ix+-128)          ;; 0BB3:  DD CB 80 2E
 sra (ix)               ;; 0BB7:  DD CB 00 2E
 sra (ix+127)           ;; 0BBB:  DD CB 7F 2E
 srl (ix+-128)          ;; 0BBF:  DD CB 80 3E
 srl (ix)               ;; 0BC3:  DD CB 00 3E
 srl (ix+127)           ;; 0BC7:  DD CB 7F 3E
 rlc (iy+-128)          ;; 0BCB:  FD CB 80 06
 rlc (iy)               ;; 0BCF:  FD CB 00 06
 rlc (iy+127)           ;; 0BD3:  FD CB 7F 06
 rrc (iy+-128)          ;; 0BD7:  FD CB 80 0E
 rrc (iy)               ;; 0BDB:  FD CB 00 0E
 rrc (iy+127)           ;; 0BDF:  FD CB 7F 0E
 rl (iy+-128)           ;; 0BE3:  FD CB 80 16
 rl (iy)                ;; 0BE7:  FD CB 00 16
 rl (iy+127)            ;; 0BEB:  FD CB 7F 16
 rr (iy+-128)           ;; 0BEF:  FD CB 80 1E
 rr (iy)                ;; 0BF3:  FD CB 00 1E
 rr (iy+127)            ;; 0BF7:  FD CB 7F 1E
 sla (iy+-128)          ;; 0BFB:  FD CB 80 26
 sla (iy)               ;; 0BFF:  FD CB 00 26
 sla (iy+127)           ;; 0C03:  FD CB 7F 26
 sra (iy+-128)          ;; 0C07:  FD CB 80 2E
 sra (iy)               ;; 0C0B:  FD CB 00 2E
 sra (iy+127)           ;; 0C0F:  FD CB 7F 2E
 srl (iy+-128)          ;; 0C13:  FD CB 80 3E
 srl (iy)               ;; 0C17:  FD CB 00 3E
 srl (iy+127)           ;; 0C1B:  FD CB 7F 3E
 rl de                  ;; 0C1F:  F3
 rr de                  ;; 0C20:  FB
 rr hl                  ;; 0C21:  FC
 rl de'                 ;; 0C22:  76 F3
 rr de'                 ;; 0C24:  76 FB
 rr hl'                 ;; 0C26:  76 FC
 rr ix                  ;; 0C28:  DD FC
 rr iy                  ;; 0C2A:  FD FC
 bit 0, b               ;; 0C2C:  CB 40
 bit 0, c               ;; 0C2E:  CB 41
 bit 0, d               ;; 0C30:  CB 42
 bit 0, e               ;; 0C32:  CB 43
 bit 0, h               ;; 0C34:  CB 44
 bit 0, l               ;; 0C36:  CB 45
 bit 0, (hl)            ;; 0C38:  CB 46
 bit 0, a               ;; 0C3A:  CB 47
 bit 1, b               ;; 0C3C:  CB 48
 bit 1, c               ;; 0C3E:  CB 49
 bit 1, d               ;; 0C40:  CB 4A
 bit 1, e               ;; 0C42:  CB 4B
 bit 1, h               ;; 0C44:  CB 4C
 bit 1, l               ;; 0C46:  CB 4D
 bit 1, (hl)            ;; 0C48:  CB 4E
 bit 1, a               ;; 0C4A:  CB 4F
 bit 2, b               ;; 0C4C:  CB 50
 bit 2, c               ;; 0C4E:  CB 51
 bit 2, d               ;; 0C50:  CB 52
 bit 2, e               ;; 0C52:  CB 53
 bit 2, h               ;; 0C54:  CB 54
 bit 2, l               ;; 0C56:  CB 55
 bit 2, (hl)            ;; 0C58:  CB 56
 bit 2, a               ;; 0C5A:  CB 57
 bit 3, b               ;; 0C5C:  CB 58
 bit 3, c               ;; 0C5E:  CB 59
 bit 3, d               ;; 0C60:  CB 5A
 bit 3, e               ;; 0C62:  CB 5B
 bit 3, h               ;; 0C64:  CB 5C
 bit 3, l               ;; 0C66:  CB 5D
 bit 3, (hl)            ;; 0C68:  CB 5E
 bit 3, a               ;; 0C6A:  CB 5F
 bit 4, b               ;; 0C6C:  CB 60
 bit 4, c               ;; 0C6E:  CB 61
 bit 4, d               ;; 0C70:  CB 62
 bit 4, e               ;; 0C72:  CB 63
 bit 4, h               ;; 0C74:  CB 64
 bit 4, l               ;; 0C76:  CB 65
 bit 4, (hl)            ;; 0C78:  CB 66
 bit 4, a               ;; 0C7A:  CB 67
 bit 5, b               ;; 0C7C:  CB 68
 bit 5, c               ;; 0C7E:  CB 69
 bit 5, d               ;; 0C80:  CB 6A
 bit 5, e               ;; 0C82:  CB 6B
 bit 5, h               ;; 0C84:  CB 6C
 bit 5, l               ;; 0C86:  CB 6D
 bit 5, (hl)            ;; 0C88:  CB 6E
 bit 5, a               ;; 0C8A:  CB 6F
 bit 6, b               ;; 0C8C:  CB 70
 bit 6, c               ;; 0C8E:  CB 71
 bit 6, d               ;; 0C90:  CB 72
 bit 6, e               ;; 0C92:  CB 73
 bit 6, h               ;; 0C94:  CB 74
 bit 6, l               ;; 0C96:  CB 75
 bit 6, (hl)            ;; 0C98:  CB 76
 bit 6, a               ;; 0C9A:  CB 77
 bit 7, b               ;; 0C9C:  CB 78
 bit 7, c               ;; 0C9E:  CB 79
 bit 7, d               ;; 0CA0:  CB 7A
 bit 7, e               ;; 0CA2:  CB 7B
 bit 7, h               ;; 0CA4:  CB 7C
 bit 7, l               ;; 0CA6:  CB 7D
 bit 7, (hl)            ;; 0CA8:  CB 7E
 bit 7, a               ;; 0CAA:  CB 7F
 res 0, b               ;; 0CAC:  CB 80
 res 0, c               ;; 0CAE:  CB 81
 res 0, d               ;; 0CB0:  CB 82
 res 0, e               ;; 0CB2:  CB 83
 res 0, h               ;; 0CB4:  CB 84
 res 0, l               ;; 0CB6:  CB 85
 res 0, (hl)            ;; 0CB8:  CB 86
 res 0, a               ;; 0CBA:  CB 87
 res 1, b               ;; 0CBC:  CB 88
 res 1, c               ;; 0CBE:  CB 89
 res 1, d               ;; 0CC0:  CB 8A
 res 1, e               ;; 0CC2:  CB 8B
 res 1, h               ;; 0CC4:  CB 8C
 res 1, l               ;; 0CC6:  CB 8D
 res 1, (hl)            ;; 0CC8:  CB 8E
 res 1, a               ;; 0CCA:  CB 8F
 res 2, b               ;; 0CCC:  CB 90
 res 2, c               ;; 0CCE:  CB 91
 res 2, d               ;; 0CD0:  CB 92
 res 2, e               ;; 0CD2:  CB 93
 res 2, h               ;; 0CD4:  CB 94
 res 2, l               ;; 0CD6:  CB 95
 res 2, (hl)            ;; 0CD8:  CB 96
 res 2, a               ;; 0CDA:  CB 97
 res 3, b               ;; 0CDC:  CB 98
 res 3, c               ;; 0CDE:  CB 99
 res 3, d               ;; 0CE0:  CB 9A
 res 3, e               ;; 0CE2:  CB 9B
 res 3, h               ;; 0CE4:  CB 9C
 res 3, l               ;; 0CE6:  CB 9D
 res 3, (hl)            ;; 0CE8:  CB 9E
 res 3, a               ;; 0CEA:  CB 9F
 res 4, b               ;; 0CEC:  CB A0
 res 4, c               ;; 0CEE:  CB A1
 res 4, d               ;; 0CF0:  CB A2
 res 4, e               ;; 0CF2:  CB A3
 res 4, h               ;; 0CF4:  CB A4
 res 4, l               ;; 0CF6:  CB A5
 res 4, (hl)            ;; 0CF8:  CB A6
 res 4, a               ;; 0CFA:  CB A7
 res 5, b               ;; 0CFC:  CB A8
 res 5, c               ;; 0CFE:  CB A9
 res 5, d               ;; 0D00:  CB AA
 res 5, e               ;; 0D02:  CB AB
 res 5, h               ;; 0D04:  CB AC
 res 5, l               ;; 0D06:  CB AD
 res 5, (hl)            ;; 0D08:  CB AE
 res 5, a               ;; 0D0A:  CB AF
 res 6, b               ;; 0D0C:  CB B0
 res 6, c               ;; 0D0E:  CB B1
 res 6, d               ;; 0D10:  CB B2
 res 6, e               ;; 0D12:  CB B3
 res 6, h               ;; 0D14:  CB B4
 res 6, l               ;; 0D16:  CB B5
 res 6, (hl)            ;; 0D18:  CB B6
 res 6, a               ;; 0D1A:  CB B7
 res 7, b               ;; 0D1C:  CB B8
 res 7, c               ;; 0D1E:  CB B9
 res 7, d               ;; 0D20:  CB BA
 res 7, e               ;; 0D22:  CB BB
 res 7, h               ;; 0D24:  CB BC
 res 7, l               ;; 0D26:  CB BD
 res 7, (hl)            ;; 0D28:  CB BE
 res 7, a               ;; 0D2A:  CB BF
 set 0, b               ;; 0D2C:  CB C0
 set 0, c               ;; 0D2E:  CB C1
 set 0, d               ;; 0D30:  CB C2
 set 0, e               ;; 0D32:  CB C3
 set 0, h               ;; 0D34:  CB C4
 set 0, l               ;; 0D36:  CB C5
 set 0, (hl)            ;; 0D38:  CB C6
 set 0, a               ;; 0D3A:  CB C7
 set 1, b               ;; 0D3C:  CB C8
 set 1, c               ;; 0D3E:  CB C9
 set 1, d               ;; 0D40:  CB CA
 set 1, e               ;; 0D42:  CB CB
 set 1, h               ;; 0D44:  CB CC
 set 1, l               ;; 0D46:  CB CD
 set 1, (hl)            ;; 0D48:  CB CE
 set 1, a               ;; 0D4A:  CB CF
 set 2, b               ;; 0D4C:  CB D0
 set 2, c               ;; 0D4E:  CB D1
 set 2, d               ;; 0D50:  CB D2
 set 2, e               ;; 0D52:  CB D3
 set 2, h               ;; 0D54:  CB D4
 set 2, l               ;; 0D56:  CB D5
 set 2, (hl)            ;; 0D58:  CB D6
 set 2, a               ;; 0D5A:  CB D7
 set 3, b               ;; 0D5C:  CB D8
 set 3, c               ;; 0D5E:  CB D9
 set 3, d               ;; 0D60:  CB DA
 set 3, e               ;; 0D62:  CB DB
 set 3, h               ;; 0D64:  CB DC
 set 3, l               ;; 0D66:  CB DD
 set 3, (hl)            ;; 0D68:  CB DE
 set 3, a               ;; 0D6A:  CB DF
 set 4, b               ;; 0D6C:  CB E0
 set 4, c               ;; 0D6E:  CB E1
 set 4, d               ;; 0D70:  CB E2
 set 4, e               ;; 0D72:  CB E3
 set 4, h               ;; 0D74:  CB E4
 set 4, l               ;; 0D76:  CB E5
 set 4, (hl)            ;; 0D78:  CB E6
 set 4, a               ;; 0D7A:  CB E7
 set 5, b               ;; 0D7C:  CB E8
 set 5, c               ;; 0D7E:  CB E9
 set 5, d               ;; 0D80:  CB EA
 set 5, e               ;; 0D82:  CB EB
 set 5, h               ;; 0D84:  CB EC
 set 5, l               ;; 0D86:  CB ED
 set 5, (hl)            ;; 0D88:  CB EE
 set 5, a               ;; 0D8A:  CB EF
 set 6, b               ;; 0D8C:  CB F0
 set 6, c               ;; 0D8E:  CB F1
 set 6, d               ;; 0D90:  CB F2
 set 6, e               ;; 0D92:  CB F3
 set 6, h               ;; 0D94:  CB F4
 set 6, l               ;; 0D96:  CB F5
 set 6, (hl)            ;; 0D98:  CB F6
 set 6, a               ;; 0D9A:  CB F7
 set 7, b               ;; 0D9C:  CB F8
 set 7, c               ;; 0D9E:  CB F9
 set 7, d               ;; 0DA0:  CB FA
 set 7, e               ;; 0DA2:  CB FB
 set 7, h               ;; 0DA4:  CB FC
 set 7, l               ;; 0DA6:  CB FD
 set 7, (hl)            ;; 0DA8:  CB FE
 set 7, a               ;; 0DAA:  CB FF
 res 0, b'              ;; 0DAC:  76 CB 80
 res 0, c'              ;; 0DAF:  76 CB 81
 res 0, d'              ;; 0DB2:  76 CB 82
 res 0, e'              ;; 0DB5:  76 CB 83
 res 0, h'              ;; 0DB8:  76 CB 84
 res 0, l'              ;; 0DBB:  76 CB 85
 res 0, a'              ;; 0DBE:  76 CB 87
 res 1, b'              ;; 0DC1:  76 CB 88
 res 1, c'              ;; 0DC4:  76 CB 89
 res 1, d'              ;; 0DC7:  76 CB 8A
 res 1, e'              ;; 0DCA:  76 CB 8B
 res 1, h'              ;; 0DCD:  76 CB 8C
 res 1, l'              ;; 0DD0:  76 CB 8D
 res 1, a'              ;; 0DD3:  76 CB 8F
 res 2, b'              ;; 0DD6:  76 CB 90
 res 2, c'              ;; 0DD9:  76 CB 91
 res 2, d'              ;; 0DDC:  76 CB 92
 res 2, e'              ;; 0DDF:  76 CB 93
 res 2, h'              ;; 0DE2:  76 CB 94
 res 2, l'              ;; 0DE5:  76 CB 95
 res 2, a'              ;; 0DE8:  76 CB 97
 res 3, b'              ;; 0DEB:  76 CB 98
 res 3, c'              ;; 0DEE:  76 CB 99
 res 3, d'              ;; 0DF1:  76 CB 9A
 res 3, e'              ;; 0DF4:  76 CB 9B
 res 3, h'              ;; 0DF7:  76 CB 9C
 res 3, l'              ;; 0DFA:  76 CB 9D
 res 3, a'              ;; 0DFD:  76 CB 9F
 res 4, b'              ;; 0E00:  76 CB A0
 res 4, c'              ;; 0E03:  76 CB A1
 res 4, d'              ;; 0E06:  76 CB A2
 res 4, e'              ;; 0E09:  76 CB A3
 res 4, h'              ;; 0E0C:  76 CB A4
 res 4, l'              ;; 0E0F:  76 CB A5
 res 4, a'              ;; 0E12:  76 CB A7
 res 5, b'              ;; 0E15:  76 CB A8
 res 5, c'              ;; 0E18:  76 CB A9
 res 5, d'              ;; 0E1B:  76 CB AA
 res 5, e'              ;; 0E1E:  76 CB AB
 res 5, h'              ;; 0E21:  76 CB AC
 res 5, l'              ;; 0E24:  76 CB AD
 res 5, a'              ;; 0E27:  76 CB AF
 res 6, b'              ;; 0E2A:  76 CB B0
 res 6, c'              ;; 0E2D:  76 CB B1
 res 6, d'              ;; 0E30:  76 CB B2
 res 6, e'              ;; 0E33:  76 CB B3
 res 6, h'              ;; 0E36:  76 CB B4
 res 6, l'              ;; 0E39:  76 CB B5
 res 6, a'              ;; 0E3C:  76 CB B7
 res 7, b'              ;; 0E3F:  76 CB B8
 res 7, c'              ;; 0E42:  76 CB B9
 res 7, d'              ;; 0E45:  76 CB BA
 res 7, e'              ;; 0E48:  76 CB BB
 res 7, h'              ;; 0E4B:  76 CB BC
 res 7, l'              ;; 0E4E:  76 CB BD
 res 7, a'              ;; 0E51:  76 CB BF
 set 0, b'              ;; 0E54:  76 CB C0
 set 0, c'              ;; 0E57:  76 CB C1
 set 0, d'              ;; 0E5A:  76 CB C2
 set 0, e'              ;; 0E5D:  76 CB C3
 set 0, h'              ;; 0E60:  76 CB C4
 set 0, l'              ;; 0E63:  76 CB C5
 set 0, a'              ;; 0E66:  76 CB C7
 set 1, b'              ;; 0E69:  76 CB C8
 set 1, c'              ;; 0E6C:  76 CB C9
 set 1, d'              ;; 0E6F:  76 CB CA
 set 1, e'              ;; 0E72:  76 CB CB
 set 1, h'              ;; 0E75:  76 CB CC
 set 1, l'              ;; 0E78:  76 CB CD
 set 1, a'              ;; 0E7B:  76 CB CF
 set 2, b'              ;; 0E7E:  76 CB D0
 set 2, c'              ;; 0E81:  76 CB D1
 set 2, d'              ;; 0E84:  76 CB D2
 set 2, e'              ;; 0E87:  76 CB D3
 set 2, h'              ;; 0E8A:  76 CB D4
 set 2, l'              ;; 0E8D:  76 CB D5
 set 2, a'              ;; 0E90:  76 CB D7
 set 3, b'              ;; 0E93:  76 CB D8
 set 3, c'              ;; 0E96:  76 CB D9
 set 3, d'              ;; 0E99:  76 CB DA
 set 3, e'              ;; 0E9C:  76 CB DB
 set 3, h'              ;; 0E9F:  76 CB DC
 set 3, l'              ;; 0EA2:  76 CB DD
 set 3, a'              ;; 0EA5:  76 CB DF
 set 4, b'              ;; 0EA8:  76 CB E0
 set 4, c'              ;; 0EAB:  76 CB E1
 set 4, d'              ;; 0EAE:  76 CB E2
 set 4, e'              ;; 0EB1:  76 CB E3
 set 4, h'              ;; 0EB4:  76 CB E4
 set 4, l'              ;; 0EB7:  76 CB E5
 set 4, a'              ;; 0EBA:  76 CB E7
 set 5, b'              ;; 0EBD:  76 CB E8
 set 5, c'              ;; 0EC0:  76 CB E9
 set 5, d'              ;; 0EC3:  76 CB EA
 set 5, e'              ;; 0EC6:  76 CB EB
 set 5, h'              ;; 0EC9:  76 CB EC
 set 5, l'              ;; 0ECC:  76 CB ED
 set 5, a'              ;; 0ECF:  76 CB EF
 set 6, b'              ;; 0ED2:  76 CB F0
 set 6, c'              ;; 0ED5:  76 CB F1
 set 6, d'              ;; 0ED8:  76 CB F2
 set 6, e'              ;; 0EDB:  76 CB F3
 set 6, h'              ;; 0EDE:  76 CB F4
 set 6, l'              ;; 0EE1:  76 CB F5
 set 6, a'              ;; 0EE4:  76 CB F7
 set 7, b'              ;; 0EE7:  76 CB F8
 set 7, c'              ;; 0EEA:  76 CB F9
 set 7, d'              ;; 0EED:  76 CB FA
 set 7, e'              ;; 0EF0:  76 CB FB
 set 7, h'              ;; 0EF3:  76 CB FC
 set 7, l'              ;; 0EF6:  76 CB FD
 set 7, a'              ;; 0EF9:  76 CB FF
 bit 0, (ix+-128)       ;; 0EFC:  DD CB 80 46
 bit 0, (ix)            ;; 0F00:  DD CB 00 46
 bit 0, (ix+127)        ;; 0F04:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0F08:  DD CB 80 4E
 bit 1, (ix)            ;; 0F0C:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0F10:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0F14:  DD CB 80 56
 bit 2, (ix)            ;; 0F18:  DD CB 00 56
 bit 2, (ix+127)        ;; 0F1C:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0F20:  DD CB 80 5E
 bit 3, (ix)            ;; 0F24:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0F28:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0F2C:  DD CB 80 66
 bit 4, (ix)            ;; 0F30:  DD CB 00 66
 bit 4, (ix+127)        ;; 0F34:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0F38:  DD CB 80 6E
 bit 5, (ix)            ;; 0F3C:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0F40:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0F44:  DD CB 80 76
 bit 6, (ix)            ;; 0F48:  DD CB 00 76
 bit 6, (ix+127)        ;; 0F4C:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0F50:  DD CB 80 7E
 bit 7, (ix)            ;; 0F54:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0F58:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0F5C:  DD CB 80 86
 res 0, (ix)            ;; 0F60:  DD CB 00 86
 res 0, (ix+127)        ;; 0F64:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0F68:  DD CB 80 8E
 res 1, (ix)            ;; 0F6C:  DD CB 00 8E
 res 1, (ix+127)        ;; 0F70:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0F74:  DD CB 80 96
 res 2, (ix)            ;; 0F78:  DD CB 00 96
 res 2, (ix+127)        ;; 0F7C:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0F80:  DD CB 80 9E
 res 3, (ix)            ;; 0F84:  DD CB 00 9E
 res 3, (ix+127)        ;; 0F88:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0F8C:  DD CB 80 A6
 res 4, (ix)            ;; 0F90:  DD CB 00 A6
 res 4, (ix+127)        ;; 0F94:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0F98:  DD CB 80 AE
 res 5, (ix)            ;; 0F9C:  DD CB 00 AE
 res 5, (ix+127)        ;; 0FA0:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0FA4:  DD CB 80 B6
 res 6, (ix)            ;; 0FA8:  DD CB 00 B6
 res 6, (ix+127)        ;; 0FAC:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0FB0:  DD CB 80 BE
 res 7, (ix)            ;; 0FB4:  DD CB 00 BE
 res 7, (ix+127)        ;; 0FB8:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0FBC:  DD CB 80 C6
 set 0, (ix)            ;; 0FC0:  DD CB 00 C6
 set 0, (ix+127)        ;; 0FC4:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0FC8:  DD CB 80 CE
 set 1, (ix)            ;; 0FCC:  DD CB 00 CE
 set 1, (ix+127)        ;; 0FD0:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0FD4:  DD CB 80 D6
 set 2, (ix)            ;; 0FD8:  DD CB 00 D6
 set 2, (ix+127)        ;; 0FDC:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0FE0:  DD CB 80 DE
 set 3, (ix)            ;; 0FE4:  DD CB 00 DE
 set 3, (ix+127)        ;; 0FE8:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0FEC:  DD CB 80 E6
 set 4, (ix)            ;; 0FF0:  DD CB 00 E6
 set 4, (ix+127)        ;; 0FF4:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0FF8:  DD CB 80 EE
 set 5, (ix)            ;; 0FFC:  DD CB 00 EE
 set 5, (ix+127)        ;; 1000:  DD CB 7F EE
 set 6, (ix+-128)       ;; 1004:  DD CB 80 F6
 set 6, (ix)            ;; 1008:  DD CB 00 F6
 set 6, (ix+127)        ;; 100C:  DD CB 7F F6
 set 7, (ix+-128)       ;; 1010:  DD CB 80 FE
 set 7, (ix)            ;; 1014:  DD CB 00 FE
 set 7, (ix+127)        ;; 1018:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 101C:  FD CB 80 46
 bit 0, (iy)            ;; 1020:  FD CB 00 46
 bit 0, (iy+127)        ;; 1024:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 1028:  FD CB 80 4E
 bit 1, (iy)            ;; 102C:  FD CB 00 4E
 bit 1, (iy+127)        ;; 1030:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 1034:  FD CB 80 56
 bit 2, (iy)            ;; 1038:  FD CB 00 56
 bit 2, (iy+127)        ;; 103C:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 1040:  FD CB 80 5E
 bit 3, (iy)            ;; 1044:  FD CB 00 5E
 bit 3, (iy+127)        ;; 1048:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 104C:  FD CB 80 66
 bit 4, (iy)            ;; 1050:  FD CB 00 66
 bit 4, (iy+127)        ;; 1054:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 1058:  FD CB 80 6E
 bit 5, (iy)            ;; 105C:  FD CB 00 6E
 bit 5, (iy+127)        ;; 1060:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 1064:  FD CB 80 76
 bit 6, (iy)            ;; 1068:  FD CB 00 76
 bit 6, (iy+127)        ;; 106C:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 1070:  FD CB 80 7E
 bit 7, (iy)            ;; 1074:  FD CB 00 7E
 bit 7, (iy+127)        ;; 1078:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 107C:  FD CB 80 86
 res 0, (iy)            ;; 1080:  FD CB 00 86
 res 0, (iy+127)        ;; 1084:  FD CB 7F 86
 res 1, (iy+-128)       ;; 1088:  FD CB 80 8E
 res 1, (iy)            ;; 108C:  FD CB 00 8E
 res 1, (iy+127)        ;; 1090:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 1094:  FD CB 80 96
 res 2, (iy)            ;; 1098:  FD CB 00 96
 res 2, (iy+127)        ;; 109C:  FD CB 7F 96
 res 3, (iy+-128)       ;; 10A0:  FD CB 80 9E
 res 3, (iy)            ;; 10A4:  FD CB 00 9E
 res 3, (iy+127)        ;; 10A8:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 10AC:  FD CB 80 A6
 res 4, (iy)            ;; 10B0:  FD CB 00 A6
 res 4, (iy+127)        ;; 10B4:  FD CB 7F A6
 res 5, (iy+-128)       ;; 10B8:  FD CB 80 AE
 res 5, (iy)            ;; 10BC:  FD CB 00 AE
 res 5, (iy+127)        ;; 10C0:  FD CB 7F AE
 res 6, (iy+-128)       ;; 10C4:  FD CB 80 B6
 res 6, (iy)            ;; 10C8:  FD CB 00 B6
 res 6, (iy+127)        ;; 10CC:  FD CB 7F B6
 res 7, (iy+-128)       ;; 10D0:  FD CB 80 BE
 res 7, (iy)            ;; 10D4:  FD CB 00 BE
 res 7, (iy+127)        ;; 10D8:  FD CB 7F BE
 set 0, (iy+-128)       ;; 10DC:  FD CB 80 C6
 set 0, (iy)            ;; 10E0:  FD CB 00 C6
 set 0, (iy+127)        ;; 10E4:  FD CB 7F C6
 set 1, (iy+-128)       ;; 10E8:  FD CB 80 CE
 set 1, (iy)            ;; 10EC:  FD CB 00 CE
 set 1, (iy+127)        ;; 10F0:  FD CB 7F CE
 set 2, (iy+-128)       ;; 10F4:  FD CB 80 D6
 set 2, (iy)            ;; 10F8:  FD CB 00 D6
 set 2, (iy+127)        ;; 10FC:  FD CB 7F D6
 set 3, (iy+-128)       ;; 1100:  FD CB 80 DE
 set 3, (iy)            ;; 1104:  FD CB 00 DE
 set 3, (iy+127)        ;; 1108:  FD CB 7F DE
 set 4, (iy+-128)       ;; 110C:  FD CB 80 E6
 set 4, (iy)            ;; 1110:  FD CB 00 E6
 set 4, (iy+127)        ;; 1114:  FD CB 7F E6
 set 5, (iy+-128)       ;; 1118:  FD CB 80 EE
 set 5, (iy)            ;; 111C:  FD CB 00 EE
 set 5, (iy+127)        ;; 1120:  FD CB 7F EE
 set 6, (iy+-128)       ;; 1124:  FD CB 80 F6
 set 6, (iy)            ;; 1128:  FD CB 00 F6
 set 6, (iy+127)        ;; 112C:  FD CB 7F F6
 set 7, (iy+-128)       ;; 1130:  FD CB 80 FE
 set 7, (iy)            ;; 1134:  FD CB 00 FE
 set 7, (iy+127)        ;; 1138:  FD CB 7F FE
 ldi                    ;; 113C:  ED A0
 ldir                   ;; 113E:  ED B0
 ldd                    ;; 1140:  ED A8
 lddr                   ;; 1142:  ED B8
 ldisr                  ;; 1144:  ED 90
 lddsr                  ;; 1146:  ED 98
 lsdr                   ;; 1148:  ED F8
 lsir                   ;; 114A:  ED F0
 lsddr                  ;; 114C:  ED D8
 lsidr                  ;; 114E:  ED D0
 nop                    ;; 1150:  00
 ld a, xpc              ;; 1151:  ED 77
 ld a', xpc             ;; 1153:  76 ED 77
 ld xpc, a              ;; 1156:  ED 67
 rdmode                 ;; 1158:  ED 7F
 setusr                 ;; 115A:  ED 6F
 sures                  ;; 115C:  ED 7D
 syscall                ;; 115E:  ED 75
 jp 0                   ;; 1160:  C3 00 00
 jp 291                 ;; 1163:  C3 23 01
 jp 17767               ;; 1166:  C3 67 45
 jp 35243               ;; 1169:  C3 AB 89
 jp 52719               ;; 116C:  C3 EF CD
 jp 65535               ;; 116F:  C3 FF FF
 jp nz, 0               ;; 1172:  C2 00 00
 jp nz, 291             ;; 1175:  C2 23 01
 jp nz, 17767           ;; 1178:  C2 67 45
 jp nz, 35243           ;; 117B:  C2 AB 89
 jp nz, 52719           ;; 117E:  C2 EF CD
 jp nz, 65535           ;; 1181:  C2 FF FF
 jp z, 0                ;; 1184:  CA 00 00
 jp z, 291              ;; 1187:  CA 23 01
 jp z, 17767            ;; 118A:  CA 67 45
 jp z, 35243            ;; 118D:  CA AB 89
 jp z, 52719            ;; 1190:  CA EF CD
 jp z, 65535            ;; 1193:  CA FF FF
 jp nc, 0               ;; 1196:  D2 00 00
 jp nc, 291             ;; 1199:  D2 23 01
 jp nc, 17767           ;; 119C:  D2 67 45
 jp nc, 35243           ;; 119F:  D2 AB 89
 jp nc, 52719           ;; 11A2:  D2 EF CD
 jp nc, 65535           ;; 11A5:  D2 FF FF
 jp c, 0                ;; 11A8:  DA 00 00
 jp c, 291              ;; 11AB:  DA 23 01
 jp c, 17767            ;; 11AE:  DA 67 45
 jp c, 35243            ;; 11B1:  DA AB 89
 jp c, 52719            ;; 11B4:  DA EF CD
 jp c, 65535            ;; 11B7:  DA FF FF
 jp po, 0               ;; 11BA:  E2 00 00
 jp po, 291             ;; 11BD:  E2 23 01
 jp po, 17767           ;; 11C0:  E2 67 45
 jp po, 35243           ;; 11C3:  E2 AB 89
 jp po, 52719           ;; 11C6:  E2 EF CD
 jp po, 65535           ;; 11C9:  E2 FF FF
 jp pe, 0               ;; 11CC:  EA 00 00
 jp pe, 291             ;; 11CF:  EA 23 01
 jp pe, 17767           ;; 11D2:  EA 67 45
 jp pe, 35243           ;; 11D5:  EA AB 89
 jp pe, 52719           ;; 11D8:  EA EF CD
 jp pe, 65535           ;; 11DB:  EA FF FF
 jp p, 0                ;; 11DE:  F2 00 00
 jp p, 291              ;; 11E1:  F2 23 01
 jp p, 17767            ;; 11E4:  F2 67 45
 jp p, 35243            ;; 11E7:  F2 AB 89
 jp p, 52719            ;; 11EA:  F2 EF CD
 jp p, 65535            ;; 11ED:  F2 FF FF
 jp m, 0                ;; 11F0:  FA 00 00
 jp m, 291              ;; 11F3:  FA 23 01
 jp m, 17767            ;; 11F6:  FA 67 45
 jp m, 35243            ;; 11F9:  FA AB 89
 jp m, 52719            ;; 11FC:  FA EF CD
 jp m, 65535            ;; 11FF:  FA FF FF
 jp lz, 0               ;; 1202:  E2 00 00
 jp lz, 291             ;; 1205:  E2 23 01
 jp lz, 17767           ;; 1208:  E2 67 45
 jp lz, 35243           ;; 120B:  E2 AB 89
 jp lz, 52719           ;; 120E:  E2 EF CD
 jp lz, 65535           ;; 1211:  E2 FF FF
 jp lo, 0               ;; 1214:  EA 00 00
 jp lo, 291             ;; 1217:  EA 23 01
 jp lo, 17767           ;; 121A:  EA 67 45
 jp lo, 35243           ;; 121D:  EA AB 89
 jp lo, 52719           ;; 1220:  EA EF CD
 jp lo, 65535           ;; 1223:  EA FF FF
 jp (hl)                ;; 1226:  E9
 jp (ix)                ;; 1227:  DD E9
 jp (iy)                ;; 1229:  FD E9
 djnz ASMPC             ;; 122B:  10 FE
 djnz b, ASMPC          ;; 122D:  10 FE
 djnz b', ASMPC         ;; 122F:  76 10 FE
 jr ASMPC               ;; 1232:  18 FE
 jr nz, ASMPC           ;; 1234:  20 FE
 jr z, ASMPC            ;; 1236:  28 FE
 jr nc, ASMPC           ;; 1238:  30 FE
 jr c, ASMPC            ;; 123A:  38 FE
 call 0                 ;; 123C:  CD 00 00
 call 291               ;; 123F:  CD 23 01
 call 17767             ;; 1242:  CD 67 45
 call 35243             ;; 1245:  CD AB 89
 call 52719             ;; 1248:  CD EF CD
 call 65535             ;; 124B:  CD FF FF
 ret                    ;; 124E:  C9
 ret nz                 ;; 124F:  C0
 ret z                  ;; 1250:  C8
 ret nc                 ;; 1251:  D0
 ret c                  ;; 1252:  D8
 ret po                 ;; 1253:  E0
 ret pe                 ;; 1254:  E8
 ret p                  ;; 1255:  F0
 ret m                  ;; 1256:  F8
 ret lz                 ;; 1257:  E0
 ret lo                 ;; 1258:  E8
 rst 16                 ;; 1259:  D7
 rst 24                 ;; 125A:  DF
 rst 32                 ;; 125B:  E7
 rst 40                 ;; 125C:  EF
 rst 56                 ;; 125D:  FF
 ipset 0                ;; 125E:  ED 46
 ipset 1                ;; 1260:  ED 56
 ipset 2                ;; 1262:  ED 4E
 ipset 3                ;; 1264:  ED 5E
 ipres                  ;; 1266:  ED 5D
 ld iir, a              ;; 1268:  ED 4F
 ld a, iir              ;; 126A:  ED 5F
 ld a', iir             ;; 126C:  76 ED 5F
 ld eir, a              ;; 126F:  ED 47
 ld a, eir              ;; 1271:  ED 57
 ld a', eir             ;; 1273:  76 ED 57
 reti                   ;; 1276:  ED 4D
 idet                   ;; 1278:  5B
