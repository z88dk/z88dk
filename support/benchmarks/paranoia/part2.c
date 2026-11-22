#include "paranoia.h"
void part2(VOID){
	Milestone = 10;
	/*=============================================*/
	TstCond (Failure, (Nine == Three * Three)
		   && (TwentySeven == Nine * Three) && (Eight == Four + Four)
		   && (ThirtyTwo == Eight * Four)
		   && (ThirtyTwo - TwentySeven - Four - One == Zero),
		   "9 != 3*3, 27 != 9*3, 32 != 8*4, or 32-27-4-1 != 0");
	TstCond (Failure, (Five == Four + One) &&
			(TwoForty == Four * Five * Three * Four)
		   && (TwoForty / Three - Four * Four * Five == Zero)
		   && ( TwoForty / Four - Five * Three * Four == Zero)
		   && ( TwoForty / Five - Four * Three * Four == Zero),
		  "5 != 4+1, 240/3 != 80, 240/4 != 60, or 240/5 != 48");
	if (ErrCnt[Failure] == 0) {
		printf("-1, 0, 1/2, 1, 2, 3, 4, 5, 9, 27, 32 & 240 are O.K.\n");
		printf("\n");
		}
	printf("Searching for Radix and Precision.\n");
	W = One;
	do  {
		W = W + W;
		Y = W + One;
		Z = Y - W;
		Y = Z - One;
		} while (MinusOne + FABS(Y) < Zero);
	/*.. now W is just big enough that |((W+1)-W)-1| >= 1 ...*/
	Precision = Zero;
	Y = One;
	do  {
		Radix = W + Y;
		Y = Y + Y;
		Radix = Radix - W;
		} while ( Radix == Zero);
	if (Radix < Two) Radix = One;
	printf("Radix = %f .\n", Radix);
	if (Radix != 1) {
		W = One;
		do  {
			Precision = Precision + One;
			W = W * Radix;
			Y = W + One;
			} while ((Y - W) == One);
		}
	/*... now W == Radix^Precision is barely too big to satisfy (W+1)-W == 1
			                              ...*/
	U1 = One / W;
	U2 = Radix * U1;
	printf("Closest relative separation found is U1 = %.7e .\n\n", U1);
	printf("Recalculating radix and precision\n ");
	
	/*save old values*/
	E0 = Radix;
	E1 = U1;
	E9 = U2;
	E3 = Precision;
	
	X = Four / Three;
	Third = X - One;
	F6 = Half - Third;
	X = F6 + F6;
	X = FABS(X - Third);
	if (X < U2) X = U2;
	
	/*... now X = (unknown no.) ulps of 1+...*/
	do  {
		U2 = X;
		Y = Half * U2 + ThirtyTwo * U2 * U2;
		Y = One + Y;
		X = Y - One;
		} while ( ! ((U2 <= X) || (X <= Zero)));
	
	/*... now U2 == 1 ulp of 1 + ... */
	X = Two / Three;
	F6 = X - Half;
	Third = F6 + F6;
	X = Third - Half;
	X = FABS(X + F6);
	if (X < U1) X = U1;
	
	/*... now  X == (unknown no.) ulps of 1 -... */
	do  {
		U1 = X;
		Y = Half * U1 + ThirtyTwo * U1 * U1;
		Y = Half - Y;
		X = Half + Y;
		Y = Half - X;
		X = Half + Y;
		} while ( ! ((U1 <= X) || (X <= Zero)));
	/*... now U1 == 1 ulp of 1 - ... */
	if (U1 == E1) printf("confirms closest relative separation U1 .\n");
	else printf("gets better closest relative separation U1 = %.7e .\n", U1);
	W = One / U1;
	F9 = (Half - U1) + Half;
	Radix = FLOOR(0.01 + U2 / U1);
	if (Radix == E0) printf("Radix confirmed.\n");
	else printf("MYSTERY: recalculated Radix = %.7e .\n", Radix);
	TstCond (Defect, Radix <= Eight + Eight,
		   "Radix is too big: roundoff problems");
	TstCond (Flaw, (Radix == Two) || (Radix == 10)
		   || (Radix == One), "Radix is not as good as 2 or 10");
	/*=============================================*/
	Milestone = 20;
	/*=============================================*/
	TstCond (Failure, F9 - Half < Half,
		   "(1-U1)-1/2 < 1/2 is FALSE, prog. fails?");
	X = F9;
	I = 1;
	Y = X - Half;
	Z = Y - Half;
	TstCond (Failure, (X != One)
		   || (Z == Zero), "Comparison is fuzzy,X=1 but X-1/2-1/2 != 0");
	X = One + U2;
	I = 0;
	/*=============================================*/
	Milestone = 25;
	/*=============================================*/
	/*... BMinusU2 = nextafter(Radix, 0) */
	BMinusU2 = Radix - One;
	BMinusU2 = (BMinusU2 - U2) + One;
	/* Purify Integers */
	if (Radix != One)  {
		X = - TwoForty * LOG(U1) / LOG(Radix);
		Y = FLOOR(Half + X);
		if (FABS(X - Y) * Four < One) X = Y;
		Precision = X / TwoForty;
		Y = FLOOR(Half + Precision);
		if (FABS(Precision - Y) * TwoForty < Half) Precision = Y;
		}
	if ((Precision != FLOOR(Precision)) || (Radix == One)) {
		printf("Precision cannot be characterized by an Integer number\n");
		printf("of significant digits but, by itself, this is a minor flaw.\n");
		}
	if (Radix == One) 
		printf("logarithmic encoding has precision characterized solely by U1.\n");
	else printf("The number of significant digits of the Radix is %f .\n",
			Precision);
	TstCond (Serious, U2 * Nine * Nine * TwoForty < One,
		   "Precision worse than 5 decimal figures  ");
	/*=============================================*/
	Milestone = 30;
	/*=============================================*/
	/* Test for extra-precise subepressions */
	X = FABS(((Four / Three - One) - One / Four) * Three - One / Four);
	do  {
		Z2 = X;
		X = (One + (Half * Z2 + ThirtyTwo * Z2 * Z2)) - One;
		} while ( ! ((Z2 <= X) || (X <= Zero)));
	X = Y = Z = FABS((Three / Four - Two / Three) * Three - One / Four);
	do  {
		Z1 = Z;
		Z = (One / Two - ((One / Two - (Half * Z1 + ThirtyTwo * Z1 * Z1))
			+ One / Two)) + One / Two;
		} while ( ! ((Z1 <= Z) || (Z <= Zero)));
	do  {
		do  {
			Y1 = Y;
			Y = (Half - ((Half - (Half * Y1 + ThirtyTwo * Y1 * Y1)) + Half
				)) + Half;
			} while ( ! ((Y1 <= Y) || (Y <= Zero)));
		X1 = X;
		X = ((Half * X1 + ThirtyTwo * X1 * X1) - F9) + F9;
		} while ( ! ((X1 <= X) || (X <= Zero)));
	if ((X1 != Y1) || (X1 != Z1)) {
		BadCond(Serious, "Disagreements among the values X1, Y1, Z1,\n");
		printf("respectively  %.7e,  %.7e,  %.7e,\n", X1, Y1, Z1);
		printf("are symptoms of inconsistencies introduced\n");
		printf("by extra-precise evaluation of arithmetic subexpressions.\n");
		notify("Possibly some part of this");
		if ((X1 == U1) || (Y1 == U1) || (Z1 == U1))  printf(
			"That feature is not tested further by this program.\n") ;
		}
	else  {
		if ((Z1 != U1) || (Z2 != U2)) {
			if ((Z1 >= U1) || (Z2 >= U2)) {
				BadCond(Failure, "");
				notify("Precision");
				printf("\tU1 = %.7e, Z1 - U1 = %.7e\n",U1,Z1-U1);
				printf("\tU2 = %.7e, Z2 - U2 = %.7e\n",U2,Z2-U2);
				}
			else {
				if ((Z1 <= Zero) || (Z2 <= Zero)) {
					printf("Because of unusual Radix = %f", Radix);
					printf(", or exact rational arithmetic a result\n");
					printf("Z1 = %.7e, or Z2 = %.7e ", Z1, Z2);
					notify("of an\nextra-precision");
					}
				if (Z1 != Z2 || Z1 > Zero) {
					X = Z1 / U1;
					Y = Z2 / U2;
					if (Y > X) X = Y;
					Q = - LOG(X);
					printf("Some subexpressions appear to be calculated extra\n");
					printf("precisely with about %g extra B-digits, i.e.\n",
						(Q / LOG(Radix)));
					printf("roughly %g extra significant decimals.\n",
						Q / LOG(10.));
					}
				printf("That feature is not tested further by this program.\n");
				}
			}
		}
	Pause();
	/*=============================================*/
	}
