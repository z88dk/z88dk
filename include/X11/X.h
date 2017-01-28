
/* Definitions for the Z88DK X window system subset */

/* $Id: X.h,v 1.1 2008-03-17 14:29:45 stefano Exp $ */


#ifndef X_H
#define X_H

/***********************************************************


Modified for the Z88 Developement Kit by Stefano Bodrato - December, 2007



Copyright 1987, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall not be
used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from The Open Group.


Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts.

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in 
supporting documentation, and that the name of Digital not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/

//typedef unsigned long XID;
typedef int XID;

//typedef unsigned long Time;
typedef unsigned int Time;

//typedef unsigned long Atom;		/* Also in Xdefs.h */
typedef unsigned int Atom;

typedef XID Window;
typedef XID Drawable;
typedef int Font;
typedef XID Pixmap;
typedef XID Cursor;
typedef XID Colormap;
typedef XID GContext;
typedef XID KeySym;

typedef unsigned char KeyCode;

/*****************************************************************
 * RESERVED RESOURCE AND CONSTANT DEFINITIONS
 *****************************************************************/

#ifndef None
#define None                 0	/* universal null resource or null atom */
#endif

#define ParentRelative       1	/* background pixmap in CreateWindow
				    and ChangeWindowAttributes */

#define CopyFromParent       0	/* border pixmap in CreateWindow
				       and ChangeWindowAttributes
				   special VisualID and special window
				       class passed to CreateWindow */

#define PointerWindow        0	/* destination window in SendEvent */
#define InputFocus           1	/* destination window in SendEvent */

#define PointerRoot          1	/* focus window in SetInputFocus */

#define AnyPropertyType      0	/* special Atom, passed to GetProperty */

#define AnyKey		     0	/* special Key Code, passed to GrabKey */

#define AnyButton            0	/* special Button Code, passed to GrabButton */

#define AllTemporary         0	/* special Resource ID passed to KillClient */

#define CurrentTime          0	/* special Time */

#define NoSymbol	     0	/* special KeySym */

/***************************************************************** 
 * EVENT DEFINITIONS 
 *****************************************************************/

/* Input Event Masks. Used as event-mask window attribute and as arguments
   to Grab requests.  Not to be confused with event names.  */

#define NoEventMask			0L
#define KeyPressMask			1L
#define KeyReleaseMask			2L
#define ButtonPressMask			4L
#define ButtonReleaseMask		8L
#define EnterWindowMask			16L
#define LeaveWindowMask			32L
#define PointerMotionMask		64L
#define PointerMotionHintMask		128L
#define Button1MotionMask		256L
#define Button2MotionMask		512L
#define Button3MotionMask		1024L
#define Button4MotionMask		2048L
#define Button5MotionMask		4096L
#define ButtonMotionMask		8192L
#define KeymapStateMask			16384L
#define ExposureMask			32768L
#define VisibilityChangeMask		65536L
#define StructureNotifyMask		131072L
#define ResizeRedirectMask		262144L
#define SubstructureNotifyMask		524288L
#define SubstructureRedirectMask	1048576L
#define FocusChangeMask			2097152L
#define PropertyChangeMask		4194304L
#define ColormapChangeMask		8388608L
#define OwnerGrabButtonMask		16777216L

/* Event names.  Used in "type" field in XEvent structures.  Not to be
confused with event masks above.  They start from 2 because 0 and 1
are reserved in the protocol for errors and replies. */

#define KeyPress		2
#define KeyRelease		3
#define ButtonPress		4
#define ButtonRelease		5
#define MotionNotify		6
#define EnterNotify		7
#define LeaveNotify		8
#define FocusIn			9
#define FocusOut		10
#define KeymapNotify		11
#define Expose			12
#define GraphicsExpose		13
#define NoExpose		14
#define VisibilityNotify	15
#define CreateNotify		16
#define DestroyNotify		17
#define UnmapNotify		18
#define MapNotify		19
#define MapRequest		20
#define ReparentNotify		21
#define ConfigureNotify		22
#define ConfigureRequest	23
#define GravityNotify		24
#define ResizeRequest		25
#define CirculateNotify		26
#define CirculateRequest	27
#define PropertyNotify		28
#define SelectionClear		29
#define SelectionRequest	30
#define SelectionNotify		31
#define ColormapNotify		32
#define ClientMessage		33
#define MappingNotify		34
#define LASTEvent		35	/* must be bigger than any event # */


