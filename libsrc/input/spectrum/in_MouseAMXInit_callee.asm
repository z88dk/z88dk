; void __CALLEE__ in_MouseAMXInit_callee(uchar xvector, uchar yvector)
; 09.2005 aralbrec

; References:
;   1. http://www.breezer.demon.co.uk/spec/tech/hware.html
;      Has an excerpt of the Z80 Emulator's documentation on the AMX Mouse.
;      Information is incorrect about mouse buttons.  Used the Spectaculator
;      emulator as reference for button behaviour.
;   2. "Z80 Data Book," Mostek Microcomputer Corporation, August 1978.
;      Technical documentation of the Z80 PIO Chip.

; The AMX mouse is interfaced to the Spectrum using a Z80 PIO chip
; configured in input mode.  Port A of the chip is associated
; with X movement and port B is associated with Y movement.  The
; mouse interface will generate an interrupt on port A or port B
; each time it is moved a distance of "one mickey" in the X or
; Y direction respectively.  It is the program's job to field
; these interrupts and update internal state representing the
; mouse's absolute position.  Once an interrupt has occurred,
; reading the data port (A or B) will return 0 (positive) or
; 1 (negative) to indicate movement direction.

; Port Addresses:
;
;   (Mapped to PIO chip)
;   $1f    Data Port A
;   $3f    Data Port B
;   $5f    Control Port A
;   $7f    Control Port B
;
;   (Separate from PIO chip)
;   $df    State of three mouse buttons: bit 7 = left, bit 6 = right,
;          bit 5 = middle, all active low.  The mouse buttons are not
;          debounced and/or are open collector.  The former adds random transitions
;          around a mouse press / depress and the latter adds random transitions
;          when the mouse is left unpressed, caused by ULA attribute bytes on
;          a floating bus.  You must take this into consideration when getting
;          a reliable read of the mouse buttons' state.
;
; Note that the AMX Mouse interface conflicts with the Kempston
; joystick interface ($1f), the Disciple disk interface ($1f) and
; the Multiface ($3f).

SECTION code_clib
PUBLIC in_MouseAMXInit_callee
PUBLIC _in_MouseAMXInit_callee
PUBLIC ASMDISP_IN_MOUSEAMXINIT_CALLEE

EXTERN im2_InstallISR_callee
EXTERN ASMDISP_IM2_INSTALLISR_CALLEE

EXTERN _in_AMXdeltaX, _in_AMXdeltaY
EXTERN _in_AMXcoordX, _in_AMXcoordY

.in_MouseAMXInit_callee
._in_MouseAMXInit_callee

   pop hl
   pop bc
   ex (sp),hl
   ld b,l

.asmentry

; enter: B = im 2 vector for X interrupts (even, 0..254)
;        C = im 2 vector for Y interrupts (even, 0..254)
; uses : AF,DE,HL
; exit : installs interrupt service routines to field AMX ints,
;        initializes mouse position to (0,0) and sets default
;        mouse deltas to one pixel.
; note : 1) disable interrupts prior to calling
;        2) uses im2.lib to register interrupt service routines

   ld l,b
   ld de,XInterrupt
   call im2_InstallISR_callee + ASMDISP_IM2_INSTALLISR_CALLEE

   ld l,c
   ld de,YInterrupt
   call im2_InstallISR_callee + ASMDISP_IM2_INSTALLISR_CALLEE

   ld a,b
   out ($5f),a                ; PIO vector for X
   ld a,$97
   out ($5f),a                ; PIO enable interrupt generation for X
   ld a,$4f
   out ($5f),a                ; PIO select input mode for X

   ld a,c
   out ($7f),a                ; PIO vector for Y
   ld a,$97
   out ($7f),a                ; PIO enable interrupt generation for Y
   ld a,$4f
   out ($7f),a                ; PIO select input mode for Y

   ld hl,$0100
   ld (_in_AMXdeltaX),hl
   ld (_in_AMXdeltaY),hl

   ld h,0
   ld (_in_AMXcoordX),hl
   ld (_in_AMXcoordY),hl
   ret


; interrupt service routines

.XInterrupt

   push af
   push de
   push hl

   ld de,(_in_AMXdeltaX)
   ld hl,(_in_AMXcoordX)

   in a,($1f)
   or a
   jr z,posx
   sbc hl,de
   jp nc, contx
   ld hl,0
   jp contx

.posx

   add hl,de
   jp nc, contx
   ld hl,$ffff

.contx

   ld (_in_AMXcoordX),hl
   pop hl
   pop de
   pop af
   ei
   reti


.YInterrupt

   push af
   push de
   push hl

   ld de,(_in_AMXdeltaY)
   ld hl,(_in_AMXcoordY)

   in a,($3f)
   or a
   jr z,posy
   add hl,de
   jp nc, conty
   ld hl,$ffff
   jp conty

.posy

   sbc hl,de
   jp nc, conty
   ld hl,0

.conty

   ld (_in_AMXcoordY),hl
   pop hl
   pop de
   pop af
   ei
   reti

DEFC ASMDISP_IN_MOUSEAMXINIT_CALLEE = # asmentry - in_MouseAMXInit_callee
