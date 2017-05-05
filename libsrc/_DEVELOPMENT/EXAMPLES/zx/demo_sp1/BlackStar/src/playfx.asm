SECTION code_user

PUBLIC _playfx

_playfx:

; void playfx(unsigned int fx)
; fastcall linkage

; fastcall linkage means
; hl = fx

   add hl,hl
   
   ld bc,sfxData
   add hl,bc

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ; zsdcc needs ix preserved

   push ix
   
   ; The Z88DK library contains the
   ; beepfx sound effects engine so we'll
   ; just call that.

   ; asm_bit_beepfx:
   ; enter : ix = void *effect
   ; uses  : af, bc, de, hl, bc', de', hl', ix

IFDEF __SDCC_IY

   ; Admittedly this is tricky.
   ; CLIB=SDCC_IY compiles build the library with IX and IY swapped.

   ; So although the library function documents IX as the input parameter,
   ; that has been changed to IY during the library build!

   ; Technically we also do not have to save IX around this call since
   ; instead of using IX it's now using IY which is ok with zsdcc.
   ; But let's keep things as simple as possible since speed here doesn't matter.

   push hl
   pop iy

ELSE

   push hl
   pop ix

ENDIF
   
   di
   
   EXTERN asm_bit_beepfx
   call   asm_bit_beepfx
   
   ei
   
   pop ix
   ret

   
SECTION rodata_user

.sfxData

.SoundEffectsData
   defw SoundEffect0Data
   defw SoundEffect1Data
   defw SoundEffect2Data
   defw SoundEffect3Data
   defw SoundEffect4Data

.SoundEffect0Data
   defb 1 ;tone
   defw 4,600,1000,400,128
   defb 0
.SoundEffect1Data
   defb 2 ;noise
   defw 10,100,128
   defb 0
.SoundEffect2Data
   defb 2 ;noise
   defw 10,400,592
   defb 0
.SoundEffect3Data
   defb 1 ;tone
   defw 4,100,16,64,128
   defb 0
.SoundEffect4Data
   defb 1 ;tone
   defw 10,1000,200,16,64
   defb 1 ;tone
   defw 10,600,200,0,128
   defb 0