/* Key masks. Used as modifiers to GrabButton and GrabKey, results of QueryPointer,
   state in various key-, mouse-, and button-related events. */

#define ShiftMask		1
#define LockMask		2
#define ControlMask		4
#define Mod1Mask		8
#define Mod2Mask		16
#define Mod3Mask		32
#define Mod4Mask		64
#define Mod5Mask		128

/* modifier names.  Used to build a SetModifierMapping request or
   to read a GetModifierMapping request.  These correspond to the
   masks defined above. */
#define ShiftMapIndex		0
#define LockMapIndex		1
#define ControlMapIndex		2
#define Mod1MapIndex		3
#define Mod2MapIndex		4
#define Mod3MapIndex		5
#define Mod4MapIndex		6
#define Mod5MapIndex		7


/* button masks.  Used in same manner as Key masks above. Not to be confused
   with button names below. */

#define Button1Mask		256
#define Button2Mask		512
#define Button3Mask		1024
#define Button4Mask		2048
#define Button5Mask		4096

#define AnyModifier		32768  /* used in GrabButton, GrabKey */


/* button names. Used as arguments to GrabButton and as detail in ButtonPress
   and ButtonRelease events.  Not to be confused with button masks above.
   Note that 0 is already defined above as "AnyButton".  */

#define Button1			1
#define Button2			2
#define Button3			3
#define Button4			4
#define Button5			5

/* Notify modes */

#define NotifyNormal		0
#define NotifyGrab		1
#define NotifyUngrab		2
#define NotifyWhileGrabbed	3

#define NotifyHint		1	/* for MotionNotify events */
		       
/* Notify detail */

#define NotifyAncestor		0
#define NotifyVirtual		1
#define NotifyInferior		2
#define NotifyNonlinear		3
#define NotifyNonlinearVirtual	4
#define NotifyPointer		5
#define NotifyPointerRoot	6
#define NotifyDetailNone	7

/* Visibility notify */

#define VisibilityUnobscured		0
#define VisibilityPartiallyObscured	1
#define VisibilityFullyObscured		2

/* Circulation request */

#define PlaceOnTop		0
#define PlaceOnBottom		1

/* protocol families */

#define FamilyInternet		0	/* IPv4 */
#define FamilyDECnet		1
#define FamilyChaos		2
#define FamilyInternet6		6	/* IPv6 */

/* authentication families not tied to a specific protocol */
#define FamilyServerInterpreted 5

/* Property notification */

#define PropertyNewValue	0
#define PropertyDelete		1

/* Color Map notification */

#define ColormapUninstalled	0
#define ColormapInstalled	1

/* GrabPointer, GrabButton, GrabKeyboard, GrabKey Modes */

#define GrabModeSync		0
#define GrabModeAsync		1

/* GrabPointer, GrabKeyboard reply status */

#define GrabSuccess		0
#define AlreadyGrabbed		1
#define GrabInvalidTime		2
#define GrabNotViewable		3
#define GrabFrozen		4

/* AllowEvents modes */

#define AsyncPointer		0
#define SyncPointer		1
#define ReplayPointer		2
#define AsyncKeyboard		3
#define SyncKeyboard		4
#define ReplayKeyboard		5
#define AsyncBoth		6
#define SyncBoth		7

/* Used in SetInputFocus, GetInputFocus */

#define RevertToNone		(int)None
#define RevertToPointerRoot	(int)PointerRoot
#define RevertToParent		2

/*****************************************************************
 * ERROR CODES 
 *****************************************************************/

#define Success		   0	/* everything's okay */
#define BadRequest	   1	/* bad request code */
#define BadValue	   2	/* int parameter out of range */
#define BadWindow	   3	/* parameter not a Window */
#define BadPixmap	   4	/* parameter not a Pixmap */
#define BadAtom		   5	/* parameter not an Atom */
#define BadCursor	   6	/* parameter not a Cursor */
#define BadFont		   7	/* parameter not a Font */
#define BadMatch	   8	/* parameter mismatch */
#define BadDrawable	   9	/* parameter not a Pixmap or Window */
#define BadAccess	  10	/* depending on context:
				 - key/button already grabbed
				 - attempt to free an illegal 
				   cmap entry 
				- attempt to store into a read-only 
				   color map entry.
 				- attempt to modify the access control
				   list from other than the local host.
				*/
