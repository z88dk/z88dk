
;
;  Apple II Z80 SoftCard
;
;  Stefano, 2025
;
;  Invoke the Rockwell 6502
;
;-----------------------------------------------------------------------------
;
;	$Id: asm_z80_delay_ms.asm $
;
; ===============================================================
;
; void z80_delay_ms(uint ms)
;
; Busy wait HL milliseconds
; The precision is not perfect 
;
; ===============================================================


SECTION code_clib
SECTION code_z80

EXTERN r6502

PUBLIC asm_z80_delay_ms
PUBLIC asm_cpu_delay_ms


asm_z80_delay_ms:
asm_cpu_delay_ms:

   ; enter : hl = milliseconds (0 = 65536)
   ;
   ; uses  : af, bc, de, hl

   ld e,l
   ld d,h

                 

ms_loop:
   
   ld a,d
   or e
   ret z
   dec de

   ld a,13       ; given tha below expression, it will wait for 1001 microsecond
                 ; reducing A to 12 would wait for 865 microsecond
   ld ($F045),a  ; 6502 accumulator
   ld hl,$FCA8   ; Wait 13+(11*A)+(5*A*A) microseconds
   call r6502    ; the 6502 CPU will use the location in HL

   jr ms_loop

