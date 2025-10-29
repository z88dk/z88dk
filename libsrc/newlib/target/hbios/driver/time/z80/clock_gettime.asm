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

    EXTERN  asm_hbios

    ; HL contains address of struct timespec
    ;   struct  timespec { time_t      tv_sec;     /* seconds */
    ;                   nseconds_t  tv_nsec;}   /* and nanoseconds */
    ;
    ; ROMWBW always has 50 ticks per second

.asm_clock_gettime
    push hl

    ld bc,__BF_SYSGET<<8|__BF_SYSGET_SECS
    call asm_hbios                  ; current seconds count value in DE:HL, 

    ld a,c                          ; ticks in A
    ld c,l                          ; current seconds count value in DE:BC, 
    ld b,h

    pop hl                          ; &timespec

    ld (hl),c
    inc hl
    ld (hl),b
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    push hl                         ; preserve timespec.tv_nsec

    ld e,$2d                        ; scale result by ns $01 13 2d 00
    ld d,a

IF __CPU_Z180__

    mlt de

ELSE

IF __CPU_Z80N__

    mul de

ELSE

    EXTERN l_mulu_de

    call l_mulu_de

ENDIF
ENDIF

    ld l,$31                        ; $31
    ld h,a

IF __CPU_Z180__

    mlt hl

ELSE

IF __CPU_Z80N__

    ex de,hl
    mul de
    ex de,hl

ELSE

    ex de,hl
    call l_mulu_de
    ex de,hl

ENDIF
ENDIF

    ld b,a                          ; $01

    ld a,d                          ; add partials
    add a,l
    ld d,a

    ld a,h
    adc a,b

    ld b,a
    ld c,d
    ld d,e
    ld e,0                          ; result in BCDE

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

