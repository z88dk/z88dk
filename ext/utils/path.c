/**
 * @file path.c
 * @brief Path manipulation helper functions
 *
 * @section License
 *
 * Copyright (C) 2010-2017 Oryx Embedded SARL. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * @author Oryx Embedded SARL (www.oryx-embedded.com)
 * @version 1.7.8
 **/

//Dependencies
#include <string.h>
#include <ctype.h>
#include "path.h"


/**
 * @brief Skip leading letter and colon to treat Windows paths
 * @param[in] path NULL-terminated string that contains the path
 * @return address path after the colon, or path if no drive spec given
 **/

static const char_t *pathSkipDrive(const char_t *path, size_t *pMaxLen)
{
   if(strlen(path) >= 2 && isalpha(path[0]) && path[1] == ':')
   {
      path += 2;		// skip volume
	  if (pMaxLen)
         *pMaxLen -= 2;
   }
      
   return path;
}
 
/**
 * @brief Test if the path is absolute
 * @param[in] path NULL-terminated string that contains the path
 * @return TRUE is the path is absolute, else FALSE
 **/

bool_t pathIsAbsolute(const char_t *path)
{
   path = pathSkipDrive(path, NULL);
	
   //Determine if the path is absolute or relative
   if(path[0] == '/' || path[0] == '\\')
      return TRUE;
   else
      return FALSE;
}


/**
 * @brief Test if the path is relative
 * @param[in] path NULL-terminated string that contains the path
 * @return TRUE is the path is relative, else FALSE
 **/

bool_t pathIsRelative(const char_t *path)
{
   //Determine if the path is absolute or relative
   return !pathIsAbsolute(path);
}


/**
 * @brief Search a path for a file name
 * @param[in] path NULL-terminated string that contains the path to search
 * @return Pointer to the file name
 **/

const char_t *pathFindFileName(const char_t *path)
{
   size_t n;

   path = pathSkipDrive(path, NULL);

   //Retrieve the length of the path
   n = strlen(path);

   //Skip trailing slash or backslash characters
   while(n > 0)
   {
      //Forward slash or backslash character found?
      if(path[n - 1] != '/' && path[n - 1] != '\\')
         break;

      //Previous character
      n--;
   }

   //Search the string for the last separator
   while(n > 0)
   {
      //Forward slash or backslash character found?
      if(path[n - 1] == '/' || path[n - 1] == '\\')
         break;

      //Previous character
      n--;
   }

   //Return a pointer to the file name
   return path + n;
}


/**
 * @brief Search a path for a file extension
 * @param[in] path NULL-terminated string that contains the path to search
 * @return Pointer to the '.' of the file extention, or to the '\0' if none
 **/
const char_t *pathFindFileExtension(const char_t *path)
{
   size_t n;

   path = pathFindFileName(path);

   //Retrieve the length of the path
   n = strlen(path);
   
   //Search the string for the last '.', except first '.' in a dot-file
   while(n > 0)
   {
      //dot found and not at start of file name?
      if(n > 1 && path[n - 1] == '.')
         return path + n - 1;				//return ".ext"

      //Previous character
      n--;
   }

   //Return a pointer to end of file name
   return path + strlen(path);				//no extension, dot-files have no extension
}


/**
 * @brief Simplify a path
 * @param[in] path NULL-terminated string containing the path to be canonicalized
 **/

void pathCanonicalize(char_t *path)
{
   size_t i;
   size_t j;
   size_t k;

   path = (char_t *)pathSkipDrive(path, NULL);

   //Move to the beginning of the string
   i = 0;
   k = 0;

   //Replace backslashes with forward slashes
   while(path[i] != '\0')
   {
      //Forward slash or backslash separator found?
      if(path[i] == '/' || path[i] == '\\')
      {
         path[k++] = '/';
         while(path[i] == '/' || path[i] == '\\') i++;
      }
      else
      {
         path[k++] = path[i++];
      }
   }

   //Properly terminate the string with a NULL character
   path[k] = '\0';

   //Move back to the beginning of the string
   i = 0;
   j = 0;
   k = 0;

   //Parse the entire string
   do
   {
      //Forward slash separator found?
      if(path[i] == '/' || path[i] == '\0')
      {
         //"." element found?
         if((i - j) == 1 && !strncmp(path + j, ".", 1))
         {
            //Check whether the pathname is empty?
            if(k == 0)
            {
               if(path[i] == '\0')
               {
                  path[k++] = '.';
               }
               else if(path[i] == '/' && path[i + 1] == '\0')
               {
                  path[k++] = '.';
                  path[k++] = '/';
               }
            }
            else if(k > 1)
            {
               //Remove the final slash if necessary
               if(path[i] == '\0')
                  k--;
            }
         }
         //".." element found?
         else if((i - j) == 2 && !strncmp(path + j, "..", 2))
         {
            //Check whether the pathname is empty?
            if(k == 0)
            {
               path[k++] = '.';
               path[k++] = '.';

               //Append a slash if necessary
               if(path[i] == '/')
                  path[k++] = '/';
            }
            else if(k > 1)
            {
               //Search the path for the previous slash
               for(j = 1; j < k; j++)
               {
                  if(path[k - j - 1] == '/')
                     break;
               }

               //Slash separator found?
               if(j < k)
               {
                  if(!strncmp(path + k - j, "..", 2))
                  {
                     path[k++] = '.';
                     path[k++] = '.';
                  }
                  else
                  {
                     k = k - j - 1;
                  }

                  //Append a slash if necessary
                  if(k == 0 && path[0] == '/')
                     path[k++] = '/';
                  else if(path[i] == '/')
                     path[k++] = '/';
               }
               //No slash separator found?
               else
               {
                  if(k == 3 && !strncmp(path, "..", 2))
                  {
                     path[k++] = '.';
                     path[k++] = '.';

                     //Append a slash if necessary
                     if(path[i] == '/')
                        path[k++] = '/';
                  }
                  else if(path[i] == '\0')
                  {
                     k = 0;
                     path[k++] = '.';
                  }
                  else if(path[i] == '/' && path[i + 1] == '\0')
                  {
                     k = 0;
                     path[k++] = '.';
                     path[k++] = '/';
                  }
                  else
                  {
                     k = 0;
                  }
               }
            }
         }
         else
         {
            //Copy directory name
            memmove(path + k, path + j, i - j);
            //Advance write pointer
            k += i - j;

            //Append a slash if necessary
            if(path[i] == '/')
               path[k++] = '/';
         }

         //Move to the next token
         while(path[i] == '/') i++;
         j = i;
      }
   } while(path[i++] != '\0');

   //Properly terminate the string with a NULL character
   path[k] = '\0';
}


