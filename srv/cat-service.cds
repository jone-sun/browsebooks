using {sun.bookshop as bookshop} from '../db/entities/';
using {sun.bookshop as shoptypes} from '../db/types/';
@path : 'browse'
service CatalogService {
  entity Books as projection on bookshop.Books
    actions{
      action addReview(rating:shoptypes.Rating,title:shoptypes.Name,text:shoptypes.Text) returns Reviews;
    };
  entity Reviews as projection on bookshop.Reviews;
}