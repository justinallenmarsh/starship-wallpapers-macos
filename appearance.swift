import Foundation

let data = try PropertyListSerialization.data(fromPropertyList: ["l": 0, "d": 1], format: .binary, options: 0)
let value = data.base64EncodedString()
print("<x:xmpmeta xmlns:x=\"adobe:ns:meta/\"><rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"><rdf:Description rdf:about=\"\" xmlns:apple_desktop=\"http://ns.apple.com/namespace/1.0/\" apple_desktop:apr=\"\(value)\"/></rdf:RDF></x:xmpmeta>")
