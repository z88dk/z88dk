// Copyright Creative Computing, Morristown, New Jersey
// C conversion by Payton Byrd from BASIC in "More BASIC
// Computer Games" by Creative Computing.
// http://csdb.dk/release/?id=95792

// bugfix applied:  result[] in getInput() must be static
// bugfix applied:  fixed memory leaks caused by use of replace()
// changed spacing as terminal resolution varies in z88dk

// zcc +cpm -vn -O3 -clib=new eliza.c -o eliza -create-app
// zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 eliza.c -o eliza -create-app

// zcc +zx -vn -O3 -startup=8 -clib=new eliza.c -o eliza -create-app
// zcc +zx -vn -SO3 -startup=8 -clib=sdcc_iy --max-allocs-per-node200000 eliza.c -o eliza -create-app

#pragma output CLIB_OPT_PRINTF      = 0x200    // %s only
#pragma output CLIB_STDIO_HEAP_SIZE = 0        // cannot open files

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Prompt the user and get the input
unsigned char* getInput()
{
	static unsigned char result[81];

	putchar('?');
	putchar(' ');

	if (!fgets(result, sizeof(result), stdin))
	   exit(1);

	result[strlen(result) - 1] = '\0';
	return result;
}

// The following code was written by Netocrat
// Found at: http://bytes.com/topic/c/answers/223500-how-replace-substring-string-using-c
char *replace(
	const char *s, 
	const char *old,
	const char *new)
{
	static char *ret;
	static int i, count;
	static size_t newlen, oldlen;

	count = 0;
	
	newlen = strlen(new);
	oldlen = strlen(old);

	for (i = 0; s[i] != '\0'; ++i) 
	{
		if (strcmp(strstr(&s[i], old), &s[i]) == 0) 
		{
			count++;
			i += oldlen - 1;
		}
	}

	ret = malloc(i + count * (newlen - oldlen));
	if (ret == NULL)
		exit(EXIT_FAILURE);

	i = 0;
	while (*s) 
	{
		if (strcmp(strstr(s, old), s) == 0) 
		{
			strcpy(&ret[i], new);
			i += newlen;
			s += oldlen;
		} 
		else
			ret[i++] = *s++;
	}

	ret[i] = '\0';

	return ret;
}

// Keyword Data
#define KEYWORDS_LENGTH 36U
unsigned char* keywords[] = {
	"can you", "can i", "you are", "you're", "i don't", "i feel",
	"why don't you", "why can't i", "are you", "i can't", "i am", "i'm",
	"you ", "i want", "what", "how", "who", "where", "when", "why",
	"name", "cause", "sorry", "dream", "hello", "hi", "maybe",
	" no", "your", "always", "think", "alike", "yes", "friend",
	"computer", "nokeyfound" };

// Conjugation Data
#define CONJUGATIONS_LENGTH 14U
unsigned char* conjugations[] = {
	" are", " am ", "were ", "was ", " you ", " I ", "your ", "my ",
	" I've ", " you've ", " I'm ", " you're ", " me ", " !you " };

// Lookups per keyword.  These are pairs,
// the first number is the index of the first response
// for the keyword and the second number is the number
// of valid responses for the keyword.
unsigned char lookup[] = {
	1,3,4,2,6,4,6,4,10,4,14,3,17,3,20,2,22,3,25,3,
	28,4,28,4,32,3,25,5,40,9,40,9,40,9,40,9,40,9,40,9,
	49,2,51,4,55,4,59,4,63,1,63,1,64,5,69,5,74,2,76,4,
	80,3,83,7,90,3,93,6,99,7,106,6 };

