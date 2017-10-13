; This performs a test for the running model (2000 or 4000)
; It is purely based on disassembly...

;SECTION data_clib
;SECTION data_vgl_model
SECTION code_driver

PUBLIC vgl_model_check

defc __VGL_SYSTEM_ARCHITECTURE_0006 = 0x0006
defc __VGL_SYSTEM_ARCHITECTURE_0038 = 0x0038
defc __VGL_SYSTEM_ARCHITECTURE_4000 = 0x4000
defc __VGL_SYSTEM_ARCHITECTURE_801E = 0x801E


vgl_model_check:
   ; Returns 2 for MODEL2000, 3 for MODEL4000
   
   ; checkArchitecture1(): Check 10x byte at [0038 + x*3]. If all are 0xc3 return A=3, else return A=2
   push bc
   push de
   push hl

   ld de, 3h
   ld b, 0ah
   ld hl, __VGL_SYSTEM_ARCHITECTURE_0038
   
   _ca1_loop:
      ld a, (hl)
      cp 0c3h ; check if [HL] == 0xc3 (This is the case for MODEL2000 and MODEL4000)
      jr nz, _ca1_ret2 ; if not: set a:=2 and return
      add hl, de ; increment by 3
   djnz _ca1_loop
   
   ; They have all evaluated to 0xc3
   ld a, 03h ; set a:=3
   jr _ca1_retA
   
   _ca1_ret2:
   ld a, 02h
   
   _ca1_retA:
   pop hl
   pop de
   pop bc
   
   ;ret
   
   ; Store result
   xor h
   ld l, a
   
   
   ; checkArchitecture2(A): call checkArchitecture3_A2/3 accordingly
   push af
   push hl
   ; The next check depends on the previous result (A=2 or A=3)
   cp 02h
   jr z, _ca3A2 ; if a == 2: checkArchitecture3_A2(): Probe CPU and ROM, continue at checkArchitecture5()
   call _ca3A3 ; checkArchitecture3A3(): Set A to ([0x0006] & 0x7f >> 4)
   jr _ca5
   
   
   ; checkArchitecture3_A2(): Probe CPU and ROM, continue at checkArchitecture5()
   _ca3A2:
      call _ca4A2 ; checkArchitecture4_A2(): Probe CPU (out (0x01), 0x01), check [0x4003]: Return A=1 for 0x02 and A=2 for 0x01 else A=that value
      jr _ca5 ; checkArchitecture5(): Probe ROM header, reset if 0x801e <> A
   
   
   ; checkArchitecture3_A3(): Set A to ([0x0006] & 0x7f >> 4)
   _ca3A3:
      ld a, (__VGL_SYSTEM_ARCHITECTURE_0006)
      and 7fh
      srl a
      srl a
      srl a
      srl a
   ret
   
   
   ; checkArchitecture4_A2(): Probe CPU (out (0x01), 0x01), check [0x4003]: Return A=1 for 0x02 and A=2 for 0x01 else A=that value
   _ca4A2:
      push hl
      ld hl, __VGL_SYSTEM_ARCHITECTURE_4000
      ld a, 01h ; out 0x01, 0x01: Get model? language?
      out (01h), a
      push bc
      ld bc, 0003h
      add hl, bc
      pop bc
      ld a, (hl) ; get value at 0x4003
      cp 02h
      jr z, _ca4A2_ret1 ; return 1
      cp 01h
      jr z, _ca4A2_ret2 ; return 2
      jr _ca4A2_retA ; break
      
   _ca4A2_ret1:
      ld a,01h
      jr _ca4A2_retA ; break
      
   _ca4A2_ret2:
      ld a,02h
      
   _ca4A2_retA:
      pop hl
   ret
   
   
   ; checkArchitecture5(): Probe ROM header, reset if 0x801e <> A
   _ca5:
      ld hl, __VGL_SYSTEM_ARCHITECTURE_801E ; This is inside the header at the beginning of the ROM, Right after the PC-PROGCARD-text
      cp (hl)
      jp nz,0000h ; reset if [801e] > 0 (it is in fact 01h)
      pop hl
      pop af
   
   _ca_end:
      ; Store result
      xor h
      ld l, a
   
   ret
