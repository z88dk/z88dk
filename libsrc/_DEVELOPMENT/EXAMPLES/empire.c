/*
 * E M P I R E
 *
 * (C) CLOAD 1981
 * PETER TREFONAS 12/30/1979
 *
 * Credits:
 *   "Hammurabi" BY RICK MERRIL & DAVID AHL
 *   "Santa Paravia" BY GEORGE BLANK
 *
 * Original version written in Basic for the TRS-80
 * http://willus.com/trs80/?-a+1+-p+125903+-f+4
 *
 * Conversion to C by aralbrec@z88dk.org July 2016
 * (instructions excluded from some builds due to size)
 *
 * zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --opt-code-size empire.c -o empire -lm -create-app -DINSTR
 * zcc +zx -vn -SO3 -startup=4 -clib=sdcc_iy --max-allocs-per-node200000 --opt-code-size empire.c -o empire -lm -create-app -DINSTR
 *
 */

#pragma output CLIB_OPT_PRINTF       = 0x04000201  // %sdf enabled
#pragma output CLIB_OPT_SCANF        = 0x00200201  // %sd[ enabled

#pragma output CLIB_EXIT_STACK_SIZE  = 0
#pragma output CLIB_MALLOC_HEAP_SIZE = 128
#pragma output CLIB_STDIO_HEAP_SIZE  = 0

#ifdef __SPECTRUM

#pragma output CRT_ORG_CODE          = 24000
#pragma output REGISTER_SP           = -1
#pragma output CRT_ENABLE_EIDI       = 0x21

#include <stropts.h>

#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <math.h>
#include <input.h>

char *Z[7][7] = {
   {0, 0, 0, 0, 0, 0, 0},
   {"Montaigne", "Auveyron", "Chevalier", "Prince", "Roi", "Empereur", "francs"},
   {"Arthur", "Brittany", "Sir", "Prince", "King", "Emperor", "francs"},
   {"Munster", "Bavaria", "Ritter", "Prinz", "Konig", "Kaiser", "marks"},
   {"Khotan", "Quatara", "Hasid", "Caliph", "Sheik", "Shah", "dinars"},
   {"Ferdinand", "Barcelona", "Caballero", "Principe", "Rey", "Emperadore", "peseta"},
   {"Hjodolf", "Svealand", "Riddare", "Prins", "Kung", "Kejsare", "krona"}
};

double_t A[7][20] = {
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 },
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 },
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 },
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 },
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 },
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 },
   { 0, 10000, 15000, 2000, 1000, 0, 0, 25, 20, 5, 35, 0, 0, 0, 0, 20, 0, 2, 1, 15 }
};

char buf[64];  // input buffer

double_t BA = 6000.0;   // barbarian land holdings

int FLAG;      // dummy variable

double_t D;    // dummy variable
int E;         // dummy variable
double_t E1;   // dummy variable
double_t E2;   // dummy variable
int H;         // dummy variable
int H1;        // dummy variable
double_t H2;   // dummy variable
double_t H3;   // dummy variable
int I;         // index, dummy variable
double_t I0;
double_t I1;   // dummy variable
double_t I2;   // dummy variable
double_t I3;
double_t I4;
double_t I5;
double_t I6;
double_t I7;
int IH;
int J;         // index, dummy variable
double_t IF;   // dummy variable
int O;
double_t O1;

int KK;        // game over flag
int KL;        // dummy flag
int K;         // current player
int NP;        // number of human players
int NY;        // current year
int NW;        // weather

int IQ;        // number of attacks in round

double_t LA;   // dummy variable
double_t HM;   // grain fed to army
double_t HS;   // grain fed to population
double_t PO;   // non-military population

double_t DB;   // number of births
double_t DD;   // deaths due to disease
double_t DS;   // deaths due to starvation
double_t DE;   // number of immigrants
double_t DM;   // deaths due to malnutrition
double_t DA;   // army deaths due to starvation
double_t PA;   // army desertion?
double_t PT;   // net population change

double_t PD;   // grain required by people
double_t AD;   // grain required by army
double_t HA;   // grain harvested
double_t RA;   // percentage of grain eaten by rats

double_t FC;   // customs tax revenue
double_t FS;   // sales tax revenue
double_t FI;   // income tax revenue

double_t F1;   // marketplace profit
double_t F2;   // grain mill profit
double_t F3;   // foundry profit
double_t F4;   // shipyard profit
double_t F5;   // soldier profit (cost)

int Q;
int QF;        // computer playing flag
int QP;        // count of active players
double_t Q0;   // average totals of active players
double_t Q2;   // average totals of active players
double_t Q3;   // average totals of active players
double_t Q4;   // average totals of active players
double_t Q5;   // average totals of active players
double_t Q6;   // average totals of active players
double_t Q7;   // average totals of active players
double_t Q8;   // average totals of active players
double_t Q9;   // average totals of active players
double_t QB;   // average totals of active players
double_t QC;   // average totals of active players
double_t QD;   // average totals of active players
double_t QR;


void CLS(void)
{
#ifdef __SPECTRUM
   ioctl(1, IOCTL_OTERM_CLS);
#else
   puts("\n\n\n");
#endif
}

double_t RND0(void)
{
   return rand()/(double_t)((unsigned int)RAND_MAX+1);
}

double_t RND(double_t n)
{
   return (n == 0.0) ? RND0() : RND0()*n+1.0;
}

double_t FRND(double_t n)
{
   return floor(RND(n));
}

void PAUSE(unsigned int p)
{
   in_wait_nokey();
   in_pause(p);
   in_wait_nokey();
}

void INPUT(char *p, char *fmt, ...)
{
   va_list arg;
   va_start(arg, fmt);
   
   printf("%s", p);
   in_wait_nokey();
   
   fflush(stdin);
   vscanf(fmt, arg);
}