/**
 * @brief Add a slash to the end of a string
 * @param[in,out] path NULL-terminated string that represents the path
 * @param[in] maxLen Maximum pathname length
 **/

void pathAddSlash(char_t *path, size_t maxLen)
{
   size_t n;

   path = (char_t *)pathSkipDrive(path, &maxLen);

   //Retrieve the length of the string
   n = strlen(path);

   //Add a slash character only if necessary
   if(!n)
   {
      //Check the length of the resulting string
      if(maxLen >= 1)
         strcpy(path, "/");
   }
   else if(path[n - 1] != '/' && path[n - 1] != '\\')
   {
      //Check the length of the resulting string
      if(maxLen >= (n + 1))
         strcat(path, "/");
   }
}


/**
 * @brief Remove the trailing slash from a given path
 * @param[in,out] path NULL-terminated string that contains the path
 **/

void pathRemoveSlash(char_t *path)
{
   char_t *end;

   path = (char_t *)pathSkipDrive(path, NULL);

   //Skip the leading slash character
   if(pathIsAbsolute(path))
      path++;

   //Search for the first slash character to be removed
   for(end = NULL; *path != '\0'; path++)
   {
      if(*path != '/' && *path != '\\')
         end = NULL;
      else if(!end)
         end = path;
   }

   //Remove the trailing slash characters
   if(end)
      *end = '\0';
}


/**
 * @brief Concatenate two paths
 * @param[in,out] path NULL-terminated string containing the first path
 * @param[in] more NULL-terminated string containing the second path
 * @param[in] maxLen Maximum pathname length
 **/

void pathCombine(char_t *path, const char_t *more, size_t maxLen)
{
   size_t n1;
   size_t n2;

   path = (char_t *)pathSkipDrive(path, &maxLen);

   //Append a slash character to the first path
   if(*path != '\0')
      pathAddSlash(path, maxLen);

   //Skip any slash character at the beginning of the second path
   while(*more == '/' || *more == '\\') more++;

   //Retrieve the length of the first path
   n1 = strlen(path);
   //Retrieve the length of second path
   n2 = strlen(more);

   //Check the length of the resulting string
   if(n1 < maxLen)
   {
      //Limit the number of characters to be copied
      n2 = MIN(n2, maxLen - n1);
      //Concatenate the resulting string
      strncpy(path + n1, more, n2);
      //Properly terminate the string with a NULL character
      path[n1 + n2] = '\0';
   }
}


/**
 * @brief Check whether a file name matches the specified pattern
 * @param[in] path NULL-terminated string that contains the path to be matched
 * @param[in] pattern NULL-terminated string that contains the pattern for
 *   which to search. The pattern may contain wildcard characters
 * @return TRUE if the path matches the specified pattern, else FALSE
 **/

bool_t pathMatch(const char_t *path, const char_t *pattern)
{
   size_t i = 0;
   size_t j = 0;

   //Parse the pattern string
   while(pattern[j] != '\0')
   {
      //Any wildcard character found?
      if(pattern[j] == '?')
      {
         //The question mark matches a single character
         if(path[i] == '\0')
         {
            return FALSE;
         }
         else
         {
            //Advance position in pathname
            i++;
            //Advance position in pattern string
            j++;
         }
      }
      else if(pattern[j] == '*')
      {
         //The asterisk sign matches zero or more characters
         if(path[i] == '\0')
         {
            //Advance position in pattern string
            j++;
         }
         else if(pathMatch(path + i, pattern + j + 1))
         {
            return TRUE;
         }
         else
         {
            //Advance position in pathname
            i++;
         }
      }
      else
      {
         //Case insensitive comparison
         if(tolower((uint8_t) path[i]) != tolower((uint8_t) pattern[j]))
         {
            return FALSE;
         }
         else
         {
            //Advance position in pathname
            i++;
            //Advance position in pattern string
            j++;
         }
      }
   }

   //Check whether the file name matches the specified pattern
   if(path[i] == '\0' && pattern[j] == '\0')
      return TRUE;
   else
      return FALSE;
}
