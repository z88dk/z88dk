
///////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #6b
// 03.2008 aralbrec
//
// sp1_PrintString() is intended as a means to print the graphics
// for an entire screen from a compressed string.  The compression
// is achieved by making use of special commands embedded in the
// string used to print a screen.
//
// The commands understood by sp1_PrintString() are listed in the
// file sp1/spectrum/tiles/SP1PRINTSTRING.asm or they can be viewed
// online (lines 17-50):
// http://z88dk.cvs.sourceforge.net/z88dk/z88dk/libsrc/sprites/
// software/sp1/spectrum/tiles/SP1PrintString.asm?view=markup
//
// Any ascii code 32 or larger is interpretted by sp1_PrintString
// as a character to be printed; anything less is interpretted
// as a command as documented in the list above.
//
// In this program several small strings are created that
// print a fan, a tree and two frames of the fan's blade
// animation.  The entire screen is stored in the "scene"
// string which contains "subroutine calls" to print the
// fan and tree using code 7.  Other codes buried in these
// strings move the cursor around, set colour and implement
// repeat loops.
//
// The fan, tree and blade strings are created as standard C
// strings.  C strings allow specific bytes to be embedded if
// they are specified using hexadecimal notation '\xHH' where
// HH = single byte hex value.  This makes them a little difficult
// to read.  However, the full screen string "scene" must be
// defined in assembler since it "calls" the fan,tree strings
// as subroutines to draw fans and trees at various spots on
// screen.  This is done by embedding code '7' followed by the
// 2-byte memory address where those subroutine strings are
// located.  C strings provide no means to embed memory addresses
// so the "scene" string is defined in assembler.  The assembler
// lists the string as a sequence of decimal bytes which is
// much easier to read.
//
// The graphics used by the program are UDG graphics
// associated with character codes 128-152 (see the end of this
// listing).  The association between character code and UDG
// graphic definition is made with calls to sp1_TileArray() from
// inside a loop.
//
// When using sp1_PrintString(), an initialized "struct ps1_pss"
// must be passed to it.  Normally this means initializing the
// bounds member with a bounding rectangle, the flags member,
// the attr_mask, the visit function (not discussed yet - set to 0),
// and the print position (x,y) through a call to sp1_SetPrintPos().
// Some of these initializations can be performed by embedded
// commands in the print string itself.  Eg, if a command causes
// the print position to be moved to an absolute position on
// screen before anything is printed, there is no need to
// initialize it before the sp1_PrintString() call.  However,
// printing something without an initialized print position
// could cause a program crash so take care!
//
// Once the screen has been printed, an eternal loop is entered
// where the fan blades of the three onscreen fans are animated
// between two blade frames.  sp1_PrintString() is not really
// intended for this purpose as it is a relatively slow function
// and should only be used outside the main game loop.  We will
// be taking a look at background animations later on where
// we will discuss several better approaches using functions like
// sp1_PutTiles(), sp1_IterateUpdateRect() and sp1_IterateUpdateArr()
// and we will look at controlling animation rates using the
// 50/60Hz frame interrupt.
//
///////////////////////////////////////////////////////////////
//
// ALL GRAPHICS BY REDBALLOON AT WWW.WORLDOFSPECTRUM.ORG/FORUMS
// zcc +zx -vn ex6b.c -o ex6b.bin -create-app -lsp1

#include <input.h>
#include <sprites/sp1.h>
#include <spectrum.h>

#pragma output STACKPTR=53248                    // place stack at $d000 at startup

// printstrings for fanblade, two frames of blade animation, and the tree

uchar blade0[] = "\x04\xff\x14\x00\x99\x9a\x9b\x17\x01\xfd\x9c\x9d\x9e";
uchar blade1[] = "\x04\xff\x14\x00\x9f\xa0\xa1\x17\x01\xfd\xa2\xa3\xa4";

