
/////////////////////////////////////////////////////////////
// EXAMPLE PROGRAM #6a
// 03.2008 aralbrec
//
// Thus far we've been printing background tiles one character
// at a time using functions like sp1_PrintAt and also by poking
// ascii codes and colour to individual "struct sp1_update"s
// directly.  Although we didn't see it used this way,
// sp1_ClearRectInv and sp1_ClearRect can also be used to print
// a single ascii char to each character inside a rectangle.
//
// This example introduces the sp1_PrintString() function
// that can print an entire string at a time.  sp1_PrintString
// is a sophisticated function that can interpret commands
// embedded in the string, as we will see in upcoming examples.
// The immediate purpose of this program is to introduce the
// "struct sp1_pss" which holds a print string context
// for sp1_PrintString.  When sp1_PrintString() is called,
// a "struct sp1_pss" is supplied which provides sp1_PrintString
// with a current cursor position, current text colour and
// current bounding rectangle among other things.  When
// sp1_PrintString finishes printing a string, its state is
// saved in the "struct sp1_pss" supplied.  This way the next
// time the "struct sp1_pss" is used, printing can continue
// from where it left off.
//
// Four independent "struct sp1_pss"s are created, each in
// possession of four different print windows, defined by
// their bounding rectangles.  sp1_PrintString will only
// print characters that lie inside the bounding rectangle
// passed to it inside the "struct sp1_pss".  The SP1_PSSFLAGs
// are investigated by setting different combinations of them
// in the "struct sp1_pss" used in each of the four windows.
//
// SP1_PSSFLAG_XWRAP causes the horizontal cursor position to
// wrap to the left edge of the bounding rectangle when
// the cursor moves off the right edge of the rectangle.
//
// SP1_PSSFLAG_YINC causes the vertical cursor coordinate to
// increase when the XWRAP occurs.
//
// SP1_PSSFLAG_YWRAP causes the vertical cursor position to
// wrap to the top edge of the bounding rectangle when
// the cursor moves off the bottom of the rectangle.
//
// In the four combinations of these flags tested, the same
// text is printed to see the effect.
/////////////////////////////////////////////////////////////

// zcc +zx -vn ex6a.c -o ex6a.bin -create-app -lsp1

#include <sprites/sp1.h>
#include <spectrum.h>

#pragma output STACKPTR=53248                    // place stack at $d000 at startup

// Full Screen Rectangle

struct sp1_Rect cr = {0, 0, 32, 24};             // rectangle covering the full screen

// Bounding Rectangles for the Four Independent Print Windows

struct sp1_Rect br1 = {1,  2, 6, 22};
struct sp1_Rect br2 = {1,  9, 6, 22};
struct sp1_Rect br3 = {1, 16, 6, 22};
struct sp1_Rect br4 = {1, 23, 6, 22};

// UDG Definitions for Background Characters

uchar hash[] = {0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};    // background hash

// Four PrintString Contexts

struct sp1_pss ps1;
struct sp1_pss ps2;
struct sp1_pss ps3;
struct sp1_pss ps4;

// The Text

char text1[] = "With the possible exception of Isaac Newton, Euclid is the best known mathematician of all time.";
char text2[] = "  Until sometime in the =>";

main()
{

   #asm
   di
   #endasm

   // Initialize SP1.LIB
   
   zx_border(INK_BLACK);
   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, INK_BLACK | PAPER_WHITE, '#');
   sp1_TileEntry('#', hash);     // redefine graphic associated with # character

   // Colour the Four Print Windows to Make Them Easily Identifiable

   sp1_ClearRect(&br1, INK_BLUE | PAPER_CYAN, 0, SP1_RFLAG_COLOUR);
   sp1_ClearRect(&br2, INK_BLUE | PAPER_RED, 0, SP1_RFLAG_COLOUR);
   sp1_ClearRect(&br3, INK_BLUE | PAPER_MAGENTA, 0, SP1_RFLAG_COLOUR);
   sp1_ClearRect(&br4, INK_BLUE | PAPER_GREEN, 0, SP1_RFLAG_COLOUR);

   sp1_Invalidate(&cr);
   sp1_UpdateNow();

   // Initialize the Four Print Contexts
   
   ps1.bounds    = &br1;                       // print window
   ps1.flags     = SP1_PSSFLAG_INVALIDATE;     // printed characters invalidated so that they are drawn in the next sp1_UpdateNow
   ps1.attr_mask = 0;                          // overwrite background colour
   ps1.attr      = INK_BLUE | PAPER_CYAN;
   ps1.visit     = 0;                          // no visit function (irrelevant in this example)
   sp1_SetPrintPos(&ps1, 11, 0);               // set initial cursor postion (coords relative to top left of print window)

   ps2.bounds    = &br2;                       // print window
   ps2.flags     = SP1_PSSFLAG_INVALIDATE | SP1_PSSFLAG_XWRAP;  // wrap when the x-coord reaches edge of print window but don't increment y-coord!
   ps2.attr_mask = 0;                          // overwrite background colour
   ps2.attr      = INK_BLUE | PAPER_RED;
   ps2.visit     = 0;                          // no visit function (irrelevant in this example)
   sp1_SetPrintPos(&ps2, 11, 0);               // set initial cursor postion (coords relative to top left of print window)

   ps3.bounds    = &br3;                       // print window
   ps3.flags     = SP1_PSSFLAG_INVALIDATE | SP1_PSSFLAG_XWRAP | SP1_PSSFLAG_YINC;  // wrap x-coord and increase y-coord when right edge of print window reached
   ps3.attr_mask = 0;                          // overwrite background colour
   ps3.attr      = INK_BLUE | PAPER_MAGENTA;
   ps3.visit     = 0;                          // no visit function (irrelevant in this example)
   sp1_SetPrintPos(&ps3, 11, 0);               // set initial cursor postion (coords relative to top left of print window)

   ps4.bounds    = &br4;                       // print window
   ps4.flags     = SP1_PSSFLAG_INVALIDATE | SP1_PSSFLAG_XWRAP | SP1_PSSFLAG_YINC | SP1_PSSFLAG_YWRAP;  // as with ps3 but also wrap y-coord when bottom of window reached
   ps4.attr_mask = 0;                          // overwrite background colour
   ps4.attr      = INK_BLUE | PAPER_GREEN;
   ps4.visit     = 0;                          // no visit function (irrelevant in this example)
   sp1_SetPrintPos(&ps4, 11, 0);               // set initial cursor postion (coords relative to top left of print window)

   // print the text to the four windows
   
   sp1_PrintString(&ps1, text1);
   sp1_PrintString(&ps2, text1);
   sp1_PrintString(&ps3, text1);
   sp1_PrintString(&ps4, text1);

   sp1_PrintString(&ps1, text2);               // printing continues from where it left off
   sp1_PrintString(&ps2, text2);
   sp1_PrintString(&ps3, text2);
   sp1_PrintString(&ps4, text2);

   sp1_UpdateNow();

   // loop forever
   
   while (1) ;

}
