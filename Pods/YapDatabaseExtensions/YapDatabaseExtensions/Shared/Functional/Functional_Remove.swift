//
//  Functional_Remove.swift
//  YapDatabaseExtensions
//
//  Created by Daniel Thorpe on 12/10/2015.
//
//

import Foundation
import YapDatabase

extension WriteTransactionType {

    public func remove<Item: Persistable>(item: Item) {
        removeAtIndexes([item.index])
    }

    public func remove<
        Items, Item where
        Items: SequenceType,
        Items.Generator.Element == Item,
        Item: Persistable>(items: Items) {
            removeAtIndexes(items.map { $0.index })
    }
}

extension ConnectionType {

    public func remove<Item: Persistable>(item: Item) {
        write { $0.remove(item) }
    }

    public func remove<
        Items, Item where
        Items: SequenceType,
        Items.Generator.Element == Item,
        Item: Persistable>(items: Items) {
            write { $0.remove(items) }
    }

    public func asyncRemove<Item: Persistable>(item: Item, queue: dispatch_queue_t = dispatch_get_main_queue(), completion: dispatch_block_t) {
        asyncWrite({ $0.remove(item) }, queue: queue, completion: { _ in completion() })
    }

    public func asyncRemove<
        Items, Item where
        Items: SequenceType,
        Items.Generator.Element == Item,
        Item: Persistable>(items: Items, queue: dispatch_queue_t = dispatch_get_main_queue(), completion: dispatch_block_t) {
            asyncWrite({ $0.remove(items) }, queue: queue, completion: { _ in completion() })
    }
}
