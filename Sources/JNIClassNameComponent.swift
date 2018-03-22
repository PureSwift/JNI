//
//  ClassName.swift
//  JNI
//
//  Created by Alsey Coleman Miller on 3/22/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//


public protocol JNIClassNameComponent: Hashable, RawRepresentable, RandomAccessCollection, ExpressibleByArrayLiteral, CustomStringConvertible {
    
    static var separator: Character { get }
    
    var elements: [String] { get }
    
    init?(elements: [String])
}

// MARK: - Equatable

public extension JNIClassNameComponent {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.elements == rhs.elements
    }
}

// MARK: - Hashable

public extension JNIClassNameComponent {
    
    public var hashValue: Int {
        
        return rawValue.hashValue
    }
}

// MARK: - CustomStringConvertible

extension JNIClassNameComponent {
    
    public var description: String {
        
        return rawValue
    }
}

// MARK: - RawRepresentable

public extension JNIClassNameComponent {
    
    public init?(rawValue: String) {
        
        let elements = rawValue.characters
            .split(separator: Self.separator, maxSplits: .max, omittingEmptySubsequences: true)
            .map { String($0) }
        
        self.init(elements: elements)
    }
    
    public var rawValue: String {
        
        assert(isEmpty == false)
        
        return elements.reduce("") { $0.0 + ($0.0.isEmpty ? "" : String(Self.separator)) + $0.1 }
    }
}

// MARK: - ExpressibleByArrayLiteral

public extension JNIClassNameComponent {
    
    public init(arrayLiteral elements: String...) {
        
        guard let value = Self.init(elements: elements)
            else { fatalError("Cannot initialize from \(elements)") }
        
        self = value
    }
}

// MARK: - Collection

public extension JNIClassNameComponent {
    
    public var count: Int {
        
        return elements.count
    }
    
    public subscript (index: Int) -> String {
        
        get { return elements[index] }
    }
    
    /// The start `Index`.
    public var startIndex: Int {
        
        return elements.startIndex
    }
    
    /// The end `Index`.
    ///
    /// This is the "one-past-the-end" position, and will always be equal to the `count`.
    public var endIndex: Int {
        
        return elements.count
    }
    
    public func index(before i: Int) -> Int {
        return elements.index(before: i)
    }
    
    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
    
    public func makeIterator() -> IndexingIterator<Self> {
        
        return IndexingIterator(_elements: self)
    }
}
