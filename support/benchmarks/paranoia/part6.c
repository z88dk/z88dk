#include "paranoia.h"
void part6(VOID){
	Milestone = 110;
	/*=============================================*/
	printf("Seeking Underflow thresholds UfThold and E0.\n");
	D = U1;
	if (Precision != FLOOR(Precision)) {
		D = BInvrse;
		X = Precision;
		do  {
			D = D * BInvrse;
			X = X - One;
			} while ( X > Zero);
		}
	Y = One;
	Z = D;
	/* ... D is power of 1/Radix < 1. */
	do  {
		C = Y;
		Y = Z;
		Z = Y * Y;
		} while ((Y > Z) && (Z + Z > Z));
	Y = C;
	Z = Y * D;
	do  {
		C = Y;
		Y = Z;
		Z = Y * D;
		} while ((Y > Z) && (Z + Z > Z));
	if (Radix < Two) HInvrse = Two;
	else HInvrse = Radix;
	H = One / HInvrse;
	/* ... 1/HInvrse == H == Min(1/Radix, 1/2) */
	CInvrse = One / C;
	E0 = C;
	Z = E0 * H;
	/* ...1/Radix^(BIG Integer) << 1 << CInvrse == 1/C */
	do  {
		Y = E0;
		E0 = Z;
		Z = E0 * H;
		} while ((E0 > Z) && (Z + Z > Z));
	UfThold = E0;
	E1 = Zero;
	Q = Zero;
	E9 = U2;
	S = One + E9;
	D = C * S;
	if (D <= C) {
		E9 = Radix * U2;
		S = One + E9;
		D = C * S;
		if (D <= C) {
			BadCond(Failure, "multiplication gets too many last digits wrong.\n");
			Underflow = E0;
			Y1 = Zero;
			PseudoZero = Z;
			Pause();
			}
		}
	else {
		Underflow = D;
		PseudoZero = Underflow * H;
		UfThold = Zero;
		do  {
			Y1 = Underflow;
			Underflow = PseudoZero;
			if (E1 + E1 <= E1) {
				Y2 = Underflow * HInvrse;
				E1 = FABS(Y1 - Y2);
				Q = Y1;
				if ((UfThold == Zero) && (Y1 != Y2)) UfThold = Y1;
				}
			PseudoZero = PseudoZero * H;
			} while ((Underflow > PseudoZero)
				&& (PseudoZero + PseudoZero > PseudoZero));
		}
	/* Comment line 4530 .. 4560 */
	if (PseudoZero != Zero) {
		printf("\n");
		Z = PseudoZero;
	/* ... Test PseudoZero for "phoney- zero" violates */
	/* ... PseudoZero < Underflow or PseudoZero < PseudoZero + PseudoZero
		   ... */
		if (PseudoZero <= Zero) {
			BadCond(Failure, "Positive expressions can underflow to an\n");
			printf("allegedly negative value\n");
			printf("PseudoZero that prints out as: %g .\n", PseudoZero);
			X = - PseudoZero;
			if (X <= Zero) {
				printf("But -PseudoZero, which should be\n");
				printf("positive, isn't; it prints out as  %g .\n", X);
				}
			}
		else {
			BadCond(Flaw, "Underflow can stick at an allegedly positive\n");
			printf("value PseudoZero that prints out as %g .\n", PseudoZero);
			}
		TstPtUf();
		}
	/*=============================================*/
	Milestone = 120;
	/*=============================================*/
	if (CInvrse * Y > CInvrse * Y1) {
		S = H * S;
		E0 = Underflow;
		}
	if (! ((E1 == Zero) || (E1 == E0))) {
		BadCond(Defect, "");
		if (E1 < E0) {
			printf("Products underflow at a higher");
			printf(" threshold than differences.\n");
			if (PseudoZero == Zero) 
			E0 = E1;
			}
		else {
			printf("Difference underflows at a higher");
			printf(" threshold than products.\n");
			}
		}
	printf("Smallest strictly positive number found is E0 = %g .\n", E0);
	Z = E0;
	TstPtUf();
	Underflow = E0;
	if (N == 1) Underflow = Y;
	I = 4;
	if (E1 == Zero) I = 3;
	if (UfThold == Zero) I = I - 2;
	UfNGrad = True;
	switch (I)  {
		case	1:
		UfThold = Underflow;
		if ((CInvrse * Q) != ((CInvrse * Y) * S)) {
			UfThold = Y;
			BadCond(Failure, "Either accuracy deteriorates as numbers\n");
			printf("approach a threshold = %.17e\n", UfThold);;
			printf(" coming down from %.17e\n", C);
			printf(" or else multiplication gets too many last digits wrong.\n");
			}
		Pause();
		break;
	
		case	2:
		BadCond(Failure, "Underflow confuses Comparison, which alleges that\n");
		printf("Q == Y while denying that |Q - Y| == 0; these values\n");
		printf("print out as Q = %.17e, Y = %.17e .\n", Q, Y2);
		printf ("|Q - Y| = %.17e .\n" , FABS(Q - Y2));
		UfThold = Q;
		break;
	
		case	3:
		X = X;
		break;
	
		case	4:
		if ((Q == UfThold) && (E1 == E0)
			&& (FABS( UfThold - E1 / E9) <= E1)) {
			UfNGrad = False;
			printf("Underflow is gradual; it incurs Absolute Error =\n");
			printf("(roundoff in UfThold) < E0.\n");
			Y = E0 * CInvrse;
			Y = Y * (OneAndHalf + U2);
			X = CInvrse * (One + U2);
			Y = Y / X;
			IEEE = (Y == E0);
			}
		}
	if (UfNGrad) {
		printf("\n");
		sigsave = sigfpe;
		if (setjmp(ovfl_buf)) {
			printf("Underflow / UfThold failed!\n");
			R = H + H;
			}
		else R = SQRT(Underflow / UfThold);
		sigsave = 0;
		if (R <= H) {
			Z = R * UfThold;
			X = Z * (One + R * H * (One + H));
			}
		else {
			Z = UfThold;
			X = Z * (One + H * H * (One + H));
			}
		if (! ((X == Z) || (X - Z != Zero))) {
			BadCond(Flaw, "");
			printf("X = %.17e\n\tis not equal to Z = %.17e .\n", X, Z);
			Z9 = X - Z;
			printf("yet X - Z yields %.17e .\n", Z9);
			printf("    Should this NOT signal Underflow, ");
			printf("this is a SERIOUS DEFECT\nthat causes ");
			printf("confusion when innocent statements like\n");;
			printf("    if (X == Z)  ...  else");
			printf("  ... (f(X) - f(Z)) / (X - Z) ...\n");
			printf("encounter Division by Zero although actually\n");
			sigsave = sigfpe;
			if (setjmp(ovfl_buf)) printf("X / Z fails!\n");
			else printf("X / Z = 1 + %g .\n", (X / Z - Half) - Half);
			sigsave = 0;
			}
		}
	printf("The Underflow threshold is %.17e, %s\n", UfThold,
		   " below which");
	printf("calculation may suffer larger Relative error than ");
	printf("merely roundoff.\n");
	Y2 = U1 * U1;
	Y = Y2 * Y2;
	Y2 = Y * U1;
	if (Y2 <= UfThold) {
		if (Y > E0) {
			BadCond(Defect, "");
			I = 5;
			}
		else {
			BadCond(Serious, "");
			I = 4;
			}
		printf("Range is too narrow; U1^%d Underflows.\n", I);
		}
	/*=============================================*/
	}
