;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_soundcopy_callee(char *dst, char *src, int size, int sound1, int sound2);

SECTION code_clib
PUBLIC vz_soundcopy_callee
PUBLIC _vz_soundcopy_callee
PUBLIC ASMDISP_VZ_SOUNDCOPY_CALLEE
EXTERN _std_seed

.vz_soundcopy_callee
._vz_soundcopy_callee

   pop af
   pop bc
   pop de
   ld b,e
   
   exx
   
   pop bc
   pop hl
   pop de
   
   push af
   exx
   
   ; bc' = int size
   ; hl' = char *src
   ; de' = char *dst
   ; c   = sound 2
   ; b   = sound 1

.asmentry

   ld e,c
   ld d,b
   ld hl,(_std_seed)

   ld a,b
   or c                      ; both off?
   exx
   ld a,($783b)              ; get latch data
   jp nz, soundcopy1         ; sound is on

   ldir
   ret

.soundcopy1

   exx
   inc d                     ; tone ?
   dec d
   jr z, soundcopy2          ; nope, skip
   dec d                     ; counted down?
   jr nz, soundcopy2         ; nope
   ld d,b                    ; reset counter
   xor $21                   ; toggle output
   ld ($6800),a

.soundcopy2

   inc e                     ; noise ?
   dec e
   jr z, soundcopy3          ; nope, skip
   dec e                     ; counted down?
   jr nz, soundcopy3         ; nope
   ld e,c                    ; reset counter
   add hl,hl                 ; rotate 16 random bits
   jr nc, soundcopy3         ; not set
   inc l                     ; set bit 0 agaon
   xor $21                   ; toggle output
   ld ($6800),a

.soundcopy3

   exx
   ldi                       ; transfer 4 bytes
   ldi
   ldi
   ldi
   jp pe, soundcopy1         ; until done
   ld ($783b),a

   ret

DEFC ASMDISP_VZ_SOUNDCOPY_CALLEE = # asmentry - vz_soundcopy_callee
