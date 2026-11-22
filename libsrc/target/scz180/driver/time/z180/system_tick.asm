;
; (c)2017 Phillip Stevens All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are
; met:
;
; Redistributions of source code must retain the above copyright notice, this
; list of conditions and the following disclaimer. Redistributions in binary
; form must reproduce the above copyright notice, this list of conditions
; and the following disclaimer in the documentation and/or other materials
; provided with the distribution. Neither the name of the copyright holders
; nor the names of contributors may be used to endorse or promote products
; derived from this software without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.

    INCLUDE "config_private.inc"

    SECTION code_driver
    
    PUBLIC	asm_system_tick
    
    EXTERN  __system_time_fraction, __system_time

    asm_system_tick:
        push af
        push hl

        in0 a, (TCR)                ; to clear the PRT0 interrupt, read the TCR
        in0 a, (TMDR0L)             ; followed by the TMDR0

        ld hl, __system_time_fraction
        inc (hl)
        jr Z, system_tick_update    ; at 0 we're at 1 second count, interrupted 256 times

    system_tick_exit:
        pop hl
        pop af
        ei                          ; interrupts were enabled, or we wouldn't have been here
        ret

    system_tick_update:
;       push bc
;       ld bc, __IO_PIO_PORT_B      ; see the low byte of __system_time
;       ld hl, __system_time
;       ld l, (hl)
;       out (c), l
;       pop bc

        ld hl, __system_time        ; increment through the __system_time bytes
        inc (hl)
        jr NZ, system_tick_exit
        inc hl
        inc (hl)
        jr NZ, system_tick_exit
        inc hl
        inc (hl)
        jr NZ, system_tick_exit
        inc hl
        inc (hl)
        jr system_tick_exit

