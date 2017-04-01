; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_addSpriteClipping

EXTERN asm_SMSlib_addSprite_0
EXTERN error_mc, error_zc

EXTERN _clipWin_x0, _clipWin_x1, _clipWin_y0, _clipWin_y1
EXTERN _SpriteNextFree, _spritesWidth, _spritesHeight
EXTERN _SpriteTableY, _SpriteTableXN

asm_SMSlib_addSpriteClipping:

   ; int SMS_addSpriteClipping (int x, int y, unsigned char tile)
   ;
   ; enter :   h = unsigned char tile
   ;          bc = int x
   ;          de = int y
   ; 
   ; exit  : success
   ;
   ;            hl = sprite #
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1 (too many sprites), 0 (clipped)
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   ld a,(_SpriteNextFree)
   
   cp MAXSPRITES
   jp nc, error_mc
   
   ld l,a
   push hl
	
	; bc = x
	; de = y
	; stack = tile | SpriteNextFree

check_x:

	; if ((x>clipWin_x1) || (x<((int)(clipWin_x0)-(int)(spritesWidth))))

first_part_x:

	bit 7,b
	jr nz, second_part_x

	inc b
	dec b
	jp nz, error_mc - 1
	
	ld a,(_clipWin_x1)
	cp c
	jp c, error_mc - 1

second_part_x:

	ld a,(_clipWin_x0)
	ld hl,(_spritesWidth)
	
	sub l
	ld l,a
	sbc a,a
   
	add a,$80
	ld h,a
	
	ld a,b
	add a,$80
	
	cp h
	jr nz, decision_x
	
	ld a,c
	cp l
	
decision_x:

   jp c, error_mc - 1
	
check_y:

	; if ((y>clipWin_y1) || (y<((int)(clipWin_y0)-(int)(spritesHeight))))
	
first_part_y:

	bit 7,d
	jr nz, second_part_y

	inc d
	dec d
	jp nz, error_mc - 1
	
	ld a,(_clipWin_y1)
	cp e
	jp c, error_mc - 1

second_part_y:
	
	ld a,(_clipWin_y0)
	ld hl,(_spritesHeight)
	
	sub l
	ld l,a
	sbc a,a
   
	add a,$80
	ld h,a
	
	ld a,d
	add a,$80
	
	cp h
	jr nz, decision_y
	
	ld a,e
	cp l
	
decision_y:

   jp c, error_mc - 1
	
	; bc = x
	; de = y
	; stack = tile | SpriteNextFree

	pop hl
	ld b,h
	ld h,e
	
	ex de,hl
	jp asm_SMS_addSprite_0
