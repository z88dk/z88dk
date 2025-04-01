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
 and (hl)                       ; A6
 and (ix)                       ; DD A6 00
 and (ix+0)                     ; DD A6 00
 and (ix+126)                   ; DD A6 7E
 and (ix-128)                   ; DD A6 80
 and (iy)                       ; FD A6 00
 and (iy+0)                     ; FD A6 00
 and (iy+126)                   ; FD A6 7E
 and (iy-128)                   ; FD A6 80
 and -128                       ; E6 80
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, ixh                     ; DD A4
 and a, ixl                     ; DD A5
 and a, iyh                     ; FD A4
 and a, iyl                     ; FD A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and l                          ; A5
 and.l (ix)                     ; 49 DD A6 00
 and.l (ix+0)                   ; 49 DD A6 00
 and.l (ix+126)                 ; 49 DD A6 7E
 and.l (ix-128)                 ; 49 DD A6 80
 and.l (iy)                     ; 49 FD A6 00
 and.l (iy+0)                   ; 49 FD A6 00
 and.l (iy+126)                 ; 49 FD A6 7E
 and.l (iy-128)                 ; 49 FD A6 80
 and.l a, (hl)                  ; 49 A6
 and.lis (ix)                   ; 49 DD A6 00
 and.lis (ix+0)                 ; 49 DD A6 00
 and.lis (ix+126)               ; 49 DD A6 7E
 and.lis (ix-128)               ; 49 DD A6 80
 and.lis (iy)                   ; 49 FD A6 00
 and.lis (iy+0)                 ; 49 FD A6 00
 and.lis (iy+126)               ; 49 FD A6 7E
 and.lis (iy-128)               ; 49 FD A6 80
 and.lis a, (hl)                ; 49 A6
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
 cp (hl)                        ; BE
 cp (ix)                        ; DD BE 00
 cp (ix+0)                      ; DD BE 00
 cp (ix+126)                    ; DD BE 7E
 cp (ix-128)                    ; DD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy+0)                      ; FD BE 00
 cp (iy+126)                    ; FD BE 7E
 cp (iy-128)                    ; FD BE 80
 cp -128                        ; FE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp ixh                         ; DD BC
 cp ixl                         ; DD BD
 cp iyh                         ; FD BC
 cp iyl                         ; FD BD
 cp l                           ; BD
 cp.l (hl)                      ; 49 BE
 cp.l (ix)                      ; 49 DD BE 00
 cp.l (ix+0)                    ; 49 DD BE 00
 cp.l (ix+126)                  ; 49 DD BE 7E
 cp.l (ix-128)                  ; 49 DD BE 80
 cp.l (iy)                      ; 49 FD BE 00
 cp.l (iy+0)                    ; 49 FD BE 00
 cp.l (iy+126)                  ; 49 FD BE 7E
 cp.l (iy-128)                  ; 49 FD BE 80
 cp.lis (hl)                    ; 49 BE
 cp.lis (ix)                    ; 49 DD BE 00
 cp.lis (ix+0)                  ; 49 DD BE 00
 cp.lis (ix+126)                ; 49 DD BE 7E
 cp.lis (ix-128)                ; 49 DD BE 80
 cp.lis (iy)                    ; 49 FD BE 00
 cp.lis (iy+0)                  ; 49 FD BE 00
 cp.lis (iy+126)                ; 49 FD BE 7E
 cp.lis (iy-128)                ; 49 FD BE 80
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
 dec bc                         ; 0B
 dec de                         ; 1B
 dec hl                         ; 2B
 dec sp                         ; 3B
 dec.l bc                       ; 49 0B
 dec.l de                       ; 49 1B
 dec.l hl                       ; 49 2B
 dec.l sp                       ; 49 3B
 dec.lis bc                     ; 49 0B
 dec.lis de                     ; 49 1B
 dec.lis hl                     ; 49 2B
 dec.lis sp                     ; 49 3B
 inc bc                         ; 03
 inc de                         ; 13
 inc hl                         ; 23
 inc sp                         ; 33
 inc.l bc                       ; 49 03
 inc.l de                       ; 49 13
 inc.l hl                       ; 49 23
 inc.l sp                       ; 49 33
 inc.lis bc                     ; 49 03
 inc.lis de                     ; 49 13
 inc.lis hl                     ; 49 23
 inc.lis sp                     ; 49 33
 or (hl)                        ; B6
 or (ix)                        ; DD B6 00
 or (ix+0)                      ; DD B6 00
 or (ix+126)                    ; DD B6 7E
 or (ix-128)                    ; DD B6 80
 or (iy)                        ; FD B6 00
 or (iy+0)                      ; FD B6 00
 or (iy+126)                    ; FD B6 7E
 or (iy-128)                    ; FD B6 80
 or -128                        ; F6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or ixh                         ; DD B4
 or ixl                         ; DD B5
 or iyh                         ; FD B4
 or iyl                         ; FD B5
 or l                           ; B5
 or.l (hl)                      ; 49 B6
 or.l (ix)                      ; 49 DD B6 00
 or.l (ix+0)                    ; 49 DD B6 00
 or.l (ix+126)                  ; 49 DD B6 7E
 or.l (ix-128)                  ; 49 DD B6 80
 or.l (iy)                      ; 49 FD B6 00
 or.l (iy+0)                    ; 49 FD B6 00
 or.l (iy+126)                  ; 49 FD B6 7E
 or.l (iy-128)                  ; 49 FD B6 80
 or.lis (hl)                    ; 49 B6
 or.lis (ix)                    ; 49 DD B6 00
 or.lis (ix+0)                  ; 49 DD B6 00
 or.lis (ix+126)                ; 49 DD B6 7E
 or.lis (ix-128)                ; 49 DD B6 80
 or.lis (iy)                    ; 49 FD B6 00
 or.lis (iy+0)                  ; 49 FD B6 00
 or.lis (iy+126)                ; 49 FD B6 7E
 or.lis (iy-128)                ; 49 FD B6 80
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
 sub (hl)                       ; 96
 sub (ix)                       ; DD 96 00
 sub (ix+0)                     ; DD 96 00
 sub (ix+126)                   ; DD 96 7E
 sub (ix-128)                   ; DD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy+0)                     ; FD 96 00
 sub (iy+126)                   ; FD 96 7E
 sub (iy-128)                   ; FD 96 80
 sub -128                       ; D6 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub ixh                        ; DD 94
 sub ixl                        ; DD 95
 sub iyh                        ; FD 94
 sub iyl                        ; FD 95
 sub l                          ; 95
 sub.l (hl)                     ; 49 96
 sub.l (ix)                     ; 49 DD 96 00
 sub.l (ix+0)                   ; 49 DD 96 00
 sub.l (ix+126)                 ; 49 DD 96 7E
 sub.l (ix-128)                 ; 49 DD 96 80
 sub.l (iy)                     ; 49 FD 96 00
 sub.l (iy+0)                   ; 49 FD 96 00
 sub.l (iy+126)                 ; 49 FD 96 7E
 sub.l (iy-128)                 ; 49 FD 96 80
 sub.lis (hl)                   ; 49 96
 sub.lis (ix)                   ; 49 DD 96 00
 sub.lis (ix+0)                 ; 49 DD 96 00
 sub.lis (ix+126)               ; 49 DD 96 7E
 sub.lis (ix-128)               ; 49 DD 96 80
 sub.lis (iy)                   ; 49 FD 96 00
 sub.lis (iy+0)                 ; 49 FD 96 00
 sub.lis (iy+126)               ; 49 FD 96 7E
 sub.lis (iy-128)               ; 49 FD 96 80
 xor (hl)                       ; AE
 xor (ix)                       ; DD AE 00
 xor (ix+0)                     ; DD AE 00
 xor (ix+126)                   ; DD AE 7E
 xor (ix-128)                   ; DD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy+0)                     ; FD AE 00
 xor (iy+126)                   ; FD AE 7E
 xor (iy-128)                   ; FD AE 80
 xor -128                       ; EE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor b                          ; A8
 xor c                          ; A9
 xor d                          ; AA
 xor e                          ; AB
 xor h                          ; AC
 xor ixh                        ; DD AC
 xor ixl                        ; DD AD
 xor iyh                        ; FD AC
 xor iyl                        ; FD AD
 xor l                          ; AD
 xor.l (hl)                     ; 49 AE
 xor.l (ix)                     ; 49 DD AE 00
 xor.l (ix+0)                   ; 49 DD AE 00
 xor.l (ix+126)                 ; 49 DD AE 7E
 xor.l (ix-128)                 ; 49 DD AE 80
 xor.l (iy)                     ; 49 FD AE 00
 xor.l (iy+0)                   ; 49 FD AE 00
 xor.l (iy+126)                 ; 49 FD AE 7E
 xor.l (iy-128)                 ; 49 FD AE 80
 xor.lis (hl)                   ; 49 AE
 xor.lis (ix)                   ; 49 DD AE 00
 xor.lis (ix+0)                 ; 49 DD AE 00
 xor.lis (ix+126)               ; 49 DD AE 7E
 xor.lis (ix-128)               ; 49 DD AE 80
 xor.lis (iy)                   ; 49 FD AE 00
 xor.lis (iy+0)                 ; 49 FD AE 00
 xor.lis (iy+126)               ; 49 FD AE 7E
 xor.lis (iy-128)               ; 49 FD AE 80
