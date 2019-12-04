 djnz %j                        ; Error
 djnz -32768                    ; Error
 djnz 32767                     ; Error
 djnz 65535                     ; Error
 djnz b, %j                     ; Error
 djnz b, -32768                 ; Error
 djnz b, 32767                  ; Error
 djnz b, 65535                  ; Error
 jr -32768                      ; Error
 jr 32767                       ; Error
 jr 65535                       ; Error
 jr c, -32768                   ; Error
 jr c, 32767                    ; Error
 jr c, 65535                    ; Error
 jr nc, -32768                  ; Error
 jr nc, 32767                   ; Error
 jr nc, 65535                   ; Error
 jr nz, -32768                  ; Error
 jr nz, 32767                   ; Error
 jr nz, 65535                   ; Error
 jr z, -32768                   ; Error
 jr z, 32767                    ; Error
 jr z, 65535                    ; Error
 ld (de), hl                    ; Error
 ld (hl+), a                    ; Error
 ld (hl-), a                    ; Error
 ld (hld), a                    ; Error
 ld (hli), a                    ; Error
 ld a, (hl+)                    ; Error
 ld a, (hl-)                    ; Error
 ld a, (hld)                    ; Error
 ld a, (hli)                    ; Error
 ld hl, (de)                    ; Error
 ldd (hl), a                    ; Error
 ldd a, (hl)                    ; Error
 ldi (hl), a                    ; Error
 ldi a, (hl)                    ; Error
 lhlde                          ; Error
 lhlx                           ; Error
 shlde                          ; Error
 shlx                           ; Error
 swap (hl)                      ; Error
 swap a                         ; Error
 swap b                         ; Error
 swap c                         ; Error
 swap d                         ; Error
 swap e                         ; Error
 swap h                         ; Error
 swap l                         ; Error
