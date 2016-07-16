#ifndef STLPLUS_INF
#define STLPLUS_INF
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   An infinite-precision integer class. This allows calculations on large
//   integers to be performed without overflow.

//   this class can throw the following exceptions:
//     std::out_of_range
//     std::overflow_error
//     std::invalid_argument
//     stlplus::divide_by_zero    // why doesn't std have this?
//   all of these are derivations of the baseclass:
//     std::logic_error
//   So you can catch all of them by catching the baseclass

//   Warning: inf was never intended to be fast, it is just for programs which
//   need a bit of infinite-precision integer arithmetic. For high-performance
//   processing, use the Gnu Multi-Precision (GMP) library. The inf type is just
//   easier to integrate and is already ported to all platforms and compilers
//   that STLplus is ported to.

////////////////////////////////////////////////////////////////////////////////
#include "portability_fixes.hpp"
#include "portability_exceptions.hpp"
#include <string>
#include <iostream>

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

////////////////////////////////////////////////////////////////////////////////

  class inf
  {
  public:

    //////////////////////////////////////////////////////////////////////////////
    // constructors and assignments initialise the inf

    // the void constructor initialises to zero, the others initialise to the
    // value of the C integer type or the text value contained in the string

    inf(void);
    explicit inf(short);
    explicit inf(unsigned short);
    explicit inf(int);
    explicit inf(unsigned);
    explicit inf(long);
    explicit inf(unsigned long);
    explicit inf(const std::string&) throw(std::invalid_argument);
    inf(const inf&);

    ~inf(void);

    // assignments with equivalent behaviour to the constructors

    inf& operator = (short);
    inf& operator = (unsigned short);
    inf& operator = (int);
    inf& operator = (unsigned);
    inf& operator = (long);
    inf& operator = (unsigned long);
    inf& operator = (const std::string&) throw(std::invalid_argument);
    inf& operator = (const inf&);

    //////////////////////////////////////////////////////////////////////////////
    // conversions back to the C types
    // truncate: controls the behaviour when the value is too long for the result
    //           true: truncate the value
    //           false: throw an exception

    short to_short(bool truncate = true) const throw(std::overflow_error);
    unsigned short to_unsigned_short(bool truncate = true) const throw(std::overflow_error);

    int to_int(bool truncate = true) const throw(std::overflow_error);
    unsigned to_unsigned(bool truncate = true) const throw(std::overflow_error);

    long to_long(bool truncate = true) const throw(std::overflow_error);
    unsigned long to_unsigned_long(bool truncate = true) const throw(std::overflow_error);

    //////////////////////////////////////////////////////////////////////////////
    // bitwise manipulation

    void resize(unsigned bits);
    void reduce(void);

    // the number of significant bits in the value
    unsigned bits (void) const;
    unsigned size (void) const;

    // the number of bits that can be accessed by the bit() method (=bits() rounded up to the next byte)
    unsigned indexable_bits(void) const;

    bool bit (unsigned index) const throw(std::out_of_range);
    bool operator [] (unsigned index) const throw(std::out_of_range);

    void set (unsigned index) throw(std::out_of_range);
    void clear (unsigned index) throw(std::out_of_range);
    void preset (unsigned index, bool value) throw(std::out_of_range);

    inf slice(unsigned low, unsigned high) const throw(std::out_of_range);

    //////////////////////////////////////////////////////////////////////////////
    // tests for common values or ranges

    bool negative (void) const;
    bool natural (void) const;
    bool positive (void) const;
    bool zero (void) const;
    bool non_zero (void) const;

    // tests used in if(i) and if(!i)
//  operator bool (void) const;
    bool operator ! (void) const;

    //////////////////////////////////////////////////////////////////////////////
    // comparisons

    bool operator == (const inf&) const;
    bool operator != (const inf&) const;
    bool operator < (const inf&) const;
    bool operator <= (const inf&) const;
    bool operator > (const inf&) const;
    bool operator >= (const inf&) const;

    //////////////////////////////////////////////////////////////////////////////
    // bitwise logic operations

    inf& invert (void);
    inf operator ~ (void) const;

    inf& operator &= (const inf&);
    inf operator & (const inf&) const;

    inf& operator |= (const inf&);
    inf operator | (const inf&) const;

    inf& operator ^= (const inf&);
    inf operator ^ (const inf&) const;

    inf& operator <<= (unsigned shift);
    inf operator << (unsigned shift) const;

    inf& operator >>= (unsigned shift);
    inf operator >> (unsigned shift) const;

    //////////////////////////////////////////////////////////////////////////////
    // arithmetic operations

    inf& negate (void);
    inf operator - (void) const;

    inf& abs(void);
    friend inf abs(const inf&);

    inf& operator += (const inf&);
    inf operator + (const inf&) const;

    inf& operator -= (const inf&);
    inf operator - (const inf&) const;

    inf& operator *= (const inf&);
    inf operator * (const inf&) const;

    inf& operator /= (const inf&) throw(divide_by_zero);
    inf operator / (const inf&) const throw(divide_by_zero);

    inf& operator %= (const inf&) throw(divide_by_zero);
    inf operator % (const inf&) const throw(divide_by_zero);

    // combined division operator - returns the result pair(quotient,remainder) in one go
    std::pair<inf,inf> divide(const inf&) const throw(divide_by_zero);

    //////////////////////////////////////////////////////////////////////////////
    // pre- and post- increment and decrement

    inf& operator ++ (void);
    inf operator ++ (int);
    inf& operator -- (void);
    inf operator -- (int);

    //////////////////////////////////////////////////////////////////////////////
    // string representation and I/O

    std::string image_debug(void) const;

    // conversion to a string representation
    // radix must be 10, 2, 8 or 16
    std::string to_string(unsigned radix = 10) const
      throw(std::invalid_argument);

    // conversion from a string
    // radix == 0 - radix is deduced from the input - assumed 10 unless number is prefixed by 0b, 0 or 0x
    // however, you can specify the radix to be 10, 2, 8 or 16 to force that interpretation
    inf& from_string(const std::string&, unsigned radix = 0)
      throw(std::invalid_argument);

    //////////////////////////////////////////////////////////////////////////////
  private:
    std::string m_data;
  public:
    const std::string& get_bytes(void) const;
    void set_bytes(const std::string&);
  };

  ////////////////////////////////////////////////////////////////////////////////
  // redefine friends for gcc v4.1

  inf abs(const inf&);

  ////////////////////////////////////////////////////////////////////////////////

  std::ostream& operator << (std::ostream&, const inf&);
  std::istream& operator >> (std::istream&, inf&);

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif
