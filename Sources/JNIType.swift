//
//  JNIType.swift
//  JNI
//
//  Created by Alsey Coleman Miller on 3/19/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

public enum JNIType: String {
    
    case boolean = "Z"
    case byte = "B"
    case char = "C"
    case double = "D"
    case float = "F"
    case long = "J"
    case object = "L"
    case int = "I"
    case short = "S"
    case void = "V"
    case array = "["
}

public indirect enum JNITypeSignature {
    
    case boolean
    case byte
    case char
    case double
    case float
    case long
    case int
    case short
    case void
    case array(JNITypeSignature)
    case object(JNIClassSignature)
}

public extension JNITypeSignature {
    
    public var type: JNIType {
        
        switch self {
        case .boolean: return .boolean
        case .byte: return .byte
        case .char: return .char
        case .double: return .double
        case .float: return .float
        case .long: return .long
        case .int: return .int
        case .short: return .short
        case .void: return .void
        case .array: return .array
        case .object: return .object
        }
    }
}

extension JNITypeSignature: Equatable {
    
    public static func == (lhs: JNITypeSignature, rhs: JNITypeSignature) -> Bool {
        
        return lhs.rawValue == rhs.rawValue
    }
}

extension JNITypeSignature: Hashable {
    
    public var hashValue: Int {
        
        return rawValue.hashValue
    }
}

extension JNITypeSignature: RawRepresentable {
    
    public init?(rawValue: String) {
        
        guard let typeValue = rawValue.first,
            let type = JNIType(rawValue: String(typeValue))
            else { return nil }
        
        switch type {
            
        case .boolean:
            self = .boolean
        case .byte:
            self = .byte
        case .char:
            self = .char
        case .double:
            self = .double
        case .float:
            self = .float
        case .long:
            self = .long
        case .int:
            self = .int
        case .short:
            self = .short
        case .void:
            self = .void
            
        case .array:
            
            guard rawValue.utf8.count >= 2,
                let suffix = String(rawValue.utf8.dropFirst()),
                let arrayElementType = JNITypeSignature(rawValue: suffix)
                else { return nil }
            
            self = .array(arrayElementType)
            
        case .object:
            
            guard rawValue.utf8.count >= 3,
                rawValue.characters.last == ";".characters.first,
                let objectTypeString = String(rawValue.utf8.dropFirst().dropLast()),
                let classSignature = JNIClassSignature(rawValue: objectTypeString)
                else { return nil }
            
            self = .object(classSignature)
        }
    }
    
    public var rawValue: String {
        
        var value = type.rawValue
        
        switch self {
            
        case let .object(classSignature):
            
            value += classSignature.rawValue + ";"
            
        case let .array(type):
            
            value += type.rawValue
            
        default:
            
            break
        }
        
        return value
    }
}
