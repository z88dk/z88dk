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
 jp.is 0x1234                   ; 40 C3 34 12
 jp.is c, 0x1234                ; 40 DA 34 12
 jp.is m, 0x1234                ; 40 FA 34 12
 jp.is nc, 0x1234               ; 40 D2 34 12
 jp.is nz, 0x1234               ; 40 C2 34 12
 jp.is p, 0x1234                ; 40 F2 34 12
 jp.is pe, 0x1234               ; 40 EA 34 12
 jp.is po, 0x1234               ; 40 E2 34 12
 jp.is z, 0x1234                ; 40 CA 34 12
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
 ld (ix), a                     ; DD 77 00
 ld (ix), b                     ; DD 70 00
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), l                     ; DD 75 00
 ld (ix+0), a                   ; DD 77 00
 ld (ix+0), b                   ; DD 70 00
 ld (ix+0), c                   ; DD 71 00
 ld (ix+0), d                   ; DD 72 00
 ld (ix+0), e                   ; DD 73 00
 ld (ix+0), h                   ; DD 74 00
 ld (ix+0), l                   ; DD 75 00
 ld (ix+126), a                 ; DD 77 7E
 ld (ix+126), b                 ; DD 70 7E
 ld (ix+126), c                 ; DD 71 7E
 ld (ix+126), d                 ; DD 72 7E
 ld (ix+126), e                 ; DD 73 7E
 ld (ix+126), h                 ; DD 74 7E
 ld (ix+126), l                 ; DD 75 7E
 ld (ix-128), a                 ; DD 77 80
 ld (ix-128), b                 ; DD 70 80
 ld (ix-128), c                 ; DD 71 80
 ld (ix-128), d                 ; DD 72 80
 ld (ix-128), e                 ; DD 73 80
 ld (ix-128), h                 ; DD 74 80
 ld (ix-128), l                 ; DD 75 80
 ld (iy), a                     ; FD 77 00
 ld (iy), b                     ; FD 70 00
 ld (iy), c                     ; FD 71 00
 ld (iy), d                     ; FD 72 00
 ld (iy), e                     ; FD 73 00
 ld (iy), h                     ; FD 74 00
 ld (iy), l                     ; FD 75 00
 ld (iy+0), a                   ; FD 77 00
 ld (iy+0), b                   ; FD 70 00
 ld (iy+0), c                   ; FD 71 00
 ld (iy+0), d                   ; FD 72 00
 ld (iy+0), e                   ; FD 73 00
 ld (iy+0), h                   ; FD 74 00
 ld (iy+0), l                   ; FD 75 00
 ld (iy+126), a                 ; FD 77 7E
 ld (iy+126), b                 ; FD 70 7E
 ld (iy+126), c                 ; FD 71 7E
 ld (iy+126), d                 ; FD 72 7E
 ld (iy+126), e                 ; FD 73 7E
 ld (iy+126), h                 ; FD 74 7E
 ld (iy+126), l                 ; FD 75 7E
 ld (iy-128), a                 ; FD 77 80
 ld (iy-128), b                 ; FD 70 80
 ld (iy-128), c                 ; FD 71 80
 ld (iy-128), d                 ; FD 72 80
 ld (iy-128), e                 ; FD 73 80
 ld (iy-128), h                 ; FD 74 80
 ld (iy-128), l                 ; FD 75 80
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix+0)                   ; DD 7E 00
 ld a, (ix+126)                 ; DD 7E 7E
 ld a, (ix-128)                 ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy+0)                   ; FD 7E 00
 ld a, (iy+126)                 ; FD 7E 7E
 ld a, (iy-128)                 ; FD 7E 80
 ld a, i                        ; ED 57
 ld a, r                        ; ED 5F
 ld b, (ix)                     ; DD 46 00
 ld b, (ix+0)                   ; DD 46 00
 ld b, (ix+126)                 ; DD 46 7E
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+0)                   ; FD 46 00
 ld b, (iy+126)                 ; FD 46 7E
 ld b, (iy-128)                 ; FD 46 80
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix+0)                   ; DD 4E 00
 ld c, (ix+126)                 ; DD 4E 7E
 ld c, (ix-128)                 ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy+0)                   ; FD 4E 00
 ld c, (iy+126)                 ; FD 4E 7E
 ld c, (iy-128)                 ; FD 4E 80
 ld d, (ix)                     ; DD 56 00
 ld d, (ix+0)                   ; DD 56 00
 ld d, (ix+126)                 ; DD 56 7E
 ld d, (ix-128)                 ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy+0)                   ; FD 56 00
 ld d, (iy+126)                 ; FD 56 7E
 ld d, (iy-128)                 ; FD 56 80
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix+0)                   ; DD 5E 00
 ld e, (ix+126)                 ; DD 5E 7E
 ld e, (ix-128)                 ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy+0)                   ; FD 5E 00
 ld e, (iy+126)                 ; FD 5E 7E
 ld e, (iy-128)                 ; FD 5E 80
 ld h, (ix)                     ; DD 66 00
 ld h, (ix+0)                   ; DD 66 00
 ld h, (ix+126)                 ; DD 66 7E
 ld h, (ix-128)                 ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy+0)                   ; FD 66 00
 ld h, (iy+126)                 ; FD 66 7E
 ld h, (iy-128)                 ; FD 66 80
 ld i, a                        ; ED 47
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix+0)                   ; DD 6E 00
 ld l, (ix+126)                 ; DD 6E 7E
 ld l, (ix-128)                 ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy+0)                   ; FD 6E 00
 ld l, (iy+126)                 ; FD 6E 7E
 ld l, (iy-128)                 ; FD 6E 80
 ld r, a                        ; ED 4F
 ld.l (ix), a                   ; 49 DD 77 00
 ld.l (ix), b                   ; 49 DD 70 00
 ld.l (ix), c                   ; 49 DD 71 00
 ld.l (ix), d                   ; 49 DD 72 00
 ld.l (ix), e                   ; 49 DD 73 00
 ld.l (ix), h                   ; 49 DD 74 00
 ld.l (ix), l                   ; 49 DD 75 00
 ld.l (ix+0), a                 ; 49 DD 77 00
 ld.l (ix+0), b                 ; 49 DD 70 00
 ld.l (ix+0), c                 ; 49 DD 71 00
 ld.l (ix+0), d                 ; 49 DD 72 00
 ld.l (ix+0), e                 ; 49 DD 73 00
 ld.l (ix+0), h                 ; 49 DD 74 00
 ld.l (ix+0), l                 ; 49 DD 75 00
 ld.l (ix+126), a               ; 49 DD 77 7E
 ld.l (ix+126), b               ; 49 DD 70 7E
 ld.l (ix+126), c               ; 49 DD 71 7E
 ld.l (ix+126), d               ; 49 DD 72 7E
 ld.l (ix+126), e               ; 49 DD 73 7E
 ld.l (ix+126), h               ; 49 DD 74 7E
 ld.l (ix+126), l               ; 49 DD 75 7E
 ld.l (ix-128), a               ; 49 DD 77 80
 ld.l (ix-128), b               ; 49 DD 70 80
 ld.l (ix-128), c               ; 49 DD 71 80
 ld.l (ix-128), d               ; 49 DD 72 80
 ld.l (ix-128), e               ; 49 DD 73 80
 ld.l (ix-128), h               ; 49 DD 74 80
 ld.l (ix-128), l               ; 49 DD 75 80
 ld.l (iy), a                   ; 49 FD 77 00
 ld.l (iy), b                   ; 49 FD 70 00
 ld.l (iy), c                   ; 49 FD 71 00
 ld.l (iy), d                   ; 49 FD 72 00
 ld.l (iy), e                   ; 49 FD 73 00
 ld.l (iy), h                   ; 49 FD 74 00
 ld.l (iy), l                   ; 49 FD 75 00
 ld.l (iy+0), a                 ; 49 FD 77 00
 ld.l (iy+0), b                 ; 49 FD 70 00
 ld.l (iy+0), c                 ; 49 FD 71 00
 ld.l (iy+0), d                 ; 49 FD 72 00
 ld.l (iy+0), e                 ; 49 FD 73 00
 ld.l (iy+0), h                 ; 49 FD 74 00
 ld.l (iy+0), l                 ; 49 FD 75 00
 ld.l (iy+126), a               ; 49 FD 77 7E
 ld.l (iy+126), b               ; 49 FD 70 7E
 ld.l (iy+126), c               ; 49 FD 71 7E
 ld.l (iy+126), d               ; 49 FD 72 7E
 ld.l (iy+126), e               ; 49 FD 73 7E
 ld.l (iy+126), h               ; 49 FD 74 7E
 ld.l (iy+126), l               ; 49 FD 75 7E
 ld.l (iy-128), a               ; 49 FD 77 80
 ld.l (iy-128), b               ; 49 FD 70 80
 ld.l (iy-128), c               ; 49 FD 71 80
 ld.l (iy-128), d               ; 49 FD 72 80
 ld.l (iy-128), e               ; 49 FD 73 80
 ld.l (iy-128), h               ; 49 FD 74 80
 ld.l (iy-128), l               ; 49 FD 75 80
 ld.l a, (ix)                   ; 49 DD 7E 00
 ld.l a, (ix+0)                 ; 49 DD 7E 00
 ld.l a, (ix+126)               ; 49 DD 7E 7E
 ld.l a, (ix-128)               ; 49 DD 7E 80
 ld.l a, (iy)                   ; 49 FD 7E 00
 ld.l a, (iy+0)                 ; 49 FD 7E 00
 ld.l a, (iy+126)               ; 49 FD 7E 7E
 ld.l a, (iy-128)               ; 49 FD 7E 80
 ld.l b, (ix)                   ; 49 DD 46 00
 ld.l b, (ix+0)                 ; 49 DD 46 00
 ld.l b, (ix+126)               ; 49 DD 46 7E
 ld.l b, (ix-128)               ; 49 DD 46 80
 ld.l b, (iy)                   ; 49 FD 46 00
 ld.l b, (iy+0)                 ; 49 FD 46 00
 ld.l b, (iy+126)               ; 49 FD 46 7E
 ld.l b, (iy-128)               ; 49 FD 46 80
 ld.l c, (ix)                   ; 49 DD 4E 00
 ld.l c, (ix+0)                 ; 49 DD 4E 00
 ld.l c, (ix+126)               ; 49 DD 4E 7E
 ld.l c, (ix-128)               ; 49 DD 4E 80
 ld.l c, (iy)                   ; 49 FD 4E 00
 ld.l c, (iy+0)                 ; 49 FD 4E 00
 ld.l c, (iy+126)               ; 49 FD 4E 7E
 ld.l c, (iy-128)               ; 49 FD 4E 80
 ld.l d, (ix)                   ; 49 DD 56 00
 ld.l d, (ix+0)                 ; 49 DD 56 00
 ld.l d, (ix+126)               ; 49 DD 56 7E
 ld.l d, (ix-128)               ; 49 DD 56 80
 ld.l d, (iy)                   ; 49 FD 56 00
 ld.l d, (iy+0)                 ; 49 FD 56 00
 ld.l d, (iy+126)               ; 49 FD 56 7E
 ld.l d, (iy-128)               ; 49 FD 56 80
 ld.l e, (ix)                   ; 49 DD 5E 00
 ld.l e, (ix+0)                 ; 49 DD 5E 00
 ld.l e, (ix+126)               ; 49 DD 5E 7E
 ld.l e, (ix-128)               ; 49 DD 5E 80
 ld.l e, (iy)                   ; 49 FD 5E 00
 ld.l e, (iy+0)                 ; 49 FD 5E 00
 ld.l e, (iy+126)               ; 49 FD 5E 7E
 ld.l e, (iy-128)               ; 49 FD 5E 80
 ld.l h, (ix)                   ; 49 DD 66 00
 ld.l h, (ix+0)                 ; 49 DD 66 00
 ld.l h, (ix+126)               ; 49 DD 66 7E
 ld.l h, (ix-128)               ; 49 DD 66 80
 ld.l h, (iy)                   ; 49 FD 66 00
 ld.l h, (iy+0)                 ; 49 FD 66 00
 ld.l h, (iy+126)               ; 49 FD 66 7E
 ld.l h, (iy-128)               ; 49 FD 66 80
 ld.l l, (ix)                   ; 49 DD 6E 00
 ld.l l, (ix+0)                 ; 49 DD 6E 00
 ld.l l, (ix+126)               ; 49 DD 6E 7E
 ld.l l, (ix-128)               ; 49 DD 6E 80
 ld.l l, (iy)                   ; 49 FD 6E 00
 ld.l l, (iy+0)                 ; 49 FD 6E 00
 ld.l l, (iy+126)               ; 49 FD 6E 7E
 ld.l l, (iy-128)               ; 49 FD 6E 80
 ld.lis (ix), a                 ; 49 DD 77 00
 ld.lis (ix), b                 ; 49 DD 70 00
 ld.lis (ix), c                 ; 49 DD 71 00
 ld.lis (ix), d                 ; 49 DD 72 00
 ld.lis (ix), e                 ; 49 DD 73 00
 ld.lis (ix), h                 ; 49 DD 74 00
 ld.lis (ix), l                 ; 49 DD 75 00
 ld.lis (ix+0), a               ; 49 DD 77 00
 ld.lis (ix+0), b               ; 49 DD 70 00
 ld.lis (ix+0), c               ; 49 DD 71 00
 ld.lis (ix+0), d               ; 49 DD 72 00
 ld.lis (ix+0), e               ; 49 DD 73 00
 ld.lis (ix+0), h               ; 49 DD 74 00
 ld.lis (ix+0), l               ; 49 DD 75 00
 ld.lis (ix+126), a             ; 49 DD 77 7E
 ld.lis (ix+126), b             ; 49 DD 70 7E
 ld.lis (ix+126), c             ; 49 DD 71 7E
 ld.lis (ix+126), d             ; 49 DD 72 7E
 ld.lis (ix+126), e             ; 49 DD 73 7E
 ld.lis (ix+126), h             ; 49 DD 74 7E
 ld.lis (ix+126), l             ; 49 DD 75 7E
 ld.lis (ix-128), a             ; 49 DD 77 80
 ld.lis (ix-128), b             ; 49 DD 70 80
 ld.lis (ix-128), c             ; 49 DD 71 80
 ld.lis (ix-128), d             ; 49 DD 72 80
 ld.lis (ix-128), e             ; 49 DD 73 80
 ld.lis (ix-128), h             ; 49 DD 74 80
 ld.lis (ix-128), l             ; 49 DD 75 80
 ld.lis (iy), a                 ; 49 FD 77 00
 ld.lis (iy), b                 ; 49 FD 70 00
 ld.lis (iy), c                 ; 49 FD 71 00
 ld.lis (iy), d                 ; 49 FD 72 00
 ld.lis (iy), e                 ; 49 FD 73 00
 ld.lis (iy), h                 ; 49 FD 74 00
 ld.lis (iy), l                 ; 49 FD 75 00
 ld.lis (iy+0), a               ; 49 FD 77 00
 ld.lis (iy+0), b               ; 49 FD 70 00
 ld.lis (iy+0), c               ; 49 FD 71 00
 ld.lis (iy+0), d               ; 49 FD 72 00
 ld.lis (iy+0), e               ; 49 FD 73 00
 ld.lis (iy+0), h               ; 49 FD 74 00
 ld.lis (iy+0), l               ; 49 FD 75 00
 ld.lis (iy+126), a             ; 49 FD 77 7E
 ld.lis (iy+126), b             ; 49 FD 70 7E
 ld.lis (iy+126), c             ; 49 FD 71 7E
 ld.lis (iy+126), d             ; 49 FD 72 7E
 ld.lis (iy+126), e             ; 49 FD 73 7E
 ld.lis (iy+126), h             ; 49 FD 74 7E
 ld.lis (iy+126), l             ; 49 FD 75 7E
 ld.lis (iy-128), a             ; 49 FD 77 80
 ld.lis (iy-128), b             ; 49 FD 70 80
 ld.lis (iy-128), c             ; 49 FD 71 80
 ld.lis (iy-128), d             ; 49 FD 72 80
 ld.lis (iy-128), e             ; 49 FD 73 80
 ld.lis (iy-128), h             ; 49 FD 74 80
 ld.lis (iy-128), l             ; 49 FD 75 80
 ld.lis a, (ix)                 ; 49 DD 7E 00
 ld.lis a, (ix+0)               ; 49 DD 7E 00
 ld.lis a, (ix+126)             ; 49 DD 7E 7E
 ld.lis a, (ix-128)             ; 49 DD 7E 80
 ld.lis a, (iy)                 ; 49 FD 7E 00
 ld.lis a, (iy+0)               ; 49 FD 7E 00
 ld.lis a, (iy+126)             ; 49 FD 7E 7E
 ld.lis a, (iy-128)             ; 49 FD 7E 80
 ld.lis b, (ix)                 ; 49 DD 46 00
 ld.lis b, (ix+0)               ; 49 DD 46 00
 ld.lis b, (ix+126)             ; 49 DD 46 7E
 ld.lis b, (ix-128)             ; 49 DD 46 80
 ld.lis b, (iy)                 ; 49 FD 46 00
 ld.lis b, (iy+0)               ; 49 FD 46 00
 ld.lis b, (iy+126)             ; 49 FD 46 7E
 ld.lis b, (iy-128)             ; 49 FD 46 80
 ld.lis c, (ix)                 ; 49 DD 4E 00
 ld.lis c, (ix+0)               ; 49 DD 4E 00
 ld.lis c, (ix+126)             ; 49 DD 4E 7E
 ld.lis c, (ix-128)             ; 49 DD 4E 80
 ld.lis c, (iy)                 ; 49 FD 4E 00
 ld.lis c, (iy+0)               ; 49 FD 4E 00
 ld.lis c, (iy+126)             ; 49 FD 4E 7E
 ld.lis c, (iy-128)             ; 49 FD 4E 80
 ld.lis d, (ix)                 ; 49 DD 56 00
 ld.lis d, (ix+0)               ; 49 DD 56 00
 ld.lis d, (ix+126)             ; 49 DD 56 7E
 ld.lis d, (ix-128)             ; 49 DD 56 80
 ld.lis d, (iy)                 ; 49 FD 56 00
 ld.lis d, (iy+0)               ; 49 FD 56 00
 ld.lis d, (iy+126)             ; 49 FD 56 7E
 ld.lis d, (iy-128)             ; 49 FD 56 80
 ld.lis e, (ix)                 ; 49 DD 5E 00
 ld.lis e, (ix+0)               ; 49 DD 5E 00
 ld.lis e, (ix+126)             ; 49 DD 5E 7E
 ld.lis e, (ix-128)             ; 49 DD 5E 80
 ld.lis e, (iy)                 ; 49 FD 5E 00
 ld.lis e, (iy+0)               ; 49 FD 5E 00
 ld.lis e, (iy+126)             ; 49 FD 5E 7E
 ld.lis e, (iy-128)             ; 49 FD 5E 80
 ld.lis h, (ix)                 ; 49 DD 66 00
 ld.lis h, (ix+0)               ; 49 DD 66 00
 ld.lis h, (ix+126)             ; 49 DD 66 7E
 ld.lis h, (ix-128)             ; 49 DD 66 80
 ld.lis h, (iy)                 ; 49 FD 66 00
 ld.lis h, (iy+0)               ; 49 FD 66 00
 ld.lis h, (iy+126)             ; 49 FD 66 7E
 ld.lis h, (iy-128)             ; 49 FD 66 80
 ld.lis l, (ix)                 ; 49 DD 6E 00
 ld.lis l, (ix+0)               ; 49 DD 6E 00
 ld.lis l, (ix+126)             ; 49 DD 6E 7E
 ld.lis l, (ix-128)             ; 49 DD 6E 80
 ld.lis l, (iy)                 ; 49 FD 6E 00
 ld.lis l, (iy+0)               ; 49 FD 6E 00
 ld.lis l, (iy+126)             ; 49 FD 6E 7E
 ld.lis l, (iy-128)             ; 49 FD 6E 80
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
 otdr                           ; ED BB
 otdr.l                         ; 49 ED BB
 otdr.lis                       ; 49 ED BB
 otir                           ; ED B3
 otir.l                         ; 49 ED B3
 otir.lis                       ; 49 ED B3
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
 outi                           ; ED A3
 outi.l                         ; 49 ED A3
 outi.lis                       ; 49 ED A3
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
