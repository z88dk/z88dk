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
 daa                    ;; 048F:  27
 rld                    ;; 0490:  ED 6F
 rrd                    ;; 0492:  ED 67
 cpl                    ;; 0494:  2F
 neg                    ;; 0495:  ED 44
 ccf                    ;; 0497:  3F
 scf                    ;; 0498:  37
 ld bc, 0               ;; 0499:  01 00 00
 ld bc, 291             ;; 049C:  01 23 01
 ld bc, 17767           ;; 049F:  01 67 45
 ld bc, 35243           ;; 04A2:  01 AB 89
 ld bc, 52719           ;; 04A5:  01 EF CD
 ld bc, 65535           ;; 04A8:  01 FF FF
 ld de, 0               ;; 04AB:  11 00 00
 ld de, 291             ;; 04AE:  11 23 01
 ld de, 17767           ;; 04B1:  11 67 45
 ld de, 35243           ;; 04B4:  11 AB 89
 ld de, 52719           ;; 04B7:  11 EF CD
 ld de, 65535           ;; 04BA:  11 FF FF
 ld hl, 0               ;; 04BD:  21 00 00
 ld hl, 291             ;; 04C0:  21 23 01
 ld hl, 17767           ;; 04C3:  21 67 45
 ld hl, 35243           ;; 04C6:  21 AB 89
 ld hl, 52719           ;; 04C9:  21 EF CD
 ld hl, 65535           ;; 04CC:  21 FF FF
 ld sp, 0               ;; 04CF:  31 00 00
 ld sp, 291             ;; 04D2:  31 23 01
 ld sp, 17767           ;; 04D5:  31 67 45
 ld sp, 35243           ;; 04D8:  31 AB 89
 ld sp, 52719           ;; 04DB:  31 EF CD
 ld sp, 65535           ;; 04DE:  31 FF FF
 ld ix, 0               ;; 04E1:  DD 21 00 00
 ld ix, 291             ;; 04E5:  DD 21 23 01
 ld ix, 17767           ;; 04E9:  DD 21 67 45
 ld ix, 35243           ;; 04ED:  DD 21 AB 89
 ld ix, 52719           ;; 04F1:  DD 21 EF CD
 ld ix, 65535           ;; 04F5:  DD 21 FF FF
 ld iy, 0               ;; 04F9:  FD 21 00 00
 ld iy, 291             ;; 04FD:  FD 21 23 01
 ld iy, 17767           ;; 0501:  FD 21 67 45
 ld iy, 35243           ;; 0505:  FD 21 AB 89
 ld iy, 52719           ;; 0509:  FD 21 EF CD
 ld iy, 65535           ;; 050D:  FD 21 FF FF
 ld hl, (0)             ;; 0511:  2A 00 00
 ld hl, (291)           ;; 0514:  2A 23 01
 ld hl, (17767)         ;; 0517:  2A 67 45
 ld hl, (35243)         ;; 051A:  2A AB 89
 ld hl, (52719)         ;; 051D:  2A EF CD
 ld hl, (65535)         ;; 0520:  2A FF FF
 ld ix, (0)             ;; 0523:  DD 2A 00 00
 ld ix, (291)           ;; 0527:  DD 2A 23 01
 ld ix, (17767)         ;; 052B:  DD 2A 67 45
 ld ix, (35243)         ;; 052F:  DD 2A AB 89
 ld ix, (52719)         ;; 0533:  DD 2A EF CD
 ld ix, (65535)         ;; 0537:  DD 2A FF FF
 ld iy, (0)             ;; 053B:  FD 2A 00 00
 ld iy, (291)           ;; 053F:  FD 2A 23 01
 ld iy, (17767)         ;; 0543:  FD 2A 67 45
 ld iy, (35243)         ;; 0547:  FD 2A AB 89
 ld iy, (52719)         ;; 054B:  FD 2A EF CD
 ld iy, (65535)         ;; 054F:  FD 2A FF FF
 ld (0), hl             ;; 0553:  22 00 00
 ld (291), hl           ;; 0556:  22 23 01
 ld (17767), hl         ;; 0559:  22 67 45
 ld (35243), hl         ;; 055C:  22 AB 89
 ld (52719), hl         ;; 055F:  22 EF CD
 ld (65535), hl         ;; 0562:  22 FF FF
 ld (0), ix             ;; 0565:  DD 22 00 00
 ld (291), ix           ;; 0569:  DD 22 23 01
 ld (17767), ix         ;; 056D:  DD 22 67 45
 ld (35243), ix         ;; 0571:  DD 22 AB 89
 ld (52719), ix         ;; 0575:  DD 22 EF CD
 ld (65535), ix         ;; 0579:  DD 22 FF FF
 ld (0), iy             ;; 057D:  FD 22 00 00
 ld (291), iy           ;; 0581:  FD 22 23 01
 ld (17767), iy         ;; 0585:  FD 22 67 45
 ld (35243), iy         ;; 0589:  FD 22 AB 89
 ld (52719), iy         ;; 058D:  FD 22 EF CD
 ld (65535), iy         ;; 0591:  FD 22 FF FF
 LD bc, (0)             ;; 0595:  ED 4B 00 00
 LD bc, (291)           ;; 0599:  ED 4B 23 01
 LD bc, (17767)         ;; 059D:  ED 4B 67 45
 LD bc, (35243)         ;; 05A1:  ED 4B AB 89
 LD bc, (52719)         ;; 05A5:  ED 4B EF CD
 LD bc, (65535)         ;; 05A9:  ED 4B FF FF
 LD de, (0)             ;; 05AD:  ED 5B 00 00
 LD de, (291)           ;; 05B1:  ED 5B 23 01
 LD de, (17767)         ;; 05B5:  ED 5B 67 45
 LD de, (35243)         ;; 05B9:  ED 5B AB 89
 LD de, (52719)         ;; 05BD:  ED 5B EF CD
 LD de, (65535)         ;; 05C1:  ED 5B FF FF
 LD sp, (0)             ;; 05C5:  ED 7B 00 00
 LD sp, (291)           ;; 05C9:  ED 7B 23 01
 LD sp, (17767)         ;; 05CD:  ED 7B 67 45
 LD sp, (35243)         ;; 05D1:  ED 7B AB 89
 LD sp, (52719)         ;; 05D5:  ED 7B EF CD
 LD sp, (65535)         ;; 05D9:  ED 7B FF FF
 LD (0), bc             ;; 05DD:  ED 43 00 00
 LD (291), bc           ;; 05E1:  ED 43 23 01
 LD (17767), bc         ;; 05E5:  ED 43 67 45
 LD (35243), bc         ;; 05E9:  ED 43 AB 89
 LD (52719), bc         ;; 05ED:  ED 43 EF CD
 LD (65535), bc         ;; 05F1:  ED 43 FF FF
 LD (0), de             ;; 05F5:  ED 53 00 00
 LD (291), de           ;; 05F9:  ED 53 23 01
 LD (17767), de         ;; 05FD:  ED 53 67 45
 LD (35243), de         ;; 0601:  ED 53 AB 89
 LD (52719), de         ;; 0605:  ED 53 EF CD
 LD (65535), de         ;; 0609:  ED 53 FF FF
 LD (0), sp             ;; 060D:  ED 73 00 00
 LD (291), sp           ;; 0611:  ED 73 23 01
 LD (17767), sp         ;; 0615:  ED 73 67 45
 LD (35243), sp         ;; 0619:  ED 73 AB 89
 LD (52719), sp         ;; 061D:  ED 73 EF CD
 LD (65535), sp         ;; 0621:  ED 73 FF FF
 ld sp, hl              ;; 0625:  F9
 ld sp, ix              ;; 0626:  DD F9
 ld sp, iy              ;; 0628:  FD F9
 push bc                ;; 062A:  C5
 push de                ;; 062B:  D5
 push hl                ;; 062C:  E5
 push af                ;; 062D:  F5
 push ix                ;; 062E:  DD E5
 push iy                ;; 0630:  FD E5
 pop bc                 ;; 0632:  C1
 pop de                 ;; 0633:  D1
 pop hl                 ;; 0634:  E1
 pop af                 ;; 0635:  F1
 pop ix                 ;; 0636:  DD E1
 pop iy                 ;; 0638:  FD E1
 add hl, bc             ;; 063A:  09
 add hl, de             ;; 063B:  19
 add hl, hl             ;; 063C:  29
 add hl, sp             ;; 063D:  39
 add ix, bc             ;; 063E:  DD 09
 add ix, de             ;; 0640:  DD 19
 add ix, ix             ;; 0642:  DD 29
 add ix, sp             ;; 0644:  DD 39
 add iy, bc             ;; 0646:  FD 09
 add iy, de             ;; 0648:  FD 19
 add iy, iy             ;; 064A:  FD 29
 add iy, sp             ;; 064C:  FD 39
 sbc hl, bc             ;; 064E:  ED 42
 sbc hl, de             ;; 0650:  ED 52
 sbc hl, hl             ;; 0652:  ED 62
 sbc hl, sp             ;; 0654:  ED 72
 adc hl, bc             ;; 0656:  ED 4A
 adc hl, de             ;; 0658:  ED 5A
 adc hl, hl             ;; 065A:  ED 6A
 adc hl, sp             ;; 065C:  ED 7A
 inc bc                 ;; 065E:  03
 inc de                 ;; 065F:  13
 inc hl                 ;; 0660:  23
 inc sp                 ;; 0661:  33
 dec bc                 ;; 0662:  0B
 dec de                 ;; 0663:  1B
 dec hl                 ;; 0664:  2B
 dec sp                 ;; 0665:  3B
 inc ix                 ;; 0666:  DD 23
 dec ix                 ;; 0668:  DD 2B
 inc iy                 ;; 066A:  FD 23
 dec iy                 ;; 066C:  FD 2B
 mlt bc                 ;; 066E:  ED 4C
 mlt de                 ;; 0670:  ED 5C
 mlt hl                 ;; 0672:  ED 6C
 mlt sp                 ;; 0674:  ED 7C
 ex af, af              ;; 0676:  08
 ex af, af'             ;; 0677:  08
 exx                    ;; 0678:  D9
 ex (sp), hl            ;; 0679:  E3
 ex (sp), ix            ;; 067A:  DD E3
 ex (sp), iy            ;; 067C:  FD E3
 ex de, hl              ;; 067E:  EB
 rlca                   ;; 067F:  07
 rrca                   ;; 0680:  0F
 rla                    ;; 0681:  17
 rra                    ;; 0682:  1F
 rlc b                  ;; 0683:  CB 00
 rlc c                  ;; 0685:  CB 01
 rlc d                  ;; 0687:  CB 02
 rlc e                  ;; 0689:  CB 03
 rlc h                  ;; 068B:  CB 04
 rlc l                  ;; 068D:  CB 05
 rlc (hl)               ;; 068F:  CB 06
 rlc a                  ;; 0691:  CB 07
 rrc b                  ;; 0693:  CB 08
 rrc c                  ;; 0695:  CB 09
 rrc d                  ;; 0697:  CB 0A
 rrc e                  ;; 0699:  CB 0B
 rrc h                  ;; 069B:  CB 0C
 rrc l                  ;; 069D:  CB 0D
 rrc (hl)               ;; 069F:  CB 0E
 rrc a                  ;; 06A1:  CB 0F
 rl b                   ;; 06A3:  CB 10
 rl c                   ;; 06A5:  CB 11
 rl d                   ;; 06A7:  CB 12
 rl e                   ;; 06A9:  CB 13
 rl h                   ;; 06AB:  CB 14
 rl l                   ;; 06AD:  CB 15
 rl (hl)                ;; 06AF:  CB 16
 rl a                   ;; 06B1:  CB 17
 rr b                   ;; 06B3:  CB 18
 rr c                   ;; 06B5:  CB 19
 rr d                   ;; 06B7:  CB 1A
 rr e                   ;; 06B9:  CB 1B
 rr h                   ;; 06BB:  CB 1C
 rr l                   ;; 06BD:  CB 1D
 rr (hl)                ;; 06BF:  CB 1E
 rr a                   ;; 06C1:  CB 1F
 sla b                  ;; 06C3:  CB 20
 sla c                  ;; 06C5:  CB 21
 sla d                  ;; 06C7:  CB 22
 sla e                  ;; 06C9:  CB 23
 sla h                  ;; 06CB:  CB 24
 sla l                  ;; 06CD:  CB 25
 sla (hl)               ;; 06CF:  CB 26
 sla a                  ;; 06D1:  CB 27
 sra b                  ;; 06D3:  CB 28
 sra c                  ;; 06D5:  CB 29
 sra d                  ;; 06D7:  CB 2A
 sra e                  ;; 06D9:  CB 2B
 sra h                  ;; 06DB:  CB 2C
 sra l                  ;; 06DD:  CB 2D
 sra (hl)               ;; 06DF:  CB 2E
 sra a                  ;; 06E1:  CB 2F
 srl b                  ;; 06E3:  CB 38
 srl c                  ;; 06E5:  CB 39
 srl d                  ;; 06E7:  CB 3A
 srl e                  ;; 06E9:  CB 3B
 srl h                  ;; 06EB:  CB 3C
 srl l                  ;; 06ED:  CB 3D
 srl (hl)               ;; 06EF:  CB 3E
 srl a                  ;; 06F1:  CB 3F
 sll b                  ;; 06F3:  CB 30
 sll c                  ;; 06F5:  CB 31
 sll d                  ;; 06F7:  CB 32
 sll e                  ;; 06F9:  CB 33
 sll h                  ;; 06FB:  CB 34
 sll l                  ;; 06FD:  CB 35
 sll (hl)               ;; 06FF:  CB 36
 sll a                  ;; 0701:  CB 37
 rlc (ix+-128)          ;; 0703:  DD CB 80 06
 rlc (ix+0)             ;; 0707:  DD CB 00 06
 rlc (ix+127)           ;; 070B:  DD CB 7F 06
 rrc (ix+-128)          ;; 070F:  DD CB 80 0E
 rrc (ix+0)             ;; 0713:  DD CB 00 0E
 rrc (ix+127)           ;; 0717:  DD CB 7F 0E
 rl (ix+-128)           ;; 071B:  DD CB 80 16
 rl (ix+0)              ;; 071F:  DD CB 00 16
 rl (ix+127)            ;; 0723:  DD CB 7F 16
 rr (ix+-128)           ;; 0727:  DD CB 80 1E
 rr (ix+0)              ;; 072B:  DD CB 00 1E
 rr (ix+127)            ;; 072F:  DD CB 7F 1E
 sla (ix+-128)          ;; 0733:  DD CB 80 26
 sla (ix+0)             ;; 0737:  DD CB 00 26
 sla (ix+127)           ;; 073B:  DD CB 7F 26
 sra (ix+-128)          ;; 073F:  DD CB 80 2E
 sra (ix+0)             ;; 0743:  DD CB 00 2E
 sra (ix+127)           ;; 0747:  DD CB 7F 2E
 srl (ix+-128)          ;; 074B:  DD CB 80 3E
 srl (ix+0)             ;; 074F:  DD CB 00 3E
 srl (ix+127)           ;; 0753:  DD CB 7F 3E
 sll (ix+-128)          ;; 0757:  DD CB 80 36
 sll (ix+0)             ;; 075B:  DD CB 00 36
 sll (ix+127)           ;; 075F:  DD CB 7F 36
 rlc (iy+-128)          ;; 0763:  FD CB 80 06
 rlc (iy+0)             ;; 0767:  FD CB 00 06
 rlc (iy+127)           ;; 076B:  FD CB 7F 06
 rrc (iy+-128)          ;; 076F:  FD CB 80 0E
 rrc (iy+0)             ;; 0773:  FD CB 00 0E
 rrc (iy+127)           ;; 0777:  FD CB 7F 0E
 rl (iy+-128)           ;; 077B:  FD CB 80 16
 rl (iy+0)              ;; 077F:  FD CB 00 16
 rl (iy+127)            ;; 0783:  FD CB 7F 16
 rr (iy+-128)           ;; 0787:  FD CB 80 1E
 rr (iy+0)              ;; 078B:  FD CB 00 1E
 rr (iy+127)            ;; 078F:  FD CB 7F 1E
 sla (iy+-128)          ;; 0793:  FD CB 80 26
 sla (iy+0)             ;; 0797:  FD CB 00 26
 sla (iy+127)           ;; 079B:  FD CB 7F 26
 sra (iy+-128)          ;; 079F:  FD CB 80 2E
 sra (iy+0)             ;; 07A3:  FD CB 00 2E
 sra (iy+127)           ;; 07A7:  FD CB 7F 2E
 srl (iy+-128)          ;; 07AB:  FD CB 80 3E
 srl (iy+0)             ;; 07AF:  FD CB 00 3E
 srl (iy+127)           ;; 07B3:  FD CB 7F 3E
 sll (iy+-128)          ;; 07B7:  FD CB 80 36
 sll (iy+0)             ;; 07BB:  FD CB 00 36
 sll (iy+127)           ;; 07BF:  FD CB 7F 36
 bit 0, b               ;; 07C3:  CB 40
 bit 0, c               ;; 07C5:  CB 41
 bit 0, d               ;; 07C7:  CB 42
 bit 0, e               ;; 07C9:  CB 43
 bit 0, h               ;; 07CB:  CB 44
 bit 0, l               ;; 07CD:  CB 45
 bit 0, (hl)            ;; 07CF:  CB 46
 bit 0, a               ;; 07D1:  CB 47
 bit 1, b               ;; 07D3:  CB 48
 bit 1, c               ;; 07D5:  CB 49
 bit 1, d               ;; 07D7:  CB 4A
 bit 1, e               ;; 07D9:  CB 4B
 bit 1, h               ;; 07DB:  CB 4C
 bit 1, l               ;; 07DD:  CB 4D
 bit 1, (hl)            ;; 07DF:  CB 4E
 bit 1, a               ;; 07E1:  CB 4F
 bit 2, b               ;; 07E3:  CB 50
 bit 2, c               ;; 07E5:  CB 51
 bit 2, d               ;; 07E7:  CB 52
 bit 2, e               ;; 07E9:  CB 53
 bit 2, h               ;; 07EB:  CB 54
 bit 2, l               ;; 07ED:  CB 55
 bit 2, (hl)            ;; 07EF:  CB 56
 bit 2, a               ;; 07F1:  CB 57
 bit 3, b               ;; 07F3:  CB 58
 bit 3, c               ;; 07F5:  CB 59
 bit 3, d               ;; 07F7:  CB 5A
 bit 3, e               ;; 07F9:  CB 5B
 bit 3, h               ;; 07FB:  CB 5C
 bit 3, l               ;; 07FD:  CB 5D
 bit 3, (hl)            ;; 07FF:  CB 5E
 bit 3, a               ;; 0801:  CB 5F
 bit 4, b               ;; 0803:  CB 60
 bit 4, c               ;; 0805:  CB 61
 bit 4, d               ;; 0807:  CB 62
 bit 4, e               ;; 0809:  CB 63
 bit 4, h               ;; 080B:  CB 64
 bit 4, l               ;; 080D:  CB 65
 bit 4, (hl)            ;; 080F:  CB 66
 bit 4, a               ;; 0811:  CB 67
 bit 5, b               ;; 0813:  CB 68
 bit 5, c               ;; 0815:  CB 69
 bit 5, d               ;; 0817:  CB 6A
 bit 5, e               ;; 0819:  CB 6B
 bit 5, h               ;; 081B:  CB 6C
 bit 5, l               ;; 081D:  CB 6D
 bit 5, (hl)            ;; 081F:  CB 6E
 bit 5, a               ;; 0821:  CB 6F
 bit 6, b               ;; 0823:  CB 70
 bit 6, c               ;; 0825:  CB 71
 bit 6, d               ;; 0827:  CB 72
 bit 6, e               ;; 0829:  CB 73
 bit 6, h               ;; 082B:  CB 74
 bit 6, l               ;; 082D:  CB 75
 bit 6, (hl)            ;; 082F:  CB 76
 bit 6, a               ;; 0831:  CB 77
 bit 7, b               ;; 0833:  CB 78
 bit 7, c               ;; 0835:  CB 79
 bit 7, d               ;; 0837:  CB 7A
 bit 7, e               ;; 0839:  CB 7B
 bit 7, h               ;; 083B:  CB 7C
 bit 7, l               ;; 083D:  CB 7D
 bit 7, (hl)            ;; 083F:  CB 7E
 bit 7, a               ;; 0841:  CB 7F
 res 0, b               ;; 0843:  CB 80
 res 0, c               ;; 0845:  CB 81
 res 0, d               ;; 0847:  CB 82
 res 0, e               ;; 0849:  CB 83
 res 0, h               ;; 084B:  CB 84
 res 0, l               ;; 084D:  CB 85
 res 0, (hl)            ;; 084F:  CB 86
 res 0, a               ;; 0851:  CB 87
 res 1, b               ;; 0853:  CB 88
 res 1, c               ;; 0855:  CB 89
 res 1, d               ;; 0857:  CB 8A
 res 1, e               ;; 0859:  CB 8B
 res 1, h               ;; 085B:  CB 8C
 res 1, l               ;; 085D:  CB 8D
 res 1, (hl)            ;; 085F:  CB 8E
 res 1, a               ;; 0861:  CB 8F
 res 2, b               ;; 0863:  CB 90
 res 2, c               ;; 0865:  CB 91
 res 2, d               ;; 0867:  CB 92
 res 2, e               ;; 0869:  CB 93
 res 2, h               ;; 086B:  CB 94
 res 2, l               ;; 086D:  CB 95
 res 2, (hl)            ;; 086F:  CB 96
 res 2, a               ;; 0871:  CB 97
 res 3, b               ;; 0873:  CB 98
 res 3, c               ;; 0875:  CB 99
 res 3, d               ;; 0877:  CB 9A
 res 3, e               ;; 0879:  CB 9B
 res 3, h               ;; 087B:  CB 9C
 res 3, l               ;; 087D:  CB 9D
 res 3, (hl)            ;; 087F:  CB 9E
 res 3, a               ;; 0881:  CB 9F
 res 4, b               ;; 0883:  CB A0
 res 4, c               ;; 0885:  CB A1
 res 4, d               ;; 0887:  CB A2
 res 4, e               ;; 0889:  CB A3
 res 4, h               ;; 088B:  CB A4
 res 4, l               ;; 088D:  CB A5
 res 4, (hl)            ;; 088F:  CB A6
 res 4, a               ;; 0891:  CB A7
 res 5, b               ;; 0893:  CB A8
 res 5, c               ;; 0895:  CB A9
 res 5, d               ;; 0897:  CB AA
 res 5, e               ;; 0899:  CB AB
 res 5, h               ;; 089B:  CB AC
 res 5, l               ;; 089D:  CB AD
 res 5, (hl)            ;; 089F:  CB AE
 res 5, a               ;; 08A1:  CB AF
 res 6, b               ;; 08A3:  CB B0
 res 6, c               ;; 08A5:  CB B1
 res 6, d               ;; 08A7:  CB B2
 res 6, e               ;; 08A9:  CB B3
 res 6, h               ;; 08AB:  CB B4
 res 6, l               ;; 08AD:  CB B5
 res 6, (hl)            ;; 08AF:  CB B6
 res 6, a               ;; 08B1:  CB B7
 res 7, b               ;; 08B3:  CB B8
 res 7, c               ;; 08B5:  CB B9
 res 7, d               ;; 08B7:  CB BA
 res 7, e               ;; 08B9:  CB BB
 res 7, h               ;; 08BB:  CB BC
 res 7, l               ;; 08BD:  CB BD
 res 7, (hl)            ;; 08BF:  CB BE
 res 7, a               ;; 08C1:  CB BF
 set 0, b               ;; 08C3:  CB C0
 set 0, c               ;; 08C5:  CB C1
 set 0, d               ;; 08C7:  CB C2
 set 0, e               ;; 08C9:  CB C3
 set 0, h               ;; 08CB:  CB C4
 set 0, l               ;; 08CD:  CB C5
 set 0, (hl)            ;; 08CF:  CB C6
 set 0, a               ;; 08D1:  CB C7
 set 1, b               ;; 08D3:  CB C8
 set 1, c               ;; 08D5:  CB C9
 set 1, d               ;; 08D7:  CB CA
 set 1, e               ;; 08D9:  CB CB
 set 1, h               ;; 08DB:  CB CC
 set 1, l               ;; 08DD:  CB CD
 set 1, (hl)            ;; 08DF:  CB CE
 set 1, a               ;; 08E1:  CB CF
 set 2, b               ;; 08E3:  CB D0
 set 2, c               ;; 08E5:  CB D1
 set 2, d               ;; 08E7:  CB D2
 set 2, e               ;; 08E9:  CB D3
 set 2, h               ;; 08EB:  CB D4
 set 2, l               ;; 08ED:  CB D5
 set 2, (hl)            ;; 08EF:  CB D6
 set 2, a               ;; 08F1:  CB D7
 set 3, b               ;; 08F3:  CB D8
 set 3, c               ;; 08F5:  CB D9
 set 3, d               ;; 08F7:  CB DA
 set 3, e               ;; 08F9:  CB DB
 set 3, h               ;; 08FB:  CB DC
 set 3, l               ;; 08FD:  CB DD
 set 3, (hl)            ;; 08FF:  CB DE
 set 3, a               ;; 0901:  CB DF
 set 4, b               ;; 0903:  CB E0
 set 4, c               ;; 0905:  CB E1
 set 4, d               ;; 0907:  CB E2
 set 4, e               ;; 0909:  CB E3
 set 4, h               ;; 090B:  CB E4
 set 4, l               ;; 090D:  CB E5
 set 4, (hl)            ;; 090F:  CB E6
 set 4, a               ;; 0911:  CB E7
 set 5, b               ;; 0913:  CB E8
 set 5, c               ;; 0915:  CB E9
 set 5, d               ;; 0917:  CB EA
 set 5, e               ;; 0919:  CB EB
 set 5, h               ;; 091B:  CB EC
 set 5, l               ;; 091D:  CB ED
 set 5, (hl)            ;; 091F:  CB EE
 set 5, a               ;; 0921:  CB EF
 set 6, b               ;; 0923:  CB F0
 set 6, c               ;; 0925:  CB F1
 set 6, d               ;; 0927:  CB F2
 set 6, e               ;; 0929:  CB F3
 set 6, h               ;; 092B:  CB F4
 set 6, l               ;; 092D:  CB F5
 set 6, (hl)            ;; 092F:  CB F6
 set 6, a               ;; 0931:  CB F7
 set 7, b               ;; 0933:  CB F8
 set 7, c               ;; 0935:  CB F9
 set 7, d               ;; 0937:  CB FA
 set 7, e               ;; 0939:  CB FB
 set 7, h               ;; 093B:  CB FC
 set 7, l               ;; 093D:  CB FD
 set 7, (hl)            ;; 093F:  CB FE
 set 7, a               ;; 0941:  CB FF
 bit 0, (ix+-128)       ;; 0943:  DD CB 80 46
 bit 0, (ix+0)          ;; 0947:  DD CB 00 46
 bit 0, (ix+127)        ;; 094B:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 094F:  DD CB 80 4E
 bit 1, (ix+0)          ;; 0953:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0957:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 095B:  DD CB 80 56
 bit 2, (ix+0)          ;; 095F:  DD CB 00 56
 bit 2, (ix+127)        ;; 0963:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0967:  DD CB 80 5E
 bit 3, (ix+0)          ;; 096B:  DD CB 00 5E
 bit 3, (ix+127)        ;; 096F:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0973:  DD CB 80 66
 bit 4, (ix+0)          ;; 0977:  DD CB 00 66
 bit 4, (ix+127)        ;; 097B:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 097F:  DD CB 80 6E
 bit 5, (ix+0)          ;; 0983:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0987:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 098B:  DD CB 80 76
 bit 6, (ix+0)          ;; 098F:  DD CB 00 76
 bit 6, (ix+127)        ;; 0993:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0997:  DD CB 80 7E
 bit 7, (ix+0)          ;; 099B:  DD CB 00 7E
 bit 7, (ix+127)        ;; 099F:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 09A3:  DD CB 80 86
 res 0, (ix+0)          ;; 09A7:  DD CB 00 86
 res 0, (ix+127)        ;; 09AB:  DD CB 7F 86
 res 1, (ix+-128)       ;; 09AF:  DD CB 80 8E
 res 1, (ix+0)          ;; 09B3:  DD CB 00 8E
 res 1, (ix+127)        ;; 09B7:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 09BB:  DD CB 80 96
 res 2, (ix+0)          ;; 09BF:  DD CB 00 96
 res 2, (ix+127)        ;; 09C3:  DD CB 7F 96
 res 3, (ix+-128)       ;; 09C7:  DD CB 80 9E
 res 3, (ix+0)          ;; 09CB:  DD CB 00 9E
 res 3, (ix+127)        ;; 09CF:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 09D3:  DD CB 80 A6
 res 4, (ix+0)          ;; 09D7:  DD CB 00 A6
 res 4, (ix+127)        ;; 09DB:  DD CB 7F A6
 res 5, (ix+-128)       ;; 09DF:  DD CB 80 AE
 res 5, (ix+0)          ;; 09E3:  DD CB 00 AE
 res 5, (ix+127)        ;; 09E7:  DD CB 7F AE
 res 6, (ix+-128)       ;; 09EB:  DD CB 80 B6
 res 6, (ix+0)          ;; 09EF:  DD CB 00 B6
 res 6, (ix+127)        ;; 09F3:  DD CB 7F B6
 res 7, (ix+-128)       ;; 09F7:  DD CB 80 BE
 res 7, (ix+0)          ;; 09FB:  DD CB 00 BE
 res 7, (ix+127)        ;; 09FF:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0A03:  DD CB 80 C6
 set 0, (ix+0)          ;; 0A07:  DD CB 00 C6
 set 0, (ix+127)        ;; 0A0B:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0A0F:  DD CB 80 CE
 set 1, (ix+0)          ;; 0A13:  DD CB 00 CE
 set 1, (ix+127)        ;; 0A17:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0A1B:  DD CB 80 D6
 set 2, (ix+0)          ;; 0A1F:  DD CB 00 D6
 set 2, (ix+127)        ;; 0A23:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0A27:  DD CB 80 DE
 set 3, (ix+0)          ;; 0A2B:  DD CB 00 DE
 set 3, (ix+127)        ;; 0A2F:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0A33:  DD CB 80 E6
 set 4, (ix+0)          ;; 0A37:  DD CB 00 E6
 set 4, (ix+127)        ;; 0A3B:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0A3F:  DD CB 80 EE
 set 5, (ix+0)          ;; 0A43:  DD CB 00 EE
 set 5, (ix+127)        ;; 0A47:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0A4B:  DD CB 80 F6
 set 6, (ix+0)          ;; 0A4F:  DD CB 00 F6
 set 6, (ix+127)        ;; 0A53:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0A57:  DD CB 80 FE
 set 7, (ix+0)          ;; 0A5B:  DD CB 00 FE
 set 7, (ix+127)        ;; 0A5F:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0A63:  FD CB 80 46
 bit 0, (iy+0)          ;; 0A67:  FD CB 00 46
 bit 0, (iy+127)        ;; 0A6B:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0A6F:  FD CB 80 4E
 bit 1, (iy+0)          ;; 0A73:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0A77:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0A7B:  FD CB 80 56
 bit 2, (iy+0)          ;; 0A7F:  FD CB 00 56
 bit 2, (iy+127)        ;; 0A83:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0A87:  FD CB 80 5E
 bit 3, (iy+0)          ;; 0A8B:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0A8F:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0A93:  FD CB 80 66
 bit 4, (iy+0)          ;; 0A97:  FD CB 00 66
 bit 4, (iy+127)        ;; 0A9B:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0A9F:  FD CB 80 6E
 bit 5, (iy+0)          ;; 0AA3:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0AA7:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0AAB:  FD CB 80 76
 bit 6, (iy+0)          ;; 0AAF:  FD CB 00 76
 bit 6, (iy+127)        ;; 0AB3:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0AB7:  FD CB 80 7E
 bit 7, (iy+0)          ;; 0ABB:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0ABF:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0AC3:  FD CB 80 86
 res 0, (iy+0)          ;; 0AC7:  FD CB 00 86
 res 0, (iy+127)        ;; 0ACB:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0ACF:  FD CB 80 8E
 res 1, (iy+0)          ;; 0AD3:  FD CB 00 8E
 res 1, (iy+127)        ;; 0AD7:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0ADB:  FD CB 80 96
 res 2, (iy+0)          ;; 0ADF:  FD CB 00 96
 res 2, (iy+127)        ;; 0AE3:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0AE7:  FD CB 80 9E
 res 3, (iy+0)          ;; 0AEB:  FD CB 00 9E
 res 3, (iy+127)        ;; 0AEF:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0AF3:  FD CB 80 A6
 res 4, (iy+0)          ;; 0AF7:  FD CB 00 A6
 res 4, (iy+127)        ;; 0AFB:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0AFF:  FD CB 80 AE
 res 5, (iy+0)          ;; 0B03:  FD CB 00 AE
 res 5, (iy+127)        ;; 0B07:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0B0B:  FD CB 80 B6
 res 6, (iy+0)          ;; 0B0F:  FD CB 00 B6
 res 6, (iy+127)        ;; 0B13:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0B17:  FD CB 80 BE
 res 7, (iy+0)          ;; 0B1B:  FD CB 00 BE
 res 7, (iy+127)        ;; 0B1F:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0B23:  FD CB 80 C6
 set 0, (iy+0)          ;; 0B27:  FD CB 00 C6
 set 0, (iy+127)        ;; 0B2B:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0B2F:  FD CB 80 CE
 set 1, (iy+0)          ;; 0B33:  FD CB 00 CE
 set 1, (iy+127)        ;; 0B37:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0B3B:  FD CB 80 D6
 set 2, (iy+0)          ;; 0B3F:  FD CB 00 D6
 set 2, (iy+127)        ;; 0B43:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0B47:  FD CB 80 DE
 set 3, (iy+0)          ;; 0B4B:  FD CB 00 DE
 set 3, (iy+127)        ;; 0B4F:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0B53:  FD CB 80 E6
 set 4, (iy+0)          ;; 0B57:  FD CB 00 E6
 set 4, (iy+127)        ;; 0B5B:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0B5F:  FD CB 80 EE
 set 5, (iy+0)          ;; 0B63:  FD CB 00 EE
 set 5, (iy+127)        ;; 0B67:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0B6B:  FD CB 80 F6
 set 6, (iy+0)          ;; 0B6F:  FD CB 00 F6
 set 6, (iy+127)        ;; 0B73:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0B77:  FD CB 80 FE
 set 7, (iy+0)          ;; 0B7B:  FD CB 00 FE
 set 7, (iy+127)        ;; 0B7F:  FD CB 7F FE
 ldi                    ;; 0B83:  ED A0
 ldir                   ;; 0B85:  ED B0
 ldd                    ;; 0B87:  ED A8
 lddr                   ;; 0B89:  ED B8
 cpi                    ;; 0B8B:  ED A1
 cpir                   ;; 0B8D:  ED B1
 cpd                    ;; 0B8F:  ED A9
 cpdr                   ;; 0B91:  ED B9
 nop                    ;; 0B93:  00
 halt                   ;; 0B94:  76
 slp                    ;; 0B95:  ED 76
 jp 0                   ;; 0B97:  C3 00 00
 jp 291                 ;; 0B9A:  C3 23 01
 jp 17767               ;; 0B9D:  C3 67 45
 jp 35243               ;; 0BA0:  C3 AB 89
 jp 52719               ;; 0BA3:  C3 EF CD
 jp 65535               ;; 0BA6:  C3 FF FF
 jp nz, 0               ;; 0BA9:  C2 00 00
 jp nz, 291             ;; 0BAC:  C2 23 01
 jp nz, 17767           ;; 0BAF:  C2 67 45
 jp nz, 35243           ;; 0BB2:  C2 AB 89
 jp nz, 52719           ;; 0BB5:  C2 EF CD
 jp nz, 65535           ;; 0BB8:  C2 FF FF
 jp z, 0                ;; 0BBB:  CA 00 00
 jp z, 291              ;; 0BBE:  CA 23 01
 jp z, 17767            ;; 0BC1:  CA 67 45
 jp z, 35243            ;; 0BC4:  CA AB 89
 jp z, 52719            ;; 0BC7:  CA EF CD
 jp z, 65535            ;; 0BCA:  CA FF FF
 jp nc, 0               ;; 0BCD:  D2 00 00
 jp nc, 291             ;; 0BD0:  D2 23 01
 jp nc, 17767           ;; 0BD3:  D2 67 45
 jp nc, 35243           ;; 0BD6:  D2 AB 89
 jp nc, 52719           ;; 0BD9:  D2 EF CD
 jp nc, 65535           ;; 0BDC:  D2 FF FF
 jp c, 0                ;; 0BDF:  DA 00 00
 jp c, 291              ;; 0BE2:  DA 23 01
 jp c, 17767            ;; 0BE5:  DA 67 45
 jp c, 35243            ;; 0BE8:  DA AB 89
 jp c, 52719            ;; 0BEB:  DA EF CD
 jp c, 65535            ;; 0BEE:  DA FF FF
 jp po, 0               ;; 0BF1:  E2 00 00
 jp po, 291             ;; 0BF4:  E2 23 01
 jp po, 17767           ;; 0BF7:  E2 67 45
 jp po, 35243           ;; 0BFA:  E2 AB 89
 jp po, 52719           ;; 0BFD:  E2 EF CD
 jp po, 65535           ;; 0C00:  E2 FF FF
 jp pe, 0               ;; 0C03:  EA 00 00
 jp pe, 291             ;; 0C06:  EA 23 01
 jp pe, 17767           ;; 0C09:  EA 67 45
 jp pe, 35243           ;; 0C0C:  EA AB 89
 jp pe, 52719           ;; 0C0F:  EA EF CD
 jp pe, 65535           ;; 0C12:  EA FF FF
 jp p, 0                ;; 0C15:  F2 00 00
 jp p, 291              ;; 0C18:  F2 23 01
 jp p, 17767            ;; 0C1B:  F2 67 45
 jp p, 35243            ;; 0C1E:  F2 AB 89
 jp p, 52719            ;; 0C21:  F2 EF CD
 jp p, 65535            ;; 0C24:  F2 FF FF
 jp m, 0                ;; 0C27:  FA 00 00
 jp m, 291              ;; 0C2A:  FA 23 01
 jp m, 17767            ;; 0C2D:  FA 67 45
 jp m, 35243            ;; 0C30:  FA AB 89
 jp m, 52719            ;; 0C33:  FA EF CD
 jp m, 65535            ;; 0C36:  FA FF FF
 jp (hl)                ;; 0C39:  E9
 jp (ix)                ;; 0C3A:  DD E9
 jp (iy)                ;; 0C3C:  FD E9
 djnz ASMPC             ;; 0C3E:  10 FE
 jr ASMPC               ;; 0C40:  18 FE
 jr nz, ASMPC           ;; 0C42:  20 FE
 jr z, ASMPC            ;; 0C44:  28 FE
 jr nc, ASMPC           ;; 0C46:  30 FE
 jr c, ASMPC            ;; 0C48:  38 FE
 call 0                 ;; 0C4A:  CD 00 00
 call 291               ;; 0C4D:  CD 23 01
 call 17767             ;; 0C50:  CD 67 45
 call 35243             ;; 0C53:  CD AB 89
 call 52719             ;; 0C56:  CD EF CD
 call 65535             ;; 0C59:  CD FF FF
 call nz, 0             ;; 0C5C:  C4 00 00
 call nz, 291           ;; 0C5F:  C4 23 01
 call nz, 17767         ;; 0C62:  C4 67 45
 call nz, 35243         ;; 0C65:  C4 AB 89
 call nz, 52719         ;; 0C68:  C4 EF CD
 call nz, 65535         ;; 0C6B:  C4 FF FF
 call z, 0              ;; 0C6E:  CC 00 00
 call z, 291            ;; 0C71:  CC 23 01
 call z, 17767          ;; 0C74:  CC 67 45
 call z, 35243          ;; 0C77:  CC AB 89
 call z, 52719          ;; 0C7A:  CC EF CD
 call z, 65535          ;; 0C7D:  CC FF FF
 call nc, 0             ;; 0C80:  D4 00 00
 call nc, 291           ;; 0C83:  D4 23 01
 call nc, 17767         ;; 0C86:  D4 67 45
 call nc, 35243         ;; 0C89:  D4 AB 89
 call nc, 52719         ;; 0C8C:  D4 EF CD
 call nc, 65535         ;; 0C8F:  D4 FF FF
 call c, 0              ;; 0C92:  DC 00 00
 call c, 291            ;; 0C95:  DC 23 01
 call c, 17767          ;; 0C98:  DC 67 45
 call c, 35243          ;; 0C9B:  DC AB 89
 call c, 52719          ;; 0C9E:  DC EF CD
 call c, 65535          ;; 0CA1:  DC FF FF
 call po, 0             ;; 0CA4:  E4 00 00
 call po, 291           ;; 0CA7:  E4 23 01
 call po, 17767         ;; 0CAA:  E4 67 45
 call po, 35243         ;; 0CAD:  E4 AB 89
 call po, 52719         ;; 0CB0:  E4 EF CD
 call po, 65535         ;; 0CB3:  E4 FF FF
 call pe, 0             ;; 0CB6:  EC 00 00
 call pe, 291           ;; 0CB9:  EC 23 01
 call pe, 17767         ;; 0CBC:  EC 67 45
 call pe, 35243         ;; 0CBF:  EC AB 89
 call pe, 52719         ;; 0CC2:  EC EF CD
 call pe, 65535         ;; 0CC5:  EC FF FF
 call p, 0              ;; 0CC8:  F4 00 00
 call p, 291            ;; 0CCB:  F4 23 01
 call p, 17767          ;; 0CCE:  F4 67 45
 call p, 35243          ;; 0CD1:  F4 AB 89
 call p, 52719          ;; 0CD4:  F4 EF CD
 call p, 65535          ;; 0CD7:  F4 FF FF
 call m, 0              ;; 0CDA:  FC 00 00
 call m, 291            ;; 0CDD:  FC 23 01
 call m, 17767          ;; 0CE0:  FC 67 45
 call m, 35243          ;; 0CE3:  FC AB 89
 call m, 52719          ;; 0CE6:  FC EF CD
 call m, 65535          ;; 0CE9:  FC FF FF
 ret                    ;; 0CEC:  C9
 ret nz                 ;; 0CED:  C0
 ret z                  ;; 0CEE:  C8
 ret nc                 ;; 0CEF:  D0
 ret c                  ;; 0CF0:  D8
 ret po                 ;; 0CF1:  E0
 ret pe                 ;; 0CF2:  E8
 ret p                  ;; 0CF3:  F0
 ret m                  ;; 0CF4:  F8
 rst 16                 ;; 0CF5:  D7
 rst 24                 ;; 0CF6:  DF
 rst 32                 ;; 0CF7:  E7
 rst 40                 ;; 0CF8:  EF
 rst 56                 ;; 0CF9:  FF
 rst 0                  ;; 0CFA:  C7
 rst 8                  ;; 0CFB:  CF
 rst 48                 ;; 0CFC:  F7
 in a, (0)              ;; 0CFD:  DB 00
 in a, (85)             ;; 0CFF:  DB 55
 in a, (170)            ;; 0D01:  DB AA
 in a, (255)            ;; 0D03:  DB FF
 in b, (c)              ;; 0D05:  ED 40
 in c, (c)              ;; 0D07:  ED 48
 in d, (c)              ;; 0D09:  ED 50
 in e, (c)              ;; 0D0B:  ED 58
 in h, (c)              ;; 0D0D:  ED 60
 in l, (c)              ;; 0D0F:  ED 68
 in f, (c)              ;; 0D11:  ED 70
 in a, (c)              ;; 0D13:  ED 78
 in0 b, (0)             ;; 0D15:  ED 00 00
 in0 b, (85)            ;; 0D18:  ED 00 55
 in0 b, (170)           ;; 0D1B:  ED 00 AA
 in0 b, (255)           ;; 0D1E:  ED 00 FF
 in0 c, (0)             ;; 0D21:  ED 08 00
 in0 c, (85)            ;; 0D24:  ED 08 55
 in0 c, (170)           ;; 0D27:  ED 08 AA
 in0 c, (255)           ;; 0D2A:  ED 08 FF
 in0 d, (0)             ;; 0D2D:  ED 10 00
 in0 d, (85)            ;; 0D30:  ED 10 55
 in0 d, (170)           ;; 0D33:  ED 10 AA
 in0 d, (255)           ;; 0D36:  ED 10 FF
 in0 e, (0)             ;; 0D39:  ED 18 00
 in0 e, (85)            ;; 0D3C:  ED 18 55
 in0 e, (170)           ;; 0D3F:  ED 18 AA
 in0 e, (255)           ;; 0D42:  ED 18 FF
 in0 h, (0)             ;; 0D45:  ED 20 00
 in0 h, (85)            ;; 0D48:  ED 20 55
 in0 h, (170)           ;; 0D4B:  ED 20 AA
 in0 h, (255)           ;; 0D4E:  ED 20 FF
 in0 l, (0)             ;; 0D51:  ED 28 00
 in0 l, (85)            ;; 0D54:  ED 28 55
 in0 l, (170)           ;; 0D57:  ED 28 AA
 in0 l, (255)           ;; 0D5A:  ED 28 FF
 in0 f, (0)             ;; 0D5D:  ED 30 00
 in0 f, (85)            ;; 0D60:  ED 30 55
 in0 f, (170)           ;; 0D63:  ED 30 AA
 in0 f, (255)           ;; 0D66:  ED 30 FF
 in0 a, (0)             ;; 0D69:  ED 38 00
 in0 a, (85)            ;; 0D6C:  ED 38 55
 in0 a, (170)           ;; 0D6F:  ED 38 AA
 in0 a, (255)           ;; 0D72:  ED 38 FF
 out (0), a             ;; 0D75:  D3 00
 out (85), a            ;; 0D77:  D3 55
 out (170), a           ;; 0D79:  D3 AA
 out (255), a           ;; 0D7B:  D3 FF
 out (c), b             ;; 0D7D:  ED 41
 out (c), c             ;; 0D7F:  ED 49
 out (c), d             ;; 0D81:  ED 51
 out (c), e             ;; 0D83:  ED 59
 out (c), h             ;; 0D85:  ED 61
 out (c), l             ;; 0D87:  ED 69
 out (c), 0             ;; 0D89:  ED 71
 out (c), a             ;; 0D8B:  ED 79
 out0 (0), b            ;; 0D8D:  ED 01 00
 out0 (85), b           ;; 0D90:  ED 01 55
 out0 (170), b          ;; 0D93:  ED 01 AA
 out0 (255), b          ;; 0D96:  ED 01 FF
 out0 (0), c            ;; 0D99:  ED 09 00
 out0 (85), c           ;; 0D9C:  ED 09 55
 out0 (170), c          ;; 0D9F:  ED 09 AA
 out0 (255), c          ;; 0DA2:  ED 09 FF
 out0 (0), d            ;; 0DA5:  ED 11 00
 out0 (85), d           ;; 0DA8:  ED 11 55
 out0 (170), d          ;; 0DAB:  ED 11 AA
 out0 (255), d          ;; 0DAE:  ED 11 FF
 out0 (0), e            ;; 0DB1:  ED 19 00
 out0 (85), e           ;; 0DB4:  ED 19 55
 out0 (170), e          ;; 0DB7:  ED 19 AA
 out0 (255), e          ;; 0DBA:  ED 19 FF
 out0 (0), h            ;; 0DBD:  ED 21 00
 out0 (85), h           ;; 0DC0:  ED 21 55
 out0 (170), h          ;; 0DC3:  ED 21 AA
 out0 (255), h          ;; 0DC6:  ED 21 FF
 out0 (0), l            ;; 0DC9:  ED 29 00
 out0 (85), l           ;; 0DCC:  ED 29 55
 out0 (170), l          ;; 0DCF:  ED 29 AA
 out0 (255), l          ;; 0DD2:  ED 29 FF
 out0 (0), a            ;; 0DD5:  ED 39 00
 out0 (85), a           ;; 0DD8:  ED 39 55
 out0 (170), a          ;; 0DDB:  ED 39 AA
 out0 (255), a          ;; 0DDE:  ED 39 FF
 tstio 0                ;; 0DE1:  ED 74 00
 tstio 85               ;; 0DE4:  ED 74 55
 tstio 170              ;; 0DE7:  ED 74 AA
 tstio 255              ;; 0DEA:  ED 74 FF
 ini                    ;; 0DED:  ED A2
 inir                   ;; 0DEF:  ED B2
 ind                    ;; 0DF1:  ED AA
 indr                   ;; 0DF3:  ED BA
 outi                   ;; 0DF5:  ED A3
 otir                   ;; 0DF7:  ED B3
 outd                   ;; 0DF9:  ED AB
 otdr                   ;; 0DFB:  ED BB
 otdm                   ;; 0DFD:  ED 8B
 otdmr                  ;; 0DFF:  ED 9B
 otim                   ;; 0E01:  ED 83
 otimr                  ;; 0E03:  ED 93
 di                     ;; 0E05:  F3
 ei                     ;; 0E06:  FB
 im 0                   ;; 0E07:  ED 46
 im 1                   ;; 0E09:  ED 56
 im 2                   ;; 0E0B:  ED 5E
 ld i, a                ;; 0E0D:  ED 47
 ld a, i                ;; 0E0F:  ED 57
 ld r, a                ;; 0E11:  ED 4F
 ld a, r                ;; 0E13:  ED 5F
 reti                   ;; 0E15:  ED 4D
 retn                   ;; 0E17:  ED 45
