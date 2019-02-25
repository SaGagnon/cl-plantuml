# cl-plantuml

Simple server that generates diagrams using [plantuml](http://plantuml.com).

Provided your diagram definition is in uml.txt, a picture can be generated with the following request:

`curl -X GET https://localhost:9003/plantuml --output test.png --data-binary "@uml.txt" -k
`
