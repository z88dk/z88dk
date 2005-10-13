#ifndef _INPUT_H
#define _INPUT_H

/*
 * Functions for Reading Keyboards, Joysticks and Mice
 *
 */

typedef unsigned int uint;
typedef unsigned char uchar;

/*
 * 1. KEYBOARD
 *
 * Every port must implement all of the following:
 *
 * uint in_GetKey(void)
 *   Returns ascii code representing a single key press or zero
 *   if no/too many keys pressed.  Must implement key debounce,
 *   key start repeat and key repeat.
 *
 * void in_GetKeyReset(void)
 *   Resets the in_GetKey state machine.
 *
 * uint in_Inkey(void)
 *   Returns ascii code representing a single key press or zero
 *   if no/too many keys pressed.  Reflects the instantaneous
 *   state of the keyboard.
 *
 * uint in_KeyPressed(uint scancode)
 *   Accepts a 16-bit scancode, returned by in_LookupKey, that
 *   identifies a specific key.  Returns non-zero if the key
 *   is pressed and zero if it is not.  Intended to operate
 *   correctly if many keys are simultaneously pressed.
 *
 * uint in_LookupKey(uchar c)
 *   Given the ascii code of a character, returns a 16-bit
 *   scancode that identifies a key or key combination that
 *   must be pressed in order to generate the ascii code.
 *   If no key combination can generate the code, 0 is returned.
 *   The scancode is used by in_KeyPressed and in_JoyKeyboard
 *   to scan the keyboard.
 *
 * uint in_Pause(uint ticks)
 *   Pause for a period of time measured in vertical blanking
 *   intervals (in Europe units of 1/50s, in North America
 *   units of 1/60s).  Return early if a key is pressed,
 *   reporting the amount of time remaining.  Machines with
 *   VBI interrupts may measure this time using "HALT" so
 *   be sure interrupts are enabled when this function
 *   executes.  Machines without a VBI interval will likely
 *   busy-wait for approximately one VBI interval between
 *   keyboard scans.
 *
 * void in_Wait(unit ticks)
 *   Similar to in_Pause but waits the entire period.
 *
 * void in_WaitForKey(void)
 *   Wait until any key is pressed.
 *
 * void in_WaitForNoKey(void)
 *   Wait until no keys are pressed.
 *
 *
 * If your program uses the in_GetKey function you must declare
 * the following variables:
 *
 * uchar in_KeyDebounce
 *   Number of ticks before a keypress is acknowledged.
 *   Set to 1 for no debouncing.
 *
 * uchar in_KeyStartRepeat
 *   Number of ticks after debounce before a key starts repeating.
 *
 * uchar in_KeyRepeatPeriod
 *   Repeat key rate measured in ticks.
 *
 * uint in_KbdState
 *   Reserved variable (don't alter, only declare).
 *
 * A tick in this context is the rate at which in_GetKey() is called.
 *
 */

extern uint __LIB__ in_GetKey(void);
extern uint __LIB__ in_GetKeyReset(void);
extern uint __LIB__ in_Inkey(void);
extern unit __LIB__ __FASTCALL__ in_KeyPressed(uint scancode);
extern unit __LIB__ __FASTCALL__ in_LookupKey(uchar c);
extern uint __LIB__ __FASTCALL__ in_Pause(unit ticks);
extern void __LIB__ __FASTCALL__ in_Wait(uint ticks);
extern void __LIB__ in_WaitForKey(void);
extern void __LIB__ in_WaitForNoKey(void);


