=================================
NIRVANA+ ENGINE - by Einar Saukas
=================================

The NIRVANA+ ENGINE provides (nearly) full-screen Rainbow Graphics support to
render all 32 columns of ZX-Spectrum screen in bicolor (a.k.a. multicolor 8x2).


=======
LICENSE
=======

You can freely use the NIRVANA+ ENGINE to develop your own programs (even for
commercial projects), as long as you clearly mention that it was developed using
the NIRVANA+ ENGINE. It doesn't matter how you choose to do so.

For instance, a concise way to respect the license would be simply including
something like this:

  Powered by NIRVANA+


======
F.A.Q.
======

  ------------------------
* WHAT'S THE NIRVANA+ API?
  ------------------------

  NIRVANA_start() - enable NIRVANA

  NIRVANA_drawT(tile, lin, col) - Draw tile (16x16 pixels)

  NIRVANA_fillT(attr, lin, col) - Change attributes in tile area (16x16 pixels)
      to certain value (use same INK/PAPER to erase it)

  NIRVANA_halt() - wait for next frame (required to sync with interrupts before
      calling NIRVANA_drawW, NIRVANA_drawT and/or NIRVANA_fillT a few times)

  NIRVANA_printC(ch, attrs, lin, col) - print 8x8 character, then paint it

  NIRVANA_paintC(attrs, lin, col) - paint 8x8 character with 4 attribute values

  NIRVANA_readC(lin, col, attrs) - read 4 attribute values from 8x8 character

  NIRVANA_fillC(attr, lin, col) - change attributes in 8x8 character to certain
      value (use same INK/PAPER to erase it)

  NIRVANA_spriteT(sprite, tile, lin, col) - Set a sprite tile (16x16 pixels) to
      be drawn at next interrupt

  NIRVANA_drawW(wtile, lin, col) - Draw wide tile (24x16 pixels), however notice 
      this routine is disabled by default!

  NIRVANA_stop() - disable NIRVANA


  --------------------------
* HOW MUCH CPU IS AVAILABLE?
  --------------------------

  Using NIRVANA+ with 23 multicolor rows, your game will have about 12.5K
  T-states available per frame, so it will be 5.5 times slower than normal.
  However drawing on screen typically consumes most of processing time in
  typical Spectrum games. Since NIRVANA automatically draws 8 btiles "for free"
  every frame (during the top border), your game won't need to spend time with
  drawing, and can spend the available time just executing the other remaining
  tasks.

  If that's not enough, you can recompile NIRVANA+ to remove a few bicolor rows
  from the bottom of screen (see parameter "TOTAL_ROWS"). Each character row not
  rendered in bicolor will save about 1.8K T-states. For instance, reducing 5
  rows (perhaps using these rows for a scoreboard with standard attributes
  instead) will make your game "only" 3.2 times slower than normal.


  -----------------------------
* HOW MUCH MEMORY IS AVAILABLE?
  -----------------------------

  NIRVANA+ takes 9055 bytes, occupying addresses 56323 to 65377. Everything else
  is fully available for your game.

  If you remove a few bicolor rows from the bottom of screen (see previous item)
  then addresses from '56718+328*TOTAL_ROWS' to 64261 will be unused, so your
  game can use this area for something else.

  If "NIRVANA_printC" is never used, then addresses 56323 to 56417 can be reused
  for something else.

  If both "NIRVANA_printC" and "NIRVANA_paintC" are never used, then addresses
  56418 to 56453 can also be reused for something else.

  If "NIRVANA_fillC" is never used, then addresses 65313 to 65341 can be reused
  for something else.

  Finally if "NIRVANA_readC" is never used, then addresses 65342 to 65377 can
  also be reused for something else.


  -----------------------------------
* HOW TO PLAY AY MUSIC WITH NIRVANA+?
  -----------------------------------

  Most AY players simply require repeatedly calling a certain routine X once per
  interrupt. In NIRVANA+, there's purposely an unused instruction "ld hl,0"
  starting at address '56698+328*TOTAL_ROWS' (address 64242 by default), that
  you can replace with "call X" to invoke your AY player routine at every
  interrupt (as long as NIRVANA+ is active). In this case, all registers will be
  automatically preserved for you.

  In practice, you could use this code to start playing an AY music:

        halt
        call    ay_start                ; start AY player
        ld      hl, ay_play
        ld      (64243),hl              ; set play address
        ld      a, $cd                  ; instruction "CALL"
        ld      (64242), a              ; play automatically every interrupt

  And this code to stop playing the AY music:

        halt
        ld      a,$21                   ; instruction "LD HL"
        ld      (64242),a               ; disable playing automatically
        call    ay_stop                 ; stop AY player


  -------------------------------------------
* HOW TO DO SOMETHING ELSE DURING TOP BORDER?
  -------------------------------------------

  By default, NIRVANA+ uses the top border to draw 8 btiles, controlled using
  "NIRVANA_spriteT". This code occupies addresses 56468 to 56531, and it takes
  exactly 13928 T-states.

  If you want to use the top border to do something different, you can change
  these addresses to put your own routine there. Just make sure your routine
  always take exactly 13928 T-states also, before it reaches address 56532.


  ----------------------
* HOW TO USE WIDE TILES?
  ----------------------

  NIRVANA+ provides an optional routine "NIRVANA_drawW" for drawing wide tiles
  (24x16 pixels), that can be used to animate pre-shifted tiles when moving
  sideways. This routine will (probably) be less frequently used, so it's
  disabled by default to save memory. If you would like to use it, you must
  recompile NIRVANA+ source code declaring 'ENABLE_WIDE_DRAW' at the beginning
  of the file, then it will occupy addresses 56085 to 56322.

  Moreover, if you declare both 'ENABLE_WIDE_DRAW' and 'ENABLE_WIDE_SPRITE'
  before compiling NIRVANA+, then it will occupy 12 more bytes (starting at 
  address 56073), and "NIRVANA_spriteT" will automatically draw wide tile 
  sprites (24x16 pixels) instead of regular tile sprites (24x16 pixels),
  although in this case you will only have 6 sprites instead of 8.

  After enabling wide sprites, you could even reconfigure separately each
  individual sprite for drawing either a regular or wide tile:

  * Use "POKE 56474+sprite*8,9+(4 AND sprite<>0)" to reconfigure any specific
    sprite to draw a regular tile

  * Use "POKE 56474+sprite*8,21+(4 AND sprite<>0)" to make this sprite draw a
    wide tile again


  ---------------------------------------------------
* WHAT'S THE DIFFERENCE BETWEEN NIRVANA AND NIRVANA+?
  ---------------------------------------------------

  NIRVANA generates bicolor graphics in 30 columns and at most 22 rows (edge
  rows and columns are reserved). It's possible to draw tiles partially hidden
  outside screen at top, bottom, and both sides. Choose this engine if you want
  to draw multicolor images gradually entering or leaving the gameplay area.

  NIRVANA+ generates multicolor graphics in 32 columns and at most 23 rows (top
  row is reserved for anti-flickering). It's possible to draw tiles partially
  hidden outside screen hidden at top and bottom, but not on either side. Choose
  this engine if you want to draw multicolor images over an even larger area.


=======
CREDITS
=======

Engine designed and implemented by Einar Saukas.

Based on 32 columns multicolor routine created by Alone Coder and Einar Saukas:
  http://www.worldofspectrum.org/forums/discussion/44591