void player_promotion(void)
{
   // Line 359
   
   if ((int)A[K][0] != 0) return;

   if ((A[K][11] > 7.0) && (A[K][12] > 3.0) && (A[K][16] > 1.0) && (A[K][1]/A[K][3] > 4.8) && (A[K][3] > 2300.0) && (A[K][18] > 10.0))
      A[K][17] = 3.0;
   
   if ((A[K][11] > 13.0) && (A[K][12] > 5.0) && (A[K][13] > 0.0) && (A[K][16] > 5.0) && (A[K][1]/A[K][3] > 5.0) && (A[K][3] > 2600.0) && (A[K][18] > 25.0))
      A[K][17] = 4.0;
   
   if ((A[K][17] > 3.0) && (A[K][16] > 9.0) && (A[K][4] > 3100.0) && (A[K][18] > 40.0))
   {
      CLS();
      
      puts("Game over . . .");
      printf("%s %s of %s Wins !\n\n", Z[K][5], Z[K][0], Z[K][1]);
      
      A[K][17] = 5.0;
      KK = 1;
   }
}

char *udeath[] = {
   "has been assassinated by an ambitious\nnoble.\n",
   "has been killed from a fall during\nthe annual fox-hunt.\n",
   "died of acute food poisoning.\nThe royal cook was summarily executed.\n",
   "passed away this winter from a weak heart.\n"
};

void unfortunate_death(int flag)
{
   CLS();

   puts("Very sad news ...\n");
   printf("%s %s ", Z[K][(int)A[K][17]], Z[K][0]);

   if (flag)
      printf("of %s has been assassinated\nby a crazed mother whose child had starved to death . . .\n\n", Z[K][1]);
   else
      puts(udeath[(int)RND(4.0)-1]);
   
   puts("The other nation-states have sent representatives to the\nfuneral.\n");
   PAUSE(10000);
      
   A[K][0] = 1.0;
}

void print_battle_report(void)
{
   CLS();
   
   printf("Land holdings:\n\n%-16s%10.0f\n", "1)  Barbarians", BA);
   for (I=1; I<=6; ++I)
      if ((int)A[I][0] == 0) printf("%d)  %-12s%10.0f\n", I+1, Z[I][1], A[I][1]);
}

void exit_qf(int flag)
{
   if (flag == 1)
      PAUSE(15000);
   else
   {
      puts("<Enter>");
      PAUSE(30000);
   }
}

void battle(void)
{
   // Line 279
   
   CLS();
   printf("%41s\n\n", "Soldiers Remaining");
   
   snprintf(buf, sizeof(buf), "%s %s of %s", Z[K][(int)A[K][17]], Z[K][0], Z[K][1]);
   printf("%*s\n%33s\n", (64+strlen(buf))/2, buf, "VS");
   
   I4 = A[K][19];
   I5 = 0.0;
   I2 = A[I][15];
   I0 = A[I][1];
   O1 = 75.0 - I1 - I2;

   A[K][15] -= I1;

   if (I == 0)
   {
      printf("%40s\n\n", "Pagan barbarians");
      
      I2 = RND(RND(I1)*3) + RND(RND(I1*1.5));
      I3 = 9.0;
      I0 = BA;
      O1 = 75.0 - I1 - I2;
   }
   else
   {
      snprintf(buf, sizeof(buf), "%s %s of %s", Z[I][(int)A[I][17]], Z[I][0], Z[I][1]);
      printf("%*s\n", (64+strlen(buf))/2, buf);
      
      I3 = A[I][19];
      IH = 0;
      
      if (A[I][15] < 1.0)
      {
         snprintf(buf, sizeof(buf), "%s's serfs are forced to defend their country!", Z[I][1]);
         printf("%*s\n", (64+strlen(buf))/2, buf);
         
         I2 = A[I][3];
         I3 = 5.0;
         IH = 1;
         O1 = -1.0;
      }
      
      puts("");
   }

   // Line 287
   
   FLAG = 0;
   do
   {
      snprintf(buf, sizeof(buf), "%10.0f  :  %-10.0f", I1, I2);
      printf("%*s\n", (64+strlen(buf))/2, buf);
      
      if (O1 > 0.0) PAUSE(O1);
   
      I7 = floor(I1/15.0+1.0);
   
      if (RND(I4) >= RND(I3))
      {
         I5 += RND(I7*26.0) - RND(I7+5.0);
         I2 -= I7;
         if (I5 < 0.0) I5 = 0.0;
      }
      else
      {
         I1 -= I7;
         if (I0 < I5) FLAG = 1;
      }
   }
   while ((I1 > 0.0) && (I2 > 0.0) && !FLAG);

   if (I1 < 0.0) I1 = 0.0;
   if (I2 < 0.0) I2 = 0.0;

   printf("\n%37s", "Battle over");
   PAUSE(5000);
   
   CLS();
   puts("Battle over\n");
   
   if (FLAG || ((IH == 1) && (I1 > 0.0)))
   {
      // Line 341
      
      if (I == 0)
      {
         puts("All barbarian lands have been seized.\nThe remaining barbarians fled.\n");
         
         A[K][1]  += I5;
         A[K][15] += I1;
         
         BA = 0.0;
      }
      else
      {
         printf("The country of %s was over-run!\nAll enemy nobles were summarily executed!\n\n", Z[I][1]);
      
         puts("The remaining enemy soldiers were imprisoned. All enemy serfs\n"
              "have pledged oaths of fealty to you, and should now be consid-\n"
              "ered to be your people too. All enemy merchants fled the coun-\n"
              "try. Unfortuntately, all enemy assets were sacked and destroyed\n"
              "by your vengeful army in a drunken riot following the victory\n"
              "celebration.\n");
      
         if (IH == 1)
         {
            IH = 0;
            A[I][3] = I2;
         }
      
         A[K][15] += I1;
         A[K][1]  += A[I][1];
         A[I][1]   = 0.0;
         A[I][0]   = 1.0;
         A[K][3]  += A[I][3];
      }
      
      exit_qf(QF);
      return;
   }
   else
   {
      // Line 307
      
      if (I1 > 0.0)
      {
         printf("The forces of %s %s were victorious.\n", Z[K][(int)A[K][17]], Z[K][0]);
         printf("%.0f acres were seized.\n\n", I5);
      }
      else
      {
         printf("%s %s was defeated.\n", Z[K][(int)A[K][17]], Z[K][0]);

         if (I5 < 2.0)
         {
            I5 = 0.0;
            puts("0 acres were seized.\n\n");
         }
         else
         {
            I5 = floor(I5/RND(3.0));
            printf("In your defeat you nevertheless managed to capture %.0f acres.\n\n", I5);
         }
      }

      // Line 317
      
      if ((I != 0) && (I5 > A[I][1]/3.0))
      {
         // Line 325
         
         if (A[I][3] > 1.0)
         {
            I6 = FRND(A[I][3]);
            printf("%.0f enemy serfs were beaten and murdered by your troops!\n", I6);
            A[I][3] -= I6;
         }
         
         if (A[I][11] > 1.0)
         {
            I6 = FRND(A[I][11]);
            printf("%.0f enemy marketplaces were destroyed\n", I6);
            A[I][11] -= I6;
         }
         
         if (A[I][2] > 1.0)
         {
            I6 = FRND(A[I][2]);
            printf("%.0f bushels of enemy grain were burned\n", I6);
            A[I][2] -= I6;
         }
         
         if (A[I][12] > 1.0)
         {
            I6 = FRND(A[I][12]);
            printf("%.0f enemy grain mills were sabotaged\n", I6);
            A[I][12] -= I6;
         }
         
         if (A[I][13] > 1.0)
         {
            I6 = FRND(A[I][13]);
            printf("%.0f enemy foundries were levelled\n", I6);
            A[I][13] -= I6;
         }
         
         if (A[I][14] > 1.0)
         {
            I6 = FRND(A[I][14]);
            printf("%.0f enemy shipyards were over-run\n", I6);
            A[I][14] -= I6;
         }
         
         if (A[I][18] > 3.0)
         {
            I6 = FRND(A[I][18]/2.0);
            printf("%.0f enemy nobles were summarily executed\n", I6);
            A[I][18] -= I6;
         }
         
         puts("");
         
         A[K][1] += I5;
         A[I][1] -= I5;
         
         exit_qf(QF);
         return;
      }

      // Line 319
      
      A[K][15] += I1;
      A[K][1]  += I5;
      
      if (I == 0)
      {
         BA -= I5;
         exit_qf(QF);
         return;
      }

      // Line 321
      
      if (IH == 1)
      {
         IH = 0;
         
         A[I][15] = 0.0;
         A[I][3]  = I2;
         A[I][1] -= I5;
         
         exit_qf(QF);
         return;
      }
      
      A[I][15]  = I2;
      A[I][1]  -= I5;
      
      exit_qf(QF);
      return;
   }
}

