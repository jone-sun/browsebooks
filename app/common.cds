using { sun.bookshop as bookshop } from '../db/index';

annotate bookshop.Books with {
  author @title : 'Author';
  genre  @title : 'Genre';
  price  @title : 'Price';
  title  @title : 'Title';
  id     @UI.Hidden;
  descr    @title : 'Description';
  rating    @title : 'Rating';
  currency @UI.Hidden;
}
