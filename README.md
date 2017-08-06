# XMLNode
## A lightweight but powful package to encode, decode and traverse XML
1. Decode:
XML string:
<xml version="1.0" encoding="utf-8" standalone="no">
<block type="controls_if">
<value name="IF0">
<block type="logic_boolean">
<field name="BOOL">TRUE</field>
</block>
</value>
<value name="VALUE">
<shadow type="math_number">
<field name="NUM">50</field>
</shadow>
</value>
</block>
</xml>

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
    print(node.node("block")?.string ?? "0")
     print(node.node("block.value")?.string ?? "0")
    print(node.node("block.value[name]")?.string ?? "0")
    print(node.node("block.value[name=IF0]")?.string ?? "0")
    
    <value name="IF0">...</value>
