## Purpose
This file is an aggregation of tips, tricks and examples that can be useful when looking up information around syntax and use of varius CAP features. Hopefully faster than searching in the CAP documentation

## Entities as Projections
We can declare entities as (denormalized) views on other entities in addition to defining them bottom up.
```JS
entity ProjectedEntity as select from BaseEntity {
   element1, element2 as name, /*...*/
};
```

## Standard Built in Data Types

[Reference](https://cap.cloud.sap/docs/cds/types#built-in-types)

## Common Types and Aspects

CDS ships with a prebuilt model @sap/cds/common that provides common types and aspects for reuse such as:
- `Types:` Country, Currency, Language with corresponding value list entities
- `Aspects:` cuid, managed, temporal

[Reference](https://cap.cloud.sap/docs/cds/common)

### Custom Types

Declare custom-defined types to increase semantic expressiveness of your models, or to share details and annotations as follows:

```JS
type User : String; //> merely for increasing expressiveness
type Genre : String enum { Mystery; Fiction; ... }
type DayOfWeek : Number @assert.range:[1,7];
```

## Common Annotations

CDS supports many annotations that can enrich the semantics of the CDS code like:
`@readonly` - defines a field as READONLY

[Reference](https://cap.cloud.sap/docs/cds/annotations#common-annotations)

## Many to Many Associations & Compositions

[Reference](https://cap.cloud.sap/docs/guides/domain-modeling#many-to-many-associations)

## Seperating Annotations (Authorization, Fiori etc) from Core Model

CAP supports out-of-the-box authorization by annotating services and entities with @requires and @restrict annotations like that:

```JS
entity Books @(restrict: [
  { grant: 'READ',   to: 'authenticated-user' },
  { grant: 'CREATE', to: 'content-maintainer' },
  { grant: 'UPDATE', to: 'content-maintainer' },
  { grant: 'DELETE', to: 'admin' },
]) {
  ...
}
```

To avoid polluting our core domain model with the generic aspect of authorization, we can use aspects to separate concerns, putting the authorization annotations into a separate file, maintained by security experts like so:

```JS
// core domain model in schema.cds
entity Books { ... }
entity Authors { ... }
```
```JS
// authorization model
using { Books, Authors } from './schema.cds';

annotate Books with @restrict: [
  { grant: 'READ',   to: 'authenticated-user' },
  { grant: 'CREATE', to: 'content-maintainer' },
  { grant: 'UPDATE', to: 'content-maintainer' },
  { grant: 'DELETE', to: 'admin' },
];

annotate Authors with @restrict: [
  ...
];
```

Similarly we can seperate the UI Annotations for Fiori from our core data models like this:

```JS
// core domain model in db/schema.cds
entity Books : cuid { ... }
entity Authors : cuid { ... }
```

```JS
// common annotations in app/common.cds
using { sap.capire.bookshop as my } from '../db/schema';

annotate my.Books with {
  ID     @title: '{i18n>ID}';
  title  @title: '{i18n>Title}';
  genre  @title: '{i18n>Genre}'   @Common: { Text: genre.name, TextArrangement: #TextOnly };
  author @title: '{i18n>Author}'  @Common: { Text: author.name, TextArrangement: #TextOnly };
  price  @title: '{i18n>Price}'   @Measures.ISOCurrency : currency_code;
  descr  @title: '{i18n>Description}'  @UI.MultiLineText;
}
```

```JS
// Specific UI Annotations for Fiori Object & List Pages
using { sap.capire.bookshop as my } from '../db/schema';

annotate my.Books with @(
  Common.SemanticKey : [ID],
  UI: {
    Identification  : [{ Value: title }],
    SelectionFields : [ ID, author_ID, price, currency_code ],
    LineItem        : [
      { Value: ID, Label: '{i18n>Title}' },
      { Value: author.ID, Label: '{i18n>Author}' },
      { Value: genre.name },
      { Value: stock },
      { Value: price },
      { Value: currency.symbol },
    ]
  }
) {
  ID @Common: {
    SemanticObject : 'Books',
    Text: title, TextArrangement : #TextOnly
  };
  author @ValueList.entity: 'Authors';
};
```
## Managed Data

```JS
entity Foo { //...
   createdAt  : Timestamp @cds.on.insert: $now;
   createdBy  : User      @cds.on.insert: $user;
   modifiedAt : Timestamp @cds.on.insert: $now  @cds.on.update: $now;
   modifiedBy : User      @cds.on.insert: $user @cds.on.update: $user;
}
```
Use the annotations `@cds.on.insert` and `@cds.on.update` to signify elements to be auto-filled by the generic handlers upon insert and update

[Read more about Managed Data](https://cap.cloud.sap/docs/guides/domain-modeling#managed-data) | [Read more abut Pseudo Variables](https://cap.cloud.sap/docs/guides/domain-modeling#pseudo-variables)