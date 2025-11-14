
#include <stdio.h>
#ifndef NOSIGNAL
#include <signal.h>
#endif
#include <setjmp.h>

#ifdef Single
#define FLOAT float
#define FABS(x) (float)fabs((double)(x))
#define FLOOR(x) (float)floor((double)(x))
#define LOG(x) (float)log((double)(x))
#define POW(x,y) (float)pow((double)(x),(double)(y))
#define SQRT(x) (float)sqrt((double)(x))
#else
#define FLOAT double
#define FABS(x) fabs(x)
#define FLOOR(x) floor(x)
#define LOG(x) log(x)
#define POW(x,y) pow(x,y)
#define SQRT(x) sqrt(x)
#endif

jmp_buf ovfl_buf;
#ifdef KR_headers
#define VOID /* void */
#define INT /* int */
#define FP /* FLOAT */
#define CHARP /* char * */
#define CHARPP /* char ** */
extern double fabs(), floor(), log(), pow(), sqrt();
extern void exit();
typedef void (*Sig_type)();
FLOAT Sign(), Random();
extern void BadCond();
extern void SqXMinX();
extern void TstCond();
extern void notify();
extern int read();
#else
#define VOID void
#define INT int
#define FP FLOAT
#define CHARP char *
#define CHARPP char **
#ifdef __STDC__
#include <stdlib.h>
#include <math.h>
#else
#ifdef __cplusplus
extern "C" {
#endif
extern double fabs(double), floor(double), log(double);
extern double pow(double,double), sqrt(double);
extern void exit(INT);
#ifdef __cplusplus
	}
#endif
#endif
typedef void (*Sig_type)(int);
FLOAT Sign(FLOAT), Random(void);
extern void BadCond(int, char*);
extern void SqXMinX(int);
extern void TstCond(int, int, char*);
extern void notify(char*);
extern int read(int, char*, int);
#endif
#undef V9
extern void Characteristics(VOID);
extern void Heading(VOID);
extern void History(VOID);
extern void Instructions(VOID);
extern void IsYeqX(VOID);
extern void NewD(VOID);
extern void Pause(VOID);
extern void PrintIfNPositive(VOID);
extern void SR3750(VOID);
extern void SR3980(VOID);
extern void TstPtUf(VOID);

Sig_type sigsave;

#define KEYBOARD 0

FLOAT Radix, BInvrse, RadixD2, BMinusU2;

/*Small floating point constants.*/
FLOAT Zero = 0.0;
FLOAT Half = 0.5;
FLOAT One = 1.0;
FLOAT Two = 2.0;
FLOAT Three = 3.0;
FLOAT Four = 4.0;
FLOAT Five = 5.0;
FLOAT Eight = 8.0;
FLOAT Nine = 9.0;
FLOAT TwentySeven = 27.0;
FLOAT ThirtyTwo = 32.0;
FLOAT TwoForty = 240.0;
FLOAT MinusOne = -1.0;
FLOAT OneAndHalf = 1.5;
/*Integer constants*/
int NoTrials = 20; /*Number of tests for commutativity. */
#define False 0
#define True 1

/* Definitions for declared types 
	Guard == (Yes, No);
	Rounding == (Chopped, Rounded, Other);
	Message == packed array [1..40] of char;
	Class == (Flaw, Defect, Serious, Failure);
	  */
#define Yes 1
#define No  0
#define Chopped 2
#define Rounded 1
#define Other   0
#define Flaw    3
#define Defect  2
#define Serious 1
#define Failure 0
typedef int Guard, Rounding, Class;
typedef char Message;