// Responses.  %s is replaced by conjugated strings
// on select responses.  The commented number is the
// line number of the data statement for the response
// in the original BASIC listing.
#define RESPONSE_LENGTH 112U
unsigned char* responses[] = {
	"Don't you believe that I can%s",	//1330
	"Perhaps you would like to be able to%s", //1340
	"You want me to be able to%s", //1350
	"Perhaps you don't want to%s", //1360
	"Do you want to be able to%s", //1365
	"What makes you think I am%s", //1370
	"Does it please you to believe I am%s", //1380
	"Perhaps you would like to be%s", //1390
	"Do you sometimes wish you were%s", //1400
	"Don't you really%s", //1410
	"Why don't you%s", //1420
	"Do you wish to be able to%s", //1430
	"Does that trouble you?", //1440
	"Tell me more about such feelings.", //1450
	"Do you often feel%s", //1460
	"Do you enjoy feeling%s", //1470
	"Do you really believe I don't%s", //1480
	"Perhaps in good time I will%s", //1490
	"Do you want me to%s", //1500
	"Do you think you should be able to%s", //1510
	"Why can't you%s", //1520
	"Why are you interested in whether or not I am%s", //1530
	"Would you prefer if I were not%s", //1540
	"Perhaps in your fantasies I am%s", //1550
	"How do you know you can't%s", //1560
	"Have you tried?", //1570
	"Perhaps you can now%s", //1580
	"Did you come to me because you are%s", //1590
	"How long have you been%s", //1600
	"Do you believe it is normal to be%s", //1610
	"Do you enjoy being%s", //1620
	"We were discussing you -- not me.", //1630
	"Oh, I%s", //1640
	"You're not really talking about me, are you?", //1650
	"What would it mean if you got%s", //1660
	"Why do you want%s", //1670
	"Suppose you soon got%s", //1680
	"What if you never got%s", //1690
	"I sometimes also want%s", //1700
	"Why do you ask?", //1710
	"Does that question interest you?", //1720
	"What answer would please you the most?", //1730
	"What do you think?", //1740
	"Are such questions on your mind often?", //1750
	"What is it that you really want to know?", //1760
	"Have you asked anyone else?", //1770
	"Have you asked such questions before?", //1780
	"What else comes to mind when you ask that?", //1790
	"Names don't interest me.", //1800
	"I don't care about names -- please go on.", //1810
	"Is that the real reason?", //1820
	"Don't any other reasons come to mind?", //1830
	"Does that reason explain anything else?", //1840
	"What other reasons might there be?", //1850
	"Please don't apologize!", //1860
	"Apologies are not necessary.", //1870
	"What feelings do you have when you apologize?", //1880
	"Don't be so defensive!", //1890
	"What does that dream suggest to you?", //1900
	"Do you dream often?", //1910
	"What persons appear in your dreams?", //1920
	"Are you disturbed by your dreams?", //1930
	"How do you do ... please state your problem.", //1940
	"You don't seem quite certain.", //1950
	"Why the uncertain tone?", //1960
	"Can't you be more positive?", //1970
	"You aren't sure?", //1980
	"Don't you know?", //1990
	"Are you saying no just to be negative?", //2000
	"You are being a bit negative.", //2010
	"Why not?", //2020
	"Are you sure?", //2030
	"Why no?", //2040
	"Why are you concerned about my%s", //2050
	"What about your own%s", //2060
	"Can you think of a specific example?", //2070
	"When?", //2080
	"What are you thinking of?", //2090
	"Really, always?", //2100
	"Do you really think so?", //2110
	"But you are not sure you%s", //2120
	"Do you doubt you%s", //2130
	"In what way?", //2140
	"What resemblance do you see?", //2150
	"What does the similarity suggest to you?", //2160
	"What other connections do you see?", //2170
	"Could there really be some connection?", //2180
	"How?", //2190
	"You seem quite positive.", //2200
	"Are you sure?", //2210
	"I see.", //2220
	"I understand.", //2230
	"Why do you bring up the topic of friends?", //2240
	"Do your friends worry you?", //2250
	"Do your friends pick on you?", //2260
	"Are you sure you have any friends?", //2270
	"Do you impose on your friends?" //2280
	"Perhaps your love for friends worries you.", //2290
	"Do computers worry you?", //2300
	"Are you talking about me in particular?", //2310
	"Are you frightened by machines?", //2320
	"Why do you mention computers?", //2330
	"What do you think machines have to do with your problem?", //2340
	"Don't you think computer can help people?", //2350
	"What is it about machines that worries you?", //2360
	"Say, do you have any psychological problems?", //2370
	"What does that suggest to you?", //2380
	"I see.", //2390
	"I'm not sure I understand you fully.", //2400
	"Come, come ... elucidate your thoughts.", //2410
	"Can you elaborate on that?", //2420
	"That is quite interesting." //2430
};

