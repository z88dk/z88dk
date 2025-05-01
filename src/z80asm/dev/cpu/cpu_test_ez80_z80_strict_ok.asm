 adc a, (hl)                    ; 8E
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix+0)                  ; DD 8E 00
 adc a, (ix+126)                ; DD 8E 7E
 adc a, (ix-128)                ; DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy+0)                  ; FD 8E 00
 adc a, (iy+126)                ; FD 8E 7E
 adc a, (iy-128)                ; FD 8E 80
 adc a, -128                    ; CE 80
 adc a, 0                       ; CE 00
 adc a, 127                     ; CE 7F
 adc a, 255                     ; CE FF
 adc a, a                       ; 8F
 adc a, b                       ; 88
 adc a, c                       ; 89
 adc a, d                       ; 8A
 adc a, e                       ; 8B
 adc a, h                       ; 8C
 adc a, ixh                     ; DD 8C
 adc a, ixl                     ; DD 8D
 adc a, iyh                     ; FD 8C
 adc a, iyl                     ; FD 8D
 adc a, l                       ; 8D
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 adc.l a, (hl)                  ; 49 8E
 adc.l a, (ix)                  ; 49 DD 8E 00
 adc.l a, (ix+0)                ; 49 DD 8E 00
 adc.l a, (ix+126)              ; 49 DD 8E 7E
 adc.l a, (ix-128)              ; 49 DD 8E 80
 adc.l a, (iy)                  ; 49 FD 8E 00
 adc.l a, (iy+0)                ; 49 FD 8E 00
 adc.l a, (iy+126)              ; 49 FD 8E 7E
 adc.l a, (iy-128)              ; 49 FD 8E 80
 adc.l hl, bc                   ; 49 ED 4A
 adc.l hl, de                   ; 49 ED 5A
 adc.l hl, hl                   ; 49 ED 6A
 adc.l hl, sp                   ; 49 ED 7A
 adc.lis a, (hl)                ; 49 8E
 adc.lis a, (ix)                ; 49 DD 8E 00
 adc.lis a, (ix+0)              ; 49 DD 8E 00
 adc.lis a, (ix+126)            ; 49 DD 8E 7E
 adc.lis a, (ix-128)            ; 49 DD 8E 80
 adc.lis a, (iy)                ; 49 FD 8E 00
 adc.lis a, (iy+0)              ; 49 FD 8E 00
 adc.lis a, (iy+126)            ; 49 FD 8E 7E
 adc.lis a, (iy-128)            ; 49 FD 8E 80
 adc.lis hl, bc                 ; 49 ED 4A
 adc.lis hl, de                 ; 49 ED 5A
 adc.lis hl, hl                 ; 49 ED 6A
 adc.lis hl, sp                 ; 49 ED 7A
 add a, (hl)                    ; 86
 add a, (ix)                    ; DD 86 00
 add a, (ix+0)                  ; DD 86 00
 add a, (ix+126)                ; DD 86 7E
 add a, (ix-128)                ; DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy+0)                  ; FD 86 00
 add a, (iy+126)                ; FD 86 7E
 add a, (iy-128)                ; FD 86 80
 add a, -128                    ; C6 80
 add a, 0                       ; C6 00
 add a, 127                     ; C6 7F
 add a, 255                     ; C6 FF
 add a, a                       ; 87
 add a, b                       ; 80
 add a, c                       ; 81
 add a, d                       ; 82
 add a, e                       ; 83
 add a, h                       ; 84
 add a, ixh                     ; DD 84
 add a, ixl                     ; DD 85
 add a, iyh                     ; FD 84
 add a, iyl                     ; FD 85
 add a, l                       ; 85
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, sp                     ; 39
 add ix, bc                     ; DD 09
 add ix, de                     ; DD 19
 add ix, ix                     ; DD 29
 add ix, sp                     ; DD 39
 add iy, bc                     ; FD 09
 add iy, de                     ; FD 19
 add iy, iy                     ; FD 29
 add iy, sp                     ; FD 39
 add.l a, (hl)                  ; 49 86
 add.l a, (ix)                  ; 49 DD 86 00
 add.l a, (ix+0)                ; 49 DD 86 00
 add.l a, (ix+126)              ; 49 DD 86 7E
 add.l a, (ix-128)              ; 49 DD 86 80
 add.l a, (iy)                  ; 49 FD 86 00
 add.l a, (iy+0)                ; 49 FD 86 00
 add.l a, (iy+126)              ; 49 FD 86 7E
 add.l a, (iy-128)              ; 49 FD 86 80
 add.l hl, bc                   ; 49 09
 add.l hl, de                   ; 49 19
 add.l hl, hl                   ; 49 29
 add.l hl, sp                   ; 49 39
 add.l ix, bc                   ; 49 DD 09
 add.l ix, de                   ; 49 DD 19
 add.l ix, ix                   ; 49 DD 29
 add.l ix, sp                   ; 49 DD 39
 add.l iy, bc                   ; 49 FD 09
 add.l iy, de                   ; 49 FD 19
 add.l iy, iy                   ; 49 FD 29
 add.l iy, sp                   ; 49 FD 39
 add.lis a, (hl)                ; 49 86
 add.lis a, (ix)                ; 49 DD 86 00
 add.lis a, (ix+0)              ; 49 DD 86 00
 add.lis a, (ix+126)            ; 49 DD 86 7E
 add.lis a, (ix-128)            ; 49 DD 86 80
 add.lis a, (iy)                ; 49 FD 86 00
 add.lis a, (iy+0)              ; 49 FD 86 00
 add.lis a, (iy+126)            ; 49 FD 86 7E
 add.lis a, (iy-128)            ; 49 FD 86 80
 add.lis hl, bc                 ; 49 09
 add.lis hl, de                 ; 49 19
 add.lis hl, hl                 ; 49 29
 add.lis hl, sp                 ; 49 39
 add.lis ix, bc                 ; 49 DD 09
 add.lis ix, de                 ; 49 DD 19
 add.lis ix, ix                 ; 49 DD 29
 add.lis ix, sp                 ; 49 DD 39
 add.lis iy, bc                 ; 49 FD 09
 add.lis iy, de                 ; 49 FD 19
 add.lis iy, iy                 ; 49 FD 29
 add.lis iy, sp                 ; 49 FD 39
 and a, (hl)                    ; A6
 and a, (ix)                    ; DD A6 00
 and a, (ix+0)                  ; DD A6 00
 and a, (ix+126)                ; DD A6 7E
 and a, (ix-128)                ; DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy+0)                  ; FD A6 00
 and a, (iy+126)                ; FD A6 7E
 and a, (iy-128)                ; FD A6 80
 and a, -128                    ; E6 80
 and a, 0                       ; E6 00
 and a, 127                     ; E6 7F
 and a, 255                     ; E6 FF
 and a, a                       ; A7
 and a, b                       ; A0
 and a, c                       ; A1
 and a, d                       ; A2
 and a, e                       ; A3
 and a, h                       ; A4
 and a, ixh                     ; DD A4
 and a, ixl                     ; DD A5
 and a, iyh                     ; FD A4
 and a, iyl                     ; FD A5
 and a, l                       ; A5
 and.l a, (hl)                  ; 49 A6
 and.l a, (ix)                  ; 49 DD A6 00
 and.l a, (ix+0)                ; 49 DD A6 00
 and.l a, (ix+126)              ; 49 DD A6 7E
 and.l a, (ix-128)              ; 49 DD A6 80
 and.l a, (iy)                  ; 49 FD A6 00
 and.l a, (iy+0)                ; 49 FD A6 00
 and.l a, (iy+126)              ; 49 FD A6 7E
 and.l a, (iy-128)              ; 49 FD A6 80
 and.lis a, (hl)                ; 49 A6
 and.lis a, (ix)                ; 49 DD A6 00
 and.lis a, (ix+0)              ; 49 DD A6 00
 and.lis a, (ix+126)            ; 49 DD A6 7E
 and.lis a, (ix-128)            ; 49 DD A6 80
 and.lis a, (iy)                ; 49 FD A6 00
 and.lis a, (iy+0)              ; 49 FD A6 00
 and.lis a, (iy+126)            ; 49 FD A6 7E
 and.lis a, (iy-128)            ; 49 FD A6 80
 bit 0, (hl)                    ; CB 46
 bit 0, (ix)                    ; DD CB 00 46
 bit 0, (ix+0)                  ; DD CB 00 46
 bit 0, (ix+126)                ; DD CB 7E 46
 bit 0, (ix-128)                ; DD CB 80 46
 bit 0, (iy)                    ; FD CB 00 46
 bit 0, (iy+0)                  ; FD CB 00 46
 bit 0, (iy+126)                ; FD CB 7E 46
 bit 0, (iy-128)                ; FD CB 80 46
 bit 0, a                       ; CB 47
 bit 0, b                       ; CB 40
 bit 0, c                       ; CB 41
 bit 0, d                       ; CB 42
 bit 0, e                       ; CB 43
 bit 0, h                       ; CB 44
 bit 0, l                       ; CB 45
 bit 1, (hl)                    ; CB 4E
 bit 1, (ix)                    ; DD CB 00 4E
 bit 1, (ix+0)                  ; DD CB 00 4E
 bit 1, (ix+126)                ; DD CB 7E 4E
 bit 1, (ix-128)                ; DD CB 80 4E
 bit 1, (iy)                    ; FD CB 00 4E
 bit 1, (iy+0)                  ; FD CB 00 4E
 bit 1, (iy+126)                ; FD CB 7E 4E
 bit 1, (iy-128)                ; FD CB 80 4E
 bit 1, a                       ; CB 4F
 bit 1, b                       ; CB 48
 bit 1, c                       ; CB 49
 bit 1, d                       ; CB 4A
 bit 1, e                       ; CB 4B
 bit 1, h                       ; CB 4C
 bit 1, l                       ; CB 4D
 bit 2, (hl)                    ; CB 56
 bit 2, (ix)                    ; DD CB 00 56
 bit 2, (ix+0)                  ; DD CB 00 56
 bit 2, (ix+126)                ; DD CB 7E 56
 bit 2, (ix-128)                ; DD CB 80 56
 bit 2, (iy)                    ; FD CB 00 56
 bit 2, (iy+0)                  ; FD CB 00 56
 bit 2, (iy+126)                ; FD CB 7E 56
 bit 2, (iy-128)                ; FD CB 80 56
 bit 2, a                       ; CB 57
 bit 2, b                       ; CB 50
 bit 2, c                       ; CB 51
 bit 2, d                       ; CB 52
 bit 2, e                       ; CB 53
 bit 2, h                       ; CB 54
 bit 2, l                       ; CB 55
 bit 3, (hl)                    ; CB 5E
 bit 3, (ix)                    ; DD CB 00 5E
 bit 3, (ix+0)                  ; DD CB 00 5E
 bit 3, (ix+126)                ; DD CB 7E 5E
 bit 3, (ix-128)                ; DD CB 80 5E
 bit 3, (iy)                    ; FD CB 00 5E
 bit 3, (iy+0)                  ; FD CB 00 5E
 bit 3, (iy+126)                ; FD CB 7E 5E
 bit 3, (iy-128)                ; FD CB 80 5E
 bit 3, a                       ; CB 5F
 bit 3, b                       ; CB 58
 bit 3, c                       ; CB 59
 bit 3, d                       ; CB 5A
 bit 3, e                       ; CB 5B
 bit 3, h                       ; CB 5C
 bit 3, l                       ; CB 5D
 bit 4, (hl)                    ; CB 66
 bit 4, (ix)                    ; DD CB 00 66
 bit 4, (ix+0)                  ; DD CB 00 66
 bit 4, (ix+126)                ; DD CB 7E 66
 bit 4, (ix-128)                ; DD CB 80 66
 bit 4, (iy)                    ; FD CB 00 66
 bit 4, (iy+0)                  ; FD CB 00 66
 bit 4, (iy+126)                ; FD CB 7E 66
 bit 4, (iy-128)                ; FD CB 80 66
 bit 4, a                       ; CB 67
 bit 4, b                       ; CB 60
 bit 4, c                       ; CB 61
 bit 4, d                       ; CB 62
 bit 4, e                       ; CB 63
 bit 4, h                       ; CB 64
 bit 4, l                       ; CB 65
 bit 5, (hl)                    ; CB 6E
 bit 5, (ix)                    ; DD CB 00 6E
 bit 5, (ix+0)                  ; DD CB 00 6E
 bit 5, (ix+126)                ; DD CB 7E 6E
 bit 5, (ix-128)                ; DD CB 80 6E
 bit 5, (iy)                    ; FD CB 00 6E
 bit 5, (iy+0)                  ; FD CB 00 6E
 bit 5, (iy+126)                ; FD CB 7E 6E
 bit 5, (iy-128)                ; FD CB 80 6E
 bit 5, a                       ; CB 6F
 bit 5, b                       ; CB 68
 bit 5, c                       ; CB 69
 bit 5, d                       ; CB 6A
 bit 5, e                       ; CB 6B
 bit 5, h                       ; CB 6C
 bit 5, l                       ; CB 6D
 bit 6, (hl)                    ; CB 76
 bit 6, (ix)                    ; DD CB 00 76
 bit 6, (ix+0)                  ; DD CB 00 76
 bit 6, (ix+126)                ; DD CB 7E 76
 bit 6, (ix-128)                ; DD CB 80 76
 bit 6, (iy)                    ; FD CB 00 76
 bit 6, (iy+0)                  ; FD CB 00 76
 bit 6, (iy+126)                ; FD CB 7E 76
 bit 6, (iy-128)                ; FD CB 80 76
 bit 6, a                       ; CB 77
 bit 6, b                       ; CB 70
 bit 6, c                       ; CB 71
 bit 6, d                       ; CB 72
 bit 6, e                       ; CB 73
 bit 6, h                       ; CB 74
 bit 6, l                       ; CB 75
 bit 7, (hl)                    ; CB 7E
 bit 7, (ix)                    ; DD CB 00 7E
 bit 7, (ix+0)                  ; DD CB 00 7E
 bit 7, (ix+126)                ; DD CB 7E 7E
 bit 7, (ix-128)                ; DD CB 80 7E
 bit 7, (iy)                    ; FD CB 00 7E
 bit 7, (iy+0)                  ; FD CB 00 7E
 bit 7, (iy+126)                ; FD CB 7E 7E
 bit 7, (iy-128)                ; FD CB 80 7E
 bit 7, a                       ; CB 7F
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, l                       ; CB 7D
 bit.l 0, (hl)                  ; 49 CB 46
 bit.l 0, (ix)                  ; 49 DD CB 00 46
 bit.l 0, (ix+0)                ; 49 DD CB 00 46
 bit.l 0, (ix+126)              ; 49 DD CB 7E 46
 bit.l 0, (ix-128)              ; 49 DD CB 80 46
 bit.l 0, (iy)                  ; 49 FD CB 00 46
 bit.l 0, (iy+0)                ; 49 FD CB 00 46
 bit.l 0, (iy+126)              ; 49 FD CB 7E 46
 bit.l 0, (iy-128)              ; 49 FD CB 80 46
 bit.l 1, (hl)                  ; 49 CB 4E
 bit.l 1, (ix)                  ; 49 DD CB 00 4E
 bit.l 1, (ix+0)                ; 49 DD CB 00 4E
 bit.l 1, (ix+126)              ; 49 DD CB 7E 4E
 bit.l 1, (ix-128)              ; 49 DD CB 80 4E
 bit.l 1, (iy)                  ; 49 FD CB 00 4E
 bit.l 1, (iy+0)                ; 49 FD CB 00 4E
 bit.l 1, (iy+126)              ; 49 FD CB 7E 4E
 bit.l 1, (iy-128)              ; 49 FD CB 80 4E
 bit.l 2, (hl)                  ; 49 CB 56
 bit.l 2, (ix)                  ; 49 DD CB 00 56
 bit.l 2, (ix+0)                ; 49 DD CB 00 56
 bit.l 2, (ix+126)              ; 49 DD CB 7E 56
 bit.l 2, (ix-128)              ; 49 DD CB 80 56
 bit.l 2, (iy)                  ; 49 FD CB 00 56
 bit.l 2, (iy+0)                ; 49 FD CB 00 56
 bit.l 2, (iy+126)              ; 49 FD CB 7E 56
 bit.l 2, (iy-128)              ; 49 FD CB 80 56
 bit.l 3, (hl)                  ; 49 CB 5E
 bit.l 3, (ix)                  ; 49 DD CB 00 5E
 bit.l 3, (ix+0)                ; 49 DD CB 00 5E
 bit.l 3, (ix+126)              ; 49 DD CB 7E 5E
 bit.l 3, (ix-128)              ; 49 DD CB 80 5E
 bit.l 3, (iy)                  ; 49 FD CB 00 5E
 bit.l 3, (iy+0)                ; 49 FD CB 00 5E
 bit.l 3, (iy+126)              ; 49 FD CB 7E 5E
 bit.l 3, (iy-128)              ; 49 FD CB 80 5E
 bit.l 4, (hl)                  ; 49 CB 66
 bit.l 4, (ix)                  ; 49 DD CB 00 66
 bit.l 4, (ix+0)                ; 49 DD CB 00 66
 bit.l 4, (ix+126)              ; 49 DD CB 7E 66
 bit.l 4, (ix-128)              ; 49 DD CB 80 66
 bit.l 4, (iy)                  ; 49 FD CB 00 66
 bit.l 4, (iy+0)                ; 49 FD CB 00 66
 bit.l 4, (iy+126)              ; 49 FD CB 7E 66
 bit.l 4, (iy-128)              ; 49 FD CB 80 66
 bit.l 5, (hl)                  ; 49 CB 6E
 bit.l 5, (ix)                  ; 49 DD CB 00 6E
 bit.l 5, (ix+0)                ; 49 DD CB 00 6E
 bit.l 5, (ix+126)              ; 49 DD CB 7E 6E
 bit.l 5, (ix-128)              ; 49 DD CB 80 6E
 bit.l 5, (iy)                  ; 49 FD CB 00 6E
 bit.l 5, (iy+0)                ; 49 FD CB 00 6E
 bit.l 5, (iy+126)              ; 49 FD CB 7E 6E
 bit.l 5, (iy-128)              ; 49 FD CB 80 6E
 bit.l 6, (hl)                  ; 49 CB 76
 bit.l 6, (ix)                  ; 49 DD CB 00 76
 bit.l 6, (ix+0)                ; 49 DD CB 00 76
 bit.l 6, (ix+126)              ; 49 DD CB 7E 76
 bit.l 6, (ix-128)              ; 49 DD CB 80 76
 bit.l 6, (iy)                  ; 49 FD CB 00 76
 bit.l 6, (iy+0)                ; 49 FD CB 00 76
 bit.l 6, (iy+126)              ; 49 FD CB 7E 76
 bit.l 6, (iy-128)              ; 49 FD CB 80 76
 bit.l 7, (hl)                  ; 49 CB 7E
 bit.l 7, (ix)                  ; 49 DD CB 00 7E
 bit.l 7, (ix+0)                ; 49 DD CB 00 7E
 bit.l 7, (ix+126)              ; 49 DD CB 7E 7E
 bit.l 7, (ix-128)              ; 49 DD CB 80 7E
 bit.l 7, (iy)                  ; 49 FD CB 00 7E
 bit.l 7, (iy+0)                ; 49 FD CB 00 7E
 bit.l 7, (iy+126)              ; 49 FD CB 7E 7E
 bit.l 7, (iy-128)              ; 49 FD CB 80 7E
 bit.lis 0, (hl)                ; 49 CB 46
 bit.lis 0, (ix)                ; 49 DD CB 00 46
 bit.lis 0, (ix+0)              ; 49 DD CB 00 46
 bit.lis 0, (ix+126)            ; 49 DD CB 7E 46
 bit.lis 0, (ix-128)            ; 49 DD CB 80 46
 bit.lis 0, (iy)                ; 49 FD CB 00 46
 bit.lis 0, (iy+0)              ; 49 FD CB 00 46
 bit.lis 0, (iy+126)            ; 49 FD CB 7E 46
 bit.lis 0, (iy-128)            ; 49 FD CB 80 46
 bit.lis 1, (hl)                ; 49 CB 4E
 bit.lis 1, (ix)                ; 49 DD CB 00 4E
 bit.lis 1, (ix+0)              ; 49 DD CB 00 4E
 bit.lis 1, (ix+126)            ; 49 DD CB 7E 4E
 bit.lis 1, (ix-128)            ; 49 DD CB 80 4E
 bit.lis 1, (iy)                ; 49 FD CB 00 4E
 bit.lis 1, (iy+0)              ; 49 FD CB 00 4E
 bit.lis 1, (iy+126)            ; 49 FD CB 7E 4E
 bit.lis 1, (iy-128)            ; 49 FD CB 80 4E
 bit.lis 2, (hl)                ; 49 CB 56
 bit.lis 2, (ix)                ; 49 DD CB 00 56
 bit.lis 2, (ix+0)              ; 49 DD CB 00 56
 bit.lis 2, (ix+126)            ; 49 DD CB 7E 56
 bit.lis 2, (ix-128)            ; 49 DD CB 80 56
 bit.lis 2, (iy)                ; 49 FD CB 00 56
 bit.lis 2, (iy+0)              ; 49 FD CB 00 56
 bit.lis 2, (iy+126)            ; 49 FD CB 7E 56
 bit.lis 2, (iy-128)            ; 49 FD CB 80 56
 bit.lis 3, (hl)                ; 49 CB 5E
 bit.lis 3, (ix)                ; 49 DD CB 00 5E
 bit.lis 3, (ix+0)              ; 49 DD CB 00 5E
 bit.lis 3, (ix+126)            ; 49 DD CB 7E 5E
 bit.lis 3, (ix-128)            ; 49 DD CB 80 5E
 bit.lis 3, (iy)                ; 49 FD CB 00 5E
 bit.lis 3, (iy+0)              ; 49 FD CB 00 5E
 bit.lis 3, (iy+126)            ; 49 FD CB 7E 5E
 bit.lis 3, (iy-128)            ; 49 FD CB 80 5E
 bit.lis 4, (hl)                ; 49 CB 66
 bit.lis 4, (ix)                ; 49 DD CB 00 66
 bit.lis 4, (ix+0)              ; 49 DD CB 00 66
 bit.lis 4, (ix+126)            ; 49 DD CB 7E 66
 bit.lis 4, (ix-128)            ; 49 DD CB 80 66
 bit.lis 4, (iy)                ; 49 FD CB 00 66
 bit.lis 4, (iy+0)              ; 49 FD CB 00 66
 bit.lis 4, (iy+126)            ; 49 FD CB 7E 66
 bit.lis 4, (iy-128)            ; 49 FD CB 80 66
 bit.lis 5, (hl)                ; 49 CB 6E
 bit.lis 5, (ix)                ; 49 DD CB 00 6E
 bit.lis 5, (ix+0)              ; 49 DD CB 00 6E
 bit.lis 5, (ix+126)            ; 49 DD CB 7E 6E
 bit.lis 5, (ix-128)            ; 49 DD CB 80 6E
 bit.lis 5, (iy)                ; 49 FD CB 00 6E
 bit.lis 5, (iy+0)              ; 49 FD CB 00 6E
 bit.lis 5, (iy+126)            ; 49 FD CB 7E 6E
 bit.lis 5, (iy-128)            ; 49 FD CB 80 6E
 bit.lis 6, (hl)                ; 49 CB 76
 bit.lis 6, (ix)                ; 49 DD CB 00 76
 bit.lis 6, (ix+0)              ; 49 DD CB 00 76
 bit.lis 6, (ix+126)            ; 49 DD CB 7E 76
 bit.lis 6, (ix-128)            ; 49 DD CB 80 76
 bit.lis 6, (iy)                ; 49 FD CB 00 76
 bit.lis 6, (iy+0)              ; 49 FD CB 00 76
 bit.lis 6, (iy+126)            ; 49 FD CB 7E 76
 bit.lis 6, (iy-128)            ; 49 FD CB 80 76
 bit.lis 7, (hl)                ; 49 CB 7E
 bit.lis 7, (ix)                ; 49 DD CB 00 7E
 bit.lis 7, (ix+0)              ; 49 DD CB 00 7E
 bit.lis 7, (ix+126)            ; 49 DD CB 7E 7E
 bit.lis 7, (ix-128)            ; 49 DD CB 80 7E
 bit.lis 7, (iy)                ; 49 FD CB 00 7E
 bit.lis 7, (iy+0)              ; 49 FD CB 00 7E
 bit.lis 7, (iy+126)            ; 49 FD CB 7E 7E
 bit.lis 7, (iy-128)            ; 49 FD CB 80 7E
 call 0x1234                    ; CD 34 12
 call c, 0x1234                 ; DC 34 12
 call m, 0x1234                 ; FC 34 12
 call nc, 0x1234                ; D4 34 12
 call nz, 0x1234                ; C4 34 12
 call p, 0x1234                 ; F4 34 12
 call pe, 0x1234                ; EC 34 12
 call po, 0x1234                ; E4 34 12
 call z, 0x1234                 ; CC 34 12
 call.il 0x123456               ; 52 CD 56 34 12
 call.il c, 0x123456            ; 52 DC 56 34 12
 call.il m, 0x123456            ; 52 FC 56 34 12
 call.il nc, 0x123456           ; 52 D4 56 34 12
 call.il nz, 0x123456           ; 52 C4 56 34 12
 call.il p, 0x123456            ; 52 F4 56 34 12
 call.il pe, 0x123456           ; 52 EC 56 34 12
 call.il po, 0x123456           ; 52 E4 56 34 12
 call.il z, 0x123456            ; 52 CC 56 34 12
 call.is 0x1234                 ; 40 CD 34 12
 call.is c, 0x1234              ; 40 DC 34 12
 call.is m, 0x1234              ; 40 FC 34 12
 call.is nc, 0x1234             ; 40 D4 34 12
 call.is nz, 0x1234             ; 40 C4 34 12
 call.is p, 0x1234              ; 40 F4 34 12
 call.is pe, 0x1234             ; 40 EC 34 12
 call.is po, 0x1234             ; 40 E4 34 12
 call.is z, 0x1234              ; 40 CC 34 12
 call.sil 0x123456              ; 52 CD 56 34 12
 call.sil c, 0x123456           ; 52 DC 56 34 12
 call.sil m, 0x123456           ; 52 FC 56 34 12
 call.sil nc, 0x123456          ; 52 D4 56 34 12
 call.sil nz, 0x123456          ; 52 C4 56 34 12
 call.sil p, 0x123456           ; 52 F4 56 34 12
 call.sil pe, 0x123456          ; 52 EC 56 34 12
 call.sil po, 0x123456          ; 52 E4 56 34 12
 call.sil z, 0x123456           ; 52 CC 56 34 12
 call.sis 0x1234                ; 40 CD 34 12
 call.sis c, 0x1234             ; 40 DC 34 12
 call.sis m, 0x1234             ; 40 FC 34 12
 call.sis nc, 0x1234            ; 40 D4 34 12
 call.sis nz, 0x1234            ; 40 C4 34 12
 call.sis p, 0x1234             ; 40 F4 34 12
 call.sis pe, 0x1234            ; 40 EC 34 12
 call.sis po, 0x1234            ; 40 E4 34 12
 call.sis z, 0x1234             ; 40 CC 34 12
 ccf                            ; 3F
 cp a, (hl)                     ; BE
 cp a, (ix)                     ; DD BE 00
 cp a, (ix+0)                   ; DD BE 00
 cp a, (ix+126)                 ; DD BE 7E
 cp a, (ix-128)                 ; DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy+0)                   ; FD BE 00
 cp a, (iy+126)                 ; FD BE 7E
 cp a, (iy-128)                 ; FD BE 80
 cp a, -128                     ; FE 80
 cp a, 0                        ; FE 00
 cp a, 127                      ; FE 7F
 cp a, 255                      ; FE FF
 cp a, a                        ; BF
 cp a, b                        ; B8
 cp a, c                        ; B9
 cp a, d                        ; BA
 cp a, e                        ; BB
 cp a, h                        ; BC
 cp a, ixh                      ; DD BC
 cp a, ixl                      ; DD BD
 cp a, iyh                      ; FD BC
 cp a, iyl                      ; FD BD
 cp a, l                        ; BD
 cp.l a, (hl)                   ; 49 BE
 cp.l a, (ix)                   ; 49 DD BE 00
 cp.l a, (ix+0)                 ; 49 DD BE 00
 cp.l a, (ix+126)               ; 49 DD BE 7E
 cp.l a, (ix-128)               ; 49 DD BE 80
 cp.l a, (iy)                   ; 49 FD BE 00
 cp.l a, (iy+0)                 ; 49 FD BE 00
 cp.l a, (iy+126)               ; 49 FD BE 7E
 cp.l a, (iy-128)               ; 49 FD BE 80
 cp.lis a, (hl)                 ; 49 BE
 cp.lis a, (ix)                 ; 49 DD BE 00
 cp.lis a, (ix+0)               ; 49 DD BE 00
 cp.lis a, (ix+126)             ; 49 DD BE 7E
 cp.lis a, (ix-128)             ; 49 DD BE 80
 cp.lis a, (iy)                 ; 49 FD BE 00
 cp.lis a, (iy+0)               ; 49 FD BE 00
 cp.lis a, (iy+126)             ; 49 FD BE 7E
 cp.lis a, (iy-128)             ; 49 FD BE 80
 cpd                            ; ED A9
 cpd.l                          ; 49 ED A9
 cpd.lis                        ; 49 ED A9
 cpdr                           ; ED B9
 cpdr.l                         ; 49 ED B9
 cpdr.lis                       ; 49 ED B9
 cpi                            ; ED A1
 cpi.l                          ; 49 ED A1
 cpi.lis                        ; 49 ED A1
 cpir                           ; ED B1
 cpir.l                         ; 49 ED B1
 cpir.lis                       ; 49 ED B1
 cpl                            ; 2F
 daa                            ; 27
 dec (hl)                       ; 35
 dec (ix)                       ; DD 35 00
 dec (ix+0)                     ; DD 35 00
 dec (ix+126)                   ; DD 35 7E
 dec (ix-128)                   ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy+0)                     ; FD 35 00
 dec (iy+126)                   ; FD 35 7E
 dec (iy-128)                   ; FD 35 80
 dec a                          ; 3D
 dec b                          ; 05
 dec bc                         ; 0B
 dec c                          ; 0D
 dec d                          ; 15
 dec de                         ; 1B
 dec e                          ; 1D
 dec h                          ; 25
 dec hl                         ; 2B
 dec ix                         ; DD 2B
 dec ixh                        ; DD 25
 dec ixl                        ; DD 2D
 dec iy                         ; FD 2B
 dec iyh                        ; FD 25
 dec iyl                        ; FD 2D
 dec l                          ; 2D
 dec sp                         ; 3B
 dec.l (hl)                     ; 49 35
 dec.l (ix)                     ; 49 DD 35 00
 dec.l (ix+0)                   ; 49 DD 35 00
 dec.l (ix+126)                 ; 49 DD 35 7E
 dec.l (ix-128)                 ; 49 DD 35 80
 dec.l (iy)                     ; 49 FD 35 00
 dec.l (iy+0)                   ; 49 FD 35 00
 dec.l (iy+126)                 ; 49 FD 35 7E
 dec.l (iy-128)                 ; 49 FD 35 80
 dec.l bc                       ; 49 0B
 dec.l de                       ; 49 1B
 dec.l hl                       ; 49 2B
 dec.l ix                       ; 49 DD 2B
 dec.l iy                       ; 49 FD 2B
 dec.l sp                       ; 49 3B
 dec.lis (hl)                   ; 49 35
 dec.lis (ix)                   ; 49 DD 35 00
 dec.lis (ix+0)                 ; 49 DD 35 00
 dec.lis (ix+126)               ; 49 DD 35 7E
 dec.lis (ix-128)               ; 49 DD 35 80
 dec.lis (iy)                   ; 49 FD 35 00
 dec.lis (iy+0)                 ; 49 FD 35 00
 dec.lis (iy+126)               ; 49 FD 35 7E
 dec.lis (iy-128)               ; 49 FD 35 80
 dec.lis bc                     ; 49 0B
 dec.lis de                     ; 49 1B
 dec.lis hl                     ; 49 2B
 dec.lis ix                     ; 49 DD 2B
 dec.lis iy                     ; 49 FD 2B
 dec.lis sp                     ; 49 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; DD E3
 ex (sp), iy                    ; FD E3
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 ex.l (sp), hl                  ; 49 E3
 ex.l (sp), ix                  ; 49 DD E3
 ex.l (sp), iy                  ; 49 FD E3
 ex.lis (sp), hl                ; 49 E3
 ex.lis (sp), ix                ; 49 DD E3
 ex.lis (sp), iy                ; 49 FD E3
 exx                            ; D9
 halt                           ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in a, (-128)                   ; DB 80
 in a, (0)                      ; DB 00
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
 in a, (bc)                     ; ED 78
 in b, (bc)                     ; ED 40
 in c, (bc)                     ; ED 48
 in d, (bc)                     ; ED 50
 in e, (bc)                     ; ED 58
 in h, (bc)                     ; ED 60
 in l, (bc)                     ; ED 68
 in0 a, (-128)                  ; ED 38 80
 in0 a, (0)                     ; ED 38 00
 in0 a, (127)                   ; ED 38 7F
 in0 a, (255)                   ; ED 38 FF
 in0 b, (-128)                  ; ED 00 80
 in0 b, (0)                     ; ED 00 00
 in0 b, (127)                   ; ED 00 7F
 in0 b, (255)                   ; ED 00 FF
 in0 c, (-128)                  ; ED 08 80
 in0 c, (0)                     ; ED 08 00
 in0 c, (127)                   ; ED 08 7F
 in0 c, (255)                   ; ED 08 FF
 in0 d, (-128)                  ; ED 10 80
 in0 d, (0)                     ; ED 10 00
 in0 d, (127)                   ; ED 10 7F
 in0 d, (255)                   ; ED 10 FF
 in0 e, (-128)                  ; ED 18 80
 in0 e, (0)                     ; ED 18 00
 in0 e, (127)                   ; ED 18 7F
 in0 e, (255)                   ; ED 18 FF
 in0 h, (-128)                  ; ED 20 80
 in0 h, (0)                     ; ED 20 00
 in0 h, (127)                   ; ED 20 7F
 in0 h, (255)                   ; ED 20 FF
 in0 l, (-128)                  ; ED 28 80
 in0 l, (0)                     ; ED 28 00
 in0 l, (127)                   ; ED 28 7F
 in0 l, (255)                   ; ED 28 FF
 inc (hl)                       ; 34
 inc (ix)                       ; DD 34 00
 inc (ix+0)                     ; DD 34 00
 inc (ix+126)                   ; DD 34 7E
 inc (ix-128)                   ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy+0)                     ; FD 34 00
 inc (iy+126)                   ; FD 34 7E
 inc (iy-128)                   ; FD 34 80
 inc a                          ; 3C
 inc b                          ; 04
 inc bc                         ; 03
 inc c                          ; 0C
 inc d                          ; 14
 inc de                         ; 13
 inc e                          ; 1C
 inc h                          ; 24
 inc hl                         ; 23
 inc ix                         ; DD 23
 inc ixh                        ; DD 24
 inc ixl                        ; DD 2C
 inc iy                         ; FD 23
 inc iyh                        ; FD 24
 inc iyl                        ; FD 2C
 inc l                          ; 2C
 inc sp                         ; 33
 inc.l (hl)                     ; 49 34
 inc.l (ix)                     ; 49 DD 34 00
 inc.l (ix+0)                   ; 49 DD 34 00
 inc.l (ix+126)                 ; 49 DD 34 7E
 inc.l (ix-128)                 ; 49 DD 34 80
 inc.l (iy)                     ; 49 FD 34 00
 inc.l (iy+0)                   ; 49 FD 34 00
 inc.l (iy+126)                 ; 49 FD 34 7E
 inc.l (iy-128)                 ; 49 FD 34 80
 inc.l bc                       ; 49 03
 inc.l de                       ; 49 13
 inc.l hl                       ; 49 23
 inc.l ix                       ; 49 DD 23
 inc.l iy                       ; 49 FD 23
 inc.l sp                       ; 49 33
 inc.lis (hl)                   ; 49 34
 inc.lis (ix)                   ; 49 DD 34 00
 inc.lis (ix+0)                 ; 49 DD 34 00
 inc.lis (ix+126)               ; 49 DD 34 7E
 inc.lis (ix-128)               ; 49 DD 34 80
 inc.lis (iy)                   ; 49 FD 34 00
 inc.lis (iy+0)                 ; 49 FD 34 00
 inc.lis (iy+126)               ; 49 FD 34 7E
 inc.lis (iy-128)               ; 49 FD 34 80
 inc.lis bc                     ; 49 03
 inc.lis de                     ; 49 13
 inc.lis hl                     ; 49 23
 inc.lis ix                     ; 49 DD 23
 inc.lis iy                     ; 49 FD 23
 inc.lis sp                     ; 49 33
 ind                            ; ED AA
 ind.l                          ; 49 ED AA
 ind.lis                        ; 49 ED AA
 ind2                           ; ED 8C
 ind2.l                         ; 49 ED 8C
 ind2.lis                       ; 49 ED 8C
 ind2r                          ; ED 9C
 ind2r.l                        ; 49 ED 9C
 ind2r.lis                      ; 49 ED 9C
 indm                           ; ED 8A
 indm.l                         ; 49 ED 8A
 indm.lis                       ; 49 ED 8A
 indmr                          ; ED 9A
 indmr.l                        ; 49 ED 9A
 indmr.lis                      ; 49 ED 9A
 indr                           ; ED BA
 indr.l                         ; 49 ED BA
 indr.lis                       ; 49 ED BA
 indrx                          ; ED CA
 indrx.l                        ; 49 ED CA
 indrx.lis                      ; 49 ED CA
 ini                            ; ED A2
 ini.l                          ; 49 ED A2
 ini.lis                        ; 49 ED A2
 ini2                           ; ED 84
 ini2.l                         ; 49 ED 84
 ini2.lis                       ; 49 ED 84
 ini2r                          ; ED 94
 ini2r.l                        ; 49 ED 94
 ini2r.lis                      ; 49 ED 94
 inim                           ; ED 82
 inim.l                         ; 49 ED 82
 inim.lis                       ; 49 ED 82
 inimr                          ; ED 92
 inimr.l                        ; 49 ED 92
 inimr.lis                      ; 49 ED 92
 inir                           ; ED B2
 inir.l                         ; 49 ED B2
 inir.lis                       ; 49 ED B2
 inirx                          ; ED C2
 inirx.l                        ; 49 ED C2
 inirx.lis                      ; 49 ED C2
 jp (hl)                        ; E9
 jp (ix)                        ; DD E9
 jp (iy)                        ; FD E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp m, 0x1234                   ; FA 34 12
 jp nc, 0x1234                  ; D2 34 12
 jp nz, 0x1234                  ; C2 34 12
 jp p, 0x1234                   ; F2 34 12
 jp pe, 0x1234                  ; EA 34 12
 jp po, 0x1234                  ; E2 34 12
 jp z, 0x1234                   ; CA 34 12
 jp.l (hl)                      ; 49 E9
 jp.l (ix)                      ; 49 DD E9
 jp.l (iy)                      ; 49 FD E9
 jp.lil 0x123456                ; 5B C3 56 34 12
 jp.lil c, 0x123456             ; 5B DA 56 34 12
 jp.lil m, 0x123456             ; 5B FA 56 34 12
 jp.lil nc, 0x123456            ; 5B D2 56 34 12
 jp.lil nz, 0x123456            ; 5B C2 56 34 12
 jp.lil p, 0x123456             ; 5B F2 56 34 12
 jp.lil pe, 0x123456            ; 5B EA 56 34 12
 jp.lil po, 0x123456            ; 5B E2 56 34 12
 jp.lil z, 0x123456             ; 5B CA 56 34 12
 jp.lis (hl)                    ; 49 E9
 jp.lis (ix)                    ; 49 DD E9
 jp.lis (iy)                    ; 49 FD E9
 jp.sis 0x1234                  ; 40 C3 34 12
 jp.sis c, 0x1234               ; 40 DA 34 12
 jp.sis m, 0x1234               ; 40 FA 34 12
 jp.sis nc, 0x1234              ; 40 D2 34 12
 jp.sis nz, 0x1234              ; 40 C2 34 12
 jp.sis p, 0x1234               ; 40 F2 34 12
 jp.sis pe, 0x1234              ; 40 EA 34 12
 jp.sis po, 0x1234              ; 40 E2 34 12
 jp.sis z, 0x1234               ; 40 CA 34 12
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; ED 43 34 12
 ld (0x1234), de                ; ED 53 34 12
 ld (0x1234), hl                ; 22 34 12
 ld (0x1234), ix                ; DD 22 34 12
 ld (0x1234), iy                ; FD 22 34 12
 ld (0x1234), sp                ; ED 73 34 12
 ld (bc), a                     ; 02
 ld (de), a                     ; 12
 ld (hl), -128                  ; 36 80
 ld (hl), 0                     ; 36 00
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), b                     ; 70
 ld (hl), bc                    ; ED 0F
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), de                    ; ED 1F
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), hl                    ; ED 2F
 ld (hl), ix                    ; ED 3F
 ld (hl), iy                    ; ED 3E
 ld (hl), l                     ; 75
 ld (ix), -128                  ; DD 36 00 80
 ld (ix), 0                     ; DD 36 00 00
 ld (ix), 127                   ; DD 36 00 7F
 ld (ix), 255                   ; DD 36 00 FF
 ld (ix), a                     ; DD 77 00
 ld (ix), b                     ; DD 70 00
 ld (ix), bc                    ; DD 0F 00
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), de                    ; DD 1F 00
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), hl                    ; DD 2F 00
 ld (ix), ix                    ; DD 3F 00
 ld (ix), iy                    ; DD 3E 00
 ld (ix), l                     ; DD 75 00
 ld (ix+0), -128                ; DD 36 00 80
 ld (ix+0), 0                   ; DD 36 00 00
 ld (ix+0), 127                 ; DD 36 00 7F
 ld (ix+0), 255                 ; DD 36 00 FF
 ld (ix+0), a                   ; DD 77 00
 ld (ix+0), b                   ; DD 70 00
 ld (ix+0), bc                  ; DD 0F 00
 ld (ix+0), c                   ; DD 71 00
 ld (ix+0), d                   ; DD 72 00
 ld (ix+0), de                  ; DD 1F 00
 ld (ix+0), e                   ; DD 73 00
 ld (ix+0), h                   ; DD 74 00
 ld (ix+0), hl                  ; DD 2F 00
 ld (ix+0), ix                  ; DD 3F 00
 ld (ix+0), iy                  ; DD 3E 00
 ld (ix+0), l                   ; DD 75 00
 ld (ix+126), -128              ; DD 36 7E 80
 ld (ix+126), 0                 ; DD 36 7E 00
 ld (ix+126), 127               ; DD 36 7E 7F
 ld (ix+126), 255               ; DD 36 7E FF
 ld (ix+126), a                 ; DD 77 7E
 ld (ix+126), b                 ; DD 70 7E
 ld (ix+126), bc                ; DD 0F 7E
 ld (ix+126), c                 ; DD 71 7E
 ld (ix+126), d                 ; DD 72 7E
 ld (ix+126), de                ; DD 1F 7E
 ld (ix+126), e                 ; DD 73 7E
 ld (ix+126), h                 ; DD 74 7E
 ld (ix+126), hl                ; DD 2F 7E
 ld (ix+126), ix                ; DD 3F 7E
 ld (ix+126), iy                ; DD 3E 7E
 ld (ix+126), l                 ; DD 75 7E
 ld (ix-128), -128              ; DD 36 80 80
 ld (ix-128), 0                 ; DD 36 80 00
 ld (ix-128), 127               ; DD 36 80 7F
 ld (ix-128), 255               ; DD 36 80 FF
 ld (ix-128), a                 ; DD 77 80
 ld (ix-128), b                 ; DD 70 80
 ld (ix-128), bc                ; DD 0F 80
 ld (ix-128), c                 ; DD 71 80
 ld (ix-128), d                 ; DD 72 80
 ld (ix-128), de                ; DD 1F 80
 ld (ix-128), e                 ; DD 73 80
 ld (ix-128), h                 ; DD 74 80
 ld (ix-128), hl                ; DD 2F 80
 ld (ix-128), ix                ; DD 3F 80
 ld (ix-128), iy                ; DD 3E 80
 ld (ix-128), l                 ; DD 75 80
 ld (iy), -128                  ; FD 36 00 80
 ld (iy), 0                     ; FD 36 00 00
 ld (iy), 127                   ; FD 36 00 7F
 ld (iy), 255                   ; FD 36 00 FF
 ld (iy), a                     ; FD 77 00
 ld (iy), b                     ; FD 70 00
 ld (iy), bc                    ; FD 0F 00
 ld (iy), c                     ; FD 71 00
 ld (iy), d                     ; FD 72 00
 ld (iy), de                    ; FD 1F 00
 ld (iy), e                     ; FD 73 00
 ld (iy), h                     ; FD 74 00
 ld (iy), hl                    ; FD 2F 00
 ld (iy), ix                    ; FD 3E 00
 ld (iy), iy                    ; FD 3F 00
 ld (iy), l                     ; FD 75 00
 ld (iy+0), -128                ; FD 36 00 80
 ld (iy+0), 0                   ; FD 36 00 00
 ld (iy+0), 127                 ; FD 36 00 7F
 ld (iy+0), 255                 ; FD 36 00 FF
 ld (iy+0), a                   ; FD 77 00
 ld (iy+0), b                   ; FD 70 00
 ld (iy+0), bc                  ; FD 0F 00
 ld (iy+0), c                   ; FD 71 00
 ld (iy+0), d                   ; FD 72 00
 ld (iy+0), de                  ; FD 1F 00
 ld (iy+0), e                   ; FD 73 00
 ld (iy+0), h                   ; FD 74 00
 ld (iy+0), hl                  ; FD 2F 00
 ld (iy+0), ix                  ; FD 3E 00
 ld (iy+0), iy                  ; FD 3F 00
 ld (iy+0), l                   ; FD 75 00
 ld (iy+126), -128              ; FD 36 7E 80
 ld (iy+126), 0                 ; FD 36 7E 00
 ld (iy+126), 127               ; FD 36 7E 7F
 ld (iy+126), 255               ; FD 36 7E FF
 ld (iy+126), a                 ; FD 77 7E
 ld (iy+126), b                 ; FD 70 7E
 ld (iy+126), bc                ; FD 0F 7E
 ld (iy+126), c                 ; FD 71 7E
 ld (iy+126), d                 ; FD 72 7E
 ld (iy+126), de                ; FD 1F 7E
 ld (iy+126), e                 ; FD 73 7E
 ld (iy+126), h                 ; FD 74 7E
 ld (iy+126), hl                ; FD 2F 7E
 ld (iy+126), ix                ; FD 3E 7E
 ld (iy+126), iy                ; FD 3F 7E
 ld (iy+126), l                 ; FD 75 7E
 ld (iy-128), -128              ; FD 36 80 80
 ld (iy-128), 0                 ; FD 36 80 00
 ld (iy-128), 127               ; FD 36 80 7F
 ld (iy-128), 255               ; FD 36 80 FF
 ld (iy-128), a                 ; FD 77 80
 ld (iy-128), b                 ; FD 70 80
 ld (iy-128), bc                ; FD 0F 80
 ld (iy-128), c                 ; FD 71 80
 ld (iy-128), d                 ; FD 72 80
 ld (iy-128), de                ; FD 1F 80
 ld (iy-128), e                 ; FD 73 80
 ld (iy-128), h                 ; FD 74 80
 ld (iy-128), hl                ; FD 2F 80
 ld (iy-128), ix                ; FD 3E 80
 ld (iy-128), iy                ; FD 3F 80
 ld (iy-128), l                 ; FD 75 80
 ld a, (0x1234)                 ; 3A 34 12
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix+0)                   ; DD 7E 00
 ld a, (ix+126)                 ; DD 7E 7E
 ld a, (ix-128)                 ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy+0)                   ; FD 7E 00
 ld a, (iy+126)                 ; FD 7E 7E
 ld a, (iy-128)                 ; FD 7E 80
 ld a, -128                     ; 3E 80
 ld a, 0                        ; 3E 00
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, i                        ; ED 57
 ld a, ixh                      ; DD 7C
 ld a, ixl                      ; DD 7D
 ld a, iyh                      ; FD 7C
 ld a, iyl                      ; FD 7D
 ld a, l                        ; 7D
 ld a, mb                       ; ED 6E
 ld a, r                        ; ED 5F
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; DD 46 00
 ld b, (ix+0)                   ; DD 46 00
 ld b, (ix+126)                 ; DD 46 7E
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+0)                   ; FD 46 00
 ld b, (iy+126)                 ; FD 46 7E
 ld b, (iy-128)                 ; FD 46 80
 ld b, -128                     ; 06 80
 ld b, 0                        ; 06 00
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; DD 44
 ld b, ixl                      ; DD 45
 ld b, iyh                      ; FD 44
 ld b, iyl                      ; FD 45
 ld b, l                        ; 45
 ld bc, (0x1234)                ; ED 4B 34 12
 ld bc, (hl)                    ; ED 07
 ld bc, (ix)                    ; DD 07 00
 ld bc, (ix+0)                  ; DD 07 00
 ld bc, (ix+126)                ; DD 07 7E
 ld bc, (ix-128)                ; DD 07 80
 ld bc, (iy)                    ; FD 07 00
 ld bc, (iy+0)                  ; FD 07 00
 ld bc, (iy+126)                ; FD 07 7E
 ld bc, (iy-128)                ; FD 07 80
 ld bc, 0x1234                  ; 01 34 12
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix+0)                   ; DD 4E 00
 ld c, (ix+126)                 ; DD 4E 7E
 ld c, (ix-128)                 ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy+0)                   ; FD 4E 00
 ld c, (iy+126)                 ; FD 4E 7E
 ld c, (iy-128)                 ; FD 4E 80
 ld c, -128                     ; 0E 80
 ld c, 0                        ; 0E 00
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; DD 4C
 ld c, ixl                      ; DD 4D
 ld c, iyh                      ; FD 4C
 ld c, iyl                      ; FD 4D
 ld c, l                        ; 4D
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; DD 56 00
 ld d, (ix+0)                   ; DD 56 00
 ld d, (ix+126)                 ; DD 56 7E
 ld d, (ix-128)                 ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy+0)                   ; FD 56 00
 ld d, (iy+126)                 ; FD 56 7E
 ld d, (iy-128)                 ; FD 56 80
 ld d, -128                     ; 16 80
 ld d, 0                        ; 16 00
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; DD 54
 ld d, ixl                      ; DD 55
 ld d, iyh                      ; FD 54
 ld d, iyl                      ; FD 55
 ld d, l                        ; 55
 ld de, (0x1234)                ; ED 5B 34 12
 ld de, (hl)                    ; ED 17
 ld de, (ix)                    ; DD 17 00
 ld de, (ix+0)                  ; DD 17 00
 ld de, (ix+126)                ; DD 17 7E
 ld de, (ix-128)                ; DD 17 80
 ld de, (iy)                    ; FD 17 00
 ld de, (iy+0)                  ; FD 17 00
 ld de, (iy+126)                ; FD 17 7E
 ld de, (iy-128)                ; FD 17 80
 ld de, 0x1234                  ; 11 34 12
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix+0)                   ; DD 5E 00
 ld e, (ix+126)                 ; DD 5E 7E
 ld e, (ix-128)                 ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy+0)                   ; FD 5E 00
 ld e, (iy+126)                 ; FD 5E 7E
 ld e, (iy-128)                 ; FD 5E 80
 ld e, -128                     ; 1E 80
 ld e, 0                        ; 1E 00
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, h                        ; 5C
 ld e, ixh                      ; DD 5C
 ld e, ixl                      ; DD 5D
 ld e, iyh                      ; FD 5C
 ld e, iyl                      ; FD 5D
 ld e, l                        ; 5D
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; DD 66 00
 ld h, (ix+0)                   ; DD 66 00
 ld h, (ix+126)                 ; DD 66 7E
 ld h, (ix-128)                 ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy+0)                   ; FD 66 00
 ld h, (iy+126)                 ; FD 66 7E
 ld h, (iy-128)                 ; FD 66 80
 ld h, -128                     ; 26 80
 ld h, 0                        ; 26 00
 ld h, 127                      ; 26 7F
 ld h, 255                      ; 26 FF
 ld h, a                        ; 67
 ld h, b                        ; 60
 ld h, c                        ; 61
 ld h, d                        ; 62
 ld h, e                        ; 63
 ld h, h                        ; 64
 ld h, l                        ; 65
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, (hl)                    ; ED 27
 ld hl, (ix)                    ; DD 27 00
 ld hl, (ix+0)                  ; DD 27 00
 ld hl, (ix+126)                ; DD 27 7E
 ld hl, (ix-128)                ; DD 27 80
 ld hl, (iy)                    ; FD 27 00
 ld hl, (iy+0)                  ; FD 27 00
 ld hl, (iy+126)                ; FD 27 7E
 ld hl, (iy-128)                ; FD 27 80
 ld hl, 0x1234                  ; 21 34 12
 ld hl, i                       ; ED D7
 ld i, a                        ; ED 47
 ld i, hl                       ; ED C7
 ld ix, (0x1234)                ; DD 2A 34 12
 ld ix, (hl)                    ; ED 37
 ld ix, (ix)                    ; DD 37 00
 ld ix, (ix+0)                  ; DD 37 00
 ld ix, (ix+126)                ; DD 37 7E
 ld ix, (ix-128)                ; DD 37 80
 ld ix, (iy)                    ; FD 31 00
 ld ix, (iy+0)                  ; FD 31 00
 ld ix, (iy+126)                ; FD 31 7E
 ld ix, (iy-128)                ; FD 31 80
 ld ix, 0x1234                  ; DD 21 34 12
 ld ixh, -128                   ; DD 26 80
 ld ixh, 0                      ; DD 26 00
 ld ixh, 127                    ; DD 26 7F
 ld ixh, 255                    ; DD 26 FF
 ld ixh, a                      ; DD 67
 ld ixh, b                      ; DD 60
 ld ixh, c                      ; DD 61
 ld ixh, d                      ; DD 62
 ld ixh, e                      ; DD 63
 ld ixh, ixh                    ; DD 64
 ld ixh, ixl                    ; DD 65
 ld ixl, -128                   ; DD 2E 80
 ld ixl, 0                      ; DD 2E 00
 ld ixl, 127                    ; DD 2E 7F
 ld ixl, 255                    ; DD 2E FF
 ld ixl, a                      ; DD 6F
 ld ixl, b                      ; DD 68
 ld ixl, c                      ; DD 69
 ld ixl, d                      ; DD 6A
 ld ixl, e                      ; DD 6B
 ld ixl, ixh                    ; DD 6C
 ld ixl, ixl                    ; DD 6D
 ld iy, (0x1234)                ; FD 2A 34 12
 ld iy, (hl)                    ; ED 31
 ld iy, (ix)                    ; DD 31 00
 ld iy, (ix+0)                  ; DD 31 00
 ld iy, (ix+126)                ; DD 31 7E
 ld iy, (ix-128)                ; DD 31 80
 ld iy, (iy)                    ; FD 37 00
 ld iy, (iy+0)                  ; FD 37 00
 ld iy, (iy+126)                ; FD 37 7E
 ld iy, (iy-128)                ; FD 37 80
 ld iy, 0x1234                  ; FD 21 34 12
 ld iyh, -128                   ; FD 26 80
 ld iyh, 0                      ; FD 26 00
 ld iyh, 127                    ; FD 26 7F
 ld iyh, 255                    ; FD 26 FF
 ld iyh, a                      ; FD 67
 ld iyh, b                      ; FD 60
 ld iyh, c                      ; FD 61
 ld iyh, d                      ; FD 62
 ld iyh, e                      ; FD 63
 ld iyh, iyh                    ; FD 64
 ld iyh, iyl                    ; FD 65
 ld iyl, -128                   ; FD 2E 80
 ld iyl, 0                      ; FD 2E 00
 ld iyl, 127                    ; FD 2E 7F
 ld iyl, 255                    ; FD 2E FF
 ld iyl, a                      ; FD 6F
 ld iyl, b                      ; FD 68
 ld iyl, c                      ; FD 69
 ld iyl, d                      ; FD 6A
 ld iyl, e                      ; FD 6B
 ld iyl, iyh                    ; FD 6C
 ld iyl, iyl                    ; FD 6D
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix+0)                   ; DD 6E 00
 ld l, (ix+126)                 ; DD 6E 7E
 ld l, (ix-128)                 ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy+0)                   ; FD 6E 00
 ld l, (iy+126)                 ; FD 6E 7E
 ld l, (iy-128)                 ; FD 6E 80
 ld l, -128                     ; 2E 80
 ld l, 0                        ; 2E 00
 ld l, 127                      ; 2E 7F
 ld l, 255                      ; 2E FF
 ld l, a                        ; 6F
 ld l, b                        ; 68
 ld l, c                        ; 69
 ld l, d                        ; 6A
 ld l, e                        ; 6B
 ld l, h                        ; 6C
 ld l, l                        ; 6D
 ld mb, a                       ; ED 6D
 ld r, a                        ; ED 4F
 ld sp, (0x1234)                ; ED 7B 34 12
 ld sp, 0x1234                  ; 31 34 12
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 ld.il (0x123456), a            ; 5B 32 56 34 12
 ld.l (bc), a                   ; 49 02
 ld.l (de), a                   ; 49 12
 ld.l (hl), -128                ; 49 36 80
 ld.l (hl), 0                   ; 49 36 00
 ld.l (hl), 127                 ; 49 36 7F
 ld.l (hl), 255                 ; 49 36 FF
 ld.l (hl), a                   ; 49 77
 ld.l (hl), b                   ; 49 70
 ld.l (hl), bc                  ; 49 ED 0F
 ld.l (hl), c                   ; 49 71
 ld.l (hl), d                   ; 49 72
 ld.l (hl), de                  ; 49 ED 1F
 ld.l (hl), e                   ; 49 73
 ld.l (hl), h                   ; 49 74
 ld.l (hl), hl                  ; 49 ED 2F
 ld.l (hl), ix                  ; 49 ED 3F
 ld.l (hl), iy                  ; 49 ED 3E
 ld.l (hl), l                   ; 49 75
 ld.l (ix), -128                ; 49 DD 36 00 80
 ld.l (ix), 0                   ; 49 DD 36 00 00
 ld.l (ix), 127                 ; 49 DD 36 00 7F
 ld.l (ix), 255                 ; 49 DD 36 00 FF
 ld.l (ix), a                   ; 49 DD 77 00
 ld.l (ix), b                   ; 49 DD 70 00
 ld.l (ix), bc                  ; 49 DD 0F 00
 ld.l (ix), c                   ; 49 DD 71 00
 ld.l (ix), d                   ; 49 DD 72 00
 ld.l (ix), de                  ; 49 DD 1F 00
 ld.l (ix), e                   ; 49 DD 73 00
 ld.l (ix), h                   ; 49 DD 74 00
 ld.l (ix), hl                  ; 49 DD 2F 00
 ld.l (ix), ix                  ; 49 DD 3F 00
 ld.l (ix), iy                  ; 49 DD 3E 00
 ld.l (ix), l                   ; 49 DD 75 00
 ld.l (ix+0), -128              ; 49 DD 36 00 80
 ld.l (ix+0), 0                 ; 49 DD 36 00 00
 ld.l (ix+0), 127               ; 49 DD 36 00 7F
 ld.l (ix+0), 255               ; 49 DD 36 00 FF
 ld.l (ix+0), a                 ; 49 DD 77 00
 ld.l (ix+0), b                 ; 49 DD 70 00
 ld.l (ix+0), bc                ; 49 DD 0F 00
 ld.l (ix+0), c                 ; 49 DD 71 00
 ld.l (ix+0), d                 ; 49 DD 72 00
 ld.l (ix+0), de                ; 49 DD 1F 00
 ld.l (ix+0), e                 ; 49 DD 73 00
 ld.l (ix+0), h                 ; 49 DD 74 00
 ld.l (ix+0), hl                ; 49 DD 2F 00
 ld.l (ix+0), ix                ; 49 DD 3F 00
 ld.l (ix+0), iy                ; 49 DD 3E 00
 ld.l (ix+0), l                 ; 49 DD 75 00
 ld.l (ix+126), -128            ; 49 DD 36 7E 80
 ld.l (ix+126), 0               ; 49 DD 36 7E 00
 ld.l (ix+126), 127             ; 49 DD 36 7E 7F
 ld.l (ix+126), 255             ; 49 DD 36 7E FF
 ld.l (ix+126), a               ; 49 DD 77 7E
 ld.l (ix+126), b               ; 49 DD 70 7E
 ld.l (ix+126), bc              ; 49 DD 0F 7E
 ld.l (ix+126), c               ; 49 DD 71 7E
 ld.l (ix+126), d               ; 49 DD 72 7E
 ld.l (ix+126), de              ; 49 DD 1F 7E
 ld.l (ix+126), e               ; 49 DD 73 7E
 ld.l (ix+126), h               ; 49 DD 74 7E
 ld.l (ix+126), hl              ; 49 DD 2F 7E
 ld.l (ix+126), ix              ; 49 DD 3F 7E
 ld.l (ix+126), iy              ; 49 DD 3E 7E
 ld.l (ix+126), l               ; 49 DD 75 7E
 ld.l (ix-128), -128            ; 49 DD 36 80 80
 ld.l (ix-128), 0               ; 49 DD 36 80 00
 ld.l (ix-128), 127             ; 49 DD 36 80 7F
 ld.l (ix-128), 255             ; 49 DD 36 80 FF
 ld.l (ix-128), a               ; 49 DD 77 80
 ld.l (ix-128), b               ; 49 DD 70 80
 ld.l (ix-128), bc              ; 49 DD 0F 80
 ld.l (ix-128), c               ; 49 DD 71 80
 ld.l (ix-128), d               ; 49 DD 72 80
 ld.l (ix-128), de              ; 49 DD 1F 80
 ld.l (ix-128), e               ; 49 DD 73 80
 ld.l (ix-128), h               ; 49 DD 74 80
 ld.l (ix-128), hl              ; 49 DD 2F 80
 ld.l (ix-128), ix              ; 49 DD 3F 80
 ld.l (ix-128), iy              ; 49 DD 3E 80
 ld.l (ix-128), l               ; 49 DD 75 80
 ld.l (iy), -128                ; 49 FD 36 00 80
 ld.l (iy), 0                   ; 49 FD 36 00 00
 ld.l (iy), 127                 ; 49 FD 36 00 7F
 ld.l (iy), 255                 ; 49 FD 36 00 FF
 ld.l (iy), a                   ; 49 FD 77 00
 ld.l (iy), b                   ; 49 FD 70 00
 ld.l (iy), bc                  ; 49 FD 0F 00
 ld.l (iy), c                   ; 49 FD 71 00
 ld.l (iy), d                   ; 49 FD 72 00
 ld.l (iy), de                  ; 49 FD 1F 00
 ld.l (iy), e                   ; 49 FD 73 00
 ld.l (iy), h                   ; 49 FD 74 00
 ld.l (iy), hl                  ; 49 FD 2F 00
 ld.l (iy), ix                  ; 49 FD 3E 00
 ld.l (iy), iy                  ; 49 FD 3F 00
 ld.l (iy), l                   ; 49 FD 75 00
 ld.l (iy+0), -128              ; 49 FD 36 00 80
 ld.l (iy+0), 0                 ; 49 FD 36 00 00
 ld.l (iy+0), 127               ; 49 FD 36 00 7F
 ld.l (iy+0), 255               ; 49 FD 36 00 FF
 ld.l (iy+0), a                 ; 49 FD 77 00
 ld.l (iy+0), b                 ; 49 FD 70 00
 ld.l (iy+0), bc                ; 49 FD 0F 00
 ld.l (iy+0), c                 ; 49 FD 71 00
 ld.l (iy+0), d                 ; 49 FD 72 00
 ld.l (iy+0), de                ; 49 FD 1F 00
 ld.l (iy+0), e                 ; 49 FD 73 00
 ld.l (iy+0), h                 ; 49 FD 74 00
 ld.l (iy+0), hl                ; 49 FD 2F 00
 ld.l (iy+0), ix                ; 49 FD 3E 00
 ld.l (iy+0), iy                ; 49 FD 3F 00
 ld.l (iy+0), l                 ; 49 FD 75 00
 ld.l (iy+126), -128            ; 49 FD 36 7E 80
 ld.l (iy+126), 0               ; 49 FD 36 7E 00
 ld.l (iy+126), 127             ; 49 FD 36 7E 7F
 ld.l (iy+126), 255             ; 49 FD 36 7E FF
 ld.l (iy+126), a               ; 49 FD 77 7E
 ld.l (iy+126), b               ; 49 FD 70 7E
 ld.l (iy+126), bc              ; 49 FD 0F 7E
 ld.l (iy+126), c               ; 49 FD 71 7E
 ld.l (iy+126), d               ; 49 FD 72 7E
 ld.l (iy+126), de              ; 49 FD 1F 7E
 ld.l (iy+126), e               ; 49 FD 73 7E
 ld.l (iy+126), h               ; 49 FD 74 7E
 ld.l (iy+126), hl              ; 49 FD 2F 7E
 ld.l (iy+126), ix              ; 49 FD 3E 7E
 ld.l (iy+126), iy              ; 49 FD 3F 7E
 ld.l (iy+126), l               ; 49 FD 75 7E
 ld.l (iy-128), -128            ; 49 FD 36 80 80
 ld.l (iy-128), 0               ; 49 FD 36 80 00
 ld.l (iy-128), 127             ; 49 FD 36 80 7F
 ld.l (iy-128), 255             ; 49 FD 36 80 FF
 ld.l (iy-128), a               ; 49 FD 77 80
 ld.l (iy-128), b               ; 49 FD 70 80
 ld.l (iy-128), bc              ; 49 FD 0F 80
 ld.l (iy-128), c               ; 49 FD 71 80
 ld.l (iy-128), d               ; 49 FD 72 80
 ld.l (iy-128), de              ; 49 FD 1F 80
 ld.l (iy-128), e               ; 49 FD 73 80
 ld.l (iy-128), h               ; 49 FD 74 80
 ld.l (iy-128), hl              ; 49 FD 2F 80
 ld.l (iy-128), ix              ; 49 FD 3E 80
 ld.l (iy-128), iy              ; 49 FD 3F 80
 ld.l (iy-128), l               ; 49 FD 75 80
 ld.l a, (bc)                   ; 49 0A
 ld.l a, (de)                   ; 49 1A
 ld.l a, (hl)                   ; 49 7E
 ld.l a, (ix)                   ; 49 DD 7E 00
 ld.l a, (ix+0)                 ; 49 DD 7E 00
 ld.l a, (ix+126)               ; 49 DD 7E 7E
 ld.l a, (ix-128)               ; 49 DD 7E 80
 ld.l a, (iy)                   ; 49 FD 7E 00
 ld.l a, (iy+0)                 ; 49 FD 7E 00
 ld.l a, (iy+126)               ; 49 FD 7E 7E
 ld.l a, (iy-128)               ; 49 FD 7E 80
 ld.l b, (hl)                   ; 49 46
 ld.l b, (ix)                   ; 49 DD 46 00
 ld.l b, (ix+0)                 ; 49 DD 46 00
 ld.l b, (ix+126)               ; 49 DD 46 7E
 ld.l b, (ix-128)               ; 49 DD 46 80
 ld.l b, (iy)                   ; 49 FD 46 00
 ld.l b, (iy+0)                 ; 49 FD 46 00
 ld.l b, (iy+126)               ; 49 FD 46 7E
 ld.l b, (iy-128)               ; 49 FD 46 80
 ld.l bc, (hl)                  ; 49 ED 07
 ld.l bc, (ix)                  ; 49 DD 07 00
 ld.l bc, (ix+0)                ; 49 DD 07 00
 ld.l bc, (ix+126)              ; 49 DD 07 7E
 ld.l bc, (ix-128)              ; 49 DD 07 80
 ld.l bc, (iy)                  ; 49 FD 07 00
 ld.l bc, (iy+0)                ; 49 FD 07 00
 ld.l bc, (iy+126)              ; 49 FD 07 7E
 ld.l bc, (iy-128)              ; 49 FD 07 80
 ld.l c, (hl)                   ; 49 4E
 ld.l c, (ix)                   ; 49 DD 4E 00
 ld.l c, (ix+0)                 ; 49 DD 4E 00
 ld.l c, (ix+126)               ; 49 DD 4E 7E
 ld.l c, (ix-128)               ; 49 DD 4E 80
 ld.l c, (iy)                   ; 49 FD 4E 00
 ld.l c, (iy+0)                 ; 49 FD 4E 00
 ld.l c, (iy+126)               ; 49 FD 4E 7E
 ld.l c, (iy-128)               ; 49 FD 4E 80
 ld.l d, (hl)                   ; 49 56
 ld.l d, (ix)                   ; 49 DD 56 00
 ld.l d, (ix+0)                 ; 49 DD 56 00
 ld.l d, (ix+126)               ; 49 DD 56 7E
 ld.l d, (ix-128)               ; 49 DD 56 80
 ld.l d, (iy)                   ; 49 FD 56 00
 ld.l d, (iy+0)                 ; 49 FD 56 00
 ld.l d, (iy+126)               ; 49 FD 56 7E
 ld.l d, (iy-128)               ; 49 FD 56 80
 ld.l de, (hl)                  ; 49 ED 17
 ld.l de, (ix)                  ; 49 DD 17 00
 ld.l de, (ix+0)                ; 49 DD 17 00
 ld.l de, (ix+126)              ; 49 DD 17 7E
 ld.l de, (ix-128)              ; 49 DD 17 80
 ld.l de, (iy)                  ; 49 FD 17 00
 ld.l de, (iy+0)                ; 49 FD 17 00
 ld.l de, (iy+126)              ; 49 FD 17 7E
 ld.l de, (iy-128)              ; 49 FD 17 80
 ld.l e, (hl)                   ; 49 5E
 ld.l e, (ix)                   ; 49 DD 5E 00
 ld.l e, (ix+0)                 ; 49 DD 5E 00
 ld.l e, (ix+126)               ; 49 DD 5E 7E
 ld.l e, (ix-128)               ; 49 DD 5E 80
 ld.l e, (iy)                   ; 49 FD 5E 00
 ld.l e, (iy+0)                 ; 49 FD 5E 00
 ld.l e, (iy+126)               ; 49 FD 5E 7E
 ld.l e, (iy-128)               ; 49 FD 5E 80
 ld.l h, (hl)                   ; 49 66
 ld.l h, (ix)                   ; 49 DD 66 00
 ld.l h, (ix+0)                 ; 49 DD 66 00
 ld.l h, (ix+126)               ; 49 DD 66 7E
 ld.l h, (ix-128)               ; 49 DD 66 80
 ld.l h, (iy)                   ; 49 FD 66 00
 ld.l h, (iy+0)                 ; 49 FD 66 00
 ld.l h, (iy+126)               ; 49 FD 66 7E
 ld.l h, (iy-128)               ; 49 FD 66 80
 ld.l hl, (hl)                  ; 49 ED 27
 ld.l hl, (ix)                  ; 49 DD 27 00
 ld.l hl, (ix+0)                ; 49 DD 27 00
 ld.l hl, (ix+126)              ; 49 DD 27 7E
 ld.l hl, (ix-128)              ; 49 DD 27 80
 ld.l hl, (iy)                  ; 49 FD 27 00
 ld.l hl, (iy+0)                ; 49 FD 27 00
 ld.l hl, (iy+126)              ; 49 FD 27 7E
 ld.l hl, (iy-128)              ; 49 FD 27 80
 ld.l ix, (hl)                  ; 49 ED 37
 ld.l ix, (ix)                  ; 49 DD 37 00
 ld.l ix, (ix+0)                ; 49 DD 37 00
 ld.l ix, (ix+126)              ; 49 DD 37 7E
 ld.l ix, (ix-128)              ; 49 DD 37 80
 ld.l ix, (iy)                  ; 49 FD 31 00
 ld.l ix, (iy+0)                ; 49 FD 31 00
 ld.l ix, (iy+126)              ; 49 FD 31 7E
 ld.l ix, (iy-128)              ; 49 FD 31 80
 ld.l iy, (hl)                  ; 49 ED 31
 ld.l iy, (ix)                  ; 49 DD 31 00
 ld.l iy, (ix+0)                ; 49 DD 31 00
 ld.l iy, (ix+126)              ; 49 DD 31 7E
 ld.l iy, (ix-128)              ; 49 DD 31 80
 ld.l iy, (iy)                  ; 49 FD 37 00
 ld.l iy, (iy+0)                ; 49 FD 37 00
 ld.l iy, (iy+126)              ; 49 FD 37 7E
 ld.l iy, (iy-128)              ; 49 FD 37 80
 ld.l l, (hl)                   ; 49 6E
 ld.l l, (ix)                   ; 49 DD 6E 00
 ld.l l, (ix+0)                 ; 49 DD 6E 00
 ld.l l, (ix+126)               ; 49 DD 6E 7E
 ld.l l, (ix-128)               ; 49 DD 6E 80
 ld.l l, (iy)                   ; 49 FD 6E 00
 ld.l l, (iy+0)                 ; 49 FD 6E 00
 ld.l l, (iy+126)               ; 49 FD 6E 7E
 ld.l l, (iy-128)               ; 49 FD 6E 80
 ld.l sp, hl                    ; 49 F9
 ld.l sp, ix                    ; 49 DD F9
 ld.l sp, iy                    ; 49 FD F9
 ld.lil (0x123456), a           ; 5B 32 56 34 12
 ld.lil (0x123456), bc          ; 5B ED 43 56 34 12
 ld.lil (0x123456), de          ; 5B ED 53 56 34 12
 ld.lil (0x123456), hl          ; 5B 22 56 34 12
 ld.lil (0x123456), ix          ; 5B DD 22 56 34 12
 ld.lil (0x123456), iy          ; 5B FD 22 56 34 12
 ld.lil (0x123456), sp          ; 5B ED 73 56 34 12
 ld.lil a, (0x123456)           ; 5B 3A 56 34 12
 ld.lil bc, (0x123456)          ; 5B ED 4B 56 34 12
 ld.lil bc, 0x123456            ; 5B 01 56 34 12
 ld.lil de, (0x123456)          ; 5B ED 5B 56 34 12
 ld.lil de, 0x123456            ; 5B 11 56 34 12
 ld.lil hl, (0x123456)          ; 5B 2A 56 34 12
 ld.lil hl, 0x123456            ; 5B 21 56 34 12
 ld.lil ix, (0x123456)          ; 5B DD 2A 56 34 12
 ld.lil ix, 0x123456            ; 5B DD 21 56 34 12
 ld.lil iy, (0x123456)          ; 5B FD 2A 56 34 12
 ld.lil iy, 0x123456            ; 5B FD 21 56 34 12
 ld.lil sp, (0x123456)          ; 5B ED 7B 56 34 12
 ld.lil sp, 0x123456            ; 5B 31 56 34 12
 ld.lis (bc), a                 ; 49 02
 ld.lis (de), a                 ; 49 12
 ld.lis (hl), -128              ; 49 36 80
 ld.lis (hl), 0                 ; 49 36 00
 ld.lis (hl), 127               ; 49 36 7F
 ld.lis (hl), 255               ; 49 36 FF
 ld.lis (hl), a                 ; 49 77
 ld.lis (hl), b                 ; 49 70
 ld.lis (hl), bc                ; 49 ED 0F
 ld.lis (hl), c                 ; 49 71
 ld.lis (hl), d                 ; 49 72
 ld.lis (hl), de                ; 49 ED 1F
 ld.lis (hl), e                 ; 49 73
 ld.lis (hl), h                 ; 49 74
 ld.lis (hl), hl                ; 49 ED 2F
 ld.lis (hl), ix                ; 49 ED 3F
 ld.lis (hl), iy                ; 49 ED 3E
 ld.lis (hl), l                 ; 49 75
 ld.lis (ix), -128              ; 49 DD 36 00 80
 ld.lis (ix), 0                 ; 49 DD 36 00 00
 ld.lis (ix), 127               ; 49 DD 36 00 7F
 ld.lis (ix), 255               ; 49 DD 36 00 FF
 ld.lis (ix), a                 ; 49 DD 77 00
 ld.lis (ix), b                 ; 49 DD 70 00
 ld.lis (ix), bc                ; 49 DD 0F 00
 ld.lis (ix), c                 ; 49 DD 71 00
 ld.lis (ix), d                 ; 49 DD 72 00
 ld.lis (ix), de                ; 49 DD 1F 00
 ld.lis (ix), e                 ; 49 DD 73 00
 ld.lis (ix), h                 ; 49 DD 74 00
 ld.lis (ix), hl                ; 49 DD 2F 00
 ld.lis (ix), ix                ; 49 DD 3F 00
 ld.lis (ix), iy                ; 49 DD 3E 00
 ld.lis (ix), l                 ; 49 DD 75 00
 ld.lis (ix+0), -128            ; 49 DD 36 00 80
 ld.lis (ix+0), 0               ; 49 DD 36 00 00
 ld.lis (ix+0), 127             ; 49 DD 36 00 7F
 ld.lis (ix+0), 255             ; 49 DD 36 00 FF
 ld.lis (ix+0), a               ; 49 DD 77 00
 ld.lis (ix+0), b               ; 49 DD 70 00
 ld.lis (ix+0), bc              ; 49 DD 0F 00
 ld.lis (ix+0), c               ; 49 DD 71 00
 ld.lis (ix+0), d               ; 49 DD 72 00
 ld.lis (ix+0), de              ; 49 DD 1F 00
 ld.lis (ix+0), e               ; 49 DD 73 00
 ld.lis (ix+0), h               ; 49 DD 74 00
 ld.lis (ix+0), hl              ; 49 DD 2F 00
 ld.lis (ix+0), ix              ; 49 DD 3F 00
 ld.lis (ix+0), iy              ; 49 DD 3E 00
 ld.lis (ix+0), l               ; 49 DD 75 00
 ld.lis (ix+126), -128          ; 49 DD 36 7E 80
 ld.lis (ix+126), 0             ; 49 DD 36 7E 00
 ld.lis (ix+126), 127           ; 49 DD 36 7E 7F
 ld.lis (ix+126), 255           ; 49 DD 36 7E FF
 ld.lis (ix+126), a             ; 49 DD 77 7E
 ld.lis (ix+126), b             ; 49 DD 70 7E
 ld.lis (ix+126), bc            ; 49 DD 0F 7E
 ld.lis (ix+126), c             ; 49 DD 71 7E
 ld.lis (ix+126), d             ; 49 DD 72 7E
 ld.lis (ix+126), de            ; 49 DD 1F 7E
 ld.lis (ix+126), e             ; 49 DD 73 7E
 ld.lis (ix+126), h             ; 49 DD 74 7E
 ld.lis (ix+126), hl            ; 49 DD 2F 7E
 ld.lis (ix+126), ix            ; 49 DD 3F 7E
 ld.lis (ix+126), iy            ; 49 DD 3E 7E
 ld.lis (ix+126), l             ; 49 DD 75 7E
 ld.lis (ix-128), -128          ; 49 DD 36 80 80
 ld.lis (ix-128), 0             ; 49 DD 36 80 00
 ld.lis (ix-128), 127           ; 49 DD 36 80 7F
 ld.lis (ix-128), 255           ; 49 DD 36 80 FF
 ld.lis (ix-128), a             ; 49 DD 77 80
 ld.lis (ix-128), b             ; 49 DD 70 80
 ld.lis (ix-128), bc            ; 49 DD 0F 80
 ld.lis (ix-128), c             ; 49 DD 71 80
 ld.lis (ix-128), d             ; 49 DD 72 80
 ld.lis (ix-128), de            ; 49 DD 1F 80
 ld.lis (ix-128), e             ; 49 DD 73 80
 ld.lis (ix-128), h             ; 49 DD 74 80
 ld.lis (ix-128), hl            ; 49 DD 2F 80
 ld.lis (ix-128), ix            ; 49 DD 3F 80
 ld.lis (ix-128), iy            ; 49 DD 3E 80
 ld.lis (ix-128), l             ; 49 DD 75 80
 ld.lis (iy), -128              ; 49 FD 36 00 80
 ld.lis (iy), 0                 ; 49 FD 36 00 00
 ld.lis (iy), 127               ; 49 FD 36 00 7F
 ld.lis (iy), 255               ; 49 FD 36 00 FF
 ld.lis (iy), a                 ; 49 FD 77 00
 ld.lis (iy), b                 ; 49 FD 70 00
 ld.lis (iy), bc                ; 49 FD 0F 00
 ld.lis (iy), c                 ; 49 FD 71 00
 ld.lis (iy), d                 ; 49 FD 72 00
 ld.lis (iy), de                ; 49 FD 1F 00
 ld.lis (iy), e                 ; 49 FD 73 00
 ld.lis (iy), h                 ; 49 FD 74 00
 ld.lis (iy), hl                ; 49 FD 2F 00
 ld.lis (iy), ix                ; 49 FD 3E 00
 ld.lis (iy), iy                ; 49 FD 3F 00
 ld.lis (iy), l                 ; 49 FD 75 00
 ld.lis (iy+0), -128            ; 49 FD 36 00 80
 ld.lis (iy+0), 0               ; 49 FD 36 00 00
 ld.lis (iy+0), 127             ; 49 FD 36 00 7F
 ld.lis (iy+0), 255             ; 49 FD 36 00 FF
 ld.lis (iy+0), a               ; 49 FD 77 00
 ld.lis (iy+0), b               ; 49 FD 70 00
 ld.lis (iy+0), bc              ; 49 FD 0F 00
 ld.lis (iy+0), c               ; 49 FD 71 00
 ld.lis (iy+0), d               ; 49 FD 72 00
 ld.lis (iy+0), de              ; 49 FD 1F 00
 ld.lis (iy+0), e               ; 49 FD 73 00
 ld.lis (iy+0), h               ; 49 FD 74 00
 ld.lis (iy+0), hl              ; 49 FD 2F 00
 ld.lis (iy+0), ix              ; 49 FD 3E 00
 ld.lis (iy+0), iy              ; 49 FD 3F 00
 ld.lis (iy+0), l               ; 49 FD 75 00
 ld.lis (iy+126), -128          ; 49 FD 36 7E 80
 ld.lis (iy+126), 0             ; 49 FD 36 7E 00
 ld.lis (iy+126), 127           ; 49 FD 36 7E 7F
 ld.lis (iy+126), 255           ; 49 FD 36 7E FF
 ld.lis (iy+126), a             ; 49 FD 77 7E
 ld.lis (iy+126), b             ; 49 FD 70 7E
 ld.lis (iy+126), bc            ; 49 FD 0F 7E
 ld.lis (iy+126), c             ; 49 FD 71 7E
 ld.lis (iy+126), d             ; 49 FD 72 7E
 ld.lis (iy+126), de            ; 49 FD 1F 7E
 ld.lis (iy+126), e             ; 49 FD 73 7E
 ld.lis (iy+126), h             ; 49 FD 74 7E
 ld.lis (iy+126), hl            ; 49 FD 2F 7E
 ld.lis (iy+126), ix            ; 49 FD 3E 7E
 ld.lis (iy+126), iy            ; 49 FD 3F 7E
 ld.lis (iy+126), l             ; 49 FD 75 7E
 ld.lis (iy-128), -128          ; 49 FD 36 80 80
 ld.lis (iy-128), 0             ; 49 FD 36 80 00
 ld.lis (iy-128), 127           ; 49 FD 36 80 7F
 ld.lis (iy-128), 255           ; 49 FD 36 80 FF
 ld.lis (iy-128), a             ; 49 FD 77 80
 ld.lis (iy-128), b             ; 49 FD 70 80
 ld.lis (iy-128), bc            ; 49 FD 0F 80
 ld.lis (iy-128), c             ; 49 FD 71 80
 ld.lis (iy-128), d             ; 49 FD 72 80
 ld.lis (iy-128), de            ; 49 FD 1F 80
 ld.lis (iy-128), e             ; 49 FD 73 80
 ld.lis (iy-128), h             ; 49 FD 74 80
 ld.lis (iy-128), hl            ; 49 FD 2F 80
 ld.lis (iy-128), ix            ; 49 FD 3E 80
 ld.lis (iy-128), iy            ; 49 FD 3F 80
 ld.lis (iy-128), l             ; 49 FD 75 80
 ld.lis a, (bc)                 ; 49 0A
 ld.lis a, (de)                 ; 49 1A
 ld.lis a, (hl)                 ; 49 7E
 ld.lis a, (ix)                 ; 49 DD 7E 00
 ld.lis a, (ix+0)               ; 49 DD 7E 00
 ld.lis a, (ix+126)             ; 49 DD 7E 7E
 ld.lis a, (ix-128)             ; 49 DD 7E 80
 ld.lis a, (iy)                 ; 49 FD 7E 00
 ld.lis a, (iy+0)               ; 49 FD 7E 00
 ld.lis a, (iy+126)             ; 49 FD 7E 7E
 ld.lis a, (iy-128)             ; 49 FD 7E 80
 ld.lis b, (hl)                 ; 49 46
 ld.lis b, (ix)                 ; 49 DD 46 00
 ld.lis b, (ix+0)               ; 49 DD 46 00
 ld.lis b, (ix+126)             ; 49 DD 46 7E
 ld.lis b, (ix-128)             ; 49 DD 46 80
 ld.lis b, (iy)                 ; 49 FD 46 00
 ld.lis b, (iy+0)               ; 49 FD 46 00
 ld.lis b, (iy+126)             ; 49 FD 46 7E
 ld.lis b, (iy-128)             ; 49 FD 46 80
 ld.lis bc, (hl)                ; 49 ED 07
 ld.lis bc, (ix)                ; 49 DD 07 00
 ld.lis bc, (ix+0)              ; 49 DD 07 00
 ld.lis bc, (ix+126)            ; 49 DD 07 7E
 ld.lis bc, (ix-128)            ; 49 DD 07 80
 ld.lis bc, (iy)                ; 49 FD 07 00
 ld.lis bc, (iy+0)              ; 49 FD 07 00
 ld.lis bc, (iy+126)            ; 49 FD 07 7E
 ld.lis bc, (iy-128)            ; 49 FD 07 80
 ld.lis bc, 0x1234              ; 49 01 34 12
 ld.lis c, (hl)                 ; 49 4E
 ld.lis c, (ix)                 ; 49 DD 4E 00
 ld.lis c, (ix+0)               ; 49 DD 4E 00
 ld.lis c, (ix+126)             ; 49 DD 4E 7E
 ld.lis c, (ix-128)             ; 49 DD 4E 80
 ld.lis c, (iy)                 ; 49 FD 4E 00
 ld.lis c, (iy+0)               ; 49 FD 4E 00
 ld.lis c, (iy+126)             ; 49 FD 4E 7E
 ld.lis c, (iy-128)             ; 49 FD 4E 80
 ld.lis d, (hl)                 ; 49 56
 ld.lis d, (ix)                 ; 49 DD 56 00
 ld.lis d, (ix+0)               ; 49 DD 56 00
 ld.lis d, (ix+126)             ; 49 DD 56 7E
 ld.lis d, (ix-128)             ; 49 DD 56 80
 ld.lis d, (iy)                 ; 49 FD 56 00
 ld.lis d, (iy+0)               ; 49 FD 56 00
 ld.lis d, (iy+126)             ; 49 FD 56 7E
 ld.lis d, (iy-128)             ; 49 FD 56 80
 ld.lis de, (hl)                ; 49 ED 17
 ld.lis de, (ix)                ; 49 DD 17 00
 ld.lis de, (ix+0)              ; 49 DD 17 00
 ld.lis de, (ix+126)            ; 49 DD 17 7E
 ld.lis de, (ix-128)            ; 49 DD 17 80
 ld.lis de, (iy)                ; 49 FD 17 00
 ld.lis de, (iy+0)              ; 49 FD 17 00
 ld.lis de, (iy+126)            ; 49 FD 17 7E
 ld.lis de, (iy-128)            ; 49 FD 17 80
 ld.lis de, 0x1234              ; 49 11 34 12
 ld.lis e, (hl)                 ; 49 5E
 ld.lis e, (ix)                 ; 49 DD 5E 00
 ld.lis e, (ix+0)               ; 49 DD 5E 00
 ld.lis e, (ix+126)             ; 49 DD 5E 7E
 ld.lis e, (ix-128)             ; 49 DD 5E 80
 ld.lis e, (iy)                 ; 49 FD 5E 00
 ld.lis e, (iy+0)               ; 49 FD 5E 00
 ld.lis e, (iy+126)             ; 49 FD 5E 7E
 ld.lis e, (iy-128)             ; 49 FD 5E 80
 ld.lis h, (hl)                 ; 49 66
 ld.lis h, (ix)                 ; 49 DD 66 00
 ld.lis h, (ix+0)               ; 49 DD 66 00
 ld.lis h, (ix+126)             ; 49 DD 66 7E
 ld.lis h, (ix-128)             ; 49 DD 66 80
 ld.lis h, (iy)                 ; 49 FD 66 00
 ld.lis h, (iy+0)               ; 49 FD 66 00
 ld.lis h, (iy+126)             ; 49 FD 66 7E
 ld.lis h, (iy-128)             ; 49 FD 66 80
 ld.lis hl, (hl)                ; 49 ED 27
 ld.lis hl, (ix)                ; 49 DD 27 00
 ld.lis hl, (ix+0)              ; 49 DD 27 00
 ld.lis hl, (ix+126)            ; 49 DD 27 7E
 ld.lis hl, (ix-128)            ; 49 DD 27 80
 ld.lis hl, (iy)                ; 49 FD 27 00
 ld.lis hl, (iy+0)              ; 49 FD 27 00
 ld.lis hl, (iy+126)            ; 49 FD 27 7E
 ld.lis hl, (iy-128)            ; 49 FD 27 80
 ld.lis hl, 0x1234              ; 49 21 34 12
 ld.lis ix, (hl)                ; 49 ED 37
 ld.lis ix, (ix)                ; 49 DD 37 00
 ld.lis ix, (ix+0)              ; 49 DD 37 00
 ld.lis ix, (ix+126)            ; 49 DD 37 7E
 ld.lis ix, (ix-128)            ; 49 DD 37 80
 ld.lis ix, (iy)                ; 49 FD 31 00
 ld.lis ix, (iy+0)              ; 49 FD 31 00
 ld.lis ix, (iy+126)            ; 49 FD 31 7E
 ld.lis ix, (iy-128)            ; 49 FD 31 80
 ld.lis ix, 0x1234              ; 49 DD 21 34 12
 ld.lis iy, (hl)                ; 49 ED 31
 ld.lis iy, (ix)                ; 49 DD 31 00
 ld.lis iy, (ix+0)              ; 49 DD 31 00
 ld.lis iy, (ix+126)            ; 49 DD 31 7E
 ld.lis iy, (ix-128)            ; 49 DD 31 80
 ld.lis iy, (iy)                ; 49 FD 37 00
 ld.lis iy, (iy+0)              ; 49 FD 37 00
 ld.lis iy, (iy+126)            ; 49 FD 37 7E
 ld.lis iy, (iy-128)            ; 49 FD 37 80
 ld.lis iy, 0x1234              ; 49 FD 21 34 12
 ld.lis l, (hl)                 ; 49 6E
 ld.lis l, (ix)                 ; 49 DD 6E 00
 ld.lis l, (ix+0)               ; 49 DD 6E 00
 ld.lis l, (ix+126)             ; 49 DD 6E 7E
 ld.lis l, (ix-128)             ; 49 DD 6E 80
 ld.lis l, (iy)                 ; 49 FD 6E 00
 ld.lis l, (iy+0)               ; 49 FD 6E 00
 ld.lis l, (iy+126)             ; 49 FD 6E 7E
 ld.lis l, (iy-128)             ; 49 FD 6E 80
 ld.lis sp, 0x1234              ; 49 31 34 12
 ld.lis sp, hl                  ; 49 F9
 ld.lis sp, ix                  ; 49 DD F9
 ld.lis sp, iy                  ; 49 FD F9
 ldd                            ; ED A8
 ldd.l                          ; 49 ED A8
 ldd.lis                        ; 49 ED A8
 lddr                           ; ED B8
 lddr.l                         ; 49 ED B8
 lddr.lis                       ; 49 ED B8
 ldi                            ; ED A0
 ldi.l                          ; 49 ED A0
 ldi.lis                        ; 49 ED A0
 ldir                           ; ED B0
 ldir.l                         ; 49 ED B0
 ldir.lis                       ; 49 ED B0
 lea bc, ix                     ; ED 02 00
 lea bc, ix+0                   ; ED 02 00
 lea bc, ix+126                 ; ED 02 7E
 lea bc, ix-128                 ; ED 02 80
 lea bc, iy                     ; ED 03 00
 lea bc, iy+0                   ; ED 03 00
 lea bc, iy+126                 ; ED 03 7E
 lea bc, iy-128                 ; ED 03 80
 lea de, ix                     ; ED 12 00
 lea de, ix+0                   ; ED 12 00
 lea de, ix+126                 ; ED 12 7E
 lea de, ix-128                 ; ED 12 80
 lea de, iy                     ; ED 13 00
 lea de, iy+0                   ; ED 13 00
 lea de, iy+126                 ; ED 13 7E
 lea de, iy-128                 ; ED 13 80
 lea hl, ix                     ; ED 22 00
 lea hl, ix+0                   ; ED 22 00
 lea hl, ix+126                 ; ED 22 7E
 lea hl, ix-128                 ; ED 22 80
 lea hl, iy                     ; ED 23 00
 lea hl, iy+0                   ; ED 23 00
 lea hl, iy+126                 ; ED 23 7E
 lea hl, iy-128                 ; ED 23 80
 lea ix, ix                     ; ED 32 00
 lea ix, ix+0                   ; ED 32 00
 lea ix, ix+126                 ; ED 32 7E
 lea ix, ix-128                 ; ED 32 80
 lea ix, iy                     ; ED 54 00
 lea ix, iy+0                   ; ED 54 00
 lea ix, iy+126                 ; ED 54 7E
 lea ix, iy-128                 ; ED 54 80
 lea iy, ix                     ; ED 55 00
 lea iy, ix+0                   ; ED 55 00
 lea iy, ix+126                 ; ED 55 7E
 lea iy, ix-128                 ; ED 55 80
 lea iy, iy                     ; ED 33 00
 lea iy, iy+0                   ; ED 33 00
 lea iy, iy+126                 ; ED 33 7E
 lea iy, iy-128                 ; ED 33 80
 lea.l bc, ix                   ; 49 ED 02 00
 lea.l bc, ix+0                 ; 49 ED 02 00
 lea.l bc, ix+126               ; 49 ED 02 7E
 lea.l bc, ix-128               ; 49 ED 02 80
 lea.l bc, iy                   ; 49 ED 03 00
 lea.l bc, iy+0                 ; 49 ED 03 00
 lea.l bc, iy+126               ; 49 ED 03 7E
 lea.l bc, iy-128               ; 49 ED 03 80
 lea.l de, ix                   ; 49 ED 12 00
 lea.l de, ix+0                 ; 49 ED 12 00
 lea.l de, ix+126               ; 49 ED 12 7E
 lea.l de, ix-128               ; 49 ED 12 80
 lea.l de, iy                   ; 49 ED 13 00
 lea.l de, iy+0                 ; 49 ED 13 00
 lea.l de, iy+126               ; 49 ED 13 7E
 lea.l de, iy-128               ; 49 ED 13 80
 lea.l hl, ix                   ; 49 ED 22 00
 lea.l hl, ix+0                 ; 49 ED 22 00
 lea.l hl, ix+126               ; 49 ED 22 7E
 lea.l hl, ix-128               ; 49 ED 22 80
 lea.l hl, iy                   ; 49 ED 23 00
 lea.l hl, iy+0                 ; 49 ED 23 00
 lea.l hl, iy+126               ; 49 ED 23 7E
 lea.l hl, iy-128               ; 49 ED 23 80
 lea.l ix, ix                   ; 49 ED 32 00
 lea.l ix, ix+0                 ; 49 ED 32 00
 lea.l ix, ix+126               ; 49 ED 32 7E
 lea.l ix, ix-128               ; 49 ED 32 80
 lea.l ix, iy                   ; 49 ED 54 00
 lea.l ix, iy+0                 ; 49 ED 54 00
 lea.l ix, iy+126               ; 49 ED 54 7E
 lea.l ix, iy-128               ; 49 ED 54 80
 lea.l iy, ix                   ; 49 ED 55 00
 lea.l iy, ix+0                 ; 49 ED 55 00
 lea.l iy, ix+126               ; 49 ED 55 7E
 lea.l iy, ix-128               ; 49 ED 55 80
 lea.l iy, iy                   ; 49 ED 33 00
 lea.l iy, iy+0                 ; 49 ED 33 00
 lea.l iy, iy+126               ; 49 ED 33 7E
 lea.l iy, iy-128               ; 49 ED 33 80
 lea.lis bc, ix                 ; 49 ED 02 00
 lea.lis bc, ix+0               ; 49 ED 02 00
 lea.lis bc, ix+126             ; 49 ED 02 7E
 lea.lis bc, ix-128             ; 49 ED 02 80
 lea.lis bc, iy                 ; 49 ED 03 00
 lea.lis bc, iy+0               ; 49 ED 03 00
 lea.lis bc, iy+126             ; 49 ED 03 7E
 lea.lis bc, iy-128             ; 49 ED 03 80
 lea.lis de, ix                 ; 49 ED 12 00
 lea.lis de, ix+0               ; 49 ED 12 00
 lea.lis de, ix+126             ; 49 ED 12 7E
 lea.lis de, ix-128             ; 49 ED 12 80
 lea.lis de, iy                 ; 49 ED 13 00
 lea.lis de, iy+0               ; 49 ED 13 00
 lea.lis de, iy+126             ; 49 ED 13 7E
 lea.lis de, iy-128             ; 49 ED 13 80
 lea.lis hl, ix                 ; 49 ED 22 00
 lea.lis hl, ix+0               ; 49 ED 22 00
 lea.lis hl, ix+126             ; 49 ED 22 7E
 lea.lis hl, ix-128             ; 49 ED 22 80
 lea.lis hl, iy                 ; 49 ED 23 00
 lea.lis hl, iy+0               ; 49 ED 23 00
 lea.lis hl, iy+126             ; 49 ED 23 7E
 lea.lis hl, iy-128             ; 49 ED 23 80
 lea.lis ix, ix                 ; 49 ED 32 00
 lea.lis ix, ix+0               ; 49 ED 32 00
 lea.lis ix, ix+126             ; 49 ED 32 7E
 lea.lis ix, ix-128             ; 49 ED 32 80
 lea.lis ix, iy                 ; 49 ED 54 00
 lea.lis ix, iy+0               ; 49 ED 54 00
 lea.lis ix, iy+126             ; 49 ED 54 7E
 lea.lis ix, iy-128             ; 49 ED 54 80
 lea.lis iy, ix                 ; 49 ED 55 00
 lea.lis iy, ix+0               ; 49 ED 55 00
 lea.lis iy, ix+126             ; 49 ED 55 7E
 lea.lis iy, ix-128             ; 49 ED 55 80
 lea.lis iy, iy                 ; 49 ED 33 00
 lea.lis iy, iy+0               ; 49 ED 33 00
 lea.lis iy, iy+126             ; 49 ED 33 7E
 lea.lis iy, iy-128             ; 49 ED 33 80
 mlt bc                         ; ED 4C
 mlt de                         ; ED 5C
 mlt hl                         ; ED 6C
 mlt sp                         ; ED 7C
 neg                            ; ED 44
 nop                            ; 00
 or a, (hl)                     ; B6
 or a, (ix)                     ; DD B6 00
 or a, (ix+0)                   ; DD B6 00
 or a, (ix+126)                 ; DD B6 7E
 or a, (ix-128)                 ; DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy+0)                   ; FD B6 00
 or a, (iy+126)                 ; FD B6 7E
 or a, (iy-128)                 ; FD B6 80
 or a, -128                     ; F6 80
 or a, 0                        ; F6 00
 or a, 127                      ; F6 7F
 or a, 255                      ; F6 FF
 or a, a                        ; B7
 or a, b                        ; B0
 or a, c                        ; B1
 or a, d                        ; B2
 or a, e                        ; B3
 or a, h                        ; B4
 or a, ixh                      ; DD B4
 or a, ixl                      ; DD B5
 or a, iyh                      ; FD B4
 or a, iyl                      ; FD B5
 or a, l                        ; B5
 or.l a, (hl)                   ; 49 B6
 or.l a, (ix)                   ; 49 DD B6 00
 or.l a, (ix+0)                 ; 49 DD B6 00
 or.l a, (ix+126)               ; 49 DD B6 7E
 or.l a, (ix-128)               ; 49 DD B6 80
 or.l a, (iy)                   ; 49 FD B6 00
 or.l a, (iy+0)                 ; 49 FD B6 00
 or.l a, (iy+126)               ; 49 FD B6 7E
 or.l a, (iy-128)               ; 49 FD B6 80
 or.lis a, (hl)                 ; 49 B6
 or.lis a, (ix)                 ; 49 DD B6 00
 or.lis a, (ix+0)               ; 49 DD B6 00
 or.lis a, (ix+126)             ; 49 DD B6 7E
 or.lis a, (ix-128)             ; 49 DD B6 80
 or.lis a, (iy)                 ; 49 FD B6 00
 or.lis a, (iy+0)               ; 49 FD B6 00
 or.lis a, (iy+126)             ; 49 FD B6 7E
 or.lis a, (iy-128)             ; 49 FD B6 80
 otd2r                          ; ED BC
 otd2r.l                        ; 49 ED BC
 otd2r.lis                      ; 49 ED BC
 otdm                           ; ED 8B
 otdm.l                         ; 49 ED 8B
 otdm.lis                       ; 49 ED 8B
 otdmr                          ; ED 9B
 otdmr.l                        ; 49 ED 9B
 otdmr.lis                      ; 49 ED 9B
 otdr                           ; ED BB
 otdr.l                         ; 49 ED BB
 otdr.lis                       ; 49 ED BB
 otdrx                          ; ED CB
 otdrx.l                        ; 49 ED CB
 otdrx.lis                      ; 49 ED CB
 oti2r                          ; ED B4
 oti2r.l                        ; 49 ED B4
 oti2r.lis                      ; 49 ED B4
 otim                           ; ED 83
 otim.l                         ; 49 ED 83
 otim.lis                       ; 49 ED 83
 otimr                          ; ED 93
 otimr.l                        ; 49 ED 93
 otimr.lis                      ; 49 ED 93
 otir                           ; ED B3
 otir.l                         ; 49 ED B3
 otir.lis                       ; 49 ED B3
 otirx                          ; ED C3
 otirx.l                        ; 49 ED C3
 otirx.lis                      ; 49 ED C3
 out (-128), a                  ; D3 80
 out (0), a                     ; D3 00
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out (bc), a                    ; ED 79
 out (bc), b                    ; ED 41
 out (bc), c                    ; ED 49
 out (bc), d                    ; ED 51
 out (bc), e                    ; ED 59
 out (bc), h                    ; ED 61
 out (bc), l                    ; ED 69
 out0 (-128), a                 ; ED 39 80
 out0 (-128), b                 ; ED 01 80
 out0 (-128), c                 ; ED 09 80
 out0 (-128), d                 ; ED 11 80
 out0 (-128), e                 ; ED 19 80
 out0 (-128), h                 ; ED 21 80
 out0 (-128), l                 ; ED 29 80
 out0 (0), a                    ; ED 39 00
 out0 (0), b                    ; ED 01 00
 out0 (0), c                    ; ED 09 00
 out0 (0), d                    ; ED 11 00
 out0 (0), e                    ; ED 19 00
 out0 (0), h                    ; ED 21 00
 out0 (0), l                    ; ED 29 00
 out0 (127), a                  ; ED 39 7F
 out0 (127), b                  ; ED 01 7F
 out0 (127), c                  ; ED 09 7F
 out0 (127), d                  ; ED 11 7F
 out0 (127), e                  ; ED 19 7F
 out0 (127), h                  ; ED 21 7F
 out0 (127), l                  ; ED 29 7F
 out0 (255), a                  ; ED 39 FF
 out0 (255), b                  ; ED 01 FF
 out0 (255), c                  ; ED 09 FF
 out0 (255), d                  ; ED 11 FF
 out0 (255), e                  ; ED 19 FF
 out0 (255), h                  ; ED 21 FF
 out0 (255), l                  ; ED 29 FF
 outd                           ; ED AB
 outd.l                         ; 49 ED AB
 outd.lis                       ; 49 ED AB
 outd2                          ; ED AC
 outd2.l                        ; 49 ED AC
 outd2.lis                      ; 49 ED AC
 outi                           ; ED A3
 outi.l                         ; 49 ED A3
 outi.lis                       ; 49 ED A3
 outi2                          ; ED A4
 outi2.l                        ; 49 ED A4
 outi2.lis                      ; 49 ED A4
 pea ix                         ; ED 65 00
 pea ix+0                       ; ED 65 00
 pea ix+126                     ; ED 65 7E
 pea ix-128                     ; ED 65 80
 pea iy                         ; ED 66 00
 pea iy+0                       ; ED 66 00
 pea iy+126                     ; ED 66 7E
 pea iy-128                     ; ED 66 80
 pea.l ix                       ; 49 ED 65 00
 pea.l ix+0                     ; 49 ED 65 00
 pea.l ix+126                   ; 49 ED 65 7E
 pea.l ix-128                   ; 49 ED 65 80
 pea.l iy                       ; 49 ED 66 00
 pea.l iy+0                     ; 49 ED 66 00
 pea.l iy+126                   ; 49 ED 66 7E
 pea.l iy-128                   ; 49 ED 66 80
 pea.lis ix                     ; 49 ED 65 00
 pea.lis ix+0                   ; 49 ED 65 00
 pea.lis ix+126                 ; 49 ED 65 7E
 pea.lis ix-128                 ; 49 ED 65 80
 pea.lis iy                     ; 49 ED 66 00
 pea.lis iy+0                   ; 49 ED 66 00
 pea.lis iy+126                 ; 49 ED 66 7E
 pea.lis iy-128                 ; 49 ED 66 80
 pop af                         ; F1
 pop bc                         ; C1
 pop de                         ; D1
 pop hl                         ; E1
 pop ix                         ; DD E1
 pop iy                         ; FD E1
 pop.l af                       ; 49 F1
 pop.l bc                       ; 49 C1
 pop.l de                       ; 49 D1
 pop.l hl                       ; 49 E1
 pop.l ix                       ; 49 DD E1
 pop.l iy                       ; 49 FD E1
 pop.lis af                     ; 49 F1
 pop.lis bc                     ; 49 C1
 pop.lis de                     ; 49 D1
 pop.lis hl                     ; 49 E1
 pop.lis ix                     ; 49 DD E1
 pop.lis iy                     ; 49 FD E1
 push af                        ; F5
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 push ix                        ; DD E5
 push iy                        ; FD E5
 push.l af                      ; 49 F5
 push.l bc                      ; 49 C5
 push.l de                      ; 49 D5
 push.l hl                      ; 49 E5
 push.l ix                      ; 49 DD E5
 push.l iy                      ; 49 FD E5
 push.lis af                    ; 49 F5
 push.lis bc                    ; 49 C5
 push.lis de                    ; 49 D5
 push.lis hl                    ; 49 E5
 push.lis ix                    ; 49 DD E5
 push.lis iy                    ; 49 FD E5
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; DD CB 00 86
 res 0, (ix+0)                  ; DD CB 00 86
 res 0, (ix+126)                ; DD CB 7E 86
 res 0, (ix-128)                ; DD CB 80 86
 res 0, (iy)                    ; FD CB 00 86
 res 0, (iy+0)                  ; FD CB 00 86
 res 0, (iy+126)                ; FD CB 7E 86
 res 0, (iy-128)                ; FD CB 80 86
 res 0, a                       ; CB 87
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, l                       ; CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; DD CB 00 8E
 res 1, (ix+0)                  ; DD CB 00 8E
 res 1, (ix+126)                ; DD CB 7E 8E
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy+0)                  ; FD CB 00 8E
 res 1, (iy+126)                ; FD CB 7E 8E
 res 1, (iy-128)                ; FD CB 80 8E
 res 1, a                       ; CB 8F
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, l                       ; CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; DD CB 00 96
 res 2, (ix+0)                  ; DD CB 00 96
 res 2, (ix+126)                ; DD CB 7E 96
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy+0)                  ; FD CB 00 96
 res 2, (iy+126)                ; FD CB 7E 96
 res 2, (iy-128)                ; FD CB 80 96
 res 2, a                       ; CB 97
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, l                       ; CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; DD CB 00 9E
 res 3, (ix+0)                  ; DD CB 00 9E
 res 3, (ix+126)                ; DD CB 7E 9E
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy+0)                  ; FD CB 00 9E
 res 3, (iy+126)                ; FD CB 7E 9E
 res 3, (iy-128)                ; FD CB 80 9E
 res 3, a                       ; CB 9F
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, l                       ; CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; DD CB 00 A6
 res 4, (ix+0)                  ; DD CB 00 A6
 res 4, (ix+126)                ; DD CB 7E A6
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy+0)                  ; FD CB 00 A6
 res 4, (iy+126)                ; FD CB 7E A6
 res 4, (iy-128)                ; FD CB 80 A6
 res 4, a                       ; CB A7
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, l                       ; CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; DD CB 00 AE
 res 5, (ix+0)                  ; DD CB 00 AE
 res 5, (ix+126)                ; DD CB 7E AE
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy+0)                  ; FD CB 00 AE
 res 5, (iy+126)                ; FD CB 7E AE
 res 5, (iy-128)                ; FD CB 80 AE
 res 5, a                       ; CB AF
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, l                       ; CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; DD CB 00 B6
 res 6, (ix+0)                  ; DD CB 00 B6
 res 6, (ix+126)                ; DD CB 7E B6
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy+0)                  ; FD CB 00 B6
 res 6, (iy+126)                ; FD CB 7E B6
 res 6, (iy-128)                ; FD CB 80 B6
 res 6, a                       ; CB B7
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, l                       ; CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; DD CB 00 BE
 res 7, (ix+0)                  ; DD CB 00 BE
 res 7, (ix+126)                ; DD CB 7E BE
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy+0)                  ; FD CB 00 BE
 res 7, (iy+126)                ; FD CB 7E BE
 res 7, (iy-128)                ; FD CB 80 BE
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 res.l 0, (hl)                  ; 49 CB 86
 res.l 0, (ix)                  ; 49 DD CB 00 86
 res.l 0, (ix+0)                ; 49 DD CB 00 86
 res.l 0, (ix+126)              ; 49 DD CB 7E 86
 res.l 0, (ix-128)              ; 49 DD CB 80 86
 res.l 0, (iy)                  ; 49 FD CB 00 86
 res.l 0, (iy+0)                ; 49 FD CB 00 86
 res.l 0, (iy+126)              ; 49 FD CB 7E 86
 res.l 0, (iy-128)              ; 49 FD CB 80 86
 res.l 1, (hl)                  ; 49 CB 8E
 res.l 1, (ix)                  ; 49 DD CB 00 8E
 res.l 1, (ix+0)                ; 49 DD CB 00 8E
 res.l 1, (ix+126)              ; 49 DD CB 7E 8E
 res.l 1, (ix-128)              ; 49 DD CB 80 8E
 res.l 1, (iy)                  ; 49 FD CB 00 8E
 res.l 1, (iy+0)                ; 49 FD CB 00 8E
 res.l 1, (iy+126)              ; 49 FD CB 7E 8E
 res.l 1, (iy-128)              ; 49 FD CB 80 8E
 res.l 2, (hl)                  ; 49 CB 96
 res.l 2, (ix)                  ; 49 DD CB 00 96
 res.l 2, (ix+0)                ; 49 DD CB 00 96
 res.l 2, (ix+126)              ; 49 DD CB 7E 96
 res.l 2, (ix-128)              ; 49 DD CB 80 96
 res.l 2, (iy)                  ; 49 FD CB 00 96
 res.l 2, (iy+0)                ; 49 FD CB 00 96
 res.l 2, (iy+126)              ; 49 FD CB 7E 96
 res.l 2, (iy-128)              ; 49 FD CB 80 96
 res.l 3, (hl)                  ; 49 CB 9E
 res.l 3, (ix)                  ; 49 DD CB 00 9E
 res.l 3, (ix+0)                ; 49 DD CB 00 9E
 res.l 3, (ix+126)              ; 49 DD CB 7E 9E
 res.l 3, (ix-128)              ; 49 DD CB 80 9E
 res.l 3, (iy)                  ; 49 FD CB 00 9E
 res.l 3, (iy+0)                ; 49 FD CB 00 9E
 res.l 3, (iy+126)              ; 49 FD CB 7E 9E
 res.l 3, (iy-128)              ; 49 FD CB 80 9E
 res.l 4, (hl)                  ; 49 CB A6
 res.l 4, (ix)                  ; 49 DD CB 00 A6
 res.l 4, (ix+0)                ; 49 DD CB 00 A6
 res.l 4, (ix+126)              ; 49 DD CB 7E A6
 res.l 4, (ix-128)              ; 49 DD CB 80 A6
 res.l 4, (iy)                  ; 49 FD CB 00 A6
 res.l 4, (iy+0)                ; 49 FD CB 00 A6
 res.l 4, (iy+126)              ; 49 FD CB 7E A6
 res.l 4, (iy-128)              ; 49 FD CB 80 A6
 res.l 5, (hl)                  ; 49 CB AE
 res.l 5, (ix)                  ; 49 DD CB 00 AE
 res.l 5, (ix+0)                ; 49 DD CB 00 AE
 res.l 5, (ix+126)              ; 49 DD CB 7E AE
 res.l 5, (ix-128)              ; 49 DD CB 80 AE
 res.l 5, (iy)                  ; 49 FD CB 00 AE
 res.l 5, (iy+0)                ; 49 FD CB 00 AE
 res.l 5, (iy+126)              ; 49 FD CB 7E AE
 res.l 5, (iy-128)              ; 49 FD CB 80 AE
 res.l 6, (hl)                  ; 49 CB B6
 res.l 6, (ix)                  ; 49 DD CB 00 B6
 res.l 6, (ix+0)                ; 49 DD CB 00 B6
 res.l 6, (ix+126)              ; 49 DD CB 7E B6
 res.l 6, (ix-128)              ; 49 DD CB 80 B6
 res.l 6, (iy)                  ; 49 FD CB 00 B6
 res.l 6, (iy+0)                ; 49 FD CB 00 B6
 res.l 6, (iy+126)              ; 49 FD CB 7E B6
 res.l 6, (iy-128)              ; 49 FD CB 80 B6
 res.l 7, (hl)                  ; 49 CB BE
 res.l 7, (ix)                  ; 49 DD CB 00 BE
 res.l 7, (ix+0)                ; 49 DD CB 00 BE
 res.l 7, (ix+126)              ; 49 DD CB 7E BE
 res.l 7, (ix-128)              ; 49 DD CB 80 BE
 res.l 7, (iy)                  ; 49 FD CB 00 BE
 res.l 7, (iy+0)                ; 49 FD CB 00 BE
 res.l 7, (iy+126)              ; 49 FD CB 7E BE
 res.l 7, (iy-128)              ; 49 FD CB 80 BE
 res.lis 0, (hl)                ; 49 CB 86
 res.lis 0, (ix)                ; 49 DD CB 00 86
 res.lis 0, (ix+0)              ; 49 DD CB 00 86
 res.lis 0, (ix+126)            ; 49 DD CB 7E 86
 res.lis 0, (ix-128)            ; 49 DD CB 80 86
 res.lis 0, (iy)                ; 49 FD CB 00 86
 res.lis 0, (iy+0)              ; 49 FD CB 00 86
 res.lis 0, (iy+126)            ; 49 FD CB 7E 86
 res.lis 0, (iy-128)            ; 49 FD CB 80 86
 res.lis 1, (hl)                ; 49 CB 8E
 res.lis 1, (ix)                ; 49 DD CB 00 8E
 res.lis 1, (ix+0)              ; 49 DD CB 00 8E
 res.lis 1, (ix+126)            ; 49 DD CB 7E 8E
 res.lis 1, (ix-128)            ; 49 DD CB 80 8E
 res.lis 1, (iy)                ; 49 FD CB 00 8E
 res.lis 1, (iy+0)              ; 49 FD CB 00 8E
 res.lis 1, (iy+126)            ; 49 FD CB 7E 8E
 res.lis 1, (iy-128)            ; 49 FD CB 80 8E
 res.lis 2, (hl)                ; 49 CB 96
 res.lis 2, (ix)                ; 49 DD CB 00 96
 res.lis 2, (ix+0)              ; 49 DD CB 00 96
 res.lis 2, (ix+126)            ; 49 DD CB 7E 96
 res.lis 2, (ix-128)            ; 49 DD CB 80 96
 res.lis 2, (iy)                ; 49 FD CB 00 96
 res.lis 2, (iy+0)              ; 49 FD CB 00 96
 res.lis 2, (iy+126)            ; 49 FD CB 7E 96
 res.lis 2, (iy-128)            ; 49 FD CB 80 96
 res.lis 3, (hl)                ; 49 CB 9E
 res.lis 3, (ix)                ; 49 DD CB 00 9E
 res.lis 3, (ix+0)              ; 49 DD CB 00 9E
 res.lis 3, (ix+126)            ; 49 DD CB 7E 9E
 res.lis 3, (ix-128)            ; 49 DD CB 80 9E
 res.lis 3, (iy)                ; 49 FD CB 00 9E
 res.lis 3, (iy+0)              ; 49 FD CB 00 9E
 res.lis 3, (iy+126)            ; 49 FD CB 7E 9E
 res.lis 3, (iy-128)            ; 49 FD CB 80 9E
 res.lis 4, (hl)                ; 49 CB A6
 res.lis 4, (ix)                ; 49 DD CB 00 A6
 res.lis 4, (ix+0)              ; 49 DD CB 00 A6
 res.lis 4, (ix+126)            ; 49 DD CB 7E A6
 res.lis 4, (ix-128)            ; 49 DD CB 80 A6
 res.lis 4, (iy)                ; 49 FD CB 00 A6
 res.lis 4, (iy+0)              ; 49 FD CB 00 A6
 res.lis 4, (iy+126)            ; 49 FD CB 7E A6
 res.lis 4, (iy-128)            ; 49 FD CB 80 A6
 res.lis 5, (hl)                ; 49 CB AE
 res.lis 5, (ix)                ; 49 DD CB 00 AE
 res.lis 5, (ix+0)              ; 49 DD CB 00 AE
 res.lis 5, (ix+126)            ; 49 DD CB 7E AE
 res.lis 5, (ix-128)            ; 49 DD CB 80 AE
 res.lis 5, (iy)                ; 49 FD CB 00 AE
 res.lis 5, (iy+0)              ; 49 FD CB 00 AE
 res.lis 5, (iy+126)            ; 49 FD CB 7E AE
 res.lis 5, (iy-128)            ; 49 FD CB 80 AE
 res.lis 6, (hl)                ; 49 CB B6
 res.lis 6, (ix)                ; 49 DD CB 00 B6
 res.lis 6, (ix+0)              ; 49 DD CB 00 B6
 res.lis 6, (ix+126)            ; 49 DD CB 7E B6
 res.lis 6, (ix-128)            ; 49 DD CB 80 B6
 res.lis 6, (iy)                ; 49 FD CB 00 B6
 res.lis 6, (iy+0)              ; 49 FD CB 00 B6
 res.lis 6, (iy+126)            ; 49 FD CB 7E B6
 res.lis 6, (iy-128)            ; 49 FD CB 80 B6
 res.lis 7, (hl)                ; 49 CB BE
 res.lis 7, (ix)                ; 49 DD CB 00 BE
 res.lis 7, (ix+0)              ; 49 DD CB 00 BE
 res.lis 7, (ix+126)            ; 49 DD CB 7E BE
 res.lis 7, (ix-128)            ; 49 DD CB 80 BE
 res.lis 7, (iy)                ; 49 FD CB 00 BE
 res.lis 7, (iy+0)              ; 49 FD CB 00 BE
 res.lis 7, (iy+126)            ; 49 FD CB 7E BE
 res.lis 7, (iy-128)            ; 49 FD CB 80 BE
 ret                            ; C9
 ret c                          ; D8
 ret m                          ; F8
 ret nc                         ; D0
 ret nz                         ; C0
 ret p                          ; F0
 ret pe                         ; E8
 ret po                         ; E0
 ret z                          ; C8
 ret.l                          ; 49 C9
 ret.l c                        ; 49 D8
 ret.l m                        ; 49 F8
 ret.l nc                       ; 49 D0
 ret.l nz                       ; 49 C0
 ret.l p                        ; 49 F0
 ret.l pe                       ; 49 E8
 ret.l po                       ; 49 E0
 ret.l z                        ; 49 C8
 ret.lis                        ; 49 C9
 ret.lis c                      ; 49 D8
 ret.lis m                      ; 49 F8
 ret.lis nc                     ; 49 D0
 ret.lis nz                     ; 49 C0
 ret.lis p                      ; 49 F0
 ret.lis pe                     ; 49 E8
 ret.lis po                     ; 49 E0
 ret.lis z                      ; 49 C8
 reti                           ; ED 4D
 reti.l                         ; 49 ED 4D
 reti.lis                       ; 49 ED 4D
 retn                           ; ED 45
 retn.l                         ; 49 ED 45
 retn.lis                       ; 49 ED 45
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix+0)                      ; DD CB 00 16
 rl (ix+126)                    ; DD CB 7E 16
 rl (ix-128)                    ; DD CB 80 16
 rl (iy)                        ; FD CB 00 16
 rl (iy+0)                      ; FD CB 00 16
 rl (iy+126)                    ; FD CB 7E 16
 rl (iy-128)                    ; FD CB 80 16
 rl a                           ; CB 17
 rl b                           ; CB 10
 rl c                           ; CB 11
 rl d                           ; CB 12
 rl e                           ; CB 13
 rl h                           ; CB 14
 rl l                           ; CB 15
 rl.l (hl)                      ; 49 CB 16
 rl.l (ix)                      ; 49 DD CB 00 16
 rl.l (ix+0)                    ; 49 DD CB 00 16
 rl.l (ix+126)                  ; 49 DD CB 7E 16
 rl.l (ix-128)                  ; 49 DD CB 80 16
 rl.l (iy)                      ; 49 FD CB 00 16
 rl.l (iy+0)                    ; 49 FD CB 00 16
 rl.l (iy+126)                  ; 49 FD CB 7E 16
 rl.l (iy-128)                  ; 49 FD CB 80 16
 rl.lis (hl)                    ; 49 CB 16
 rl.lis (ix)                    ; 49 DD CB 00 16
 rl.lis (ix+0)                  ; 49 DD CB 00 16
 rl.lis (ix+126)                ; 49 DD CB 7E 16
 rl.lis (ix-128)                ; 49 DD CB 80 16
 rl.lis (iy)                    ; 49 FD CB 00 16
 rl.lis (iy+0)                  ; 49 FD CB 00 16
 rl.lis (iy+126)                ; 49 FD CB 7E 16
 rl.lis (iy-128)                ; 49 FD CB 80 16
 rla                            ; 17
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix+0)                     ; DD CB 00 06
 rlc (ix+126)                   ; DD CB 7E 06
 rlc (ix-128)                   ; DD CB 80 06
 rlc (iy)                       ; FD CB 00 06
 rlc (iy+0)                     ; FD CB 00 06
 rlc (iy+126)                   ; FD CB 7E 06
 rlc (iy-128)                   ; FD CB 80 06
 rlc a                          ; CB 07
 rlc b                          ; CB 00
 rlc c                          ; CB 01
 rlc d                          ; CB 02
 rlc e                          ; CB 03
 rlc h                          ; CB 04
 rlc l                          ; CB 05
 rlc.l (hl)                     ; 49 CB 06
 rlc.l (ix)                     ; 49 DD CB 00 06
 rlc.l (ix+0)                   ; 49 DD CB 00 06
 rlc.l (ix+126)                 ; 49 DD CB 7E 06
 rlc.l (ix-128)                 ; 49 DD CB 80 06
 rlc.l (iy)                     ; 49 FD CB 00 06
 rlc.l (iy+0)                   ; 49 FD CB 00 06
 rlc.l (iy+126)                 ; 49 FD CB 7E 06
 rlc.l (iy-128)                 ; 49 FD CB 80 06
 rlc.lis (hl)                   ; 49 CB 06
 rlc.lis (ix)                   ; 49 DD CB 00 06
 rlc.lis (ix+0)                 ; 49 DD CB 00 06
 rlc.lis (ix+126)               ; 49 DD CB 7E 06
 rlc.lis (ix-128)               ; 49 DD CB 80 06
 rlc.lis (iy)                   ; 49 FD CB 00 06
 rlc.lis (iy+0)                 ; 49 FD CB 00 06
 rlc.lis (iy+126)               ; 49 FD CB 7E 06
 rlc.lis (iy-128)               ; 49 FD CB 80 06
 rlca                           ; 07
 rld                            ; ED 6F
 rr (hl)                        ; CB 1E
 rr (ix)                        ; DD CB 00 1E
 rr (ix+0)                      ; DD CB 00 1E
 rr (ix+126)                    ; DD CB 7E 1E
 rr (ix-128)                    ; DD CB 80 1E
 rr (iy)                        ; FD CB 00 1E
 rr (iy+0)                      ; FD CB 00 1E
 rr (iy+126)                    ; FD CB 7E 1E
 rr (iy-128)                    ; FD CB 80 1E
 rr a                           ; CB 1F
 rr b                           ; CB 18
 rr c                           ; CB 19
 rr d                           ; CB 1A
 rr e                           ; CB 1B
 rr h                           ; CB 1C
 rr l                           ; CB 1D
 rr.l (hl)                      ; 49 CB 1E
 rr.l (ix)                      ; 49 DD CB 00 1E
 rr.l (ix+0)                    ; 49 DD CB 00 1E
 rr.l (ix+126)                  ; 49 DD CB 7E 1E
 rr.l (ix-128)                  ; 49 DD CB 80 1E
 rr.l (iy)                      ; 49 FD CB 00 1E
 rr.l (iy+0)                    ; 49 FD CB 00 1E
 rr.l (iy+126)                  ; 49 FD CB 7E 1E
 rr.l (iy-128)                  ; 49 FD CB 80 1E
 rr.lis (hl)                    ; 49 CB 1E
 rr.lis (ix)                    ; 49 DD CB 00 1E
 rr.lis (ix+0)                  ; 49 DD CB 00 1E
 rr.lis (ix+126)                ; 49 DD CB 7E 1E
 rr.lis (ix-128)                ; 49 DD CB 80 1E
 rr.lis (iy)                    ; 49 FD CB 00 1E
 rr.lis (iy+0)                  ; 49 FD CB 00 1E
 rr.lis (iy+126)                ; 49 FD CB 7E 1E
 rr.lis (iy-128)                ; 49 FD CB 80 1E
 rra                            ; 1F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix+0)                     ; DD CB 00 0E
 rrc (ix+126)                   ; DD CB 7E 0E
 rrc (ix-128)                   ; DD CB 80 0E
 rrc (iy)                       ; FD CB 00 0E
 rrc (iy+0)                     ; FD CB 00 0E
 rrc (iy+126)                   ; FD CB 7E 0E
 rrc (iy-128)                   ; FD CB 80 0E
 rrc a                          ; CB 0F
 rrc b                          ; CB 08
 rrc c                          ; CB 09
 rrc d                          ; CB 0A
 rrc e                          ; CB 0B
 rrc h                          ; CB 0C
 rrc l                          ; CB 0D
 rrc.l (hl)                     ; 49 CB 0E
 rrc.l (ix)                     ; 49 DD CB 00 0E
 rrc.l (ix+0)                   ; 49 DD CB 00 0E
 rrc.l (ix+126)                 ; 49 DD CB 7E 0E
 rrc.l (ix-128)                 ; 49 DD CB 80 0E
 rrc.l (iy)                     ; 49 FD CB 00 0E
 rrc.l (iy+0)                   ; 49 FD CB 00 0E
 rrc.l (iy+126)                 ; 49 FD CB 7E 0E
 rrc.l (iy-128)                 ; 49 FD CB 80 0E
 rrc.lis (hl)                   ; 49 CB 0E
 rrc.lis (ix)                   ; 49 DD CB 00 0E
 rrc.lis (ix+0)                 ; 49 DD CB 00 0E
 rrc.lis (ix+126)               ; 49 DD CB 7E 0E
 rrc.lis (ix-128)               ; 49 DD CB 80 0E
 rrc.lis (iy)                   ; 49 FD CB 00 0E
 rrc.lis (iy+0)                 ; 49 FD CB 00 0E
 rrc.lis (iy+126)               ; 49 FD CB 7E 0E
 rrc.lis (iy-128)               ; 49 FD CB 80 0E
 rrca                           ; 0F
 rrd                            ; ED 67
 rsmix                          ; ED 7E
 rst 0                          ; C7
 rst 16                         ; D7
 rst 24                         ; DF
 rst 32                         ; E7
 rst 40                         ; EF
 rst 48                         ; F7
 rst 56                         ; FF
 rst 8                          ; CF
 rst.l 0                        ; 49 C7
 rst.l 16                       ; 49 D7
 rst.l 24                       ; 49 DF
 rst.l 32                       ; 49 E7
 rst.l 40                       ; 49 EF
 rst.l 48                       ; 49 F7
 rst.l 56                       ; 49 FF
 rst.l 8                        ; 49 CF
 rst.lis 0                      ; 49 C7
 rst.lis 16                     ; 49 D7
 rst.lis 24                     ; 49 DF
 rst.lis 32                     ; 49 E7
 rst.lis 40                     ; 49 EF
 rst.lis 48                     ; 49 F7
 rst.lis 56                     ; 49 FF
 rst.lis 8                      ; 49 CF
 sbc a, (hl)                    ; 9E
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix+0)                  ; DD 9E 00
 sbc a, (ix+126)                ; DD 9E 7E
 sbc a, (ix-128)                ; DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy+0)                  ; FD 9E 00
 sbc a, (iy+126)                ; FD 9E 7E
 sbc a, (iy-128)                ; FD 9E 80
 sbc a, -128                    ; DE 80
 sbc a, 0                       ; DE 00
 sbc a, 127                     ; DE 7F
 sbc a, 255                     ; DE FF
 sbc a, a                       ; 9F
 sbc a, b                       ; 98
 sbc a, c                       ; 99
 sbc a, d                       ; 9A
 sbc a, e                       ; 9B
 sbc a, h                       ; 9C
 sbc a, ixh                     ; DD 9C
 sbc a, ixl                     ; DD 9D
 sbc a, iyh                     ; FD 9C
 sbc a, iyl                     ; FD 9D
 sbc a, l                       ; 9D
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 sbc.l a, (hl)                  ; 49 9E
 sbc.l a, (ix)                  ; 49 DD 9E 00
 sbc.l a, (ix+0)                ; 49 DD 9E 00
 sbc.l a, (ix+126)              ; 49 DD 9E 7E
 sbc.l a, (ix-128)              ; 49 DD 9E 80
 sbc.l a, (iy)                  ; 49 FD 9E 00
 sbc.l a, (iy+0)                ; 49 FD 9E 00
 sbc.l a, (iy+126)              ; 49 FD 9E 7E
 sbc.l a, (iy-128)              ; 49 FD 9E 80
 sbc.l hl, bc                   ; 49 ED 42
 sbc.l hl, de                   ; 49 ED 52
 sbc.l hl, hl                   ; 49 ED 62
 sbc.l hl, sp                   ; 49 ED 72
 sbc.lis a, (hl)                ; 49 9E
 sbc.lis a, (ix)                ; 49 DD 9E 00
 sbc.lis a, (ix+0)              ; 49 DD 9E 00
 sbc.lis a, (ix+126)            ; 49 DD 9E 7E
 sbc.lis a, (ix-128)            ; 49 DD 9E 80
 sbc.lis a, (iy)                ; 49 FD 9E 00
 sbc.lis a, (iy+0)              ; 49 FD 9E 00
 sbc.lis a, (iy+126)            ; 49 FD 9E 7E
 sbc.lis a, (iy-128)            ; 49 FD 9E 80
 sbc.lis hl, bc                 ; 49 ED 42
 sbc.lis hl, de                 ; 49 ED 52
 sbc.lis hl, hl                 ; 49 ED 62
 sbc.lis hl, sp                 ; 49 ED 72
 scf                            ; 37
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; DD CB 00 C6
 set 0, (ix+0)                  ; DD CB 00 C6
 set 0, (ix+126)                ; DD CB 7E C6
 set 0, (ix-128)                ; DD CB 80 C6
 set 0, (iy)                    ; FD CB 00 C6
 set 0, (iy+0)                  ; FD CB 00 C6
 set 0, (iy+126)                ; FD CB 7E C6
 set 0, (iy-128)                ; FD CB 80 C6
 set 0, a                       ; CB C7
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, l                       ; CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; DD CB 00 CE
 set 1, (ix+0)                  ; DD CB 00 CE
 set 1, (ix+126)                ; DD CB 7E CE
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy+0)                  ; FD CB 00 CE
 set 1, (iy+126)                ; FD CB 7E CE
 set 1, (iy-128)                ; FD CB 80 CE
 set 1, a                       ; CB CF
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, l                       ; CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; DD CB 00 D6
 set 2, (ix+0)                  ; DD CB 00 D6
 set 2, (ix+126)                ; DD CB 7E D6
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy+0)                  ; FD CB 00 D6
 set 2, (iy+126)                ; FD CB 7E D6
 set 2, (iy-128)                ; FD CB 80 D6
 set 2, a                       ; CB D7
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, l                       ; CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; DD CB 00 DE
 set 3, (ix+0)                  ; DD CB 00 DE
 set 3, (ix+126)                ; DD CB 7E DE
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy+0)                  ; FD CB 00 DE
 set 3, (iy+126)                ; FD CB 7E DE
 set 3, (iy-128)                ; FD CB 80 DE
 set 3, a                       ; CB DF
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, l                       ; CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; DD CB 00 E6
 set 4, (ix+0)                  ; DD CB 00 E6
 set 4, (ix+126)                ; DD CB 7E E6
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy+0)                  ; FD CB 00 E6
 set 4, (iy+126)                ; FD CB 7E E6
 set 4, (iy-128)                ; FD CB 80 E6
 set 4, a                       ; CB E7
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, l                       ; CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; DD CB 00 EE
 set 5, (ix+0)                  ; DD CB 00 EE
 set 5, (ix+126)                ; DD CB 7E EE
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy+0)                  ; FD CB 00 EE
 set 5, (iy+126)                ; FD CB 7E EE
 set 5, (iy-128)                ; FD CB 80 EE
 set 5, a                       ; CB EF
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, l                       ; CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; DD CB 00 F6
 set 6, (ix+0)                  ; DD CB 00 F6
 set 6, (ix+126)                ; DD CB 7E F6
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy+0)                  ; FD CB 00 F6
 set 6, (iy+126)                ; FD CB 7E F6
 set 6, (iy-128)                ; FD CB 80 F6
 set 6, a                       ; CB F7
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, l                       ; CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; DD CB 00 FE
 set 7, (ix+0)                  ; DD CB 00 FE
 set 7, (ix+126)                ; DD CB 7E FE
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy+0)                  ; FD CB 00 FE
 set 7, (iy+126)                ; FD CB 7E FE
 set 7, (iy-128)                ; FD CB 80 FE
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 set.l 0, (hl)                  ; 49 CB C6
 set.l 0, (ix)                  ; 49 DD CB 00 C6
 set.l 0, (ix+0)                ; 49 DD CB 00 C6
 set.l 0, (ix+126)              ; 49 DD CB 7E C6
 set.l 0, (ix-128)              ; 49 DD CB 80 C6
 set.l 0, (iy)                  ; 49 FD CB 00 C6
 set.l 0, (iy+0)                ; 49 FD CB 00 C6
 set.l 0, (iy+126)              ; 49 FD CB 7E C6
 set.l 0, (iy-128)              ; 49 FD CB 80 C6
 set.l 1, (hl)                  ; 49 CB CE
 set.l 1, (ix)                  ; 49 DD CB 00 CE
 set.l 1, (ix+0)                ; 49 DD CB 00 CE
 set.l 1, (ix+126)              ; 49 DD CB 7E CE
 set.l 1, (ix-128)              ; 49 DD CB 80 CE
 set.l 1, (iy)                  ; 49 FD CB 00 CE
 set.l 1, (iy+0)                ; 49 FD CB 00 CE
 set.l 1, (iy+126)              ; 49 FD CB 7E CE
 set.l 1, (iy-128)              ; 49 FD CB 80 CE
 set.l 2, (hl)                  ; 49 CB D6
 set.l 2, (ix)                  ; 49 DD CB 00 D6
 set.l 2, (ix+0)                ; 49 DD CB 00 D6
 set.l 2, (ix+126)              ; 49 DD CB 7E D6
 set.l 2, (ix-128)              ; 49 DD CB 80 D6
 set.l 2, (iy)                  ; 49 FD CB 00 D6
 set.l 2, (iy+0)                ; 49 FD CB 00 D6
 set.l 2, (iy+126)              ; 49 FD CB 7E D6
 set.l 2, (iy-128)              ; 49 FD CB 80 D6
 set.l 3, (hl)                  ; 49 CB DE
 set.l 3, (ix)                  ; 49 DD CB 00 DE
 set.l 3, (ix+0)                ; 49 DD CB 00 DE
 set.l 3, (ix+126)              ; 49 DD CB 7E DE
 set.l 3, (ix-128)              ; 49 DD CB 80 DE
 set.l 3, (iy)                  ; 49 FD CB 00 DE
 set.l 3, (iy+0)                ; 49 FD CB 00 DE
 set.l 3, (iy+126)              ; 49 FD CB 7E DE
 set.l 3, (iy-128)              ; 49 FD CB 80 DE
 set.l 4, (hl)                  ; 49 CB E6
 set.l 4, (ix)                  ; 49 DD CB 00 E6
 set.l 4, (ix+0)                ; 49 DD CB 00 E6
 set.l 4, (ix+126)              ; 49 DD CB 7E E6
 set.l 4, (ix-128)              ; 49 DD CB 80 E6
 set.l 4, (iy)                  ; 49 FD CB 00 E6
 set.l 4, (iy+0)                ; 49 FD CB 00 E6
 set.l 4, (iy+126)              ; 49 FD CB 7E E6
 set.l 4, (iy-128)              ; 49 FD CB 80 E6
 set.l 5, (hl)                  ; 49 CB EE
 set.l 5, (ix)                  ; 49 DD CB 00 EE
 set.l 5, (ix+0)                ; 49 DD CB 00 EE
 set.l 5, (ix+126)              ; 49 DD CB 7E EE
 set.l 5, (ix-128)              ; 49 DD CB 80 EE
 set.l 5, (iy)                  ; 49 FD CB 00 EE
 set.l 5, (iy+0)                ; 49 FD CB 00 EE
 set.l 5, (iy+126)              ; 49 FD CB 7E EE
 set.l 5, (iy-128)              ; 49 FD CB 80 EE
 set.l 6, (hl)                  ; 49 CB F6
 set.l 6, (ix)                  ; 49 DD CB 00 F6
 set.l 6, (ix+0)                ; 49 DD CB 00 F6
 set.l 6, (ix+126)              ; 49 DD CB 7E F6
 set.l 6, (ix-128)              ; 49 DD CB 80 F6
 set.l 6, (iy)                  ; 49 FD CB 00 F6
 set.l 6, (iy+0)                ; 49 FD CB 00 F6
 set.l 6, (iy+126)              ; 49 FD CB 7E F6
 set.l 6, (iy-128)              ; 49 FD CB 80 F6
 set.l 7, (hl)                  ; 49 CB FE
 set.l 7, (ix)                  ; 49 DD CB 00 FE
 set.l 7, (ix+0)                ; 49 DD CB 00 FE
 set.l 7, (ix+126)              ; 49 DD CB 7E FE
 set.l 7, (ix-128)              ; 49 DD CB 80 FE
 set.l 7, (iy)                  ; 49 FD CB 00 FE
 set.l 7, (iy+0)                ; 49 FD CB 00 FE
 set.l 7, (iy+126)              ; 49 FD CB 7E FE
 set.l 7, (iy-128)              ; 49 FD CB 80 FE
 set.lis 0, (hl)                ; 49 CB C6
 set.lis 0, (ix)                ; 49 DD CB 00 C6
 set.lis 0, (ix+0)              ; 49 DD CB 00 C6
 set.lis 0, (ix+126)            ; 49 DD CB 7E C6
 set.lis 0, (ix-128)            ; 49 DD CB 80 C6
 set.lis 0, (iy)                ; 49 FD CB 00 C6
 set.lis 0, (iy+0)              ; 49 FD CB 00 C6
 set.lis 0, (iy+126)            ; 49 FD CB 7E C6
 set.lis 0, (iy-128)            ; 49 FD CB 80 C6
 set.lis 1, (hl)                ; 49 CB CE
 set.lis 1, (ix)                ; 49 DD CB 00 CE
 set.lis 1, (ix+0)              ; 49 DD CB 00 CE
 set.lis 1, (ix+126)            ; 49 DD CB 7E CE
 set.lis 1, (ix-128)            ; 49 DD CB 80 CE
 set.lis 1, (iy)                ; 49 FD CB 00 CE
 set.lis 1, (iy+0)              ; 49 FD CB 00 CE
 set.lis 1, (iy+126)            ; 49 FD CB 7E CE
 set.lis 1, (iy-128)            ; 49 FD CB 80 CE
 set.lis 2, (hl)                ; 49 CB D6
 set.lis 2, (ix)                ; 49 DD CB 00 D6
 set.lis 2, (ix+0)              ; 49 DD CB 00 D6
 set.lis 2, (ix+126)            ; 49 DD CB 7E D6
 set.lis 2, (ix-128)            ; 49 DD CB 80 D6
 set.lis 2, (iy)                ; 49 FD CB 00 D6
 set.lis 2, (iy+0)              ; 49 FD CB 00 D6
 set.lis 2, (iy+126)            ; 49 FD CB 7E D6
 set.lis 2, (iy-128)            ; 49 FD CB 80 D6
 set.lis 3, (hl)                ; 49 CB DE
 set.lis 3, (ix)                ; 49 DD CB 00 DE
 set.lis 3, (ix+0)              ; 49 DD CB 00 DE
 set.lis 3, (ix+126)            ; 49 DD CB 7E DE
 set.lis 3, (ix-128)            ; 49 DD CB 80 DE
 set.lis 3, (iy)                ; 49 FD CB 00 DE
 set.lis 3, (iy+0)              ; 49 FD CB 00 DE
 set.lis 3, (iy+126)            ; 49 FD CB 7E DE
 set.lis 3, (iy-128)            ; 49 FD CB 80 DE
 set.lis 4, (hl)                ; 49 CB E6
 set.lis 4, (ix)                ; 49 DD CB 00 E6
 set.lis 4, (ix+0)              ; 49 DD CB 00 E6
 set.lis 4, (ix+126)            ; 49 DD CB 7E E6
 set.lis 4, (ix-128)            ; 49 DD CB 80 E6
 set.lis 4, (iy)                ; 49 FD CB 00 E6
 set.lis 4, (iy+0)              ; 49 FD CB 00 E6
 set.lis 4, (iy+126)            ; 49 FD CB 7E E6
 set.lis 4, (iy-128)            ; 49 FD CB 80 E6
 set.lis 5, (hl)                ; 49 CB EE
 set.lis 5, (ix)                ; 49 DD CB 00 EE
 set.lis 5, (ix+0)              ; 49 DD CB 00 EE
 set.lis 5, (ix+126)            ; 49 DD CB 7E EE
 set.lis 5, (ix-128)            ; 49 DD CB 80 EE
 set.lis 5, (iy)                ; 49 FD CB 00 EE
 set.lis 5, (iy+0)              ; 49 FD CB 00 EE
 set.lis 5, (iy+126)            ; 49 FD CB 7E EE
 set.lis 5, (iy-128)            ; 49 FD CB 80 EE
 set.lis 6, (hl)                ; 49 CB F6
 set.lis 6, (ix)                ; 49 DD CB 00 F6
 set.lis 6, (ix+0)              ; 49 DD CB 00 F6
 set.lis 6, (ix+126)            ; 49 DD CB 7E F6
 set.lis 6, (ix-128)            ; 49 DD CB 80 F6
 set.lis 6, (iy)                ; 49 FD CB 00 F6
 set.lis 6, (iy+0)              ; 49 FD CB 00 F6
 set.lis 6, (iy+126)            ; 49 FD CB 7E F6
 set.lis 6, (iy-128)            ; 49 FD CB 80 F6
 set.lis 7, (hl)                ; 49 CB FE
 set.lis 7, (ix)                ; 49 DD CB 00 FE
 set.lis 7, (ix+0)              ; 49 DD CB 00 FE
 set.lis 7, (ix+126)            ; 49 DD CB 7E FE
 set.lis 7, (ix-128)            ; 49 DD CB 80 FE
 set.lis 7, (iy)                ; 49 FD CB 00 FE
 set.lis 7, (iy+0)              ; 49 FD CB 00 FE
 set.lis 7, (iy+126)            ; 49 FD CB 7E FE
 set.lis 7, (iy-128)            ; 49 FD CB 80 FE
 sla (hl)                       ; CB 26
 sla (ix)                       ; DD CB 00 26
 sla (ix+0)                     ; DD CB 00 26
 sla (ix+126)                   ; DD CB 7E 26
 sla (ix-128)                   ; DD CB 80 26
 sla (iy)                       ; FD CB 00 26
 sla (iy+0)                     ; FD CB 00 26
 sla (iy+126)                   ; FD CB 7E 26
 sla (iy-128)                   ; FD CB 80 26
 sla a                          ; CB 27
 sla b                          ; CB 20
 sla c                          ; CB 21
 sla d                          ; CB 22
 sla e                          ; CB 23
 sla h                          ; CB 24
 sla l                          ; CB 25
 sla.l (hl)                     ; 49 CB 26
 sla.l (ix)                     ; 49 DD CB 00 26
 sla.l (ix+0)                   ; 49 DD CB 00 26
 sla.l (ix+126)                 ; 49 DD CB 7E 26
 sla.l (ix-128)                 ; 49 DD CB 80 26
 sla.l (iy)                     ; 49 FD CB 00 26
 sla.l (iy+0)                   ; 49 FD CB 00 26
 sla.l (iy+126)                 ; 49 FD CB 7E 26
 sla.l (iy-128)                 ; 49 FD CB 80 26
 sla.lis (hl)                   ; 49 CB 26
 sla.lis (ix)                   ; 49 DD CB 00 26
 sla.lis (ix+0)                 ; 49 DD CB 00 26
 sla.lis (ix+126)               ; 49 DD CB 7E 26
 sla.lis (ix-128)               ; 49 DD CB 80 26
 sla.lis (iy)                   ; 49 FD CB 00 26
 sla.lis (iy+0)                 ; 49 FD CB 00 26
 sla.lis (iy+126)               ; 49 FD CB 7E 26
 sla.lis (iy-128)               ; 49 FD CB 80 26
 slp                            ; ED 76
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix+0)                     ; DD CB 00 2E
 sra (ix+126)                   ; DD CB 7E 2E
 sra (ix-128)                   ; DD CB 80 2E
 sra (iy)                       ; FD CB 00 2E
 sra (iy+0)                     ; FD CB 00 2E
 sra (iy+126)                   ; FD CB 7E 2E
 sra (iy-128)                   ; FD CB 80 2E
 sra a                          ; CB 2F
 sra b                          ; CB 28
 sra c                          ; CB 29
 sra d                          ; CB 2A
 sra e                          ; CB 2B
 sra h                          ; CB 2C
 sra l                          ; CB 2D
 sra.l (hl)                     ; 49 CB 2E
 sra.l (ix)                     ; 49 DD CB 00 2E
 sra.l (ix+0)                   ; 49 DD CB 00 2E
 sra.l (ix+126)                 ; 49 DD CB 7E 2E
 sra.l (ix-128)                 ; 49 DD CB 80 2E
 sra.l (iy)                     ; 49 FD CB 00 2E
 sra.l (iy+0)                   ; 49 FD CB 00 2E
 sra.l (iy+126)                 ; 49 FD CB 7E 2E
 sra.l (iy-128)                 ; 49 FD CB 80 2E
 sra.lis (hl)                   ; 49 CB 2E
 sra.lis (ix)                   ; 49 DD CB 00 2E
 sra.lis (ix+0)                 ; 49 DD CB 00 2E
 sra.lis (ix+126)               ; 49 DD CB 7E 2E
 sra.lis (ix-128)               ; 49 DD CB 80 2E
 sra.lis (iy)                   ; 49 FD CB 00 2E
 sra.lis (iy+0)                 ; 49 FD CB 00 2E
 sra.lis (iy+126)               ; 49 FD CB 7E 2E
 sra.lis (iy-128)               ; 49 FD CB 80 2E
 srl (hl)                       ; CB 3E
 srl (ix)                       ; DD CB 00 3E
 srl (ix+0)                     ; DD CB 00 3E
 srl (ix+126)                   ; DD CB 7E 3E
 srl (ix-128)                   ; DD CB 80 3E
 srl (iy)                       ; FD CB 00 3E
 srl (iy+0)                     ; FD CB 00 3E
 srl (iy+126)                   ; FD CB 7E 3E
 srl (iy-128)                   ; FD CB 80 3E
 srl a                          ; CB 3F
 srl b                          ; CB 38
 srl c                          ; CB 39
 srl d                          ; CB 3A
 srl e                          ; CB 3B
 srl h                          ; CB 3C
 srl l                          ; CB 3D
 srl.l (hl)                     ; 49 CB 3E
 srl.l (ix)                     ; 49 DD CB 00 3E
 srl.l (ix+0)                   ; 49 DD CB 00 3E
 srl.l (ix+126)                 ; 49 DD CB 7E 3E
 srl.l (ix-128)                 ; 49 DD CB 80 3E
 srl.l (iy)                     ; 49 FD CB 00 3E
 srl.l (iy+0)                   ; 49 FD CB 00 3E
 srl.l (iy+126)                 ; 49 FD CB 7E 3E
 srl.l (iy-128)                 ; 49 FD CB 80 3E
 srl.lis (hl)                   ; 49 CB 3E
 srl.lis (ix)                   ; 49 DD CB 00 3E
 srl.lis (ix+0)                 ; 49 DD CB 00 3E
 srl.lis (ix+126)               ; 49 DD CB 7E 3E
 srl.lis (ix-128)               ; 49 DD CB 80 3E
 srl.lis (iy)                   ; 49 FD CB 00 3E
 srl.lis (iy+0)                 ; 49 FD CB 00 3E
 srl.lis (iy+126)               ; 49 FD CB 7E 3E
 srl.lis (iy-128)               ; 49 FD CB 80 3E
 stmix                          ; ED 7D
 sub a, (hl)                    ; 96
 sub a, (ix)                    ; DD 96 00
 sub a, (ix+0)                  ; DD 96 00
 sub a, (ix+126)                ; DD 96 7E
 sub a, (ix-128)                ; DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy+0)                  ; FD 96 00
 sub a, (iy+126)                ; FD 96 7E
 sub a, (iy-128)                ; FD 96 80
 sub a, -128                    ; D6 80
 sub a, 0                       ; D6 00
 sub a, 127                     ; D6 7F
 sub a, 255                     ; D6 FF
 sub a, a                       ; 97
 sub a, b                       ; 90
 sub a, c                       ; 91
 sub a, d                       ; 92
 sub a, e                       ; 93
 sub a, h                       ; 94
 sub a, ixh                     ; DD 94
 sub a, ixl                     ; DD 95
 sub a, iyh                     ; FD 94
 sub a, iyl                     ; FD 95
 sub a, l                       ; 95
 sub.l a, (hl)                  ; 49 96
 sub.l a, (ix)                  ; 49 DD 96 00
 sub.l a, (ix+0)                ; 49 DD 96 00
 sub.l a, (ix+126)              ; 49 DD 96 7E
 sub.l a, (ix-128)              ; 49 DD 96 80
 sub.l a, (iy)                  ; 49 FD 96 00
 sub.l a, (iy+0)                ; 49 FD 96 00
 sub.l a, (iy+126)              ; 49 FD 96 7E
 sub.l a, (iy-128)              ; 49 FD 96 80
 sub.lis a, (hl)                ; 49 96
 sub.lis a, (ix)                ; 49 DD 96 00
 sub.lis a, (ix+0)              ; 49 DD 96 00
 sub.lis a, (ix+126)            ; 49 DD 96 7E
 sub.lis a, (ix-128)            ; 49 DD 96 80
 sub.lis a, (iy)                ; 49 FD 96 00
 sub.lis a, (iy+0)              ; 49 FD 96 00
 sub.lis a, (iy+126)            ; 49 FD 96 7E
 sub.lis a, (iy-128)            ; 49 FD 96 80
 tst a, (hl)                    ; ED 34
 tst a, -128                    ; ED 64 80
 tst a, 0                       ; ED 64 00
 tst a, 127                     ; ED 64 7F
 tst a, 255                     ; ED 64 FF
 tst a, a                       ; ED 3C
 tst a, b                       ; ED 04
 tst a, c                       ; ED 0C
 tst a, d                       ; ED 14
 tst a, e                       ; ED 1C
 tst a, h                       ; ED 24
 tst a, l                       ; ED 2C
 tst.l a, (hl)                  ; 49 ED 34
 tst.lis a, (hl)                ; 49 ED 34
 tstio -128                     ; ED 74 80
 tstio 0                        ; ED 74 00
 tstio 127                      ; ED 74 7F
 tstio 255                      ; ED 74 FF
 xor a, (hl)                    ; AE
 xor a, (ix)                    ; DD AE 00
 xor a, (ix+0)                  ; DD AE 00
 xor a, (ix+126)                ; DD AE 7E
 xor a, (ix-128)                ; DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy+0)                  ; FD AE 00
 xor a, (iy+126)                ; FD AE 7E
 xor a, (iy-128)                ; FD AE 80
 xor a, -128                    ; EE 80
 xor a, 0                       ; EE 00
 xor a, 127                     ; EE 7F
 xor a, 255                     ; EE FF
 xor a, a                       ; AF
 xor a, b                       ; A8
 xor a, c                       ; A9
 xor a, d                       ; AA
 xor a, e                       ; AB
 xor a, h                       ; AC
 xor a, ixh                     ; DD AC
 xor a, ixl                     ; DD AD
 xor a, iyh                     ; FD AC
 xor a, iyl                     ; FD AD
 xor a, l                       ; AD
 xor.l a, (hl)                  ; 49 AE
 xor.l a, (ix)                  ; 49 DD AE 00
 xor.l a, (ix+0)                ; 49 DD AE 00
 xor.l a, (ix+126)              ; 49 DD AE 7E
 xor.l a, (ix-128)              ; 49 DD AE 80
 xor.l a, (iy)                  ; 49 FD AE 00
 xor.l a, (iy+0)                ; 49 FD AE 00
 xor.l a, (iy+126)              ; 49 FD AE 7E
 xor.l a, (iy-128)              ; 49 FD AE 80
 xor.lis a, (hl)                ; 49 AE
 xor.lis a, (ix)                ; 49 DD AE 00
 xor.lis a, (ix+0)              ; 49 DD AE 00
 xor.lis a, (ix+126)            ; 49 DD AE 7E
 xor.lis a, (ix-128)            ; 49 DD AE 80
 xor.lis a, (iy)                ; 49 FD AE 00
 xor.lis a, (iy+0)              ; 49 FD AE 00
 xor.lis a, (iy+126)            ; 49 FD AE 7E
 xor.lis a, (iy-128)            ; 49 FD AE 80