#define BadAlloc	  11	/* insufficient resources */
#define BadColor	  12	/* no such colormap */
#define BadGC		  13	/* parameter not a GC */
#define BadIDChoice	  14	/* choice not in range or already used */
#define BadName		  15	/* font or color name doesn't exist */
#define BadLength	  16	/* Request length incorrect */
#define BadImplementation 17	/* server is defective */

#define FirstExtensionError	128
#define LastExtensionError	255

/*****************************************************************
 * WINDOW DEFINITIONS 
 *****************************************************************/

/* Window classes used by CreateWindow */
/* Note that CopyFromParent is already defined as 0 above */

#define InputOutput		1
#define InputOnly		2

/* Window attributes for CreateWindow and ChangeWindowAttributes */

#define CWBackPixmap		1
#define CWBackPixel		2
#define CWBorderPixmap		4
#define CWBorderPixel           8
#define CWBitGravity		16
#define CWWinGravity		32
#define CWBackingStore          64
#define CWBackingPlanes	        128
#define CWBackingPixel	        256
#define CWOverrideRedirect	512
#define CWSaveUnder		1024
#define CWEventMask		2048
#define CWDontPropagate	        4096
#define CWColormap		8192
#define CWCursor	        16384

/* ConfigureWindow structure */

#define CWX			1
#define CWY			2
#define CWWidth			4
#define CWHeight		8
#define CWBorderWidth		16
#define CWSibling		32
#define CWStackMode		64


/* Bit Gravity */

#define ForgetGravity		0
#define NorthWestGravity	1
#define NorthGravity		2
#define NorthEastGravity	3
#define WestGravity		4
#define CenterGravity		5
#define EastGravity		6
#define SouthWestGravity	7
#define SouthGravity		8
#define SouthEastGravity	9
#define StaticGravity		10

/* Window gravity + bit gravity above */

#define UnmapGravity		0

/* Used in CreateWindow for backing-store hint */

#define NotUseful               0
#define WhenMapped              1
#define Always                  2

/* Used in GetWindowAttributes reply */

#define IsUnmapped		0
#define IsUnviewable		1
#define IsViewable		2

/* Used in ChangeSaveSet */

#define SetModeInsert           0
#define SetModeDelete           1

/* Used in ChangeCloseDownMode */

#define DestroyAll              0
#define RetainPermanent         1
#define RetainTemporary         2

/* Window stacking method (in configureWindow) */

#define Above                   0
#define Below                   1
#define TopIf                   2
#define BottomIf                3
#define Opposite                4

/* Circulation direction */

#define RaiseLowest             0
#define LowerHighest            1

/* Property modes */

#define PropModeReplace         0
#define PropModePrepend         1
#define PropModeAppend          2

/*****************************************************************
 * GRAPHICS DEFINITIONS
 *****************************************************************/

/* graphics functions, as in GC.alu */

#define	GXclear			0x0		/* 0 */
#define GXand			0x1		/* src AND dst */
#define GXandReverse		0x2		/* src AND NOT dst */
#define GXcopy			0x3		/* src */
#define GXandInverted		0x4		/* NOT src AND dst */
#define	GXnoop			0x5		/* dst */
#define GXxor			0x6		/* src XOR dst */
#define GXor			0x7		/* src OR dst */
#define GXnor			0x8		/* NOT src AND NOT dst */
#define GXequiv			0x9		/* NOT src XOR dst */
#define GXinvert		0xa		/* NOT dst */
#define GXorReverse		0xb		/* src OR NOT dst */
#define GXcopyInverted		0xc		/* NOT src */
#define GXorInverted		0xd		/* NOT src OR dst */
#define GXnand			0xe		/* NOT src OR NOT dst */
#define GXset			0xf		/* 1 */

/* LineStyle */

#define LineSolid		0
#define LineOnOffDash		1
#define LineDoubleDash		2

/* capStyle */

#define CapNotLast		0
#define CapButt			1
#define CapRound		2
#define CapProjecting		3

/* joinStyle */

#define JoinMiter		0
#define JoinRound		1
#define JoinBevel		2

/* fillStyle */

#define FillSolid		0
#define FillTiled		1
#define FillStippled		2
#define FillOpaqueStippled	3

/* fillRule */

#define EvenOddRule		0
#define WindingRule		1

/* subwindow mode */

#define ClipByChildren		0
#define IncludeInferiors	1

/* SetClipRectangles ordering */

#define Unsorted		0
#define YSorted			1
#define YXSorted		2
#define YXBanded		3

