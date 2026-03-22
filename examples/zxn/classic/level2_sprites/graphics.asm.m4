SECTION rodata_user

;; ZX Next Hardware Sprite
;; Sword $E3 is transparent

PUBLIC _gfx_sword

EXTERN __ZXN_RGB332_NEXTOS_BRIGHT_MAGENTA

defc TRAN = __ZXN_RGB332_NEXTOS_BRIGHT_MAGENTA

_gfx_sword:

   defb 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN
   defb 0x04, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN
   defb 0x04, 0xFF, 0xFB, 0xFB, 0xFB, 0xFF, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN
   defb 0x04, 0xFF, 0xFB, 0xF5, 0xF5, 0xFB, 0xFF, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN
   defb 0x04, 0xFF, 0xFB, 0xF5, 0xA8, 0xA8, 0xFB, 0xFF, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN
   defb 0x04, 0xFF, 0xFF, 0xFB, 0xA8, 0x44, 0xA8, 0xFB, 0xFF, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN
   defb 0x04, 0x04, 0x04, 0xFF, 0xFB, 0xA8, 0x44, 0xA8, 0xFB, 0xFF, 0x04, TRAN, TRAN, TRAN, TRAN, TRAN
   defb TRAN, TRAN, TRAN, 0x04, 0xFF, 0xFB, 0xA8, 0x44, 0x44, 0xFB, 0xFF, 0x04, TRAN, 0x04, TRAN, TRAN
   defb TRAN, TRAN, TRAN, TRAN, 0x04, 0xFF, 0xFB, 0x44, 0x44, 0x44, 0xFB, 0xFF, 0x04, 0x4D, 0x04, TRAN
   defb TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0xFF, 0xFB, 0x44, 0x44, 0x44, 0x44, 0xFA, 0x4D, 0x04, TRAN
   defb TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0xFF, 0xFB, 0x44, 0xFF, 0xF5, 0x44, 0x04, TRAN, TRAN
   defb TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0xFF, 0x44, 0xF5, 0xA8, 0x04, TRAN, TRAN, TRAN
   defb TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0xFA, 0x44, 0x04, 0xA8, 0x04, TRAN, TRAN
   defb TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0x4D, 0x4D, 0x04, TRAN, 0x04, 0xF5, 0x04, TRAN
   defb TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0x04, TRAN, TRAN, TRAN, 0x04, 0xFA, 0x04
   defb TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, TRAN, 0x04, 0x04

;; Layer 2 Tile 16x16

PUBLIC _gfx_tile

EXTERN __ZXN_RGB332_ARCADE29_LGRAY
EXTERN __ZXN_RGB332_ARCADE29_BLUEGRAY

pushdef(`O', __ZXN_RGB332_ARCADE29_LGRAY)
pushdef(`W', __ZXN_RGB332_ARCADE29_BLUEGRAY)

_gfx_tile:
   
   defb O,O,O,O,W,W,O,O,O,O,O,O,O,O,O,O
   defb O,O,O,W,O,O,W,O,O,O,O,O,O,O,O,O
   defb O,O,W,O,O,O,O,W,O,O,O,O,O,O,O,O
   defb O,W,O,O,O,O,O,O,W,O,O,O,O,O,O,O
   defb W,O,O,O,O,O,O,O,O,W,O,O,O,O,O,O
   defb O,O,O,O,O,O,O,O,O,O,W,O,O,O,O,W
   defb O,O,O,O,O,O,O,O,O,O,O,W,O,O,W,O
   defb O,O,O,O,O,O,O,O,O,O,O,O,W,W,O,O
   defb O,O,O,O,O,O,O,O,O,O,O,O,W,W,O,O
   defb O,O,O,O,O,O,O,O,O,O,O,W,O,O,W,O
   defb O,O,O,O,O,O,O,O,O,O,W,O,O,O,O,W
   defb W,O,O,O,O,O,O,O,O,W,O,O,O,O,O,O
   defb O,W,O,O,O,O,O,O,W,O,O,O,O,O,O,O
   defb O,O,W,O,O,O,O,W,O,O,O,O,O,O,O,O
   defb O,O,O,W,O,O,W,O,O,O,O,O,O,O,O,O
   defb O,O,O,O,W,W,O,O,O,O,O,O,O,O,O,O

popdef(`O')
popdef(`W')
