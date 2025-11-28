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
                       ;     PIN SOFT I/F, Elettronica 2000 magazine n.53, Microhobby,
					   ;     Proceeding Electronic System, B&V Interface
  dec a
  jp z,init_dktronics  ;  1: DK'Tronics (Z80 PIO)
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
  jp z,init_aerco      ; 11: AERCO CP-ZX (A.K.A. CP-2068)
  dec a
  jp z,init_ppi        ; 12: 8255 PPI based 3-port parallel interface by Marko Solajic
                       ;     also mentioned in a russian website as "AT IMS KR580VV66A PIA"
  dec a
  jp z,init_tasman     ; 13: TASMAM Parallel Printer Interface
  dec a
  jp z,init_wafa       ; 14: Rotronics WAFADRIVE Centronics interface
  dec a
  jp z,init_zxpower    ; 15: ZX-POWER PROD "ZX LPRINT" - Denmark
  dec a
  jp z,init_link       ; 16: "CENTRONICS LINK" interface by RS/MM
  dec a
  jp z,init_gama_a     ; 17: Didaktik Gama (strobed on port A)
  dec a
  jp z,init_gama_b     ; 18: Didaktik Gama "Proxima" (strobed on port B)
  dec a
  jp z,init_special_a  ; 19: SPECIAL DIDAKTIK (M/P interface), suggested option
  dec a
  jp z,init_special_b  ; 20: SPECIAL DIDAKTIK B
  dec a
  jp z,init_multiprint ; 21: Romantic Robot MULTIPRINT
  dec a
  jp z,init_hobbit     ; 22: Hobbit (Хоббит), strobed Z80 PIO

  ; default
  jp init_morex


;=========================================================


; TODO:
; Fuller and Fuller Dual interface (also RS232)
; Microdigital TK90X/ TK95
; Opus Discovery
; Sam Coupè


;=========================================================
; Centronics-Schnittstelle, HWG 1986

init_hwg:
  LD  A,$0F
  OUT ($5F),A
  LD  A,$CF
  OUT ($7F),A
  LD  A,$01
  OUT ($7F),A
  LD  A,$67
  OUT ($7F),A
  LD  A,$80
  OUT ($3F),A
  ld  hl,send_hwg
  ld  (driver_selected),hl
  RET
  
send_hwg:
send_hwg_busy:
  call  centronics_break
  IN    A,($3F)
  RRA
  JR    C,send_hwg_busy
  POP   AF
  OUT   ($1F),A
  ld    a,(centronics_strobe_delay)
  ld    b,a
  XOR   A
  OUT   ($3F),A      ; enable strobe (active low)
send_hwg_strobe:
  djnz  send_hwg_strobe
  LD    A,$80
  OUT   ($3F),A
  jp    centronics_ei


;=========================================================
; DK'Tronics 1988 (see also "Henk de Groot" ROM)
; https://www.pcbway.com/project/shareproject/ZX_Spectrum_LPT_Centronics_Interface_40443afb.html

init_dktronics:
;  LD  A,$1F
;  LD  ($0001),A
  LD  A,$3F            ; Program Z80-PIO port A to 
  OUT ($DB),A          ; be all "outputs". 
  LD  A,$FF            ; Port A will be connected to the 
  OUT ($FB),A          ; Centronix data lines. 
  LD  A,$80            ; Program port B to "inputs" 
  OUT ($FB),A          ; Except bit 8 on port B 
  LD  A,$02            ; Bit 2 of port B will be the 
  OUT ($BB),A          ; "Stobe", initialize to "1" 
;  LD  A,$0A
;  LD  ($0002),A
  ld  hl,send_dktronics
  ld  (driver_selected),hl
  RET

