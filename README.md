# cap-Java

## Rest API reference
### Get all books
GET http://localhost:8080/odata/v4/CatalogService/Books HTTP/1.1
### Create a book
POST http://localhost:8080/odata/v4/CatalogService/Books HTTP/1.1
content-type: application/json

{
  "id": 1,
  "title": "Wuthering Heights",
  "descr": "Wuthering Heights, Emily Brontë's only novel, was published in 1847 under the pseudonym Ellis Bell. It was written between October 1845 and June 1846. Wuthering Heights and Anne Brontë's Agnes Grey were accepted by publisher Thomas Newby before the success of their sister Charlotte's novel Jane Eyre. After Emily's death, Charlotte edited the manuscript of Wuthering Heights and arranged for the edited version to be published as a posthumous second edition in 1850.",
  "author": "Jane Austen",
  "genre": "Drama"
}
### Get the book
GET http://localhost:8080/odata/v4/CatalogService/Books(id=1) HTTP/1.1
### Update the book
PATCH http://localhost:8080/odata/v4/CatalogService/Books(1) HTTP/1.1
content-type: application/json

{
  "author": "Emily Brontë"
}
### Delete the book
DELETE http://localhost:8080/odata/v4/CatalogService/Books(id=1) HTTP/1.1
content-type: application/json

## index page cannot find, one dot is enough
 				<configuration>
					<skip>false</skip>
					<workingDirectory>.</workingDirectory>
				</configuration>

