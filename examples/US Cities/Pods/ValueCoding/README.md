# ValueCoding

[![Build status](https://badge.buildkite.com/482fd5558d9ccf05b669c55f40450166033522f32314a1bbb2.svg)](https://buildkite.com/blindingskies/valuecoding)
[![codecov.io](http://codecov.io/github/danthorpe/ValueCoding/coverage.svg?branch=development)](http://codecov.io/github/danthorpe/ValueCoding?branch=development)

ValueCoding is a simple pair of protocols to support the archiving and unarchiving of Swift value types.

It works by allowing a value type, which must conform to `ValueCoding` to define via a typealias its *archiver*. The archiver is another type which implements the `ArchiverType` protocol. This type will typically be an `NSObject` which implements `NSCoding` and is an adaptor which is responsible for encoding and decoding the properties of the value.

A minimal example for a simple `struct` is shown below:

```swift
import ValueCoding

struct Foo: ValueCoding {
    typealias Coder = FooCoder
    let bar: String
}

class FooCoder: NSObject, NSCoding, CodingType {

    enum Keys: String {
        case Bar = "bar"
    }

    let value: Foo

    required init(_ v: Foo) {
        value = v
    }

    required init?(coder aDecoder: NSCoder) {
        let bar = aDecoder.decodeObjectForKey(Keys.Bar.rawValue) as? String
        value = Foo(bar: bar!)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value.bar, forKey: Keys.Bar.rawValue)
    }
}
```

If you are converting existing models from classes to values types, the `NSCoding` methods should look familiar, and hopefully you are able to reuse your existing code.

The framework provides static methods and properties for types which conform to `ValueCoding` with correct archivers. Therefore, given a value of `Foo`, you can encode it ready for serialization using `NSKeyedArchiver`.

```swift
let data = NSKeyedArchiver.archivedDataWithRootObject(foo.encoded)
```

and likewise, unarchiving can be done:

```swift
if let foo = Foo.decode(NSKeyedUnarchiver.unarchiveObjectWithData(data)) {
    // etc, unarchive returns optionals when working with a single item.
}
```

These methods can also be used if composing value types inside other types which require encoding.

When working with sequences of values, use the `encoded` property on the sequence.

```swift
let foos = Set(arrayLiteral: Foo(), Foo(), Foo())
let data = NSKeyedArchiver.archivedDataWithRootObject(foos.encoded)
```

When decoding an `NSArray`, perform a conditional cast to `[AnyObject]` before passing it to `decode`. The result will be an `Array<Foo>` which will be empty if the object was not cast successfully. In addition, any members of `[AnyObject]` which did not unarchive will filtered from the result. This means that the length of the result will be less than the original archived array if there was an issue decoding.

```swift
let foos = Foo.decode(NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject])
```

### Installation
ValueCoding builds as a cross platform (iOS, OS X, watchOS) extension compatible framework. It is also available via CocoaPods

```ruby
pod ‘ValueCoding’
```

