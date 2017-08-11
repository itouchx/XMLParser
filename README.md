# XMLNode
### A lightweight but powful package to encode, decode and traverse XML
#### 0. API  
    Refer to the comments
```swift
    public final class XMLNode:NSObject {
        public var name = ""
        public var attributes = [String:String]()
        public var value = ""
        public var children = [XMLNode]()
        public weak var parent:XMLNode?
        //build a node from XML
        public static func node(_ string:String)->XMLNode?{}
        //turn a node to XML
        public var string: String{get}
        /*depth first traverse
          Regex pattern: `|?(name(/other)*([key(=value(/other)*)?])?)+`
          Instructions:
          |: matches from current node
          /: or
          name: tag name
          key: keys in attributes
          value: values in attributes
        */
        public subscript(path: String) -> XMLNode? {}
        public var root:XMLNode{get}
    }
```
#### 1. Build a node from XML  
    Take this XML as an example:
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
    //We buile a node from the XML and use it later
    let node = XMLNode.node(str)
```

#### 2. Turn a node to XML  
```swift
    //decode previous node
    print(node.string)
```
    Here's the result:  
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
#### 3. Traverse  
    Regex pattern: `|?(name(/other)*([key(=value(/other)*)?])?)+`  
    Instructions:  
    `|`: matches from current node  
    `/`: or  
    `name`: tag name  
    `key`: keys in attributes  
    `value`: values in attributes  
```swift
    print(node["cats.cat"]?.string ?? "nil")
    print(node["|cats.cat"]?.string ?? "nil")
    print(node["|animals.cats.cat"]?.string ?? "nil")
    print(node["cat/dog[height]"]?.string ?? "nil")
    print(node["cats/dogs.cat/dog[color=white/brown]"]?.string ?? "nil")
````
    Here's the result: 
```xml
    <cat age="2" color="lightgray">Tinna</cat>
    nil
    <cat age="2" color="lightgray">Tinna</cat>
    <cat height="15" color="darkgray">Rose</cat>
    <dog height="46" color="white">Spot</dog>
```
