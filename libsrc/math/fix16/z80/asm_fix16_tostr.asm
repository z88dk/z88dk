;
; Z80 fixed Q8.8 maths routines
;
; These routines have been adapted from two sources:
;
; https://github.com/Zeda/Z80-Optimized-Routines/tree/master/math
;
; With the following licence:
;
; 1. This License does not apply to any file with a separate License header.
; 2. Permission is granted, free of charge, to use, modify, and/or distribute any part of this software for any purpose.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
; WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
; COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
;
; Written by Zeda Thomas zedae.z80@gmail.com, Aug 2019


    SECTION code_math
    PUBLIC  asm_fix16_tostr
    EXTERN  asm_fix16_itoa8


;Written by Zeda.
;This converts a fixed-point number to a string.
;It displays up to 3 digits after the decimal.

asm_fix16_tostr:
fixed88_to_str:
;Inputs:
;   D.E is the fixed-point number
;   HL points to where the string gets output.
;      Needs at most 9 bytes.
;Outputs:
;   HL is preserved
;Destroys:
;   AF,DE,BC

;First check if the input is negative.
;If so, write a negative sign and negate
  push hl
  ld a,d
  or a
  jp p,l0
  ld (hl),$1A      ;negative sign on TI-OS
  inc hl
  xor a
  sub e
  ld e,a
  sbc a,a
  sub d
l0:

;Our adjusted number is in A.E
;Now we can print the integer part
  call asm_fix16_itoa8

;Check if we need to print the fractional part
  xor a
  cp e
  jr z,fixed88_to_str_end

;We need to write the fractional part, so seek the end of the string
;Search for the null byte. A is already 0
  cpir

;Write a decimal
  dec hl
  ld (hl),'.'

  ld b,3
l1:
;Multiply E by 10, converting overflow to an ASCII digit
  call fixed88_to_str_e_times_10
  inc hl
  ld (hl),a
  djnz l1

;Strip the ending zeros
  ld a,'0'
l2:
  cp (hl)
  dec hl
  jr z,l2

;write a null byte
  inc hl
  inc hl
  ld (hl),0

fixed88_to_str_end:
;restore HL
  pop hl
  ret

fixed88_to_str_e_times_10:
  ld a,e
  ld d,0
  add a,a
  rl d
  add a,a
  rl d
  add a,e
  jr nc,$+3
  inc d
  add a,a
  ld e,a
  ld a,d
  rla
  add a,'0'
  ret