void print_revenue_report(void)
{
   CLS();
   
   printf("State Revenues\nTreasury = %.2f %s\n\n", A[K][4], Z[K][6]);
   puts("Customs duty    Sales tax       Income tax");
   printf("%11.0f%%%12.0f%%%16.0f%%\n", A[K][8], A[K][9], A[K][10]);
   printf("%11.0f %12.0f %16.0f\n\n", FC, FS, FI);

   printf("%-16s%10s%14s%8s\n\n", "Investments", "Number", "Profits", "Cost");
   printf("%-16s%10.0f%14.0f%8s\n", "1) Marketplaces", A[K][11], F1, "1000");
   printf("%-16s%10.0f%14.0f%8s\n", "2) Grain mills", A[K][12], F2, "2000");
   printf("%-16s%10.0f%14.0f%8s\n", "3) Foundries", A[K][13], F3, "7000");
   printf("%-16s%10.0f%14.0f%8s\n", "4) Shipyards", A[K][14], F4, "8000");
   printf("%-16s%10.0f%14.0f%8s\n", "5) Soldiers", A[K][15], F5, "8");
   printf("%-16s%10.0f%-14s%8s\n", "6) Palace", A[K][16]*10.0, "% Completed", "5000");
   
   if (KL == 1) KL = 0;
}

void print_grain_report(void)
{
   CLS();
   
   printf("%s %s of %s\n", Z[K][(int)A[K][17]], Z[K][0], Z[K][1]);
   printf("Land Holdings %.1f\n\n", A[K][1]);
   printf("Rats ate %.0f%% of the grain reserve\n\n", RA);
   puts("Grain      Grain     People     Army       Royal");
   puts("harvest   reserve   require    requires   treasury");
   printf("%7.0f%10.0f%10.0f%11.0f%11.0f\n", HA, A[K][2], PD, AD, A[K][4]);
   printf("bushels   bushels   bushels    bushels    %s\n", Z[K][6]);
   
   // Line 93
   
   puts("\n------Grain for sale:\n");
   printf("  Country%10sBushels%4sPrice\n", "", "", "");
   
   J = 0;
   for (I=1; I<=6; ++I)
   {
      if (((int)A[I][0] == 0) && (A[I][5] != 0.0))
      {
         J = 1;
         printf("%-2d%-13s%11.0f%9.2f\n", I, Z[I][1], A[I][5], A[I][6]);
      }
   }
   
   if (J == 0) puts("\n\nNo grain for sale . . .");
}

