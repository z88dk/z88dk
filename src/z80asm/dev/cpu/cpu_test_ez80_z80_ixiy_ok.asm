 aci -128                       ; CE 80
 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc (hl+)                      ; 8E 23
 adc (hl-)                      ; 8E 2B
 adc (ix)                       ; FD 8E 00
 adc (ix+0)                     ; FD 8E 00
 adc (ix+126)                   ; FD 8E 7E
 adc (ix-128)                   ; FD 8E 80
 adc (iy)                       ; DD 8E 00
 adc (iy+0)                     ; DD 8E 00
 adc (iy+126)                   ; DD 8E 7E
 adc (iy-128)                   ; DD 8E 80
 adc -128                       ; CE 80
 adc 0                          ; CE 00
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, (hl+)                   ; 8E 23
 adc a, (hl-)                   ; 8E 2B
 adc a, (ix)                    ; FD 8E 00
 adc a, (ix+0)                  ; FD 8E 00
 adc a, (ix+126)                ; FD 8E 7E
 adc a, (ix-128)                ; FD 8E 80
 adc a, (iy)                    ; DD 8E 00
 adc a, (iy+0)                  ; DD 8E 00
 adc a, (iy+126)                ; DD 8E 7E
 adc a, (iy-128)                ; DD 8E 80
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
 adc a, ixh                     ; FD 8C
 adc a, ixl                     ; FD 8D
 adc a, iyh                     ; DD 8C
 adc a, iyl                     ; DD 8D
 adc a, l                       ; 8D
 adc b                          ; 88
 adc c                          ; 89
 adc d                          ; 8A
 adc e                          ; 8B
 adc h                          ; 8C
 adc hl, bc                     ; CD @__z80asm__adc_hl_bc
 adc hl, de                     ; CD @__z80asm__adc_hl_de
 adc hl, hl                     ; CD @__z80asm__adc_hl_hl
 adc hl, sp                     ; CD @__z80asm__adc_hl_sp
 adc ixh                        ; FD 8C
 adc ixl                        ; FD 8D
 adc iyh                        ; DD 8C
 adc iyl                        ; DD 8D
 adc l                          ; 8D
 adc m                          ; 8E
 adc.l (hl)                     ; 49 8E
 adc.l (hl+)                    ; 49 8E 49 23
 adc.l (hl-)                    ; 49 8E 49 2B
 adc.l (ix)                     ; 49 FD 8E 00
 adc.l (ix+0)                   ; 49 FD 8E 00
 adc.l (ix+126)                 ; 49 FD 8E 7E
 adc.l (ix-128)                 ; 49 FD 8E 80
 adc.l (iy)                     ; 49 DD 8E 00
 adc.l (iy+0)                   ; 49 DD 8E 00
 adc.l (iy+126)                 ; 49 DD 8E 7E
 adc.l (iy-128)                 ; 49 DD 8E 80
 adc.l a, (hl)                  ; 49 8E
 adc.l a, (hl+)                 ; 49 8E 49 23
 adc.l a, (hl-)                 ; 49 8E 49 2B
 adc.l a, (ix)                  ; 49 FD 8E 00
 adc.l a, (ix+0)                ; 49 FD 8E 00
 adc.l a, (ix+126)              ; 49 FD 8E 7E
 adc.l a, (ix-128)              ; 49 FD 8E 80
 adc.l a, (iy)                  ; 49 DD 8E 00
 adc.l a, (iy+0)                ; 49 DD 8E 00
 adc.l a, (iy+126)              ; 49 DD 8E 7E
 adc.l a, (iy-128)              ; 49 DD 8E 80
 adc.lis (hl)                   ; 49 8E
 adc.lis (hl+)                  ; 49 8E 49 23
 adc.lis (hl-)                  ; 49 8E 49 2B
 adc.lis (ix)                   ; 49 FD 8E 00
 adc.lis (ix+0)                 ; 49 FD 8E 00
 adc.lis (ix+126)               ; 49 FD 8E 7E
 adc.lis (ix-128)               ; 49 FD 8E 80
 adc.lis (iy)                   ; 49 DD 8E 00
 adc.lis (iy+0)                 ; 49 DD 8E 00
 adc.lis (iy+126)               ; 49 DD 8E 7E
 adc.lis (iy-128)               ; 49 DD 8E 80
 adc.lis a, (hl)                ; 49 8E
 adc.lis a, (hl+)               ; 49 8E 49 23
 adc.lis a, (hl-)               ; 49 8E 49 2B
 adc.lis a, (ix)                ; 49 FD 8E 00
 adc.lis a, (ix+0)              ; 49 FD 8E 00
 adc.lis a, (ix+126)            ; 49 FD 8E 7E
 adc.lis a, (ix-128)            ; 49 FD 8E 80
 adc.lis a, (iy)                ; 49 DD 8E 00
 adc.lis a, (iy+0)              ; 49 DD 8E 00
 adc.lis a, (iy+126)            ; 49 DD 8E 7E
 adc.lis a, (iy-128)            ; 49 DD 8E 80
 add (hl)                       ; 86
 add (hl+)                      ; 86 23
 add (hl-)                      ; 86 2B
 add (ix)                       ; FD 86 00
 add (ix+0)                     ; FD 86 00
 add (ix+126)                   ; FD 86 7E
 add (ix-128)                   ; FD 86 80
 add (iy)                       ; DD 86 00
 add (iy+0)                     ; DD 86 00
 add (iy+126)                   ; DD 86 7E
 add (iy-128)                   ; DD 86 80
 add -128                       ; C6 80
 add 0                          ; C6 00
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, (hl+)                   ; 86 23
 add a, (hl-)                   ; 86 2B
 add a, (ix)                    ; FD 86 00
 add a, (ix+0)                  ; FD 86 00
 add a, (ix+126)                ; FD 86 7E
 add a, (ix-128)                ; FD 86 80
 add a, (iy)                    ; DD 86 00
 add a, (iy+0)                  ; DD 86 00
 add a, (iy+126)                ; DD 86 7E
 add a, (iy-128)                ; DD 86 80
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
 add a, ixh                     ; FD 84
 add a, ixl                     ; FD 85
 add a, iyh                     ; DD 84
 add a, iyl                     ; DD 85
 add a, l                       ; 85
 add b                          ; 80
 add bc, a                      ; CD @__z80asm__add_bc_a
 add c                          ; 81
 add d                          ; 82
 add de, a                      ; CD @__z80asm__add_de_a
 add e                          ; 83
 add h                          ; 84
 add hl, a                      ; CD @__z80asm__add_hl_a
 add ixh                        ; FD 84
 add ixl                        ; FD 85
 add iyh                        ; DD 84
 add iyl                        ; DD 85
 add l                          ; 85
 add m                          ; 86
 add sp, -128                   ; CD @__z80asm__add_sp_s 80
 add sp, 0                      ; CD @__z80asm__add_sp_s 00
 add sp, 126                    ; CD @__z80asm__add_sp_s 7E
 add.l (hl)                     ; 49 86
 add.l (hl+)                    ; 49 86 49 23
 add.l (hl-)                    ; 49 86 49 2B
 add.l (ix)                     ; 49 FD 86 00
 add.l (ix+0)                   ; 49 FD 86 00
 add.l (ix+126)                 ; 49 FD 86 7E
 add.l (ix-128)                 ; 49 FD 86 80
 add.l (iy)                     ; 49 DD 86 00
 add.l (iy+0)                   ; 49 DD 86 00
 add.l (iy+126)                 ; 49 DD 86 7E
 add.l (iy-128)                 ; 49 DD 86 80
 add.l a, (hl)                  ; 49 86
 add.l a, (hl+)                 ; 49 86 49 23
 add.l a, (hl-)                 ; 49 86 49 2B
 add.l a, (ix)                  ; 49 FD 86 00
 add.l a, (ix+0)                ; 49 FD 86 00
 add.l a, (ix+126)              ; 49 FD 86 7E
 add.l a, (ix-128)              ; 49 FD 86 80
 add.l a, (iy)                  ; 49 DD 86 00
 add.l a, (iy+0)                ; 49 DD 86 00
 add.l a, (iy+126)              ; 49 DD 86 7E
 add.l a, (iy-128)              ; 49 DD 86 80
 add.lis (hl)                   ; 49 86
 add.lis (hl+)                  ; 49 86 49 23
 add.lis (hl-)                  ; 49 86 49 2B
 add.lis (ix)                   ; 49 FD 86 00
 add.lis (ix+0)                 ; 49 FD 86 00
 add.lis (ix+126)               ; 49 FD 86 7E
 add.lis (ix-128)               ; 49 FD 86 80
 add.lis (iy)                   ; 49 DD 86 00
 add.lis (iy+0)                 ; 49 DD 86 00
 add.lis (iy+126)               ; 49 DD 86 7E
 add.lis (iy-128)               ; 49 DD 86 80
 add.lis a, (hl)                ; 49 86
 add.lis a, (hl+)               ; 49 86 49 23
 add.lis a, (hl-)               ; 49 86 49 2B
 add.lis a, (ix)                ; 49 FD 86 00
 add.lis a, (ix+0)              ; 49 FD 86 00
 add.lis a, (ix+126)            ; 49 FD 86 7E
 add.lis a, (ix-128)            ; 49 FD 86 80
 add.lis a, (iy)                ; 49 DD 86 00
 add.lis a, (iy+0)              ; 49 DD 86 00
 add.lis a, (iy+126)            ; 49 DD 86 7E
 add.lis a, (iy-128)            ; 49 DD 86 80
 adi -128                       ; C6 80
 adi 0                          ; C6 00
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 ana a                          ; A7
 ana b                          ; A0
 ana c                          ; A1
 ana d                          ; A2
 ana e                          ; A3
 ana h                          ; A4
 ana l                          ; A5
 ana m                          ; A6
 and (hl)                       ; A6
 and (hl+)                      ; A6 23
 and (hl-)                      ; A6 2B
 and (ix)                       ; FD A6 00
 and (ix+0)                     ; FD A6 00
 and (ix+126)                   ; FD A6 7E
 and (ix-128)                   ; FD A6 80
 and (iy)                       ; DD A6 00
 and (iy+0)                     ; DD A6 00
 and (iy+126)                   ; DD A6 7E
 and (iy-128)                   ; DD A6 80
 and -128                       ; E6 80
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, (hl+)                   ; A6 23
 and a, (hl-)                   ; A6 2B
 and a, (ix)                    ; FD A6 00
 and a, (ix+0)                  ; FD A6 00
 and a, (ix+126)                ; FD A6 7E
 and a, (ix-128)                ; FD A6 80
 and a, (iy)                    ; DD A6 00
 and a, (iy+0)                  ; DD A6 00
 and a, (iy+126)                ; DD A6 7E
 and a, (iy-128)                ; DD A6 80
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
 and a, ixh                     ; FD A4
 and a, ixl                     ; FD A5
 and a, iyh                     ; DD A4
 and a, iyl                     ; DD A5
 and a, l                       ; A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and ixh                        ; FD A4
 and ixl                        ; FD A5
 and iyh                        ; DD A4
 and iyl                        ; DD A5
 and l                          ; A5
 and.l (hl)                     ; 49 A6
 and.l (hl+)                    ; 49 A6 49 23
 and.l (hl-)                    ; 49 A6 49 2B
 and.l (ix)                     ; 49 FD A6 00
 and.l (ix+0)                   ; 49 FD A6 00
 and.l (ix+126)                 ; 49 FD A6 7E
 and.l (ix-128)                 ; 49 FD A6 80
 and.l (iy)                     ; 49 DD A6 00
 and.l (iy+0)                   ; 49 DD A6 00
 and.l (iy+126)                 ; 49 DD A6 7E
 and.l (iy-128)                 ; 49 DD A6 80
 and.l a, (hl)                  ; 49 A6
 and.l a, (hl+)                 ; 49 A6 49 23
 and.l a, (hl-)                 ; 49 A6 49 2B
 and.l a, (ix)                  ; 49 FD A6 00
 and.l a, (ix+0)                ; 49 FD A6 00
 and.l a, (ix+126)              ; 49 FD A6 7E
 and.l a, (ix-128)              ; 49 FD A6 80
 and.l a, (iy)                  ; 49 DD A6 00
 and.l a, (iy+0)                ; 49 DD A6 00
 and.l a, (iy+126)              ; 49 DD A6 7E
 and.l a, (iy-128)              ; 49 DD A6 80
 and.lis (hl)                   ; 49 A6
 and.lis (hl+)                  ; 49 A6 49 23
 and.lis (hl-)                  ; 49 A6 49 2B
 and.lis (ix)                   ; 49 FD A6 00
 and.lis (ix+0)                 ; 49 FD A6 00
 and.lis (ix+126)               ; 49 FD A6 7E
 and.lis (ix-128)               ; 49 FD A6 80
 and.lis (iy)                   ; 49 DD A6 00
 and.lis (iy+0)                 ; 49 DD A6 00
 and.lis (iy+126)               ; 49 DD A6 7E
 and.lis (iy-128)               ; 49 DD A6 80
 and.lis a, (hl)                ; 49 A6
 and.lis a, (hl+)               ; 49 A6 49 23
 and.lis a, (hl-)               ; 49 A6 49 2B
 and.lis a, (ix)                ; 49 FD A6 00
 and.lis a, (ix+0)              ; 49 FD A6 00
 and.lis a, (ix+126)            ; 49 FD A6 7E
 and.lis a, (ix-128)            ; 49 FD A6 80
 and.lis a, (iy)                ; 49 DD A6 00
 and.lis a, (iy+0)              ; 49 DD A6 00
 and.lis a, (iy+126)            ; 49 DD A6 7E
 and.lis a, (iy-128)            ; 49 DD A6 80
 ani -128                       ; E6 80
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CD @__z80asm__sra_hl
 call (hl)                      ; CD @__z80asm__call_hl
 cmp (hl)                       ; BE
 cmp (hl+)                      ; BE 23
 cmp (hl-)                      ; BE 2B
 cmp (ix)                       ; FD BE 00
 cmp (ix+0)                     ; FD BE 00
 cmp (ix+126)                   ; FD BE 7E
 cmp (ix-128)                   ; FD BE 80
 cmp (iy)                       ; DD BE 00
 cmp (iy+0)                     ; DD BE 00
 cmp (iy+126)                   ; DD BE 7E
 cmp (iy-128)                   ; DD BE 80
 cmp -128                       ; FE 80
 cmp 0                          ; FE 00
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, (hl+)                   ; BE 23
 cmp a, (hl-)                   ; BE 2B
 cmp a, (ix)                    ; FD BE 00
 cmp a, (ix+0)                  ; FD BE 00
 cmp a, (ix+126)                ; FD BE 7E
 cmp a, (ix-128)                ; FD BE 80
 cmp a, (iy)                    ; DD BE 00
 cmp a, (iy+0)                  ; DD BE 00
 cmp a, (iy+126)                ; DD BE 7E
 cmp a, (iy-128)                ; DD BE 80
 cmp a, -128                    ; FE 80
 cmp a, 0                       ; FE 00
 cmp a, 127                     ; FE 7F
 cmp a, 255                     ; FE FF
 cmp a, a                       ; BF
 cmp a, b                       ; B8
 cmp a, c                       ; B9
 cmp a, d                       ; BA
 cmp a, e                       ; BB
 cmp a, h                       ; BC
 cmp a, ixh                     ; FD BC
 cmp a, ixl                     ; FD BD
 cmp a, iyh                     ; DD BC
 cmp a, iyl                     ; DD BD
 cmp a, l                       ; BD
 cmp b                          ; B8
 cmp c                          ; B9
 cmp d                          ; BA
 cmp e                          ; BB
 cmp h                          ; BC
 cmp ixh                        ; FD BC
 cmp ixl                        ; FD BD
 cmp iyh                        ; DD BC
 cmp iyl                        ; DD BD
 cmp l                          ; BD
 cmp m                          ; BE
 cmp.l (hl)                     ; 49 BE
 cmp.l (hl+)                    ; 49 BE 49 23
 cmp.l (hl-)                    ; 49 BE 49 2B
 cmp.l (ix)                     ; 49 FD BE 00
 cmp.l (ix+0)                   ; 49 FD BE 00
 cmp.l (ix+126)                 ; 49 FD BE 7E
 cmp.l (ix-128)                 ; 49 FD BE 80
 cmp.l (iy)                     ; 49 DD BE 00
 cmp.l (iy+0)                   ; 49 DD BE 00
 cmp.l (iy+126)                 ; 49 DD BE 7E
 cmp.l (iy-128)                 ; 49 DD BE 80
 cmp.l a, (hl)                  ; 49 BE
 cmp.l a, (hl+)                 ; 49 BE 49 23
 cmp.l a, (hl-)                 ; 49 BE 49 2B
 cmp.l a, (ix)                  ; 49 FD BE 00
 cmp.l a, (ix+0)                ; 49 FD BE 00
 cmp.l a, (ix+126)              ; 49 FD BE 7E
 cmp.l a, (ix-128)              ; 49 FD BE 80
 cmp.l a, (iy)                  ; 49 DD BE 00
 cmp.l a, (iy+0)                ; 49 DD BE 00
 cmp.l a, (iy+126)              ; 49 DD BE 7E
 cmp.l a, (iy-128)              ; 49 DD BE 80
 cmp.lis (hl)                   ; 49 BE
 cmp.lis (hl+)                  ; 49 BE 49 23
 cmp.lis (hl-)                  ; 49 BE 49 2B
 cmp.lis (ix)                   ; 49 FD BE 00
 cmp.lis (ix+0)                 ; 49 FD BE 00
 cmp.lis (ix+126)               ; 49 FD BE 7E
 cmp.lis (ix-128)               ; 49 FD BE 80
 cmp.lis (iy)                   ; 49 DD BE 00
 cmp.lis (iy+0)                 ; 49 DD BE 00
 cmp.lis (iy+126)               ; 49 DD BE 7E
 cmp.lis (iy-128)               ; 49 DD BE 80
 cmp.lis a, (hl)                ; 49 BE
 cmp.lis a, (hl+)               ; 49 BE 49 23
 cmp.lis a, (hl-)               ; 49 BE 49 2B
 cmp.lis a, (ix)                ; 49 FD BE 00
 cmp.lis a, (ix+0)              ; 49 FD BE 00
 cmp.lis a, (ix+126)            ; 49 FD BE 7E
 cmp.lis a, (ix-128)            ; 49 FD BE 80
 cmp.lis a, (iy)                ; 49 DD BE 00
 cmp.lis a, (iy+0)              ; 49 DD BE 00
 cmp.lis a, (iy+126)            ; 49 DD BE 7E
 cmp.lis a, (iy-128)            ; 49 DD BE 80
 cp (hl)                        ; BE
 cp (hl+)                       ; BE 23
 cp (hl-)                       ; BE 2B
 cp (ix)                        ; FD BE 00
 cp (ix+0)                      ; FD BE 00
 cp (ix+126)                    ; FD BE 7E
 cp (ix-128)                    ; FD BE 80
 cp (iy)                        ; DD BE 00
 cp (iy+0)                      ; DD BE 00
 cp (iy+126)                    ; DD BE 7E
 cp (iy-128)                    ; DD BE 80
 cp -128                        ; FE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, (hl+)                    ; BE 23
 cp a, (hl-)                    ; BE 2B
 cp a, (ix)                     ; FD BE 00
 cp a, (ix+0)                   ; FD BE 00
 cp a, (ix+126)                 ; FD BE 7E
 cp a, (ix-128)                 ; FD BE 80
 cp a, (iy)                     ; DD BE 00
 cp a, (iy+0)                   ; DD BE 00
 cp a, (iy+126)                 ; DD BE 7E
 cp a, (iy-128)                 ; DD BE 80
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
 cp a, ixh                      ; FD BC
 cp a, ixl                      ; FD BD
 cp a, iyh                      ; DD BC
 cp a, iyl                      ; DD BD
 cp a, l                        ; BD
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp ixh                         ; FD BC
 cp ixl                         ; FD BD
 cp iyh                         ; DD BC
 cp iyl                         ; DD BD
 cp l                           ; BD
 cp.l (hl)                      ; 49 BE
 cp.l (hl+)                     ; 49 BE 49 23
 cp.l (hl-)                     ; 49 BE 49 2B
 cp.l (ix)                      ; 49 FD BE 00
 cp.l (ix+0)                    ; 49 FD BE 00
 cp.l (ix+126)                  ; 49 FD BE 7E
 cp.l (ix-128)                  ; 49 FD BE 80
 cp.l (iy)                      ; 49 DD BE 00
 cp.l (iy+0)                    ; 49 DD BE 00
 cp.l (iy+126)                  ; 49 DD BE 7E
 cp.l (iy-128)                  ; 49 DD BE 80
 cp.l a, (hl)                   ; 49 BE
 cp.l a, (hl+)                  ; 49 BE 49 23
 cp.l a, (hl-)                  ; 49 BE 49 2B
 cp.l a, (ix)                   ; 49 FD BE 00
 cp.l a, (ix+0)                 ; 49 FD BE 00
 cp.l a, (ix+126)               ; 49 FD BE 7E
 cp.l a, (ix-128)               ; 49 FD BE 80
 cp.l a, (iy)                   ; 49 DD BE 00
 cp.l a, (iy+0)                 ; 49 DD BE 00
 cp.l a, (iy+126)               ; 49 DD BE 7E
 cp.l a, (iy-128)               ; 49 DD BE 80
 cp.lis (hl)                    ; 49 BE
 cp.lis (hl+)                   ; 49 BE 49 23
 cp.lis (hl-)                   ; 49 BE 49 2B
 cp.lis (ix)                    ; 49 FD BE 00
 cp.lis (ix+0)                  ; 49 FD BE 00
 cp.lis (ix+126)                ; 49 FD BE 7E
 cp.lis (ix-128)                ; 49 FD BE 80
 cp.lis (iy)                    ; 49 DD BE 00
 cp.lis (iy+0)                  ; 49 DD BE 00
 cp.lis (iy+126)                ; 49 DD BE 7E
 cp.lis (iy-128)                ; 49 DD BE 80
 cp.lis a, (hl)                 ; 49 BE
 cp.lis a, (hl+)                ; 49 BE 49 23
 cp.lis a, (hl-)                ; 49 BE 49 2B
 cp.lis a, (ix)                 ; 49 FD BE 00
 cp.lis a, (ix+0)               ; 49 FD BE 00
 cp.lis a, (ix+126)             ; 49 FD BE 7E
 cp.lis a, (ix-128)             ; 49 FD BE 80
 cp.lis a, (iy)                 ; 49 DD BE 00
 cp.lis a, (iy+0)               ; 49 DD BE 00
 cp.lis a, (iy+126)             ; 49 DD BE 7E
 cp.lis a, (iy-128)             ; 49 DD BE 80
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpi                            ; CD @__z80asm__cpi
 cpi -128                       ; FE 80
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; CD @__z80asm__cpir
 daa                            ; CD @__z80asm__daa
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
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex (sp), hl                    ; CD @__z80asm__ex_sp_hl
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
 ldd                            ; CD @__z80asm__ldd
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldir                           ; CD @__z80asm__ldir
 or (hl)                        ; B6
 or (hl+)                       ; B6 23
 or (hl-)                       ; B6 2B
 or (ix)                        ; FD B6 00
 or (ix+0)                      ; FD B6 00
 or (ix+126)                    ; FD B6 7E
 or (ix-128)                    ; FD B6 80
 or (iy)                        ; DD B6 00
 or (iy+0)                      ; DD B6 00
 or (iy+126)                    ; DD B6 7E
 or (iy-128)                    ; DD B6 80
 or -128                        ; F6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, (hl+)                    ; B6 23
 or a, (hl-)                    ; B6 2B
 or a, (ix)                     ; FD B6 00
 or a, (ix+0)                   ; FD B6 00
 or a, (ix+126)                 ; FD B6 7E
 or a, (ix-128)                 ; FD B6 80
 or a, (iy)                     ; DD B6 00
 or a, (iy+0)                   ; DD B6 00
 or a, (iy+126)                 ; DD B6 7E
 or a, (iy-128)                 ; DD B6 80
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
 or a, ixh                      ; FD B4
 or a, ixl                      ; FD B5
 or a, iyh                      ; DD B4
 or a, iyl                      ; DD B5
 or a, l                        ; B5
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or ixh                         ; FD B4
 or ixl                         ; FD B5
 or iyh                         ; DD B4
 or iyl                         ; DD B5
 or l                           ; B5
 or.l (hl)                      ; 49 B6
 or.l (hl+)                     ; 49 B6 49 23
 or.l (hl-)                     ; 49 B6 49 2B
 or.l (ix)                      ; 49 FD B6 00
 or.l (ix+0)                    ; 49 FD B6 00
 or.l (ix+126)                  ; 49 FD B6 7E
 or.l (ix-128)                  ; 49 FD B6 80
 or.l (iy)                      ; 49 DD B6 00
 or.l (iy+0)                    ; 49 DD B6 00
 or.l (iy+126)                  ; 49 DD B6 7E
 or.l (iy-128)                  ; 49 DD B6 80
 or.l a, (hl)                   ; 49 B6
 or.l a, (hl+)                  ; 49 B6 49 23
 or.l a, (hl-)                  ; 49 B6 49 2B
 or.l a, (ix)                   ; 49 FD B6 00
 or.l a, (ix+0)                 ; 49 FD B6 00
 or.l a, (ix+126)               ; 49 FD B6 7E
 or.l a, (ix-128)               ; 49 FD B6 80
 or.l a, (iy)                   ; 49 DD B6 00
 or.l a, (iy+0)                 ; 49 DD B6 00
 or.l a, (iy+126)               ; 49 DD B6 7E
 or.l a, (iy-128)               ; 49 DD B6 80
 or.lis (hl)                    ; 49 B6
 or.lis (hl+)                   ; 49 B6 49 23
 or.lis (hl-)                   ; 49 B6 49 2B
 or.lis (ix)                    ; 49 FD B6 00
 or.lis (ix+0)                  ; 49 FD B6 00
 or.lis (ix+126)                ; 49 FD B6 7E
 or.lis (ix-128)                ; 49 FD B6 80
 or.lis (iy)                    ; 49 DD B6 00
 or.lis (iy+0)                  ; 49 DD B6 00
 or.lis (iy+126)                ; 49 DD B6 7E
 or.lis (iy-128)                ; 49 DD B6 80
 or.lis a, (hl)                 ; 49 B6
 or.lis a, (hl+)                ; 49 B6 49 23
 or.lis a, (hl-)                ; 49 B6 49 2B
 or.lis a, (ix)                 ; 49 FD B6 00
 or.lis a, (ix+0)               ; 49 FD B6 00
 or.lis a, (ix+126)             ; 49 FD B6 7E
 or.lis a, (ix-128)             ; 49 FD B6 80
 or.lis a, (iy)                 ; 49 DD B6 00
 or.lis a, (iy+0)               ; 49 DD B6 00
 or.lis a, (iy+126)             ; 49 DD B6 7E
 or.lis a, (iy-128)             ; 49 DD B6 80
 ora a                          ; B7
 ora b                          ; B0
 ora c                          ; B1
 ora d                          ; B2
 ora e                          ; B3
 ora h                          ; B4
 ora l                          ; B5
 ora m                          ; B6
 ori -128                       ; F6 80
 ori 0                          ; F6 00
 ori 127                        ; F6 7F
 ori 255                        ; F6 FF
 rdel                           ; CD @__z80asm__rl_de
 rl bc                          ; CD @__z80asm__rl_bc
 rl de                          ; CD @__z80asm__rl_de
 rl hl                          ; CD @__z80asm__rl_hl
 rld                            ; CD @__z80asm__rld
 rlde                           ; CD @__z80asm__rl_de
 rr bc                          ; CD @__z80asm__rr_bc
 rr de                          ; CD @__z80asm__rr_de
 rr hl                          ; CD @__z80asm__rr_hl
 rrd                            ; CD @__z80asm__rrd
 rrhl                           ; CD @__z80asm__sra_hl
 sbb a                          ; 9F
 sbb b                          ; 98
 sbb c                          ; 99
 sbb d                          ; 9A
 sbb e                          ; 9B
 sbb h                          ; 9C
 sbb l                          ; 9D
 sbb m                          ; 9E
 sbc (hl)                       ; 9E
 sbc (hl+)                      ; 9E 23
 sbc (hl-)                      ; 9E 2B
 sbc (ix)                       ; FD 9E 00
 sbc (ix+0)                     ; FD 9E 00
 sbc (ix+126)                   ; FD 9E 7E
 sbc (ix-128)                   ; FD 9E 80
 sbc (iy)                       ; DD 9E 00
 sbc (iy+0)                     ; DD 9E 00
 sbc (iy+126)                   ; DD 9E 7E
 sbc (iy-128)                   ; DD 9E 80
 sbc -128                       ; DE 80
 sbc 0                          ; DE 00
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, (hl+)                   ; 9E 23
 sbc a, (hl-)                   ; 9E 2B
 sbc a, (ix)                    ; FD 9E 00
 sbc a, (ix+0)                  ; FD 9E 00
 sbc a, (ix+126)                ; FD 9E 7E
 sbc a, (ix-128)                ; FD 9E 80
 sbc a, (iy)                    ; DD 9E 00
 sbc a, (iy+0)                  ; DD 9E 00
 sbc a, (iy+126)                ; DD 9E 7E
 sbc a, (iy-128)                ; DD 9E 80
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
 sbc a, ixh                     ; FD 9C
 sbc a, ixl                     ; FD 9D
 sbc a, iyh                     ; DD 9C
 sbc a, iyl                     ; DD 9D
 sbc a, l                       ; 9D
 sbc b                          ; 98
 sbc c                          ; 99
 sbc d                          ; 9A
 sbc e                          ; 9B
 sbc h                          ; 9C
 sbc hl, bc                     ; CD @__z80asm__sbc_hl_bc
 sbc hl, de                     ; CD @__z80asm__sbc_hl_de
 sbc hl, hl                     ; CD @__z80asm__sbc_hl_hl
 sbc hl, sp                     ; CD @__z80asm__sbc_hl_sp
 sbc ixh                        ; FD 9C
 sbc ixl                        ; FD 9D
 sbc iyh                        ; DD 9C
 sbc iyl                        ; DD 9D
 sbc l                          ; 9D
 sbc.l (hl)                     ; 49 9E
 sbc.l (hl+)                    ; 49 9E 49 23
 sbc.l (hl-)                    ; 49 9E 49 2B
 sbc.l (ix)                     ; 49 FD 9E 00
 sbc.l (ix+0)                   ; 49 FD 9E 00
 sbc.l (ix+126)                 ; 49 FD 9E 7E
 sbc.l (ix-128)                 ; 49 FD 9E 80
 sbc.l (iy)                     ; 49 DD 9E 00
 sbc.l (iy+0)                   ; 49 DD 9E 00
 sbc.l (iy+126)                 ; 49 DD 9E 7E
 sbc.l (iy-128)                 ; 49 DD 9E 80
 sbc.l a, (hl)                  ; 49 9E
 sbc.l a, (hl+)                 ; 49 9E 49 23
 sbc.l a, (hl-)                 ; 49 9E 49 2B
 sbc.l a, (ix)                  ; 49 FD 9E 00
 sbc.l a, (ix+0)                ; 49 FD 9E 00
 sbc.l a, (ix+126)              ; 49 FD 9E 7E
 sbc.l a, (ix-128)              ; 49 FD 9E 80
 sbc.l a, (iy)                  ; 49 DD 9E 00
 sbc.l a, (iy+0)                ; 49 DD 9E 00
 sbc.l a, (iy+126)              ; 49 DD 9E 7E
 sbc.l a, (iy-128)              ; 49 DD 9E 80
 sbc.lis (hl)                   ; 49 9E
 sbc.lis (hl+)                  ; 49 9E 49 23
 sbc.lis (hl-)                  ; 49 9E 49 2B
 sbc.lis (ix)                   ; 49 FD 9E 00
 sbc.lis (ix+0)                 ; 49 FD 9E 00
 sbc.lis (ix+126)               ; 49 FD 9E 7E
 sbc.lis (ix-128)               ; 49 FD 9E 80
 sbc.lis (iy)                   ; 49 DD 9E 00
 sbc.lis (iy+0)                 ; 49 DD 9E 00
 sbc.lis (iy+126)               ; 49 DD 9E 7E
 sbc.lis (iy-128)               ; 49 DD 9E 80
 sbc.lis a, (hl)                ; 49 9E
 sbc.lis a, (hl+)               ; 49 9E 49 23
 sbc.lis a, (hl-)               ; 49 9E 49 2B
 sbc.lis a, (ix)                ; 49 FD 9E 00
 sbc.lis a, (ix+0)              ; 49 FD 9E 00
 sbc.lis a, (ix+126)            ; 49 FD 9E 7E
 sbc.lis a, (ix-128)            ; 49 FD 9E 80
 sbc.lis a, (iy)                ; 49 DD 9E 00
 sbc.lis a, (iy+0)              ; 49 DD 9E 00
 sbc.lis a, (iy+126)            ; 49 DD 9E 7E
 sbc.lis a, (iy-128)            ; 49 DD 9E 80
 sbi -128                       ; DE 80
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 sra bc                         ; CD @__z80asm__sra_bc
 sra de                         ; CD @__z80asm__sra_de
 sra hl                         ; CD @__z80asm__sra_hl
 sub (hl)                       ; 96
 sub (hl+)                      ; 96 23
 sub (hl-)                      ; 96 2B
 sub (ix)                       ; FD 96 00
 sub (ix+0)                     ; FD 96 00
 sub (ix+126)                   ; FD 96 7E
 sub (ix-128)                   ; FD 96 80
 sub (iy)                       ; DD 96 00
 sub (iy+0)                     ; DD 96 00
 sub (iy+126)                   ; DD 96 7E
 sub (iy-128)                   ; DD 96 80
 sub -128                       ; D6 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, (hl+)                   ; 96 23
 sub a, (hl-)                   ; 96 2B
 sub a, (ix)                    ; FD 96 00
 sub a, (ix+0)                  ; FD 96 00
 sub a, (ix+126)                ; FD 96 7E
 sub a, (ix-128)                ; FD 96 80
 sub a, (iy)                    ; DD 96 00
 sub a, (iy+0)                  ; DD 96 00
 sub a, (iy+126)                ; DD 96 7E
 sub a, (iy-128)                ; DD 96 80
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
 sub a, ixh                     ; FD 94
 sub a, ixl                     ; FD 95
 sub a, iyh                     ; DD 94
 sub a, iyl                     ; DD 95
 sub a, l                       ; 95
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub hl, bc                     ; CD @__z80asm__sub_hl_bc
 sub hl, de                     ; CD @__z80asm__sub_hl_de
 sub hl, hl                     ; CD @__z80asm__sub_hl_hl
 sub hl, sp                     ; CD @__z80asm__sub_hl_sp
 sub ixh                        ; FD 94
 sub ixl                        ; FD 95
 sub iyh                        ; DD 94
 sub iyl                        ; DD 95
 sub l                          ; 95
 sub m                          ; 96
 sub.l (hl)                     ; 49 96
 sub.l (hl+)                    ; 49 96 49 23
 sub.l (hl-)                    ; 49 96 49 2B
 sub.l (ix)                     ; 49 FD 96 00
 sub.l (ix+0)                   ; 49 FD 96 00
 sub.l (ix+126)                 ; 49 FD 96 7E
 sub.l (ix-128)                 ; 49 FD 96 80
 sub.l (iy)                     ; 49 DD 96 00
 sub.l (iy+0)                   ; 49 DD 96 00
 sub.l (iy+126)                 ; 49 DD 96 7E
 sub.l (iy-128)                 ; 49 DD 96 80
 sub.l a, (hl)                  ; 49 96
 sub.l a, (hl+)                 ; 49 96 49 23
 sub.l a, (hl-)                 ; 49 96 49 2B
 sub.l a, (ix)                  ; 49 FD 96 00
 sub.l a, (ix+0)                ; 49 FD 96 00
 sub.l a, (ix+126)              ; 49 FD 96 7E
 sub.l a, (ix-128)              ; 49 FD 96 80
 sub.l a, (iy)                  ; 49 DD 96 00
 sub.l a, (iy+0)                ; 49 DD 96 00
 sub.l a, (iy+126)              ; 49 DD 96 7E
 sub.l a, (iy-128)              ; 49 DD 96 80
 sub.lis (hl)                   ; 49 96
 sub.lis (hl+)                  ; 49 96 49 23
 sub.lis (hl-)                  ; 49 96 49 2B
 sub.lis (ix)                   ; 49 FD 96 00
 sub.lis (ix+0)                 ; 49 FD 96 00
 sub.lis (ix+126)               ; 49 FD 96 7E
 sub.lis (ix-128)               ; 49 FD 96 80
 sub.lis (iy)                   ; 49 DD 96 00
 sub.lis (iy+0)                 ; 49 DD 96 00
 sub.lis (iy+126)               ; 49 DD 96 7E
 sub.lis (iy-128)               ; 49 DD 96 80
 sub.lis a, (hl)                ; 49 96
 sub.lis a, (hl+)               ; 49 96 49 23
 sub.lis a, (hl-)               ; 49 96 49 2B
 sub.lis a, (ix)                ; 49 FD 96 00
 sub.lis a, (ix+0)              ; 49 FD 96 00
 sub.lis a, (ix+126)            ; 49 FD 96 7E
 sub.lis a, (ix-128)            ; 49 FD 96 80
 sub.lis a, (iy)                ; 49 DD 96 00
 sub.lis a, (iy+0)              ; 49 DD 96 00
 sub.lis a, (iy+126)            ; 49 DD 96 7E
 sub.lis a, (iy-128)            ; 49 DD 96 80
 sui -128                       ; D6 80
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xor (hl)                       ; AE
 xor (hl+)                      ; AE 23
 xor (hl-)                      ; AE 2B
 xor (ix)                       ; FD AE 00
 xor (ix+0)                     ; FD AE 00
 xor (ix+126)                   ; FD AE 7E
 xor (ix-128)                   ; FD AE 80
 xor (iy)                       ; DD AE 00
 xor (iy+0)                     ; DD AE 00
 xor (iy+126)                   ; DD AE 7E
 xor (iy-128)                   ; DD AE 80
 xor -128                       ; EE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, (hl+)                   ; AE 23
 xor a, (hl-)                   ; AE 2B
 xor a, (ix)                    ; FD AE 00
 xor a, (ix+0)                  ; FD AE 00
 xor a, (ix+126)                ; FD AE 7E
 xor a, (ix-128)                ; FD AE 80
 xor a, (iy)                    ; DD AE 00
 xor a, (iy+0)                  ; DD AE 00
 xor a, (iy+126)                ; DD AE 7E
 xor a, (iy-128)                ; DD AE 80
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
 xor a, ixh                     ; FD AC
 xor a, ixl                     ; FD AD
 xor a, iyh                     ; DD AC
 xor a, iyl                     ; DD AD
 xor a, l                       ; AD
 xor b                          ; A8
 xor c                          ; A9
 xor d                          ; AA
 xor e                          ; AB
 xor h                          ; AC
 xor ixh                        ; FD AC
 xor ixl                        ; FD AD
 xor iyh                        ; DD AC
 xor iyl                        ; DD AD
 xor l                          ; AD
 xor.l (hl)                     ; 49 AE
 xor.l (hl+)                    ; 49 AE 49 23
 xor.l (hl-)                    ; 49 AE 49 2B
 xor.l (ix)                     ; 49 FD AE 00
 xor.l (ix+0)                   ; 49 FD AE 00
 xor.l (ix+126)                 ; 49 FD AE 7E
 xor.l (ix-128)                 ; 49 FD AE 80
 xor.l (iy)                     ; 49 DD AE 00
 xor.l (iy+0)                   ; 49 DD AE 00
 xor.l (iy+126)                 ; 49 DD AE 7E
 xor.l (iy-128)                 ; 49 DD AE 80
 xor.l a, (hl)                  ; 49 AE
 xor.l a, (hl+)                 ; 49 AE 49 23
 xor.l a, (hl-)                 ; 49 AE 49 2B
 xor.l a, (ix)                  ; 49 FD AE 00
 xor.l a, (ix+0)                ; 49 FD AE 00
 xor.l a, (ix+126)              ; 49 FD AE 7E
 xor.l a, (ix-128)              ; 49 FD AE 80
 xor.l a, (iy)                  ; 49 DD AE 00
 xor.l a, (iy+0)                ; 49 DD AE 00
 xor.l a, (iy+126)              ; 49 DD AE 7E
 xor.l a, (iy-128)              ; 49 DD AE 80
 xor.lis (hl)                   ; 49 AE
 xor.lis (hl+)                  ; 49 AE 49 23
 xor.lis (hl-)                  ; 49 AE 49 2B
 xor.lis (ix)                   ; 49 FD AE 00
 xor.lis (ix+0)                 ; 49 FD AE 00
 xor.lis (ix+126)               ; 49 FD AE 7E
 xor.lis (ix-128)               ; 49 FD AE 80
 xor.lis (iy)                   ; 49 DD AE 00
 xor.lis (iy+0)                 ; 49 DD AE 00
 xor.lis (iy+126)               ; 49 DD AE 7E
 xor.lis (iy-128)               ; 49 DD AE 80
 xor.lis a, (hl)                ; 49 AE
 xor.lis a, (hl+)               ; 49 AE 49 23
 xor.lis a, (hl-)               ; 49 AE 49 2B
 xor.lis a, (ix)                ; 49 FD AE 00
 xor.lis a, (ix+0)              ; 49 FD AE 00
 xor.lis a, (ix+126)            ; 49 FD AE 7E
 xor.lis a, (ix-128)            ; 49 FD AE 80
 xor.lis a, (iy)                ; 49 DD AE 00
 xor.lis a, (iy+0)              ; 49 DD AE 00
 xor.lis a, (iy+126)            ; 49 DD AE 7E
 xor.lis a, (iy-128)            ; 49 DD AE 80
 xra a                          ; AF
 xra b                          ; A8
 xra c                          ; A9
 xra d                          ; AA
 xra e                          ; AB
 xra h                          ; AC
 xra l                          ; AD
 xra m                          ; AE
 xri -128                       ; EE 80
 xri 0                          ; EE 00
 xri 127                        ; EE 7F
 xri 255                        ; EE FF
 xthl                           ; CD @__z80asm__ex_sp_hl
