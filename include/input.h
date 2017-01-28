#ifndef _INPUT_H
#define _INPUT_H

/*
 * Functions for Reading Keyboards, Joysticks and Mice
 */
#include <sys/compiler.h>
#include <sys/types.h>

/*
 * 1. KEYBOARD
 *
 * Every port must implement all of the following:
 *
 * uint in_GetKey(void)
 *   Returns ascii code representing a single key press or zero
 *   if no/too many keys pressed.  Must implement key debounce,
 *   key start repeat and key repeat (below).
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
 * uint in_Pause(uint msec)
 *   Pause for a period of time measured in milliseconds.
 *   Return early if a key is pressed, reporting the amount of
 *   time remaining.  This must be a busy wait interval; resist
 *   the use of interrupts to keep the function useful even
 *   with interrupts disabled.  If msec==0 wait until key
 *   is pressed.
 *
 * void in_Wait(unit msec)
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
 * uchar in_KeyDebounce;
 *   Number of ticks before a keypress is acknowledged.
 *   Set to 1 for no debouncing.
 *
 * uchar in_KeyStartRepeat;
 *   Number of ticks after debounce before a key starts repeating.
 *
 * uchar in_KeyRepeatPeriod;
 *   Repeat key rate measured in ticks.
 *
 * uint in_KbdState;
 *   Reserved variable (don't alter, only declare).
 *
 * A tick in this context is the rate at which in_GetKey() is called.
 *
 * Declaring these C variables statically will cause them to
 * be compiled as part of the final binary.  Alternatively (required
 * if the final binary is to be ROMable) the locations of these
 * variables in RAM can be specified using special extern syntax.
 *
 *  Example:
 *
 *  extern char in_KeyDebounce(50000);
 *  extern char in_KeyStartRepeat(50001);
 *  extern char in_KeyRepeatPeriod(50002);
 *  extern int  in_KbdState(50003);
 */

extern uint __LIB__ in_GetKey(void);
extern void __LIB__ in_GetKeyReset(void);
extern uint __LIB__ in_Inkey(void);
extern uint __LIB__  in_KeyPressed(uint scancode) __z88dk_fastcall;
extern uint __LIB__  in_LookupKey(uchar c) __z88dk_fastcall;
extern uint __LIB__  in_Pause(uint msec) __z88dk_fastcall;
extern void __LIB__  in_Wait(uint msec) __z88dk_fastcall;
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
 * Protoypes for platform-specific joystick functions are
 * included from the target machine's implementation
 * dependent header file (eg spectrum.h for the zx spectrum)
 * but are also listed in the comments below.
 *
 * It is possible to use a function pointer to use one of
 * a number of joystick functions selected by the user from
 * a menu since all joystick functions can accept the
 * same parameter and return a value in the same format.
 *
 * Example using Sinclair Spectrum joystick functions:
 *
 *   uchar choice, dirs;
 *   void *joyfunc;                * pointer to joystick function  *
 *   char *joynames[];             * an array of joystick names    *
 *   struct in_UDK k;
 *
 *   k.fire = in_LookupKey('m');   * fill in keys for key joystick *
 *   k.left = in_LookupKey('o');   * in case it is chosen          *
 *   (etc)
 *   ...
 *   printf("You have selected the %s joystick\n", joynames[choice]);
 *   switch (choice) {
 *      case 0 : joyfunc = in_JoyKeyboard; break;
 *      case 1 : joyfunc = in_JoyKempston; break;
 *      case 2 : joyfunc = in_JoySinclair1; break;
 *      default: joyfunc = in_JoySinclair2; break;
 *   }
 *   ...
 *   dirs = (joyfunc)(&k);
 *   if (dirs & in_FIRE)
 *      printf("pressed fire!\n");
 *
 * None of the joystick functions expect a parameter with the
 * exception of in_JoyKeyboard.  Therefore the joystick function
 * call through the pointer should always be made with the parameter
 * expected by in_JoyKeyboard.  The other joystick functions will
 * simply ignore it.
 *
 */

#define in_FIRE  0x80
#define in_UP    0x01
#define in_DOWN  0x02
#define in_LEFT  0x04
#define in_RIGHT 0x08

