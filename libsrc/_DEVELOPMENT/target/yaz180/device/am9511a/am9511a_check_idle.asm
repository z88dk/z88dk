;------------------------------------------------------------------------------
;       Confirms whether the APU is idle
;       Loop until it returns ready
;       Operand Entry and Removal takes little time,
;       and we'll be interrupted for Command entry.
;       Use after the first APU_ISR call.
;
;       A = contents of (APUStatus || APUError)
;       SCF if no errors (aggregation of any errors found)
;
;       APUError is zeroed on return

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _am9511a_chk_idle

    EXTERN APUStatus, APUError

    _am9511a_chk_idle:
        push hl

    am9511a_check_loop:
        ld a, (APUStatus)       ; get the status of the APU (but don't disturb APU)
        tst __IO_APU_STATUS_BUSY    ; check busy bit is set,
        jr nz, am9511a_check_loop   ; so we wait

        ld hl, APUError
        or (hl)                 ; collect the aggregated errors, with APUStatus
        tst __IO_APU_STATUS_ERROR   ; any errors?
        ld (hl), 0              ; clear any aggregated errors in APUError
        pop hl
        ret nz                  ; return with no carry if errors
        scf                     ; set carry flag
        ret                     ; return with (APUStatus || APUError) with carry set if no errors

