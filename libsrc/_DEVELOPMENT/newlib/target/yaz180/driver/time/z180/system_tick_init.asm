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
;
;    HL = address of the z180 prt0 address
    
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC	asm_system_tick_init

    EXTERN  asm_system_tick

    asm_system_tick_init:       ; set up system tick timer
        push af
        push de

        xor a
        out0 (TCR), a           ; disable down counting and interrupts for PRT0/PRT1

                                ; remember the interrupt location for PRT0 is in hl
        ld de, asm_system_tick  ; load our interrupt service routine origin
                                ; initially there is a RET there
        ld (hl), e              ; load the address of the PRT0 service routine
        inc hl
        ld (hl), d

        ld hl, __CPU_CLOCK/__CPU_TIMER_SCALE/__CLOCKS_PER_SECOND-1  ; we do 256 ticks per second
        out0 (RLDR0L), l
        out0 (RLDR0H), h

        ld a, TCR_TIE0|TCR_TDE0 ; enable down counting and interrupts for PRT0
        out0 (TCR), a

        pop de
        pop af
        ret

