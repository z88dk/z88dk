	; Universal Centronics driver for the ZX Spectrum
	; Stefano - November, 2025
	;
	; This module must be configured with centronics_init(n), where n is the driver number
	; centronics_send(c) will then print a single character taking care of the handshake.

    SECTION code_clib

    PUBLIC  centronics_init
    PUBLIC  _centronics_init
    PUBLIC  centronics_send
    PUBLIC  _centronics_send

	; Basing on a doc referring to russian clones some printer, like the ROBOTRON 6329
	; require the driver to send a VERY long STROBE signal
	; I chose a much shorter value, yet almost all of the drivers had no delay at all !
	; Probably it is relevant on systems with 14Mhz like the ATM Turbo.
	; If you need to speed-up the printer output just set it to zero.
	; If your printer doesn't work, properly try 0 or 255.

    PUBLIC  centronics_strobe_delay
    PUBLIC  _centronics_strobe_delay

    EXTERN  __bit_irqstatus

    EXTERN  call_rom3
    ;EXTERN  zx_opus


centronics_send:
_centronics_send:
  pop   bc
  pop   hl
  push  hl      ; no FASTCALL to have also a drop-in replacement
  push  bc      ; for fputc_cons
  ld    a,l
  PUSH  AF
;------------------------
; centronics_di
;------------------------
    ld      a, i      ; get the current status of the irq line
    di
    push    af
    ex      (sp), hl
    ld      (__bit_irqstatus), hl
    pop     hl
;------------------------
  ld bc,(driver_selected)
  push bc
  ret


centronics_init:
_centronics_init:
  ld a,l
  and a
  jp z,init_morex      ;  0: Morex, Abbeydale, Indescomp, Ventamatic,
                       ;     PIN SOFT I/F, Microhobby, B&V Interface
                       ;     Proceeding Electronic System,
                       ;     Elettronica 2000 magazine n.53
  cp 100
  jp z,init_if1        ; 100: ZX Interface 1 (lame implementation, 9600bps by default)

  dec a
  jp z,init_dktronic   ;  1: DK'Tronic (Z80 PIO)
  dec a
  jp z,init_kempe      ;  2: Kempston Interface E
  dec a
  jp z,init_kempston   ;  3: Kempston Interface S
  dec a
  jp z,init_hilderbay  ;  4: Hilderbay Printer Interface
  dec a
  jp z,init_hwg        ;  5: Centronics-Schnittstelle, HWG 1986
  dec a
  jp z,init_ne         ;  6: (strobed) - Nuova Elettronica magazine n.98, kit LX674
                       ;                 MICROFACE by CSH (Bajtek magazine)
  dec a
  jp z,init_plus3      ;  7: ZX Spectrum +2A/+3
  dec a
  jp z,init_disciple   ;  8: DISCiPLE
  dec a
  jp z,init_plusd      ;  9: +D interface
  dec a
  jp z,init_lprint3    ; 10: Euroelectronics LPRINT III (called MK III in Russian clones)
                       ;     e.g. ATM Turbo
  dec a
  jp z,init_aerco      ; 11: AERCO CP-ZX (A.K.A. CP-2068), OLIGER
  dec a
  jp z,init_ppi        ; 12: 8255 PPI based 3-port parallel interface by Marko Solajic
  dec a
  jp z,init_tasman     ; 13: TASMAN P.Printer Interface (Type A / USA B)
  dec a
  jp z,init_tasman_b   ; 14: TASMAN Type B (USA Type C)
  dec a
  jp z,init_wafa       ; 15: Rotronics WAFADRIVE Centronics interface
  dec a
  jp z,init_zxpower    ; 16: ZX-POWER PROD "ZX LPRINT" - Denmark
  dec a
  jp z,init_link       ; 17: "CENTRONICS LINK" interface by RS/MM
  dec a
  jp z,init_gama_a     ; 18: Didaktik Gama (strobed on port A)
  dec a
  jp z,init_gama_b     ; 19: Didaktik Gama "Proxima" (strobed on port B)
  dec a
  jp z,init_special_a  ; 20: SPECIAL DIDAKTIK (M/P interface), suggested option
  dec a
  jp z,init_special_b  ; 21: SPECIAL DIDAKTIK B, and expansions on "Baltik" or "Ural"
  dec a
  jp z,init_multiprint ; 22: Romantic Robot MULTIPRINT
  dec a
  jp z,init_hobbit     ; 23: Hobbit (Хоббит), strobed Z80 PIO
  dec a
  jp z,init_aj         ; 24: A & J Centronics or "Micro-Drive"+Centronics
  dec a
  jp z,init_interface3 ; 25: Interface III Printer interface
  dec a
  jp z,init_opus       ; 26: Opus Discovery (crashes if Interface 1 is connected)
  dec a
  jp z,init_8255       ; 27: Russian "AT IMS KR580VV66A PIA", very close to PPI
  dec a
  jp z,init_ads        ; 28: ADS Interface, a.k.a. "Printer Interface 1"

  ; default
  jp init_morex


