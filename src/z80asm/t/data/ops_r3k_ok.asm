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
 cpl                    ;; 0680:  2F
 cpl a                  ;; 0681:  2F
 cpl a'                 ;; 0682:  76 2F
 neg                    ;; 0684:  ED 44
 neg a                  ;; 0686:  ED 44
 neg a'                 ;; 0688:  76 ED 44
 ccf                    ;; 068B:  3F
 ccf f                  ;; 068C:  3F
 ccf f'                 ;; 068D:  76 3F
 scf                    ;; 068F:  37
 scf f                  ;; 0690:  37
 scf f'                 ;; 0691:  76 37
 ld bc, 0               ;; 0693:  01 00 00
 ld bc, 291             ;; 0696:  01 23 01
 ld bc, 17767           ;; 0699:  01 67 45
 ld bc, 35243           ;; 069C:  01 AB 89
 ld bc, 52719           ;; 069F:  01 EF CD
 ld bc, 65535           ;; 06A2:  01 FF FF
 ld de, 0               ;; 06A5:  11 00 00
 ld de, 291             ;; 06A8:  11 23 01
 ld de, 17767           ;; 06AB:  11 67 45
 ld de, 35243           ;; 06AE:  11 AB 89
 ld de, 52719           ;; 06B1:  11 EF CD
 ld de, 65535           ;; 06B4:  11 FF FF
 ld hl, 0               ;; 06B7:  21 00 00
 ld hl, 291             ;; 06BA:  21 23 01
 ld hl, 17767           ;; 06BD:  21 67 45
 ld hl, 35243           ;; 06C0:  21 AB 89
 ld hl, 52719           ;; 06C3:  21 EF CD
 ld hl, 65535           ;; 06C6:  21 FF FF
 ld sp, 0               ;; 06C9:  31 00 00
 ld sp, 291             ;; 06CC:  31 23 01
 ld sp, 17767           ;; 06CF:  31 67 45
 ld sp, 35243           ;; 06D2:  31 AB 89
 ld sp, 52719           ;; 06D5:  31 EF CD
 ld sp, 65535           ;; 06D8:  31 FF FF
 ld bc', 0              ;; 06DB:  76 01 00 00
 ld bc', 291            ;; 06DF:  76 01 23 01
 ld bc', 17767          ;; 06E3:  76 01 67 45
 ld bc', 35243          ;; 06E7:  76 01 AB 89
 ld bc', 52719          ;; 06EB:  76 01 EF CD
 ld bc', 65535          ;; 06EF:  76 01 FF FF
 ld de', 0              ;; 06F3:  76 11 00 00
 ld de', 291            ;; 06F7:  76 11 23 01
 ld de', 17767          ;; 06FB:  76 11 67 45
 ld de', 35243          ;; 06FF:  76 11 AB 89
 ld de', 52719          ;; 0703:  76 11 EF CD
 ld de', 65535          ;; 0707:  76 11 FF FF
 ld hl', 0              ;; 070B:  76 21 00 00
 ld hl', 291            ;; 070F:  76 21 23 01
 ld hl', 17767          ;; 0713:  76 21 67 45
 ld hl', 35243          ;; 0717:  76 21 AB 89
 ld hl', 52719          ;; 071B:  76 21 EF CD
 ld hl', 65535          ;; 071F:  76 21 FF FF
 ld ix, 0               ;; 0723:  DD 21 00 00
 ld ix, 291             ;; 0727:  DD 21 23 01
 ld ix, 17767           ;; 072B:  DD 21 67 45
 ld ix, 35243           ;; 072F:  DD 21 AB 89
 ld ix, 52719           ;; 0733:  DD 21 EF CD
 ld ix, 65535           ;; 0737:  DD 21 FF FF
 ld iy, 0               ;; 073B:  FD 21 00 00
 ld iy, 291             ;; 073F:  FD 21 23 01
 ld iy, 17767           ;; 0743:  FD 21 67 45
 ld iy, 35243           ;; 0747:  FD 21 AB 89
 ld iy, 52719           ;; 074B:  FD 21 EF CD
 ld iy, 65535           ;; 074F:  FD 21 FF FF
 ld hl, (0)             ;; 0753:  2A 00 00
 ld hl, (291)           ;; 0756:  2A 23 01
 ld hl, (17767)         ;; 0759:  2A 67 45
 ld hl, (35243)         ;; 075C:  2A AB 89
 ld hl, (52719)         ;; 075F:  2A EF CD
 ld hl, (65535)         ;; 0762:  2A FF FF
 ld hl', (0)            ;; 0765:  76 2A 00 00
 ld hl', (291)          ;; 0769:  76 2A 23 01
 ld hl', (17767)        ;; 076D:  76 2A 67 45
 ld hl', (35243)        ;; 0771:  76 2A AB 89
 ld hl', (52719)        ;; 0775:  76 2A EF CD
 ld hl', (65535)        ;; 0779:  76 2A FF FF
 ld ix, (0)             ;; 077D:  DD 2A 00 00
 ld ix, (291)           ;; 0781:  DD 2A 23 01
 ld ix, (17767)         ;; 0785:  DD 2A 67 45
 ld ix, (35243)         ;; 0789:  DD 2A AB 89
 ld ix, (52719)         ;; 078D:  DD 2A EF CD
 ld ix, (65535)         ;; 0791:  DD 2A FF FF
 ld iy, (0)             ;; 0795:  FD 2A 00 00
 ld iy, (291)           ;; 0799:  FD 2A 23 01
 ld iy, (17767)         ;; 079D:  FD 2A 67 45
 ld iy, (35243)         ;; 07A1:  FD 2A AB 89
 ld iy, (52719)         ;; 07A5:  FD 2A EF CD
 ld iy, (65535)         ;; 07A9:  FD 2A FF FF
 ld (0), hl             ;; 07AD:  22 00 00
 ld (291), hl           ;; 07B0:  22 23 01
 ld (17767), hl         ;; 07B3:  22 67 45
 ld (35243), hl         ;; 07B6:  22 AB 89
 ld (52719), hl         ;; 07B9:  22 EF CD
 ld (65535), hl         ;; 07BC:  22 FF FF
 ld (0), ix             ;; 07BF:  DD 22 00 00
 ld (291), ix           ;; 07C3:  DD 22 23 01
 ld (17767), ix         ;; 07C7:  DD 22 67 45
 ld (35243), ix         ;; 07CB:  DD 22 AB 89
 ld (52719), ix         ;; 07CF:  DD 22 EF CD
 ld (65535), ix         ;; 07D3:  DD 22 FF FF
 ld (0), iy             ;; 07D7:  FD 22 00 00
 ld (291), iy           ;; 07DB:  FD 22 23 01
 ld (17767), iy         ;; 07DF:  FD 22 67 45
 ld (35243), iy         ;; 07E3:  FD 22 AB 89
 ld (52719), iy         ;; 07E7:  FD 22 EF CD
 ld (65535), iy         ;; 07EB:  FD 22 FF FF
 ld bc, (0)             ;; 07EF:  ED 4B 00 00
 ld bc, (291)           ;; 07F3:  ED 4B 23 01
 ld bc, (17767)         ;; 07F7:  ED 4B 67 45
 ld bc, (35243)         ;; 07FB:  ED 4B AB 89
 ld bc, (52719)         ;; 07FF:  ED 4B EF CD
 ld bc, (65535)         ;; 0803:  ED 4B FF FF
 ld de, (0)             ;; 0807:  ED 5B 00 00
 ld de, (291)           ;; 080B:  ED 5B 23 01
 ld de, (17767)         ;; 080F:  ED 5B 67 45
 ld de, (35243)         ;; 0813:  ED 5B AB 89
 ld de, (52719)         ;; 0817:  ED 5B EF CD
 ld de, (65535)         ;; 081B:  ED 5B FF FF
 ld sp, (0)             ;; 081F:  ED 7B 00 00
 ld sp, (291)           ;; 0823:  ED 7B 23 01
 ld sp, (17767)         ;; 0827:  ED 7B 67 45
 ld sp, (35243)         ;; 082B:  ED 7B AB 89
 ld sp, (52719)         ;; 082F:  ED 7B EF CD
 ld sp, (65535)         ;; 0833:  ED 7B FF FF
 ld bc', (0)            ;; 0837:  76 ED 4B 00 00
 ld bc', (291)          ;; 083C:  76 ED 4B 23 01
 ld bc', (17767)        ;; 0841:  76 ED 4B 67 45
 ld bc', (35243)        ;; 0846:  76 ED 4B AB 89
 ld bc', (52719)        ;; 084B:  76 ED 4B EF CD
 ld bc', (65535)        ;; 0850:  76 ED 4B FF FF
 ld de', (0)            ;; 0855:  76 ED 5B 00 00
 ld de', (291)          ;; 085A:  76 ED 5B 23 01
 ld de', (17767)        ;; 085F:  76 ED 5B 67 45
 ld de', (35243)        ;; 0864:  76 ED 5B AB 89
 ld de', (52719)        ;; 0869:  76 ED 5B EF CD
 ld de', (65535)        ;; 086E:  76 ED 5B FF FF
 ld (0), bc             ;; 0873:  ED 43 00 00
 ld (291), bc           ;; 0877:  ED 43 23 01
 ld (17767), bc         ;; 087B:  ED 43 67 45
 ld (35243), bc         ;; 087F:  ED 43 AB 89
 ld (52719), bc         ;; 0883:  ED 43 EF CD
 ld (65535), bc         ;; 0887:  ED 43 FF FF
 ld (0), de             ;; 088B:  ED 53 00 00
 ld (291), de           ;; 088F:  ED 53 23 01
 ld (17767), de         ;; 0893:  ED 53 67 45
 ld (35243), de         ;; 0897:  ED 53 AB 89
 ld (52719), de         ;; 089B:  ED 53 EF CD
 ld (65535), de         ;; 089F:  ED 53 FF FF
 ld (0), sp             ;; 08A3:  ED 73 00 00
 ld (291), sp           ;; 08A7:  ED 73 23 01
 ld (17767), sp         ;; 08AB:  ED 73 67 45
 ld (35243), sp         ;; 08AF:  ED 73 AB 89
 ld (52719), sp         ;; 08B3:  ED 73 EF CD
 ld (65535), sp         ;; 08B7:  ED 73 FF FF
 ld sp, hl              ;; 08BB:  F9
 ld sp, ix              ;; 08BC:  DD F9
 ld sp, iy              ;; 08BE:  FD F9
 push bc                ;; 08C0:  C5
 push de                ;; 08C1:  D5
 push hl                ;; 08C2:  E5
 push af                ;; 08C3:  F5
 push ix                ;; 08C4:  DD E5
 push iy                ;; 08C6:  FD E5
 push ip                ;; 08C8:  ED 76
 push su                ;; 08CA:  ED 66
 pop bc                 ;; 08CC:  C1
 pop de                 ;; 08CD:  D1
 pop hl                 ;; 08CE:  E1
 pop af                 ;; 08CF:  F1
 pop bc'                ;; 08D0:  76 C1
 pop de'                ;; 08D2:  76 D1
 pop hl'                ;; 08D4:  76 E1
 pop af'                ;; 08D6:  76 F1
 pop ix                 ;; 08D8:  DD E1
 pop iy                 ;; 08DA:  FD E1
 pop ip                 ;; 08DC:  ED 7E
 pop su                 ;; 08DE:  ED 6E
 ld hl, ix              ;; 08E0:  DD 7C
 ld hl', ix             ;; 08E2:  76 DD 7C
 ld hl, iy              ;; 08E5:  FD 7C
 ld hl', iy             ;; 08E7:  76 FD 7C
 ld ix, hl              ;; 08EA:  DD 7D
 ld iy, hl              ;; 08EC:  FD 7D
 ld hl, (hl + -128)     ;; 08EE:  DD E4 80
 ld hl, (hl)            ;; 08F1:  DD E4 00
 ld hl, (hl + 127)      ;; 08F4:  DD E4 7F
 ld hl', (hl + -128)    ;; 08F7:  76 DD E4 80
 ld hl', (hl)           ;; 08FB:  76 DD E4 00
 ld hl', (hl + 127)     ;; 08FF:  76 DD E4 7F
 ld hl, (ix + -128)     ;; 0903:  E4 80
 ld hl, (ix)            ;; 0905:  E4 00
 ld hl, (ix + 127)      ;; 0907:  E4 7F
 ld hl', (ix + -128)    ;; 0909:  76 E4 80
 ld hl', (ix)           ;; 090C:  76 E4 00
 ld hl', (ix + 127)     ;; 090F:  76 E4 7F
 ld hl, (iy + -128)     ;; 0912:  FD E4 80
 ld hl, (iy)            ;; 0915:  FD E4 00
 ld hl, (iy + 127)      ;; 0918:  FD E4 7F
 ld hl', (iy + -128)    ;; 091B:  76 FD E4 80
 ld hl', (iy)           ;; 091F:  76 FD E4 00
 ld hl', (iy + 127)     ;; 0923:  76 FD E4 7F
 ld (hl + -128), hl     ;; 0927:  DD F4 80
 ld (hl), hl            ;; 092A:  DD F4 00
 ld (hl + 127), hl      ;; 092D:  DD F4 7F
 ld (ix + -128), hl     ;; 0930:  F4 80
 ld (ix), hl            ;; 0932:  F4 00
 ld (ix + 127), hl      ;; 0934:  F4 7F
 ld (iy + -128), hl     ;; 0936:  FD F4 80
 ld (iy), hl            ;; 0939:  FD F4 00
 ld (iy + 127), hl      ;; 093C:  FD F4 7F
 ldp (0), hl            ;; 093F:  ED 65 00 00
 ldp (291), hl          ;; 0943:  ED 65 23 01
 ldp (17767), hl        ;; 0947:  ED 65 67 45
 ldp (35243), hl        ;; 094B:  ED 65 AB 89
 ldp (52719), hl        ;; 094F:  ED 65 EF CD
 ldp (65535), hl        ;; 0953:  ED 65 FF FF
 ldp (0), ix            ;; 0957:  DD 65 00 00
 ldp (291), ix          ;; 095B:  DD 65 23 01
 ldp (17767), ix        ;; 095F:  DD 65 67 45
 ldp (35243), ix        ;; 0963:  DD 65 AB 89
 ldp (52719), ix        ;; 0967:  DD 65 EF CD
 ldp (65535), ix        ;; 096B:  DD 65 FF FF
 ldp (0), iy            ;; 096F:  FD 65 00 00
 ldp (291), iy          ;; 0973:  FD 65 23 01
 ldp (17767), iy        ;; 0977:  FD 65 67 45
 ldp (35243), iy        ;; 097B:  FD 65 AB 89
 ldp (52719), iy        ;; 097F:  FD 65 EF CD
 ldp (65535), iy        ;; 0983:  FD 65 FF FF
 ldp hl, (0)            ;; 0987:  ED 6D 00 00
 ldp hl, (291)          ;; 098B:  ED 6D 23 01
 ldp hl, (17767)        ;; 098F:  ED 6D 67 45
 ldp hl, (35243)        ;; 0993:  ED 6D AB 89
 ldp hl, (52719)        ;; 0997:  ED 6D EF CD
 ldp hl, (65535)        ;; 099B:  ED 6D FF FF
 ldp ix, (0)            ;; 099F:  DD 6D 00 00
 ldp ix, (291)          ;; 09A3:  DD 6D 23 01
 ldp ix, (17767)        ;; 09A7:  DD 6D 67 45
 ldp ix, (35243)        ;; 09AB:  DD 6D AB 89
 ldp ix, (52719)        ;; 09AF:  DD 6D EF CD
 ldp ix, (65535)        ;; 09B3:  DD 6D FF FF
 ldp iy, (0)            ;; 09B7:  FD 6D 00 00
 ldp iy, (291)          ;; 09BB:  FD 6D 23 01
 ldp iy, (17767)        ;; 09BF:  FD 6D 67 45
 ldp iy, (35243)        ;; 09C3:  FD 6D AB 89
 ldp iy, (52719)        ;; 09C7:  FD 6D EF CD
 ldp iy, (65535)        ;; 09CB:  FD 6D FF FF
 ldp (hl), hl           ;; 09CF:  ED 64
 ldp (ix), hl           ;; 09D1:  DD 64
 ldp (iy), hl           ;; 09D3:  FD 64
 ldp hl, (hl)           ;; 09D5:  ED 6C
 ldp hl, (ix)           ;; 09D7:  DD 6C
 ldp hl, (iy)           ;; 09D9:  FD 6C
 ld (sp), hl            ;; 09DB:  D4 00
 ld (sp + 85), hl       ;; 09DD:  D4 55
 ld (sp + 170), hl      ;; 09DF:  D4 AA
 ld (sp + 255), hl      ;; 09E1:  D4 FF
 ld (sp), ix            ;; 09E3:  DD D4 00
 ld (sp + 85), ix       ;; 09E6:  DD D4 55
 ld (sp + 170), ix      ;; 09E9:  DD D4 AA
 ld (sp + 255), ix      ;; 09EC:  DD D4 FF
 ld (sp), iy            ;; 09EF:  FD D4 00
 ld (sp + 85), iy       ;; 09F2:  FD D4 55
 ld (sp + 170), iy      ;; 09F5:  FD D4 AA
 ld (sp + 255), iy      ;; 09F8:  FD D4 FF
 ld hl, (sp)            ;; 09FB:  C4 00
 ld hl, (sp + 85)       ;; 09FD:  C4 55
 ld hl, (sp + 170)      ;; 09FF:  C4 AA
 ld hl, (sp + 255)      ;; 0A01:  C4 FF
 ld hl', (sp)           ;; 0A03:  76 C4 00
 ld hl', (sp + 85)      ;; 0A06:  76 C4 55
 ld hl', (sp + 170)     ;; 0A09:  76 C4 AA
 ld hl', (sp + 255)     ;; 0A0C:  76 C4 FF
 ld ix, (sp)            ;; 0A0F:  DD C4 00
 ld ix, (sp + 85)       ;; 0A12:  DD C4 55
 ld ix, (sp + 170)      ;; 0A15:  DD C4 AA
 ld ix, (sp + 255)      ;; 0A18:  DD C4 FF
 ld iy, (sp)            ;; 0A1B:  FD C4 00
 ld iy, (sp + 85)       ;; 0A1E:  FD C4 55
 ld iy, (sp + 170)      ;; 0A21:  FD C4 AA
 ld iy, (sp + 255)      ;; 0A24:  FD C4 FF
 ld bc', bc             ;; 0A27:  ED 49
 ld bc', de             ;; 0A29:  ED 41
 ld de', bc             ;; 0A2B:  ED 59
 ld de', de             ;; 0A2D:  ED 51
 ld hl', bc             ;; 0A2F:  ED 69
 ld hl', de             ;; 0A31:  ED 61
 add hl, bc             ;; 0A33:  09
 add hl, de             ;; 0A34:  19
 add hl, hl             ;; 0A35:  29
 add hl, sp             ;; 0A36:  39
 add hl', bc            ;; 0A37:  76 09
 add hl', de            ;; 0A39:  76 19
 add hl', hl            ;; 0A3B:  76 29
 add hl', sp            ;; 0A3D:  76 39
 add ix, bc             ;; 0A3F:  DD 09
 add ix, de             ;; 0A41:  DD 19
 add ix, ix             ;; 0A43:  DD 29
 add ix, sp             ;; 0A45:  DD 39
 add iy, bc             ;; 0A47:  FD 09
 add iy, de             ;; 0A49:  FD 19
 add iy, iy             ;; 0A4B:  FD 29
 add iy, sp             ;; 0A4D:  FD 39
 sbc hl, bc             ;; 0A4F:  ED 42
 sbc hl, de             ;; 0A51:  ED 52
 sbc hl, hl             ;; 0A53:  ED 62
 sbc hl, sp             ;; 0A55:  ED 72
 adc hl, bc             ;; 0A57:  ED 4A
 adc hl, de             ;; 0A59:  ED 5A
 adc hl, hl             ;; 0A5B:  ED 6A
 adc hl, sp             ;; 0A5D:  ED 7A
 sbc hl', bc            ;; 0A5F:  76 ED 42
 sbc hl', de            ;; 0A62:  76 ED 52
 sbc hl', hl            ;; 0A65:  76 ED 62
 sbc hl', sp            ;; 0A68:  76 ED 72
 adc hl', bc            ;; 0A6B:  76 ED 4A
 adc hl', de            ;; 0A6E:  76 ED 5A
 adc hl', hl            ;; 0A71:  76 ED 6A
 adc hl', sp            ;; 0A74:  76 ED 7A
 inc bc                 ;; 0A77:  03
 inc de                 ;; 0A78:  13
 inc hl                 ;; 0A79:  23
 inc sp                 ;; 0A7A:  33
 dec bc                 ;; 0A7B:  0B
 dec de                 ;; 0A7C:  1B
 dec hl                 ;; 0A7D:  2B
 dec sp                 ;; 0A7E:  3B
 inc bc'                ;; 0A7F:  76 03
 inc de'                ;; 0A81:  76 13
 inc hl'                ;; 0A83:  76 23
 dec bc'                ;; 0A85:  76 0B
 dec de'                ;; 0A87:  76 1B
 dec hl'                ;; 0A89:  76 2B
 inc ix                 ;; 0A8B:  DD 23
 dec ix                 ;; 0A8D:  DD 2B
 inc iy                 ;; 0A8F:  FD 23
 dec iy                 ;; 0A91:  FD 2B
 add sp, -128           ;; 0A93:  27 80
 add sp, 0              ;; 0A95:  27 00
 add sp, 127            ;; 0A97:  27 7F
 and hl, de             ;; 0A99:  DC
 or hl, de              ;; 0A9A:  EC
 and hl', de            ;; 0A9B:  76 DC
 or hl', de             ;; 0A9D:  76 EC
 and ix, de             ;; 0A9F:  DD DC
 or ix, de              ;; 0AA1:  DD EC
 and iy, de             ;; 0AA3:  FD DC
 or iy, de              ;; 0AA5:  FD EC
 bool hl                ;; 0AA7:  CC
 bool hl'               ;; 0AA8:  76 CC
 bool ix                ;; 0AAA:  DD CC
 bool iy                ;; 0AAC:  FD CC
 mul                    ;; 0AAE:  F7
 uma                    ;; 0AAF:  ED C0
 ums                    ;; 0AB1:  ED C8
 ex af, af              ;; 0AB3:  08
 ex af, af'             ;; 0AB4:  08
 exx                    ;; 0AB5:  D9
 ex (sp), hl            ;; 0AB6:  ED 54
 ex (sp), hl'           ;; 0AB8:  76 ED 54
 ex (sp), ix            ;; 0ABB:  DD E3
 ex (sp), iy            ;; 0ABD:  FD E3
 ex de, hl              ;; 0ABF:  EB
 ex de', hl             ;; 0AC0:  E3
 ex de, hl'             ;; 0AC1:  76 EB
 ex de', hl'            ;; 0AC3:  76 E3
 rlca                   ;; 0AC5:  07
 rrca                   ;; 0AC6:  0F
 rla                    ;; 0AC7:  17
 rra                    ;; 0AC8:  1F
 rlc b                  ;; 0AC9:  CB 00
 rlc c                  ;; 0ACB:  CB 01
 rlc d                  ;; 0ACD:  CB 02
 rlc e                  ;; 0ACF:  CB 03
 rlc h                  ;; 0AD1:  CB 04
 rlc l                  ;; 0AD3:  CB 05
 rlc (hl)               ;; 0AD5:  CB 06
 rlc a                  ;; 0AD7:  CB 07
 rrc b                  ;; 0AD9:  CB 08
 rrc c                  ;; 0ADB:  CB 09
 rrc d                  ;; 0ADD:  CB 0A
 rrc e                  ;; 0ADF:  CB 0B
 rrc h                  ;; 0AE1:  CB 0C
 rrc l                  ;; 0AE3:  CB 0D
 rrc (hl)               ;; 0AE5:  CB 0E
 rrc a                  ;; 0AE7:  CB 0F
 rl b                   ;; 0AE9:  CB 10
 rl c                   ;; 0AEB:  CB 11
 rl d                   ;; 0AED:  CB 12
 rl e                   ;; 0AEF:  CB 13
 rl h                   ;; 0AF1:  CB 14
 rl l                   ;; 0AF3:  CB 15
 rl (hl)                ;; 0AF5:  CB 16
 rl a                   ;; 0AF7:  CB 17
 rr b                   ;; 0AF9:  CB 18
 rr c                   ;; 0AFB:  CB 19
 rr d                   ;; 0AFD:  CB 1A
 rr e                   ;; 0AFF:  CB 1B
 rr h                   ;; 0B01:  CB 1C
 rr l                   ;; 0B03:  CB 1D
 rr (hl)                ;; 0B05:  CB 1E
 rr a                   ;; 0B07:  CB 1F
 sla b                  ;; 0B09:  CB 20
 sla c                  ;; 0B0B:  CB 21
 sla d                  ;; 0B0D:  CB 22
 sla e                  ;; 0B0F:  CB 23
 sla h                  ;; 0B11:  CB 24
 sla l                  ;; 0B13:  CB 25
 sla (hl)               ;; 0B15:  CB 26
 sla a                  ;; 0B17:  CB 27
 sra b                  ;; 0B19:  CB 28
 sra c                  ;; 0B1B:  CB 29
 sra d                  ;; 0B1D:  CB 2A
 sra e                  ;; 0B1F:  CB 2B
 sra h                  ;; 0B21:  CB 2C
 sra l                  ;; 0B23:  CB 2D
 sra (hl)               ;; 0B25:  CB 2E
 sra a                  ;; 0B27:  CB 2F
 srl b                  ;; 0B29:  CB 38
 srl c                  ;; 0B2B:  CB 39
 srl d                  ;; 0B2D:  CB 3A
 srl e                  ;; 0B2F:  CB 3B
 srl h                  ;; 0B31:  CB 3C
 srl l                  ;; 0B33:  CB 3D
 srl (hl)               ;; 0B35:  CB 3E
 srl a                  ;; 0B37:  CB 3F
 rlc (ix+-128)          ;; 0B39:  DD CB 80 06
 rlc (ix)               ;; 0B3D:  DD CB 00 06
 rlc (ix+127)           ;; 0B41:  DD CB 7F 06
 rrc (ix+-128)          ;; 0B45:  DD CB 80 0E
 rrc (ix)               ;; 0B49:  DD CB 00 0E
 rrc (ix+127)           ;; 0B4D:  DD CB 7F 0E
 rl (ix+-128)           ;; 0B51:  DD CB 80 16
 rl (ix)                ;; 0B55:  DD CB 00 16
 rl (ix+127)            ;; 0B59:  DD CB 7F 16
 rr (ix+-128)           ;; 0B5D:  DD CB 80 1E
 rr (ix)                ;; 0B61:  DD CB 00 1E
 rr (ix+127)            ;; 0B65:  DD CB 7F 1E
 sla (ix+-128)          ;; 0B69:  DD CB 80 26
 sla (ix)               ;; 0B6D:  DD CB 00 26
 sla (ix+127)           ;; 0B71:  DD CB 7F 26
 sra (ix+-128)          ;; 0B75:  DD CB 80 2E
 sra (ix)               ;; 0B79:  DD CB 00 2E
 sra (ix+127)           ;; 0B7D:  DD CB 7F 2E
 srl (ix+-128)          ;; 0B81:  DD CB 80 3E
 srl (ix)               ;; 0B85:  DD CB 00 3E
 srl (ix+127)           ;; 0B89:  DD CB 7F 3E
 rlc (iy+-128)          ;; 0B8D:  FD CB 80 06
 rlc (iy)               ;; 0B91:  FD CB 00 06
 rlc (iy+127)           ;; 0B95:  FD CB 7F 06
 rrc (iy+-128)          ;; 0B99:  FD CB 80 0E
 rrc (iy)               ;; 0B9D:  FD CB 00 0E
 rrc (iy+127)           ;; 0BA1:  FD CB 7F 0E
 rl (iy+-128)           ;; 0BA5:  FD CB 80 16
 rl (iy)                ;; 0BA9:  FD CB 00 16
 rl (iy+127)            ;; 0BAD:  FD CB 7F 16
 rr (iy+-128)           ;; 0BB1:  FD CB 80 1E
 rr (iy)                ;; 0BB5:  FD CB 00 1E
 rr (iy+127)            ;; 0BB9:  FD CB 7F 1E
 sla (iy+-128)          ;; 0BBD:  FD CB 80 26
 sla (iy)               ;; 0BC1:  FD CB 00 26
 sla (iy+127)           ;; 0BC5:  FD CB 7F 26
 sra (iy+-128)          ;; 0BC9:  FD CB 80 2E
 sra (iy)               ;; 0BCD:  FD CB 00 2E
 sra (iy+127)           ;; 0BD1:  FD CB 7F 2E
 srl (iy+-128)          ;; 0BD5:  FD CB 80 3E
 srl (iy)               ;; 0BD9:  FD CB 00 3E
 srl (iy+127)           ;; 0BDD:  FD CB 7F 3E
 rl de                  ;; 0BE1:  F3
 rr de                  ;; 0BE2:  FB
 rr hl                  ;; 0BE3:  FC
 rl de'                 ;; 0BE4:  76 F3
 rr de'                 ;; 0BE6:  76 FB
 rr hl'                 ;; 0BE8:  76 FC
 rr ix                  ;; 0BEA:  DD FC
 rr iy                  ;; 0BEC:  FD FC
 bit 0, b               ;; 0BEE:  CB 40
 bit 0, c               ;; 0BF0:  CB 41
 bit 0, d               ;; 0BF2:  CB 42
 bit 0, e               ;; 0BF4:  CB 43
 bit 0, h               ;; 0BF6:  CB 44
 bit 0, l               ;; 0BF8:  CB 45
 bit 0, (hl)            ;; 0BFA:  CB 46
 bit 0, a               ;; 0BFC:  CB 47
 bit 1, b               ;; 0BFE:  CB 48
 bit 1, c               ;; 0C00:  CB 49
 bit 1, d               ;; 0C02:  CB 4A
 bit 1, e               ;; 0C04:  CB 4B
 bit 1, h               ;; 0C06:  CB 4C
 bit 1, l               ;; 0C08:  CB 4D
 bit 1, (hl)            ;; 0C0A:  CB 4E
 bit 1, a               ;; 0C0C:  CB 4F
 bit 2, b               ;; 0C0E:  CB 50
 bit 2, c               ;; 0C10:  CB 51
 bit 2, d               ;; 0C12:  CB 52
 bit 2, e               ;; 0C14:  CB 53
 bit 2, h               ;; 0C16:  CB 54
 bit 2, l               ;; 0C18:  CB 55
 bit 2, (hl)            ;; 0C1A:  CB 56
 bit 2, a               ;; 0C1C:  CB 57
 bit 3, b               ;; 0C1E:  CB 58
 bit 3, c               ;; 0C20:  CB 59
 bit 3, d               ;; 0C22:  CB 5A
 bit 3, e               ;; 0C24:  CB 5B
 bit 3, h               ;; 0C26:  CB 5C
 bit 3, l               ;; 0C28:  CB 5D
 bit 3, (hl)            ;; 0C2A:  CB 5E
 bit 3, a               ;; 0C2C:  CB 5F
 bit 4, b               ;; 0C2E:  CB 60
 bit 4, c               ;; 0C30:  CB 61
 bit 4, d               ;; 0C32:  CB 62
 bit 4, e               ;; 0C34:  CB 63
 bit 4, h               ;; 0C36:  CB 64
 bit 4, l               ;; 0C38:  CB 65
 bit 4, (hl)            ;; 0C3A:  CB 66
 bit 4, a               ;; 0C3C:  CB 67
 bit 5, b               ;; 0C3E:  CB 68
 bit 5, c               ;; 0C40:  CB 69
 bit 5, d               ;; 0C42:  CB 6A
 bit 5, e               ;; 0C44:  CB 6B
 bit 5, h               ;; 0C46:  CB 6C
 bit 5, l               ;; 0C48:  CB 6D
 bit 5, (hl)            ;; 0C4A:  CB 6E
 bit 5, a               ;; 0C4C:  CB 6F
 bit 6, b               ;; 0C4E:  CB 70
 bit 6, c               ;; 0C50:  CB 71
 bit 6, d               ;; 0C52:  CB 72
 bit 6, e               ;; 0C54:  CB 73
 bit 6, h               ;; 0C56:  CB 74
 bit 6, l               ;; 0C58:  CB 75
 bit 6, (hl)            ;; 0C5A:  CB 76
 bit 6, a               ;; 0C5C:  CB 77
 bit 7, b               ;; 0C5E:  CB 78
 bit 7, c               ;; 0C60:  CB 79
 bit 7, d               ;; 0C62:  CB 7A
 bit 7, e               ;; 0C64:  CB 7B
 bit 7, h               ;; 0C66:  CB 7C
 bit 7, l               ;; 0C68:  CB 7D
 bit 7, (hl)            ;; 0C6A:  CB 7E
 bit 7, a               ;; 0C6C:  CB 7F
 res 0, b               ;; 0C6E:  CB 80
 res 0, c               ;; 0C70:  CB 81
 res 0, d               ;; 0C72:  CB 82
 res 0, e               ;; 0C74:  CB 83
 res 0, h               ;; 0C76:  CB 84
 res 0, l               ;; 0C78:  CB 85
 res 0, (hl)            ;; 0C7A:  CB 86
 res 0, a               ;; 0C7C:  CB 87
 res 1, b               ;; 0C7E:  CB 88
 res 1, c               ;; 0C80:  CB 89
 res 1, d               ;; 0C82:  CB 8A
 res 1, e               ;; 0C84:  CB 8B
 res 1, h               ;; 0C86:  CB 8C
 res 1, l               ;; 0C88:  CB 8D
 res 1, (hl)            ;; 0C8A:  CB 8E
 res 1, a               ;; 0C8C:  CB 8F
 res 2, b               ;; 0C8E:  CB 90
 res 2, c               ;; 0C90:  CB 91
 res 2, d               ;; 0C92:  CB 92
 res 2, e               ;; 0C94:  CB 93
 res 2, h               ;; 0C96:  CB 94
 res 2, l               ;; 0C98:  CB 95
 res 2, (hl)            ;; 0C9A:  CB 96
 res 2, a               ;; 0C9C:  CB 97
 res 3, b               ;; 0C9E:  CB 98
 res 3, c               ;; 0CA0:  CB 99
 res 3, d               ;; 0CA2:  CB 9A
 res 3, e               ;; 0CA4:  CB 9B
 res 3, h               ;; 0CA6:  CB 9C
 res 3, l               ;; 0CA8:  CB 9D
 res 3, (hl)            ;; 0CAA:  CB 9E
 res 3, a               ;; 0CAC:  CB 9F
 res 4, b               ;; 0CAE:  CB A0
 res 4, c               ;; 0CB0:  CB A1
 res 4, d               ;; 0CB2:  CB A2
 res 4, e               ;; 0CB4:  CB A3
 res 4, h               ;; 0CB6:  CB A4
 res 4, l               ;; 0CB8:  CB A5
 res 4, (hl)            ;; 0CBA:  CB A6
 res 4, a               ;; 0CBC:  CB A7
 res 5, b               ;; 0CBE:  CB A8
 res 5, c               ;; 0CC0:  CB A9
 res 5, d               ;; 0CC2:  CB AA
 res 5, e               ;; 0CC4:  CB AB
 res 5, h               ;; 0CC6:  CB AC
 res 5, l               ;; 0CC8:  CB AD
 res 5, (hl)            ;; 0CCA:  CB AE
 res 5, a               ;; 0CCC:  CB AF
 res 6, b               ;; 0CCE:  CB B0
 res 6, c               ;; 0CD0:  CB B1
 res 6, d               ;; 0CD2:  CB B2
 res 6, e               ;; 0CD4:  CB B3
 res 6, h               ;; 0CD6:  CB B4
 res 6, l               ;; 0CD8:  CB B5
 res 6, (hl)            ;; 0CDA:  CB B6
 res 6, a               ;; 0CDC:  CB B7
 res 7, b               ;; 0CDE:  CB B8
 res 7, c               ;; 0CE0:  CB B9
 res 7, d               ;; 0CE2:  CB BA
 res 7, e               ;; 0CE4:  CB BB
 res 7, h               ;; 0CE6:  CB BC
 res 7, l               ;; 0CE8:  CB BD
 res 7, (hl)            ;; 0CEA:  CB BE
 res 7, a               ;; 0CEC:  CB BF
 set 0, b               ;; 0CEE:  CB C0
 set 0, c               ;; 0CF0:  CB C1
 set 0, d               ;; 0CF2:  CB C2
 set 0, e               ;; 0CF4:  CB C3
 set 0, h               ;; 0CF6:  CB C4
 set 0, l               ;; 0CF8:  CB C5
 set 0, (hl)            ;; 0CFA:  CB C6
 set 0, a               ;; 0CFC:  CB C7
 set 1, b               ;; 0CFE:  CB C8
 set 1, c               ;; 0D00:  CB C9
 set 1, d               ;; 0D02:  CB CA
 set 1, e               ;; 0D04:  CB CB
 set 1, h               ;; 0D06:  CB CC
 set 1, l               ;; 0D08:  CB CD
 set 1, (hl)            ;; 0D0A:  CB CE
 set 1, a               ;; 0D0C:  CB CF
 set 2, b               ;; 0D0E:  CB D0
 set 2, c               ;; 0D10:  CB D1
 set 2, d               ;; 0D12:  CB D2
 set 2, e               ;; 0D14:  CB D3
 set 2, h               ;; 0D16:  CB D4
 set 2, l               ;; 0D18:  CB D5
 set 2, (hl)            ;; 0D1A:  CB D6
 set 2, a               ;; 0D1C:  CB D7
 set 3, b               ;; 0D1E:  CB D8
 set 3, c               ;; 0D20:  CB D9
 set 3, d               ;; 0D22:  CB DA
 set 3, e               ;; 0D24:  CB DB
 set 3, h               ;; 0D26:  CB DC
 set 3, l               ;; 0D28:  CB DD
 set 3, (hl)            ;; 0D2A:  CB DE
 set 3, a               ;; 0D2C:  CB DF
 set 4, b               ;; 0D2E:  CB E0
 set 4, c               ;; 0D30:  CB E1
 set 4, d               ;; 0D32:  CB E2
 set 4, e               ;; 0D34:  CB E3
 set 4, h               ;; 0D36:  CB E4
 set 4, l               ;; 0D38:  CB E5
 set 4, (hl)            ;; 0D3A:  CB E6
 set 4, a               ;; 0D3C:  CB E7
 set 5, b               ;; 0D3E:  CB E8
 set 5, c               ;; 0D40:  CB E9
 set 5, d               ;; 0D42:  CB EA
 set 5, e               ;; 0D44:  CB EB
 set 5, h               ;; 0D46:  CB EC
 set 5, l               ;; 0D48:  CB ED
 set 5, (hl)            ;; 0D4A:  CB EE
 set 5, a               ;; 0D4C:  CB EF
 set 6, b               ;; 0D4E:  CB F0
 set 6, c               ;; 0D50:  CB F1
 set 6, d               ;; 0D52:  CB F2
 set 6, e               ;; 0D54:  CB F3
 set 6, h               ;; 0D56:  CB F4
 set 6, l               ;; 0D58:  CB F5
 set 6, (hl)            ;; 0D5A:  CB F6
 set 6, a               ;; 0D5C:  CB F7
 set 7, b               ;; 0D5E:  CB F8
 set 7, c               ;; 0D60:  CB F9
 set 7, d               ;; 0D62:  CB FA
 set 7, e               ;; 0D64:  CB FB
 set 7, h               ;; 0D66:  CB FC
 set 7, l               ;; 0D68:  CB FD
 set 7, (hl)            ;; 0D6A:  CB FE
 set 7, a               ;; 0D6C:  CB FF
 res 0, b'              ;; 0D6E:  76 CB 80
 res 0, c'              ;; 0D71:  76 CB 81
 res 0, d'              ;; 0D74:  76 CB 82
 res 0, e'              ;; 0D77:  76 CB 83
 res 0, h'              ;; 0D7A:  76 CB 84
 res 0, l'              ;; 0D7D:  76 CB 85
 res 0, a'              ;; 0D80:  76 CB 87
 res 1, b'              ;; 0D83:  76 CB 88
 res 1, c'              ;; 0D86:  76 CB 89
 res 1, d'              ;; 0D89:  76 CB 8A
 res 1, e'              ;; 0D8C:  76 CB 8B
 res 1, h'              ;; 0D8F:  76 CB 8C
 res 1, l'              ;; 0D92:  76 CB 8D
 res 1, a'              ;; 0D95:  76 CB 8F
 res 2, b'              ;; 0D98:  76 CB 90
 res 2, c'              ;; 0D9B:  76 CB 91
 res 2, d'              ;; 0D9E:  76 CB 92
 res 2, e'              ;; 0DA1:  76 CB 93
 res 2, h'              ;; 0DA4:  76 CB 94
 res 2, l'              ;; 0DA7:  76 CB 95
 res 2, a'              ;; 0DAA:  76 CB 97
 res 3, b'              ;; 0DAD:  76 CB 98
 res 3, c'              ;; 0DB0:  76 CB 99
 res 3, d'              ;; 0DB3:  76 CB 9A
 res 3, e'              ;; 0DB6:  76 CB 9B
 res 3, h'              ;; 0DB9:  76 CB 9C
 res 3, l'              ;; 0DBC:  76 CB 9D
 res 3, a'              ;; 0DBF:  76 CB 9F
 res 4, b'              ;; 0DC2:  76 CB A0
 res 4, c'              ;; 0DC5:  76 CB A1
 res 4, d'              ;; 0DC8:  76 CB A2
 res 4, e'              ;; 0DCB:  76 CB A3
 res 4, h'              ;; 0DCE:  76 CB A4
 res 4, l'              ;; 0DD1:  76 CB A5
 res 4, a'              ;; 0DD4:  76 CB A7
 res 5, b'              ;; 0DD7:  76 CB A8
 res 5, c'              ;; 0DDA:  76 CB A9
 res 5, d'              ;; 0DDD:  76 CB AA
 res 5, e'              ;; 0DE0:  76 CB AB
 res 5, h'              ;; 0DE3:  76 CB AC
 res 5, l'              ;; 0DE6:  76 CB AD
 res 5, a'              ;; 0DE9:  76 CB AF
 res 6, b'              ;; 0DEC:  76 CB B0
 res 6, c'              ;; 0DEF:  76 CB B1
 res 6, d'              ;; 0DF2:  76 CB B2
 res 6, e'              ;; 0DF5:  76 CB B3
 res 6, h'              ;; 0DF8:  76 CB B4
 res 6, l'              ;; 0DFB:  76 CB B5
 res 6, a'              ;; 0DFE:  76 CB B7
 res 7, b'              ;; 0E01:  76 CB B8
 res 7, c'              ;; 0E04:  76 CB B9
 res 7, d'              ;; 0E07:  76 CB BA
 res 7, e'              ;; 0E0A:  76 CB BB
 res 7, h'              ;; 0E0D:  76 CB BC
 res 7, l'              ;; 0E10:  76 CB BD
 res 7, a'              ;; 0E13:  76 CB BF
 set 0, b'              ;; 0E16:  76 CB C0
 set 0, c'              ;; 0E19:  76 CB C1
 set 0, d'              ;; 0E1C:  76 CB C2
 set 0, e'              ;; 0E1F:  76 CB C3
 set 0, h'              ;; 0E22:  76 CB C4
 set 0, l'              ;; 0E25:  76 CB C5
 set 0, a'              ;; 0E28:  76 CB C7
 set 1, b'              ;; 0E2B:  76 CB C8
 set 1, c'              ;; 0E2E:  76 CB C9
 set 1, d'              ;; 0E31:  76 CB CA
 set 1, e'              ;; 0E34:  76 CB CB
 set 1, h'              ;; 0E37:  76 CB CC
 set 1, l'              ;; 0E3A:  76 CB CD
 set 1, a'              ;; 0E3D:  76 CB CF
 set 2, b'              ;; 0E40:  76 CB D0
 set 2, c'              ;; 0E43:  76 CB D1
 set 2, d'              ;; 0E46:  76 CB D2
 set 2, e'              ;; 0E49:  76 CB D3
 set 2, h'              ;; 0E4C:  76 CB D4
 set 2, l'              ;; 0E4F:  76 CB D5
 set 2, a'              ;; 0E52:  76 CB D7
 set 3, b'              ;; 0E55:  76 CB D8
 set 3, c'              ;; 0E58:  76 CB D9
 set 3, d'              ;; 0E5B:  76 CB DA
 set 3, e'              ;; 0E5E:  76 CB DB
 set 3, h'              ;; 0E61:  76 CB DC
 set 3, l'              ;; 0E64:  76 CB DD
 set 3, a'              ;; 0E67:  76 CB DF
 set 4, b'              ;; 0E6A:  76 CB E0
 set 4, c'              ;; 0E6D:  76 CB E1
 set 4, d'              ;; 0E70:  76 CB E2
 set 4, e'              ;; 0E73:  76 CB E3
 set 4, h'              ;; 0E76:  76 CB E4
 set 4, l'              ;; 0E79:  76 CB E5
 set 4, a'              ;; 0E7C:  76 CB E7
 set 5, b'              ;; 0E7F:  76 CB E8
 set 5, c'              ;; 0E82:  76 CB E9
 set 5, d'              ;; 0E85:  76 CB EA
 set 5, e'              ;; 0E88:  76 CB EB
 set 5, h'              ;; 0E8B:  76 CB EC
 set 5, l'              ;; 0E8E:  76 CB ED
 set 5, a'              ;; 0E91:  76 CB EF
 set 6, b'              ;; 0E94:  76 CB F0
 set 6, c'              ;; 0E97:  76 CB F1
 set 6, d'              ;; 0E9A:  76 CB F2
 set 6, e'              ;; 0E9D:  76 CB F3
 set 6, h'              ;; 0EA0:  76 CB F4
 set 6, l'              ;; 0EA3:  76 CB F5
 set 6, a'              ;; 0EA6:  76 CB F7
 set 7, b'              ;; 0EA9:  76 CB F8
 set 7, c'              ;; 0EAC:  76 CB F9
 set 7, d'              ;; 0EAF:  76 CB FA
 set 7, e'              ;; 0EB2:  76 CB FB
 set 7, h'              ;; 0EB5:  76 CB FC
 set 7, l'              ;; 0EB8:  76 CB FD
 set 7, a'              ;; 0EBB:  76 CB FF
 bit 0, (ix+-128)       ;; 0EBE:  DD CB 80 46
 bit 0, (ix)            ;; 0EC2:  DD CB 00 46
 bit 0, (ix+127)        ;; 0EC6:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0ECA:  DD CB 80 4E
 bit 1, (ix)            ;; 0ECE:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0ED2:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0ED6:  DD CB 80 56
 bit 2, (ix)            ;; 0EDA:  DD CB 00 56
 bit 2, (ix+127)        ;; 0EDE:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0EE2:  DD CB 80 5E
 bit 3, (ix)            ;; 0EE6:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0EEA:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0EEE:  DD CB 80 66
 bit 4, (ix)            ;; 0EF2:  DD CB 00 66
 bit 4, (ix+127)        ;; 0EF6:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0EFA:  DD CB 80 6E
 bit 5, (ix)            ;; 0EFE:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0F02:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0F06:  DD CB 80 76
 bit 6, (ix)            ;; 0F0A:  DD CB 00 76
 bit 6, (ix+127)        ;; 0F0E:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0F12:  DD CB 80 7E
 bit 7, (ix)            ;; 0F16:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0F1A:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0F1E:  DD CB 80 86
 res 0, (ix)            ;; 0F22:  DD CB 00 86
 res 0, (ix+127)        ;; 0F26:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0F2A:  DD CB 80 8E
 res 1, (ix)            ;; 0F2E:  DD CB 00 8E
 res 1, (ix+127)        ;; 0F32:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0F36:  DD CB 80 96
 res 2, (ix)            ;; 0F3A:  DD CB 00 96
 res 2, (ix+127)        ;; 0F3E:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0F42:  DD CB 80 9E
 res 3, (ix)            ;; 0F46:  DD CB 00 9E
 res 3, (ix+127)        ;; 0F4A:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0F4E:  DD CB 80 A6
 res 4, (ix)            ;; 0F52:  DD CB 00 A6
 res 4, (ix+127)        ;; 0F56:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0F5A:  DD CB 80 AE
 res 5, (ix)            ;; 0F5E:  DD CB 00 AE
 res 5, (ix+127)        ;; 0F62:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0F66:  DD CB 80 B6
 res 6, (ix)            ;; 0F6A:  DD CB 00 B6
 res 6, (ix+127)        ;; 0F6E:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0F72:  DD CB 80 BE
 res 7, (ix)            ;; 0F76:  DD CB 00 BE
 res 7, (ix+127)        ;; 0F7A:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0F7E:  DD CB 80 C6
 set 0, (ix)            ;; 0F82:  DD CB 00 C6
 set 0, (ix+127)        ;; 0F86:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0F8A:  DD CB 80 CE
 set 1, (ix)            ;; 0F8E:  DD CB 00 CE
 set 1, (ix+127)        ;; 0F92:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0F96:  DD CB 80 D6
 set 2, (ix)            ;; 0F9A:  DD CB 00 D6
 set 2, (ix+127)        ;; 0F9E:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0FA2:  DD CB 80 DE
 set 3, (ix)            ;; 0FA6:  DD CB 00 DE
 set 3, (ix+127)        ;; 0FAA:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0FAE:  DD CB 80 E6
 set 4, (ix)            ;; 0FB2:  DD CB 00 E6
 set 4, (ix+127)        ;; 0FB6:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0FBA:  DD CB 80 EE
 set 5, (ix)            ;; 0FBE:  DD CB 00 EE
 set 5, (ix+127)        ;; 0FC2:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0FC6:  DD CB 80 F6
 set 6, (ix)            ;; 0FCA:  DD CB 00 F6
 set 6, (ix+127)        ;; 0FCE:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0FD2:  DD CB 80 FE
 set 7, (ix)            ;; 0FD6:  DD CB 00 FE
 set 7, (ix+127)        ;; 0FDA:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0FDE:  FD CB 80 46
 bit 0, (iy)            ;; 0FE2:  FD CB 00 46
 bit 0, (iy+127)        ;; 0FE6:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0FEA:  FD CB 80 4E
 bit 1, (iy)            ;; 0FEE:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0FF2:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0FF6:  FD CB 80 56
 bit 2, (iy)            ;; 0FFA:  FD CB 00 56
 bit 2, (iy+127)        ;; 0FFE:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 1002:  FD CB 80 5E
 bit 3, (iy)            ;; 1006:  FD CB 00 5E
 bit 3, (iy+127)        ;; 100A:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 100E:  FD CB 80 66
 bit 4, (iy)            ;; 1012:  FD CB 00 66
 bit 4, (iy+127)        ;; 1016:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 101A:  FD CB 80 6E
 bit 5, (iy)            ;; 101E:  FD CB 00 6E
 bit 5, (iy+127)        ;; 1022:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 1026:  FD CB 80 76
 bit 6, (iy)            ;; 102A:  FD CB 00 76
 bit 6, (iy+127)        ;; 102E:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 1032:  FD CB 80 7E
 bit 7, (iy)            ;; 1036:  FD CB 00 7E
 bit 7, (iy+127)        ;; 103A:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 103E:  FD CB 80 86
 res 0, (iy)            ;; 1042:  FD CB 00 86
 res 0, (iy+127)        ;; 1046:  FD CB 7F 86
 res 1, (iy+-128)       ;; 104A:  FD CB 80 8E
 res 1, (iy)            ;; 104E:  FD CB 00 8E
 res 1, (iy+127)        ;; 1052:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 1056:  FD CB 80 96
 res 2, (iy)            ;; 105A:  FD CB 00 96
 res 2, (iy+127)        ;; 105E:  FD CB 7F 96
 res 3, (iy+-128)       ;; 1062:  FD CB 80 9E
 res 3, (iy)            ;; 1066:  FD CB 00 9E
 res 3, (iy+127)        ;; 106A:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 106E:  FD CB 80 A6
 res 4, (iy)            ;; 1072:  FD CB 00 A6
 res 4, (iy+127)        ;; 1076:  FD CB 7F A6
 res 5, (iy+-128)       ;; 107A:  FD CB 80 AE
 res 5, (iy)            ;; 107E:  FD CB 00 AE
 res 5, (iy+127)        ;; 1082:  FD CB 7F AE
 res 6, (iy+-128)       ;; 1086:  FD CB 80 B6
 res 6, (iy)            ;; 108A:  FD CB 00 B6
 res 6, (iy+127)        ;; 108E:  FD CB 7F B6
 res 7, (iy+-128)       ;; 1092:  FD CB 80 BE
 res 7, (iy)            ;; 1096:  FD CB 00 BE
 res 7, (iy+127)        ;; 109A:  FD CB 7F BE
 set 0, (iy+-128)       ;; 109E:  FD CB 80 C6
 set 0, (iy)            ;; 10A2:  FD CB 00 C6
 set 0, (iy+127)        ;; 10A6:  FD CB 7F C6
 set 1, (iy+-128)       ;; 10AA:  FD CB 80 CE
 set 1, (iy)            ;; 10AE:  FD CB 00 CE
 set 1, (iy+127)        ;; 10B2:  FD CB 7F CE
 set 2, (iy+-128)       ;; 10B6:  FD CB 80 D6
 set 2, (iy)            ;; 10BA:  FD CB 00 D6
 set 2, (iy+127)        ;; 10BE:  FD CB 7F D6
 set 3, (iy+-128)       ;; 10C2:  FD CB 80 DE
 set 3, (iy)            ;; 10C6:  FD CB 00 DE
 set 3, (iy+127)        ;; 10CA:  FD CB 7F DE
 set 4, (iy+-128)       ;; 10CE:  FD CB 80 E6
 set 4, (iy)            ;; 10D2:  FD CB 00 E6
 set 4, (iy+127)        ;; 10D6:  FD CB 7F E6
 set 5, (iy+-128)       ;; 10DA:  FD CB 80 EE
 set 5, (iy)            ;; 10DE:  FD CB 00 EE
 set 5, (iy+127)        ;; 10E2:  FD CB 7F EE
 set 6, (iy+-128)       ;; 10E6:  FD CB 80 F6
 set 6, (iy)            ;; 10EA:  FD CB 00 F6
 set 6, (iy+127)        ;; 10EE:  FD CB 7F F6
 set 7, (iy+-128)       ;; 10F2:  FD CB 80 FE
 set 7, (iy)            ;; 10F6:  FD CB 00 FE
 set 7, (iy+127)        ;; 10FA:  FD CB 7F FE
 ldi                    ;; 10FE:  ED A0
 ldir                   ;; 1100:  ED B0
 ldd                    ;; 1102:  ED A8
 lddr                   ;; 1104:  ED B8
 ldisr                  ;; 1106:  ED 90
 lddsr                  ;; 1108:  ED 98
 lsdr                   ;; 110A:  ED F8
 lsir                   ;; 110C:  ED F0
 lsddr                  ;; 110E:  ED D8
 lsidr                  ;; 1110:  ED D0
 nop                    ;; 1112:  00
 ld a, xpc              ;; 1113:  ED 77
 ld a', xpc             ;; 1115:  76 ED 77
 ld xpc, a              ;; 1118:  ED 67
 rdmode                 ;; 111A:  ED 7F
 setusr                 ;; 111C:  ED 6F
 sures                  ;; 111E:  ED 7D
 syscall                ;; 1120:  ED 75
 jp 0                   ;; 1122:  C3 00 00
 jp 291                 ;; 1125:  C3 23 01
 jp 17767               ;; 1128:  C3 67 45
 jp 35243               ;; 112B:  C3 AB 89
 jp 52719               ;; 112E:  C3 EF CD
 jp 65535               ;; 1131:  C3 FF FF
 jp nz, 0               ;; 1134:  C2 00 00
 jp nz, 291             ;; 1137:  C2 23 01
 jp nz, 17767           ;; 113A:  C2 67 45
 jp nz, 35243           ;; 113D:  C2 AB 89
 jp nz, 52719           ;; 1140:  C2 EF CD
 jp nz, 65535           ;; 1143:  C2 FF FF
 jp z, 0                ;; 1146:  CA 00 00
 jp z, 291              ;; 1149:  CA 23 01
 jp z, 17767            ;; 114C:  CA 67 45
 jp z, 35243            ;; 114F:  CA AB 89
 jp z, 52719            ;; 1152:  CA EF CD
 jp z, 65535            ;; 1155:  CA FF FF
 jp nc, 0               ;; 1158:  D2 00 00
 jp nc, 291             ;; 115B:  D2 23 01
 jp nc, 17767           ;; 115E:  D2 67 45
 jp nc, 35243           ;; 1161:  D2 AB 89
 jp nc, 52719           ;; 1164:  D2 EF CD
 jp nc, 65535           ;; 1167:  D2 FF FF
 jp c, 0                ;; 116A:  DA 00 00
 jp c, 291              ;; 116D:  DA 23 01
 jp c, 17767            ;; 1170:  DA 67 45
 jp c, 35243            ;; 1173:  DA AB 89
 jp c, 52719            ;; 1176:  DA EF CD
 jp c, 65535            ;; 1179:  DA FF FF
 jp po, 0               ;; 117C:  E2 00 00
 jp po, 291             ;; 117F:  E2 23 01
 jp po, 17767           ;; 1182:  E2 67 45
 jp po, 35243           ;; 1185:  E2 AB 89
 jp po, 52719           ;; 1188:  E2 EF CD
 jp po, 65535           ;; 118B:  E2 FF FF
 jp pe, 0               ;; 118E:  EA 00 00
 jp pe, 291             ;; 1191:  EA 23 01
 jp pe, 17767           ;; 1194:  EA 67 45
 jp pe, 35243           ;; 1197:  EA AB 89
 jp pe, 52719           ;; 119A:  EA EF CD
 jp pe, 65535           ;; 119D:  EA FF FF
 jp p, 0                ;; 11A0:  F2 00 00
 jp p, 291              ;; 11A3:  F2 23 01
 jp p, 17767            ;; 11A6:  F2 67 45
 jp p, 35243            ;; 11A9:  F2 AB 89
 jp p, 52719            ;; 11AC:  F2 EF CD
 jp p, 65535            ;; 11AF:  F2 FF FF
 jp m, 0                ;; 11B2:  FA 00 00
 jp m, 291              ;; 11B5:  FA 23 01
 jp m, 17767            ;; 11B8:  FA 67 45
 jp m, 35243            ;; 11BB:  FA AB 89
 jp m, 52719            ;; 11BE:  FA EF CD
 jp m, 65535            ;; 11C1:  FA FF FF
 jp lz, 0               ;; 11C4:  E2 00 00
 jp lz, 291             ;; 11C7:  E2 23 01
 jp lz, 17767           ;; 11CA:  E2 67 45
 jp lz, 35243           ;; 11CD:  E2 AB 89
 jp lz, 52719           ;; 11D0:  E2 EF CD
 jp lz, 65535           ;; 11D3:  E2 FF FF
 jp lo, 0               ;; 11D6:  EA 00 00
 jp lo, 291             ;; 11D9:  EA 23 01
 jp lo, 17767           ;; 11DC:  EA 67 45
 jp lo, 35243           ;; 11DF:  EA AB 89
 jp lo, 52719           ;; 11E2:  EA EF CD
 jp lo, 65535           ;; 11E5:  EA FF FF
 jp (hl)                ;; 11E8:  E9
 jp (ix)                ;; 11E9:  DD E9
 jp (iy)                ;; 11EB:  FD E9
 djnz ASMPC             ;; 11ED:  10 FE
 djnz b, ASMPC          ;; 11EF:  10 FE
 djnz b', ASMPC         ;; 11F1:  76 10 FE
 jr ASMPC               ;; 11F4:  18 FE
 jr nz, ASMPC           ;; 11F6:  20 FE
 jr z, ASMPC            ;; 11F8:  28 FE
 jr nc, ASMPC           ;; 11FA:  30 FE
 jr c, ASMPC            ;; 11FC:  38 FE
 call 0                 ;; 11FE:  CD 00 00
 call 291               ;; 1201:  CD 23 01
 call 17767             ;; 1204:  CD 67 45
 call 35243             ;; 1207:  CD AB 89
 call 52719             ;; 120A:  CD EF CD
 call 65535             ;; 120D:  CD FF FF
 ret                    ;; 1210:  C9
 ret nz                 ;; 1211:  C0
 ret z                  ;; 1212:  C8
 ret nc                 ;; 1213:  D0
 ret c                  ;; 1214:  D8
 ret po                 ;; 1215:  E0
 ret pe                 ;; 1216:  E8
 ret p                  ;; 1217:  F0
 ret m                  ;; 1218:  F8
 ret lz                 ;; 1219:  E0
 ret lo                 ;; 121A:  E8
 rst 16                 ;; 121B:  D7
 rst 24                 ;; 121C:  DF
 rst 32                 ;; 121D:  E7
 rst 40                 ;; 121E:  EF
 rst 56                 ;; 121F:  FF
 ipset 0                ;; 1220:  ED 46
 ipset 1                ;; 1222:  ED 56
 ipset 2                ;; 1224:  ED 4E
 ipset 3                ;; 1226:  ED 5E
 ipres                  ;; 1228:  ED 5D
 ld iir, a              ;; 122A:  ED 4F
 ld a, iir              ;; 122C:  ED 5F
 ld a', iir             ;; 122E:  76 ED 5F
 ld eir, a              ;; 1231:  ED 47
 ld a, eir              ;; 1233:  ED 57
 ld a', eir             ;; 1235:  76 ED 57
 reti                   ;; 1238:  ED 4D
 idet                   ;; 123A:  5B
