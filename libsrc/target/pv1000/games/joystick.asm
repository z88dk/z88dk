; Casio PV-1000 joystick routines
;
;
; Key input
; Select data to read on port 0FDH and read the same port.
; 　
; Output Bit 3 = 1
; 	Bit 3 = 2 P TRIG 2
; 	Bit 2 = 2 P TRIG 1
; 	Bit 1 = 1 P TRIG 2
; 	Bit 0 = 1 P TRIG 1
; 　
; Output Bit 2 = 1
; 	Bit 3 = 2 P Up
; 	Bit 2 = 2 P Lef
; 	Bit 1 = 1 P Up
; 	Bit 0 = 1 P Left
; 　
; Output Bit 1 = 1
; 	Bit 3 = 2 P Right
; 	Bit 2 = 2 P Down
; 	Bit 1 = 1 P Right
; 	Bit 0 = 1 P Down
; 　
; Output Bit 0 = 1
; 	Bit 3 = 2 P Start
; 	Bit 2 = 2 P Select
; 	Bit 1 = 1 P Start
; 	Bit 0 = 1 P Select
;* It seems that the value outputting this port 0FDH can be confirmed on port 0FCH.
;
;


    SECTION code_clib

    PUBLIC  joystick
    PUBLIC  _joystick

    EXTERN  __keyscan_vals

joystick:
_joystick:
    ld      de,__keyscan_vals
    ld      a,(de)      ;Bit 0 Start, Select -> Output 7,6
    rrca
    rrca
    bit     0, l                        ;J2?
    jr      nz, not_j2_1
    rrca
    rrca
not_j2_1:
    and     @11000000
    ld      h, a                        ;h = return value

    inc     de
    ld      a,(de)                      ;;Bit 1  = Down, right
    bit     0, l                        ;J2?
    jr      nz, not_j2_2
    rrca
    rrca
not_j2_2:
    rrca                                ;Down
    jr      nc, not_down
    set     2, h
not_down:
    rrca                                ;Right
    jr      nc, not_right
    set     0, h
not_right:

    inc     de
    ld      a,(de)                      ;Bit 2 = Up, left
    bit     0, l                        ;J2?
    jr      nz, not_j2_3
    rrca
    rrca
not_j2_3:
    rrca                                ;Left
    jr      nc, not_left
    set     1, h
not_left:
    rrca
    jr      nc, not_up
    set     3, h
not_up:

    inc     de
    ld      a,(de)                      ;Bit 3 = Trig 2, Trig 1
    bit     0, l
    jr      nz, not_j2_4
    rrca
    rrca
not_j2_4:
    rrca                                ; Trigger 1
    jr      nc, not_trigger1
    set     4, h
not_trigger1:
    rrca                                ; Trigger 2
    jr      nc, not_trigger2
    set     5, h
not_trigger2:
    ld      l, h
    ld      h, 0
    ret




