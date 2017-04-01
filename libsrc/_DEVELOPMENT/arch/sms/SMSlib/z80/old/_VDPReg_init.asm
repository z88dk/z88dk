; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION rodata_lib
PUBLIC _VDPReg_init

_VDPReg_init:

   defb 0x04   ; /* reg0: Mode 4 */
   defb 0x20   ; /* reg1: display OFF - frame int (vblank) ON */
   defb 0xFF   ; /* reg2: PNT at 0x3800 */
   defb 0xFF   ; /* reg3: no effect (when in mode 4) */
   defb 0xFF   ; /* reg4: no effect (when in mode 4) */
   defb 0xFF   ; /* reg5: SAT at 0x3F00 */
   defb 0xFF   ; /* reg6: Sprite tiles at 0x2000 */
   defb 0x00   ; /* reg7: backdrop color (zero) */
   defb 0x00   ; /* reg8: scroll X (zero) */
   defb 0x00   ; /* reg9: scroll Y (zero) */
   defb 0xFF   ; /* regA: line interrupt count (offscreen) */