#define in_FIRE1 0x80
#define in_FIRE2 0x40  /* not currently used */

struct in_UDK {        /* user defined keys structure         */
   uint fire;          /* these are 16-bit scancodes returned */
   uint right;         /*  by in_LookupKey() that should be    */
   uint left;          /*  populated by the programmer        */
   uint down;
   uint up;
};

extern uint __LIB__  in_JoyKeyboard(struct in_UDK *u) __z88dk_fastcall;

#ifdef SPECTRUM
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
 *   any hw initialization. (0,0) is located at the top left corner of the
 *   screen
 *
 * void in_MouseNAME(uchar *buttons, uint *xcoord, uint *ycoord)
 *   Read the mouse, returning single byte 00000MRL active high for buttons +
 *   16-bit X and Y coords for current mouse position
 *
 * void in_MouseNAMESetPos(uint xcoord, uint ycoord)
 *   Move the mouse's position to given (x,y) coord
 *
 * Functions should handle out of bounds (X,Y) coords gracefully.  Each port
 * defines macros IN_MAX_X and IN_MAX_Y to indicate maximum X and Y values.
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
 * and are listed in comments below.
 *
 * As with the joystick functions, it is possible to use
 * function pointers to use one of a number of mice selected
 * by the user from a menu.
 *
 * Example using Sinclair Spectrum mice:
 *
 *   uchar choice, b;
 *   void *mouseinit, *mouseread, *mousesetpos;
 *   void **mousefunc;
 *   void *mousename[];
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
 *   m.delta = deltas;             * acceleration profile *
 *   ...
 *   printf("You have selected the %s mouse\n", mousename[choice]);
 *   switch (choice) {
 *      case 0 : mouseinit   = in_MouseSimInit;
 *               mousesetpos = in_MouseSimSetPos;
 *               mouseread   = in_MouseSim;
 *               break;
 *      case 1 : mouseinit   = in_MouseAMXInit2;
 *               mousesetpos = in_MouseAMXSetPos;
 *               mouseread   = in_MouseAMX;
 *               break;
 *      default: mouseinit   = in_MouseKempInit;
 *               mousesetpos = in_MouseKempSetPos;
 *               mouseread   = in_MouseKemp;
 *               break;
 *   }
 *
 *   (mouseinit)(&m);
 *   ...
 *   (mouseread)(&m, &b, &x, &y);
 *   if (b & in_BUT1)
 *      printf("button pressed at coord (%d,%d)!\n", x, y);
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

extern void __LIB__ in_MouseSimInit(struct in_UDM *u);
extern void __LIB__ in_MouseSim(struct in_UDM *u, uchar *buttons, uint *xcoord, uint *ycoord) __smallc;
extern void __LIB__ in_MouseSimSetPos(struct in_UDM *u, uint xcoord, uint ycoord) __smallc;

extern void __LIB__  in_MouseSimInit_fastcall(struct in_UDM *u) __z88dk_fastcall;
extern void __LIB__  in_MouseSim_callee(struct in_UDM *u, uchar *buttons, uint *xcoord, uint *ycoord) __smallc __z88dk_callee;
extern void __LIB__  in_MouseSimSetPos_callee(struct in_UDM *u, uint xcoord, uint ycoord) __smallc __z88dk_callee;

#define in_MouseSimInit(a)        in_MouseSimInit_fastcall(a)
#define in_MouseSim(a,b,c,d)      in_MouseSim_callee(a,b,c,d)
#define in_MouseSimSetPos(a,b,c)  in_MouseSimSetPos_callee(a,b,c)

#ifdef SPECTRUM
   #define IN_MAX_X    255  /* largest x coord  */
   #define IN_MAX_Y    191  /* largest y coord  */
   #include <spectrum.h>
/*
   Adds: 1 in_MouseKempInit, in_MouseKemp, in_MouseKempSetPos
         2 in_MouseAMXInit, in_MouseAMXInit2, in_MouseAMX, in_MouseAMXSetPos

   Both the AMX mouse and the Kempston mouse require variables to be declared,
   see spectrum.h for details.
*/
#endif


#endif