uchar fan[] = "\x04\x00\x14\x46\x98\x98\x98\x98\x98\x98\x98\x17\x01\xf9" \
              "\x98\x14\x47\x80\x14\x07\x81\x82\x14\x47\x83\x14\x46\x84\x98\x17\x01\xf9" \
              "\x98\x14\x47\x85\x14\x07\x86\x87\x14\x47\x88\x14\x45\x84\x14\x46\x98\x17\x01\xf9" \
              "\x98\x14\x47\x8a\x8b\x8c\x14\x45\x8d\x14\x05\x8e\x14\x46\x98\x17\x01\xf9" \
              "\x98\x14\x47\x8f\x14\x07\x99\x14\x47\x9a\x14\x07\x9b\x14\x05\x90\x14\x46\x98\x17\x01\xf9" \
              "\x98\x14\x47\x91\x14\x07\x9c\x14\x47\x9d\x14\x07\x9e\x14\x05\x92\x14\x46\x98\x17\x01\xf9" \
              "\x98\x93\x94\x95\x96\x97\x98\x17\x01\xf9" \
              "\x98\x98\x98\x98\x98\x98\x98";

uchar tree[] = "\x04\x00\x14\x44" \
               "\xa5\xa6\xa7\xa8\x17\x01\xfc" \
               "\xa9\xaa\xab\xac\x17\x01\xfc" \
               "\xad\xae\xaf\xb0\x17\x01\xfc" \
               "\xb1\xb2\xb3\xb4\x17\x01\xfc" \
               "\xb5\xb6\xb7\xb8";

uchar credit[] = "\x04\x00\x14\x07graphics.by.redballoon";

// string for drawing the screen
// must be defined in asm since there is no C mechanism to bury
// addresses inside a string, which is needed here to print the fan
// and tree "subroutine" strings

extern uchar scene[];
#asm

._scene                        ; C variable "scene" will hold this address

   defb 22, 0, 10              ; set coords to (0,10)
   defb 7                      ; print credit
   defw _credit

   defb 22, 2, 1               ; set coords to (2,1)
   defb 7                      ; print fan
   defw _fan
   
   defb 22, 5, 23              ; set coords to (5,23)
   defb 7                      ; print fan
   defw _fan
   
   defb 22, 16, 6              ; set coords to (16,6)
   defb 7                      ; print fan
   defw _fan
   
   defb 20, $44                ; set attr to bright green on black
   
   defb 22, 15, 1              ; set coords to (15,1)
   defb 14, 9                  ; repeat 9 times (row loop)
   defb 14, 4                  ; repeat 4 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -4              ; move cursor one char down, four chars left
   defb 15                     ; end row loop

   defb 22, 11, 1              ; set coords to (11,1)
   defb 14, 4                  ; repeat 4 times (row loop)
   defb 14, 21                 ; repeat 21 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -21             ; move cursor one char down, 21 chars left
   defb 15                     ; end row loop

   defb 22, 2, 9               ; set coords to (2,9)
   defb 14, 9                  ; repeat 9 times (row loop)
   defb 14, 13                 ; repeat 13 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -13             ; move cursor one char down, 13 chars left
   defb 15                     ; end row loop
 
   defb 22, 14, 22             ; set coords to (14,22)
   defb 14, 9                  ; repeat 9 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop

   defb 22, 15, 14             ; set coords to (15,14)
   defb 14, 9                  ; repeat 9 times (row loop)
   defb 14, 17                 ; repeat 17 times (col loop)
   defb '#'                    ; grass char
   defb 15                     ; end col loop
   defb 23, 1, -17             ; move cursor one char down, 17 chars left
   defb 15                     ; end row loop

   defb 22, 18, 17             ; set coords to (18,17)
   defb 7                      ; print tree
   defw _tree
   
   defb 22, 19, 25             ; set coords to (19,25)
   defb 7                      ; print tree
   defw _tree
   
   defb 22, 3, 10
   defb 14, 3                  ; repeat 3 times (row loop)
   defb 14, 3                  ; repeat 3 times (col loop)
   defb 26                     ; save cursor position
   defb 7                      ; print tree
   defw _tree
   defb 28                     ; restore cursor position
   defb 9, 9, 9, 9             ; move cursor to the right 4 chars
   defb 15                     ; end col loop
   defb 23, 3, -12             ; move cursor down 3 chars, left 12 chars
   defb 15                     ; end row loop

   defb 0                      ; end string
   
