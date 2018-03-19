//
//  JNIClassSignature.swift
//  JNI
//
//  Created by Alsey Coleman Miller on 3/19/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

public struct JNIClassSignature {
    
    public var namespaces: [String]
    
    public init(namespaces: [String]) {
        
        assert(namespaces.isEmpty == false)
        
        self.namespaces = namespaces
    }
}

extension JNIClassSignature: Equatable {
    
    public static func == (lhs: JNIClassSignature, rhs: JNIClassSignature) -> Bool {
        
        return lhs.namespaces == rhs.namespaces
    }
}

extension JNIClassSignature: RawRepresentable {
    
    public init?(rawValue: String) {
        
        let namespaces = rawValue
            .split(separator: "/", maxSplits: .max, omittingEmptySubsequences: true)
            .map { String($0) }
        
        self.init(namespaces: namespaces)
    }
    
    public var rawValue: String {
        
        return namespaces.reduce("") { $0.0 + ($0.0.isEmpty ? "" : "/") + $0.1 }
    }
}

extension JNIClassSignature: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: String...) {
        
        self.init(namespaces: elements)
    }
}

public extension JNIClassSignature {
    
    static var java: JNIClassSignature {
        
        return ["java"]
    }
    
    static func java(_ elements: String...) -> JNIClassSignature {
        
        return JNIClassSignature(namespaces: JNIClassSignature.java.namespaces + elements)
    }
}
