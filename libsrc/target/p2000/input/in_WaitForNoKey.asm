SECTION code_clib

PUBLIC in_WaitForNoKey

; -----------------------------------------------------------------------------
; void in_WaitForNoKey(void)
;
; Halts execution until no keys on the keyboard are pressed.
;
; Implementation (Fast and Safe Hybrid Scan):
;   The logic is the inverse of in_WaitForKey. It loops as long as a
;   key press is detected, using the same safe global scan method
;   (DI/EI wrapped) to poll the hardware.
; -----------------------------------------------------------------------------
in_WaitForNoKey:
_wfnk_l:
    di                      ; Disable interrupts
    ld a, $40
    out ($10), a            ; Enable KBIEN for global scan
    in a, ($00)             ; Read all rows
    ei                      ; Re-enable interrupts

    inc a                   ; Check if any key was pressed (result != 0xFF)
    jr nz, _wfnk_l          ; Loop if a key IS pressed
    ret
