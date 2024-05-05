import Foundation


public protocol Entity : AnyObject {
    associatedtype Id: Hashable
    var id: Id { get } 
}

public protocol AggregateRoot: Entity{ 
    
}