 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; DD 44
 ld b, iyh                      ; FD 44
 ld b, l                        ; 45
 ld b, ixl                      ; DD 45
 ld b, iyl                      ; FD 45
 ld b, a                        ; 47
 ld b,  42                      ; 06 2A
 ld b, (42)                     ; 06 2A
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; DD 46 00
 ld b, (ix + 127)               ; DD 46 7F
 ld b, (ix - 128)               ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy + 127)               ; FD 46 7F
 ld b, (iy - 128)               ; FD 46 80
 ld (hl), b                     ; 70
 ld (ix), b                     ; DD 70 00
 ld (ix + 127), b               ; DD 70 7F
 ld (ix - 128), b               ; DD 70 80
 ld (iy), b                     ; FD 70 00
 ld (iy + 127), b               ; FD 70 7F
 ld (iy - 128), b               ; FD 70 80
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; DD 4C
 ld c, iyh                      ; FD 4C
 ld c, l                        ; 4D
 ld c, ixl                      ; DD 4D
 ld c, iyl                      ; FD 4D
 ld c, a                        ; 4F
 ld c,  42                      ; 0E 2A
 ld c, (42)                     ; 0E 2A
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix + 127)               ; DD 4E 7F
 ld c, (ix - 128)               ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy + 127)               ; FD 4E 7F
 ld c, (iy - 128)               ; FD 4E 80
 ld (hl), c                     ; 71
 ld (ix), c                     ; DD 71 00
 ld (ix + 127), c               ; DD 71 7F
 ld (ix - 128), c               ; DD 71 80
 ld (iy), c                     ; FD 71 00
 ld (iy + 127), c               ; FD 71 7F
 ld (iy - 128), c               ; FD 71 80
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; DD 54
 ld d, iyh                      ; FD 54
 ld d, l                        ; 55
 ld d, ixl                      ; DD 55
 ld d, iyl                      ; FD 55
 ld d, a                        ; 57
 ld d,  42                      ; 16 2A
 ld d, (42)                     ; 16 2A
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; DD 56 00
 ld d, (ix + 127)               ; DD 56 7F
 ld d, (ix - 128)               ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy + 127)               ; FD 56 7F
 ld d, (iy - 128)               ; FD 56 80
 ld (hl), d                     ; 72
 ld (ix), d                     ; DD 72 00
 ld (ix + 127), d               ; DD 72 7F
 ld (ix - 128), d               ; DD 72 80
 ld (iy), d                     ; FD 72 00
 ld (iy + 127), d               ; FD 72 7F
 ld (iy - 128), d               ; FD 72 80
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, ixh                      ; DD 5C
 ld e, iyh                      ; FD 5C
 ld e, l                        ; 5D
 ld e, ixl                      ; DD 5D
 ld e, iyl                      ; FD 5D
 ld e, a                        ; 5F
 ld e,  42                      ; 1E 2A
 ld e, (42)                     ; 1E 2A
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix + 127)               ; DD 5E 7F
 ld e, (ix - 128)               ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy + 127)               ; FD 5E 7F
 ld e, (iy - 128)               ; FD 5E 80
 ld (hl), e                     ; 73
 ld (ix), e                     ; DD 73 00
 ld (ix + 127), e               ; DD 73 7F
 ld (ix - 128), e               ; DD 73 80
 ld (iy), e                     ; FD 73 00
 ld (iy + 127), e               ; FD 73 7F
 ld (iy - 128), e               ; FD 73 80
 ld h, b                        ; 60
 ld ixh, b                      ; DD 60
 ld iyh, b                      ; FD 60
 ld h, c                        ; 61
 ld ixh, c                      ; DD 61
 ld iyh, c                      ; FD 61
 ld h, d                        ; 62
 ld ixh, d                      ; DD 62
 ld iyh, d                      ; FD 62
 ld h, e                        ; 63
 ld ixh, e                      ; DD 63
 ld iyh, e                      ; FD 63
 ld h, h                        ; 64
 ld ixh, ixh                    ; DD 64
 ld iyh, iyh                    ; FD 64
 ld h, l                        ; 65
 ld ixh, ixl                    ; DD 65
 ld iyh, iyl                    ; FD 65
 ld h, a                        ; 67
 ld ixh, a                      ; DD 67
 ld iyh, a                      ; FD 67
 ld h,  42                      ; 26 2A
 ld h, (42)                     ; 26 2A
 ld ixh,  42                    ; DD 26 2A
 ld ixh, (42)                   ; DD 26 2A
 ld iyh,  42                    ; FD 26 2A
 ld iyh, (42)                   ; FD 26 2A
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; DD 66 00
 ld h, (ix + 127)               ; DD 66 7F
 ld h, (ix - 128)               ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy + 127)               ; FD 66 7F
 ld h, (iy - 128)               ; FD 66 80
 ld (hl), h                     ; 74
 ld (ix), h                     ; DD 74 00
 ld (ix + 127), h               ; DD 74 7F
 ld (ix - 128), h               ; DD 74 80
 ld (iy), h                     ; FD 74 00
 ld (iy + 127), h               ; FD 74 7F
 ld (iy - 128), h               ; FD 74 80
 ld l, b                        ; 68
 ld ixl, b                      ; DD 68
 ld iyl, b                      ; FD 68
 ld l, c                        ; 69
 ld ixl, c                      ; DD 69
 ld iyl, c                      ; FD 69
 ld l, d                        ; 6A
 ld ixl, d                      ; DD 6A
 ld iyl, d                      ; FD 6A
 ld l, e                        ; 6B
 ld ixl, e                      ; DD 6B
 ld iyl, e                      ; FD 6B
 ld l, h                        ; 6C
 ld ixl, ixh                    ; DD 6C
 ld iyl, iyh                    ; FD 6C
 ld l, l                        ; 6D
 ld ixl, ixl                    ; DD 6D
 ld iyl, iyl                    ; FD 6D
 ld l, a                        ; 6F
 ld ixl, a                      ; DD 6F
 ld iyl, a                      ; FD 6F
 ld l,  42                      ; 2E 2A
 ld l, (42)                     ; 2E 2A
 ld ixl,  42                    ; DD 2E 2A
 ld ixl, (42)                   ; DD 2E 2A
 ld iyl,  42                    ; FD 2E 2A
 ld iyl, (42)                   ; FD 2E 2A
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix + 127)               ; DD 6E 7F
 ld l, (ix - 128)               ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy + 127)               ; FD 6E 7F
 ld l, (iy - 128)               ; FD 6E 80
 ld (hl), l                     ; 75
 ld (ix), l                     ; DD 75 00
 ld (ix + 127), l               ; DD 75 7F
 ld (ix - 128), l               ; DD 75 80
 ld (iy), l                     ; FD 75 00
 ld (iy + 127), l               ; FD 75 7F
 ld (iy - 128), l               ; FD 75 80
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, ixh                      ; DD 7C
 ld a, iyh                      ; FD 7C
 ld a, l                        ; 7D
 ld a, ixl                      ; DD 7D
 ld a, iyl                      ; FD 7D
 ld a, a                        ; 7F
 ld a, 42                       ; 3E 2A
 ld a, (256)                    ; 3A 00 01
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix + 127)               ; DD 7E 7F
 ld a, (ix - 128)               ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy + 127)               ; FD 7E 7F
 ld a, (iy - 128)               ; FD 7E 80
 ld (hl), a                     ; 77
 ld (ix), a                     ; DD 77 00
 ld (ix + 127), a               ; DD 77 7F
 ld (ix - 128), a               ; DD 77 80
 ld (iy), a                     ; FD 77 00
 ld (iy + 127), a               ; FD 77 7F
 ld (iy - 128), a               ; FD 77 80
 ld (hl), 42                    ; 36 2A
 ld (ix), 42                    ; DD 36 00 2A
 ld (ix + 127), 42              ; DD 36 7F 2A
 ld (ix - 128), 42              ; DD 36 80 2A
 ld (iy), 42                    ; FD 36 00 2A
 ld (iy + 127), 42              ; FD 36 7F 2A
 ld (iy - 128), 42              ; FD 36 80 2A
 ld (bc), a                     ; 02
 ld a, (bc)                     ; 0A
 ld (de), a                     ; 12
 ld a, (de)                     ; 1A
 ld (256), a                    ; 32 00 01
 add a, b                       ; 80
 add b                          ; 80
 add a, c                       ; 81
 add c                          ; 81
 add a, d                       ; 82
 add d                          ; 82
 add a, e                       ; 83
 add e                          ; 83
 add a, h                       ; 84
 add h                          ; 84
 add a, ixh                     ; DD 84
 add ixh                        ; DD 84
 add a, iyh                     ; FD 84
 add iyh                        ; FD 84
 add a, l                       ; 85
 add l                          ; 85
 add a, ixl                     ; DD 85
 add ixl                        ; DD 85
 add a, iyl                     ; FD 85
 add iyl                        ; FD 85
 add a, a                       ; 87
 add a                          ; 87
 add a, (hl)                    ; 86
 add (hl)                       ; 86
 add a, (ix)                    ; DD 86 00
 add a, (ix + 127)              ; DD 86 7F
 add a, (ix - 128)              ; DD 86 80
 add (ix)                       ; DD 86 00
 add (ix + 127)                 ; DD 86 7F
 add (ix - 128)                 ; DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy + 127)              ; FD 86 7F
 add a, (iy - 128)              ; FD 86 80
 add (iy)                       ; FD 86 00
 add (iy + 127)                 ; FD 86 7F
 add (iy - 128)                 ; FD 86 80
 add a,  42                     ; C6 2A
 add a, (42)                    ; C6 2A
 add  42                        ; C6 2A
 add (42)                       ; C6 2A
 adc a, b                       ; 88
 adc b                          ; 88
 adc a, c                       ; 89
 adc c                          ; 89
 adc a, d                       ; 8A
 adc d                          ; 8A
 adc a, e                       ; 8B
 adc e                          ; 8B
 adc a, h                       ; 8C
 adc h                          ; 8C
 adc a, ixh                     ; DD 8C
 adc ixh                        ; DD 8C
 adc a, iyh                     ; FD 8C
 adc iyh                        ; FD 8C
 adc a, l                       ; 8D
 adc l                          ; 8D
 adc a, ixl                     ; DD 8D
 adc ixl                        ; DD 8D
 adc a, iyl                     ; FD 8D
 adc iyl                        ; FD 8D
 adc a, a                       ; 8F
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc (hl)                       ; 8E
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix + 127)              ; DD 8E 7F
 adc a, (ix - 128)              ; DD 8E 80
 adc (ix)                       ; DD 8E 00
 adc (ix + 127)                 ; DD 8E 7F
 adc (ix - 128)                 ; DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy + 127)              ; FD 8E 7F
 adc a, (iy - 128)              ; FD 8E 80
 adc (iy)                       ; FD 8E 00
 adc (iy + 127)                 ; FD 8E 7F
 adc (iy - 128)                 ; FD 8E 80
 adc a,  42                     ; CE 2A
 adc a, (42)                    ; CE 2A
 adc  42                        ; CE 2A
 adc (42)                       ; CE 2A
 sub a, b                       ; 90
 sub b                          ; 90
 sub a, c                       ; 91
 sub c                          ; 91
 sub a, d                       ; 92
 sub d                          ; 92
 sub a, e                       ; 93
 sub e                          ; 93
 sub a, h                       ; 94
 sub h                          ; 94
 sub a, ixh                     ; DD 94
 sub ixh                        ; DD 94
 sub a, iyh                     ; FD 94
 sub iyh                        ; FD 94
 sub a, l                       ; 95
 sub l                          ; 95
 sub a, ixl                     ; DD 95
 sub ixl                        ; DD 95
 sub a, iyl                     ; FD 95
 sub iyl                        ; FD 95
 sub a, a                       ; 97
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub (hl)                       ; 96
 sub a, (ix)                    ; DD 96 00
 sub a, (ix + 127)              ; DD 96 7F
 sub a, (ix - 128)              ; DD 96 80
 sub (ix)                       ; DD 96 00
 sub (ix + 127)                 ; DD 96 7F
 sub (ix - 128)                 ; DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy + 127)              ; FD 96 7F
 sub a, (iy - 128)              ; FD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy + 127)                 ; FD 96 7F
 sub (iy - 128)                 ; FD 96 80
 sub a,  42                     ; D6 2A
 sub a, (42)                    ; D6 2A
 sub  42                        ; D6 2A
 sub (42)                       ; D6 2A
 sbc a, b                       ; 98
 sbc b                          ; 98
 sbc a, c                       ; 99
 sbc c                          ; 99
 sbc a, d                       ; 9A
 sbc d                          ; 9A
 sbc a, e                       ; 9B
 sbc e                          ; 9B
 sbc a, h                       ; 9C
 sbc h                          ; 9C
 sbc a, ixh                     ; DD 9C
 sbc ixh                        ; DD 9C
 sbc a, iyh                     ; FD 9C
 sbc iyh                        ; FD 9C
 sbc a, l                       ; 9D
 sbc l                          ; 9D
 sbc a, ixl                     ; DD 9D
 sbc ixl                        ; DD 9D
 sbc a, iyl                     ; FD 9D
 sbc iyl                        ; FD 9D
 sbc a, a                       ; 9F
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc (hl)                       ; 9E
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix + 127)              ; DD 9E 7F
 sbc a, (ix - 128)              ; DD 9E 80
 sbc (ix)                       ; DD 9E 00
 sbc (ix + 127)                 ; DD 9E 7F
 sbc (ix - 128)                 ; DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy + 127)              ; FD 9E 7F
 sbc a, (iy - 128)              ; FD 9E 80
 sbc (iy)                       ; FD 9E 00
 sbc (iy + 127)                 ; FD 9E 7F
 sbc (iy - 128)                 ; FD 9E 80
 sbc a,  42                     ; DE 2A
 sbc a, (42)                    ; DE 2A
 sbc  42                        ; DE 2A
 sbc (42)                       ; DE 2A
 and a, b                       ; A0
 and b                          ; A0
 and a, c                       ; A1
 and c                          ; A1
 and a, d                       ; A2
 and d                          ; A2
 and a, e                       ; A3
 and e                          ; A3
 and a, h                       ; A4
 and h                          ; A4
 and a, ixh                     ; DD A4
 and ixh                        ; DD A4
 and a, iyh                     ; FD A4
 and iyh                        ; FD A4
 and a, l                       ; A5
 and l                          ; A5
 and a, ixl                     ; DD A5
 and ixl                        ; DD A5
 and a, iyl                     ; FD A5
 and iyl                        ; FD A5
 and a, a                       ; A7
 and a                          ; A7
 and a, (hl)                    ; A6
 and (hl)                       ; A6
 and a, (ix)                    ; DD A6 00
 and a, (ix + 127)              ; DD A6 7F
 and a, (ix - 128)              ; DD A6 80
 and (ix)                       ; DD A6 00
 and (ix + 127)                 ; DD A6 7F
 and (ix - 128)                 ; DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy + 127)              ; FD A6 7F
 and a, (iy - 128)              ; FD A6 80
 and (iy)                       ; FD A6 00
 and (iy + 127)                 ; FD A6 7F
 and (iy - 128)                 ; FD A6 80
 and a,  42                     ; E6 2A
 and a, (42)                    ; E6 2A
 and  42                        ; E6 2A
 and (42)                       ; E6 2A
 xor a, b                       ; A8
 xor b                          ; A8
 xor a, c                       ; A9
 xor c                          ; A9
 xor a, d                       ; AA
 xor d                          ; AA
 xor a, e                       ; AB
 xor e                          ; AB
 xor a, h                       ; AC
 xor h                          ; AC
 xor a, ixh                     ; DD AC
 xor ixh                        ; DD AC
 xor a, iyh                     ; FD AC
 xor iyh                        ; FD AC
 xor a, l                       ; AD
 xor l                          ; AD
 xor a, ixl                     ; DD AD
 xor ixl                        ; DD AD
 xor a, iyl                     ; FD AD
 xor iyl                        ; FD AD
 xor a, a                       ; AF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor (hl)                       ; AE
 xor a, (ix)                    ; DD AE 00
 xor a, (ix + 127)              ; DD AE 7F
 xor a, (ix - 128)              ; DD AE 80
 xor (ix)                       ; DD AE 00
 xor (ix + 127)                 ; DD AE 7F
 xor (ix - 128)                 ; DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy + 127)              ; FD AE 7F
 xor a, (iy - 128)              ; FD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy + 127)                 ; FD AE 7F
 xor (iy - 128)                 ; FD AE 80
 xor a,  42                     ; EE 2A
 xor a, (42)                    ; EE 2A
 xor  42                        ; EE 2A
 xor (42)                       ; EE 2A
 or a, b                        ; B0
 or b                           ; B0
 or a, c                        ; B1
 or c                           ; B1
 or a, d                        ; B2
 or d                           ; B2
 or a, e                        ; B3
 or e                           ; B3
 or a, h                        ; B4
 or h                           ; B4
 or a, ixh                      ; DD B4
 or ixh                         ; DD B4
 or a, iyh                      ; FD B4
 or iyh                         ; FD B4
 or a, l                        ; B5
 or l                           ; B5
 or a, ixl                      ; DD B5
 or ixl                         ; DD B5
 or a, iyl                      ; FD B5
 or iyl                         ; FD B5
 or a, a                        ; B7
 or a                           ; B7
 or a, (hl)                     ; B6
 or (hl)                        ; B6
 or a, (ix)                     ; DD B6 00
 or a, (ix + 127)               ; DD B6 7F
 or a, (ix - 128)               ; DD B6 80
 or (ix)                        ; DD B6 00
 or (ix + 127)                  ; DD B6 7F
 or (ix - 128)                  ; DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy + 127)               ; FD B6 7F
 or a, (iy - 128)               ; FD B6 80
 or (iy)                        ; FD B6 00
 or (iy + 127)                  ; FD B6 7F
 or (iy - 128)                  ; FD B6 80
 or a,  42                      ; F6 2A
 or a, (42)                     ; F6 2A
 or  42                         ; F6 2A
 or (42)                        ; F6 2A
 cp a, b                        ; B8
 cp b                           ; B8
 cp a, c                        ; B9
 cp c                           ; B9
 cp a, d                        ; BA
 cp d                           ; BA
 cp a, e                        ; BB
 cp e                           ; BB
 cp a, h                        ; BC
 cp h                           ; BC
 cp a, ixh                      ; DD BC
 cp ixh                         ; DD BC
 cp a, iyh                      ; FD BC
 cp iyh                         ; FD BC
 cp a, l                        ; BD
 cp l                           ; BD
 cp a, ixl                      ; DD BD
 cp ixl                         ; DD BD
 cp a, iyl                      ; FD BD
 cp iyl                         ; FD BD
 cp a, a                        ; BF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp (hl)                        ; BE
 cp a, (ix)                     ; DD BE 00
 cp a, (ix + 127)               ; DD BE 7F
 cp a, (ix - 128)               ; DD BE 80
 cp (ix)                        ; DD BE 00
 cp (ix + 127)                  ; DD BE 7F
 cp (ix - 128)                  ; DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy + 127)               ; FD BE 7F
 cp a, (iy - 128)               ; FD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy + 127)                  ; FD BE 7F
 cp (iy - 128)                  ; FD BE 80
 cp a,  42                      ; FE 2A
 cp a, (42)                     ; FE 2A
 cp  42                         ; FE 2A
 cp (42)                        ; FE 2A
 inc b                          ; 04
 inc c                          ; 0C
 inc d                          ; 14
 inc e                          ; 1C
 inc h                          ; 24
 inc ixh                        ; DD 24
 inc iyh                        ; FD 24
 inc l                          ; 2C
 inc ixl                        ; DD 2C
 inc iyl                        ; FD 2C
 inc a                          ; 3C
 inc (hl)                       ; 34
 inc (ix)                       ; DD 34 00
 inc (ix + 127)                 ; DD 34 7F
 inc (ix - 128)                 ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy + 127)                 ; FD 34 7F
 inc (iy - 128)                 ; FD 34 80
 dec b                          ; 05
 dec c                          ; 0D
 dec d                          ; 15
 dec e                          ; 1D
 dec h                          ; 25
 dec ixh                        ; DD 25
 dec iyh                        ; FD 25
 dec l                          ; 2D
 dec ixl                        ; DD 2D
 dec iyl                        ; FD 2D
 dec a                          ; 3D
 dec (hl)                       ; 35
 dec (ix)                       ; DD 35 00
 dec (ix + 127)                 ; DD 35 7F
 dec (ix - 128)                 ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy + 127)                 ; FD 35 7F
 dec (iy - 128)                 ; FD 35 80
 daa                            ; 27
 rrd                            ; ED 67
 rld                            ; ED 6F
 cpl                            ; 2F
 cpl a                          ; 2F
 neg                            ; ED 44
 neg a                          ; ED 44
 ccf                            ; 3F
 ccf f                          ; 3F
 scf                            ; 37
 scf f                          ; 37