;=========================================================
;
; TODO:
; Watford Centronics + RS232
; Fuller and Fuller Dual interface (also RS232) -> Nordic Systems ?
; Microdigital TK90X/ TK95
; CS-Disk
; Pericon-C
; Parallel over AY-3-8910
;
; -------(shadow/ROM tricks)------- 
; Sam Coupè  (CALL 0181H - send A to parallel printer)
; FDD-3000
;


;=========================================================
; A & J Centronics and "Micro-Drive"+Centronics

init_aj:
  ld   hl,cfg_aj
  jp   init_general_sub

cfg_aj:
	defw $0041   ; busy port
	defb $04     ; busy mask
	defw $0042   ; data port
	defw $0041   ; strobe port
	defb $04     ; strobe low (enabled)    ..inverted, the real strobe is active low
	defb $00     ; strobe high


;=========================================================
; Interface III Printer interface

init_interface3:
  ld   hl,cfg_interface3
  jp   init_general_sub

cfg_interface3:
	defw $FC9F   ; busy port
	defb $01     ; busy mask
	defw $FD9F   ; data port
	defw $FC9F   ; strobe port
	defb $00     ; strobe low (enabled)
	defb $02     ; strobe high


;=========================================================
; Centronics-Schnittstelle, HWG 1986

init_hwg:
  LD  A,$0F      ; some unknown magic found in the original driver
  OUT ($5F),A
  LD  A,$CF
  OUT ($7F),A
  LD  A,$01
  OUT ($7F),A
  LD  A,$67
  OUT ($7F),A
;  LD  A,$80
;  OUT ($3F),A    --> already in the "general" code section
  ld   hl,cfg_hwg
  jp   init_general_sub

cfg_hwg:
	defw $003F   ; busy port
	defb $01     ; busy mask
	defw $001F   ; data port
	defw $003F   ; strobe port
	defb $00     ; strobe low (enabled)
	defb $80     ; strobe high


;=========================================================
; DK'Tronic 1988 (see also "Henk de Groot" ROM)
; https://www.pcbway.com/project/shareproject/ZX_Spectrum_LPT_Centronics_Interface_40443afb.html

init_dktronic:
;  LD  A,$1F
;  LD  ($0001),A
  LD  A,$3F            ; Program Z80-PIO port A to 
  OUT ($DB),A          ; be all "outputs". 
  LD  A,$FF            ; Port A will be connected to the 
  OUT ($FB),A          ; Centronix data lines. 
  LD  A,$80            ; Program port B to "inputs" 
  OUT ($FB),A          ; Except bit 8 on port B 
;  LD  A,$02            ; Bit 2 of port B will be the
;  OUT ($BB),A          ; "Stobe", initialize to "1"    --> already in the "general" code section
;  LD  A,$0A
;  LD  ($0002),A
  ld   hl,cfg_dktronic
  jp   init_general_sub

cfg_dktronic:
	defw $00BB   ; busy port
	defb $80     ; busy mask
	defw $009B   ; data port
	defw $00BB   ; strobe port
	defb $00     ; strobe low (enabled)
	defb $02     ; strobe high


