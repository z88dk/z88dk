#include "paranoia.h"
int part8(VOID){
	Milestone = 190;
	/*=============================================*/
	Pause();
	X = UfThold * V;
	Y = Radix * Radix;
	if (X*Y < One || X > Y) {
		if (X * Y < U1 || X > Y/U1) BadCond(Defect, "Badly");
		else BadCond(Flaw, "");
			
		printf(" unbalanced range; UfThold * V = %.17e\n\t%s\n",
			X, "is too far from 1.\n");
		}
	/*=============================================*/
	Milestone = 200;
	/*=============================================*/
	for (Indx = 1; Indx <= 5; ++Indx)  {
		X = F9;
		switch (Indx)  {
			case 2: X = One + U2; break;
			case 3: X = V; break;
			case 4: X = UfThold; break;
			case 5: X = Radix;
			}
		Y = X;
		sigsave = sigfpe;
		if (setjmp(ovfl_buf))
			printf("  X / X  traps when X = %g\n", X);
		else {
			V9 = (Y / X - Half) - Half;
			if (V9 == Zero) continue;
			if (V9 == - U1 && Indx < 5) BadCond(Flaw, "");
			else BadCond(Serious, "");
			printf("  X / X differs from 1 when X = %.17e\n", X);
			printf("  instead, X / X - 1/2 - 1/2 = %.17e .\n", V9);
			}
		sigsave = 0;
		}
	/*=============================================*/
	Milestone = 210;
	/*=============================================*/
	MyZero = Zero;
	printf("\n");
	printf("What message and/or values does Division by Zero produce?\n") ;
#ifndef NOPAUSE
	printf("This can interupt your program.  You can ");
	printf("skip this part if you wish.\n");
	printf("Do you wish to compute 1 / 0? ");
	fflush(stdout);
	read (KEYBOARD, ch, 8);
	if ((ch[0] == 'Y') || (ch[0] == 'y')) {
#endif
		sigsave = sigfpe;
		printf("    Trying to compute 1 / 0 produces ...");
		if (!setjmp(ovfl_buf)) printf("  %.7e .\n", One / MyZero);
		sigsave = 0;
#ifndef NOPAUSE
		}
	else printf("O.K.\n");
	printf("\nDo you wish to compute 0 / 0? ");
	fflush(stdout);
	read (KEYBOARD, ch, 80);
	if ((ch[0] == 'Y') || (ch[0] == 'y')) {
#endif
		sigsave = sigfpe;
		printf("\n    Trying to compute 0 / 0 produces ...");
		if (!setjmp(ovfl_buf)) printf("  %.7e .\n", Zero / MyZero);
		sigsave = 0;
#ifndef NOPAUSE
		}
	else printf("O.K.\n");
#endif
	/*=============================================*/
	Milestone = 220;
	/*=============================================*/
	Pause();
	printf("\n");
	{
		static char *msg[] = {
			"FAILUREs  encountered =",
			"SERIOUS DEFECTs  discovered =",
			"DEFECTs  discovered =",
			"FLAWs  discovered =" };
		int i;
		for(i = 0; i < 4; i++) if (ErrCnt[i])
			printf("The number of  %-29s %d.\n",
				msg[i], ErrCnt[i]);
		}
	printf("\n");
	if ((ErrCnt[Failure] + ErrCnt[Serious] + ErrCnt[Defect]
			+ ErrCnt[Flaw]) > 0) {
		if ((ErrCnt[Failure] + ErrCnt[Serious] + ErrCnt[
			Defect] == 0) && (ErrCnt[Flaw] > 0)) {
			printf("The arithmetic diagnosed seems ");
			printf("Satisfactory though flawed.\n");
			}
		if ((ErrCnt[Failure] + ErrCnt[Serious] == 0)
			&& ( ErrCnt[Defect] > 0)) {
			printf("The arithmetic diagnosed may be Acceptable\n");
			printf("despite inconvenient Defects.\n");
			}
		if ((ErrCnt[Failure] + ErrCnt[Serious]) > 0) {
			printf("The arithmetic diagnosed has ");
			printf("unacceptable Serious Defects.\n");
			}
		if (ErrCnt[Failure] > 0) {
			printf("Potentially fatal FAILURE may have spoiled this");
			printf(" program's subsequent diagnoses.\n");
			}
		}
	else {
		printf("No failures, defects nor flaws have been discovered.\n");
		if (! ((RMult == Rounded) && (RDiv == Rounded)
			&& (RAddSub == Rounded) && (RSqrt == Rounded))) 
			printf("The arithmetic diagnosed seems Satisfactory.\n");
		else {
			if (StickyBit >= One &&
				(Radix - Two) * (Radix - Nine - One) == Zero) {
				printf("Rounding appears to conform to ");
				printf("the proposed IEEE standard P");
				if ((Radix == Two) &&
					 ((Precision - Four * Three * Two) *
					  ( Precision - TwentySeven -
					   TwentySeven + One) == Zero)) 
					printf("754");
				else printf("854");
				if (IEEE) printf(".\n");
				else {
					printf(",\nexcept for possibly Double Rounding");
					printf(" during Gradual Underflow.\n");
					}
				}
			printf("The arithmetic diagnosed appears to be Excellent!\n");
			}
		}
	if (fpecount)
		printf("\nA total of %d floating point exceptions were registered.\n",
			fpecount);
	printf("END OF TEST.\n");
	return 0;
	}