#endasm

// background UDG graphics

uchar hash [] = {0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};
uchar grass[] = {251, 255, 191, 255, 255, 253, 223, 255};

// attach C variable to tile graphics defined in asm at end of file

extern uchar gr_tiles[];       // gr_tiles will hold the address of the asm label _gr_tiles

// program global variables

struct sp1_Rect cr = {0, 0, 32, 24};             // rectangle covering the full screen
struct sp1_pss ps0;                              // context for sp1_PrintString

main()
{
   uchar *temp;
   uchar i;
   
   #asm
   di
   #endasm

   // initialize SP1.LIB
   
   zx_border(INK_BLACK);
   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, INK_BLACK | PAPER_WHITE, ' ');
   sp1_TileEntry(' ', hash);    // redefine graphic associated with space character
   sp1_TileEntry('#', grass);   // redefine graphic associated with # character

   sp1_Invalidate(&cr);
   sp1_UpdateNow();

   // define tile graphics for codes 128 through 184
   
   temp = gr_tiles;
   for (i=128; i!=185; ++i, temp+=8)
      sp1_TileEntry(i, temp);
   
   // initialize print string struct
   // colour and print position information embedded in the print codes in the string

   ps0.bounds    = &cr;                       // bounding rectangle = full screen
   ps0.flags     = SP1_PSSFLAG_INVALIDATE;    // invalidate chars printed to
   ps0.visit     = 0;                         // not using this feature yet, 0 = safe

   sp1_PrintString(&ps0, scene);   // print the screen
   sp1_UpdateNow();                // draw screen now

   while (1)
   {
      in_Wait(62);             // wait 62 ms
      
      sp1_SetPrintPos(&ps0, 6, 3);
      sp1_PrintString(&ps0, blade1);
      
      sp1_SetPrintPos(&ps0, 9, 25);
      sp1_PrintString(&ps0, blade1);

      sp1_SetPrintPos(&ps0, 20, 8);
      sp1_PrintString(&ps0, blade1);

      sp1_UpdateNow();
      
      in_Wait(62);             // wait 62 ms

      sp1_SetPrintPos(&ps0, 6, 3);
      sp1_PrintString(&ps0, blade0);
      
      sp1_SetPrintPos(&ps0, 9, 25);
      sp1_PrintString(&ps0, blade0);

      sp1_SetPrintPos(&ps0, 20, 8);
      sp1_PrintString(&ps0, blade0);

      sp1_UpdateNow();
   }
}

#asm

._gr_tiles

; fan graphic
; width = 5 chars, height = 6 chars
; character codes 128 through 152

	DEFB	$E0,$CF,$BF,$BE,$63,$4F,$5F,$7E
	DEFB	$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB	$03,$50,$F8,$FD,$FE,$FD,$FE,$FF
	DEFB	$EF,$17,$43,$E8,$FD,$FE,$FF,$FF
	DEFB	$EF,$F7,$F7,$FB,$3B,$98,$C7,$E7
	
	DEFB	$63,$4F,$5F,$7E,$63,$4F,$5F,$7F
	DEFB	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DEFB	$FE,$FF,$FE,$FF,$FE,$FF,$FF,$FF
	DEFB	$FF,$FF,$FF,$FF,$AB,$81,$F0,$FC
	DEFB	$D3,$E1,$F1,$E8,$F0,$78,$54,$38
	
	DEFB	$7F,$7E,$7F,$7F,$7F,$7F,$7F,$7F
	DEFB	$F6,$FF,$FF,$FF,$FF,$FF,$FF,$FD
	DEFB	$AA,$FF,$FF,$FF,$FF,$FF,$FF,$55
	DEFB	$FF,$AF,$F5,$FA,$FF,$F6,$FF,$7E
	DEFB	$14,$C8,$E4,$A0,$54,$88,$C2,$A0
	
	DEFB	$7F,$7F,$7F,$7F,$7E,$7D,$7E,$7C
	DEFB	$C0,$D0,$68,$D0,$A8,$D4,$60,$54
	
	DEFB	$7E,$7C,$7E,$7F,$7E,$7F,$3F,$BF
	DEFB	$68,$50,$E8,$D4,$A0,$10,$A8,$41
	
	DEFB	$8B,$C5,$E0,$F8,$FB,$F8,$37,$CF
	DEFB	$FE,$55,$00,$00,$FB,$F8,$37,$CF
	DEFB	$AA,$55,$00,$00,$FB,$F8,$37,$CF
	DEFB	$AA,$54,$00,$00,$FB,$F8,$37,$CF
	DEFB	$91,$03,$07,$1B,$FB,$F8,$37,$CF

	DEFB	$EF,$F7,$F7,$FB,$FB,$F8,$37,$CF