void action_grain_report(void)
{
   if (H == 1)
   {
       // Line 105
      
      do { INPUT("From which country (give #)? ", "%d", &H1); } while ((H1 < 0) || (H1 > 6));
      if (H1 == 0) return;
       
      if (((int)A[H1][0] == 1) || (A[H1][5] == 0.0))
      {
         puts("That country has none for sale!");
         PAUSE(3000);
         return;
      }
       
      if (H1 == K)
      {
         puts("You cannot buy grain that you have put on the market!");
         PAUSE(3000);
         return;
      }
       
      do
      {
         do
         {
            INPUT("How many bushels? ", "%30[0-9.-]", buf);
            H2 = atof(buf);
             
            FLAG = H2 > A[H1][5];
             
            if (FLAG)
            {
               puts("You can't buy more grain than they are selling!\n");
               PAUSE(3000);
            }
         }
         while (FLAG || (H2 < 0.0));
          
         H3 = H2 * A[H1][6] / 0.9;
          
         FLAG = H3 > A[K][4];
               
         if (FLAG)
            printf("%s %s please reconsider -\nYou can only afford to buy %.1f bushels.\n", Z[K][(int)A[K][17]], Z[K][0], A[K][4]*0.9/A[H1][6]);
      }
      while (FLAG);

      A[K][2] += H2;
      A[K][4] -= H3;
       
      A[H1][4] += H3 * 0.9;
      A[H1][5] -= H2;
   }
   else if (H == 2)
   {
      // Line 121
      
      do
      {
         INPUT("How many bushels do you wish to sell? ", "%30[0-9.-]s", buf);
         H2 = atof(buf);
         
         FLAG = H2 > A[K][2];
         
         if (FLAG)
         {
            printf("%s %s, please think again\nYou only have %.0f bushels.\n", Z[K][(int)A[K][17]], Z[K,0], A[K][2]);
            PAUSE(3000);
         }
      }
      while (FLAG || (H2 < 0.0));
      
      if (H2 != 0.0)
      {
         do
         {
            INPUT("What will be the price per bushel? ", "%30[0-9.-]", buf);
            H3 = atof(buf);
            
            FLAG = H3 > 15.0;
            
            if (FLAG)
               puts("Be reasonable . . .even gold costs less than that!\n");
         }
         while (FLAG || (H3 <= 0.0));
         
         A[K][6] = (A[K][6]*A[K][5] + H2*H3) / (A[K][5]+H2);
            
         A[K][5] += H2;
         A[K][2] -= H2;
      }
   }
   else if (H == 3)
   {
      // Line 133
      
      do
      {
         printf("The barbarians will give you two %s per acre\n", Z[K][6]);
         
         INPUT("How many acres will you sell them? ", "%30[0-9.-]", buf);
         H2 = atof(buf);
         
         FLAG = H2 > A[K][1]*0.95;
         
         if (FLAG)
            puts("You must keep some land for the royal palace!");
      }
      while (FLAG || (H2 < 0.0));
            
      A[K][4] += H2*2.0;
      A[K][1] -= H2;
            
      BA += H2;
   }
}

struct {
   char *s;
   int   max;
}
tax_query[] = {
   { "Give new customs tax (max=50%)? ", 50 },
   { "Give new sales tax (max=20%)? ", 20 },
   { "Give new income tax (max=35%)? ", 35 }
};