;=========================================================
; Kempston Interface E

init_kempe:
  xor  a             ; clear data port (and disable STROBE)
  OUT  ($BF),A
  ld   hl,send_kempe
  ld   (driver_selected),hl
  RET

send_kempe:
send_kempe_busy:
  call centronics_break
  IN   A,($BF)
  AND  $40
  JR   NZ,send_kempe_busy
  ld   a,(centronics_strobe_delay)
  ld   b,a
  POP  AF
  OUT  ($BF),A       ; send data
  OUT  ($BB),A       ; send strobe
send_kempe_strobe:
  djnz send_kempe_strobe
  OUT  ($BF),A       ; stop strobe signal
  jp   centronics_ei


;=========================================================
; Romantic Robot Multiprint
; (IN A,($BF)->rom_page-in, IN A,($BB)->rom_page-out)

init_multiprint:
  xor  a             ; clear data port (and disable STROBE)
  OUT  ($BF),A
  ld   hl,send_multiprint
  ld   (driver_selected),hl
  RET

send_multiprint:
send_multiprint_busy:
  IN   A,($BF)       ; page in the ROM (I hope so!)
  call centronics_break
  IN   A,($BB)       ; test BUSY (and page out the ROM)
  BIT 6,A
  JR   NZ,send_multiprint_busy
  ld   a,(centronics_strobe_delay)
  ld   b,a
  POP  AF
  OUT  ($BF),A       ; send data
  OUT  ($BB),A       ; send strobe
send_multiprint_strobe:
  djnz send_multiprint_strobe
  OUT  ($BF),A       ; stop strobe signal
  IN   A,($BF)       ; page in the ROM (I hope so!)
  jp   centronics_ei


;=========================================================
; DISCiPLE parallel port

init_disciple:
  ld   hl,cfg_disciple
  jp   init_general_sub

cfg_disciple:
	defw $001F   ; busy port
	defb $40     ; busy mask
	defw $00FB   ; data port
	defw $001F   ; strobe port
	defb $40     ; strobe low (enabled)   ..inverted, on bit 6
	defb $00     ; strobe high


;=========================================================
; +D printer port

init_plusd:
  ld   hl,cfg_plusd
  jp   init_general_sub

cfg_plusd:
	defw $00F7   ; busy port
	defb $80     ; busy mask
	defw $00F7   ; data port
	defw $00EF   ; strobe port
	defb $40     ; strobe low (enabled)   ..inverted, on bit 6
	defb $00     ; strobe high


