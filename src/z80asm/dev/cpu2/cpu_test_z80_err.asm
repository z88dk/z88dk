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