/* Declarations of Variables */
int Indx;
char ch[8];
FLOAT AInvrse, A1;
FLOAT C, CInvrse;
FLOAT D, FourD;
FLOAT E0, E1, Exp2, E3, MinSqEr;
FLOAT SqEr, MaxSqEr, E9;
FLOAT Third;
FLOAT F6, F9;
FLOAT H, HInvrse;
int I;
FLOAT StickyBit, J;
FLOAT MyZero;
FLOAT Precision;
FLOAT Q, Q9;
FLOAT R, Random9;
FLOAT T, Underflow, S;
FLOAT OneUlp, UfThold, U1, U2;
FLOAT V, V0, V9;
FLOAT W;
FLOAT X, X1, X2, X8, Random1;
FLOAT Y, Y1, Y2, Random2;
FLOAT Z, PseudoZero, Z1, Z2, Z9;
int ErrCnt[4];
int fpecount;
int Milestone;
int PageNo;
int M, N, N1;
Guard GMult, GDiv, GAddSub;
Rounding RMult, RDiv, RAddSub, RSqrt;
int Break, Done, NotMonot, Monot, Anomaly, IEEE,
		SqRWrng, UfNGrad;
/* Computed constants. */
/*U1  gap below 1.0, i.e, 1.0-U1 is next number below 1.0 */
/*U2  gap above 1.0, i.e, 1.0+U2 is next number above 1.0 */

/* floating point exception receiver */
 void
sigfpe(INT x)
{
	fpecount++;
	printf("\n* * * FLOATING-POINT ERROR %d * * *\n", x);
	fflush(stdout);
	if (sigsave) {
#ifndef NOSIGNAL
		signal(SIGFPE, sigsave);
#endif
		sigsave = 0;
		longjmp(ovfl_buf, 1);
		}
	exit(1);
}

extern void part2(VOID);
extern void part3(VOID);
extern void part4(VOID);
extern void part5(VOID);
extern void part6(VOID);
extern void part7(VOID);
extern int  part8(VOID);

main(VOID)
{
	/* First two assignments use integer right-hand sides. */
	Zero = 0;
	One = 1;
	Two = One + One;
	Three = Two + One;
	Four = Three + One;
	Five = Four + One;
	Eight = Four + Four;
	Nine = Three * Three;
	TwentySeven = Nine * Three;
	ThirtyTwo = Four * Eight;
	TwoForty = Four * Five * Three * Four;
	MinusOne = -One;
	Half = One / Two;
	OneAndHalf = One + Half;
	ErrCnt[Failure] = 0;
	ErrCnt[Serious] = 0;
	ErrCnt[Defect] = 0;
	ErrCnt[Flaw] = 0;
	PageNo = 1;
	/*=============================================*/
	Milestone = 0;
	/*=============================================*/
#ifndef NOSIGNAL
	signal(SIGFPE, sigfpe);
#endif
	Instructions();
	Pause();
	Heading();
	Pause();
	Characteristics();
	Pause();
	History();
	Pause();
	/*=============================================*/
	Milestone = 7;
	/*=============================================*/
	printf("Program is now RUNNING tests on small integers:\n");
	
	TstCond (Failure, (Zero + Zero == Zero) && (One - One == Zero)
		   && (One > Zero) && (One + One == Two),
			"0+0 != 0, 1-1 != 0, 1 <= 0, or 1+1 != 2");
	Z = - Zero;
	if (Z != 0.0) {
		ErrCnt[Failure] = ErrCnt[Failure] + 1;
		printf("Comparison alleges that -0.0 is Non-zero!\n");
		U2 = 0.001;
		Radix = 1;
		TstPtUf();
		}
	TstCond (Failure, (Three == Two + One) && (Four == Three + One)
		   && (Four + Two * (- Two) == Zero)
		   && (Four - Three - One == Zero),
		   "3 != 2+1, 4 != 3+1, 4+2*(-2) != 0, or 4-3-1 != 0");
	TstCond (Failure, (MinusOne == (0 - One))
		   && (MinusOne + One == Zero ) && (One + MinusOne == Zero)
		   && (MinusOne + FABS(One) == Zero)
		   && (MinusOne + MinusOne * MinusOne == Zero),
		   "-1+1 != 0, (-1)+abs(1) != 0, or -1+(-1)*(-1) != 0");
	TstCond (Failure, Half + MinusOne + Half == Zero,
		  "1/2 + (-1) + 1/2 != 0");
	/*=============================================*/
	{
		extern void part2(VOID), part3(VOID), part4(VOID),
			part5(VOID), part6(VOID), part7(VOID);
		extern int part8(VOID);

		part2();
		part3();
		part4();
		part5();
		part6();
		part7();
		return part8();
		}
	}
