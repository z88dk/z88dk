#include "paranoia.h"
void part4(VOID){
	Milestone = 50;
	/*=============================================*/
	TstCond (Failure, ((F9 + U1) - Half == Half)
		   && ((BMinusU2 + U2 ) - One == Radix - One),
		   "Incomplete carry-propagation in Addition");
	X = One - U1 * U1;
	Y = One + U2 * (One - U2);
	Z = F9 - Half;
	X = (X - Half) - Z;
	Y = Y - One;
	if ((X == Zero) && (Y == Zero)) {
		RAddSub = Chopped;
		printf("Add/Subtract appears to be chopped.\n");
		}
	if (GAddSub == Yes) {
		X = (Half + U2) * U2;
		Y = (Half - U2) * U2;
		X = One + X;
		Y = One + Y;
		X = (One + U2) - X;
		Y = One - Y;
		if ((X == Zero) && (Y == Zero)) {
			X = (Half + U2) * U1;
			Y = (Half - U2) * U1;
			X = One - X;
			Y = One - Y;
			X = F9 - X;
			Y = One - Y;
			if ((X == Zero) && (Y == Zero)) {
				RAddSub = Rounded;
				printf("Addition/Subtraction appears to round correctly.\n");
				if (GAddSub == No) notify("Add/Subtract");
				}
			else printf("Addition/Subtraction neither rounds nor chops.\n");
			}
		else printf("Addition/Subtraction neither rounds nor chops.\n");
		}
	else printf("Addition/Subtraction neither rounds nor chops.\n");
	S = One;
	X = One + Half * (One + Half);
	Y = (One + U2) * Half;
	Z = X - Y;
	T = Y - X;
	StickyBit = Z + T;
	if (StickyBit != Zero) {
		S = Zero;
		BadCond(Flaw, "(X - Y) + (Y - X) is non zero!\n");
		}
	StickyBit = Zero;
	if ((GMult == Yes) && (GDiv == Yes) && (GAddSub == Yes)
		&& (RMult == Rounded) && (RDiv == Rounded)
		&& (RAddSub == Rounded) && (FLOOR(RadixD2) == RadixD2)) {
		printf("Checking for sticky bit.\n");
		X = (Half + U1) * U2;
		Y = Half * U2;
		Z = One + Y;
		T = One + X;
		if ((Z - One <= Zero) && (T - One >= U2)) {
			Z = T + Y;
			Y = Z - X;
			if ((Z - T >= U2) && (Y - T == Zero)) {
				X = (Half + U1) * U1;
				Y = Half * U1;
				Z = One - Y;
				T = One - X;
				if ((Z - One == Zero) && (T - F9 == Zero)) {
					Z = (Half - U1) * U1;
					T = F9 - Z;
					Q = F9 - Y;
					if ((T - F9 == Zero) && (F9 - U1 - Q == Zero)) {
						Z = (One + U2) * OneAndHalf;
						T = (OneAndHalf + U2) - Z + U2;
						X = One + Half / Radix;
						Y = One + Radix * U2;
						Z = X * Y;
						if (T == Zero && X + Radix * U2 - Z == Zero) {
							if (Radix != Two) {
								X = Two + U2;
								Y = X / Two;
								if ((Y - One == Zero)) StickyBit = S;
								}
							else StickyBit = S;
							}
						}
					}
				}
			}
		}
	if (StickyBit == One) printf("Sticky bit apparently used correctly.\n");
	else printf("Sticky bit used incorrectly or not at all.\n");
	TstCond (Flaw, !(GMult == No || GDiv == No || GAddSub == No ||
			RMult == Other || RDiv == Other || RAddSub == Other),
		"lack(s) of guard digits or failure(s) to correctly round or chop\n\
(noted above) count as one flaw in the final tally below");
	/*=============================================*/
	Milestone = 60;
	/*=============================================*/
	printf("\n");
	printf("Does Multiplication commute?  ");
	printf("Testing on %d random pairs.\n", NoTrials);
	Random9 = SQRT(3.0);
	Random1 = Third;
	I = 1;
	do  {
		X = Random();
		Y = Random();
		Z9 = Y * X;
		Z = X * Y;
		Z9 = Z - Z9;
		I = I + 1;
		} while ( ! ((I > NoTrials) || (Z9 != Zero)));
	if (I == NoTrials) {
		Random1 = One + Half / Three;
		Random2 = (U2 + U1) + One;
		Z = Random1 * Random2;
		Y = Random2 * Random1;
		Z9 = (One + Half / Three) * ((U2 + U1) + One) - (One + Half /
			Three) * ((U2 + U1) + One);
		}
	if (! ((I == NoTrials) || (Z9 == Zero)))
		BadCond(Defect, "X * Y == Y * X trial fails.\n");
	else printf("     No failures found in %d integer pairs.\n", NoTrials);
	/*=============================================*/
	Milestone = 70;
	/*=============================================*/
	printf("\nRunning test of square root(x).\n");
	TstCond (Failure, (Zero == SQRT(Zero))
		   && (- Zero == SQRT(- Zero))
		   && (One == SQRT(One)), "Square root of 0.0, -0.0 or 1.0 wrong");
	MinSqEr = Zero;
	MaxSqEr = Zero;
	J = Zero;
	X = Radix;
	OneUlp = U2;
	SqXMinX (Serious);
	X = BInvrse;
	OneUlp = BInvrse * U1;
	SqXMinX (Serious);
	X = U1;
	OneUlp = U1 * U1;
	SqXMinX (Serious);
	if (J != Zero) Pause();
	printf("Testing if sqrt(X * X) == X for %d Integers X.\n", NoTrials);
	J = Zero;
	X = Two;
	Y = Radix;
	if ((Radix != One)) do  {
		X = Y;
		Y = Radix * Y;
		} while ( ! ((Y - X >= NoTrials)));
	OneUlp = X * U2;
	I = 1;
	while (I <= NoTrials) {
		X = X + One;
		SqXMinX (Defect);
		if (J > Zero) break;
		I = I + 1;
		}
	printf("Test for sqrt monotonicity.\n");
	I = - 1;
	X = BMinusU2;
	Y = Radix;
	Z = Radix + Radix * U2;
	NotMonot = False;
	Monot = False;
	while ( ! (NotMonot || Monot)) {
		I = I + 1;
		X = SQRT(X);
		Q = SQRT(Y);
		Z = SQRT(Z);
		if ((X > Q) || (Q > Z)) NotMonot = True;
		else {
			Q = FLOOR(Q + Half);
			if (!(I > 0 || Radix == Q * Q)) Monot = True;
			else if (I > 0) {
			if (I > 1) Monot = True;
			else {
				Y = Y * BInvrse;
				X = Y - U1;
				Z = Y + U1;
				}
			}
			else {
				Y = Q;
				X = Y - U2;
				Z = Y + U2;
				}
			}
		}
	if (Monot) printf("sqrt has passed a test for Monotonicity.\n");
	else {
		BadCond(Defect, "");
		printf("sqrt(X) is non-monotonic for X near %.7e .\n", Y);
		}
	/*=============================================*/
	}
