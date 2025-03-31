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
 adc.s (hl)                     ; 52 8E
 adc.s (hl+)                    ; 52 8E 52 23
 adc.s (hl-)                    ; 52 8E 52 2B
 adc.s (ix)                     ; 52 FD 8E 00
 adc.s (ix+0)                   ; 52 FD 8E 00
 adc.s (ix+126)                 ; 52 FD 8E 7E
 adc.s (ix-128)                 ; 52 FD 8E 80
 adc.s (iy)                     ; 52 DD 8E 00
 adc.s (iy+0)                   ; 52 DD 8E 00
 adc.s (iy+126)                 ; 52 DD 8E 7E
 adc.s (iy-128)                 ; 52 DD 8E 80
 adc.s a, (hl)                  ; 52 8E
 adc.s a, (hl+)                 ; 52 8E 52 23
 adc.s a, (hl-)                 ; 52 8E 52 2B
 adc.s a, (ix)                  ; 52 FD 8E 00
 adc.s a, (ix+0)                ; 52 FD 8E 00
 adc.s a, (ix+126)              ; 52 FD 8E 7E
 adc.s a, (ix-128)              ; 52 FD 8E 80
 adc.s a, (iy)                  ; 52 DD 8E 00
 adc.s a, (iy+0)                ; 52 DD 8E 00
 adc.s a, (iy+126)              ; 52 DD 8E 7E
 adc.s a, (iy-128)              ; 52 DD 8E 80
 adc.sil (hl)                   ; 52 8E
 adc.sil (hl+)                  ; 52 8E 52 23
 adc.sil (hl-)                  ; 52 8E 52 2B
 adc.sil (ix)                   ; 52 FD 8E 00
 adc.sil (ix+0)                 ; 52 FD 8E 00
 adc.sil (ix+126)               ; 52 FD 8E 7E
 adc.sil (ix-128)               ; 52 FD 8E 80
 adc.sil (iy)                   ; 52 DD 8E 00
 adc.sil (iy+0)                 ; 52 DD 8E 00
 adc.sil (iy+126)               ; 52 DD 8E 7E
 adc.sil (iy-128)               ; 52 DD 8E 80
 adc.sil a, (hl)                ; 52 8E
 adc.sil a, (hl+)               ; 52 8E 52 23
 adc.sil a, (hl-)               ; 52 8E 52 2B
 adc.sil a, (ix)                ; 52 FD 8E 00
 adc.sil a, (ix+0)              ; 52 FD 8E 00
 adc.sil a, (ix+126)            ; 52 FD 8E 7E
 adc.sil a, (ix-128)            ; 52 FD 8E 80
 adc.sil a, (iy)                ; 52 DD 8E 00
 adc.sil a, (iy+0)              ; 52 DD 8E 00
 adc.sil a, (iy+126)            ; 52 DD 8E 7E
 adc.sil a, (iy-128)            ; 52 DD 8E 80
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
 add.s (hl)                     ; 52 86
 add.s (hl+)                    ; 52 86 52 23
 add.s (hl-)                    ; 52 86 52 2B
 add.s (ix)                     ; 52 FD 86 00
 add.s (ix+0)                   ; 52 FD 86 00
 add.s (ix+126)                 ; 52 FD 86 7E
 add.s (ix-128)                 ; 52 FD 86 80
 add.s (iy)                     ; 52 DD 86 00
 add.s (iy+0)                   ; 52 DD 86 00
 add.s (iy+126)                 ; 52 DD 86 7E
 add.s (iy-128)                 ; 52 DD 86 80
 add.s a, (hl)                  ; 52 86
 add.s a, (hl+)                 ; 52 86 52 23
 add.s a, (hl-)                 ; 52 86 52 2B
 add.s a, (ix)                  ; 52 FD 86 00
 add.s a, (ix+0)                ; 52 FD 86 00
 add.s a, (ix+126)              ; 52 FD 86 7E
 add.s a, (ix-128)              ; 52 FD 86 80
 add.s a, (iy)                  ; 52 DD 86 00
 add.s a, (iy+0)                ; 52 DD 86 00
 add.s a, (iy+126)              ; 52 DD 86 7E
 add.s a, (iy-128)              ; 52 DD 86 80
 add.sil (hl)                   ; 52 86
 add.sil (hl+)                  ; 52 86 52 23
 add.sil (hl-)                  ; 52 86 52 2B
 add.sil (ix)                   ; 52 FD 86 00
 add.sil (ix+0)                 ; 52 FD 86 00
 add.sil (ix+126)               ; 52 FD 86 7E
 add.sil (ix-128)               ; 52 FD 86 80
 add.sil (iy)                   ; 52 DD 86 00
 add.sil (iy+0)                 ; 52 DD 86 00
 add.sil (iy+126)               ; 52 DD 86 7E
 add.sil (iy-128)               ; 52 DD 86 80
 add.sil a, (hl)                ; 52 86
 add.sil a, (hl+)               ; 52 86 52 23
 add.sil a, (hl-)               ; 52 86 52 2B
 add.sil a, (ix)                ; 52 FD 86 00
 add.sil a, (ix+0)              ; 52 FD 86 00
 add.sil a, (ix+126)            ; 52 FD 86 7E
 add.sil a, (ix-128)            ; 52 FD 86 80
 add.sil a, (iy)                ; 52 DD 86 00
 add.sil a, (iy+0)              ; 52 DD 86 00
 add.sil a, (iy+126)            ; 52 DD 86 7E
 add.sil a, (iy-128)            ; 52 DD 86 80
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
 and.s (hl)                     ; 52 A6
 and.s (hl+)                    ; 52 A6 52 23
 and.s (hl-)                    ; 52 A6 52 2B
 and.s (ix)                     ; 52 FD A6 00
 and.s (ix+0)                   ; 52 FD A6 00
 and.s (ix+126)                 ; 52 FD A6 7E
 and.s (ix-128)                 ; 52 FD A6 80
 and.s (iy)                     ; 52 DD A6 00
 and.s (iy+0)                   ; 52 DD A6 00
 and.s (iy+126)                 ; 52 DD A6 7E
 and.s (iy-128)                 ; 52 DD A6 80
 and.s a, (hl)                  ; 52 A6
 and.s a, (hl+)                 ; 52 A6 52 23
 and.s a, (hl-)                 ; 52 A6 52 2B
 and.s a, (ix)                  ; 52 FD A6 00
 and.s a, (ix+0)                ; 52 FD A6 00
 and.s a, (ix+126)              ; 52 FD A6 7E
 and.s a, (ix-128)              ; 52 FD A6 80
 and.s a, (iy)                  ; 52 DD A6 00
 and.s a, (iy+0)                ; 52 DD A6 00
 and.s a, (iy+126)              ; 52 DD A6 7E
 and.s a, (iy-128)              ; 52 DD A6 80
 and.sil (hl)                   ; 52 A6
 and.sil (hl+)                  ; 52 A6 52 23
 and.sil (hl-)                  ; 52 A6 52 2B
 and.sil (ix)                   ; 52 FD A6 00
 and.sil (ix+0)                 ; 52 FD A6 00
 and.sil (ix+126)               ; 52 FD A6 7E
 and.sil (ix-128)               ; 52 FD A6 80
 and.sil (iy)                   ; 52 DD A6 00
 and.sil (iy+0)                 ; 52 DD A6 00
 and.sil (iy+126)               ; 52 DD A6 7E
 and.sil (iy-128)               ; 52 DD A6 80
 and.sil a, (hl)                ; 52 A6
 and.sil a, (hl+)               ; 52 A6 52 23
 and.sil a, (hl-)               ; 52 A6 52 2B
 and.sil a, (ix)                ; 52 FD A6 00
 and.sil a, (ix+0)              ; 52 FD A6 00
 and.sil a, (ix+126)            ; 52 FD A6 7E
 and.sil a, (ix-128)            ; 52 FD A6 80
 and.sil a, (iy)                ; 52 DD A6 00
 and.sil a, (iy+0)              ; 52 DD A6 00
 and.sil a, (iy+126)            ; 52 DD A6 7E
 and.sil a, (iy-128)            ; 52 DD A6 80
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
 cmp.s (hl)                     ; 52 BE
 cmp.s (hl+)                    ; 52 BE 52 23
 cmp.s (hl-)                    ; 52 BE 52 2B
 cmp.s (ix)                     ; 52 FD BE 00
 cmp.s (ix+0)                   ; 52 FD BE 00
 cmp.s (ix+126)                 ; 52 FD BE 7E
 cmp.s (ix-128)                 ; 52 FD BE 80
 cmp.s (iy)                     ; 52 DD BE 00
 cmp.s (iy+0)                   ; 52 DD BE 00
 cmp.s (iy+126)                 ; 52 DD BE 7E
 cmp.s (iy-128)                 ; 52 DD BE 80
 cmp.s a, (hl)                  ; 52 BE
 cmp.s a, (hl+)                 ; 52 BE 52 23
 cmp.s a, (hl-)                 ; 52 BE 52 2B
 cmp.s a, (ix)                  ; 52 FD BE 00
 cmp.s a, (ix+0)                ; 52 FD BE 00
 cmp.s a, (ix+126)              ; 52 FD BE 7E
 cmp.s a, (ix-128)              ; 52 FD BE 80
 cmp.s a, (iy)                  ; 52 DD BE 00
 cmp.s a, (iy+0)                ; 52 DD BE 00
 cmp.s a, (iy+126)              ; 52 DD BE 7E
 cmp.s a, (iy-128)              ; 52 DD BE 80
 cmp.sil (hl)                   ; 52 BE
 cmp.sil (hl+)                  ; 52 BE 52 23
 cmp.sil (hl-)                  ; 52 BE 52 2B
 cmp.sil (ix)                   ; 52 FD BE 00
 cmp.sil (ix+0)                 ; 52 FD BE 00
 cmp.sil (ix+126)               ; 52 FD BE 7E
 cmp.sil (ix-128)               ; 52 FD BE 80
 cmp.sil (iy)                   ; 52 DD BE 00
 cmp.sil (iy+0)                 ; 52 DD BE 00
 cmp.sil (iy+126)               ; 52 DD BE 7E
 cmp.sil (iy-128)               ; 52 DD BE 80
 cmp.sil a, (hl)                ; 52 BE
 cmp.sil a, (hl+)               ; 52 BE 52 23
 cmp.sil a, (hl-)               ; 52 BE 52 2B
 cmp.sil a, (ix)                ; 52 FD BE 00
 cmp.sil a, (ix+0)              ; 52 FD BE 00
 cmp.sil a, (ix+126)            ; 52 FD BE 7E
 cmp.sil a, (ix-128)            ; 52 FD BE 80
 cmp.sil a, (iy)                ; 52 DD BE 00
 cmp.sil a, (iy+0)              ; 52 DD BE 00
 cmp.sil a, (iy+126)            ; 52 DD BE 7E
 cmp.sil a, (iy-128)            ; 52 DD BE 80
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
 cp.s (hl)                      ; 52 BE
 cp.s (hl+)                     ; 52 BE 52 23
 cp.s (hl-)                     ; 52 BE 52 2B
 cp.s (ix)                      ; 52 FD BE 00
 cp.s (ix+0)                    ; 52 FD BE 00
 cp.s (ix+126)                  ; 52 FD BE 7E
 cp.s (ix-128)                  ; 52 FD BE 80
 cp.s (iy)                      ; 52 DD BE 00
 cp.s (iy+0)                    ; 52 DD BE 00
 cp.s (iy+126)                  ; 52 DD BE 7E
 cp.s (iy-128)                  ; 52 DD BE 80
 cp.s a, (hl)                   ; 52 BE
 cp.s a, (hl+)                  ; 52 BE 52 23
 cp.s a, (hl-)                  ; 52 BE 52 2B
 cp.s a, (ix)                   ; 52 FD BE 00
 cp.s a, (ix+0)                 ; 52 FD BE 00
 cp.s a, (ix+126)               ; 52 FD BE 7E
 cp.s a, (ix-128)               ; 52 FD BE 80
 cp.s a, (iy)                   ; 52 DD BE 00
 cp.s a, (iy+0)                 ; 52 DD BE 00
 cp.s a, (iy+126)               ; 52 DD BE 7E
 cp.s a, (iy-128)               ; 52 DD BE 80
 cp.sil (hl)                    ; 52 BE
 cp.sil (hl+)                   ; 52 BE 52 23
 cp.sil (hl-)                   ; 52 BE 52 2B
 cp.sil (ix)                    ; 52 FD BE 00
 cp.sil (ix+0)                  ; 52 FD BE 00
 cp.sil (ix+126)                ; 52 FD BE 7E
 cp.sil (ix-128)                ; 52 FD BE 80
 cp.sil (iy)                    ; 52 DD BE 00
 cp.sil (iy+0)                  ; 52 DD BE 00
 cp.sil (iy+126)                ; 52 DD BE 7E
 cp.sil (iy-128)                ; 52 DD BE 80
 cp.sil a, (hl)                 ; 52 BE
 cp.sil a, (hl+)                ; 52 BE 52 23
 cp.sil a, (hl-)                ; 52 BE 52 2B
 cp.sil a, (ix)                 ; 52 FD BE 00
 cp.sil a, (ix+0)               ; 52 FD BE 00
 cp.sil a, (ix+126)             ; 52 FD BE 7E
 cp.sil a, (ix-128)             ; 52 FD BE 80
 cp.sil a, (iy)                 ; 52 DD BE 00
 cp.sil a, (iy+0)               ; 52 DD BE 00
 cp.sil a, (iy+126)             ; 52 DD BE 7E
 cp.sil a, (iy-128)             ; 52 DD BE 80
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
 dec.s bc                       ; 52 0B
 dec.s de                       ; 52 1B
 dec.s hl                       ; 52 2B
 dec.s sp                       ; 52 3B
 dec.sil bc                     ; 52 0B
 dec.sil de                     ; 52 1B
 dec.sil hl                     ; 52 2B
 dec.sil sp                     ; 52 3B
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex (sp), hl                    ; CD @__z80asm__ex_sp_hl
 inc bc                         ; 03
 inc de                         ; 13
 inc hl                         ; 23
 inc sp                         ; 33
 inc.s bc                       ; 52 03
 inc.s de                       ; 52 13
 inc.s hl                       ; 52 23
 inc.s sp                       ; 52 33
 inc.sil bc                     ; 52 03
 inc.sil de                     ; 52 13
 inc.sil hl                     ; 52 23
 inc.sil sp                     ; 52 33
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
 or.s (hl)                      ; 52 B6
 or.s (hl+)                     ; 52 B6 52 23
 or.s (hl-)                     ; 52 B6 52 2B
 or.s (ix)                      ; 52 FD B6 00
 or.s (ix+0)                    ; 52 FD B6 00
 or.s (ix+126)                  ; 52 FD B6 7E
 or.s (ix-128)                  ; 52 FD B6 80
 or.s (iy)                      ; 52 DD B6 00
 or.s (iy+0)                    ; 52 DD B6 00
 or.s (iy+126)                  ; 52 DD B6 7E
 or.s (iy-128)                  ; 52 DD B6 80
 or.s a, (hl)                   ; 52 B6
 or.s a, (hl+)                  ; 52 B6 52 23
 or.s a, (hl-)                  ; 52 B6 52 2B
 or.s a, (ix)                   ; 52 FD B6 00
 or.s a, (ix+0)                 ; 52 FD B6 00
 or.s a, (ix+126)               ; 52 FD B6 7E
 or.s a, (ix-128)               ; 52 FD B6 80
 or.s a, (iy)                   ; 52 DD B6 00
 or.s a, (iy+0)                 ; 52 DD B6 00
 or.s a, (iy+126)               ; 52 DD B6 7E
 or.s a, (iy-128)               ; 52 DD B6 80
 or.sil (hl)                    ; 52 B6
 or.sil (hl+)                   ; 52 B6 52 23
 or.sil (hl-)                   ; 52 B6 52 2B
 or.sil (ix)                    ; 52 FD B6 00
 or.sil (ix+0)                  ; 52 FD B6 00
 or.sil (ix+126)                ; 52 FD B6 7E
 or.sil (ix-128)                ; 52 FD B6 80
 or.sil (iy)                    ; 52 DD B6 00
 or.sil (iy+0)                  ; 52 DD B6 00
 or.sil (iy+126)                ; 52 DD B6 7E
 or.sil (iy-128)                ; 52 DD B6 80
 or.sil a, (hl)                 ; 52 B6
 or.sil a, (hl+)                ; 52 B6 52 23
 or.sil a, (hl-)                ; 52 B6 52 2B
 or.sil a, (ix)                 ; 52 FD B6 00
 or.sil a, (ix+0)               ; 52 FD B6 00
 or.sil a, (ix+126)             ; 52 FD B6 7E
 or.sil a, (ix-128)             ; 52 FD B6 80
 or.sil a, (iy)                 ; 52 DD B6 00
 or.sil a, (iy+0)               ; 52 DD B6 00
 or.sil a, (iy+126)             ; 52 DD B6 7E
 or.sil a, (iy-128)             ; 52 DD B6 80
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
 sbc.s (hl)                     ; 52 9E
 sbc.s (hl+)                    ; 52 9E 52 23
 sbc.s (hl-)                    ; 52 9E 52 2B
 sbc.s (ix)                     ; 52 FD 9E 00
 sbc.s (ix+0)                   ; 52 FD 9E 00
 sbc.s (ix+126)                 ; 52 FD 9E 7E
 sbc.s (ix-128)                 ; 52 FD 9E 80
 sbc.s (iy)                     ; 52 DD 9E 00
 sbc.s (iy+0)                   ; 52 DD 9E 00
 sbc.s (iy+126)                 ; 52 DD 9E 7E
 sbc.s (iy-128)                 ; 52 DD 9E 80
 sbc.s a, (hl)                  ; 52 9E
 sbc.s a, (hl+)                 ; 52 9E 52 23
 sbc.s a, (hl-)                 ; 52 9E 52 2B
 sbc.s a, (ix)                  ; 52 FD 9E 00
 sbc.s a, (ix+0)                ; 52 FD 9E 00
 sbc.s a, (ix+126)              ; 52 FD 9E 7E
 sbc.s a, (ix-128)              ; 52 FD 9E 80
 sbc.s a, (iy)                  ; 52 DD 9E 00
 sbc.s a, (iy+0)                ; 52 DD 9E 00
 sbc.s a, (iy+126)              ; 52 DD 9E 7E
 sbc.s a, (iy-128)              ; 52 DD 9E 80
 sbc.sil (hl)                   ; 52 9E
 sbc.sil (hl+)                  ; 52 9E 52 23
 sbc.sil (hl-)                  ; 52 9E 52 2B
 sbc.sil (ix)                   ; 52 FD 9E 00
 sbc.sil (ix+0)                 ; 52 FD 9E 00
 sbc.sil (ix+126)               ; 52 FD 9E 7E
 sbc.sil (ix-128)               ; 52 FD 9E 80
 sbc.sil (iy)                   ; 52 DD 9E 00
 sbc.sil (iy+0)                 ; 52 DD 9E 00
 sbc.sil (iy+126)               ; 52 DD 9E 7E
 sbc.sil (iy-128)               ; 52 DD 9E 80
 sbc.sil a, (hl)                ; 52 9E
 sbc.sil a, (hl+)               ; 52 9E 52 23
 sbc.sil a, (hl-)               ; 52 9E 52 2B
 sbc.sil a, (ix)                ; 52 FD 9E 00
 sbc.sil a, (ix+0)              ; 52 FD 9E 00
 sbc.sil a, (ix+126)            ; 52 FD 9E 7E
 sbc.sil a, (ix-128)            ; 52 FD 9E 80
 sbc.sil a, (iy)                ; 52 DD 9E 00
 sbc.sil a, (iy+0)              ; 52 DD 9E 00
 sbc.sil a, (iy+126)            ; 52 DD 9E 7E
 sbc.sil a, (iy-128)            ; 52 DD 9E 80
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
 sub.s (hl)                     ; 52 96
 sub.s (hl+)                    ; 52 96 52 23
 sub.s (hl-)                    ; 52 96 52 2B
 sub.s (ix)                     ; 52 FD 96 00
 sub.s (ix+0)                   ; 52 FD 96 00
 sub.s (ix+126)                 ; 52 FD 96 7E
 sub.s (ix-128)                 ; 52 FD 96 80
 sub.s (iy)                     ; 52 DD 96 00
 sub.s (iy+0)                   ; 52 DD 96 00
 sub.s (iy+126)                 ; 52 DD 96 7E
 sub.s (iy-128)                 ; 52 DD 96 80
 sub.s a, (hl)                  ; 52 96
 sub.s a, (hl+)                 ; 52 96 52 23
 sub.s a, (hl-)                 ; 52 96 52 2B
 sub.s a, (ix)                  ; 52 FD 96 00
 sub.s a, (ix+0)                ; 52 FD 96 00
 sub.s a, (ix+126)              ; 52 FD 96 7E
 sub.s a, (ix-128)              ; 52 FD 96 80
 sub.s a, (iy)                  ; 52 DD 96 00
 sub.s a, (iy+0)                ; 52 DD 96 00
 sub.s a, (iy+126)              ; 52 DD 96 7E
 sub.s a, (iy-128)              ; 52 DD 96 80
 sub.sil (hl)                   ; 52 96
 sub.sil (hl+)                  ; 52 96 52 23
 sub.sil (hl-)                  ; 52 96 52 2B
 sub.sil (ix)                   ; 52 FD 96 00
 sub.sil (ix+0)                 ; 52 FD 96 00
 sub.sil (ix+126)               ; 52 FD 96 7E
 sub.sil (ix-128)               ; 52 FD 96 80
 sub.sil (iy)                   ; 52 DD 96 00
 sub.sil (iy+0)                 ; 52 DD 96 00
 sub.sil (iy+126)               ; 52 DD 96 7E
 sub.sil (iy-128)               ; 52 DD 96 80
 sub.sil a, (hl)                ; 52 96
 sub.sil a, (hl+)               ; 52 96 52 23
 sub.sil a, (hl-)               ; 52 96 52 2B
 sub.sil a, (ix)                ; 52 FD 96 00
 sub.sil a, (ix+0)              ; 52 FD 96 00
 sub.sil a, (ix+126)            ; 52 FD 96 7E
 sub.sil a, (ix-128)            ; 52 FD 96 80
 sub.sil a, (iy)                ; 52 DD 96 00
 sub.sil a, (iy+0)              ; 52 DD 96 00
 sub.sil a, (iy+126)            ; 52 DD 96 7E
 sub.sil a, (iy-128)            ; 52 DD 96 80
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
 xor.s (hl)                     ; 52 AE
 xor.s (hl+)                    ; 52 AE 52 23
 xor.s (hl-)                    ; 52 AE 52 2B
 xor.s (ix)                     ; 52 FD AE 00
 xor.s (ix+0)                   ; 52 FD AE 00
 xor.s (ix+126)                 ; 52 FD AE 7E
 xor.s (ix-128)                 ; 52 FD AE 80
 xor.s (iy)                     ; 52 DD AE 00
 xor.s (iy+0)                   ; 52 DD AE 00
 xor.s (iy+126)                 ; 52 DD AE 7E
 xor.s (iy-128)                 ; 52 DD AE 80
 xor.s a, (hl)                  ; 52 AE
 xor.s a, (hl+)                 ; 52 AE 52 23
 xor.s a, (hl-)                 ; 52 AE 52 2B
 xor.s a, (ix)                  ; 52 FD AE 00
 xor.s a, (ix+0)                ; 52 FD AE 00
 xor.s a, (ix+126)              ; 52 FD AE 7E
 xor.s a, (ix-128)              ; 52 FD AE 80
 xor.s a, (iy)                  ; 52 DD AE 00
 xor.s a, (iy+0)                ; 52 DD AE 00
 xor.s a, (iy+126)              ; 52 DD AE 7E
 xor.s a, (iy-128)              ; 52 DD AE 80
 xor.sil (hl)                   ; 52 AE
 xor.sil (hl+)                  ; 52 AE 52 23
 xor.sil (hl-)                  ; 52 AE 52 2B
 xor.sil (ix)                   ; 52 FD AE 00
 xor.sil (ix+0)                 ; 52 FD AE 00
 xor.sil (ix+126)               ; 52 FD AE 7E
 xor.sil (ix-128)               ; 52 FD AE 80
 xor.sil (iy)                   ; 52 DD AE 00
 xor.sil (iy+0)                 ; 52 DD AE 00
 xor.sil (iy+126)               ; 52 DD AE 7E
 xor.sil (iy-128)               ; 52 DD AE 80
 xor.sil a, (hl)                ; 52 AE
 xor.sil a, (hl+)               ; 52 AE 52 23
 xor.sil a, (hl-)               ; 52 AE 52 2B
 xor.sil a, (ix)                ; 52 FD AE 00
 xor.sil a, (ix+0)              ; 52 FD AE 00
 xor.sil a, (ix+126)            ; 52 FD AE 7E
 xor.sil a, (ix-128)            ; 52 FD AE 80
 xor.sil a, (iy)                ; 52 DD AE 00
 xor.sil a, (iy+0)              ; 52 DD AE 00
 xor.sil a, (iy+126)            ; 52 DD AE 7E
 xor.sil a, (iy-128)            ; 52 DD AE 80
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