void player_human(void)
{
   // Line 65
   // Line 395
   
   if (RND0() <= 0.02)
   {
      CLS();
      
      puts("P L A G U E  ! ! !");
      puts("Black death has struck your nation.\n");
      
      IF = FRND(A[K][3]/2.0);
      A[K][3] -= IF;
      printf("%.0f serfs died.\n", IF);
      
      IF = FRND(A[K][7]/3.0);
      A[K][7] -= IF;
      printf("%.0f merchants died.\n", IF);
      
      IF = FRND(A[K][15]/3.0);
      A[K][15] -= IF;
      printf("%.0f soldiers died.\n", IF);
      
      IF = FRND(A[K][18]/3.0);
      A[K][18] -= IF;
      printf("%.0f nobles died.\n", IF);
      
      PAUSE(10000);
   }
   
   // Line 69

   DS = 0.0;
   IQ = 1;
   
   LA = A[K][1] - A[K][3] - A[K][18]*2.0 - A[K][16] - A[K][7] - A[K][15]*2.0;
   PD = (A[K][3] + A[K][7] + A[K][18]*3.0) * 5.0;
   AD = A[K][15] * 8.0;

   A[K][19] = 15.0;

   player_promotion();
   if (KK == 1) return;
   
   // Line 73
   
   LA = fmin(A[K][2]*3.0, LA);
   LA = fmin(A[K][3]*5.0, LA);
   
   A[K][2] -= LA/3.0;
   
   RA = FRND(30.0);
   A[K][2] -= A[K][2]*RA/100.0;
   
   HA = fmax(LA * NW * 0.72 + FRND(500) - A[K][13] * 500.0, 0.0);
   A[K][2] += HA;

   // Line 81
   // GRAIN REPORT

   do
   {
      print_grain_report();
      puts("");
      
      do { INPUT("1) Buy grain  2) Sell grain  3) Sell land ? ", "%d", &H); } while ((H < 0) || (H > 3));
      puts("");
      
      action_grain_report();
   }
   while (H != 0);
   
   // Line 141
   
   do 
   {
      printf("\nHow many bushels will you give to your army of %.0f men? ", A[K][15]);
      
      INPUT("", "%30[0-9.-]", buf);
      HM = atof(buf);
      
      FLAG = HM > A[K][2];
      
      if (FLAG)
         puts("You cannot give your army more grain than you have!");
   }
   while (FLAG || (HM < 0.0));
   
   A[K][2] -= HM;
   
   // Line 147
   
   PO = A[K][3] + A[K][7] + A[K][18];
   
   do
   {
      printf("How many bushels will you give to your %.0f people? ", PO);

      INPUT("", "%30[0-9.-]", buf);
      HS = atof(buf);
      
      FLAG = HS > A[K][2];
      
      if (FLAG)
         printf("But you only have %.1f bushels of grain!\n", A[K][2]);
      
      if (HS < A[K][2]*0.1)
      {
         FLAG = 1;
         puts("You must release at least 10% of the stored grain\n");
      }
   }
   while (FLAG || (HS < 0));
   
   A[K][2] -= HS;
   A[K][19] = fmin(fmax(HM/(AD+0.001)*10.0, 5.0), 15.0);

   // Line 155
   // POPULATION GROWTH
   
   CLS();
   printf("%s %s of %s\nIn Year %d,\n", Z[K][(int)A[K][17]], Z[K][0], Z[K][1], NY);
   
   DB = FRND(PO/9.5); DM = 0.0; DD = FRND(PO/22.0); DE = 0.0;
   
   if ((HS > PD*1.5) && ((D = sqrt(HS-PD) - RND(A[K][8]*1.5)) >= 0.0))
      DE = FRND(2.0*D+1.0);

   // Line 161

   DS = 0.0;
   
   if (PD > HS*2.0)
   {
      DS = FRND(PO/16.0+1.0);
      DM = FRND(PO/12.0+1.0);
   }
   else if (PD > HS)
      DM = FRND(PO/15.0+1.0);
   
   // Line 165
   
   PT = DB - DS - DM - DD + DE;
   I1 = FRND(DE/5.0);
   I2 = FRND(DE/25.0);
   
   A[K][7]  += I1;
   A[K][18] += I2;
   A[K][3]  += PT - I1 - I2;
   
   DA = 0.0;
   if (AD > HM*2.0)
   {
      DA = FRND(A[K][15]/2.0+1.0);
      A[K][15] -= DA;
   }
   
   PA = 0.0;
   if (AD > HM*2.0)
   {
      PA = RND(A[K][15]/5.0);
      A[K][15] -= PA;
   }
   
   printf("\n%.0f babies were born.\n", DB);
   printf("%.0f people died of disease.\n", DD);
   
   if (DE > 0.0) printf("%.0f people immigrated into your country.\n", DE);
   if (DM > 0.0) printf("%.0f people died of malnutrition.\n", DM);
   if (DS > 0.0) printf("%.0f people starved to death.\n", DS);
   if (DA > 0.0) printf("%.0f soldiers starved to death.\n", DA);
   
   printf("\nYour army will fight at %.0f%% efficiency.\n", A[K][19]*10.0);
   printf("Your population %s %.0f citizens.\n", (PT < 0.0) ? "lost" : "gained", fabs(PT));
   
   printf("\n\n<Enter>");
   PAUSE(30000);

   // Line 373
   // UNFORTUNATE DEATH
   
   FLAG = RND(DS) > RND(110.0);
   
   if (FLAG || (RND0() <= 0.01))
   {
      unfortunate_death(FLAG);
      return;
   }
   
   // Line 189
   
//   F1 = (A[K][11] * ((A[K][7] + RND(35.0) + RND(35.0)) / (A[K][9] + 1.0) * 12.0 + 5.0)) * 0.9;
//   F2 = (A[K][12] * (5.8*(HA + RND(250.0)) / (A[K][10]*20.0 + A[K][9]*40.0 + 10.0) + 150.0)) * 0.9;
//   F3 = (A[K][13] * (A[K][15] + RND(150.0) + 400.0)) * 0.9;
//   F4 = (A[K][14] * (A[K][7]*4.0 + A[K][11]*9.0 + A[K][13]*15.0) * NW) * 0.9;
//   F5 = -A[K][15] * 8.0;

   F1 = pow(A[K][11] * ((A[K][7] + RND(35.0) + RND(35.0)) / (A[K][9] + 1.0) * 12.0 + 5.0), 0.9);
   F2 = pow(A[K][12] * (5.8*(HA + RND(250.0)) / (A[K][10]*20.0 + A[K][9]*40.0 + 10.0) + 150.0), 0.9);
   F3 = pow(A[K][13] * (A[K][15] + RND(150.0) + 400.0), 0.9);
   F4 = pow(A[K][14] * (A[K][7]*4.0 + A[K][11]*9.0 + A[K][13]*15.0) * NW, 0.9);
   F5 = -A[K][15] * 8.0;

//   FC = DE * (RND(40.0) + RND(40.0))/100.0 * A[K][8];
//   FS = A[K][9]/100.0 * ((A[K][7]*1.8 + F1*33.0 + F2*17.0 + F3*50.0 + F4*70.0)*0.85 + A[K][18]*5.0 + A[K][3]);
//   FI = (A[K][10]/100.0 * (A[K][3]*1.3 + A[K][18]*145.0 + A[K][7]*39.0 + A[K][11]*99.0 + A[K][12]*99.0 + A[K][13]*425.0 + A[K][14]*965.0)) * 0.97;

   FC = DE * (RND(40.0) + RND(40.0))/100.0 * A[K][8];
   FS = A[K][9]/100.0 * (pow(A[K][7]*1.8 + F1*33.0 + F2*17.0 + F3*50.0 + F4*70.0, 0.85) + A[K][18]*5.0 + A[K][3]);
   FI = pow(A[K][10]/100.0 * (A[K][3]*1.3 + A[K][18]*145.0 + A[K][7]*39.0 + A[K][11]*99.0 + A[K][12]*99.0 + A[K][13]*425.0 + A[K][14]*965.0), 0.97);

   A[K][4] += F1 + F2 + F3 + F4 + F5 + FC + FS + FI;
   A[K][18] = floor(A[K][18]);

   // Line 199
   // REVENUE REPORT
   
   while (1)
   {
      print_revenue_report();
      puts("");
      
      do { INPUT("1) Customs duty  2) Sales tax  3) Income tax ? ", "%d", &E); } while ((E > 3) || (E < 0));
      puts("");

      if (E == 0) break;

      do
      {
         INPUT(tax_query[E-1].s, "%30[0-9.-]", buf);
         E1 = atof(buf);
      }
      while ((E1 < 0.0) || (E1 > tax_query[E-1].max));
      
      A[K][E+7] = E1;
   }

   // Line 229
   
   while (1)
   {
      puts("");
      do { INPUT("Any new investments (give #)? ", "%d", &E); } while ((E > 6) || (E < 0));
      
      if (E == 0) break;
      
      J = H = 0;
      switch (E)
      {
         case 1:
            E1 = 1000.0;
            J  = RND(7);
            break;
         
         case 2:
            E1 = 2000.0;
            break;
         
         case 3:
            E1 = 7000.0;
            break;
         
         case 4:
            E1 = 8000.0;
            break;
         
         case 5:
            E1 = 8.0;
            break;
         
         case 6:
            E1 = 5000.0;
            H  = RND(4);
            break;
         
         default:
            break;
      }
      
      // Line 245

      do
      {
         FLAG = 0;
         
         do
         {
            INPUT("How many? ", "%30[0-9.-]", buf);
            E2 = floor(atof(buf));
         }
         while (E2 < 0.0);
            
         if (E2 == 0.0) break;
           
         if (A[K][4] < E1*E2)
         {
            FLAG = 1;
            printf("Think again . . .You only have %.2f %s\n", A[K][4], Z[K][6]);
            continue;
         }
            
         if ((E2+(E2-1.0)*(J+H)) > A[K][3])
         {
            FLAG = 1;
            printf("You don't have enough serfs to train\n");
            continue;
         }
            
         if ((E1 == 8.0) && (((E2+A[K][15])/PO) > (0.05+A[K][13]*0.015)))
         {
            FLAG = 1;
            printf("You cannot equip and maintain so many troops, %s.\n", Z[K][(int)A[K][17]]);
            continue;
         }
            
         A[K][15] = floor(A[K][15]);
            
         if ((E1 == 8.0) && ((E2+A[K][15]) > (A[K][18]*20.0)))
         {
            FLAG = 1;
            printf("Please think again . . .  You only have %.0f nobles\nto lead your troops.\n", A[K][18]);
            continue;
         }
      }
      while (FLAG);

      if (E1 == 8.0)
         A[K][3]  -= E2;
      else
      {
         A[K][7]  += J*E2;
         A[K][18] += H*E2;
         A[K][3]  -= (J+H)*E2;
      }
      
      // Line 255
     
      A[K][4]    -= E2*E1;
      A[K][E+10] += E2;

      print_revenue_report();
   }
   
   // Line 257
   // BATTLE REPORT
   
   while (1)
   {
      print_battle_report();
      
      do
      {
         FLAG = 0;
         do { INPUT("\nWho do you wish to attack (give #)? ", "%d", &I); } while ((I > 7) || (I < 0));
      
         if (I == 0) break;
      
         if (I == K+1)
         {
            FLAG = 1;
            printf("%s, please think again.  You are #%d!\n", Z[K][(int)A[K][17]], I);
            continue;
         }
      
         if ((I > 1) && (NY < 3))
         {
            FLAG = 1;
            puts("Due to international treaty, you cannot attack other\nnations until the third year.\n");
            continue;
         }
      
         if ((I == 1) && (BA < 1.0))
         {
            FLAG = 1;
            puts("All barbarian lands have been seized.\n");
            BA = 0.0;
            continue;
         }
      
         if ((int)A[I-1][0] != 0)
         {
            FLAG = 1;
            puts("That player is no longer in the game.\n");
            continue;
         }
      
         H = (int)(A[K][18]/4.0) + 1;
      
         if (IQ > H)
         {
            FLAG = 1;
            printf("Due to a shortage of nobles, you are limited to\nonly %d attacks per year.\n", H);
            continue;
         }
      }
      while (FLAG);
   
      if (I-- == 0) break;
      
      FLAG = 0;
      do
      {
         INPUT("How many soldiers do you want to send? ", "%30[0-9.-]", buf);
         I1 = atof(buf);
         
         FLAG = I1 > A[K][15];
         
         if (FLAG)
            printf("Think again... You have only %.0f soldiers\n", A[K][15]);
      }
      while (FLAG || (I1 < 0.0));
      
      // Line 279
      
      if (I1 > 0.0)
      {
         ++IQ;
         battle();
      }
   }
}

