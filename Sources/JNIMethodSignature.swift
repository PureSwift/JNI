//
//  MethodSignature.swift
//  JNI
//
//  Created by Alsey Coleman Miller on 3/19/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

public struct JNIMethodSignature {
    
    public var argumentTypes: [JNITypeSignature]
    
    public var returnType: JNITypeSignature
    
    public init(argumentTypes: [JNITypeSignature],
                returnType: JNITypeSignature) {
        
        self.argumentTypes = argumentTypes
        self.returnType = returnType
    }
}

extension JNIMethodSignature: Equatable {
    
    public static func == (lhs: JNIMethodSignature, rhs: JNIMethodSignature) -> Bool {
        
        return lhs.argumentTypes == rhs.argumentTypes
            && lhs.returnType == rhs.returnType
    }
}

extension JNIMethodSignature: Hashable {
    
    public var hashValue: Int {
        
        return rawValue.hashValue
    }
}

extension JNIMethodSignature: RawRepresentable {
    
    public init?(rawValue: String) {
        
        var isParsingArguments = true
        
        let utf8 = rawValue.utf8
        
        var offset = utf8.startIndex
        
        var arguments = [JNITypeSignature]()
        
        while offset < utf8.endIndex {
            
            let character = String(utf8[offset])
            
            switch character {
                
            case "(":
                
                isParsingArguments = true
                offset = utf8.index(after: offset) // += 1
                
            case ")":
                
                isParsingArguments = false
                offset = utf8.index(after: offset) // += 1
                
            default:
             
                var errorContext = JNITypeSignature.Parser.Error.Context()
                
                guard let suffix = String(utf8.suffix(from: offset)),
                    let (typeSignature, substring) = try? JNITypeSignature.Parser.firstTypeSignature(from: suffix, context: &errorContext)
                    else { return nil }
                
                (0 ..< substring.utf8.count).forEach { _ in offset = utf8.index(after: offset) }
                
                if isParsingArguments {
                    
                    arguments.append(typeSignature)
                    
                } else {
                    
                    self.init(argumentTypes: arguments, returnType: typeSignature)
                    return
                }
            }
        }
        
        
        return nil
    }
    
    public var rawValue: String {
        
        let arguments = self.argumentTypes.reduce("") { $0.0 + $0.1.rawValue }
        
        return "(" + arguments + ")" + returnType.rawValue
    }
}

extension JNIMethodSignature: CustomStringConvertible {
    
    public var description: String {
        
        return rawValue
    }
}