/* CoordinateMode for drawing routines */

#define CoordModeOrigin		0	/* relative to the origin */
#define CoordModePrevious       1	/* relative to previous point */

/* Polygon shapes */

#define Complex			0	/* paths may intersect */
#define Nonconvex		1	/* no paths intersect, but not convex */
#define Convex			2	/* wholly convex */

/* Arc modes for PolyFillArc */

#define ArcChord		0	/* join endpoints of arc */
#define ArcPieSlice		1	/* join endpoints to center of arc */

/* GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
   GC.stateChanges */

#define GCFunction              1
#define GCPlaneMask             2
#define GCForeground            4
#define GCBackground            8
#define GCLineWidth             16
#define GCLineStyle             32
#define GCCapStyle              64
#define GCJoinStyle		128
#define GCFillStyle		256
#define GCFillRule		512
#define GCTile			1024
#define GCStipple		2048
#define GCTileStipXOrigin	4096
#define GCTileStipYOrigin	8192
#define GCFont 			16384
#define GCSubwindowMode		32768
/*
#define GCGraphicsExposures     65536L      
#define GCClipXOrigin		131072L     
#define GCClipYOrigin		262144L     
#define GCClipMask		524288L     
#define GCDashOffset		1048576L    
#define GCDashList		2097152L    
#define GCArcMode		4194304L
*/
                                 
#define GCLastBit		22
/*****************************************************************
 * FONTS 
 *****************************************************************/

/* used in QueryFont -- draw direction */

#define FontLeftToRight		0
#define FontRightToLeft		1

#define FontChange		255

/*****************************************************************
 *  IMAGING 
 *****************************************************************/

/* ImageFormat -- PutImage, GetImage */

#define XYBitmap		0	/* depth 1, XYFormat */
#define XYPixmap		1	/* depth == drawable depth */
#define ZPixmap			2	/* depth == drawable depth */

/*****************************************************************
 *  COLOR MAP STUFF 
 *****************************************************************/

/* For CreateColormap */

#define AllocNone		0	/* create map with no entries */
#define AllocAll		1	/* allocate entire map writeable */


/* Flags used in StoreNamedColor, StoreColors */

#define DoRed			1
#define DoGreen			2
#define DoBlue			4

/*****************************************************************
 * CURSOR STUFF
 *****************************************************************/

/* QueryBestSize Class */

#define CursorShape		0	/* largest size that can be displayed */
#define TileShape		1	/* size tiled fastest */
#define StippleShape		2	/* size stippled fastest */

/***************************************************************** 
 * KEYBOARD/POINTER STUFF
 *****************************************************************/

#define AutoRepeatModeOff	0
#define AutoRepeatModeOn	1
#define AutoRepeatModeDefault	2

#define LedModeOff		0
#define LedModeOn		1

/* masks for ChangeKeyboardControl */

#define KBKeyClickPercent	1
#define KBBellPercent		2
#define KBBellPitch		4
#define KBBellDuration		8
#define KBLed			16
#define KBLedMode		32
#define KBKey			64
#define KBAutoRepeatMode	128

#define MappingSuccess     	0
#define MappingBusy        	1
#define MappingFailed		2

#define MappingModifier		0
#define MappingKeyboard		1
#define MappingPointer		2

/*****************************************************************
 * SCREEN SAVER STUFF 
 *****************************************************************/

#define DontPreferBlanking	0
#define PreferBlanking		1
#define DefaultBlanking		2

#define DisableScreenSaver	0
#define DisableScreenInterval	0

#define DontAllowExposures	0
#define AllowExposures		1
#define DefaultExposures	2

/* for ForceScreenSaver */

#define ScreenSaverReset 0
#define ScreenSaverActive 1

/*****************************************************************
 * HOSTS AND CONNECTIONS
 *****************************************************************/

/* for ChangeHosts */

#define HostInsert		0
#define HostDelete		1

/* for ChangeAccessControl */

#define EnableAccess		1      
#define DisableAccess		0

/* Display classes  used in opening the connection 
 * Note that the statically allocated ones are even numbered and the
 * dynamically changeable ones are odd numbered */

#define StaticGray		0
#define GrayScale		1
#define StaticColor		2
#define PseudoColor		3
#define TrueColor		4
#define DirectColor		5


/* Byte order  used in imageByteOrder and bitmapBitOrder */

#define LSBFirst		0
#define MSBFirst		1

#endif /* X_H */