; fan blade graphic frame 0/1
; width = 3 chars, height = 2 chars
; character codes 153 through 158

	DEFB	$EA,$D0,$00,$44,$02,$00,$03,$0F
	DEFB	$00,$55,$FE,$FF,$FE,$FF,$FF,$C3
	DEFB	$AB,$06,$03,$21,$00,$28,$C4,$F2

	DEFB	$3F,$3F,$3F,$1F,$87,$40,$D0,$F5
	DEFB	$91,$D3,$FF,$E7,$91,$2A,$14,$00
	DEFB	$FD,$FD,$FC,$FA,$E5,$13,$06,$5D

; fan blade graphic frame 1/1
; width = 3 chars, height = 2 chars
; character codes 159 through 164

	DEFB	234,208,  2, 85, 47, 31, 47, 15
	DEFB	  0,  0,128,229,255,255,255,195
	DEFB	171, 14,163, 81,248,252,248,242
	
	DEFB	  3,  0, 10,  0,130, 65,208,245
	DEFB	137,203,255,255,255,126,  0,  0
	DEFB	197, 42, 86, 62, 85,179,  6, 93	
	
; tree graphic
; width = 4 chars, height = 5 chars
; character codes 165 through 184

defb 251, 255, 190, 253, 251, 247, 207, 239  ; char block [0, 0]
defb 240, 134, 122, 239, 253, 252, 183, 127  ; char block [1, 0]
defb  15, 129,  80,   4,  64,  32, 132, 136  ; char block [2, 0]
defb 251, 255,  63,  63,  31,  13,  71, 135  ; char block [3, 0]

defb 223, 223, 159, 191, 191, 191, 191, 191  ; char block [0, 1]
defb 251, 124, 255, 251, 127, 255, 190, 219  ; char block [1, 1]
defb   4,  32,  85, 234, 176, 234, 208, 164  ; char block [2, 1]
defb  19,  35,   3,  41,   1,  33,  67, 169  ; char block [3, 1]

defb 127, 127, 127, 111, 127, 127, 123, 191  ; char block [0, 2]
defb 238, 249, 255, 255, 254, 255, 255, 251  ; char block [1, 2]
defb  16,   6, 109, 214, 253, 251, 222, 245  ; char block [2, 2]
defb  16, 160,  80, 128,  68, 128, 132,  17  ; char block [3, 2]

defb 158, 191, 159, 207, 229, 242, 216, 251  ; char block [0, 3]
defb 255, 173, 240, 108, 250, 127,  42,   1  ; char block [1, 3]
defb 250,  97,   2,  87, 252,  84, 160,   0  ; char block [2, 3]
defb   1,  81, 163,  67, 135,  13,  63, 159  ; char block [3, 3]

defb 250, 252, 191, 255, 255, 253, 223, 255  ; char block [0, 4]
defb 208, 125, 168, 147, 199, 253, 223, 255  ; char block [1, 4]
defb   4, 114, 160,  73, 159, 253, 223, 255  ; char block [2, 4]
defb  27,  63, 191, 255, 255, 253, 223, 255  ; char block [3, 4]

#endasm
