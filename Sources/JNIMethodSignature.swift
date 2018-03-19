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
        
        fatalError()
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