send_dktronics:
send_dktronics_busy:
  call centronics_break
  XOR  A                         ; Look if the printer is BUSY 
  IN   A,($BB)                   ; Look at dataline 8 of Z80-PIO 
  RLCA                           ; port B. 
  JR   C,send_dktronics_busy     ; Repeat if printer is busy 
  POP  AF                        ; Restore register A 
  OUT  ($9B),A    ; send data    ; Put A on Z80-PIO port A 
  ld   a,(centronics_strobe_delay)
  ld   b,a
  XOR  A                         ; Make A clean 
  OUT  ($BB),A                   ; Lower the STROBE signal, data 
send_dktronics_strobe:           ; line 2 of port B.
  djnz send_dktronics_strobe     ; The data is clocked in into the printer
                                 ;  with the STROBE signal.
  LD   A,$02
  OUT  ($BB),A                   ; Raise it again  
  jp   centronics_ei


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
  xor  a             ; clear STROBE (and stop/disable disk drives)
  OUT  ($1F),A       ; stop strobe signal
  ld   hl,send_disciple
  ld   (driver_selected),hl
  RET

send_disciple:
send_disciple_busy:
  call centronics_break
  IN   A,($1F)
  BIT  6,A
  JR   Z,send_disciple_busy
  POP  AF
  OUT  ($FB),A       ; send data
  ld   a,(centronics_strobe_delay)
  ld   b,a
  ld   a,$40
  OUT  ($1F),A       ; send strobe
send_disciple_strobe:
  djnz send_disciple_strobe
  xor  a
  OUT  ($1F),A       ; stop strobe signal
  jp   centronics_ei


;=========================================================
; +D printer port

  xor  a             ; clear STROBE (and stop/disable disk drives)
init_plusd:
  OUT  ($EF),A       ; stop strobe signal
  ld   hl,send_plusd
  ld   (driver_selected),hl
  RET

send_plusd:
send_plusd_busy:
  call centronics_break
  IN   A,($f7)
  BIT  7,A
  JR   NZ,send_plusd_busy
  IN   A,($f7)
  BIT  7,A
  JR   NZ,send_plusd_busy
  IN   A,($f7)
  BIT  7,A
  JR   NZ,send_plusd_busy
  POP  AF
  OUT  ($f7),A       ; send data
  ld   a,(centronics_strobe_delay)
  ld   b,a
  ld   a,$40
  OUT  ($EF),A       ; send strobe
send_plusd_strobe:
  djnz send_plusd_strobe
  xor  a
  OUT  ($EF),A       ; stop strobe signal
  jp   centronics_ei


