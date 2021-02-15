;
;	S-OS system variables
;	by Stefano Bodrato, 2020
;
;       $Id: sos_variables.asm $
;

        SECTION   code_clib

PUBLIC _SOS_MXLIN
PUBLIC _SOS_WIDTH
PUBLIC _SOS_DSK  
PUBLIC _SOS_FATPS
PUBLIC _SOS_DIRPS
PUBLIC _SOS_FATBF
PUBLIC _SOS_DTBUF
PUBLIC _SOS_MXTRK
PUBLIC _SOS_DIRNO
PUBLIC _SOS_WKSIZ
PUBLIC _SOS_MEMAX
PUBLIC _SOS_STKAD
PUBLIC _SOS_EXADR
PUBLIC _SOS_DTADR
PUBLIC _SOS_SIZE 
PUBLIC _SOS_IBFAD
PUBLIC _SOS_KBFAD
PUBLIC _SOS_XYADR
PUBLIC _SOS_XADR 
PUBLIC _SOS_YADR 
PUBLIC _SOS_PRCNT
PUBLIC _SOS_LPSW 
PUBLIC _SOS_DVSW 
PUBLIC _SOS_USR  

PUBLIC _SOS_HOT 
PUBLIC _SOS_COLD


DEFVARS $1f5b
{
_SOS_MXLIN  ds.b 1  ; Display size (lines).
_SOS_WIDTH  ds.b 1  ; Display size (columns).
_SOS_DSK    ds.b 1  ; Current device name.
_SOS_FATPS  ds.w 1  ; FAT start position (track / sector).
_SOS_DIRPS  ds.w 1  ; Directory start position (track / sector).
_SOS_FATBF  ds.w 1  ; FAT read buffer PTR (256 bytes long area).
_SOS_DTBUF  ds.w 1  ; Disk read buffer PTR (256 bytes long area).
_SOS_MXTRK  ds.b 1  ; The maximum number of tracks.
_SOS_DIRNO  ds.b 1  ; Current file number.
_SOS_WKSIZ  ds.w 1  ; Size of special work area.
_SOS_MEMAX  ds.w 1  ; User area upper limit (z88dk moves the SP here).
_SOS_STKAD  ds.w 1  ; Initial value of STACK.
_SOS_EXADR  ds.w 1  ; File exec address (program entry point).
_SOS_DTADR  ds.w 1  ; File start address.
_SOS_SIZE   ds.w 1  ; File size.
_SOS_IBFAD  ds.w 1  ; File Control Block position.
_SOS_KBFAD  ds.w 1  ; Keyboard input buffer address.
; ..doesn't this remind the tricks on the Working Storage in COBOL ? :D
_SOS_XYADR  ds.w 0  ; Cursor coordinates.
_SOS_XADR   ds.b 1  
_SOS_YADR   ds.b 1  
_SOS_PRCNT  ds.w 1  ; Number of characters displayed in a new line.
_SOS_LPSW   ds.b 1  ; If non-zero, output also to the printer.
_SOS_DVSW   ds.b 1  ; Tape format.
_SOS_USR    ds.w 1  ; Address to jump to after a cold start.
}

DEFVARS $1ffb
{
_SOS_HOT   ds.w 1	; Hot boot entry
_SOS_FOO   ds.b 1
_SOS_COLD  ds.w 1	; Cold boot entry
}