void player_computer(void)
{
   for (Q=1; Q<=NP; ++Q)
      if ((int)A[Q][0] == 0) break;
   
   if (Q > NP) exit(1);
   if ((int)A[K][0] != 0) return;
   
   DS = 0.0;
   
   CLS();
   
   printf("One moment -- %s %s's turn . . .\n", Z[K][(int)A[K][17]], Z[K][0]);
   PAUSE(3000);
   
   if (RND0() < 0.01)
   {
      unfortunate_death(0);
      return;
   }

   Q0 = Q2 = Q3 = Q4 = Q5 = Q6 = Q7 = Q8 = Q9 = 0.0;
   QB = QC = QD = 0.0;
   
   QP = 0;
   for (Q=1; Q<=NP; ++Q)
   {
      if ((int)A[Q][0] == 0)
      {
         ++QP;
         
         Q2 += A[Q][3];
         Q3 += A[Q][5];
         Q4 += A[Q][6];
         Q5 += A[Q][4];
         Q6 += A[Q][7];
         Q7 += A[Q][11];
         Q8 += A[Q][12];
         Q9 += A[Q][13];
         Q0 += A[Q][14];
         
         QB += A[Q][16];
         QC += A[Q][18];
         QD += A[Q][19];
      }
   }
   
   // Line 431

   Q2 /= QP; Q3 /= QP; Q4 /= QP; Q5 /= QP; Q6 /= QP; Q7 /= QP; Q8 /= QP; Q9 /= QP; Q0 /= QP;
   QB /= QP; QC /= QP; QD /= QP;

   do
   {
      Q2  = floor(Q2 + RND(200.0) - RND(200.0));
      Q3  = floor(Q3 + RND(1000.0) - RND(1000.0));
      Q4  = Q4 + RND0() - RND0();
      Q5  = floor(Q5 + RND(1500.0) - RND(1500.0));
      Q6  = floor(Q6 + RND(25.0) - RND(25.0));
      
      if (Q4 < 0.0) Q4 = 0.0;
   }
   while (Q4 == 0.0);
   
   Q7 = floor(Q7 + RND(4.0) - RND(4.0));
   Q8 = floor(Q8 + RND(2.0) - RND(2.0));
   
   if (RND0() < 0.3)
   {
      Q9 = floor(Q9 + RND(2.0) - RND(2.0));
      Q0 = floor(Q0 + RND(2.0) - RND(2.0));
      
      if (RND0() < 0.5)
      {
         QB = floor(QB + RND(2.0) - RND(2.0));
         QC = floor(QC + RND(2.0) - RND(2.0));
      }
   }

   // Line 437
   
   A[K][3] = Q2;
   
   if ((Q3 > A[K][5]) && (RND(9.0) > 6.0))
   {
      A[K][5] = Q3;
      A[K][6] = Q4;
      
      if (NW < 3) A[K][6] += RND0()/1.5;
   }
   
   A[K][4] = Q5;
   
   if (Q6 > A[K][7])  A[K][7]  = Q6;
   if (Q7 > A[K][11]) A[K][11] = Q7;
   if (Q8 > A[K][12]) A[K][12] = Q8;
   if (Q9 > A[K][13]) A[K][13] = Q9;
   if (Q0 > A[K][14]) A[K][14] = Q0;
   if (QB > A[K][16]) A[K][16] = QB;
   if (QC > A[K][18]) A[K][18] = QC;

   A[K][15] = 10.0*A[K][18] + RND(10.0*A[K][18]);
   IQ = 0;
   
   while ((A[K][15]/Q2) > (A[K][13]*0.01+0.05))
      A[K][15] /= 2.0;

   A[K][19] = QD;

   QF = 1;
   player_promotion();
   QF = 0;

   do { Q = RND(NP); } while (((int)A[Q][0] != 0) || (Q == K));

   if (A[Q][5] >= 1.0)
   {
      do
      {
         QR = RND(O)*A[Q][5];
      
         if ((QR*A[Q][6]) < A[K][4])
         {
            A[Q][4] += floor(QR*A[Q][6]*90.0)/100.0;
            A[Q][5] -= floor(QR);
            
            break;
         }
      }
      while (RND(9.0) > 3.0);
   }

   do
   {
      if (RND(9.0) < 2.0) return;
      
      if (NY >= 3)
      {
         do { I = RND(6); } while ((I == K) || ((int)A[I][0] != 0));
      }
      else
      {
         I = 0;
         if (BA <= 0.0) return;
      }
      
      // Line 477
      
      I1 = FRND(A[K][15]);
      
      QF = 1;
      battle();
      QF = 0;
      
      ++IQ;
   }
   while ((A[K][15] > 30.0) && (IQ < A[K][18]/4.0));
}

