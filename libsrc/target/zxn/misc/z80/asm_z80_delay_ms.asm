
; ===============================================================
; void z80_delay_ms(uint ms)
;
; +zxn replacement for the generic busy wait. The generic routine
; burns __CPU_CLOCK/1000 states per millisecond, and +zxn assembles
; that clock as 3.5 MHz. Register 7 bits 5-4 are the speed the CPU
; is actually running:
;   00 = 3.5 MHz, 01 = 7 MHz, 10 = 14 MHz, 11 = 28 MHz.
; Bits 1-0 are the programmed speed. Bits 7, 6, 3 and 2 are reserved.
; A reserved bit means this read is not a core 3 speed value, and the
; wait uses 3.5 MHz. Actual speed 00 also uses 3.5 MHz, including a
; core 3 machine held at 3.5 MHz by the expansion bus.
;
; The specnext.com TBBlue port page (core 2.00.27 text) only defines
; bits 1-0, and it stops at 14 MHz. The current description is
; https://wiki.specnext.dev/CPU_Speed_Register
;
; Core 3.0.5 adds a wait on each opcode fetch at 28 MHz, so that
; setting runs long. asm_z80_delay_tstate is unchanged.
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_delay_ms
PUBLIC asm_cpu_delay_ms

EXTERN asm_z80_delay_tstate

asm_z80_delay_ms:
asm_cpu_delay_ms:

   ; enter : hl = milliseconds (0 = 65536)
   ;
   ; uses  : af, bc, de, hl

   ld e,l
   ld d,h

   ; Port 0x243B selects the register. Port 0x253B reads it.
   ld bc,$243b
   ld a,$07
   out (c),a
   inc b
   in a,(c)

   ld c,a
   and $cc
   jr nz, ms_35
   ld a,c
   and $30
   jr z, ms_35
   cp $10
   jr z, ms_7
   cp $20
   jr z, ms_14

   ; 28 MHz. 28000 states is one millisecond at that clock.
ms_28:

   dec de
   ld a,d
   or e
   jr z, last_28

   ld hl,28000 - 43
   call asm_z80_delay_tstate

   jr ms_28

last_28:

   ld hl,28000 - 54
   jp asm_z80_delay_tstate

ms_14:

   dec de
   ld a,d
   or e
   jr z, last_14

   ld hl,14000 - 43
   call asm_z80_delay_tstate

   jr ms_14

last_14:

   ld hl,14000 - 54
   jp asm_z80_delay_tstate

ms_7:

   dec de
   ld a,d
   or e
   jr z, last_7

   ld hl,7000 - 43
   call asm_z80_delay_tstate

   jr ms_7

last_7:

   ld hl,7000 - 54
   jp asm_z80_delay_tstate

   ; 3.5 MHz, and any read that is not a core 3 speed value.
ms_35:

   dec de
   ld a,d
   or e
   jr z, last_35

   ld hl,3500 - 43
   call asm_z80_delay_tstate

   jr ms_35

last_35:

   ld hl,3500 - 54
   jp asm_z80_delay_tstate
