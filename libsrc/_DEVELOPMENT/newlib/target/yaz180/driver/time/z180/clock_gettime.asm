;
; (c)2019 Phillip Stevens All rights reserved.
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
    
    PUBLIC	asm_clock_gettime
    
    EXTERN  __system_time_fraction, __system_time

    ; HL contains address of struct timespec
    ;   struct  timespec { time_t      tv_sec;     /* seconds */
    ;                   nseconds_t  tv_nsec;}   /* and nanoseconds */

.asm_clock_gettime
    ex de,hl                        ; get the address of the timespec in DE
    ld hl,__system_time

    ld a,i
    push af                         ; preserve interrupt status
    di

    ldi                             ; timespec.tv_sec = (__system_time)
    ldi
    ldi
    ldi
    ld hl,__system_time_fraction
    ld b,(hl)                       ; (__system_time_fraction)

    pop af                          ; restore interrupts
    jp PO,noints                    ; jr PO,noints -> no interrupts if di 
    ei

.noints
    push de                         ; preserve timespec.tv_nsec

    ld e,$ca                        ; scale result into ns
    ld d,b
    mlt de                          ; 00DE
    ld l,$9a
    ld h,b
    mlt hl                          ; 0HL0
    ld c,$3b
    mlt bc                          ; BC00

    ld a,d                          ; add partials
    add a,l
    ld d,a

    ld a,h
    adc a,c
    ld c,a
    
    jr NC,nocarry
    inc b                           ; result in BCDE

.nocarry
    pop hl                          ; recover timespec.tv_nsec
    ld (hl),e                       ; place scaled (__system_time_fraction)
    inc hl
    ld (hl),d
    inc hl
    ld (hl),c
    inc hl
    ld (hl),b
    ld hl,0                         ; return null
    ret

