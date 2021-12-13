;-------------------------------------------------------------------------
; Native i/o port functionality for micro8085_cilb
; Functions below assumes support for INTEL 8085 "undocumented" opcodes

        SECTION code_clib

        EXTERN  puartd
        EXTERN  puartc
        EXTERN  padc1
        EXTERN  padc2
        EXTERN  pdac
        EXTERN  uenabl
        EXTERN  urts
        EXTERN  CPU_CLK_kHz
        
        PUBLIC  _io_inp
        PUBLIC  _io_outp
        PUBLIC  _beep_en
        PUBLIC  _beep_dis
        PUBLIC  _adc1_in
        PUBLIC  _adc2_in

;-------------------------------------------------------------------------
; Implementation for read or write access to arbitrary io addres space port
; sets up executable code snippet in ram (on stack) to let cpu execute the
; IN/OUT instructions with port address as succeeding immediate data
;-------------------------------------------------------------------------
; extern uint8 io_inp(uint8 port);
_io_inp:
        ld      hl,2           ;point at argument
        add     hl,sp          ;behind return addr
        ld      a,(hl)         ;get the argument
        ld      hl,0FFFFH      ;go to first ram loc
        add     hl,sp          ;in front of ret addr
        di                     ;disable irq while manipulate ram @ stack
        ld      (hl),0C9H      ;RET instruction
        dec     hl
        ld      (hl),0FBH      ;EI instruction
        dec     hl
; not necessary to zero h as caller treats ret val as byte and reads only l
;        ld      (hl),0         ;d8 = 0
;        dec     hl
;        ld      (hl),26H       ;LD H,d8 instruction
;        dec     hl
        ld      (hl),6FH       ;LD L,A instr (ret val in (h)l)
        dec     hl
        ld      (hl),a         ;io port to read
        dec     hl
        ld      (hl),0DBH      ;IN instruction
        jp      (hl)           ;jmp to (hl) location

;-------------------------------------------------------------------------
; extern void io_outp(uint8 port, uint8 data);
_io_outp:
        ld      hl,2           ;point at argument
        add     hl,sp          ;behind return addr
        ld      a,(hl)         ;get 2nd argument (data)
        inc     hl             ;bump to next
        inc     hl             ;arg position
        ld      b,(hl)         ;get 1st argument (port)
        ld      hl,0FFFFH      ;go to first ram loc
        add     hl,sp          ;in front of ret addr
        di                     ;disable irq while manipulate ram @ stack
        ld      (hl),0C9H      ;RET instruction
        dec     hl
        ld      (hl),0FBH      ;EI instruction
        dec     hl
        ld      (hl),b         ;io port to write (data already in a)
        dec     hl
        ld      (hl),0D3H      ;OUT instruction
        jp      (hl)           ;jmp to (hl) location

;-------------------------------------------------------------------------
; extern void beep_en(void)
_beep_en:
        ld      a,uenabl+urts   ;beep on/off gate on RTS line
        out     (puartc),a      ;uart control reg
        ret

;-------------------------------------------------------------------------
; extern void beep_dis(void)
_beep_dis:
        ld      a,uenabl        ;disable RTS and DTR lines
        out     (puartc),a      ;uart control reg
        ret

;-------------------------------------------------------------------------
; extern uint8 adc1_in(void)
_adc1_in:
        out     (padc1),a       ;dummy write to start conversion
        call    dly140us        ;wait for conversion (takes 140us)
        in      a,(padc1)       ;read result
        ld      l,a             ;return val in (h)l
        ret

;-------------------------------------------------------------------------
; extern uint8 adc2_in(void)
_adc2_in:
        out     (padc2),a       ;dummy write to start conversion
        call    dly140us        ;wait for conversion (takes 140us)
        in      a,(padc2)       ;read result
        ld      l,a             ;return val in (h)l
        ret

;-------------------------------------------------------------------------
dly140us:                       ;(2/XTAL)*n*(4+10)=140us -> n=XTAL_kHz/200
        ld      h,CPU_CLK_kHz/200
dly2:   dec     h               ;4 clock cycles
        jp      nz,dly2         ;10 clock cycles
        ret                     ;returning zero in h

