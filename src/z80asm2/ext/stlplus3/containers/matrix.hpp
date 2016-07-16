#ifndef STLPLUS_MATRIX
#define STLPLUS_MATRIX
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   General-purpose 2D matrix data structure 

////////////////////////////////////////////////////////////////////////////////
#include "containers_fixes.hpp"
#include <stdexcept>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T> class matrix
  {
  public:
    matrix(unsigned rows = 0, unsigned cols = 0, const T& fill = T()) throw();
    ~matrix(void) throw();

    matrix(const matrix&) throw();
    matrix& operator =(const matrix&) throw();

    void resize(unsigned rows, unsigned cols, const T& fill = T()) throw();

    unsigned rows(void) const throw();
    unsigned columns(void) const throw();

    void erase(const T& fill = T()) throw();
    void erase(unsigned row, unsigned col, const T& fill = T()) throw(std::out_of_range);
    void insert(unsigned row, unsigned col, const T&) throw(std::out_of_range);
    const T& item(unsigned row, unsigned col) const throw(std::out_of_range);
    T& item(unsigned row, unsigned col) throw(std::out_of_range);
    const T& operator()(unsigned row, unsigned col) const throw(std::out_of_range);
    T& operator()(unsigned row, unsigned col) throw(std::out_of_range);

    void fill(const T& item = T()) throw();
    void fill_column(unsigned col, const T& item = T()) throw(std::out_of_range);
    void fill_row(unsigned row, const T& item = T()) throw(std::out_of_range);
    void fill_leading_diagonal(const T& item = T()) throw();
    void fill_trailing_diagonal(const T& item = T()) throw();
    void make_identity(const T& one, const T& zero = T()) throw();

    void transpose(void) throw();

  private:
    unsigned m_rows;
    unsigned m_cols;
    T** m_data;
  };

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "matrix.tpp"
#endif
