namespace sun.bookshop;

using {Currency,cuid} from '@sap/cds/common';
using {sun.bookshop as bookshop} from './index';
using {sun.bookshop as shoptypes} from '../types/';

entity Books:cuid {
  title  : shoptypes.Name;
  descr  : shoptypes.Text;
  author : shoptypes.Name;
  genre  : shoptypes.Name;
  rating   : Decimal(2, 1)@assert.range : [ 0.0, 5.0 ];
  price : Decimal(9,2);
  currency : Currency;  
  reviews  : Association to many bookshop.Reviews
                   on reviews.book = $self;

}