#include "paranoia.h"
void part7(VOID){
	Milestone = 130;
	/*=============================================*/
	Y = - FLOOR(Half - TwoForty * LOG(UfThold) / LOG(HInvrse)) / TwoForty;
	Y2 = Y + Y;
	printf("Since underflow occurs below the threshold\n");
	printf("UfThold = (%.17e) ^ (%.17e)\nonly underflow ", HInvrse, Y);
	printf("should afflict the expression\n\t(%.17e) ^ (%.17e);\n",
		HInvrse, Y2);
	printf("actually calculating yields:");
	if (setjmp(ovfl_buf)) {
		sigsave = 0;
		BadCond(Serious, "trap on underflow.\n");
		}
	else {
		sigsave = sigfpe;
		V9 = POW(HInvrse, Y2);
		sigsave = 0;
		printf(" %.17e .\n", V9);
		if (! ((V9 >= Zero) && (V9 <= (Radix + Radix + E9) * UfThold))) {
			BadCond(Serious, "this is not between 0 and underflow\n");
		printf("   threshold = %.17e .\n", UfThold);
		}
		else if (! (V9 > UfThold * (One + E9)))
			printf("This computed value is O.K.\n");
		else {
			BadCond(Defect, "this is not between 0 and underflow\n");
			printf("   threshold = %.17e .\n", UfThold);
			}
		}
	/*=============================================*/
	Milestone = 140;
	/*=============================================*/
	printf("\n");
	/* ...calculate Exp2 == exp(2) == 7.389056099... */
	X = Zero;
	I = 2;
	Y = Two * Three;
	Q = Zero;
	N = 0;
	do  {
		Z = X;
		I = I + 1;
		Y = Y / (I + I);
		R = Y + Q;
		X = Z + R;
		Q = (Z - X) + R;
		} while(X > Z);
	Z = (OneAndHalf + One / Eight) + X / (OneAndHalf * ThirtyTwo);
	X = Z * Z;
	Exp2 = X * X;
	X = F9;
	Y = X - U1;
	printf("Testing X^((X + 1) / (X - 1)) vs. exp(2) = %.17e as X -> 1.\n",
		Exp2);
	for(I = 1;;) {
		Z = X - BInvrse;
		Z = (X + One) / (Z - (One - BInvrse));
		Q = POW(X, Z) - Exp2;
		if (FABS(Q) > TwoForty * U2) {
			N = 1;
	 		V9 = (X - BInvrse) - (One - BInvrse);
			BadCond(Defect, "Calculated");
			printf(" %.17e for\n", POW(X,Z));
			printf("\t(1 + (%.17e) ^ (%.17e);\n", V9, Z);
			printf("\tdiffers from correct value by %.17e .\n", Q);
			printf("\tThis much error may spoil financial\n");
			printf("\tcalculations involving tiny interest rates.\n");
			break;
			}
		else {
			Z = (Y - X) * Two + Y;
			X = Y;
			Y = Z;
			Z = One + (X - F9)*(X - F9);
			if (Z > One && I < NoTrials) I++;
			else  {
				if (X > One) {
					if (N == 0)
					   printf("Accuracy seems adequate.\n");
					break;
					}
				else {
					X = One + U2;
					Y = U2 + U2;
					Y += X;
					I = 1;
					}
				}
			}
		}
	/*=============================================*/
	Milestone = 150;
	/*=============================================*/
	printf("Testing powers Z^Q at four nearly extreme values.\n");
	N = 0;
	Z = A1;
	Q = FLOOR(Half - LOG(C) / LOG(A1));
	Break = False;
	do  {
		X = CInvrse;
		Y = POW(Z, Q);
		IsYeqX();
		Q = - Q;
		X = C;
		Y = POW(Z, Q);
		IsYeqX();
		if (Z < One) Break = True;
		else Z = AInvrse;
		} while ( ! (Break));
	PrintIfNPositive();
	if (N == 0) printf(" ... no discrepancies found.\n");
	printf("\n");
	
	/*=============================================*/
	Milestone = 160;
	/*=============================================*/
	Pause();
	printf("Searching for Overflow threshold:\n");
	printf("This may generate an error.\n");
	Y = - CInvrse;
	V9 = HInvrse * Y;
	sigsave = sigfpe;
	if (setjmp(ovfl_buf)) { I = 0; V9 = Y; goto overflow; }
	do {
		V = Y;
		Y = V9;
		V9 = HInvrse * Y;
		} while(V9 < Y);
	I = 1;
overflow:
	sigsave = 0;
	Z = V9;
	printf("Can `Z = -Y' overflow?\n");
	printf("Trying it on Y = %.17e .\n", Y);
	V9 = - Y;
	V0 = V9;
	if (V - Y == V + V0) printf("Seems O.K.\n");
	else {
		printf("finds a ");
		BadCond(Flaw, "-(-Y) differs from Y.\n");
		}
	if (Z != Y) {
		BadCond(Serious, "");
		printf("overflow past %.17e\n\tshrinks to %.17e .\n", Y, Z);
		}
	if (I) {
		Y = V * (HInvrse * U2 - HInvrse);
		Z = Y + ((One - HInvrse) * U2) * V;
		if (Z < V0) Y = Z;
		if (Y < V0) V = Y;
		if (V0 - V < V0) V = V0;
		}
	else {
		V = Y * (HInvrse * U2 - HInvrse);
		V = V + ((One - HInvrse) * U2) * Y;
		}
	printf("Overflow threshold is V  = %.17e .\n", V);
	if (I) printf("Overflow saturates at V0 = %.17e .\n", V0);
	else printf("There is no saturation value because \
the system traps on overflow.\n");
	V9 = V * One;
	printf("No Overflow should be signaled for V * 1 = %.17e\n", V9);
	V9 = V / One;
	printf("                           nor for V / 1 = %.17e .\n", V9);
	printf("Any overflow signal separating this * from the one\n");
	printf("above is a DEFECT.\n");
	/*=============================================*/
	Milestone = 170;
	/*=============================================*/
	if (!(-V < V && -V0 < V0 && -UfThold < V && UfThold < V)) {
		BadCond(Failure, "Comparisons involving ");
		printf("+-%g, +-%g\nand +-%g are confused by Overflow.",
			V, V0, UfThold);
		}
	/*=============================================*/
	Milestone = 175;
	/*=============================================*/
	printf("\n");
	for(Indx = 1; Indx <= 3; ++Indx) {
		switch (Indx)  {
			case 1: Z = UfThold; break;
			case 2: Z = E0; break;
			case 3: Z = PseudoZero; break;
			}
		if (Z != Zero) {
			V9 = SQRT(Z);
			Y = V9 * V9;
			if (Y / (One - Radix * E9) < Z
			   || Y > (One + Radix * E9) * Z) { /* dgh: + E9 --> * E9 */
				if (V9 > U1) BadCond(Serious, "");
				else BadCond(Defect, "");
				printf("Comparison alleges that what prints as Z = %.17e\n", Z);
				printf(" is too far from sqrt(Z) ^ 2 = %.17e .\n", Y);
				}
			}
		}
	/*=============================================*/
	Milestone = 180;
	/*=============================================*/
	for(Indx = 1; Indx <= 2; ++Indx) {
		if (Indx == 1) Z = V;
		else Z = V0;
		V9 = SQRT(Z);
		X = (One - Radix * E9) * V9;
		V9 = V9 * X;
		if (((V9 < (One - Two * Radix * E9) * Z) || (V9 > Z))) {
			Y = V9;
			if (X < W) BadCond(Serious, "");
			else BadCond(Defect, "");
			printf("Comparison alleges that Z = %17e\n", Z);
			printf(" is too far from sqrt(Z) ^ 2 (%.17e) .\n", Y);
			}
		}
	/*=============================================*/
	}
