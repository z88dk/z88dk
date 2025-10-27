; int compare_dostm(struct dos_tm *a, struct dos_tm *b)

IF !__CPU_INTEL__
SECTION code_time

PUBLIC asm_compare_dostm

EXTERN error_mc, error_onc

asm_compare_dostm:

   ; enter : hl = struct dos_tm *a
   ;         bc = struct dos_tm *b
   ;
   ; exit  : if a < b : hl = -1, carry set
   ;         if a = b : hl =  0, carry reset, z set
   ;         if a > b : hl =  1, carry reset, nz set
   ;
   ; uses  : af, bc, de, hl
   
   inc hl
   inc hl
   inc hl
   
   inc bc
   inc bc
   inc bc

   ; year
   
   ld a,(bc)
   and $fe
   ld e,a                      ; e = year b
   
   ld a,(hl)
   and $fe                     ; a = year a
   
   cp e                        ; year a - year b
   
   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ; month
   
   ld a,(bc)
   rra
   dec bc
   ld a,(bc)
   rra
   and $f0
   ld e,a                      ; e = month b
   
   ld a,(hl)
   rra
   dec hl
   ld a,(hl)
   rra
   and $f0                     ; a = month a
   
   cp e                        ; month a - month b
   
   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ; day
   
   ld a,(bc)
   and $1f
   ld e,a                      ; e = day b
   
   ld a,(hl)
   and $1f                     ; a = day a
   
   cp e                        ; day a - day b

   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ; hours
   
   dec bc
   ld a,(bc)
   and $f8
   ld e,a                      ; e = hours b
   
   dec hl
   ld a,(hl)
   and $f8                     ; a = hours a
   
   cp e                        ; hours a - hours b
   
   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ; mins
   
   ld a,(bc)
   ld e,a
   dec bc
   ld a,(bc)
   rr e
   rra
   rr e
   rra
   rr e
   rra
   and $fc
   ld e,a                      ; e = mins b
   
   ld d,(hl)
   dec hl
   ld a,(hl)
   rr d
   rra
   rr d
   rra
   rr d
   rra
   and $fc                     ; a = mins a
   
   cp e

   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ; secs
   
   ld a,(bc)
   and $1f
   ld e,a                      ; e = secs b
   
   ld a,(hl)
   and $1f                     ; a = secs a
   
   sub b                       ; secs a - secs b
   
   jp c, error_mc              ; return with hl = -1
   jp nz, error_onc            ; return with hl = 1
   
   ld l,a
   ld h,a                      ; return with hl = 0
   
   ret

; msdos time
;
;   bits 15.11  hour (0-23)
;   bits 10..5  minute (0-59)
;   bits  4..0  seconds divided by two
;
; msdos date
;
;   bits 15..9  year offset from 1980
;   bits  8..5  month (1 = Jan)
;   bits  4..0  day (1-31)
ENDIF