/*
 * 2. JOYSTICK
 *
 * All joystick functions return a single byte in the format
 * F000RLDU (active high) to indicate state of directions and
 * fire button.  Do not assume that any directions are
 * mutually exclusive as on traditional joysticks (ie up and
 * down cannot normally be simultaneously asserted) since
 * joysticks may be simulated by other devices on certain
 * machines.
 *
 * Every port must provide at minimum:
 *
 * - in_JoyKeyboard, a keyboard joystick with user-definable
 *   keys for directions and fire button.
 *
 * - in_JoystickQuery, to return a pointer to a platform-dependent
 *   joystick function given a numerical identifier.  An
 *   out of range identifier returns the keyboard joystick.
 *
 * - in_JoyEnumQuery, to return a lower case string naming
 *   a platform-dependent joystick type given the same
 *   numerical identifier.  An out of range identifier
 *   returns 0 (NULL).
 *
 * Numerical identifier 0 always identifies the keyboard
 * joystick with succeeding identifiers choosing joystick
 * types in decreasing popularity (according to the
 * implementor).
 *
 * Protoypes for platform-specific joystick functions are
 * included from the target machine's implementation
 * dependent header file (eg spectrum.h for the zx spectrum)
 *
 * The intention is for the author to call in_JoyEnumQuery to
 * get names for a list of supported joysticks, have the
 * user select one and then call in_JoystickQuery to get a pointer
 * to the relevant joystick function.  This joystick function
 * should always be called with the parameter expected by
 * in_JoyKeyboard (other joystick functions will not need
 * or refer to this parameter).
 *
 * Example:
 *
 *   uchar choice, dirs;
 *   void *joyfunc;
 *   struct in_UDK k;
 *
 *   k.fire = in_LookupKey('m');   * fill in keys for key joystick *
 *   k.left = in_LookupKey('o');   * in case it is chosen          *
 *   (etc)
 *   ...
 *   printf("You have selected the %s joystick\n", in_JoyEnumQuery(choice));
 *   joyfunc = in_JoystickQuery(choice);
 *   ...
 *   dirs = (joyfunc)(&k);
 *   if (dirs & in_FIRE)
 *      printf("pressed fire!\n");
 *
 * If the author is not interested in this cross-platform capability,
 * the platform specific functions in the include files can be
 * used instead.
 *
 */

#define in_FIRE  0x80
#define in_UP    0x01
#define in_DOWN  0x02
#define in_LEFT  0x04
#define in_RIGHT 0x08

#define in_FIRE1 0x80
#define in_FIRE2 0x40   /* not currently used */

struct in_UDK {         /* user defined keys structure         */
   uint fire;          /* these are 16-bit scancodes returned */
   uint right;         /*  by in_LookupKey() that should be    */
   uint left;          /*  populated by the programmer        */
   uint down;
   uint up;
};

extern void __LIB__ __FASTCALL__ *in_JoystickQuery(uchar i);
extern char __LIB__ __FASTCALL__ *in_JoyEnumQuery(uchar i);
extern uint __LIB__ in_JoyKeyboard(struct in_UDK *u);

#ifdef SPECTRUM
   #define in_NUMJOY 6   /* last valid index 0..6 */
   #include <spectrum.h>
/*
   Adds: 1 in_JoyKempston, 2 in_JoySinclair1, 3 in_JoySinclair2,
         4 in_JoyFuller,   5 in_JoyTimex1,    6 in_JoyTimex2
*/
#endif