;=========================================================
;  CENTRONICS interface kit LX674 (from the Nuova Elettronica magazine, page 78)
;  (https://win.adrirobot.it/nuova_elettronica/pdf/nuova-elettronica-098.pdf)
;  and MICROFACE by CSH (as presented in the Bajtek magazine)
;  (https://archive.org/details/bajtek19900708/page/28)
;  The strobe signal is generated by the interface circuitry
;  ZXPRINT (unknown interface)

init_ne:
;  XOR  A  
;  OUT  ($FB),A              ; INIT code found in "ZXPRINT", it sends a NUL (hopefully harmless)
  ld  hl,send_ne
  ld  (driver_selected),hl
  ret

send_ne:
send_ne_busy:
  call centronics_break
  IN   A,($FB)
  and  $80                  ; bit 7 = BUSY signal
  ld   b,a
  IN   A,($FB)
  and  $80
  cp   b                    ; we want to have a stable signal
  jr   nz,send_ne_busy
  or   a                    ; BUSY (active low) must be off
  jr   nz,send_ne_busy
  POP  AF
  OUT  ($FB),A               ; Prepare data to be sent
  ld   a,(centronics_strobe_delay)
  ld   b,a                   ; originally it was 80 decimal, 70 is close enough
send_ne_delay:
  djnz send_ne_delay
  jp   centronics_ei        ; the I/F Centronics by PIN SOFT had a short delay here,
                            ; the code around centronics_ei will suffice


;=========================================================
;  ADS Interface
;  "Printer Interface 1" by Advanced Digital Systems Ltd. 

init_ads:
  ld  hl,send_ads
  ld  (driver_selected),hl
  ret

send_ads:
send_ads_busy:
  call centronics_break
  IN   A,($9d)
  bit  4,a
  jr   nz,send_ads_busy
  POP  AF
  OUT  ($9d),A               ; Prepare data to be sent

  ld   a,(centronics_strobe_delay)
  ld   b,a                   ; originally it was 80 decimal, 70 is close enough
send_ads_delay:
  djnz send_ads_delay
  jp   centronics_ei


;=========================================================
;  "General case"
;  Found in a driver for the Timex computers

init_gen:
  ld   hl,cfg_gen
  jp   init_general_sub

cfg_gen:
	defw $0080   ; busy port
	defb $10     ; busy mask
	defw $0082   ; data port
	defw $0081   ; strobe port
	defb $FE     ; strobe low (enabled)
	defb $FF     ; strobe high


;=========================================================
;  Morex Peripherals Ltd (a.k.a. Abbeydale Designers Ltd)
;  B&V Interface, Forlì - Italy, by Simone Majocchi
;  Proceeding Electronic System, San prospero (MO) - Italy
;  Ventamatic, Indescomp by MHT ingenieros - Spain, 
;  Elettronica 2000 magazine n.53, Spet. 1983, p.41
;  (https://win.adrirobot.it/E2000/pdf/E2000_053_Set_1983.pdf)
;  Microhobby (it didn't have the RS232 mode)
;  PIN SOFT I/F Centronics

init_morex:
  ld   hl,cfg_morex
  jp   init_general_sub

cfg_morex:
	defw $00FB   ; busy port
	defb $01     ; busy mask
	defw $00FB   ; data port
	defw $007F   ; strobe port
	defb $FE     ; strobe low (enabled)
	defb $FF     ; strobe high


;=========================================================
;  Spectrum +2A/+3

init_plus3:
  ld   a,($5b67)
  ld   bc,$1ffd
  set  4,a
  ld   ($5b67),a
  out  (c),a           ; set strobe high
  ld   hl,send_plus3
  ld   (driver_selected),hl
  ret

send_plus3:
send_plus3_busy:
  call centronics_break
  ld   bc,$0ffd
  in   a,(c)
  bit  0,a
  JR   NZ,send_plus3_busy
  pop  af
  out  (c),a           ; output character
.send_plus3_strobe
  ld   bc,$1ffd
  ld   a,($5b67)
  xor  $10                      ; toggle strobe bit and update BANK678
  ld   ($5b67),a
  out  (c),a                    ; output strobe
  bit  4,a
  jr   z,send_plus3_strobe      ; loop back to finish with strobe high
  jp   centronics_ei


;=========================================================
;  Kempston Centronics ("ordinary", not Kempston E)

init_kempston:
  LD   BC,$E3BF
  LD   A,$81
  OUT  (C),A
  ld   hl,cfg_kempston
  jp   init_general_sub

cfg_kempston:
	defw $E2BF   ; busy port
	defb $01     ; busy mask
	defw $E0BF   ; data port
	defw $E3BF   ; strobe port
	defb $0E     ; strobe low (enabled)
	defb $0F     ; strobe high


;=========================================================
; ZX-POWER PROD LPRINT (Denmark)

init_zxpower:
  LD   BC,$031F
  LD   A,$0F
  OUT  (C),A
  ld   hl,send_zxpower
  ld   (driver_selected),hl
  ret

send_zxpower:
send_zxpower_busy:
  call centronics_break
  LD   BC,$001F
  IN   A,(C)             ; 001Fh
  BIT  0,A
  JR   NZ,send_zxpower_busy
  POP  AF
  LD   B,$01
  OUT  (C),A             ; send byte
  LD   B,$02             ; 021Fh
  ld   a,(centronics_strobe_delay)
  ld   d,a
  LD   A,$4F
  OUT  (C),A             ; send strobe signal
send_zxpower_strobe:
  dec  d
  jr   nz,send_zxpower_strobe
  LD   B,$03             ; 031Fh
  LD   A,$0F             ; stop strobe signal
  OUT  (C),A
  jp   centronics_ei


;=========================================================
; LPRINT III (called MK III in Russian clones)
;
; IN  A,($7B) also disables the shadow ROM
; IN  A,($FB) would enable the shadow ROM

init_lprint3:
  xor a
  OUT ($FB),A   ; clear data port (and disable STROBE)
  ld   hl,send_lprint3
  ld   (driver_selected),hl
  ret

send_lprint3:
send_lprint3_busy:
  call centronics_break
  IN  A,($7B)            ; BUSY ?
  RLCA
  JR  C,send_lprint3_busy
  ld  a,(centronics_strobe_delay)
  ld  b,a
  POP AF
  OUT ($FB),A    ; data (and disable STROBE)
  OUT ($7B),A    ; send strobe
send_lprint3_strobe:
  djnz send_lprint3_strobe
  OUT ($FB),A    ; disable strobe
  jp   centronics_ei


;=========================================================
; AERCO CP-ZX (A.K.A. CP-2068)

init_aerco:
  ; xor a
  ; OUT ($7f),A   ; clear data port (and disable STROBE)
  ld   hl,send_aerco
  ld   (driver_selected),hl
  ret


send_aerco:
send_aerco_busy:
  call centronics_break
;  IN   A,($7F)              ; look at input status
;  LD   C,A
;  LD   B,$50
;aerco_busy2:
  IN   A,($7F)
;  CP   C
;  JR   NZ,send_aerco_busy    ; no stable data
;  DJNZ aerco_busy2         ; keep checking for a while
;  BIT  1,A                 ; Enough, let's move on, let's test paper sensor..
;  JR   NZ,send_aerco_busy 
  BIT  4,A                 ; ..and the BUSY signal  (standard simplified drivers existed)
  JR   NZ,send_aerco_busy 
  POP  AF
  OUT  ($7F),A             ; data
  ld   a,(centronics_strobe_delay)   ; doing something rather than NOPs
  ld   b,a
  ;NOP                     ; perhaps useless, but the original driver...
  ;NOP                     ; ...put POP instructions in the way
  ;NOP
  IN   A,($7F)            ; "strobe is generated by reading the port immediately after writing to it"
send_aerco_strobe:
  djnz send_aerco_strobe  ; probably useless, but harmless
  jp   centronics_ei


;=========================================================
; 8255 PPI based 3-port parallel interface by Marko Solajic
; https://github.com/msolajic/zx_spectrum_parallel_interface
;
; The russian version named "AT IMS KR580VV66A PIA" was very close

init_8255:
  ld   a,152
  out  (127),a
  ld   hl,cfg_ppi
  jp   init_general_sub

init_ppi:
  call init_8255
  ld   hl,strobe_high
  xor  a         ; STROBE is inverted in the modern versopm
  ld   (hl),a    ; strobe_high
  cpl
  dec  hl
  ld   (hl),a    ; strobe_low
  ret

cfg_ppi:
	defw $005F   ; busy port
	defb $80     ; busy mask
	defw $003F   ; data port
	defw $005F   ; strobe port
	defb $FE     ; strobe low=$FF ($FE in the russian version)
	defb $5F     ; strobe high=$00 ($5F in the russian version)


;=========================================================
; Hobbit (Хоббит)

init_hobbit:
  ;OUT  (7Fh),A  ; paging or extra peripherals ?
  LD   A,18h    ; init PIO, (strobed) Mode 3 bidirectional
  OUT  (1Fh),A
  ld   hl,send_hobbit
  ld   (driver_selected),hl
  ret

send_hobbit:
send_hobbit_busy:
  call centronics_break
  IN   A,($FF)              ; look at input status
  RLCA
  JR   NC,send_hobbit_busy
  POP  AF
  OUT  ($3F),A    ; Data
  ;OUT (5Fh),A    ; the CP/M BIOS sends a different data byte here
  ld   a,(centronics_strobe_delay)
  ld   b,a
send_hobbit_strobe:
  djnz send_hobbit_strobe
  jp   centronics_ei


;=========================================================
; TASMAN Centronics interface

init_tasman:
  call init_tasman_b
  LD   A,$00BF   ; busy_port
  ld   (busy_port),A
  ret


;=========================================================
; TASMAN Centronics interface Type B (USA Type C)

init_tasman_b:
;  SUB A         ; odd "init" code in the original driver
;  OUT ($FB),A
;  DEC A
;  OUT ($7B),A
;  OUT ($FB),A
  ld   hl,cfg_tasman_b
  jp   init_general_sub

cfg_tasman_b:
	defw $00FB   ; busy port
	defb $01     ; busy mask
	defw $007B   ; data port
	defw $00FB   ; strobe port
	defb $F7     ; strobe low (enabled)
	defb $FF     ; strobe high


;=========================================================
; Rotronics WAFADRIVE Centronics interface

init_wafa:
  ld   bc,$000A
  in   a,(c)       ; enforce "strobe off"
  ld   hl,send_wafa
  ld   (driver_selected),hl
  ret
  
send_wafa:
send_wafa_busy:
  call centronics_break
  LD   BC,$0002
  IN   A,(C)
  BIT  5,A
  JR   Z,send_wafa_busy
  POP  AF
  ld   b,a
  ld   c,$0e
  IN   A,(C)               ; *send* data
  ld   a,(centronics_strobe_delay)
  ld   d,a
  ld   bc,$200A
  IN   A,(C)               ; strobe
send_wafa_wait:
  dec  d
  jr   NZ,send_wafa_wait
  ld   b,$00
  IN   A,(C)               ; strobe off
  jp   centronics_ei


;=========================================================
; "CENTRONICS LINK" interface by RS/MM
; Produced by Computershop LINK - Lindengasse 20  - Wien, 1984

init_link:
  ld   bc,$000A
  in   a,(c)
  ld   hl,cfg_link
  jp   init_general_sub

cfg_link:
	defw $FF3F   ; busy port
	defb $20     ; busy mask
	defw $FF5F   ; data port
	defw $FF1F   ; strobe port
	defb $00     ; strobe low (enabled)
	defb $FF     ; strobe high

;=========================================================
; Hilderbay Printer Interface, 1983

init_hilderbay:
  LD   BC,$FFBF  ; odd init code from the original driver
  LD   A,$83
  OUT  (C),A
  ld   bc,$000A
  in   a,(c)
  ld   hl,cfg_hilderbay
  jp   init_general_sub

cfg_hilderbay:
	defw $DFBF   ; busy port
	defb $08     ; busy mask
	defw $DBBF   ; data port
	defw $FFBF   ; strobe port
	defb $0E     ; strobe low (enabled)
	defb $0F     ; strobe high


;=========================================================
; Didaktik Gama
;
; STROBED PORT A   (rather common on the Didaktik Gama)
; 8255 is configured in "mode 1", port A ($1F) is used for data
; Port C:  STROBE(out) - bit 7, ACK (in) - bit 6

init_gama_a:
  LD A,$92       ; [10010010] init 8255, A=OUT, B=IN, C=control
  OUT ($7F),A
  ld   hl,send_gama_a
  ld   (driver_selected),hl
  ret

send_gama_a:
send_gama_a_busy:
  call centronics_break
  IN   A,($5F)
  BIT  3,A
  jr   z,send_gama_a_busy
  POP  AF
  LD HL,$5C81            ; The system variable 23681 is declared "unused" but
  BIT 7,(HL)             ; contains 91 in the standard Spectrum ROM, because it is
  JR Z,no_inversion      ; indeed used by the ZX Printer together with 23680 as
  CPL                    ; a pointer to the printer buffer.
no_inversion:            ; On the GAMA it allows to invert the data bits
  OUT ($1F),A    ; data
  ld   a,(centronics_strobe_delay)
  ld   b,a               ; The _strobe signal is automatic.  We add a delay, just to be sure
send_gama_a_wait:
  djnz send_gama_a_wait:
  jp   centronics_ei


;=========================================================
; Didaktik Gama
;
; STROBED PORT B   (used by Proxima)
; 8255 is configured in "mode 1", port B is used for data
; Port C:  STROBE(out) - bit 1, ACK (in) - bit 2

init_gama_b:
  LD A,$6A       ; [01101010] init 8255
  OUT ($7F),A
  ld   hl,send_gama_b
  ld   (driver_selected),hl
  ret

send_gama_b:
send_gama_b_busy:
  call centronics_break
  IN   A,($5F)
  BIT  3,A
  jr   z,send_gama_b_busy
  POP  AF
  ; Let's skip the "bit inversion" option for the moment
  OUT ($3F),A    ; data
  ld   a,(centronics_strobe_delay)
  ld   b,a               ; The _strobe signal is automatic.  We add a delay, just to be sure
send_gama_b_wait:
  djnz send_gama_b_wait:
  jp   centronics_ei


;=========================================================
; SPECIAL DIDAKTIK  (to be used with the M/P interface)
; 8255 is configured in "mode 0", port A is used for data
; Port C:  STROBE(out) - bit 3, BUSY (in) - bit 7

init_special_a:
  LD    A,$8A       ; [10001010] init 8255, A=OUT, B=IN, C[0..3]=OUT, C[4..7]=IN
  OUT   ($7F),A
  ld    hl,cfg_special_b
  call  init_general_sub
  ld    a,$1F
  ld    (data_port),a
  ret


;=========================================================
; SPECIAL DIDAKTIK  B
; 8255 is configured in "mode 0", port B is used for data
; Port C:  STROBE(out) - bit 3, BUSY (in) - bit 7
;
; this interface is very close to the PPI one, but for the strobe signal

init_special_b:
  LD A,$98       ; [10011000] init 8255, A=IN, B=OUT, C[0..3]=OUT, C[4..7]=IN
  OUT ($7F),A
  ld   hl,cfg_special_b
  jp   init_general_sub

cfg_special_b:
	defw $005F   ; busy port
	defb $80     ; busy mask
	defw $003F   ; data port
	defw $007F   ; strobe port
	defb $06     ; strobe low (enabled)
	defb $07     ; strobe high


;=========================================================
; ZX Interface 1 - default is 9600bps
; this is a light implementation prone to crashes
; the version in the rs232 library is preferrable
;
; this interface is very close to the PPI one, but for the strobe signal

init_if1:
  ld   hl,send_interface1      ; Now, the IF1 is not related to Centronics but
  ld   (driver_selected),hl    ; it is easy to add, the default speed is 9600bps
  rst  8
  defb $31                     ; Create Interface 1 system vars if not present already
  ret

send_interface1:
  pop  af           ; get the character in A
  rst  8
  defb $1E          ;  Calls the Hook Code
  jp   centronics_ei
  

;=========================================================
; OPUS Discovery
;
; The commented out code was intended to avoid crashes in case the Opus Discovery was absent.
; This would still happen with the Interface 1 connected and possibly
; other expansions, so we keep the code small and leave the eventual
; protections to the caller program by using zx_interface1(), zx_opus(), etc..

init_opus:
  ;call zx_opus
  ;ld   a,l
  ;and  a
  ;jp   z,init_morex            ; No OPUS, no known interfaces availabe, fall back to default
  ld   hl,send_opus
  ld   (driver_selected),hl
  ret

send_opus:
  call call_rom3
  defw $1708        ; Page in the Discovery ROM

  pop  af              ; A := character.
  LD   HL,$3003
  LD   (HL),$38        ; Clock on for bits program
  DEC  HL
  LD   (HL),$FF        ; Signal: all databits = out
  DEC  HL
  RES  2,(HL)          ; Clock on for BUSY program
  DEC  HL
  RES  6,(HL)          ; Signal: BUSY = input.
  INC  HL
  SET  2,(HL)          ; Clock off for BUSY program
  INC  HL
  INC  HL
  LD   (HL),$3C        ; Clock off for bits program
  DEC  HL
  LD   (HL),A          ; data
send_opus_busy:
  call opus_break      ; Test the 'BREAK' key.
  LD   A,($3000)
  BIT  6,A             ; Printer BUSY?
  JR   NZ,send_opus_busy
  INC  HL
  LD   (HL),$34        ; STROBE on.
  ld   a,(centronics_strobe_delay)
  ld   b,a
send_opus_wait:
  djnz send_opus_wait
  LD   (HL),$3C        ; STROBE off.

; The ACK signal is not much relevant, if we're in trouble we can compensate 
; with a delay before sending the next character or by extending
; the STROBE duration a little

;  DEC  HL
;  DEC  HL
;send_opus_wait_ack:
;  call opus_break      ; Test the 'BREAK' key.
;  BIT  6,(HL)          ; Wait for ACK to go high.
;  JR   Z,send_opus_wait_ack      ;  (Don't wait for it to go low again)

opus_ei:
    ld      hl,0
    push    hl
    ld      hl, (__bit_irqstatus)
    ex      (sp), hl
    push    hl
    call    call_rom3
    defw    $1748      ; Page out the Discovery ROM
    pop     hl
    pop     af
    ret     po
    ei
    ret

opus_break:
    LD      A,$7F      ; SPACE key ?
    IN      A,($FE)
    RRA
    RET     C
    LD      A,$FE      ; CAPS SHIFT key ?
    IN      A,($FE)
    RRA
    RET     C

    pop     bc     ; skip RET to the caller
    ld      hl,-1
    jr      opus_ei+3


;=========================================================
; shared subroutines
;=========================================================

init_general_sub:
  ld    de,busy_port
  ld    bc,9
  ldir
  ld    bc,(strobe_port)
  LD    a,(strobe_high)
  out   (c),A              ; send strobe
  ld    hl,send_general
  ld    (driver_selected),hl
  ret

send_general:
  call  centronics_break
  ld    bc,(busy_port)
  ld    hl,busy_mask
  in    a,(c)
  and   (hl)
  ld    d,a
  in    a,(c)
  and   (hl)
  cp    d                     ; we want a stable signal
  jr    nz,send_general
  or    a                     ; BUSY (active low) must be off
  jr    nz,send_general
  ;-----------
  pop   af
  ld    bc,(data_port)
  out   (c),a                ; send byte
  ;-----------
  ld    a,(centronics_strobe_delay)
  ld    d,a
  ld    a,(strobe_low)       ; strobe is active low
  ld    bc,(strobe_port)
  out   (c),a              ; send strobe
send_general_strobe:
  dec   d
  jr    nz,send_general_strobe
  LD    A,(strobe_high)
  out   (c),a              ; send strobe
  jp    centronics_ei

;=========================================================

; Most of the original routines had DI/EI, some didn't
; Is disabling the interrupts really needed for parallel output?

centronics_break:
    LD      A,$7F      ; SPACE key ?
    IN      A,($FE)
    RRA
    RET     C
    LD      A,$FE      ; CAPS SHIFT key ?
    IN      A,($FE)
    RRA
    RET     C

    pop     bc     ; skip RET to the caller
    ld      hl,-1
    jr      centronics_ei+3

;=========================================================

centronics_ei:
    ld      hl,0
    push    hl
    ld      hl, (__bit_irqstatus)
    ex      (sp), hl
    pop     af
    ret     po
    ei
    ret


;=========================================================
;=========================================================


  SECTION  bss_clib


centronics_strobe_delay:
_centronics_strobe_delay:
	defw 20        ; make the strobe signal more persistent (what if we are on a 14mhz ATM Turbo ?)

driver_selected:
	defw send_ne   ; The default value is set to a "strobed" interface which
                   ; doesn't require real initialization

; DO NOT SHUFFLE the data order
;-------------------------------
busy_port:
	defw $0000
busy_mask:
	defb $00
data_port:
	defw $0000
strobe_port:
	defw $0000
strobe_low:
	defb $00
strobe_high:
	defb $ff

