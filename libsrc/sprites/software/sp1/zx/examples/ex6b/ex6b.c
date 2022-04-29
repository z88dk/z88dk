
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

#include <arch/zx/sprites/sp1.h>
#include <input.h>
#include <spectrum.h>
#include <intrinsic.h>

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

// background UDG graphics

uchar hash [] = {0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};
uchar grass[] = {251, 255, 191, 255, 255, 253, 223, 255};

// attach C variable to tile graphics defined in separate asm file

extern uchar gr_tiles[];       // gr_tiles will hold the address of the asm label _gr_tiles

// program global variables

struct sp1_Rect cr = {0, 0, 32, 24};             // rectangle covering the full screen
struct sp1_pss ps0;                              // context for sp1_PrintString

main()
{
   uchar *temp;
   uchar i;
   
   intrinsic_di();

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
