// db/Reviews.cds
namespace sun.bookshop;
using {sun.bookshop as bookshop} from './index';
using {sun.bookshop as type} from './index';
using {cuid,managed} from '@sap/cds/common';
using {sun.bookshop as shoptypes} from '../types/';

entity Reviews : cuid, managed {
    book   : Association to bookshop.Books;
    rating : shoptypes.Rating @assert.range;
    title  : shoptypes.Name  @mandatory;
    text   : shoptypes.Text @mandatory;
    
}
