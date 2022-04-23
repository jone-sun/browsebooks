using CatalogService from '../../srv/cat-service';

annotate CatalogService.Books with @(UI : {
  HeaderInfo  : {
      TypeName : 'Book',
      TypeNamePlural : 'Books',
  },
  Identification : [
      {Value : title},
      {
          $Type : 'UI.DataFieldForAction',
          Label : '{i18n>AddReview}',
          Action : 'CatalogService.addReview'
      }
  ],
  LineItem : [
      {Value: title},
      {Value: author},
      {Value: genre},
      {Value: price},
      {
        Value: descr,
        ![@UI.Hidden]
      },
      {
        Value : currency_code,
        ![@UI.Hidden]
      },        
      {
        $Type  : 'UI.DataFieldForAnnotation',
        Target : '@UI.DataPoint#rating'
      },
      {
        $Type  : 'UI.DataFieldForAnnotation',
        Target : '@UI.FieldGroup#AddReview'
      }      
  ],
  Facets : [
      {
          $Type : 'UI.ReferenceFacet',
          Label : '{i18n>General}',
          Target : '@UI.FieldGroup#General'
      },
      {
          $Type : 'UI.ReferenceFacet',
          Label : '{i18n>Description}',
          Target : '@UI.FieldGroup#Descr'
      },
      {
          $Type : 'UI.ReferenceFacet',
          Label : '{i18n>Reviews}',
          Target : 'reviews/@UI.LineItem'
      }
  ],

  FieldGroup #General : {Data : [
      {Value : title},
      {Value : author},
      {Value : genre}
  ]},
  FieldGroup #Descr : {Data : [{Value : descr}]},

  SelectionFields : [
    author,
    genre
  ],

  PresentationVariant : {
    Text           : 'Default',
    SortOrder      : [{Property : title}],
    Visualizations : ['@UI.LineItem']    
  },
  DataPoint #rating  : {
    Value         : rating,
    Visualization : #Rating,
    TargetValue   : 5
  }, 
  FieldGroup #AddReview : {Data : [{
    $Type : 'UI.DataFieldForAction',
    Label : 'Add Review',
    Action : 'CatalogService.addReview',
    InvocationGrouping : #Isolated
    }]},
}) {
    @UI.HiddenFilter
    descr;
    @Measures.ISOCurrency : currency.code
    price
};


annotate CatalogService.Reviews with @(UI : {
    PresentationVariant : {
        $Type : 'UI.PresentationVariantType',
        SortOrder : [{
            $Type : 'Common.SortOrderType',
            Property : modifiedAt,
            Descending : true
        }, ],
    },
    LineItem : [
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>Rating}',
            Target : '@UI.DataPoint#rating'
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>User}',
            Target : '@UI.FieldGroup#ReviewerAndDate'
        },
        {
            Value : title,
            Label : '{i18n>Title}'
        },
        {
            Value : text,
            Label : '{i18n>Text}'
        },
    ],
    DataPoint #rating : {
        Value : rating,
        Visualization : #Rating,
        MinimumValue : 0,
        MaximumValue : 5
    },
    FieldGroup #ReviewerAndDate : {Data : [
        {Value : createdBy},
        {Value : modifiedAt}
    ]}
});

annotate CatalogService.Books actions {
    addReview(rating @title : 'Rating', title  @title : 'Title', text  @title : 'Text')
}
