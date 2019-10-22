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
    
    PUBLIC	asm_clock_getres

    ; HL contains address of struct timespec
    ;   struct  timespec { time_t      tv_sec;     /* seconds */
    ;                   nseconds_t  tv_nsec;}   /* and nanoseconds */

.asm_clock_getres
    xor a                           ; yaz180 has 256 ticks per second
    ld (hl),a                       ; tv_sec 0x 00 00 00 00
    inc hl
    ld (hl),a
    inc hl
    ld (hl),a
    inc hl
    ld (hl),a
    inc hl
    ld (hl),$ca                     ; tv_nsec 0x 00 3B 9A CA
    inc hl
    ld (hl),$9a
    inc hl
    ld (hl),$3b
    inc hl
    ld (hl),a
    ld hl,0                         ; return null
    ret


