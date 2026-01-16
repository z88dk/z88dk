#include "paranoia.h"

 FLOAT
Sign (FP X)
#ifdef KR_headers
FLOAT X;
#endif
{ return X >= 0. ? 1.0 : -1.0; }

 void
Pause(VOID)
{
#ifndef NOPAUSE
	char ch[8];

	printf("\nTo continue, press RETURN");
	fflush(stdout);
	read(KEYBOARD, ch, 8);
#endif
	printf("\nDiagnosis resumes after milestone Number %d", Milestone);
	printf("          Page: %d\n\n", PageNo);
	++Milestone;
	++PageNo;
	}

 void
TstCond (INT K, INT Valid, CHARP T)
#ifdef KR_headers
int K, Valid;
char *T;
#endif
{ if (! Valid) { BadCond(K,T); printf(".\n"); } }

 void
BadCond(INT K, CHARP T)
#ifdef KR_headers
int K;
char *T;
#endif
{
	static char *msg[] = { "FAILURE", "SERIOUS DEFECT", "DEFECT", "FLAW" };

	ErrCnt [K] = ErrCnt [K] + 1;
	printf("%s:  %s", msg[K], T);
	}


 FLOAT
Random(VOID)
/*  Random computes
     X = (Random1 + Random9)^5
     Random1 = X - FLOOR(X) + 0.000005 * X;
   and returns the new value of Random1
*/
{
	FLOAT X, Y;
	
	X = Random1 + Random9;
	Y = X * X;
	Y = Y * Y;
	X = X * Y;
	Y = X - FLOOR(X);
	Random1 = Y + X * 0.000005;
	return(Random1);
	}

 void
SqXMinX (INT ErrKind)
#ifdef KR_headers
int ErrKind;
#endif
{
	FLOAT XA, XB;
	
	XB = X * BInvrse;
	XA = X - XB;
	SqEr = ((SQRT(X * X) - XB) - XA) / OneUlp;
	if (SqEr != Zero) {
		if (SqEr < MinSqEr) MinSqEr = SqEr;
		if (SqEr > MaxSqEr) MaxSqEr = SqEr;
		J = J + 1.0;
		BadCond(ErrKind, "\n");
		printf("sqrt( %.17e) - %.17e  = %.17e\n", X * X, X, OneUlp * SqEr);
		printf("\tinstead of correct value 0 .\n");
		}
	}

 void
NewD(VOID)
{
	X = Z1 * Q;
	X = FLOOR(Half - X / Radix) * Radix + X;
	Q = (Q - X * Z) / Radix + X * X * (D / Radix);
	Z = Z - Two * X * D;
	if (Z <= Zero) {
		Z = - Z;
		Z1 = - Z1;
		}
	D = Radix * D;
	}

 void
SR3750(VOID)
{
	if (! ((X - Radix < Z2 - Radix) || (X - Z2 > W - Z2))) {
		I = I + 1;
		X2 = SQRT(X * D);
		Y2 = (X2 - Z2) - (Y - Z2);
		X2 = X8 / (Y - Half);
		X2 = X2 - Half * X2 * X2;
		SqEr = (Y2 + Half) + (Half - X2);
		if (SqEr < MinSqEr) MinSqEr = SqEr;
		SqEr = Y2 - X2;
		if (SqEr > MaxSqEr) MaxSqEr = SqEr;
		}
	}

 void
IsYeqX(VOID)
{
	if (Y != X) {
		if (N <= 0) {
			if (Z == Zero && Q <= Zero)
				printf("WARNING:  computing\n");
			else BadCond(Defect, "computing\n");
			printf("\t(%.17e) ^ (%.17e)\n", Z, Q);
			printf("\tyielded %.17e;\n", Y);
			printf("\twhich compared unequal to correct %.17e ;\n",
				X);
			printf("\t\tthey differ by %.17e .\n", Y - X);
			}
		N = N + 1; /* ... count discrepancies. */
		}
	}

 void
SR3980(VOID)
{
	do {
		Q = (FLOAT) I;
		Y = POW(Z, Q);
		IsYeqX();
		if (++I > M) break;
		X = Z * X;
		} while ( X < W );
	}

 void
PrintIfNPositive(VOID)
{
	if (N > 0) printf("Similar discrepancies have occurred %d times.\n", N);
	}

 void
TstPtUf(VOID)
{
	N = 0;
	if (Z != Zero) {
		printf("Since comparison denies Z = 0, evaluating ");
		printf("(Z + Z) / Z should be safe.\n");
		sigsave = sigfpe;
		if (setjmp(ovfl_buf)) goto very_serious;
		Q9 = (Z + Z) / Z;
		printf("What the machine gets for (Z + Z) / Z is  %.17e .\n",
			Q9);
		if (FABS(Q9 - Two) < Radix * U2) {
			printf("This is O.K., provided Over/Underflow");
			printf(" has NOT just been signaled.\n");
			}
		else {
			if ((Q9 < One) || (Q9 > Two)) {
very_serious:
				N = 1;
				ErrCnt [Serious] = ErrCnt [Serious] + 1;
				printf("This is a VERY SERIOUS DEFECT!\n");
				}
			else {
				N = 1;
				ErrCnt [Defect] = ErrCnt [Defect] + 1;
				printf("This is a DEFECT!\n");
				}
			}
		sigsave = 0;
		V9 = Z * One;
		Random1 = V9;
		V9 = One * Z;
		Random2 = V9;
		V9 = Z / One;
		if ((Z == Random1) && (Z == Random2) && (Z == V9)) {
			if (N > 0) Pause();
			}
		else {
			N = 1;
			BadCond(Defect, "What prints as Z = ");
			printf("%.17e\n\tcompares different from  ", Z);
			if (Z != Random1) printf("Z * 1 = %.17e ", Random1);
			if (! ((Z == Random2)
				|| (Random2 == Random1)))
				printf("1 * Z == %g\n", Random2);
			if (! (Z == V9)) printf("Z / 1 = %.17e\n", V9);
			if (Random2 != Random1) {
				ErrCnt [Defect] = ErrCnt [Defect] + 1;
				BadCond(Defect, "Multiplication does not commute!\n");
				printf("\tComparison alleges that 1 * Z = %.17e\n",
					Random2);
				printf("\tdiffers from Z * 1 = %.17e\n", Random1);
				}
			Pause();
			}
		}
	}

 void
notify(CHARP s)
#ifdef KR_headers
 char *s;
#endif
{
	printf("%s test appears to be inconsistent...\n", s);
	printf("   PLEASE NOTIFY KARPINKSI!\n");
	}