#ifdef INSTR

extern const char inst[];

void instructions(void)
{
   char *p;
   
   CLS();
   
   for (p=inst; *p != '\0'; ++p)
   {
      if (*p == '*')
         PAUSE(1000);
      else if (*p == '@')
      {
         PAUSE(0);
         CLS();
      }
      else if (*p == '<')
         puts("");
      else
      {
         putchar(*p);
         in_pause(25);
      }
   }
}

#endif

char *main_weather[] = {
   "",
   "Poor weather. No rain. Locusts migrate.",
   "Early frosts. Arid conditions.",
   "Flash floods. Too much rain.",
   "Average weather. Good year.",
   "Fine weather. Long summer.",
   "Fantastic weather! Great year!"
};

void main(void)
{
#ifdef __SPECTRUM
   ioctl(1, IOCTL_OTERM_PAUSE, 0);
#endif

   // Line 0
   
   CLS();
   
   puts("E M P I R E\n\n");
   puts("(Always hit <enter> to continue)\n");
   
   in_wait_nokey();
   for (I=0; !in_test_key(); ++I) ;
   in_wait_nokey();
   
   srand(I);

#ifdef INSTR

   do
   {
      INPUT("Instructions? (y/n) ", "%2s", buf);
      *buf = toupper(*buf);
   }
   while ((*buf != 'Y') && (*buf != 'N'));
   
   if (*buf == 'Y') instructions();

#endif
   
   CLS();
   
   // Line 9
   
   for (I=1; I<=6; ++I)
      A[I][2] += FRND(10000);
   
   do { INPUT("How many people are playing? ", "%d", &NP); } while ((NP < 0) || (NP > 6));
   
   puts("");
   for (I=1; I<=NP; ++I)
   {
      printf("%d - Who is the ruler of %s? ", I, Z[I][1]);
      INPUT("", "%11s", buf);
      Z[I][0] = strdup(buf);
   }
   
   // Line 19
   
   do
   {
      CLS();
      
      printf("Year %d\n\n", ++NY);
      puts(main_weather[NW = RND(6)]);
      
      // Line 35
      
      PAUSE(5000);
      
      for (K=1; K<=6; ++K)
      {
         (K > NP) ? player_computer() : player_human();
         if (KK == 1) break;
      }
      
      // Line 43
      
      CLS();
      
      puts("Summary");
      puts("Nobles   Soldiers   Merchants   Serfs   Land    Palace\n");
      
      for (I=1; I<=6; ++I)
      {
         if ((int)A[I][0] == 0)
         {
            printf("%s %s of %s\n", Z[I][(int)A[I][17]], Z[I][0], Z[I][1]);
            printf("%4.0f%12.0f%12.0f%10.0f%8.0f%5.0f%%\n", A[I][18], A[I][15], A[I][7], A[I][3], A[I][1], A[I][16]*10.0);
         }
      }

      puts("\n<Enter>");
      PAUSE(30000);
   }
   while (KK != 1);
}

