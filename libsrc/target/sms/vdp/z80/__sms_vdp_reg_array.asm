INCLUDE "config_private.inc"

SECTION rodata_arch

PUBLIC __sms_vdp_reg_array

__sms_vdp_reg_array:

   defb __SMS_VDP_R0           ; /* reg0: Mode 4 */
   defb __SMS_VDP_R1           ; /* reg1: display OFF - frame int (vblank) ON */
   defb ((__SMSLIB_PNTADDRESS & 0x3800) >> 10) + 0xf1                     ; /* reg2: PNT at 0x3800 */
   defb 0xFF                   ; /* reg3: no effect (when in mode 4) */
   defb 0xFF                   ; /* reg4: no effect (when in mode 4) */
   defb ((__SMSLIB_SATADDRESS & 0x3f00) >> 7) + 0x81                      ; /* reg5: SAT at 0x3F00 */
   defb ((__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS & 0x2000) >> 11) + 0xfb  ; /* reg6: Sprite tiles at 0x2000 */
   defb 0x00                   ; /* reg7: backdrop color (zero) */
   defb 0x00                   ; /* reg8: scroll X (zero) */
   defb 0x00                   ; /* reg9: scroll Y (zero) */
   defb 0xFF                   ; /* regA: line interrupt count (offscreen) */
