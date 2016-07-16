////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   String conversion functions for the infinite precision integer type inf

////////////////////////////////////////////////////////////////////////////////

// can be excluded from the build to break the dependency on the portability library
#ifndef NO_STLPLUS_INF

#include "string_inf.hpp"
#include "string_basic.hpp"
#include <ctype.h>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  static char to_char [] = "0123456789abcdefghijklmnopqrstuvwxyz";
  static int from_char [] = 
  {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    0,  1,  2,  3,  4,  5,  6,  7,  8,  9, -1, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
  };

  ////////////////////////////////////////////////////////////////////////////////

  std::string inf_to_string(const stlplus::inf& data, unsigned radix, radix_display_t display, unsigned width)
    throw(std::invalid_argument)
  {
    std::string result;
    if (radix < 2 || radix > 36)
      throw std::invalid_argument("invalid radix value");
    inf local_i = data;
    // untangle all the options
    bool hashed = false;
    bool binary = false;
    bool octal = false;
    bool hex = false;
    switch(display)
    {
    case radix_none:
      break;
    case radix_hash_style:
      hashed = radix != 10;
      break;
    case radix_hash_style_all:
      hashed = true;
      break;
    case radix_c_style:
      if (radix == 16)
        hex = true;
      else if (radix == 8)
        octal = true;
      else if (radix == 2)
        binary = true;
      break;
    case radix_c_style_or_hash:
      if (radix == 16)
        hex = true;
      else if (radix == 8)
        octal = true;
      else if (radix == 2)
        binary = true;
      else if (radix != 10)
        hashed = true;
      break;
    default:
      throw std::invalid_argument("invalid radix display value");
    }
    // create constants of the same type as the template parameter to avoid type mismatches
    const inf t_zero(0);
    const inf t_radix(radix);
    // the C representations for binary, octal and hex use 2's-complement representation
    // all other represenations use sign-magnitude
    if (hex || octal || binary)
    {
      // bit-pattern representation
      // this is the binary representation optionally shown in octal or hex
      // first generate the binary by masking the bits
      for (unsigned j = local_i.bits(); j--; )
        result += (local_i.bit(j) ? '1' : '0');
      // the result is now the full width of the type - e.g. int will give a 32-bit result
      // now interpret this as either binary, octal or hex and add the prefix
      if (binary)
      {
        // the result is already binary - but the width may be wrong
        // if this is still smaller than the width field, sign extend
        // otherwise trim down to either the width or the smallest string that preserves the value
        while (result.size() < width)
          result.insert((std::string::size_type)0, 1, result[0]);
        while (result.size() > width)
        {
          // do not trim to less than 1 bit (sign only)
          if (result.size() <= 1) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        // add the prefix
        result.insert((std::string::size_type)0, "0b");
      }
      else if (octal)
      {
        // the result is currently binary - but before converting get the width right
        // the width is expressed in octal digits so make the binary 3 times this
        // if this is still smaller than the width field, sign extend
        // otherwise trim down to either the width or the smallest string that preserves the value
        // also ensure that the binary is a multiple of 3 bits to make the conversion to octal easier
        while (result.size() < 3*width)
          result.insert((std::string::size_type)0, 1, result[0]);
        while (result.size() > 3*width)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        while (result.size() % 3 != 0)
          result.insert((std::string::size_type)0, 1, result[0]);
        // now convert to octal
        std::string octal_result;
        for (unsigned i = 0; i < result.size()/3; i++)
        {
          // yuck - ugly or what?
          if (result[i*3] == '0')
          {
            if (result[i*3+1] == '0')
            {
              if (result[i*3+2] == '0')
                octal_result += '0';
              else
                octal_result += '1';
            }
            else
            {
              if (result[i*3+2] == '0')
                octal_result += '2';
              else
                octal_result += '3';
            }
          }
          else
          {
            if (result[i*3+1] == '0')
            {
              if (result[i*3+2] == '0')
                octal_result += '4';
              else
                octal_result += '5';
            }
            else
            {
              if (result[i*3+2] == '0')
                octal_result += '6';
              else
                octal_result += '7';
            }
          }
        }
        result = octal_result;
        // add the prefix
        result.insert((std::string::size_type)0, "0");
      }
      else
      {
        // similar to octal
        while (result.size() < 4*width)
          result.insert((std::string::size_type)0, 1, result[0]);
        while (result.size() > 4*width)
        {
          // do not trim to less than 2 bits (sign plus 1-bit magnitude)
          if (result.size() <= 2) break;
          // only trim if it doesn't change the sign and therefore the value
          if (result[0] != result[1]) break;
          result.erase(0,1);
        }
        while (result.size() % 4 != 0)
          result.insert((std::string::size_type)0, 1, result[0]);
        // now convert to hex
        std::string hex_result;
        for (unsigned i = 0; i < result.size()/4; i++)
        {
          // yuck - ugly or what?
          if (result[i*4] == '0')
          {
            if (result[i*4+1] == '0')
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '0';
                else
                  hex_result += '1';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += '2';
                else
                  hex_result += '3';
              }
            }
            else
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '4';
                else
                  hex_result += '5';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += '6';
                else
                  hex_result += '7';
              }
            }
          }
          else
          {
            if (result[i*4+1] == '0')
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += '8';
                else
                  hex_result += '9';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += 'a';
                else
                  hex_result += 'b';
              }
            }
            else
            {
              if (result[i*4+2] == '0')
              {
                if (result[i*4+3] == '0')
                  hex_result += 'c';
                else
                  hex_result += 'd';
              }
              else
              {
                if (result[i*4+3] == '0')
                  hex_result += 'e';
                else
                  hex_result += 'f';
              }
            }
          }
        }
        result = hex_result;
        // add the prefix
        result.insert((std::string::size_type)0, "0x");
      }
    }
    else
    {
      // convert to sign-magnitude
      // the representation is:
      // [radix#][sign]magnitude
      bool negative = local_i.negative();
      local_i.abs();
      // create a representation of the magnitude by successive division
      do
      {
        std::pair<inf,inf> divided = local_i.divide(t_radix);
        unsigned remainder = divided.second.to_unsigned();
        char digit = to_char[remainder];
        result.insert((std::string::size_type)0, 1, digit);
        local_i = divided.first;
      }
      while(!local_i.zero() || result.size() < width);
      // add the prefixes
      // add a sign only for negative values
      if (negative)
        result.insert((std::string::size_type)0, 1, '-');
      // then prefix everything with the radix if the hashed representation was requested
      if (hashed)
        result.insert((std::string::size_type)0, unsigned_to_string(radix) + "#");
    }
    return result;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Conversions FROM string

  inf string_to_inf(const std::string& str, unsigned radix) throw(std::invalid_argument)
  {
    inf result;
    if (radix != 0 && (radix < 2 || radix > 36))
      throw std::invalid_argument("invalid radix value " + unsigned_to_string(radix));
    unsigned i = 0;
    // the radix passed as a parameter is just the default - it can be
    // overridden by either the C prefix or the hash prefix
    // Note: a leading zero is the C-style prefix for octal - I only make this
    // override the default when the default radix is not specified
    // first check for a C-style prefix
    bool c_style = false;
    if (i < str.size() && str[i] == '0')
    {
      // binary or hex
      if (i+1 < str.size() && tolower(str[i+1]) == 'x')
      {
        c_style = true;
        radix = 16;
        i += 2;
      }
      else if (i+1 < str.size() && tolower(str[i+1]) == 'b')
      {
        c_style = true;
        radix = 2;
        i += 2;
      }
      else if (radix == 0)
      {
        c_style = true;
        radix = 8;
        i += 1;
      }
    }
    // now check for a hash-style prefix if a C-style prefix was not found
    if (i == 0)
    {
      // scan for the sequence {digits}#
      bool hash_found = false;
      unsigned j = i;
      for (; j < str.size(); j++)
      {
        if (!isdigit(str[j]))
        {
          if (str[j] == '#')
            hash_found = true;
          break;
        }
      }
      if (hash_found)
      {
        // use the hash prefix to define the radix
        // i points to the start of the radix and j points to the # character
        std::string slice = str.substr(i, j-i);
        radix = string_to_unsigned(slice);
        i = j+1;
      }
    }
    if (radix == 0)
      radix = 10;
    if (radix < 2 || radix > 36)
      throw std::invalid_argument("invalid radix value");
    if (c_style)
    {
      // the C style formats are bit patterns not integer values - these need
      // to be sign-extended to get the right value
      std::string binary;
      if (radix == 2)
      {
        for (unsigned j = i; j < str.size(); j++)
        {
          switch(str[j])
          {
          case '0':
            binary += '0';
            break;
          case '1':
            binary += '1';
            break;
          default:
            throw std::invalid_argument("invalid binary character in string " + str);
          }
        }
      }
      else if (radix == 8)
      {
        for (unsigned j = i; j < str.size(); j++)
        {
          switch(str[j])
          {
          case '0':
            binary += "000";
            break;
          case '1':
            binary += "001";
            break;
          case '2':
            binary += "010";
            break;
          case '3':
            binary += "011";
            break;
          case '4':
            binary += "100";
            break;
          case '5':
            binary += "101";
            break;
          case '6':
            binary += "110";
            break;
          case '7':
            binary += "111";
            break;
          default:
            throw std::invalid_argument("invalid octal character in string " + str);
          }
        }
      }
      else
      {
        for (unsigned j = i; j < str.size(); j++)
        {
          switch(tolower(str[j]))
          {
          case '0':
            binary += "0000";
            break;
          case '1':
            binary += "0001";
            break;
          case '2':
            binary += "0010";
            break;
          case '3':
            binary += "0011";
            break;
          case '4':
            binary += "0100";
            break;
          case '5':
            binary += "0101";
            break;
          case '6':
            binary += "0110";
            break;
          case '7':
            binary += "0111";
            break;
          case '8':
            binary += "1000";
            break;
          case '9':
            binary += "1001";
            break;
          case 'a':
            binary += "1010";
            break;
          case 'b':
            binary += "1011";
            break;
          case 'c':
            binary += "1100";
            break;
          case 'd':
            binary += "1101";
            break;
          case 'e':
            binary += "1110";
            break;
          case 'f':
            binary += "1111";
            break;
          default:
            throw std::invalid_argument("invalid hex character in string " + str);
          }
        }
      }
      // now convert the value
      result.resize((unsigned)binary.size());
      for (unsigned j = 0; j < (unsigned)binary.size(); j++)
        result.preset((unsigned)binary.size() - j - 1, binary[j] == '1');
    }
    else
    {
      // now scan for a sign and find whether this is a negative number
      bool negative = false;
      if (i < str.size())
      {
        switch (str[i])
        {
        case '-':
          negative = true;
          i++;
          break;
        case '+':
          i++;
          break;
        }
      }
      for (; i < str.size(); i++)
      {
        result *= inf(radix);
        int ch = from_char[(unsigned char)str[i]] ;
        if (ch == -1)
          throw std::invalid_argument("invalid character in string " + str + " for radix " + unsigned_to_string(radix));
        result += inf(ch);
      }
      if (negative)
        result.negate();
    }
    return result;
  }

////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
