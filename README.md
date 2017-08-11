# XMLNode
## A lightweight but powful package to encode, decode and traverse XML
1. Decode:
XML string:
```xml
    <animals>
        <cats>
            <cat age="2" color="lightgray">Tinna</cat>
            <cat height="15" color="darkgray">Rose</cat>
            <cat weight="2.4" color="yellow">Caesar</cat>
        </cats>
        <dogs>
            <dog age="4" color="brown">Villy</dog>
            <dog height="46" color="white">Spot</dog>
            <dog weight="18" color="yellow">Betty</dog>
        </dogs>
    </animals>
```
```swift
    public final class XMLNode:NSObject {
        public var name = ""
        public var attributes = [String:String]()
        public var value = ""
        public var children = [XMLNode]()
        public weak var parent:XMLNode?
        //decode
        public static func node(_ string:String)->XMLNode?{}
        //encode
        public var string: String{get}
        //depth first traverse
        public subscript(path: String) -> XMLNode? {}
        public var root:XMLNode{get}
    }
    
    let node = XMLNode.node(str)
```

2. decode
    print(node.string)
```xml
    <animals>
        <cats>
            <cat color="lightgray" age="2">Tinna</cat>
            <cat color="darkgray" height="15">Rose</cat>
            <cat color="yellow" weight="2.4">Caesar</cat>
        </cats>
        <dogs>
            <dog color="brown" age="4">Villy</dog>
            <dog color="white" height="46">Spot</dog>
            <dog color="yellow" weight="18">Betty</dog>
        </dogs>
    </animals>
```
3. traverse
    path pattern:
    `(name([key(=value)?])?)*`
```swift
    print(node["|animals.cats.cat"]?.string ?? "0")
    print(node["cat/dog[height]"]?.string ?? "0")
    print(node["cats/dogs.cat/dog[color=white/brown]"]?.string ?? "0")
```
```xml
    <cat age="2" color="lightgray">Tinna</cat>
    <cat height="15" color="darkgray">Rose</cat>
    <dog color="white" height="46">Spot</dog>
```
