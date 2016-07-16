////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "string_utilities.hpp"
#include "string_basic.hpp"
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>

namespace stlplus
{

  // added as a local copy to break the dependency on the portability library
  static std::string local_dformat(const char* format, ...) throw(std::invalid_argument)
  {
    std::string formatted;
    va_list args;
    va_start(args, format);
#ifdef MSWINDOWS
    int length = 0;
    char* buffer = 0;
    for(int buffer_length = 256; ; buffer_length*=2)
    {
      buffer = (char*)malloc(buffer_length);
      if (!buffer) throw std::invalid_argument("string_utilities");
      length = _vsnprintf(buffer, buffer_length-1, format, args);
      if (length >= 0)
      {
        buffer[length] = 0;
        formatted += std::string(buffer);
        free(buffer);
        break;
      }
      free(buffer);
    }
#else
    char* buffer = 0;
    int length = vasprintf(&buffer, format, args);
    if (!buffer) throw std::invalid_argument("string_utilities");
    if (length >= 0)
      formatted += std::string(buffer);
    free(buffer);
#endif
    va_end(args);
    if (length < 0) throw std::invalid_argument("string_utilities");
    return formatted;
  }

  ////////////////////////////////////////////////////////////////////////////////

  std::string pad(const std::string& str, alignment_t alignment, unsigned width, char padch)
    throw(std::invalid_argument)
  {
    std::string result = str;
    switch(alignment)
    {
    case align_left:
    {
      std::string::size_type padding = width>str.size() ? width - str.size() : 0;
      std::string::size_type i = 0;
      while (i++ < padding)
        result.insert(result.end(), padch);
      break;
    }
    case align_right:
    {
      std::string::size_type padding = width>str.size() ? width - str.size() : 0;
      std::string::size_type i = 0;
      while (i++ < padding)
        result.insert(result.begin(), padch);
      break;
    }
    case align_centre:
    {
      std::string::size_type padding = width>str.size() ? width - str.size() : 0;
      std::string::size_type i = 0;
      while (i++ < padding/2)
        result.insert(result.end(), padch);
      i--;
      while (i++ < padding)
        result.insert(result.begin(), padch);
      break;
    }
    default:
      throw std::invalid_argument("invalid alignment value");
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

  std::string trim_left(const std::string& val)
  {
    std::string result = val;
    while (!result.empty() && isspace(result[0]))
      result.erase(result.begin());
    return result;
  }

  std::string trim_right(const std::string& val)
  {
    std::string result = val;
    while (!result.empty() && isspace(result[result.size()-1]))
      result.erase(result.end()-1);
    return result;
  }

  std::string trim(const std::string& val)
  {
    std::string result = val;
    while (!result.empty() && isspace(result[0]))
      result.erase(result.begin());
    while (!result.empty() && isspace(result[result.size()-1]))
      result.erase(result.end()-1);
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

  std::string lowercase(const std::string& val)
  {
    std::string text = val;
    for (unsigned i = 0; i < text.size(); i++)
      text[i] = tolower(text[i]);
    return text;
  }

  std::string uppercase(const std::string& val)
  {
    std::string text = val;
    for (unsigned i = 0; i < text.size(); i++)
      text[i] = toupper(text[i]);
    return text;
  }

  ////////////////////////////////////////////////////////////////////////////////

  std::string translate(const std::string& input, const std::string& from_set, const std::string& to_set)
  {
    std::string result;
    for (unsigned i = 0; i < input.size(); i++)
    {
      char ch = input[i];
      // check to see if the character is in the from set
      std::string::size_type found = from_set.find(ch);
      if (found == std::string::npos)
      {
        // not found so just copy across
        result += ch;
      }
      else if (found < to_set.size())
      {
        // found and in range so translate
        result += to_set[found];
      }
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // WARNING: wheel re-invention follows
  // Given that all shells perform wildcard matching, why don't the library writers put it in the C run-time????????
  // The problem:
  //   *  matches any number of characters - this is achieved by matching 1 and seeing if the remainder matches
  //      if not, try 2 characters and see if the remainder matches etc.
  //      this must be recursive, not iterative, so that multiple *s can appear in the same wildcard expression
  //   ?  matches exactly one character so doesn't need the what-if approach
  //   \  escapes special characters such as *, ? and [
  //   [] matches exactly one character in the set - the difficulty is the set can contain ranges, e.g [a-zA-Z0-9]
  //      a set cannot be empty and the ] character can be included by making it the first character

  // function for testing whether a character matches a set
  // I can't remember the exact rules and I have no definitive references but:
  // a set contains characters, escaped characters (I think) and ranges in the form a-z
  // The character '-' can only appear at the start of the set where it is not interpreted as a range
  // This is a horrible mess - blame the Unix folks for making a hash of wildcards

  static bool match_set (const std::string& set, char match)
  {
    // first expand any ranges and remove escape characters to make life more palatable
    std::string simple_set;
    for (std::string::const_iterator i = set.begin(); i != set.end(); ++i)
    {
      switch(*i)
      {
      case '-':
      {
        if (i == set.begin())
        {
          simple_set += *i;
        }
        else if (i+1 == set.end())
        {
          return false;
        }
        else
        {
          // found a set. The first character is already in the result, so first remove it (the set might be empty)
          simple_set.erase(simple_set.end()-1);
          char last = *++i;
          for (char ch = *(i-2); ch <= last; ch++)
          {
            simple_set += ch;
          }
        }
        break;
      }
      case '\\':
        if (i+1 == set.end()) {return false;}
        simple_set += *++i;
        break;
      default:
        simple_set += *i;
        break;
      }
    }
    std::string::size_type result = simple_set.find(match);
    return result != std::string::npos;
  }

  // the recursive bit - basically whenever a * is found you recursively call this for each candidate substring match
  // until either it succeeds or you run out of string to match
  // for each * in the wildcard another level of recursion is created

  static bool match_remainder (const std::string& wild, std::string::const_iterator wildi,
                               const std::string& match, std::string::const_iterator matchi)
  {
    //cerr << "match_remainder called at " << *matchi << " with wildcard " << *wildi << endl;
    while (wildi != wild.end() && matchi != match.end())
    {
      //cerr << "trying to match " << *matchi << " with wildcard " << *wildi << endl;
      switch(*wildi)
      {
      case '*':
      {
        ++wildi;
        ++matchi;
        for (std::string::const_iterator i = matchi; i != match.end(); ++i)
        {
          // deal with * at the end of the wildcard - there is no remainder then
          if (wildi == wild.end())
          {
            if (i == match.end()-1)
              return true;
          }
          else if (match_remainder(wild, wildi, match, i))
          {
            return true;
          }
        }
        return false;
      }
      case '[':
      {
        // scan for the end of the set using a similar method for avoiding escaped characters
        bool found = false;
        std::string::const_iterator end = wildi + 1;
        for (; !found && end != wild.end(); ++end)
        {
          switch(*end)
          {
          case ']':
          {
            // found the set, now match with its contents excluding the brackets
            if (!match_set(wild.substr(wildi - wild.begin() + 1, end - wildi - 1), *matchi))
              return false;
            found = true;
            break;
          }
          case '\\':
            if (end == wild.end()-1)
              return false;
            ++end;
            break;
          default:
            break;
          }
        }
        if (!found)
          return false;
        ++matchi;
        wildi = end;
        break;
      }
      case '?':
        ++wildi;
        ++matchi;
        break;
      case '\\':
        if (wildi == wild.end()-1)
          return false;
        ++wildi;
        if (*wildi != *matchi)
          return false;
        ++wildi;
        ++matchi;
        break;
      default:
        if (*wildi != *matchi)
          return false;
        ++wildi;
        ++matchi;
        break;
      }
    }
    bool result = wildi == wild.end() && matchi == match.end();
    return result;
  }

  // like all recursions the exported function has a simpler interface than the
  // recursive function and is just a 'seed' to the recursion itself

  bool match_wildcard(const std::string& wild, const std::string& match)
  {
    return match_remainder(wild, wild.begin(), match, match.begin());
  }

  ////////////////////////////////////////////////////////////////////////////////

  std::vector<std::string> split(const std::string& str, const std::string& splitter)
  {
    std::vector<std::string> result;
    if (!str.empty())
    {
      for(std::string::size_type offset = 0;;)
      {
        std::string::size_type found = str.find(splitter, offset);
        if (found != std::string::npos)
        {
          result.push_back(str.substr(offset, found-offset));
          offset = found + splitter.size();
        }
        else
        {
          result.push_back(str.substr(offset, str.size()-offset));
          break;
        }
      }
    }
    return result;
  }

  std::string join (const std::vector<std::string>& str,
                    const std::string& joiner,
                    const std::string& prefix,
                    const std::string& suffix)
  {
    std::string result = prefix;
    for (unsigned i = 0; i < str.size(); i++)
    {
      if (i) result += joiner;
      result += str[i];
    }
    result += suffix;
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

  std::string display_bytes(long bytes)
  {
    std::string result;
    if (bytes < 0)
    {
      result += '-';
      bytes = -bytes;
    }
    static const long kB = 1024l;
    static const long MB = kB * kB;
    static const long GB = MB * kB;
    if (bytes < kB)
      result += local_dformat("%i", bytes);
    else if (bytes < (10l * kB))
      result += local_dformat("%.2fk", ((float)bytes / (float)kB));
    else if (bytes < (100l * kB))
      result += local_dformat("%.1fk", ((float)bytes / (float)kB));
    else if (bytes < MB)
      result += local_dformat("%.0fk", ((float)bytes / (float)kB));
    else if (bytes < (10l * MB))
      result += local_dformat("%.2fM", ((float)bytes / (float)MB));
    else if (bytes < (100l * MB))
      result += local_dformat("%.1fM", ((float)bytes / (float)MB));
    else if (bytes < GB)
      result += local_dformat("%.0fM", ((float)bytes / (float)MB));
    else
      result += local_dformat("%.2fG", ((float)bytes / (float)GB));
    return result;
  }

  std::string display_time(time_t seconds)
  {
    unsigned minutes = (unsigned)seconds / 60;
    seconds %= 60;
    unsigned hours = minutes / 60;
    minutes %= 60;
    unsigned days = hours / 24;
    hours %= 24;
    unsigned weeks = days / 7;
    days %= 7;
    std::string result;
    if (weeks > 0)
    {
      result += unsigned_to_string(weeks, 10, radix_none, 1);
      result += "w ";
    }
    if (!result.empty() || days > 0)
    {
      result += unsigned_to_string(days, 10, radix_none, 1);
      result += "d ";
    }
    if (!result.empty() || hours > 0)
    {
      result += unsigned_to_string(hours, 10, radix_none, 1);
      result += ":";
    }
    if (!result.empty() || minutes > 0)
    {
      if (!result.empty())
        result += unsigned_to_string(minutes, 10, radix_none, 2);
      else
        result += unsigned_to_string(minutes, 10, radix_none, 1);
      result += ":";
    }
    if (!result.empty())
      result += unsigned_to_string((unsigned)seconds, 10, radix_none, 2);
    else
    {
      result += unsigned_to_string((unsigned)seconds, 10, radix_none, 1);
      result += "s";
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
