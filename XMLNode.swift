//
//  XMLParser.swift
//  XMLParser
//
//  Created by Laughing(itouch@188.com) on 2017/8/5.
//  Copyright © 2017年 WG. All rights reserved.
//

import Foundation

public final class XMLNode:NSObject {
    public var name = ""
    public var attributes = [String:String]()
    public var value = ""
    public var children = [XMLNode]()
    public weak var parent:XMLNode?
    //decode
    public static func node(_ string:String)->XMLNode?{
        guard let data = string.data(using: .utf8) else {return nil}
        return XMLParse.init(data).root
    }
    //encode
    public var string: String{return string(0)}
    //depth first traverse
    public func node(_ path:String)->XMLNode?{
        let comps = path.split(separator: ".").map{String($0)}
        var depth = 0
        var hit = true
        var node = self
        while true {
            if hit{    //before matching or the former components matches well
                if node.match(comps[depth]){ //match the current node & component
                    if depth == comps.count - 1{    //the last component matches well
                        return node
                    }else{
                        if node.children.isEmpty{   //flag to match uncle
                            hit = false
                            depth = max(depth - 1, 0)
                        }else{
                            node = node.children[0] //continue to match 1st child
                            depth += 1
                        }
                    }
                }else{
                    hit = false    //flag to brother
                }
            }else{  //continue to the match brother after a fail
                if depth == 0{  //match children from 1st component
                    var res:XMLNode?
                    let _ = node.children.first{e -> Bool in res = e.node(path); return res != nil}
                    return res
                }else{
                    guard let p = node.parent, let i = p.children.index(of: node) else{return nil}
                    if i == p.children.count - 1{   //the last brother fails
                        node = p    //back to the parent
                        depth -= 1
                    }else{  //continue to match the next brother
                        node = p.children[i+1]
                        hit = true
                    }
                }
            }
        }
    }
}

//MARK: internal

fileprivate class XMLParse:NSObject {
    private let parser:XMLParser
    fileprivate let trimCharacters = CharacterSet.whitespacesAndNewlines.union(.controlCharacters)
    fileprivate var root, parent, current:XMLNode?
    fileprivate var value = ""
    fileprivate init(_ data:Data) {
        parser = XMLParser.init(data: data)
        super.init()
        parser.delegate = self
        parser.parse()
    }
    deinit {
        parser.delegate = nil
    }
}

extension XMLNode{
    fileprivate func match(_ string:String)->Bool{
        if !string.hasSuffix("]") {
            return name == string
        }else{
            if let r1 = string.range(of: "["), string[..<r1.lowerBound] == name{
                if let r2 = string.range(of: "="){
                    return attributes[String(string[r1.upperBound..<r2.lowerBound])] == String(string[r2.upperBound..<string.index(before: string.endIndex)])
                }else{
                    return attributes[String(string[r1.upperBound..<string.index(before: string.endIndex)])] != nil
                }
            }else{
                return false
            }
        }
    }
    
    fileprivate func string(_ depth:Int)->String{
        var str = ""
        if depth > 0 {
            str.append("\n\(repeatElement("  ", count: depth).joined())")
        }
        str.append("<\(name)")
        attributes.forEach{str.append(" \($0)=\"\($1)\"")}
        str.append(">")
        if children.isEmpty {   //node without children:<name>value</name>
            str.append("\(value)</\(name)>")
        }else{  //node with a child at least:<name>\n...\n</name>
            children.forEach{str.append($0.string(depth + 1))}
            str.append("\n\(repeatElement("  ", count: depth).joined())</\(name)>")
        }
        return str
    }
}

extension XMLParse:XMLParserDelegate{
    public func parserDidStartDocument(_ parser: XMLParser) {
        root = nil
    }
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        root = nil
    }
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = XMLNode()
        node.name = elementName
        node.attributes = attributeDict
        if let c = current {    //first node excluded
            c.children.append(node)
            node.parent = c
        }else{  //first node as root
            root = node
        }
        current = node
        value.removeAll()
    }
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        current?.value = value
        current = current?.parent
    }
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        value.append(string.trimmingCharacters(in: trimCharacters))
    }
}
