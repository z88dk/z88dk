; void tm_from_dostm(struct tm *,struct dos_tm *)

IF !__CPU_INTEL__
SECTION code_time

PUBLIC asm_tm_from_dostm

asm_tm_from_dostm:

   ; enter : de = struct tm *
   ;         hl = struct dos_tm *
   ;
   ; uses  : af, bc, de, hl
   
   ld a,(hl)
   and $1f
   add a,a                     ; a = dos.seconds
   
   ld (de),a                   ; tm_sec
   inc de
   
   ld c,(hl)
   inc hl
   ld a,(hl)
   rra
   rr c
   rra
   rr c
   rra
   rr c
   ld b,a
   ld a,c
   rra
   rra
   and $3f                     ; a = dos.minute
   
   ld (de),a                   ; tm_min
   inc de
   
   ld a,b
   and $1f                     ; a = dos.hour
   
   ld (de),a                   ; tm_hour
   inc de
   
   inc hl
   ld a,(hl)
   and $1f                     ; a = dos.day
   
   ld (de),a                   ; tm_mday
   inc de
   
   inc hl
   ld a,(hl)
   rra
   ld c,a                      ; c = dos.year offset from 1980
   dec hl
   ld a,(hl)
   rla
   rla
   rla
   rla
   and $0f                     ; a = dos.month

   jr z, no_adjust_month
   dec a

no_adjust_month:

   ld (de),a                   ; tm_mon
   inc de
   
   ld a,80
   add a,c
   ld (de),a                   ; tm_year offset from 1900
   inc de
   sbc a,a
   and $01
   ld (de),a
   inc de
   
   ; de = &tm.wday
   ; place -1 in rest of structure
   
   ld a,255
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a
   inc de
   ld (de),a

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