// Main function
void main(void)
{
	static unsigned char* input;			// User's input
	static unsigned char lastInput[81];		// User's last input
	static unsigned char conjugated[81];	// Temporary variable to conjugate the question
	static unsigned char counter;			// Loop variable
	static unsigned char keywordIndex;		// Index of the keyword in the keywords array
	static unsigned char replyStart;		// Index of the first valid reply for the keywrod
	static unsigned char replyLength;		// Number of possible replies for the keyword
	static unsigned char nextReplyIndex[KEYWORDS_LENGTH];	// List of current reply in the rotation per keyword
	static unsigned char *tmp;

	// Initialize the array of current replies.
	for(counter = 0; counter < KEYWORDS_LENGTH; ++counter)
	{
		nextReplyIndex[counter] = 0;
	}

	// Initialize the lastInput string.
	lastInput[0] = '\0';

	// Display program header
	puts("\n");
	puts(  "Eliza");
	puts(  "Creative Computing");
	puts(  "Morristown, New Jersey");
	puts("\nConverted to C by Payton Byrd");
	puts("\n");
	puts("Hi!  I'm Eliza.\n\nWhat's your problem?\n");

	// This is the program that does not end.
	// It goes on and on my friend.
	// I started playing not knowing what it was.
	// And I'll keep on playing forever just because:
	// This is the program that does not end...
	for(;;)
	{
		// Get the user's input.
		input = getInput();

		// Make it lower case.
		strlwr(input);

		// Move the cursor down.
		puts("");

		// Check if the user is repeating themself.
		if(strlen(lastInput) != 0 && strcmp(input, lastInput) == 0)
		{
			puts("Please don't repeat yourself!");
		}
		else
		{
			// Parse keyword
			for(counter = 0; counter < KEYWORDS_LENGTH; ++counter)
			{
				if(strstr(input, keywords[counter]) != NULL)
				{
					// Found keyword
					break;
				}
			}

			// Did we find a keyword?
			if(counter < KEYWORDS_LENGTH)
			{
				// Yes, set the index
				keywordIndex = counter;
			}
			else
			{
				// No, set the default keyword index
				keywordIndex = KEYWORDS_LENGTH - 1;
			}

			// Get the rest of the user's input after the keyword.
			sprintf(conjugated, " %s ", (strstr(input, keywords[keywordIndex]) + strlen(keywords[keywordIndex])) );

			// Loop through the array of conjugations and find the first
			// one in the user's response after the keyword.
			for(counter = 0; counter < CONJUGATIONS_LENGTH; counter += 2)
			{
				// Did we find one?
				if(strstr(input, conjugations[counter]) != NULL)
				{
					// Yes, Swap words
					strcpy(conjugated, tmp = replace(conjugated, conjugations[counter], conjugations[counter + 1]));
					free(tmp);
					break;
				}
				else if(strstr(input, conjugations[counter + 1]) != NULL)
				{
					// Yes, Swap words
					strcpy(conjugated, tmp = replace(conjugated, conjugations[counter + 1], conjugations[counter]));
					free(tmp);
					break;
				}
			}

			// Get rid of the ! characters.  I don't know why they
			// are there to begin with, maybe the original BASIC
			// author knows....
			while(strchr(conjugated, '!') != NULL)
			{
				strcpy(conjugated, tmp = replace(conjugated, "!", ""));
				free(tmp);
			}

			// Get the starting response
			replyStart = lookup[keywordIndex * 2];

			// And the number of valid responses
			replyLength = lookup[keywordIndex * 2 + 1];

			// Display the response
			puts("");
			printf(responses[replyStart + nextReplyIndex[keywordIndex]], conjugated);
			puts("");

			// Increment the response counter
			++nextReplyIndex[keywordIndex];

			// Set back to 0 if necessary
			if(nextReplyIndex[keywordIndex] == replyLength)
			{
				nextReplyIndex[keywordIndex] = 0;
			}

			// Record user's last input.
			strcpy(lastInput, input);
		}
	}
}