;=========================================================
;  CENTRONICS interface kit LX674 (from the Nuova Elettronica magazine, page 78)
;  (https://win.adrirobot.it/nuova_elettronica/pdf/nuova-elettronica-098.pdf)
;  and MICROFACE by CSH (as presented in the Bajtek magazine)
;  (https://archive.org/details/bajtek19900708/page/28)
;  The strobe signal is generated by the interface circuitry
;  ZXPRINT (unknown interface)

init_ne:
  XOR  A  
  OUT  ($FB),A               ; INIT code found in "ZXPRINT", it sends a NUL (hopefully harmless)
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
  ld   a,(centronics_strobe_delay)
  ld   b,a                   ; originally it was 80 decimal, 70 is close enough
send_ne_delay:
  djnz send_ne_delay
  POP  AF
  OUT  ($FB),A               ; Prepare data to be sent
send_ne_wait:
  djnz send_ne_wait         ; loop 256 times, leaving time to the automatic strobe
  jp   centronics_ei        ; the I/F Centronics by PIN SOFT had a short delay here,
                            ; the code around centronics_ei will suffice


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
  ld  a,$FF                 ; no strobe
  OUT ($7F),A
  ld  hl,send_morex
  ld  (driver_selected),hl
  ret

send_morex:
send_morex_busy:
  call  centronics_break
  IN    A,($FB)
  and   1                    ; test the right bit for BUSY
  JR    NZ,send_morex_busy
  POP   AF
  OUT   ($FB),A              ; send byte
  ld    a,(centronics_strobe_delay)
  ld    b,a
  LD    A,$FE                ; strobe on bit 0
  AND   $FE
  OUT   ($7F),A              ; send strobe
send_morex_strobe:
  djnz  send_morex_strobe
  INC A                      ; stop strobe signal
  OUT   ($7F),A
  jp    centronics_ei        ; the I/F Centronics by PIN SOFT had a short delay here,
                             ; the code around centronics_ei will suffice


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
  LD   A,$0F
  OUT  (C),A
  ld   hl,send_kempston
  ld   (driver_selected),hl
  ret

send_kempston:
send_kempston_busy:
  call centronics_break
  LD   BC,$E2BF        ; busy port
  in   a,(c)
  rra
  jr   c,send_kempston_busy
  POP  AF
  ld   b,$E0
  out  (c),a      ; send character
  ld   a,(centronics_strobe_delay)
  ld   d,a
  ld   a,$0E       ; strobe data
  ld   b,$E3       ; change port to E3BFh, strobe port
  out  (c),a       ; enable STROBE
send_kempston_strobe:
  dec  d
  jr   nz,send_kempston_strobe
  inc  a           ; stop STROBE signal
  out  (c),a
  jp   centronics_ei


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
  IN   A,($7F)              ; look at input status
  LD   C,A
  LD   B,$50
aerco_busy2:
  IN   A,($7F)
  CP   C
  JR   NZ,send_aerco_busy   ; no stable data
  DJNZ aerco_busy2        ; keep checking for a while
  BIT  1,A                 ; Enough, let's move on, let's test paper sensor..
  JR   NZ,send_aerco_busy 
  BIT  4,A                 ; ..and the BUSY signal
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
; Also found in a russian website as "AT IMS KR580VV66A PIA"

init_ppi:
  ld   a,152
  out  (127),a
  ld   hl,send_ppi
  ld   (driver_selected),hl
  ret

send_ppi:
send_ppi_busy:
  call centronics_break
  IN   A,($5F)              ; look at input status
  BIT  7, A
  JR   NZ,send_ppi_busy
  POP  AF
  OUT  ($3F), A              ; Data
  ld   a,(centronics_strobe_delay)
  ld   b,a
  LD   A, $FF                 ; STROBE 0
  OUT  ($5F), A
send_ppi_strobe:
  djnz send_ppi_strobe
  LD   A, $00                 ; STROBE 1 ($FE) in the russian version
  OUT  ($5F), A
  jp   centronics_ei


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
  LD  BC,$00FB
  XOR A
  OUT (C),A
  LD  BC,$007B
  CPL               ; strobe off
  OUT (C),A
  OUT ($FB),A       ; enforce "strobe off"
  ld   hl,send_tasman
  ld   (driver_selected),hl
  ret

  LD BC,$00FB
  LD A,$00
  OUT (C),A
  LD BC,$007B
  LD A,$FF
  OUT (C),A
  OUT ($FB),A
  
send_tasman:
send_tasman_busy:
  call centronics_break
  LD   BC,$00BF
  IN   D,(C)
  BIT  0,D
  JR   NZ,send_tasman_busy
;tasman_delay:            ; lots of time was taken in the original driver..
;  DJNZ tasman_delay
  POP  AF
  OUT  ($7B),A             ; data
;tasman_wait:
;  DJNZ _tasman_wait
  ld   a,(centronics_strobe_delay)
  ld   b,a
  LD   A,$F7                ; strobe
  OUT  ($FB),A
send_tasman_wait:
  DJNZ send_tasman_wait   ; .. we keep only an adjustable delay for the strobe signal
;tasman_wait2:
;  DJNZ tasman_wait2
  LD   A,$FF                ; strobe off
  OUT  ($FB),A
;tasman_wait3:
;  DJNZ tasman_wait3
  jp   centronics_ei


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
  in   a,(c)       ; enforce "strobe off"
  ld   hl,send_link
  ld   (driver_selected),hl
  ret

send_link:
send_link_busy:
  call centronics_break
  ld b,$FF
  ld c,$3F
  in l,(c)
  bit 5,l
  jr nz,send_link_busy
  POP  AF
  ld b,$FF
  ld c,$5F
  OUT  (C),A         ; DATA
  ld b,$FF
  ld c,$1F
  xor a
  OUT  (C),A
  ld a,$ff           ; "strobe off"
  OUT  (C),A
  jp   centronics_ei


;=========================================================
; Hilderbay Printer Interface, 1983

init_hilderbay:
  LD   BC,$FFBF
  LD   A,$83
  OUT  (C),A
  LD   A,$0F
  OUT  (C),A        ; "strobe off"
  ld   hl,send_hilderbay
  ld   (driver_selected),hl
  ret
  
send_hilderbay:
send_hilderbay_busy:
  call centronics_break
  LD   BC,$DFBF
  IN   a,(C)
  BIT  3,a
  JR   NZ,send_hilderbay_busy
  LD   B,$DB         ; DBBFh
  POP  AF
  OUT  (C),A         ; DATA
  ld   a,(centronics_strobe_delay)
  ld   d,a
  LD   E,$0E         ; "strobe on"
  LD   B,$FF         ; FFBFh
  OUT  (C),E
send_hilderbay_strobe:
  dec  d
  jr   nz,send_hilderbay_strobe
  INC  E             ; "strobe off"
  OUT  (C),E
  jp   centronics_ei


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
  LD A,$8A       ; [10001010] init 8255, A=OUT, B=IN, C[0..3]=OUT, C[4..7]=IN
  OUT ($7F),A
  nop
  ld   a,7       ;set bit 3 on port C
  OUT ($7F),A
  ld   hl,send_special_a
  ld   (driver_selected),hl
  ret
  
send_special_a:
send_special_a_busy:
  call centronics_break
  IN   A,($5F)
  BIT  7,a
  JR   nz,send_special_a_busy
  POP  AF
  OUT ($1F),A    ; data
  ld   a,(centronics_strobe_delay)
  ld   b,a
  ld   a,6       ;reset bit 3 on port C
  OUT ($7F),A
send_special_a_strobe:
  djnz send_special_a_strobe
  ld   a,7       ;set bit 3 on port C
  OUT ($7F),A
  jp   centronics_ei


;=========================================================
; SPECIAL DIDAKTIK  B
; 8255 is configured in "mode 0", port B is used for data
; Port C:  STROBE(out) - bit 3, BUSY (in) - bit 7
;
; this driver is very close to the PPI one, but for the strobe signal

init_special_b:
  LD A,$98       ; [10011000] init 8255, A=IN, B=OUT, C[0..3]=OUT, C[4..7]=IN
  OUT ($7F),A
  nop
  ld   a,7       ;set bit 3 on port C
  OUT ($7F),A
  ld   hl,send_special_b
  ld   (driver_selected),hl
  ret
  
send_special_b:
send_special_b_busy:
  call centronics_break
  IN   A,($5F)
  BIT  7,a
  JR   nz,send_special_b_busy
  POP  AF
  OUT ($3F),A
  ld   a,(centronics_strobe_delay)
  ld   b,a
  ld   a,6       ;reset bit 3 on port C
  OUT ($7F),A
send_special_b_strobe:
  djnz send_special_b_strobe
  ld   a,7       ;set bit 3 on port C
  OUT ($7F),A
  jp   centronics_ei



;=========================================================
; shared subroutines
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

	SECTION	bss_clib

centronics_strobe_delay:
_centronics_strobe_delay:
	defw 20        ; make the strobe signal more persistent (what if we are on a 14mhz ATM Turbo ?)

driver_selected:
	defw send_ne

