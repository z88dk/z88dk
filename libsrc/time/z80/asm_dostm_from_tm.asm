; void dostm_from_tm(struct dos_tm *,struct tm *)

IF !__CPU_INTEL__
SECTION code_time

PUBLIC asm_dostm_from_tm

asm_dostm_from_tm:

   ; enter : hl = struct dos_tm *
   ;         de = struct tm *
   ;
   ; uses  : af, bc, de, hl

   ld a,(de)                   ; tm_sec
   inc de
   
   srl a
   ld (hl),a                   ; dos.seconds
   
   ld a,(de)                   ; tm_min
   inc de
   
   rrca
   rrca
   rrca
   ld c,a
   and $e0
   or (hl)
   ld (hl),a                   ; dos.minute low part
   inc hl
   
   ld a,c
   and $07
   ld (hl),a                   ; dos.minute high part
   
   ld a,(de)                   ; tm_hour
   inc de
   
   add a,a
   add a,a
   add a,a
   or (hl)
   ld (hl),a                   ; dos.hour
   inc hl
   
   ld a,(de)                   ; tm_mday
   inc de
   
   and $1f
   ld (hl),a                   ; dos.day
   
   ld a,(de)                   ; tm_mon
   inc a
   inc de
   
   rrca
   rrca
   rrca
   ld c,a
   and $e0
   or (hl)
   ld (hl),a                  ; dos.month low part
   inc hl
   ld a,c
   and $01
   ld (hl),a                  ; dos.month high part
   
   ld a,(de)                  ; tm_year offset from 1900
   sub 80
   add a,a
   or (hl)
   ld (hl),a                  ; dos.year offset from 1980
   
   ret


; msdos date
;
;   bits 15..9  year offset from 1980
;   bits  8..5  month (1 = Jan)
;   bits  4..0  day (1-31)
;
; msdos time
;
;   bits 15.11  hour (0-23)
;   bits 10..5  minute (0-59)
;   bits  4..0  seconds divided by two
ENDIF
