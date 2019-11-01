 add sp, +127                   ; Error
 add sp, -128                   ; Error
 bit 0, (hl)                    ; Error
 bit 0, a                       ; Error
 bit 0, b                       ; Error
 bit 0, c                       ; Error
 bit 0, d                       ; Error
 bit 0, e                       ; Error
 bit 0, h                       ; Error
 bit 0, l                       ; Error
 bit 1, (hl)                    ; Error
 bit 1, a                       ; Error
 bit 1, b                       ; Error
 bit 1, c                       ; Error
 bit 1, d                       ; Error
 bit 1, e                       ; Error
 bit 1, h                       ; Error
 bit 1, l                       ; Error
 bit 2, (hl)                    ; Error
 bit 2, a                       ; Error
 bit 2, b                       ; Error
 bit 2, c                       ; Error
 bit 2, d                       ; Error
 bit 2, e                       ; Error
 bit 2, h                       ; Error
 bit 2, l                       ; Error
 bit 3, (hl)                    ; Error
 bit 3, a                       ; Error
 bit 3, b                       ; Error
 bit 3, c                       ; Error
 bit 3, d                       ; Error
 bit 3, e                       ; Error
 bit 3, h                       ; Error
 bit 3, l                       ; Error
 bit 4, (hl)                    ; Error
 bit 4, a                       ; Error
 bit 4, b                       ; Error
 bit 4, c                       ; Error
 bit 4, d                       ; Error
 bit 4, e                       ; Error
 bit 4, h                       ; Error
 bit 4, l                       ; Error
 bit 5, (hl)                    ; Error
 bit 5, a                       ; Error
 bit 5, b                       ; Error
 bit 5, c                       ; Error
 bit 5, d                       ; Error
 bit 5, e                       ; Error
 bit 5, h                       ; Error
 bit 5, l                       ; Error
 bit 6, (hl)                    ; Error
 bit 6, a                       ; Error
 bit 6, b                       ; Error
 bit 6, c                       ; Error
 bit 6, d                       ; Error
 bit 6, e                       ; Error
 bit 6, h                       ; Error
 bit 6, l                       ; Error
 bit 7, (hl)                    ; Error
 bit 7, a                       ; Error
 bit 7, b                       ; Error
 bit 7, c                       ; Error
 bit 7, d                       ; Error
 bit 7, e                       ; Error
 bit 7, h                       ; Error
 bit 7, l                       ; Error
 cp (hl)                        ; Error
 cp -128                        ; Error
 cp 127                         ; Error
 cp 255                         ; Error
 cp a                           ; Error
 cp a, (hl)                     ; Error
 cp a, -128                     ; Error
 cp a, 127                      ; Error
 cp a, 255                      ; Error
 cp a, a                        ; Error
 cp a, b                        ; Error
 cp a, c                        ; Error
 cp a, d                        ; Error
 cp a, e                        ; Error
 cp a, h                        ; Error
 cp a, l                        ; Error
 cp b                           ; Error
 cp c                           ; Error
 cp d                           ; Error
 cp e                           ; Error
 cp h                           ; Error
 cp l                           ; Error
 jp c, -32768                   ; Error
 jp c, 32767                    ; Error
 jp c, 65535                    ; Error
 jp nc, -32768                  ; Error
 jp nc, 32767                   ; Error
 jp nc, 65535                   ; Error
 jp nz, -32768                  ; Error
 jp nz, 32767                   ; Error
 jp nz, 65535                   ; Error
 jp z, -32768                   ; Error
 jp z, 32767                    ; Error
 jp z, 65535                    ; Error
 jr %j                          ; Error
 jr c, %j                       ; Error
 jr nc, %j                      ; Error
 jr nz, %j                      ; Error
 jr z, %j                       ; Error
 ld (-32768), sp                ; Error
 ld (32767), sp                 ; Error
 ld (65535), sp                 ; Error
 ld (c), a                      ; Error
 ld (hl+), a                    ; Error
 ld (hl-), a                    ; Error
 ld (hld), a                    ; Error
 ld (hli), a                    ; Error
 ld a, (c)                      ; Error
 ld a, (hl+)                    ; Error
 ld a, (hl-)                    ; Error
 ld a, (hld)                    ; Error
 ld a, (hli)                    ; Error
 ld hl, sp++127                 ; Error
 ld hl, sp+-128                 ; Error
 ldd (hl), a                    ; Error
 ldd a, (hl)                    ; Error
 ldh (-128), a                  ; Error
 ldh (127), a                   ; Error
 ldh (255), a                   ; Error
 ldh (c), a                     ; Error
 ldh a, (-128)                  ; Error
 ldh a, (127)                   ; Error
 ldh a, (255)                   ; Error
 ldh a, (c)                     ; Error
 ldhl sp, +127                  ; Error
 ldhl sp, -128                  ; Error
 ldi (hl), a                    ; Error
 ldi a, (hl)                    ; Error
 res 0, (hl)                    ; Error
 res 0, a                       ; Error
 res 0, b                       ; Error
 res 0, c                       ; Error
 res 0, d                       ; Error
 res 0, e                       ; Error
 res 0, h                       ; Error
 res 0, l                       ; Error
 res 1, (hl)                    ; Error
 res 1, a                       ; Error
 res 1, b                       ; Error
 res 1, c                       ; Error
 res 1, d                       ; Error
 res 1, e                       ; Error
 res 1, h                       ; Error
 res 1, l                       ; Error
 res 2, (hl)                    ; Error
 res 2, a                       ; Error
 res 2, b                       ; Error
 res 2, c                       ; Error
 res 2, d                       ; Error
 res 2, e                       ; Error
 res 2, h                       ; Error
 res 2, l                       ; Error
 res 3, (hl)                    ; Error
 res 3, a                       ; Error
 res 3, b                       ; Error
 res 3, c                       ; Error
 res 3, d                       ; Error
 res 3, e                       ; Error
 res 3, h                       ; Error
 res 3, l                       ; Error
 res 4, (hl)                    ; Error
 res 4, a                       ; Error
 res 4, b                       ; Error
 res 4, c                       ; Error
 res 4, d                       ; Error
 res 4, e                       ; Error
 res 4, h                       ; Error
 res 4, l                       ; Error
 res 5, (hl)                    ; Error
 res 5, a                       ; Error
 res 5, b                       ; Error
 res 5, c                       ; Error
 res 5, d                       ; Error
 res 5, e                       ; Error
 res 5, h                       ; Error
 res 5, l                       ; Error
 res 6, (hl)                    ; Error
 res 6, a                       ; Error
 res 6, b                       ; Error
 res 6, c                       ; Error
 res 6, d                       ; Error
 res 6, e                       ; Error
 res 6, h                       ; Error
 res 6, l                       ; Error
 res 7, (hl)                    ; Error
 res 7, a                       ; Error
 res 7, b                       ; Error
 res 7, c                       ; Error
 res 7, d                       ; Error
 res 7, e                       ; Error
 res 7, h                       ; Error
 res 7, l                       ; Error
 reti                           ; Error
 rl (hl)                        ; Error
 rl a                           ; Error
 rl b                           ; Error
 rl c                           ; Error
 rl d                           ; Error
 rl e                           ; Error
 rl h                           ; Error
 rl l                           ; Error
 rlc (hl)                       ; Error
 rlc a                          ; Error
 rlc b                          ; Error
 rlc c                          ; Error
 rlc d                          ; Error
 rlc e                          ; Error
 rlc h                          ; Error
 rlc l                          ; Error
 rr (hl)                        ; Error
 rr a                           ; Error
 rr b                           ; Error
 rr c                           ; Error
 rr d                           ; Error
 rr e                           ; Error
 rr h                           ; Error
 rr l                           ; Error
 rrc (hl)                       ; Error
 rrc a                          ; Error
 rrc b                          ; Error
 rrc c                          ; Error
 rrc d                          ; Error
 rrc e                          ; Error
 rrc h                          ; Error
 rrc l                          ; Error
 set 0, (hl)                    ; Error
 set 0, a                       ; Error
 set 0, b                       ; Error
 set 0, c                       ; Error
 set 0, d                       ; Error
 set 0, e                       ; Error
 set 0, h                       ; Error
 set 0, l                       ; Error
 set 1, (hl)                    ; Error
 set 1, a                       ; Error
 set 1, b                       ; Error
 set 1, c                       ; Error
 set 1, d                       ; Error
 set 1, e                       ; Error
 set 1, h                       ; Error
 set 1, l                       ; Error
 set 2, (hl)                    ; Error
 set 2, a                       ; Error
 set 2, b                       ; Error
 set 2, c                       ; Error
 set 2, d                       ; Error
 set 2, e                       ; Error
 set 2, h                       ; Error
 set 2, l                       ; Error
 set 3, (hl)                    ; Error
 set 3, a                       ; Error
 set 3, b                       ; Error
 set 3, c                       ; Error
 set 3, d                       ; Error
 set 3, e                       ; Error
 set 3, h                       ; Error
 set 3, l                       ; Error
 set 4, (hl)                    ; Error
 set 4, a                       ; Error
 set 4, b                       ; Error
 set 4, c                       ; Error
 set 4, d                       ; Error
 set 4, e                       ; Error
 set 4, h                       ; Error
 set 4, l                       ; Error
 set 5, (hl)                    ; Error
 set 5, a                       ; Error
 set 5, b                       ; Error
 set 5, c                       ; Error
 set 5, d                       ; Error
 set 5, e                       ; Error
 set 5, h                       ; Error
 set 5, l                       ; Error
 set 6, (hl)                    ; Error
 set 6, a                       ; Error
 set 6, b                       ; Error
 set 6, c                       ; Error
 set 6, d                       ; Error
 set 6, e                       ; Error
 set 6, h                       ; Error
 set 6, l                       ; Error
 set 7, (hl)                    ; Error
 set 7, a                       ; Error
 set 7, b                       ; Error
 set 7, c                       ; Error
 set 7, d                       ; Error
 set 7, e                       ; Error
 set 7, h                       ; Error
 set 7, l                       ; Error
 sla (hl)                       ; Error
 sla a                          ; Error
 sla b                          ; Error
 sla c                          ; Error
 sla d                          ; Error
 sla e                          ; Error
 sla h                          ; Error
 sla l                          ; Error
 sra (hl)                       ; Error
 sra a                          ; Error
 sra b                          ; Error
 sra c                          ; Error
 sra d                          ; Error
 sra e                          ; Error
 sra h                          ; Error
 sra l                          ; Error
 srl (hl)                       ; Error
 srl a                          ; Error
 srl b                          ; Error
 srl c                          ; Error
 srl d                          ; Error
 srl e                          ; Error
 srl h                          ; Error
 srl l                          ; Error
 stop                           ; Error
 swap (hl)                      ; Error
 swap a                         ; Error
 swap b                         ; Error
 swap c                         ; Error
 swap d                         ; Error
 swap e                         ; Error
 swap h                         ; Error
 swap l                         ; Error
