SECTION code_clib

PUBLIC in_Pause
EXTERN in_WaitForKey, in_WaitForNoKey
; =============================================================================
; FUNCTION: in_Pause
; =============================================================================
; C Prototype:
;   uint in_Pause(uint msec) __z88dk_fastcall;
;
; Description:
;   Pauses execution for 'msec' milliseconds, interruptible by ANY key press.
;
;   - Mode 0 (HL > 0):  Standard timeout.
;   - Mode 1 (HL = 0):  Waits indefinitely ("Press Any Key").
;
; Input:
;   HL = Duration (ms). 0 = Infinite.
;
; Output:
;   HL = Remaining time (0 if timeout completed).
;   Carry Flag: Set (1) if interrupted by key, Clear (0) if timeout.
;
; Hardware Note (Global Scan Mode):
;   Writing $40 to Port $10 enables "Global Scan Mode".
;   In this mode, reading Port $00 returns $FF if NO keys are pressed,
;   or a different value if ANY key is pressed.
;
; Calibration (2.5 MHz):
;   Target: 2500 T-States per millisecond.
;   - Global Scan Overhead: ~55 T-States (DI/OUT/IN/EI/Check)
;   - Loop Overhead:        ~31 T-States
;   - Remaining Budget:     2414 T-States
;   - Inner Loop (26T):     2414 / 26 ~= 93 loops.
; =============================================================================

in_Pause:
    ; --- Entry Check (Not counted in the 1ms loop) ---
    ld   a, h               ; [4 T]
    or   l                  ; [4 T]
    jr   z, _p_forever      ; [7 T] (Assume Not Taken)

_p_loop:
    ; =========================================================================
    ; START OF 1ms BLOCK
    ; =========================================================================
    push hl                 ; [11 T] Save msec counter

    ; --- Inner Delay Loop ---
    ld   bc, 93             ; [10 T] CALIBRATION CONSTANT
                            ; Logic: 93 * 26 = 2418 T-States
_p_inner:
    dec  bc                 ; [6 T]
    ld   a, b               ; [4 T]
    or   c                  ; [4 T]
    jr   nz, _p_inner       ; [12/7 T] 12 if Loop continues, 7 on exit.
                            ; Total per iteration: 26 T-States.
                            ; Total for 93 loops: (92 * 26) + (1 * 21) = 2413 T

    pop  hl                 ; [10 T] Restore msec counter

    ; --- Hardware Global Scan ---
    di                      ; [4 T]
    ld   a, $40             ; [7 T]
    out  ($10), a           ; [11 T] Enable Global Scan
    in   a, ($00)           ; [11 T] Read Status
    ei                      ; [4 T]

    inc  a                  ; [4 T]  Check for $FF
    jr   nz, _p_exit        ; [7 T]  Not Taken (No Key Pressed)

    ; --- Outer Loop Management ---
    dec  hl                 ; [6 T]
    ld   a, h               ; [4 T]
    or   l                  ; [4 T]
    jr   nz, _p_loop        ; [12 T] Jump back to start

    ; =========================================================================
    ; TOTAL CALCULATION (One 1ms Pass):
    ;
    ; Fixed Overhead:
    ;   PUSH (11) + POP (10) + DI (4) + LD (7) + OUT (11) + IN (11) + EI (4)
    ;   + INC (4) + JR_False (7) + DEC (6) + LD (4) + OR (4) + JR_True (12)
    ;   = 95 T-States Overhead
    ;
    ; Inner Loop Cost (Count 93):
    ;   92 iterations * 26 T = 2392
    ;   1  iteration  * 21 T = 21 (Exit path is faster by 5T)
    ;   Total Inner = 2413 T-States
    ;
    ; GRAND TOTAL:
    ;   95 (Overhead) + 2413 (Loop) = 2508 T-States
    ;
    ; Result:
    ;   2508 * 0.4us = 1003.2 microseconds (~1.003 ms)
    ; =========================================================================

    or   a                  ; [4 T] Clear Carry
    ret                     ; [10 T]

_p_exit:
    scf                     ; [4 T]
    ret                     ; [10 T]

_p_forever:
    call in_WaitForNoKey
    call in_WaitForKey
    ld   hl, 0
    scf
    ret