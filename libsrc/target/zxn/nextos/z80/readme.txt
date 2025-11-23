Code here will automatically change the banking configuration to
ROM2 in bottom 16k, BANK 7 in top 16k and BANK 5 in mmu2
to run NextOS API calls and then restore the banking configuration
before return.

NextOS will enable interrupts while running so you have to make
sure your interrupt routine is available or change to im1 mode
prior to calling.  You can di;im1 to ensure ROM2 is in place before
interrupts are enabled.  The calls here will preserve di/ei status
so on return the di/ei state will be the same as when called.

divmmc memory, port 123b, interrupts, display mode


Two consecutive words, or a longword, YYYYYYYMMMMDDDDD hhhhhmmmmmmsssss

YYYYYYY is years from 1980 = 0
sssss is (seconds/2).

3658 = 0011 0110 0101 1000 = 0011011 0010 11000 = 27 2 24 = 2007-02-24
7423 = 0111 0100 0010 0011 - 01110 100001 00011 = 14 33 2 =   14:33:06
