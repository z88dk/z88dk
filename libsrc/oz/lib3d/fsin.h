/*
	Integer sin functions taken from the lib3d library, OZ7xx DK
	by Hamilton, Green and Pruss
	isin and icos return a value from -16384 to +16384
*/

extern int __LIB__ isin(unsigned degrees); /* input must be between 0 and 360 */
extern int __LIB__ icos(unsigned degrees); /* input must be between 0 and 360 */
extern int __LIB__ div16384(long value); /* divide by 16384 */