/*
 * 3. MOUSE
 *
 * Each mouse supported must implement at minimum three functions:
 *
 * void in_MouseNAMEInit(void)
 *   Initializes the mouse by setting coordinates to (0,0) and performing
 *   any hw initialization
 *
 * void in_MouseNAME(uchar *buttons, uint *xcoord, uint *ycoord)
 *   Read the mouse, returning single byte 00000MRL active high for buttons +
 *   16-bit X and Y coords for current mouse position
 *
 * void in_MouseNAMESetPos(uint xcoord, uint ycoord)
 *   Move the mouse's position to given (x,y) coord
 *
 * Functions should handle out of bounds (X,Y) coords gracefully.  Each port
 * defines macros in_MAX_X and in_MAX_Y to indicate maximum X and Y values.
 *
 * Every port must provide at minimum:
 *
 * - in_MouseQuery, to return a pointer to a platform-dependent
 *   array of three functions (3 words) for a particular mouse
 *   selected by a numerical identifier.  The pointer points at,
 *   in order: init function followed by set position function
 *   followed by read function.  These functions should be called
 *   as if they were the mandatory MouseSim functions listed below
 *   (ie with the struct in_UDM * parameter most mouse functions
 *   will not need).
 *
 * - in_MouseEnumQuery, to return a lower case string naming
 *   a platform-dependent mouse type given the same
 *   numerical identifier.  An out of range identifier
 *   returns 0 (NULL).
 *
 * Numerical identifier 0 always identifies the simulated mouse
 * with succeeding identifiers selecting mouse types in decreasing
 * popularity (according to the implementor).
 *
 * Every port must implement the simulated mouse which attempts
 * to simulate a mouse using a connected joystick:
 *
 * - in_MouseSimInit
 * - in_MouseSim
 * - in_MouseSimSetPos
 *
 * Protoypes for platform-specific mouse functions are
 * included from the target machine's implementation
 * dependent header file (eg spectrum.h for the zx spectrum)
 *
 * The intention is for the author to call in_MouseEnumQuery to
 * get names for a list of supported mice, have the
 * user select one and then call in_MouseQuery to get a pointer
 * to the relevant mouse functions.  These mouse functions
 * should always be called with the parameters expected by
 * the simulated mouse.
 *
 * Example:
 *
 *   uchar choice, b;
 *   void *mouseinit, *mouseread, *mousesetpos;
 *   void **mousefunc;
 *   struct in_UDM m;
 *   struct in_UDK k;
 *   uint x, y; 
 *   struct in_MD deltas[] = {
 *      3,0x10,0x10,              * 3 times one pixel move   *
 *      3,0x20,0x20,              * 3 times two pixel move   *
 *      5,0x40,0x40,              * 5 times four pixel move  *
 *      255,0x80,0x80             * forever eight pixel move *
 *   };
 *
 *   k.fire = in_LookupKey('m');   * fill in keys for key joystick *
 *   k.left = in_LookupKey('o');   * in case it is needed          *
 *   (etc)
 *   ...
 *   m.keys = &k;
 *   m.joyfunc = in_JoyKeyboard;   * simulated mouse will use key joystick *
 *   m.delta = deltas;            * acceleration profile *
 *   ...
 *   printf("You have selected the %s mouse\n", in_MouseEnumQuery(choice));
 *   mousefunc = in_MouseQuery(choice);
 *   mouseinit = mousefunc[0];
 *   mousesetpos = mousefunc[1];
 *   mouseread = mousefunc[2];
 *   (mouseinit)(&m);
 *   ...
 *   (mouseread)(&m, &b, &x, &y);
 *   if (b & in_BUT1)
 *      printf("button pressed at coord (%d,%d)!\n", x, y);
 *
 * If the author is not interested in this cross-platform capability,
 * the platform specific functions in the include files can be
 * used instead.
 *
 */

#define in_MLEFT   0x01
#define in_MRIGHT  0x02
#define in_MMID    0x04

#define in_BUT1    0x01
#define in_BUT2    0x02
#define in_BUT3    0x04

struct in_MD {              /* mouse deltas for struct in_UDM            */
   uchar maxcount;          /* number of times to use this mouse delta   */
   uint  dx;                /* x += dx if mouse moved in horizontal dir  */
   uint  dy;                /* y += dy if mouse moved in vertical dir    */
};

struct in_UDM {              /* user defined mouse structure                          */
   struct in_UDK  *keys;     /* parameter if in_JoyKeyboard() is used else ignored    */
   void          *joyfunc;   /* joystick function for reading input                   */
   struct in_MD  **delta;    /* pointer to array of in_MD; last max count must be 255 */
   uchar          state;     /* current index into delta array                        */
   uchar          count;     /* current count                                         */
   uint           y;         /* current (x,y) coordinate, fixed point                 */
   uint           x;
};

extern void __LIB__ __FASTCALL__ *in_MouseQuery(uchar i);
extern char __LIB__ __FASTCALL__ *in_MouseEnumQuery(uchar i);
extern void __LIB__ in_MouseSimInit(struct in_UDM *u);
extern void __LIB__ in_MouseSim(struct in_UDM *u, uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ in_MouseSimSetPos(struct in_UDM *u, uint xcoord, uint ycoord);

#ifdef SPECTRUM
   #define in_NUMMOUSE 2    /* last valid index 0..2 */
   #define in_MAX_X    255  /* largest x coord  */
   #define in_MAX_Y    191  /* largest y coord  */
   #include <spectrum.h>
/*
   Adds: 1 in_MouseKempInit, in_MouseKemp, in_MouseKempSetPos
         2 in_MouseAMXInit, in_MouseAMXInit2, in_MouseAMX, in_MouseAMXSetPos

   Both the AMX mouse and the Kempston mouse require variables to be declared,
   see spectrum.h for details.
*/
#endif


#endif
