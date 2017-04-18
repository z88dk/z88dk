zcc +sms -vn -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 speech.c quotes.c font_8x8_bubble.asm -o speech -pragma-include:zpragma.inc -create-app
