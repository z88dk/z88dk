;;
;; Code coming from:  http://www.cepece.info/amstrad/source.html
;;
;; This example shows how it is possible to detect a Amstrad
;; or Vortex floppy disc controller.
;;
;; Both controllers use a NEC765 compatible floppy disc controller,
;; and the same control method to read/write to the discs
;; using the controller (polling).
;;
;; But the NEC765 controller is accessed through different 
;; I/O port addressess for each controller.
;;
;; This example attempts to send a "invalid" command to the NEC765
;; FDC. If the correct responses are detected, then it is assumed
;; that the controller is present and connected.

;
; int cpc_fdc();
; 
; Results:
;    0 - no valid floppy controller found
;    1 - Amstrad FDC
;    2 - Vortex FDC


;; $Id: cpc_fdc.asm,v 1.4 2016-06-10 21:12:36 dom Exp $


        SECTION   code_clib
        PUBLIC cpc_fdc
        PUBLIC _cpc_fdc

;;------------------------------------

defc ams_fdc_io = $fb7e         ;; I/O address for main status register of NEC765 in Amstrad controller
defc vtx_fdc_io = $fbf6         ;; I/O address for main status register of NEC765 in Vortex controller.

.cpc_fdc
._cpc_fdc

;;------------------------------------
;; detect amstrad floppy disc interface

ld bc,ams_fdc_io
call detect_fdc
jr c,dd1
ld      hl,1    ; Amstrad FDC found
ret
.dd1

;;------------------------------------
;; detect vortex floppy disc interface

ld bc,vtx_fdc_io
call detect_fdc
jr c,dd2
ld hl,2
ret
.dd2
ld hl,0
ret


;;-----------------------------------------------------------------
;; Entry conditions:
;; BC = I/O address for FDC main status register
;;
;; Exit conditions:
;; carry flag set -> not detected
;; carry flag clear -> detected
;;
;; assumes:
;; - I/O port for read data = I/O port for write data
;; - I/O port for read data = I/O port for write data = I/O port for main status register + 1
;; - FDC is not executing a command at this time
;;
;; Attempts to execute a invalid command.

.detect_fdc
;; initialise timeout
ld e,0

.df1
;; read main status register
in a,(c)
;; isolate flags we are interested in
and @11110000
;; test for the following flags:
;; - Data register of FDC is ready for data transfer
;; - Data transfer direction is from CPU->FDC
;; - Not in Execution Mode
;; - FDC not busy
cp @10000000
jr z,df2

;; decrease timeout
dec e
jr nz,df1
;; failed
scf
ret

.df2
;; ok... FDC is ready to accept a command

;;----------------------------------------
;; write the "invalid" command

inc c
;; BC = I/O address of FDC data register

;; code for invalid command
xor a
;; write to FDC data register
out (c),a
dec c
;; BC = I/O address of FDC main status register

;;--------------------------
;; wait for fdc to become busy
ld e,0
.df3
;; read main status register
in a,(c)
and @00010000
jr nz,df4

dec e
jr nz,df3
;; failed
scf
ret

.df4
;; saw fdc become busy

;;--------------------------------
;; wait for execution phase

ld e,0
.df5
in a,(c)
and @11110000
;; test for the following flags:
;; - Data register of FDC is ready for data transfer
;; - Data transfer direction is from CPU->FDC
;; - Not in Execution Mode
;; - FDC busy
cp @11010000
jr z,df6
dec e
jr nz,df5

;; failed
scf
ret

.df6
;; ok saw start of result phase
inc c
;; BC = I/O address of FDC data register

;; read result phase data
in a,(c)

dec c

cp $80
jr nz,df7

;; ok successful
or a
ret

.df7
;; failed
scf
ret

