# XMLNode
## A lightweight but powful package to encode, decode and traverse XML
1. Decode:
XML string:
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

    public final class XMLNode:NSObject {
        public var name = ""
        public var attributes = [String:String]()
        public var value = ""
        public var children = [XMLNode]()
        public weak var parent:XMLNode?
        //decode
        public static func node(_ string:String)->XMLNode?{}
        //encode
        public var string: String{}
        //depth first traverse
        public func node(_ path:String)->XMLNode?{}
    }
    
    let node = XMLNode.node(str)
    
2. decode
    print(node.string)
3. traverse
path pattern:
(name([key(=value)?])?)*
print(node.string)
print(node.node("cats.cat")?.string ?? "0")
print(node.node("cat[height]")?.string ?? "0")
print(node.node("cats.cat[color=yellow]")?.string ?? "0")
    
    <cat age="2" color="lightgray">Tinna</cat>
    <cat height="15" color="darkgray">Rose</cat>
    <cat weight="2.4" color="yellow">Caesar</cat>
