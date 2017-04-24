 ld b, b                ;; 0000:  40
 ld b, c                ;; 0001:  41
 ld b, d                ;; 0002:  42
 ld b, e                ;; 0003:  43
 ld b, h                ;; 0004:  44
 ld b, l                ;; 0005:  45
 ld b, a                ;; 0006:  47
 ld c, b                ;; 0007:  48
 ld c, c                ;; 0008:  49
 ld c, d                ;; 0009:  4A
 ld c, e                ;; 000A:  4B
 ld c, h                ;; 000B:  4C
 ld c, l                ;; 000C:  4D
 ld c, a                ;; 000D:  4F
 ld d, b                ;; 000E:  50
 ld d, c                ;; 000F:  51
 ld d, d                ;; 0010:  52
 ld d, e                ;; 0011:  53
 ld d, h                ;; 0012:  54
 ld d, l                ;; 0013:  55
 ld d, a                ;; 0014:  57
 ld e, b                ;; 0015:  58
 ld e, c                ;; 0016:  59
 ld e, d                ;; 0017:  5A
 ld e, e                ;; 0018:  5B
 ld e, h                ;; 0019:  5C
 ld e, l                ;; 001A:  5D
 ld e, a                ;; 001B:  5F
 ld h, b                ;; 001C:  60
 ld h, c                ;; 001D:  61
 ld h, d                ;; 001E:  62
 ld h, e                ;; 001F:  63
 ld h, h                ;; 0020:  64
 ld h, l                ;; 0021:  65
 ld h, a                ;; 0022:  67
 ld l, b                ;; 0023:  68
 ld l, c                ;; 0024:  69
 ld l, d                ;; 0025:  6A
 ld l, e                ;; 0026:  6B
 ld l, h                ;; 0027:  6C
 ld l, l                ;; 0028:  6D
 ld l, a                ;; 0029:  6F
 ld a, b                ;; 002A:  78
 ld a, c                ;; 002B:  79
 ld a, d                ;; 002C:  7A
 ld a, e                ;; 002D:  7B
 ld a, h                ;; 002E:  7C
 ld a, l                ;; 002F:  7D
 ld a, a                ;; 0030:  7F
 ld b, 0                ;; 0031:  06 00
 ld b, 85               ;; 0033:  06 55
 ld b, 170              ;; 0035:  06 AA
 ld b, 255              ;; 0037:  06 FF
 ld c, 0                ;; 0039:  0E 00
 ld c, 85               ;; 003B:  0E 55
 ld c, 170              ;; 003D:  0E AA
 ld c, 255              ;; 003F:  0E FF
 ld d, 0                ;; 0041:  16 00
 ld d, 85               ;; 0043:  16 55
 ld d, 170              ;; 0045:  16 AA
 ld d, 255              ;; 0047:  16 FF
 ld e, 0                ;; 0049:  1E 00
 ld e, 85               ;; 004B:  1E 55
 ld e, 170              ;; 004D:  1E AA
 ld e, 255              ;; 004F:  1E FF
 ld h, 0                ;; 0051:  26 00
 ld h, 85               ;; 0053:  26 55
 ld h, 170              ;; 0055:  26 AA
 ld h, 255              ;; 0057:  26 FF
 ld l, 0                ;; 0059:  2E 00
 ld l, 85               ;; 005B:  2E 55
 ld l, 170              ;; 005D:  2E AA
 ld l, 255              ;; 005F:  2E FF
 ld a, 0                ;; 0061:  3E 00
 ld a, 85               ;; 0063:  3E 55
 ld a, 170              ;; 0065:  3E AA
 ld a, 255              ;; 0067:  3E FF
 ld b, (hl)             ;; 0069:  46
 ld c, (hl)             ;; 006A:  4E
 ld d, (hl)             ;; 006B:  56
 ld e, (hl)             ;; 006C:  5E
 ld h, (hl)             ;; 006D:  66
 ld l, (hl)             ;; 006E:  6E
 ld a, (hl)             ;; 006F:  7E
 ld b, (ix + -128)      ;; 0070:  DD 46 80
 ld b, (ix + 0)         ;; 0073:  DD 46 00
 ld b, (ix + 127)       ;; 0076:  DD 46 7F
 ld c, (ix + -128)      ;; 0079:  DD 4E 80
 ld c, (ix + 0)         ;; 007C:  DD 4E 00
 ld c, (ix + 127)       ;; 007F:  DD 4E 7F
 ld d, (ix + -128)      ;; 0082:  DD 56 80
 ld d, (ix + 0)         ;; 0085:  DD 56 00
 ld d, (ix + 127)       ;; 0088:  DD 56 7F
 ld e, (ix + -128)      ;; 008B:  DD 5E 80
 ld e, (ix + 0)         ;; 008E:  DD 5E 00
 ld e, (ix + 127)       ;; 0091:  DD 5E 7F
 ld h, (ix + -128)      ;; 0094:  DD 66 80
 ld h, (ix + 0)         ;; 0097:  DD 66 00
 ld h, (ix + 127)       ;; 009A:  DD 66 7F
 ld l, (ix + -128)      ;; 009D:  DD 6E 80
 ld l, (ix + 0)         ;; 00A0:  DD 6E 00
 ld l, (ix + 127)       ;; 00A3:  DD 6E 7F
 ld a, (ix + -128)      ;; 00A6:  DD 7E 80
 ld a, (ix + 0)         ;; 00A9:  DD 7E 00
 ld a, (ix + 127)       ;; 00AC:  DD 7E 7F
 ld b, (iy + -128)      ;; 00AF:  FD 46 80
 ld b, (iy + 0)         ;; 00B2:  FD 46 00
 ld b, (iy + 127)       ;; 00B5:  FD 46 7F
 ld c, (iy + -128)      ;; 00B8:  FD 4E 80
 ld c, (iy + 0)         ;; 00BB:  FD 4E 00
 ld c, (iy + 127)       ;; 00BE:  FD 4E 7F
 ld d, (iy + -128)      ;; 00C1:  FD 56 80
 ld d, (iy + 0)         ;; 00C4:  FD 56 00
 ld d, (iy + 127)       ;; 00C7:  FD 56 7F
 ld e, (iy + -128)      ;; 00CA:  FD 5E 80
 ld e, (iy + 0)         ;; 00CD:  FD 5E 00
 ld e, (iy + 127)       ;; 00D0:  FD 5E 7F
 ld h, (iy + -128)      ;; 00D3:  FD 66 80
 ld h, (iy + 0)         ;; 00D6:  FD 66 00
 ld h, (iy + 127)       ;; 00D9:  FD 66 7F
 ld l, (iy + -128)      ;; 00DC:  FD 6E 80
 ld l, (iy + 0)         ;; 00DF:  FD 6E 00
 ld l, (iy + 127)       ;; 00E2:  FD 6E 7F
 ld a, (iy + -128)      ;; 00E5:  FD 7E 80
 ld a, (iy + 0)         ;; 00E8:  FD 7E 00
 ld a, (iy + 127)       ;; 00EB:  FD 7E 7F
 ld (hl), b             ;; 00EE:  70
 ld (hl), c             ;; 00EF:  71
 ld (hl), d             ;; 00F0:  72
 ld (hl), e             ;; 00F1:  73
 ld (hl), h             ;; 00F2:  74
 ld (hl), l             ;; 00F3:  75
 ld (hl), a             ;; 00F4:  77
 ld (ix + -128), b      ;; 00F5:  DD 70 80
 ld (ix + 0), b         ;; 00F8:  DD 70 00
 ld (ix + 127), b       ;; 00FB:  DD 70 7F
 ld (ix + -128), c      ;; 00FE:  DD 71 80
 ld (ix + 0), c         ;; 0101:  DD 71 00
 ld (ix + 127), c       ;; 0104:  DD 71 7F
 ld (ix + -128), d      ;; 0107:  DD 72 80
 ld (ix + 0), d         ;; 010A:  DD 72 00
 ld (ix + 127), d       ;; 010D:  DD 72 7F
 ld (ix + -128), e      ;; 0110:  DD 73 80
 ld (ix + 0), e         ;; 0113:  DD 73 00
 ld (ix + 127), e       ;; 0116:  DD 73 7F
 ld (ix + -128), h      ;; 0119:  DD 74 80
 ld (ix + 0), h         ;; 011C:  DD 74 00
 ld (ix + 127), h       ;; 011F:  DD 74 7F
 ld (ix + -128), l      ;; 0122:  DD 75 80
 ld (ix + 0), l         ;; 0125:  DD 75 00
 ld (ix + 127), l       ;; 0128:  DD 75 7F
 ld (ix + -128), a      ;; 012B:  DD 77 80
 ld (ix + 0), a         ;; 012E:  DD 77 00
 ld (ix + 127), a       ;; 0131:  DD 77 7F
 ld (iy + -128), b      ;; 0134:  FD 70 80
 ld (iy + 0), b         ;; 0137:  FD 70 00
 ld (iy + 127), b       ;; 013A:  FD 70 7F
 ld (iy + -128), c      ;; 013D:  FD 71 80
 ld (iy + 0), c         ;; 0140:  FD 71 00
 ld (iy + 127), c       ;; 0143:  FD 71 7F
 ld (iy + -128), d      ;; 0146:  FD 72 80
 ld (iy + 0), d         ;; 0149:  FD 72 00
 ld (iy + 127), d       ;; 014C:  FD 72 7F
 ld (iy + -128), e      ;; 014F:  FD 73 80
 ld (iy + 0), e         ;; 0152:  FD 73 00
 ld (iy + 127), e       ;; 0155:  FD 73 7F
 ld (iy + -128), h      ;; 0158:  FD 74 80
 ld (iy + 0), h         ;; 015B:  FD 74 00
 ld (iy + 127), h       ;; 015E:  FD 74 7F
 ld (iy + -128), l      ;; 0161:  FD 75 80
 ld (iy + 0), l         ;; 0164:  FD 75 00
 ld (iy + 127), l       ;; 0167:  FD 75 7F
 ld (iy + -128), a      ;; 016A:  FD 77 80
 ld (iy + 0), a         ;; 016D:  FD 77 00
 ld (iy + 127), a       ;; 0170:  FD 77 7F
 ld (hl), 0             ;; 0173:  36 00
 ld (hl), 85            ;; 0175:  36 55
 ld (hl), 170           ;; 0177:  36 AA
 ld (hl), 255           ;; 0179:  36 FF
 ld (ix + -128), 0      ;; 017B:  DD 36 80 00
 ld (ix + 0), 0         ;; 017F:  DD 36 00 00
 ld (ix + 127), 0       ;; 0183:  DD 36 7F 00
 ld (ix + -128), 85     ;; 0187:  DD 36 80 55
 ld (ix + 0), 85        ;; 018B:  DD 36 00 55
 ld (ix + 127), 85      ;; 018F:  DD 36 7F 55
 ld (ix + -128), 170    ;; 0193:  DD 36 80 AA
 ld (ix + 0), 170       ;; 0197:  DD 36 00 AA
 ld (ix + 127), 170     ;; 019B:  DD 36 7F AA
 ld (ix + -128), 255    ;; 019F:  DD 36 80 FF
 ld (ix + 0), 255       ;; 01A3:  DD 36 00 FF
 ld (ix + 127), 255     ;; 01A7:  DD 36 7F FF
 ld (iy + -128), 0      ;; 01AB:  FD 36 80 00
 ld (iy + 0), 0         ;; 01AF:  FD 36 00 00
 ld (iy + 127), 0       ;; 01B3:  FD 36 7F 00
 ld (iy + -128), 85     ;; 01B7:  FD 36 80 55
 ld (iy + 0), 85        ;; 01BB:  FD 36 00 55
 ld (iy + 127), 85      ;; 01BF:  FD 36 7F 55
 ld (iy + -128), 170    ;; 01C3:  FD 36 80 AA
 ld (iy + 0), 170       ;; 01C7:  FD 36 00 AA
 ld (iy + 127), 170     ;; 01CB:  FD 36 7F AA
 ld (iy + -128), 255    ;; 01CF:  FD 36 80 FF
 ld (iy + 0), 255       ;; 01D3:  FD 36 00 FF
 ld (iy + 127), 255     ;; 01D7:  FD 36 7F FF
 ld a, (bc)             ;; 01DB:  0A
 ld a, (de)             ;; 01DC:  1A
 ld (bc), a             ;; 01DD:  02
 ld (de), a             ;; 01DE:  12
 ld a, (0)              ;; 01DF:  3A 00 00
 ld a, (291)            ;; 01E2:  3A 23 01
 ld a, (17767)          ;; 01E5:  3A 67 45
 ld a, (35243)          ;; 01E8:  3A AB 89
 ld a, (52719)          ;; 01EB:  3A EF CD
 ld a, (65535)          ;; 01EE:  3A FF FF
 ld (0), a              ;; 01F1:  32 00 00
 ld (291), a            ;; 01F4:  32 23 01
 ld (17767), a          ;; 01F7:  32 67 45
 ld (35243), a          ;; 01FA:  32 AB 89
 ld (52719), a          ;; 01FD:  32 EF CD
 ld (65535), a          ;; 0200:  32 FF FF
 add a, b               ;; 0203:  80
 add a, c               ;; 0204:  81
 add a, d               ;; 0205:  82
 add a, e               ;; 0206:  83
 add a, h               ;; 0207:  84
 add a, l               ;; 0208:  85
 add a, (hl)            ;; 0209:  86
 add a, a               ;; 020A:  87
 adc a, b               ;; 020B:  88
 adc a, c               ;; 020C:  89
 adc a, d               ;; 020D:  8A
 adc a, e               ;; 020E:  8B
 adc a, h               ;; 020F:  8C
 adc a, l               ;; 0210:  8D
 adc a, (hl)            ;; 0211:  8E
 adc a, a               ;; 0212:  8F
 sub a, b               ;; 0213:  90
 sub a, c               ;; 0214:  91
 sub a, d               ;; 0215:  92
 sub a, e               ;; 0216:  93
 sub a, h               ;; 0217:  94
 sub a, l               ;; 0218:  95
 sub a, (hl)            ;; 0219:  96
 sub a, a               ;; 021A:  97
 sbc a, b               ;; 021B:  98
 sbc a, c               ;; 021C:  99
 sbc a, d               ;; 021D:  9A
 sbc a, e               ;; 021E:  9B
 sbc a, h               ;; 021F:  9C
 sbc a, l               ;; 0220:  9D
 sbc a, (hl)            ;; 0221:  9E
 sbc a, a               ;; 0222:  9F
 and a, b               ;; 0223:  A0
 and a, c               ;; 0224:  A1
 and a, d               ;; 0225:  A2
 and a, e               ;; 0226:  A3
 and a, h               ;; 0227:  A4
 and a, l               ;; 0228:  A5
 and a, (hl)            ;; 0229:  A6
 and a, a               ;; 022A:  A7
 xor a, b               ;; 022B:  A8
 xor a, c               ;; 022C:  A9
 xor a, d               ;; 022D:  AA
 xor a, e               ;; 022E:  AB
 xor a, h               ;; 022F:  AC
 xor a, l               ;; 0230:  AD
 xor a, (hl)            ;; 0231:  AE
 xor a, a               ;; 0232:  AF
 or a, b                ;; 0233:  B0
 or a, c                ;; 0234:  B1
 or a, d                ;; 0235:  B2
 or a, e                ;; 0236:  B3
 or a, h                ;; 0237:  B4
 or a, l                ;; 0238:  B5
 or a, (hl)             ;; 0239:  B6
 or a, a                ;; 023A:  B7
 cp a, b                ;; 023B:  B8
 cp a, c                ;; 023C:  B9
 cp a, d                ;; 023D:  BA
 cp a, e                ;; 023E:  BB
 cp a, h                ;; 023F:  BC
 cp a, l                ;; 0240:  BD
 cp a, (hl)             ;; 0241:  BE
 cp a, a                ;; 0242:  BF
 add b                  ;; 0243:  80
 add c                  ;; 0244:  81
 add d                  ;; 0245:  82
 add e                  ;; 0246:  83
 add h                  ;; 0247:  84
 add l                  ;; 0248:  85
 add (hl)               ;; 0249:  86
 add a                  ;; 024A:  87
 adc b                  ;; 024B:  88
 adc c                  ;; 024C:  89
 adc d                  ;; 024D:  8A
 adc e                  ;; 024E:  8B
 adc h                  ;; 024F:  8C
 adc l                  ;; 0250:  8D
 adc (hl)               ;; 0251:  8E
 adc a                  ;; 0252:  8F
 sub b                  ;; 0253:  90
 sub c                  ;; 0254:  91
 sub d                  ;; 0255:  92
 sub e                  ;; 0256:  93
 sub h                  ;; 0257:  94
 sub l                  ;; 0258:  95
 sub (hl)               ;; 0259:  96
 sub a                  ;; 025A:  97
 sbc b                  ;; 025B:  98
 sbc c                  ;; 025C:  99
 sbc d                  ;; 025D:  9A
 sbc e                  ;; 025E:  9B
 sbc h                  ;; 025F:  9C
 sbc l                  ;; 0260:  9D
 sbc (hl)               ;; 0261:  9E
 sbc a                  ;; 0262:  9F
 and b                  ;; 0263:  A0
 and c                  ;; 0264:  A1
 and d                  ;; 0265:  A2
 and e                  ;; 0266:  A3
 and h                  ;; 0267:  A4
 and l                  ;; 0268:  A5
 and (hl)               ;; 0269:  A6
 and a                  ;; 026A:  A7
 xor b                  ;; 026B:  A8
 xor c                  ;; 026C:  A9
 xor d                  ;; 026D:  AA
 xor e                  ;; 026E:  AB
 xor h                  ;; 026F:  AC
 xor l                  ;; 0270:  AD
 xor (hl)               ;; 0271:  AE
 xor a                  ;; 0272:  AF
 or b                   ;; 0273:  B0
 or c                   ;; 0274:  B1
 or d                   ;; 0275:  B2
 or e                   ;; 0276:  B3
 or h                   ;; 0277:  B4
 or l                   ;; 0278:  B5
 or (hl)                ;; 0279:  B6
 or a                   ;; 027A:  B7
 cp b                   ;; 027B:  B8
 cp c                   ;; 027C:  B9
 cp d                   ;; 027D:  BA
 cp e                   ;; 027E:  BB
 cp h                   ;; 027F:  BC
 cp l                   ;; 0280:  BD
 cp (hl)                ;; 0281:  BE
 cp a                   ;; 0282:  BF
 add a, (ix+-128)       ;; 0283:  DD 86 80
 add a, (ix+0)          ;; 0286:  DD 86 00
 add a, (ix+127)        ;; 0289:  DD 86 7F
 adc a, (ix+-128)       ;; 028C:  DD 8E 80
 adc a, (ix+0)          ;; 028F:  DD 8E 00
 adc a, (ix+127)        ;; 0292:  DD 8E 7F
 sub a, (ix+-128)       ;; 0295:  DD 96 80
 sub a, (ix+0)          ;; 0298:  DD 96 00
 sub a, (ix+127)        ;; 029B:  DD 96 7F
 sbc a, (ix+-128)       ;; 029E:  DD 9E 80
 sbc a, (ix+0)          ;; 02A1:  DD 9E 00
 sbc a, (ix+127)        ;; 02A4:  DD 9E 7F
 and a, (ix+-128)       ;; 02A7:  DD A6 80
 and a, (ix+0)          ;; 02AA:  DD A6 00
 and a, (ix+127)        ;; 02AD:  DD A6 7F
 xor a, (ix+-128)       ;; 02B0:  DD AE 80
 xor a, (ix+0)          ;; 02B3:  DD AE 00
 xor a, (ix+127)        ;; 02B6:  DD AE 7F
 or a, (ix+-128)        ;; 02B9:  DD B6 80
 or a, (ix+0)           ;; 02BC:  DD B6 00
 or a, (ix+127)         ;; 02BF:  DD B6 7F
 cp a, (ix+-128)        ;; 02C2:  DD BE 80
 cp a, (ix+0)           ;; 02C5:  DD BE 00
 cp a, (ix+127)         ;; 02C8:  DD BE 7F
 add (ix+-128)          ;; 02CB:  DD 86 80
 add (ix+0)             ;; 02CE:  DD 86 00
 add (ix+127)           ;; 02D1:  DD 86 7F
 adc (ix+-128)          ;; 02D4:  DD 8E 80
 adc (ix+0)             ;; 02D7:  DD 8E 00
 adc (ix+127)           ;; 02DA:  DD 8E 7F
 sub (ix+-128)          ;; 02DD:  DD 96 80
 sub (ix+0)             ;; 02E0:  DD 96 00
 sub (ix+127)           ;; 02E3:  DD 96 7F
 sbc (ix+-128)          ;; 02E6:  DD 9E 80
 sbc (ix+0)             ;; 02E9:  DD 9E 00
 sbc (ix+127)           ;; 02EC:  DD 9E 7F
 and (ix+-128)          ;; 02EF:  DD A6 80
 and (ix+0)             ;; 02F2:  DD A6 00
 and (ix+127)           ;; 02F5:  DD A6 7F
 xor (ix+-128)          ;; 02F8:  DD AE 80
 xor (ix+0)             ;; 02FB:  DD AE 00
 xor (ix+127)           ;; 02FE:  DD AE 7F
 or (ix+-128)           ;; 0301:  DD B6 80
 or (ix+0)              ;; 0304:  DD B6 00
 or (ix+127)            ;; 0307:  DD B6 7F
 cp (ix+-128)           ;; 030A:  DD BE 80
 cp (ix+0)              ;; 030D:  DD BE 00
 cp (ix+127)            ;; 0310:  DD BE 7F
 add a, (iy+-128)       ;; 0313:  FD 86 80
 add a, (iy+0)          ;; 0316:  FD 86 00
 add a, (iy+127)        ;; 0319:  FD 86 7F
 adc a, (iy+-128)       ;; 031C:  FD 8E 80
 adc a, (iy+0)          ;; 031F:  FD 8E 00
 adc a, (iy+127)        ;; 0322:  FD 8E 7F
 sub a, (iy+-128)       ;; 0325:  FD 96 80
 sub a, (iy+0)          ;; 0328:  FD 96 00
 sub a, (iy+127)        ;; 032B:  FD 96 7F
 sbc a, (iy+-128)       ;; 032E:  FD 9E 80
 sbc a, (iy+0)          ;; 0331:  FD 9E 00
 sbc a, (iy+127)        ;; 0334:  FD 9E 7F
 and a, (iy+-128)       ;; 0337:  FD A6 80
 and a, (iy+0)          ;; 033A:  FD A6 00
 and a, (iy+127)        ;; 033D:  FD A6 7F
 xor a, (iy+-128)       ;; 0340:  FD AE 80
 xor a, (iy+0)          ;; 0343:  FD AE 00
 xor a, (iy+127)        ;; 0346:  FD AE 7F
 or a, (iy+-128)        ;; 0349:  FD B6 80
 or a, (iy+0)           ;; 034C:  FD B6 00
 or a, (iy+127)         ;; 034F:  FD B6 7F
 cp a, (iy+-128)        ;; 0352:  FD BE 80
 cp a, (iy+0)           ;; 0355:  FD BE 00
 cp a, (iy+127)         ;; 0358:  FD BE 7F
 add (iy+-128)          ;; 035B:  FD 86 80
 add (iy+0)             ;; 035E:  FD 86 00
 add (iy+127)           ;; 0361:  FD 86 7F
 adc (iy+-128)          ;; 0364:  FD 8E 80
 adc (iy+0)             ;; 0367:  FD 8E 00
 adc (iy+127)           ;; 036A:  FD 8E 7F
 sub (iy+-128)          ;; 036D:  FD 96 80
 sub (iy+0)             ;; 0370:  FD 96 00
 sub (iy+127)           ;; 0373:  FD 96 7F
 sbc (iy+-128)          ;; 0376:  FD 9E 80
 sbc (iy+0)             ;; 0379:  FD 9E 00
 sbc (iy+127)           ;; 037C:  FD 9E 7F
 and (iy+-128)          ;; 037F:  FD A6 80
 and (iy+0)             ;; 0382:  FD A6 00
 and (iy+127)           ;; 0385:  FD A6 7F
 xor (iy+-128)          ;; 0388:  FD AE 80
 xor (iy+0)             ;; 038B:  FD AE 00
 xor (iy+127)           ;; 038E:  FD AE 7F
 or (iy+-128)           ;; 0391:  FD B6 80
 or (iy+0)              ;; 0394:  FD B6 00
 or (iy+127)            ;; 0397:  FD B6 7F
 cp (iy+-128)           ;; 039A:  FD BE 80
 cp (iy+0)              ;; 039D:  FD BE 00
 cp (iy+127)            ;; 03A0:  FD BE 7F
 add a, 0               ;; 03A3:  C6 00
 add a, 85              ;; 03A5:  C6 55
 add a, 170             ;; 03A7:  C6 AA
 add a, 255             ;; 03A9:  C6 FF
 adc a, 0               ;; 03AB:  CE 00
 adc a, 85              ;; 03AD:  CE 55
 adc a, 170             ;; 03AF:  CE AA
 adc a, 255             ;; 03B1:  CE FF
 sub a, 0               ;; 03B3:  D6 00
 sub a, 85              ;; 03B5:  D6 55
 sub a, 170             ;; 03B7:  D6 AA
 sub a, 255             ;; 03B9:  D6 FF
 sbc a, 0               ;; 03BB:  DE 00
 sbc a, 85              ;; 03BD:  DE 55
 sbc a, 170             ;; 03BF:  DE AA
 sbc a, 255             ;; 03C1:  DE FF
 and a, 0               ;; 03C3:  E6 00
 and a, 85              ;; 03C5:  E6 55
 and a, 170             ;; 03C7:  E6 AA
 and a, 255             ;; 03C9:  E6 FF
 xor a, 0               ;; 03CB:  EE 00
 xor a, 85              ;; 03CD:  EE 55
 xor a, 170             ;; 03CF:  EE AA
 xor a, 255             ;; 03D1:  EE FF
 or a, 0                ;; 03D3:  F6 00
 or a, 85               ;; 03D5:  F6 55
 or a, 170              ;; 03D7:  F6 AA
 or a, 255              ;; 03D9:  F6 FF
 cp a, 0                ;; 03DB:  FE 00
 cp a, 85               ;; 03DD:  FE 55
 cp a, 170              ;; 03DF:  FE AA
 cp a, 255              ;; 03E1:  FE FF
 add 0                  ;; 03E3:  C6 00
 add 85                 ;; 03E5:  C6 55
 add 170                ;; 03E7:  C6 AA
 add 255                ;; 03E9:  C6 FF
 adc 0                  ;; 03EB:  CE 00
 adc 85                 ;; 03ED:  CE 55
 adc 170                ;; 03EF:  CE AA
 adc 255                ;; 03F1:  CE FF
 sub 0                  ;; 03F3:  D6 00
 sub 85                 ;; 03F5:  D6 55
 sub 170                ;; 03F7:  D6 AA
 sub 255                ;; 03F9:  D6 FF
 sbc 0                  ;; 03FB:  DE 00
 sbc 85                 ;; 03FD:  DE 55
 sbc 170                ;; 03FF:  DE AA
 sbc 255                ;; 0401:  DE FF
 and 0                  ;; 0403:  E6 00
 and 85                 ;; 0405:  E6 55
 and 170                ;; 0407:  E6 AA
 and 255                ;; 0409:  E6 FF
 xor 0                  ;; 040B:  EE 00
 xor 85                 ;; 040D:  EE 55
 xor 170                ;; 040F:  EE AA
 xor 255                ;; 0411:  EE FF
 or 0                   ;; 0413:  F6 00
 or 85                  ;; 0415:  F6 55
 or 170                 ;; 0417:  F6 AA
 or 255                 ;; 0419:  F6 FF
 cp 0                   ;; 041B:  FE 00
 cp 85                  ;; 041D:  FE 55
 cp 170                 ;; 041F:  FE AA
 cp 255                 ;; 0421:  FE FF
 inc b                  ;; 0423:  04
 inc c                  ;; 0424:  0C
 inc d                  ;; 0425:  14
 inc e                  ;; 0426:  1C
 inc h                  ;; 0427:  24
 inc l                  ;; 0428:  2C
 inc a                  ;; 0429:  3C
 dec b                  ;; 042A:  05
 dec c                  ;; 042B:  0D
 dec d                  ;; 042C:  15
 dec e                  ;; 042D:  1D
 dec h                  ;; 042E:  25
 dec l                  ;; 042F:  2D
 dec a                  ;; 0430:  3D
 inc (hl)               ;; 0431:  34
 dec (hl)               ;; 0432:  35
 inc (ix + -128)        ;; 0433:  DD 34 80
 inc (ix + 0)           ;; 0436:  DD 34 00
 inc (ix + 127)         ;; 0439:  DD 34 7F
 dec (ix + -128)        ;; 043C:  DD 35 80
 dec (ix + 0)           ;; 043F:  DD 35 00
 dec (ix + 127)         ;; 0442:  DD 35 7F
 inc (iy + -128)        ;; 0445:  FD 34 80
 inc (iy + 0)           ;; 0448:  FD 34 00
 inc (iy + 127)         ;; 044B:  FD 34 7F
 dec (iy + -128)        ;; 044E:  FD 35 80
 dec (iy + 0)           ;; 0451:  FD 35 00
 dec (iy + 127)         ;; 0454:  FD 35 7F
 tst a, b               ;; 0457:  ED 04
 tst a, c               ;; 0459:  ED 0C
 tst a, d               ;; 045B:  ED 14
 tst a, e               ;; 045D:  ED 1C
 tst a, h               ;; 045F:  ED 24
 tst a, l               ;; 0461:  ED 2C
 tst a, a               ;; 0463:  ED 3C
 tst b                  ;; 0465:  ED 04
 tst c                  ;; 0467:  ED 0C
 tst d                  ;; 0469:  ED 14
 tst e                  ;; 046B:  ED 1C
 tst h                  ;; 046D:  ED 24
 tst l                  ;; 046F:  ED 2C
 tst a                  ;; 0471:  ED 3C
 tst a, 0               ;; 0473:  ED 64 00
 tst a, 85              ;; 0476:  ED 64 55
 tst a, 170             ;; 0479:  ED 64 AA
 tst a, 255             ;; 047C:  ED 64 FF
 tst 0                  ;; 047F:  ED 64 00
 tst 85                 ;; 0482:  ED 64 55
 tst 170                ;; 0485:  ED 64 AA
 tst 255                ;; 0488:  ED 64 FF
 tst a, (hl)            ;; 048B:  ED 34
 tst (hl)               ;; 048D:  ED 34
 cpl                    ;; 048F:  2F
 neg                    ;; 0490:  ED 44
 ccf                    ;; 0492:  3F
 scf                    ;; 0493:  37
 ld bc, 0               ;; 0494:  01 00 00
 ld bc, 291             ;; 0497:  01 23 01
 ld bc, 17767           ;; 049A:  01 67 45
 ld bc, 35243           ;; 049D:  01 AB 89
 ld bc, 52719           ;; 04A0:  01 EF CD
 ld bc, 65535           ;; 04A3:  01 FF FF
 ld de, 0               ;; 04A6:  11 00 00
 ld de, 291             ;; 04A9:  11 23 01
 ld de, 17767           ;; 04AC:  11 67 45
 ld de, 35243           ;; 04AF:  11 AB 89
 ld de, 52719           ;; 04B2:  11 EF CD
 ld de, 65535           ;; 04B5:  11 FF FF
 ld hl, 0               ;; 04B8:  21 00 00
 ld hl, 291             ;; 04BB:  21 23 01
 ld hl, 17767           ;; 04BE:  21 67 45
 ld hl, 35243           ;; 04C1:  21 AB 89
 ld hl, 52719           ;; 04C4:  21 EF CD
 ld hl, 65535           ;; 04C7:  21 FF FF
 ld sp, 0               ;; 04CA:  31 00 00
 ld sp, 291             ;; 04CD:  31 23 01
 ld sp, 17767           ;; 04D0:  31 67 45
 ld sp, 35243           ;; 04D3:  31 AB 89
 ld sp, 52719           ;; 04D6:  31 EF CD
 ld sp, 65535           ;; 04D9:  31 FF FF
 ld ix, 0               ;; 04DC:  DD 21 00 00
 ld ix, 291             ;; 04E0:  DD 21 23 01
 ld ix, 17767           ;; 04E4:  DD 21 67 45
 ld ix, 35243           ;; 04E8:  DD 21 AB 89
 ld ix, 52719           ;; 04EC:  DD 21 EF CD
 ld ix, 65535           ;; 04F0:  DD 21 FF FF
 ld iy, 0               ;; 04F4:  FD 21 00 00
 ld iy, 291             ;; 04F8:  FD 21 23 01
 ld iy, 17767           ;; 04FC:  FD 21 67 45
 ld iy, 35243           ;; 0500:  FD 21 AB 89
 ld iy, 52719           ;; 0504:  FD 21 EF CD
 ld iy, 65535           ;; 0508:  FD 21 FF FF
 ld hl, (0)             ;; 050C:  2A 00 00
 ld hl, (291)           ;; 050F:  2A 23 01
 ld hl, (17767)         ;; 0512:  2A 67 45
 ld hl, (35243)         ;; 0515:  2A AB 89
 ld hl, (52719)         ;; 0518:  2A EF CD
 ld hl, (65535)         ;; 051B:  2A FF FF
 ld ix, (0)             ;; 051E:  DD 2A 00 00
 ld ix, (291)           ;; 0522:  DD 2A 23 01
 ld ix, (17767)         ;; 0526:  DD 2A 67 45
 ld ix, (35243)         ;; 052A:  DD 2A AB 89
 ld ix, (52719)         ;; 052E:  DD 2A EF CD
 ld ix, (65535)         ;; 0532:  DD 2A FF FF
 ld iy, (0)             ;; 0536:  FD 2A 00 00
 ld iy, (291)           ;; 053A:  FD 2A 23 01
 ld iy, (17767)         ;; 053E:  FD 2A 67 45
 ld iy, (35243)         ;; 0542:  FD 2A AB 89
 ld iy, (52719)         ;; 0546:  FD 2A EF CD
 ld iy, (65535)         ;; 054A:  FD 2A FF FF
 ld (0), hl             ;; 054E:  22 00 00
 ld (291), hl           ;; 0551:  22 23 01
 ld (17767), hl         ;; 0554:  22 67 45
 ld (35243), hl         ;; 0557:  22 AB 89
 ld (52719), hl         ;; 055A:  22 EF CD
 ld (65535), hl         ;; 055D:  22 FF FF
 ld (0), ix             ;; 0560:  DD 22 00 00
 ld (291), ix           ;; 0564:  DD 22 23 01
 ld (17767), ix         ;; 0568:  DD 22 67 45
 ld (35243), ix         ;; 056C:  DD 22 AB 89
 ld (52719), ix         ;; 0570:  DD 22 EF CD
 ld (65535), ix         ;; 0574:  DD 22 FF FF
 ld (0), iy             ;; 0578:  FD 22 00 00
 ld (291), iy           ;; 057C:  FD 22 23 01
 ld (17767), iy         ;; 0580:  FD 22 67 45
 ld (35243), iy         ;; 0584:  FD 22 AB 89
 ld (52719), iy         ;; 0588:  FD 22 EF CD
 ld (65535), iy         ;; 058C:  FD 22 FF FF
 LD bc, (0)             ;; 0590:  ED 4B 00 00
 LD bc, (291)           ;; 0594:  ED 4B 23 01
 LD bc, (17767)         ;; 0598:  ED 4B 67 45
 LD bc, (35243)         ;; 059C:  ED 4B AB 89
 LD bc, (52719)         ;; 05A0:  ED 4B EF CD
 LD bc, (65535)         ;; 05A4:  ED 4B FF FF
 LD de, (0)             ;; 05A8:  ED 5B 00 00
 LD de, (291)           ;; 05AC:  ED 5B 23 01
 LD de, (17767)         ;; 05B0:  ED 5B 67 45
 LD de, (35243)         ;; 05B4:  ED 5B AB 89
 LD de, (52719)         ;; 05B8:  ED 5B EF CD
 LD de, (65535)         ;; 05BC:  ED 5B FF FF
 LD sp, (0)             ;; 05C0:  ED 7B 00 00
 LD sp, (291)           ;; 05C4:  ED 7B 23 01
 LD sp, (17767)         ;; 05C8:  ED 7B 67 45
 LD sp, (35243)         ;; 05CC:  ED 7B AB 89
 LD sp, (52719)         ;; 05D0:  ED 7B EF CD
 LD sp, (65535)         ;; 05D4:  ED 7B FF FF
 LD (0), bc             ;; 05D8:  ED 43 00 00
 LD (291), bc           ;; 05DC:  ED 43 23 01
 LD (17767), bc         ;; 05E0:  ED 43 67 45
 LD (35243), bc         ;; 05E4:  ED 43 AB 89
 LD (52719), bc         ;; 05E8:  ED 43 EF CD
 LD (65535), bc         ;; 05EC:  ED 43 FF FF
 LD (0), de             ;; 05F0:  ED 53 00 00
 LD (291), de           ;; 05F4:  ED 53 23 01
 LD (17767), de         ;; 05F8:  ED 53 67 45
 LD (35243), de         ;; 05FC:  ED 53 AB 89
 LD (52719), de         ;; 0600:  ED 53 EF CD
 LD (65535), de         ;; 0604:  ED 53 FF FF
 LD (0), sp             ;; 0608:  ED 73 00 00
 LD (291), sp           ;; 060C:  ED 73 23 01
 LD (17767), sp         ;; 0610:  ED 73 67 45
 LD (35243), sp         ;; 0614:  ED 73 AB 89
 LD (52719), sp         ;; 0618:  ED 73 EF CD
 LD (65535), sp         ;; 061C:  ED 73 FF FF
 ld sp, hl              ;; 0620:  F9
 ld sp, ix              ;; 0621:  DD F9
 ld sp, iy              ;; 0623:  FD F9
 push bc                ;; 0625:  C5
 push de                ;; 0626:  D5
 push hl                ;; 0627:  E5
 push af                ;; 0628:  F5
 push ix                ;; 0629:  DD E5
 push iy                ;; 062B:  FD E5
 pop bc                 ;; 062D:  C1
 pop de                 ;; 062E:  D1
 pop hl                 ;; 062F:  E1
 pop af                 ;; 0630:  F1
 pop ix                 ;; 0631:  DD E1
 pop iy                 ;; 0633:  FD E1
 ld (hl + -128), hl     ;; 0635:  DD F4 80
 ld (hl + 0), hl        ;; 0638:  DD F4 00
 ld (hl + 127), hl      ;; 063B:  DD F4 7F
 ld (ix + -128), hl     ;; 063E:  F4 80
 ld (ix + 0), hl        ;; 0640:  F4 00
 ld (ix + 127), hl      ;; 0642:  F4 7F
 ld (iy + -128), hl     ;; 0644:  FD F4 80
 ld (iy + 0), hl        ;; 0647:  FD F4 00
 ld (iy + 127), hl      ;; 064A:  FD F4 7F
 ld (sp + 0), hl        ;; 064D:  D4 00
 ld (sp + 85), hl       ;; 064F:  D4 55
 ld (sp + 170), hl      ;; 0651:  D4 AA
 ld (sp + 255), hl      ;; 0653:  D4 FF
 ld (sp + 0), ix        ;; 0655:  DD D4 00
 ld (sp + 85), ix       ;; 0658:  DD D4 55
 ld (sp + 170), ix      ;; 065B:  DD D4 AA
 ld (sp + 255), ix      ;; 065E:  DD D4 FF
 ld (sp + 0), iy        ;; 0661:  FD D4 00
 ld (sp + 85), iy       ;; 0664:  FD D4 55
 ld (sp + 170), iy      ;; 0667:  FD D4 AA
 ld (sp + 255), iy      ;; 066A:  FD D4 FF
 ld bc', bc             ;; 066D:  ED 49
 ld bc', de             ;; 066F:  ED 41
 ld de', bc             ;; 0671:  ED 59
 ld de', de             ;; 0673:  ED 51
 ld hl', bc             ;; 0675:  ED 69
 ld hl', de             ;; 0677:  ED 61
 add hl, bc             ;; 0679:  09
 add hl, de             ;; 067A:  19
 add hl, hl             ;; 067B:  29
 add hl, sp             ;; 067C:  39
 add ix, bc             ;; 067D:  DD 09
 add ix, de             ;; 067F:  DD 19
 add ix, ix             ;; 0681:  DD 29
 add ix, sp             ;; 0683:  DD 39
 add iy, bc             ;; 0685:  FD 09
 add iy, de             ;; 0687:  FD 19
 add iy, iy             ;; 0689:  FD 29
 add iy, sp             ;; 068B:  FD 39
 sbc hl, bc             ;; 068D:  ED 42
 sbc hl, de             ;; 068F:  ED 52
 sbc hl, hl             ;; 0691:  ED 62
 sbc hl, sp             ;; 0693:  ED 72
 adc hl, bc             ;; 0695:  ED 4A
 adc hl, de             ;; 0697:  ED 5A
 adc hl, hl             ;; 0699:  ED 6A
 adc hl, sp             ;; 069B:  ED 7A
 inc bc                 ;; 069D:  03
 inc de                 ;; 069E:  13
 inc hl                 ;; 069F:  23
 inc sp                 ;; 06A0:  33
 dec bc                 ;; 06A1:  0B
 dec de                 ;; 06A2:  1B
 dec hl                 ;; 06A3:  2B
 dec sp                 ;; 06A4:  3B
 inc ix                 ;; 06A5:  DD 23
 dec ix                 ;; 06A7:  DD 2B
 inc iy                 ;; 06A9:  FD 23
 dec iy                 ;; 06AB:  FD 2B
 add sp, -128           ;; 06AD:  27 80
 add sp, 0              ;; 06AF:  27 00
 add sp, 127            ;; 06B1:  27 7F
 and hl, de             ;; 06B3:  DC
 and ix, de             ;; 06B4:  DD DC
 and iy, de             ;; 06B6:  FD DC
 bool hl                ;; 06B8:  CC
 bool ix                ;; 06B9:  DD CC
 bool iy                ;; 06BB:  FD CC
 mlt bc                 ;; 06BD:  ED 4C
 mlt de                 ;; 06BF:  ED 5C
 mlt hl                 ;; 06C1:  ED 6C
 ex af, af              ;; 06C3:  08
 ex af, af'             ;; 06C4:  08
 exx                    ;; 06C5:  D9
 ex (sp), hl            ;; 06C6:  ED 54
 ex (sp), ix            ;; 06C8:  DD E3
 ex (sp), iy            ;; 06CA:  FD E3
 ex de, hl              ;; 06CC:  EB
 ex de', hl             ;; 06CD:  E3
 ex de, hl'             ;; 06CE:  76 EB
 ex de', hl'            ;; 06D0:  76 E3
 rlca                   ;; 06D2:  07
 rrca                   ;; 06D3:  0F
 rla                    ;; 06D4:  17
 rra                    ;; 06D5:  1F
 rlc b                  ;; 06D6:  CB 00
 rlc c                  ;; 06D8:  CB 01
 rlc d                  ;; 06DA:  CB 02
 rlc e                  ;; 06DC:  CB 03
 rlc h                  ;; 06DE:  CB 04
 rlc l                  ;; 06E0:  CB 05
 rlc (hl)               ;; 06E2:  CB 06
 rlc a                  ;; 06E4:  CB 07
 rrc b                  ;; 06E6:  CB 08
 rrc c                  ;; 06E8:  CB 09
 rrc d                  ;; 06EA:  CB 0A
 rrc e                  ;; 06EC:  CB 0B
 rrc h                  ;; 06EE:  CB 0C
 rrc l                  ;; 06F0:  CB 0D
 rrc (hl)               ;; 06F2:  CB 0E
 rrc a                  ;; 06F4:  CB 0F
 rl b                   ;; 06F6:  CB 10
 rl c                   ;; 06F8:  CB 11
 rl d                   ;; 06FA:  CB 12
 rl e                   ;; 06FC:  CB 13
 rl h                   ;; 06FE:  CB 14
 rl l                   ;; 0700:  CB 15
 rl (hl)                ;; 0702:  CB 16
 rl a                   ;; 0704:  CB 17
 rr b                   ;; 0706:  CB 18
 rr c                   ;; 0708:  CB 19
 rr d                   ;; 070A:  CB 1A
 rr e                   ;; 070C:  CB 1B
 rr h                   ;; 070E:  CB 1C
 rr l                   ;; 0710:  CB 1D
 rr (hl)                ;; 0712:  CB 1E
 rr a                   ;; 0714:  CB 1F
 sla b                  ;; 0716:  CB 20
 sla c                  ;; 0718:  CB 21
 sla d                  ;; 071A:  CB 22
 sla e                  ;; 071C:  CB 23
 sla h                  ;; 071E:  CB 24
 sla l                  ;; 0720:  CB 25
 sla (hl)               ;; 0722:  CB 26
 sla a                  ;; 0724:  CB 27
 sra b                  ;; 0726:  CB 28
 sra c                  ;; 0728:  CB 29
 sra d                  ;; 072A:  CB 2A
 sra e                  ;; 072C:  CB 2B
 sra h                  ;; 072E:  CB 2C
 sra l                  ;; 0730:  CB 2D
 sra (hl)               ;; 0732:  CB 2E
 sra a                  ;; 0734:  CB 2F
 srl b                  ;; 0736:  CB 38
 srl c                  ;; 0738:  CB 39
 srl d                  ;; 073A:  CB 3A
 srl e                  ;; 073C:  CB 3B
 srl h                  ;; 073E:  CB 3C
 srl l                  ;; 0740:  CB 3D
 srl (hl)               ;; 0742:  CB 3E
 srl a                  ;; 0744:  CB 3F
 rlc (ix+-128)          ;; 0746:  DD CB 80 06
 rlc (ix+0)             ;; 074A:  DD CB 00 06
 rlc (ix+127)           ;; 074E:  DD CB 7F 06
 rrc (ix+-128)          ;; 0752:  DD CB 80 0E
 rrc (ix+0)             ;; 0756:  DD CB 00 0E
 rrc (ix+127)           ;; 075A:  DD CB 7F 0E
 rl (ix+-128)           ;; 075E:  DD CB 80 16
 rl (ix+0)              ;; 0762:  DD CB 00 16
 rl (ix+127)            ;; 0766:  DD CB 7F 16
 rr (ix+-128)           ;; 076A:  DD CB 80 1E
 rr (ix+0)              ;; 076E:  DD CB 00 1E
 rr (ix+127)            ;; 0772:  DD CB 7F 1E
 sla (ix+-128)          ;; 0776:  DD CB 80 26
 sla (ix+0)             ;; 077A:  DD CB 00 26
 sla (ix+127)           ;; 077E:  DD CB 7F 26
 sra (ix+-128)          ;; 0782:  DD CB 80 2E
 sra (ix+0)             ;; 0786:  DD CB 00 2E
 sra (ix+127)           ;; 078A:  DD CB 7F 2E
 srl (ix+-128)          ;; 078E:  DD CB 80 3E
 srl (ix+0)             ;; 0792:  DD CB 00 3E
 srl (ix+127)           ;; 0796:  DD CB 7F 3E
 rlc (iy+-128)          ;; 079A:  FD CB 80 06
 rlc (iy+0)             ;; 079E:  FD CB 00 06
 rlc (iy+127)           ;; 07A2:  FD CB 7F 06
 rrc (iy+-128)          ;; 07A6:  FD CB 80 0E
 rrc (iy+0)             ;; 07AA:  FD CB 00 0E
 rrc (iy+127)           ;; 07AE:  FD CB 7F 0E
 rl (iy+-128)           ;; 07B2:  FD CB 80 16
 rl (iy+0)              ;; 07B6:  FD CB 00 16
 rl (iy+127)            ;; 07BA:  FD CB 7F 16
 rr (iy+-128)           ;; 07BE:  FD CB 80 1E
 rr (iy+0)              ;; 07C2:  FD CB 00 1E
 rr (iy+127)            ;; 07C6:  FD CB 7F 1E
 sla (iy+-128)          ;; 07CA:  FD CB 80 26
 sla (iy+0)             ;; 07CE:  FD CB 00 26
 sla (iy+127)           ;; 07D2:  FD CB 7F 26
 sra (iy+-128)          ;; 07D6:  FD CB 80 2E
 sra (iy+0)             ;; 07DA:  FD CB 00 2E
 sra (iy+127)           ;; 07DE:  FD CB 7F 2E
 srl (iy+-128)          ;; 07E2:  FD CB 80 3E
 srl (iy+0)             ;; 07E6:  FD CB 00 3E
 srl (iy+127)           ;; 07EA:  FD CB 7F 3E
 bit 0, b               ;; 07EE:  CB 40
 bit 0, c               ;; 07F0:  CB 41
 bit 0, d               ;; 07F2:  CB 42
 bit 0, e               ;; 07F4:  CB 43
 bit 0, h               ;; 07F6:  CB 44
 bit 0, l               ;; 07F8:  CB 45
 bit 0, (hl)            ;; 07FA:  CB 46
 bit 0, a               ;; 07FC:  CB 47
 bit 1, b               ;; 07FE:  CB 48
 bit 1, c               ;; 0800:  CB 49
 bit 1, d               ;; 0802:  CB 4A
 bit 1, e               ;; 0804:  CB 4B
 bit 1, h               ;; 0806:  CB 4C
 bit 1, l               ;; 0808:  CB 4D
 bit 1, (hl)            ;; 080A:  CB 4E
 bit 1, a               ;; 080C:  CB 4F
 bit 2, b               ;; 080E:  CB 50
 bit 2, c               ;; 0810:  CB 51
 bit 2, d               ;; 0812:  CB 52
 bit 2, e               ;; 0814:  CB 53
 bit 2, h               ;; 0816:  CB 54
 bit 2, l               ;; 0818:  CB 55
 bit 2, (hl)            ;; 081A:  CB 56
 bit 2, a               ;; 081C:  CB 57
 bit 3, b               ;; 081E:  CB 58
 bit 3, c               ;; 0820:  CB 59
 bit 3, d               ;; 0822:  CB 5A
 bit 3, e               ;; 0824:  CB 5B
 bit 3, h               ;; 0826:  CB 5C
 bit 3, l               ;; 0828:  CB 5D
 bit 3, (hl)            ;; 082A:  CB 5E
 bit 3, a               ;; 082C:  CB 5F
 bit 4, b               ;; 082E:  CB 60
 bit 4, c               ;; 0830:  CB 61
 bit 4, d               ;; 0832:  CB 62
 bit 4, e               ;; 0834:  CB 63
 bit 4, h               ;; 0836:  CB 64
 bit 4, l               ;; 0838:  CB 65
 bit 4, (hl)            ;; 083A:  CB 66
 bit 4, a               ;; 083C:  CB 67
 bit 5, b               ;; 083E:  CB 68
 bit 5, c               ;; 0840:  CB 69
 bit 5, d               ;; 0842:  CB 6A
 bit 5, e               ;; 0844:  CB 6B
 bit 5, h               ;; 0846:  CB 6C
 bit 5, l               ;; 0848:  CB 6D
 bit 5, (hl)            ;; 084A:  CB 6E
 bit 5, a               ;; 084C:  CB 6F
 bit 6, b               ;; 084E:  CB 70
 bit 6, c               ;; 0850:  CB 71
 bit 6, d               ;; 0852:  CB 72
 bit 6, e               ;; 0854:  CB 73
 bit 6, h               ;; 0856:  CB 74
 bit 6, l               ;; 0858:  CB 75
 bit 6, (hl)            ;; 085A:  CB 76
 bit 6, a               ;; 085C:  CB 77
 bit 7, b               ;; 085E:  CB 78
 bit 7, c               ;; 0860:  CB 79
 bit 7, d               ;; 0862:  CB 7A
 bit 7, e               ;; 0864:  CB 7B
 bit 7, h               ;; 0866:  CB 7C
 bit 7, l               ;; 0868:  CB 7D
 bit 7, (hl)            ;; 086A:  CB 7E
 bit 7, a               ;; 086C:  CB 7F
 res 0, b               ;; 086E:  CB 80
 res 0, c               ;; 0870:  CB 81
 res 0, d               ;; 0872:  CB 82
 res 0, e               ;; 0874:  CB 83
 res 0, h               ;; 0876:  CB 84
 res 0, l               ;; 0878:  CB 85
 res 0, (hl)            ;; 087A:  CB 86
 res 0, a               ;; 087C:  CB 87
 res 1, b               ;; 087E:  CB 88
 res 1, c               ;; 0880:  CB 89
 res 1, d               ;; 0882:  CB 8A
 res 1, e               ;; 0884:  CB 8B
 res 1, h               ;; 0886:  CB 8C
 res 1, l               ;; 0888:  CB 8D
 res 1, (hl)            ;; 088A:  CB 8E
 res 1, a               ;; 088C:  CB 8F
 res 2, b               ;; 088E:  CB 90
 res 2, c               ;; 0890:  CB 91
 res 2, d               ;; 0892:  CB 92
 res 2, e               ;; 0894:  CB 93
 res 2, h               ;; 0896:  CB 94
 res 2, l               ;; 0898:  CB 95
 res 2, (hl)            ;; 089A:  CB 96
 res 2, a               ;; 089C:  CB 97
 res 3, b               ;; 089E:  CB 98
 res 3, c               ;; 08A0:  CB 99
 res 3, d               ;; 08A2:  CB 9A
 res 3, e               ;; 08A4:  CB 9B
 res 3, h               ;; 08A6:  CB 9C
 res 3, l               ;; 08A8:  CB 9D
 res 3, (hl)            ;; 08AA:  CB 9E
 res 3, a               ;; 08AC:  CB 9F
 res 4, b               ;; 08AE:  CB A0
 res 4, c               ;; 08B0:  CB A1
 res 4, d               ;; 08B2:  CB A2
 res 4, e               ;; 08B4:  CB A3
 res 4, h               ;; 08B6:  CB A4
 res 4, l               ;; 08B8:  CB A5
 res 4, (hl)            ;; 08BA:  CB A6
 res 4, a               ;; 08BC:  CB A7
 res 5, b               ;; 08BE:  CB A8
 res 5, c               ;; 08C0:  CB A9
 res 5, d               ;; 08C2:  CB AA
 res 5, e               ;; 08C4:  CB AB
 res 5, h               ;; 08C6:  CB AC
 res 5, l               ;; 08C8:  CB AD
 res 5, (hl)            ;; 08CA:  CB AE
 res 5, a               ;; 08CC:  CB AF
 res 6, b               ;; 08CE:  CB B0
 res 6, c               ;; 08D0:  CB B1
 res 6, d               ;; 08D2:  CB B2
 res 6, e               ;; 08D4:  CB B3
 res 6, h               ;; 08D6:  CB B4
 res 6, l               ;; 08D8:  CB B5
 res 6, (hl)            ;; 08DA:  CB B6
 res 6, a               ;; 08DC:  CB B7
 res 7, b               ;; 08DE:  CB B8
 res 7, c               ;; 08E0:  CB B9
 res 7, d               ;; 08E2:  CB BA
 res 7, e               ;; 08E4:  CB BB
 res 7, h               ;; 08E6:  CB BC
 res 7, l               ;; 08E8:  CB BD
 res 7, (hl)            ;; 08EA:  CB BE
 res 7, a               ;; 08EC:  CB BF
 set 0, b               ;; 08EE:  CB C0
 set 0, c               ;; 08F0:  CB C1
 set 0, d               ;; 08F2:  CB C2
 set 0, e               ;; 08F4:  CB C3
 set 0, h               ;; 08F6:  CB C4
 set 0, l               ;; 08F8:  CB C5
 set 0, (hl)            ;; 08FA:  CB C6
 set 0, a               ;; 08FC:  CB C7
 set 1, b               ;; 08FE:  CB C8
 set 1, c               ;; 0900:  CB C9
 set 1, d               ;; 0902:  CB CA
 set 1, e               ;; 0904:  CB CB
 set 1, h               ;; 0906:  CB CC
 set 1, l               ;; 0908:  CB CD
 set 1, (hl)            ;; 090A:  CB CE
 set 1, a               ;; 090C:  CB CF
 set 2, b               ;; 090E:  CB D0
 set 2, c               ;; 0910:  CB D1
 set 2, d               ;; 0912:  CB D2
 set 2, e               ;; 0914:  CB D3
 set 2, h               ;; 0916:  CB D4
 set 2, l               ;; 0918:  CB D5
 set 2, (hl)            ;; 091A:  CB D6
 set 2, a               ;; 091C:  CB D7
 set 3, b               ;; 091E:  CB D8
 set 3, c               ;; 0920:  CB D9
 set 3, d               ;; 0922:  CB DA
 set 3, e               ;; 0924:  CB DB
 set 3, h               ;; 0926:  CB DC
 set 3, l               ;; 0928:  CB DD
 set 3, (hl)            ;; 092A:  CB DE
 set 3, a               ;; 092C:  CB DF
 set 4, b               ;; 092E:  CB E0
 set 4, c               ;; 0930:  CB E1
 set 4, d               ;; 0932:  CB E2
 set 4, e               ;; 0934:  CB E3
 set 4, h               ;; 0936:  CB E4
 set 4, l               ;; 0938:  CB E5
 set 4, (hl)            ;; 093A:  CB E6
 set 4, a               ;; 093C:  CB E7
 set 5, b               ;; 093E:  CB E8
 set 5, c               ;; 0940:  CB E9
 set 5, d               ;; 0942:  CB EA
 set 5, e               ;; 0944:  CB EB
 set 5, h               ;; 0946:  CB EC
 set 5, l               ;; 0948:  CB ED
 set 5, (hl)            ;; 094A:  CB EE
 set 5, a               ;; 094C:  CB EF
 set 6, b               ;; 094E:  CB F0
 set 6, c               ;; 0950:  CB F1
 set 6, d               ;; 0952:  CB F2
 set 6, e               ;; 0954:  CB F3
 set 6, h               ;; 0956:  CB F4
 set 6, l               ;; 0958:  CB F5
 set 6, (hl)            ;; 095A:  CB F6
 set 6, a               ;; 095C:  CB F7
 set 7, b               ;; 095E:  CB F8
 set 7, c               ;; 0960:  CB F9
 set 7, d               ;; 0962:  CB FA
 set 7, e               ;; 0964:  CB FB
 set 7, h               ;; 0966:  CB FC
 set 7, l               ;; 0968:  CB FD
 set 7, (hl)            ;; 096A:  CB FE
 set 7, a               ;; 096C:  CB FF
 bit 0, (ix+-128)       ;; 096E:  DD CB 80 46
 bit 0, (ix+0)          ;; 0972:  DD CB 00 46
 bit 0, (ix+127)        ;; 0976:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 097A:  DD CB 80 4E
 bit 1, (ix+0)          ;; 097E:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0982:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0986:  DD CB 80 56
 bit 2, (ix+0)          ;; 098A:  DD CB 00 56
 bit 2, (ix+127)        ;; 098E:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0992:  DD CB 80 5E
 bit 3, (ix+0)          ;; 0996:  DD CB 00 5E
 bit 3, (ix+127)        ;; 099A:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 099E:  DD CB 80 66
 bit 4, (ix+0)          ;; 09A2:  DD CB 00 66
 bit 4, (ix+127)        ;; 09A6:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 09AA:  DD CB 80 6E
 bit 5, (ix+0)          ;; 09AE:  DD CB 00 6E
 bit 5, (ix+127)        ;; 09B2:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 09B6:  DD CB 80 76
 bit 6, (ix+0)          ;; 09BA:  DD CB 00 76
 bit 6, (ix+127)        ;; 09BE:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 09C2:  DD CB 80 7E
 bit 7, (ix+0)          ;; 09C6:  DD CB 00 7E
 bit 7, (ix+127)        ;; 09CA:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 09CE:  DD CB 80 86
 res 0, (ix+0)          ;; 09D2:  DD CB 00 86
 res 0, (ix+127)        ;; 09D6:  DD CB 7F 86
 res 1, (ix+-128)       ;; 09DA:  DD CB 80 8E
 res 1, (ix+0)          ;; 09DE:  DD CB 00 8E
 res 1, (ix+127)        ;; 09E2:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 09E6:  DD CB 80 96
 res 2, (ix+0)          ;; 09EA:  DD CB 00 96
 res 2, (ix+127)        ;; 09EE:  DD CB 7F 96
 res 3, (ix+-128)       ;; 09F2:  DD CB 80 9E
 res 3, (ix+0)          ;; 09F6:  DD CB 00 9E
 res 3, (ix+127)        ;; 09FA:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 09FE:  DD CB 80 A6
 res 4, (ix+0)          ;; 0A02:  DD CB 00 A6
 res 4, (ix+127)        ;; 0A06:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0A0A:  DD CB 80 AE
 res 5, (ix+0)          ;; 0A0E:  DD CB 00 AE
 res 5, (ix+127)        ;; 0A12:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0A16:  DD CB 80 B6
 res 6, (ix+0)          ;; 0A1A:  DD CB 00 B6
 res 6, (ix+127)        ;; 0A1E:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0A22:  DD CB 80 BE
 res 7, (ix+0)          ;; 0A26:  DD CB 00 BE
 res 7, (ix+127)        ;; 0A2A:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0A2E:  DD CB 80 C6
 set 0, (ix+0)          ;; 0A32:  DD CB 00 C6
 set 0, (ix+127)        ;; 0A36:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0A3A:  DD CB 80 CE
 set 1, (ix+0)          ;; 0A3E:  DD CB 00 CE
 set 1, (ix+127)        ;; 0A42:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0A46:  DD CB 80 D6
 set 2, (ix+0)          ;; 0A4A:  DD CB 00 D6
 set 2, (ix+127)        ;; 0A4E:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0A52:  DD CB 80 DE
 set 3, (ix+0)          ;; 0A56:  DD CB 00 DE
 set 3, (ix+127)        ;; 0A5A:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0A5E:  DD CB 80 E6
 set 4, (ix+0)          ;; 0A62:  DD CB 00 E6
 set 4, (ix+127)        ;; 0A66:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0A6A:  DD CB 80 EE
 set 5, (ix+0)          ;; 0A6E:  DD CB 00 EE
 set 5, (ix+127)        ;; 0A72:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0A76:  DD CB 80 F6
 set 6, (ix+0)          ;; 0A7A:  DD CB 00 F6
 set 6, (ix+127)        ;; 0A7E:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0A82:  DD CB 80 FE
 set 7, (ix+0)          ;; 0A86:  DD CB 00 FE
 set 7, (ix+127)        ;; 0A8A:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0A8E:  FD CB 80 46
 bit 0, (iy+0)          ;; 0A92:  FD CB 00 46
 bit 0, (iy+127)        ;; 0A96:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0A9A:  FD CB 80 4E
 bit 1, (iy+0)          ;; 0A9E:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0AA2:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0AA6:  FD CB 80 56
 bit 2, (iy+0)          ;; 0AAA:  FD CB 00 56
 bit 2, (iy+127)        ;; 0AAE:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0AB2:  FD CB 80 5E
 bit 3, (iy+0)          ;; 0AB6:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0ABA:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0ABE:  FD CB 80 66
 bit 4, (iy+0)          ;; 0AC2:  FD CB 00 66
 bit 4, (iy+127)        ;; 0AC6:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0ACA:  FD CB 80 6E
 bit 5, (iy+0)          ;; 0ACE:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0AD2:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0AD6:  FD CB 80 76
 bit 6, (iy+0)          ;; 0ADA:  FD CB 00 76
 bit 6, (iy+127)        ;; 0ADE:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0AE2:  FD CB 80 7E
 bit 7, (iy+0)          ;; 0AE6:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0AEA:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0AEE:  FD CB 80 86
 res 0, (iy+0)          ;; 0AF2:  FD CB 00 86
 res 0, (iy+127)        ;; 0AF6:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0AFA:  FD CB 80 8E
 res 1, (iy+0)          ;; 0AFE:  FD CB 00 8E
 res 1, (iy+127)        ;; 0B02:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0B06:  FD CB 80 96
 res 2, (iy+0)          ;; 0B0A:  FD CB 00 96
 res 2, (iy+127)        ;; 0B0E:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0B12:  FD CB 80 9E
 res 3, (iy+0)          ;; 0B16:  FD CB 00 9E
 res 3, (iy+127)        ;; 0B1A:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0B1E:  FD CB 80 A6
 res 4, (iy+0)          ;; 0B22:  FD CB 00 A6
 res 4, (iy+127)        ;; 0B26:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0B2A:  FD CB 80 AE
 res 5, (iy+0)          ;; 0B2E:  FD CB 00 AE
 res 5, (iy+127)        ;; 0B32:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0B36:  FD CB 80 B6
 res 6, (iy+0)          ;; 0B3A:  FD CB 00 B6
 res 6, (iy+127)        ;; 0B3E:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0B42:  FD CB 80 BE
 res 7, (iy+0)          ;; 0B46:  FD CB 00 BE
 res 7, (iy+127)        ;; 0B4A:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0B4E:  FD CB 80 C6
 set 0, (iy+0)          ;; 0B52:  FD CB 00 C6
 set 0, (iy+127)        ;; 0B56:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0B5A:  FD CB 80 CE
 set 1, (iy+0)          ;; 0B5E:  FD CB 00 CE
 set 1, (iy+127)        ;; 0B62:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0B66:  FD CB 80 D6
 set 2, (iy+0)          ;; 0B6A:  FD CB 00 D6
 set 2, (iy+127)        ;; 0B6E:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0B72:  FD CB 80 DE
 set 3, (iy+0)          ;; 0B76:  FD CB 00 DE
 set 3, (iy+127)        ;; 0B7A:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0B7E:  FD CB 80 E6
 set 4, (iy+0)          ;; 0B82:  FD CB 00 E6
 set 4, (iy+127)        ;; 0B86:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0B8A:  FD CB 80 EE
 set 5, (iy+0)          ;; 0B8E:  FD CB 00 EE
 set 5, (iy+127)        ;; 0B92:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0B96:  FD CB 80 F6
 set 6, (iy+0)          ;; 0B9A:  FD CB 00 F6
 set 6, (iy+127)        ;; 0B9E:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0BA2:  FD CB 80 FE
 set 7, (iy+0)          ;; 0BA6:  FD CB 00 FE
 set 7, (iy+127)        ;; 0BAA:  FD CB 7F FE
 ldi                    ;; 0BAE:  ED A0
 ldir                   ;; 0BB0:  ED B0
 ldd                    ;; 0BB2:  ED A8
 lddr                   ;; 0BB4:  ED B8
 nop                    ;; 0BB6:  00
 altd                   ;; 0BB7:  76
 ld a, xpc              ;; 0BB8:  ED 77
 ld xpc, a              ;; 0BBA:  ED 67
 jp 0                   ;; 0BBC:  C3 00 00
 jp 291                 ;; 0BBF:  C3 23 01
 jp 17767               ;; 0BC2:  C3 67 45
 jp 35243               ;; 0BC5:  C3 AB 89
 jp 52719               ;; 0BC8:  C3 EF CD
 jp 65535               ;; 0BCB:  C3 FF FF
 jp nz, 0               ;; 0BCE:  C2 00 00
 jp nz, 291             ;; 0BD1:  C2 23 01
 jp nz, 17767           ;; 0BD4:  C2 67 45
 jp nz, 35243           ;; 0BD7:  C2 AB 89
 jp nz, 52719           ;; 0BDA:  C2 EF CD
 jp nz, 65535           ;; 0BDD:  C2 FF FF
 jp z, 0                ;; 0BE0:  CA 00 00
 jp z, 291              ;; 0BE3:  CA 23 01
 jp z, 17767            ;; 0BE6:  CA 67 45
 jp z, 35243            ;; 0BE9:  CA AB 89
 jp z, 52719            ;; 0BEC:  CA EF CD
 jp z, 65535            ;; 0BEF:  CA FF FF
 jp nc, 0               ;; 0BF2:  D2 00 00
 jp nc, 291             ;; 0BF5:  D2 23 01
 jp nc, 17767           ;; 0BF8:  D2 67 45
 jp nc, 35243           ;; 0BFB:  D2 AB 89
 jp nc, 52719           ;; 0BFE:  D2 EF CD
 jp nc, 65535           ;; 0C01:  D2 FF FF
 jp c, 0                ;; 0C04:  DA 00 00
 jp c, 291              ;; 0C07:  DA 23 01
 jp c, 17767            ;; 0C0A:  DA 67 45
 jp c, 35243            ;; 0C0D:  DA AB 89
 jp c, 52719            ;; 0C10:  DA EF CD
 jp c, 65535            ;; 0C13:  DA FF FF
 jp po, 0               ;; 0C16:  E2 00 00
 jp po, 291             ;; 0C19:  E2 23 01
 jp po, 17767           ;; 0C1C:  E2 67 45
 jp po, 35243           ;; 0C1F:  E2 AB 89
 jp po, 52719           ;; 0C22:  E2 EF CD
 jp po, 65535           ;; 0C25:  E2 FF FF
 jp pe, 0               ;; 0C28:  EA 00 00
 jp pe, 291             ;; 0C2B:  EA 23 01
 jp pe, 17767           ;; 0C2E:  EA 67 45
 jp pe, 35243           ;; 0C31:  EA AB 89
 jp pe, 52719           ;; 0C34:  EA EF CD
 jp pe, 65535           ;; 0C37:  EA FF FF
 jp p, 0                ;; 0C3A:  F2 00 00
 jp p, 291              ;; 0C3D:  F2 23 01
 jp p, 17767            ;; 0C40:  F2 67 45
 jp p, 35243            ;; 0C43:  F2 AB 89
 jp p, 52719            ;; 0C46:  F2 EF CD
 jp p, 65535            ;; 0C49:  F2 FF FF
 jp m, 0                ;; 0C4C:  FA 00 00
 jp m, 291              ;; 0C4F:  FA 23 01
 jp m, 17767            ;; 0C52:  FA 67 45
 jp m, 35243            ;; 0C55:  FA AB 89
 jp m, 52719            ;; 0C58:  FA EF CD
 jp m, 65535            ;; 0C5B:  FA FF FF
 jp lz, 0               ;; 0C5E:  E2 00 00
 jp lz, 291             ;; 0C61:  E2 23 01
 jp lz, 17767           ;; 0C64:  E2 67 45
 jp lz, 35243           ;; 0C67:  E2 AB 89
 jp lz, 52719           ;; 0C6A:  E2 EF CD
 jp lz, 65535           ;; 0C6D:  E2 FF FF
 jp lo, 0               ;; 0C70:  EA 00 00
 jp lo, 291             ;; 0C73:  EA 23 01
 jp lo, 17767           ;; 0C76:  EA 67 45
 jp lo, 35243           ;; 0C79:  EA AB 89
 jp lo, 52719           ;; 0C7C:  EA EF CD
 jp lo, 65535           ;; 0C7F:  EA FF FF
 jp (hl)                ;; 0C82:  E9
 jp (ix)                ;; 0C83:  DD E9
 jp (iy)                ;; 0C85:  FD E9
 djnz ASMPC             ;; 0C87:  10 FE
 jr ASMPC               ;; 0C89:  18 FE
 jr nz, ASMPC           ;; 0C8B:  20 FE
 jr z, ASMPC            ;; 0C8D:  28 FE
 jr nc, ASMPC           ;; 0C8F:  30 FE
 jr c, ASMPC            ;; 0C91:  38 FE
 call 0                 ;; 0C93:  CD 00 00
 call 291               ;; 0C96:  CD 23 01
 call 17767             ;; 0C99:  CD 67 45
 call 35243             ;; 0C9C:  CD AB 89
 call 52719             ;; 0C9F:  CD EF CD
 call 65535             ;; 0CA2:  CD FF FF
 ret                    ;; 0CA5:  C9
 ret nz                 ;; 0CA6:  C0
 ret z                  ;; 0CA7:  C8
 ret nc                 ;; 0CA8:  D0
 ret c                  ;; 0CA9:  D8
 ret po                 ;; 0CAA:  E0
 ret pe                 ;; 0CAB:  E8
 ret p                  ;; 0CAC:  F0
 ret m                  ;; 0CAD:  F8
 ret lz                 ;; 0CAE:  E0
 ret lo                 ;; 0CAF:  E8
 rst 16                 ;; 0CB0:  D7
 rst 24                 ;; 0CB1:  DF
 rst 32                 ;; 0CB2:  E7
 rst 40                 ;; 0CB3:  EF
 rst 56                 ;; 0CB4:  FF
 ioe                    ;; 0CB5:  DB
 ioi                    ;; 0CB6:  D3
 ipset 0                ;; 0CB7:  ED 46
 ipset 1                ;; 0CB9:  ED 56
 ipset 2                ;; 0CBB:  ED 4E
 ipset 3                ;; 0CBD:  ED 5E
 ipres                  ;; 0CBF:  ED 5D
 ld iir, a              ;; 0CC1:  ED 47
 ld a, iir              ;; 0CC3:  ED 57
 ld eir, a              ;; 0CC5:  ED 4F
 ld a, eir              ;; 0CC7:  ED 5F
 reti                   ;; 0CC9:  ED 4D
