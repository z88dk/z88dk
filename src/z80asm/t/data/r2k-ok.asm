 ld (hl), b                     ; 70
 ld (ix), b                     ; DD 70 00
 ld (ix + 127), b               ; DD 70 7F
 ld (ix - 128), b               ; DD 70 80
 ld (iy), b                     ; FD 70 00
 ld (iy + 127), b               ; FD 70 7F
 ld (iy - 128), b               ; FD 70 80
 ld (hl), c                     ; 71
 ld (ix), c                     ; DD 71 00
 ld (ix + 127), c               ; DD 71 7F
 ld (ix - 128), c               ; DD 71 80
 ld (iy), c                     ; FD 71 00
 ld (iy + 127), c               ; FD 71 7F
 ld (iy - 128), c               ; FD 71 80
 ld (hl), d                     ; 72
 ld (ix), d                     ; DD 72 00
 ld (ix + 127), d               ; DD 72 7F
 ld (ix - 128), d               ; DD 72 80
 ld (iy), d                     ; FD 72 00
 ld (iy + 127), d               ; FD 72 7F
 ld (iy - 128), d               ; FD 72 80
 ld (hl), e                     ; 73
 ld (ix), e                     ; DD 73 00
 ld (ix + 127), e               ; DD 73 7F
 ld (ix - 128), e               ; DD 73 80
 ld (iy), e                     ; FD 73 00
 ld (iy + 127), e               ; FD 73 7F
 ld (iy - 128), e               ; FD 73 80
 ld (hl), h                     ; 74
 ld (ix), h                     ; DD 74 00
 ld (ix + 127), h               ; DD 74 7F
 ld (ix - 128), h               ; DD 74 80
 ld (iy), h                     ; FD 74 00
 ld (iy + 127), h               ; FD 74 7F
 ld (iy - 128), h               ; FD 74 80
 ld (hl), l                     ; 75
 ld (ix), l                     ; DD 75 00
 ld (ix + 127), l               ; DD 75 7F
 ld (ix - 128), l               ; DD 75 80
 ld (iy), l                     ; FD 75 00
 ld (iy + 127), l               ; FD 75 7F
 ld (iy - 128), l               ; FD 75 80
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
 altd ld a, (bc)                ; 76 0A
 ld a', (bc)                    ; 76 0A
 ld (de), a                     ; 12
 ld a, (de)                     ; 1A
 altd ld a, (de)                ; 76 1A
 ld a', (de)                    ; 76 1A
 ld (256), a                    ; 32 00 01
 add a, b                       ; 80
 add b                          ; 80
 altd add a, b                  ; 76 80
 altd add b                     ; 76 80
 add a', b                      ; 76 80
 add a, c                       ; 81
 add c                          ; 81
 altd add a, c                  ; 76 81
 altd add c                     ; 76 81
 add a', c                      ; 76 81
 add a, d                       ; 82
 add d                          ; 82
 altd add a, d                  ; 76 82
 altd add d                     ; 76 82
 add a', d                      ; 76 82
 add a, e                       ; 83
 add e                          ; 83
 altd add a, e                  ; 76 83
 altd add e                     ; 76 83
 add a', e                      ; 76 83
 add a, h                       ; 84
 add h                          ; 84
 altd add a, h                  ; 76 84
 altd add h                     ; 76 84
 add a', h                      ; 76 84
 add a, l                       ; 85
 add l                          ; 85
 altd add a, l                  ; 76 85
 altd add l                     ; 76 85
 add a', l                      ; 76 85
 add a, a                       ; 87
 add a                          ; 87
 altd add a, a                  ; 76 87
 altd add a                     ; 76 87
 add a', a                      ; 76 87
 add a, (hl)                    ; 86
 add (hl)                       ; 86
 altd add a, (hl)               ; 76 86
 altd add (hl)                  ; 76 86
 add a', (hl)                   ; 76 86
 add a, (ix)                    ; DD 86 00
 add a, (ix + 127)              ; DD 86 7F
 add a, (ix - 128)              ; DD 86 80
 add (ix)                       ; DD 86 00
 add (ix + 127)                 ; DD 86 7F
 add (ix - 128)                 ; DD 86 80
 altd add a, (ix)               ; 76 DD 86 00
 altd add a, (ix + 127)         ; 76 DD 86 7F
 altd add a, (ix - 128)         ; 76 DD 86 80
 altd add (ix)                  ; 76 DD 86 00
 altd add (ix + 127)            ; 76 DD 86 7F
 altd add (ix - 128)            ; 76 DD 86 80
 add a', (ix)                   ; 76 DD 86 00
 add a', (ix + 127)             ; 76 DD 86 7F
 add a', (ix - 128)             ; 76 DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy + 127)              ; FD 86 7F
 add a, (iy - 128)              ; FD 86 80
 add (iy)                       ; FD 86 00
 add (iy + 127)                 ; FD 86 7F
 add (iy - 128)                 ; FD 86 80
 altd add a, (iy)               ; 76 FD 86 00
 altd add a, (iy + 127)         ; 76 FD 86 7F
 altd add a, (iy - 128)         ; 76 FD 86 80
 altd add (iy)                  ; 76 FD 86 00
 altd add (iy + 127)            ; 76 FD 86 7F
 altd add (iy - 128)            ; 76 FD 86 80
 add a', (iy)                   ; 76 FD 86 00
 add a', (iy + 127)             ; 76 FD 86 7F
 add a', (iy - 128)             ; 76 FD 86 80
 add a,  42                     ; C6 2A
 add a, (42)                    ; C6 2A
 add  42                        ; C6 2A
 add (42)                       ; C6 2A
 altd add a,  42                ; 76 C6 2A
 altd add a, (42)               ; 76 C6 2A
 altd add  42                   ; 76 C6 2A
 altd add (42)                  ; 76 C6 2A
 add a',  42                    ; 76 C6 2A
 add a', (42)                   ; 76 C6 2A
 adc a, b                       ; 88
 adc b                          ; 88
 altd adc a, b                  ; 76 88
 altd adc b                     ; 76 88
 adc a', b                      ; 76 88
 adc a, c                       ; 89
 adc c                          ; 89
 altd adc a, c                  ; 76 89
 altd adc c                     ; 76 89
 adc a', c                      ; 76 89
 adc a, d                       ; 8A
 adc d                          ; 8A
 altd adc a, d                  ; 76 8A
 altd adc d                     ; 76 8A
 adc a', d                      ; 76 8A
 adc a, e                       ; 8B
 adc e                          ; 8B
 altd adc a, e                  ; 76 8B
 altd adc e                     ; 76 8B
 adc a', e                      ; 76 8B
 adc a, h                       ; 8C
 adc h                          ; 8C
 altd adc a, h                  ; 76 8C
 altd adc h                     ; 76 8C
 adc a', h                      ; 76 8C
 adc a, l                       ; 8D
 adc l                          ; 8D
 altd adc a, l                  ; 76 8D
 altd adc l                     ; 76 8D
 adc a', l                      ; 76 8D
 adc a, a                       ; 8F
 adc a                          ; 8F
 altd adc a, a                  ; 76 8F
 altd adc a                     ; 76 8F
 adc a', a                      ; 76 8F
 adc a, (hl)                    ; 8E
 adc (hl)                       ; 8E
 altd adc a, (hl)               ; 76 8E
 altd adc (hl)                  ; 76 8E
 adc a', (hl)                   ; 76 8E
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix + 127)              ; DD 8E 7F
 adc a, (ix - 128)              ; DD 8E 80
 adc (ix)                       ; DD 8E 00
 adc (ix + 127)                 ; DD 8E 7F
 adc (ix - 128)                 ; DD 8E 80
 altd adc a, (ix)               ; 76 DD 8E 00
 altd adc a, (ix + 127)         ; 76 DD 8E 7F
 altd adc a, (ix - 128)         ; 76 DD 8E 80
 altd adc (ix)                  ; 76 DD 8E 00
 altd adc (ix + 127)            ; 76 DD 8E 7F
 altd adc (ix - 128)            ; 76 DD 8E 80
 adc a', (ix)                   ; 76 DD 8E 00
 adc a', (ix + 127)             ; 76 DD 8E 7F
 adc a', (ix - 128)             ; 76 DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy + 127)              ; FD 8E 7F
 adc a, (iy - 128)              ; FD 8E 80
 adc (iy)                       ; FD 8E 00
 adc (iy + 127)                 ; FD 8E 7F
 adc (iy - 128)                 ; FD 8E 80
 altd adc a, (iy)               ; 76 FD 8E 00
 altd adc a, (iy + 127)         ; 76 FD 8E 7F
 altd adc a, (iy - 128)         ; 76 FD 8E 80
 altd adc (iy)                  ; 76 FD 8E 00
 altd adc (iy + 127)            ; 76 FD 8E 7F
 altd adc (iy - 128)            ; 76 FD 8E 80
 adc a', (iy)                   ; 76 FD 8E 00
 adc a', (iy + 127)             ; 76 FD 8E 7F
 adc a', (iy - 128)             ; 76 FD 8E 80
 adc a,  42                     ; CE 2A
 adc a, (42)                    ; CE 2A
 adc  42                        ; CE 2A
 adc (42)                       ; CE 2A
 altd adc a,  42                ; 76 CE 2A
 altd adc a, (42)               ; 76 CE 2A
 altd adc  42                   ; 76 CE 2A
 altd adc (42)                  ; 76 CE 2A
 adc a',  42                    ; 76 CE 2A
 adc a', (42)                   ; 76 CE 2A
 sub a, b                       ; 90
 sub b                          ; 90
 altd sub a, b                  ; 76 90
 altd sub b                     ; 76 90
 sub a', b                      ; 76 90
 sub a, c                       ; 91
 sub c                          ; 91
 altd sub a, c                  ; 76 91
 altd sub c                     ; 76 91
 sub a', c                      ; 76 91
 sub a, d                       ; 92
 sub d                          ; 92
 altd sub a, d                  ; 76 92
 altd sub d                     ; 76 92
 sub a', d                      ; 76 92
 sub a, e                       ; 93
 sub e                          ; 93
 altd sub a, e                  ; 76 93
 altd sub e                     ; 76 93
 sub a', e                      ; 76 93
 sub a, h                       ; 94
 sub h                          ; 94
 altd sub a, h                  ; 76 94
 altd sub h                     ; 76 94
 sub a', h                      ; 76 94
 sub a, l                       ; 95
 sub l                          ; 95
 altd sub a, l                  ; 76 95
 altd sub l                     ; 76 95
 sub a', l                      ; 76 95
 sub a, a                       ; 97
 sub a                          ; 97
 altd sub a, a                  ; 76 97
 altd sub a                     ; 76 97
 sub a', a                      ; 76 97
 sub a, (hl)                    ; 96
 sub (hl)                       ; 96
 altd sub a, (hl)               ; 76 96
 altd sub (hl)                  ; 76 96
 sub a', (hl)                   ; 76 96
 sub a, (ix)                    ; DD 96 00
 sub a, (ix + 127)              ; DD 96 7F
 sub a, (ix - 128)              ; DD 96 80
 sub (ix)                       ; DD 96 00
 sub (ix + 127)                 ; DD 96 7F
 sub (ix - 128)                 ; DD 96 80
 altd sub a, (ix)               ; 76 DD 96 00
 altd sub a, (ix + 127)         ; 76 DD 96 7F
 altd sub a, (ix - 128)         ; 76 DD 96 80
 altd sub (ix)                  ; 76 DD 96 00
 altd sub (ix + 127)            ; 76 DD 96 7F
 altd sub (ix - 128)            ; 76 DD 96 80
 sub a', (ix)                   ; 76 DD 96 00
 sub a', (ix + 127)             ; 76 DD 96 7F
 sub a', (ix - 128)             ; 76 DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy + 127)              ; FD 96 7F
 sub a, (iy - 128)              ; FD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy + 127)                 ; FD 96 7F
 sub (iy - 128)                 ; FD 96 80
 altd sub a, (iy)               ; 76 FD 96 00
 altd sub a, (iy + 127)         ; 76 FD 96 7F
 altd sub a, (iy - 128)         ; 76 FD 96 80
 altd sub (iy)                  ; 76 FD 96 00
 altd sub (iy + 127)            ; 76 FD 96 7F
 altd sub (iy - 128)            ; 76 FD 96 80
 sub a', (iy)                   ; 76 FD 96 00
 sub a', (iy + 127)             ; 76 FD 96 7F
 sub a', (iy - 128)             ; 76 FD 96 80
 sub a,  42                     ; D6 2A
 sub a, (42)                    ; D6 2A
 sub  42                        ; D6 2A
 sub (42)                       ; D6 2A
 altd sub a,  42                ; 76 D6 2A
 altd sub a, (42)               ; 76 D6 2A
 altd sub  42                   ; 76 D6 2A
 altd sub (42)                  ; 76 D6 2A
 sub a',  42                    ; 76 D6 2A
 sub a', (42)                   ; 76 D6 2A
 sbc a, b                       ; 98
 sbc b                          ; 98
 altd sbc a, b                  ; 76 98
 altd sbc b                     ; 76 98
 sbc a', b                      ; 76 98
 sbc a, c                       ; 99
 sbc c                          ; 99
 altd sbc a, c                  ; 76 99
 altd sbc c                     ; 76 99
 sbc a', c                      ; 76 99
 sbc a, d                       ; 9A
 sbc d                          ; 9A
 altd sbc a, d                  ; 76 9A
 altd sbc d                     ; 76 9A
 sbc a', d                      ; 76 9A
 sbc a, e                       ; 9B
 sbc e                          ; 9B
 altd sbc a, e                  ; 76 9B
 altd sbc e                     ; 76 9B
 sbc a', e                      ; 76 9B
 sbc a, h                       ; 9C
 sbc h                          ; 9C
 altd sbc a, h                  ; 76 9C
 altd sbc h                     ; 76 9C
 sbc a', h                      ; 76 9C
 sbc a, l                       ; 9D
 sbc l                          ; 9D
 altd sbc a, l                  ; 76 9D
 altd sbc l                     ; 76 9D
 sbc a', l                      ; 76 9D
 sbc a, a                       ; 9F
 sbc a                          ; 9F
 altd sbc a, a                  ; 76 9F
 altd sbc a                     ; 76 9F
 sbc a', a                      ; 76 9F
 sbc a, (hl)                    ; 9E
 sbc (hl)                       ; 9E
 altd sbc a, (hl)               ; 76 9E
 altd sbc (hl)                  ; 76 9E
 sbc a', (hl)                   ; 76 9E
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix + 127)              ; DD 9E 7F
 sbc a, (ix - 128)              ; DD 9E 80
 sbc (ix)                       ; DD 9E 00
 sbc (ix + 127)                 ; DD 9E 7F
 sbc (ix - 128)                 ; DD 9E 80
 altd sbc a, (ix)               ; 76 DD 9E 00
 altd sbc a, (ix + 127)         ; 76 DD 9E 7F
 altd sbc a, (ix - 128)         ; 76 DD 9E 80
 altd sbc (ix)                  ; 76 DD 9E 00
 altd sbc (ix + 127)            ; 76 DD 9E 7F
 altd sbc (ix - 128)            ; 76 DD 9E 80
 sbc a', (ix)                   ; 76 DD 9E 00
 sbc a', (ix + 127)             ; 76 DD 9E 7F
 sbc a', (ix - 128)             ; 76 DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy + 127)              ; FD 9E 7F
 sbc a, (iy - 128)              ; FD 9E 80
 sbc (iy)                       ; FD 9E 00
 sbc (iy + 127)                 ; FD 9E 7F
 sbc (iy - 128)                 ; FD 9E 80
 altd sbc a, (iy)               ; 76 FD 9E 00
 altd sbc a, (iy + 127)         ; 76 FD 9E 7F
 altd sbc a, (iy - 128)         ; 76 FD 9E 80
 altd sbc (iy)                  ; 76 FD 9E 00
 altd sbc (iy + 127)            ; 76 FD 9E 7F
 altd sbc (iy - 128)            ; 76 FD 9E 80
 sbc a', (iy)                   ; 76 FD 9E 00
 sbc a', (iy + 127)             ; 76 FD 9E 7F
 sbc a', (iy - 128)             ; 76 FD 9E 80
 sbc a,  42                     ; DE 2A
 sbc a, (42)                    ; DE 2A
 sbc  42                        ; DE 2A
 sbc (42)                       ; DE 2A
 altd sbc a,  42                ; 76 DE 2A
 altd sbc a, (42)               ; 76 DE 2A
 altd sbc  42                   ; 76 DE 2A
 altd sbc (42)                  ; 76 DE 2A
 sbc a',  42                    ; 76 DE 2A
 sbc a', (42)                   ; 76 DE 2A
 and a, b                       ; A0
 and b                          ; A0
 altd and a, b                  ; 76 A0
 altd and b                     ; 76 A0
 and a', b                      ; 76 A0
 and a, c                       ; A1
 and c                          ; A1
 altd and a, c                  ; 76 A1
 altd and c                     ; 76 A1
 and a', c                      ; 76 A1
 and a, d                       ; A2
 and d                          ; A2
 altd and a, d                  ; 76 A2
 altd and d                     ; 76 A2
 and a', d                      ; 76 A2
 and a, e                       ; A3
 and e                          ; A3
 altd and a, e                  ; 76 A3
 altd and e                     ; 76 A3
 and a', e                      ; 76 A3
 and a, h                       ; A4
 and h                          ; A4
 altd and a, h                  ; 76 A4
 altd and h                     ; 76 A4
 and a', h                      ; 76 A4
 and a, l                       ; A5
 and l                          ; A5
 altd and a, l                  ; 76 A5
 altd and l                     ; 76 A5
 and a', l                      ; 76 A5
 and a, a                       ; A7
 and a                          ; A7
 altd and a, a                  ; 76 A7
 altd and a                     ; 76 A7
 and a', a                      ; 76 A7
 and a, (hl)                    ; A6
 and (hl)                       ; A6
 altd and a, (hl)               ; 76 A6
 altd and (hl)                  ; 76 A6
 and a', (hl)                   ; 76 A6
 and a, (ix)                    ; DD A6 00
 and a, (ix + 127)              ; DD A6 7F
 and a, (ix - 128)              ; DD A6 80
 and (ix)                       ; DD A6 00
 and (ix + 127)                 ; DD A6 7F
 and (ix - 128)                 ; DD A6 80
 altd and a, (ix)               ; 76 DD A6 00
 altd and a, (ix + 127)         ; 76 DD A6 7F
 altd and a, (ix - 128)         ; 76 DD A6 80
 altd and (ix)                  ; 76 DD A6 00
 altd and (ix + 127)            ; 76 DD A6 7F
 altd and (ix - 128)            ; 76 DD A6 80
 and a', (ix)                   ; 76 DD A6 00
 and a', (ix + 127)             ; 76 DD A6 7F
 and a', (ix - 128)             ; 76 DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy + 127)              ; FD A6 7F
 and a, (iy - 128)              ; FD A6 80
 and (iy)                       ; FD A6 00
 and (iy + 127)                 ; FD A6 7F
 and (iy - 128)                 ; FD A6 80
 altd and a, (iy)               ; 76 FD A6 00
 altd and a, (iy + 127)         ; 76 FD A6 7F
 altd and a, (iy - 128)         ; 76 FD A6 80
 altd and (iy)                  ; 76 FD A6 00
 altd and (iy + 127)            ; 76 FD A6 7F
 altd and (iy - 128)            ; 76 FD A6 80
 and a', (iy)                   ; 76 FD A6 00
 and a', (iy + 127)             ; 76 FD A6 7F
 and a', (iy - 128)             ; 76 FD A6 80
 and a,  42                     ; E6 2A
 and a, (42)                    ; E6 2A
 and  42                        ; E6 2A
 and (42)                       ; E6 2A
 altd and a,  42                ; 76 E6 2A
 altd and a, (42)               ; 76 E6 2A
 altd and  42                   ; 76 E6 2A
 altd and (42)                  ; 76 E6 2A
 and a',  42                    ; 76 E6 2A
 and a', (42)                   ; 76 E6 2A
 xor a, b                       ; A8
 xor b                          ; A8
 altd xor a, b                  ; 76 A8
 altd xor b                     ; 76 A8
 xor a', b                      ; 76 A8
 xor a, c                       ; A9
 xor c                          ; A9
 altd xor a, c                  ; 76 A9
 altd xor c                     ; 76 A9
 xor a', c                      ; 76 A9
 xor a, d                       ; AA
 xor d                          ; AA
 altd xor a, d                  ; 76 AA
 altd xor d                     ; 76 AA
 xor a', d                      ; 76 AA
 xor a, e                       ; AB
 xor e                          ; AB
 altd xor a, e                  ; 76 AB
 altd xor e                     ; 76 AB
 xor a', e                      ; 76 AB
 xor a, h                       ; AC
 xor h                          ; AC
 altd xor a, h                  ; 76 AC
 altd xor h                     ; 76 AC
 xor a', h                      ; 76 AC
 xor a, l                       ; AD
 xor l                          ; AD
 altd xor a, l                  ; 76 AD
 altd xor l                     ; 76 AD
 xor a', l                      ; 76 AD
 xor a, a                       ; AF
 xor a                          ; AF
 altd xor a, a                  ; 76 AF
 altd xor a                     ; 76 AF
 xor a', a                      ; 76 AF
 xor a, (hl)                    ; AE
 xor (hl)                       ; AE
 altd xor a, (hl)               ; 76 AE
 altd xor (hl)                  ; 76 AE
 xor a', (hl)                   ; 76 AE
 xor a, (ix)                    ; DD AE 00
 xor a, (ix + 127)              ; DD AE 7F
 xor a, (ix - 128)              ; DD AE 80
 xor (ix)                       ; DD AE 00
 xor (ix + 127)                 ; DD AE 7F
 xor (ix - 128)                 ; DD AE 80
 altd xor a, (ix)               ; 76 DD AE 00
 altd xor a, (ix + 127)         ; 76 DD AE 7F
 altd xor a, (ix - 128)         ; 76 DD AE 80
 altd xor (ix)                  ; 76 DD AE 00
 altd xor (ix + 127)            ; 76 DD AE 7F
 altd xor (ix - 128)            ; 76 DD AE 80
 xor a', (ix)                   ; 76 DD AE 00
 xor a', (ix + 127)             ; 76 DD AE 7F
 xor a', (ix - 128)             ; 76 DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy + 127)              ; FD AE 7F
 xor a, (iy - 128)              ; FD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy + 127)                 ; FD AE 7F
 xor (iy - 128)                 ; FD AE 80
 altd xor a, (iy)               ; 76 FD AE 00
 altd xor a, (iy + 127)         ; 76 FD AE 7F
 altd xor a, (iy - 128)         ; 76 FD AE 80
 altd xor (iy)                  ; 76 FD AE 00
 altd xor (iy + 127)            ; 76 FD AE 7F
 altd xor (iy - 128)            ; 76 FD AE 80
 xor a', (iy)                   ; 76 FD AE 00
 xor a', (iy + 127)             ; 76 FD AE 7F
 xor a', (iy - 128)             ; 76 FD AE 80
 xor a,  42                     ; EE 2A
 xor a, (42)                    ; EE 2A
 xor  42                        ; EE 2A
 xor (42)                       ; EE 2A
 altd xor a,  42                ; 76 EE 2A
 altd xor a, (42)               ; 76 EE 2A
 altd xor  42                   ; 76 EE 2A
 altd xor (42)                  ; 76 EE 2A
 xor a',  42                    ; 76 EE 2A
 xor a', (42)                   ; 76 EE 2A
 or a, b                        ; B0
 or b                           ; B0
 altd or a, b                   ; 76 B0
 altd or b                      ; 76 B0
 or a', b                       ; 76 B0
 or a, c                        ; B1
 or c                           ; B1
 altd or a, c                   ; 76 B1
 altd or c                      ; 76 B1
 or a', c                       ; 76 B1
 or a, d                        ; B2
 or d                           ; B2
 altd or a, d                   ; 76 B2
 altd or d                      ; 76 B2
 or a', d                       ; 76 B2
 or a, e                        ; B3
 or e                           ; B3
 altd or a, e                   ; 76 B3
 altd or e                      ; 76 B3
 or a', e                       ; 76 B3
 or a, h                        ; B4
 or h                           ; B4
 altd or a, h                   ; 76 B4
 altd or h                      ; 76 B4
 or a', h                       ; 76 B4
 or a, l                        ; B5
 or l                           ; B5
 altd or a, l                   ; 76 B5
 altd or l                      ; 76 B5
 or a', l                       ; 76 B5
 or a, a                        ; B7
 or a                           ; B7
 altd or a, a                   ; 76 B7
 altd or a                      ; 76 B7
 or a', a                       ; 76 B7
 or a, (hl)                     ; B6
 or (hl)                        ; B6
 altd or a, (hl)                ; 76 B6
 altd or (hl)                   ; 76 B6
 or a', (hl)                    ; 76 B6
 or a, (ix)                     ; DD B6 00
 or a, (ix + 127)               ; DD B6 7F
 or a, (ix - 128)               ; DD B6 80
 or (ix)                        ; DD B6 00
 or (ix + 127)                  ; DD B6 7F
 or (ix - 128)                  ; DD B6 80
 altd or a, (ix)                ; 76 DD B6 00
 altd or a, (ix + 127)          ; 76 DD B6 7F
 altd or a, (ix - 128)          ; 76 DD B6 80
 altd or (ix)                   ; 76 DD B6 00
 altd or (ix + 127)             ; 76 DD B6 7F
 altd or (ix - 128)             ; 76 DD B6 80
 or a', (ix)                    ; 76 DD B6 00
 or a', (ix + 127)              ; 76 DD B6 7F
 or a', (ix - 128)              ; 76 DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy + 127)               ; FD B6 7F
 or a, (iy - 128)               ; FD B6 80
 or (iy)                        ; FD B6 00
 or (iy + 127)                  ; FD B6 7F
 or (iy - 128)                  ; FD B6 80
 altd or a, (iy)                ; 76 FD B6 00
 altd or a, (iy + 127)          ; 76 FD B6 7F
 altd or a, (iy - 128)          ; 76 FD B6 80
 altd or (iy)                   ; 76 FD B6 00
 altd or (iy + 127)             ; 76 FD B6 7F
 altd or (iy - 128)             ; 76 FD B6 80
 or a', (iy)                    ; 76 FD B6 00
 or a', (iy + 127)              ; 76 FD B6 7F
 or a', (iy - 128)              ; 76 FD B6 80
 or a,  42                      ; F6 2A
 or a, (42)                     ; F6 2A
 or  42                         ; F6 2A
 or (42)                        ; F6 2A
 altd or a,  42                 ; 76 F6 2A
 altd or a, (42)                ; 76 F6 2A
 altd or  42                    ; 76 F6 2A
 altd or (42)                   ; 76 F6 2A
 or a',  42                     ; 76 F6 2A
 or a', (42)                    ; 76 F6 2A
 cp a, b                        ; B8
 cp b                           ; B8
 altd cp a, b                   ; 76 B8
 altd cp b                      ; 76 B8
 cp a', b                       ; 76 B8
 cp a, c                        ; B9
 cp c                           ; B9
 altd cp a, c                   ; 76 B9
 altd cp c                      ; 76 B9
 cp a', c                       ; 76 B9
 cp a, d                        ; BA
 cp d                           ; BA
 altd cp a, d                   ; 76 BA
 altd cp d                      ; 76 BA
 cp a', d                       ; 76 BA
 cp a, e                        ; BB
 cp e                           ; BB
 altd cp a, e                   ; 76 BB
 altd cp e                      ; 76 BB
 cp a', e                       ; 76 BB
 cp a, h                        ; BC
 cp h                           ; BC
 altd cp a, h                   ; 76 BC
 altd cp h                      ; 76 BC
 cp a', h                       ; 76 BC
 cp a, l                        ; BD
 cp l                           ; BD
 altd cp a, l                   ; 76 BD
 altd cp l                      ; 76 BD
 cp a', l                       ; 76 BD
 cp a, a                        ; BF
 cp a                           ; BF
 altd cp a, a                   ; 76 BF
 altd cp a                      ; 76 BF
 cp a', a                       ; 76 BF
 cp a, (hl)                     ; BE
 cp (hl)                        ; BE
 altd cp a, (hl)                ; 76 BE
 altd cp (hl)                   ; 76 BE
 cp a', (hl)                    ; 76 BE
 cp a, (ix)                     ; DD BE 00
 cp a, (ix + 127)               ; DD BE 7F
 cp a, (ix - 128)               ; DD BE 80
 cp (ix)                        ; DD BE 00
 cp (ix + 127)                  ; DD BE 7F
 cp (ix - 128)                  ; DD BE 80
 altd cp a, (ix)                ; 76 DD BE 00
 altd cp a, (ix + 127)          ; 76 DD BE 7F
 altd cp a, (ix - 128)          ; 76 DD BE 80
 altd cp (ix)                   ; 76 DD BE 00
 altd cp (ix + 127)             ; 76 DD BE 7F
 altd cp (ix - 128)             ; 76 DD BE 80
 cp a', (ix)                    ; 76 DD BE 00
 cp a', (ix + 127)              ; 76 DD BE 7F
 cp a', (ix - 128)              ; 76 DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy + 127)               ; FD BE 7F
 cp a, (iy - 128)               ; FD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy + 127)                  ; FD BE 7F
 cp (iy - 128)                  ; FD BE 80
 altd cp a, (iy)                ; 76 FD BE 00
 altd cp a, (iy + 127)          ; 76 FD BE 7F
 altd cp a, (iy - 128)          ; 76 FD BE 80
 altd cp (iy)                   ; 76 FD BE 00
 altd cp (iy + 127)             ; 76 FD BE 7F
 altd cp (iy - 128)             ; 76 FD BE 80
 cp a', (iy)                    ; 76 FD BE 00
 cp a', (iy + 127)              ; 76 FD BE 7F
 cp a', (iy - 128)              ; 76 FD BE 80
 cp a,  42                      ; FE 2A
 cp a, (42)                     ; FE 2A
 cp  42                         ; FE 2A
 cp (42)                        ; FE 2A
 altd cp a,  42                 ; 76 FE 2A
 altd cp a, (42)                ; 76 FE 2A
 altd cp  42                    ; 76 FE 2A
 altd cp (42)                   ; 76 FE 2A
 cp a',  42                     ; 76 FE 2A
 cp a', (42)                    ; 76 FE 2A
 inc b                          ; 04
 altd inc b                     ; 76 04
 inc b'                         ; 76 04
 inc c                          ; 0C
 altd inc c                     ; 76 0C
 inc c'                         ; 76 0C
 inc d                          ; 14
 altd inc d                     ; 76 14
 inc d'                         ; 76 14
 inc e                          ; 1C
 altd inc e                     ; 76 1C
 inc e'                         ; 76 1C
 inc h                          ; 24
 altd inc h                     ; 76 24
 inc h'                         ; 76 24
 inc l                          ; 2C
 altd inc l                     ; 76 2C
 inc l'                         ; 76 2C
 inc a                          ; 3C
 altd inc a                     ; 76 3C
 inc a'                         ; 76 3C
 inc (hl)                       ; 34
 inc (ix)                       ; DD 34 00
 inc (ix + 127)                 ; DD 34 7F
 inc (ix - 128)                 ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy + 127)                 ; FD 34 7F
 inc (iy - 128)                 ; FD 34 80
 dec b                          ; 05
 altd dec b                     ; 76 05
 dec b'                         ; 76 05
 dec c                          ; 0D
 altd dec c                     ; 76 0D
 dec c'                         ; 76 0D
 dec d                          ; 15
 altd dec d                     ; 76 15
 dec d'                         ; 76 15
 dec e                          ; 1D
 altd dec e                     ; 76 1D
 dec e'                         ; 76 1D
 dec h                          ; 25
 altd dec h                     ; 76 25
 dec h'                         ; 76 25
 dec l                          ; 2D
 altd dec l                     ; 76 2D
 dec l'                         ; 76 2D
 dec a                          ; 3D
 altd dec a                     ; 76 3D
 dec a'                         ; 76 3D
 dec (hl)                       ; 35
 dec (ix)                       ; DD 35 00
 dec (ix + 127)                 ; DD 35 7F
 dec (ix - 128)                 ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy + 127)                 ; FD 35 7F
 dec (iy - 128)                 ; FD 35 80
 tst a, b                       ; ED 04
 tst b                          ; ED 04
 tst a, c                       ; ED 0C
 tst c                          ; ED 0C
 tst a, d                       ; ED 14
 tst d                          ; ED 14
 tst a, e                       ; ED 1C
 tst e                          ; ED 1C
 tst a, h                       ; ED 24
 tst h                          ; ED 24
 tst a, l                       ; ED 2C
 tst l                          ; ED 2C
 tst a, a                       ; ED 3C
 tst a                          ; ED 3C
 tst a, (hl)                    ; ED 34
 tst (hl)                       ; ED 34
 tst a,  42                     ; ED 64 2A
 tst a, (42)                    ; ED 64 2A
 tst  42                        ; ED 64 2A
 tst (42)                       ; ED 64 2A
 cpl                            ; 2F
 cpl a                          ; 2F
 altd cpl a                     ; 76 2F
 altd cpl                       ; 76 2F
 cpl a'                         ; 76 2F
 neg                            ; ED 44
 neg a                          ; ED 44
 altd neg a                     ; 76 ED 44
 altd neg                       ; 76 ED 44
 neg a'                         ; 76 ED 44
 ccf                            ; 3F
 ccf f                          ; 3F
 altd ccf f                     ; 76 3F
 altd ccf                       ; 76 3F
 ccf f'                         ; 76 3F
 scf                            ; 37
 scf f                          ; 37
 altd scf f                     ; 76 37
 altd scf                       ; 76 37
 scf f'                         ; 76 37
 ld hl,  256                    ; 21 00 01
 ld hl, (256)                   ; 2A 00 01
 altd ld hl,  256               ; 76 21 00 01
 altd ld hl, (256)              ; 76 2A 00 01
 ld hl',  256                   ; 76 21 00 01
 ld hl', (256)                  ; 76 2A 00 01
 ld ix,  256                    ; DD 21 00 01
 ld ix, (256)                   ; DD 2A 00 01
 ld iy,  256                    ; FD 21 00 01
 ld iy, (256)                   ; FD 2A 00 01
 ld bc,  256                    ; 01 00 01
 ld bc, (256)                   ; ED 4B 00 01
 altd ld bc,  256               ; 76 01 00 01
 altd ld bc, (256)              ; 76 ED 4B 00 01
 ld bc',  256                   ; 76 01 00 01
 ld bc', (256)                  ; 76 ED 4B 00 01
 ld de,  256                    ; 11 00 01
 ld de, (256)                   ; ED 5B 00 01
 altd ld de,  256               ; 76 11 00 01
 altd ld de, (256)              ; 76 ED 5B 00 01
 ld de',  256                   ; 76 11 00 01
 ld de', (256)                  ; 76 ED 5B 00 01
 ld sp,  256                    ; 31 00 01
 ld sp, (256)                   ; ED 7B 00 01
 ld (256), hl                   ; 22 00 01
 ld (256), ix                   ; DD 22 00 01
 ld (256), iy                   ; FD 22 00 01
 ld (256), bc                   ; ED 43 00 01
 ld (256), de                   ; ED 53 00 01
 ld (256), sp                   ; ED 73 00 01
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 push af                        ; F5
 push ix                        ; DD E5
 push iy                        ; FD E5
 pop bc                         ; C1
 altd pop bc                    ; 76 C1
 pop bc'                        ; 76 C1
 pop de                         ; D1
 altd pop de                    ; 76 D1
 pop de'                        ; 76 D1
 pop hl                         ; E1
 altd pop hl                    ; 76 E1
 pop hl'                        ; 76 E1
 pop af                         ; F1
 altd pop af                    ; 76 F1
 pop af'                        ; 76 F1
 pop ix                         ; DD E1
 pop iy                         ; FD E1
 push ip                        ; ED 76
 pop ip                         ; ED 7E
 ld hl, ix                      ; DD 7C
 altd ld hl, ix                 ; 76 DD 7C
 ld hl', ix                     ; 76 DD 7C
 ld ix, hl                      ; DD 7D
 ld hl, iy                      ; FD 7C
 altd ld hl, iy                 ; 76 FD 7C
 ld hl', iy                     ; 76 FD 7C
 ld iy, hl                      ; FD 7D
