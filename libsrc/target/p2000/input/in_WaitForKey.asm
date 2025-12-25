SECTION code_clib

PUBLIC in_WaitForKey

; -----------------------------------------------------------------------------
; void in_WaitForKey(void)
;
; Halts execution until any key on the keyboard is pressed.
;
; Implementation (Fast and Safe Hybrid Scan):
;   - Loops continuously until a key press is detected.
;   - In each loop, it safely reads the keyboard's global state.
;   - It disables interrupts (DI) briefly to prevent race conditions
;     with the Monitor ROM's own ~50Hz interrupt handler.
;   - It enables KBIEN (Global Scan) mode, allowing port $00 to be read
;     to check the state of all keys at once. A result of 0xFF means no
;     keys are pressed.
;   - Interrupts are immediately re-enabled (EI) after the single 'IN'
;     instruction to minimize impact on system timing.
; -----------------------------------------------------------------------------
in_WaitForKey:
_wfk_l:
    di                      ; Disable interrupts for safe hardware access
    ld a, $40
    out ($10), a            ; Enable KBIEN for global scan mode
    in a, ($00)             ; Read all rows at once
    ei                      ; Immediately re-enable interrupts

    inc a                   ; Check if any key was pressed (result != 0xFF)
    jr z, _wfk_l            ; Loop if no key was pressed
    ret
