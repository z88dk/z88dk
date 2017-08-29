;------------------------------------------------------------------------------
;       Confirms whether the APU is idle
;       Loop until it returns ready
;       Operand Entry and Removal takes little time,
;       and we'll be interrupted for Command entry.
;       Use after the first APU_ISR call.
;
;       A = contents of APUError (aggregation of any errors found)
;       SCF if no errors

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _am9511a_chk_idle

    EXTERN APUStatus, APUError

    _am9511a_chk_idle:
        push bc

    am9511a_check_loop:
        ld a, (APUStatus)       ; get the status of the APU
        or a                    ; check it is zero (NOP) command
        jr nz, am9511a_check_loop   ; otherwise wait

        ld bc, __IO_APU_PORT_STATUS ; the address of the APU status port in bc
        in a, (c)               ; read the APU status port
        and __IO_APU_STATUS_BUSY    ; busy bit set?
        jr nz, am9511a_check_loop   ; yes, then wait

        pop bc        

        ld a, (APUError)        ; get the aggregated errors collected
        or a
        ret nz                  ; return with no carrry if errors
        scf                     ; set carry flag
        ret                     ; return with APUError in a, carry set if no errors
