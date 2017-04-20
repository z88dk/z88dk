Space Hawks by KanedaFr
http://www.smspower.org/Homebrew/SpaceHawks-SMS
https://bitbucket.org/SpritesMind/spacehawks_sms/downloads/?tab=branches

sccz80 compile:
// unable to compile due to multidimensional array
// zcc +sms -v -startup=16 -clib=new -O3 @zproject-sms.lst -o spacehawks -create-app -pragma-include:zpragma.inc

zsdcc compile:
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 @zproject-sms.lst -o spacehawks -create-app -pragma-include:zpragma.inc