#ifdef INSTR

const char inst[] = "  Hello!     Welcome to  E M P I R E . . .*<<"
   "Imagine yourself to be the ruler of a small, unimportant piece<"
   "of European land way back in the medieval ages. Your country is<"
   "beset by many problems - no industry, little trade, small army"
   ",<underpopulation, angry neighbors, plague, and all the other<"
   "day-to-day problems a capable leader must learn to face. Am-<"
   "bitious by necessity, you must aquire land, capital, and an<"
   "army just to survive. Because of the short lifetimes back then,<"
   "you'll have only a limited amount of time to build your coun-<"
   "try into an empire.<<  Competent rule will gradually be rewarded "
   "with lofty titles -<Knight, Prince, King, and finally  -- Emperor"
   " --@  Sounds easy?  Then consider this - five other city-states "
   "are<also struggling to become the emperor, and they don't just in-"
   "<tend to passively watch you win. They control armies which can<"
   "attack at a moments notice, and perhaps devastate your country.<"
   "They control the grain market, and if you think OPEC is bad,<"
   "just wait and see how scarce and expensive grain can become.<<"
   "  Of course, a competent ruler could make a killing on the<"
   "grain market. With proper planning, your harvests should be<"
   "plentiful. You could solve overpopulation problems by raising a<"
   "large army to be killed off in battle.<<  Nevertheless, your overriding"
   " concern should be lebensraum -<living room. There is only a limited "
   "amount of land to be con-<quered. If you can defeat the barbarian "
   "hordes, and the well-<trained standing armies of the other nations, "
   "and then defeat<their peasant militias, perhaps you may attain "
   "the well deser-<ved title of Emperor.@Taxes:<<  The customs tax "
   "applies only to immigrants to your nation.<Often, lower customs "
   "tax means more immigrants.<<  The sales tax is closely intertwined "
   "into your capitalist<economy. While it has the potential of raising "
   "lots of money,<overly high taxes tend to stifle industrial profits.<<"
   "  Income taxes are paid by all inhabitants and industry. Again,<"
   "lower income tax often means increased industrial output."
   "<<  You have the option each year to invest your earnings in<"
   "different types of trade and industry. In the years to follow,<"
   "these investments, if managed correctly, will more than pay<"
   "for themselves.@Types of investments:<<  Marketplaces are a "
   "relatively cheap investment that are quite<profitable because "
   "they encourage the formation of a middle<class - the merchants. "
   "And, as you are probably aware, the<middle class pays an inordinate "
   "share of taxes.<<  Grain mills are necessary to process the harvest, "
   "and con-<sequently, usually do quite well when there is a large "
   "harvest.<<  Foundries are necessary for the creation of large armies.<"
   "Several of them will allow you to equip a much larger army<than otherwise.<<"
   "  Shipyards have the greatest profit potential of all invest-<ments. "
   "Because of a larger volume of orders during good wea-<ther, there is "
   "often a better return during these years.@  Armies are never a profitable "
   "investment. Besides costing<a large initial investment, they also cost "
   "a lot to maintain<and train. In addition, they also require a greater "
   "fraction<of the harvest than serfs.<<  Of course, one should give himself "
   "the luxury of building a<palace. What else could distinguish an emperor "
   "from all the<other kings with their castles, than a palace? Also, with a<"
   "palace, your country will begin to attract more nobles.<<Other general "
   "hints:<<  You always lose 10% as a brokerage fee when dealing on the<"
   "grain market. When you sell your grain at different prices,<"
   "the market price is the weighted average of the sales prices<(this "
   "helps to prevent large yearly price fluctuations). To<prevent "
   "those unscrupulous rulers who try to use the market as<"
   "a method to avoid the rats, you can't buy back your own grain.@"
   "Also, leave a portion of your grain reserve for planting for<next "
   "year's harvest.<<Often, it is beneficial to feed your people much "
   "more than they<require. Immigrants are usually attracted to a "
   "prosperous nat-<ion, and sometimes, even merchants and nobles move in.<"
   "<<  Up to six people can play this game. Rulers not played by<humans "
   "will be played by your TRS-80, with its playing abil-<ity based on "
   "the average of the human players.@Winning:<<To become a prince, you "
   "must pass these rather stringent<qualifications:8 marketplaces, "
   "4 mills, palace 20% completed,<a land-over-serf ratio of 4.8, over "
   "10 nobles, and over 2300<serfs.<<To become a king, you must have:"
   "14 marketplaces, 6 mills,<palace 60% completed, 1 foundry, land-over-serf "
   "ratio of at<least 5.0, Over 2600 serfs and 25 nobles.<<To become an "
   "+EMPEROR+ you must meet all of the above qual-<ifications, and ....over "
   "3100 serfs and 40 nobles.<<<-- Good luck, future rulers@";

#endif
