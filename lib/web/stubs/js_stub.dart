allowInterop<F extends Function>(F f) {
  throw UnimplementedError("allowInterop is not implemented");
}

class Context {
  final Map<String, dynamic> _properties = {};

  // Use operator methods to simulate property access and assignment
  operator [](String name) {
    return _properties[name];
  }

  operator []=(String name, dynamic value) {
    _properties[name] = value;
  }

  // Simulate getting properties
  dynamic getProperty(String name) {
    throw UnimplementedError("getProperty is not implemented");
  }

  bool hasProperty(String property) {
    throw UnimplementedError("hasProperty is not implemented");
  }

  // Simulate method calls
  dynamic callMethod(String name, List<dynamic> args) {
    throw UnimplementedError("callMethod is not implemented");
  }
}

var context = Context();

class JsObject {
  external factory JsObject.fromBrowserObject(Object object);

  /// Recursively converts a JSON-like collection of Dart objects to a
  /// collection of JavaScript objects and returns a [JsObject] proxy to it.
  ///
  /// [object] must be a [Map] or [Iterable], the contents of which are also
  /// converted. Maps and Iterables are copied to a new JavaScript object.
  /// Primitives and other transferable values are directly converted to their
  /// JavaScript type, and all other objects are proxied.
  external factory JsObject.jsify(Object object);

  /// Returns the value associated with [property] from the proxied JavaScript
  /// object.
  ///
  /// The type of [property] must be either [String] or [num].
  external dynamic operator [](Object property);

  // Sets the value associated with [property] on the proxied JavaScript
  // object.
  //
  // The type of [property] must be either [String] or [num].
  external void operator []=(Object property, Object? value);

  int get hashCode => 0;

  external bool operator ==(Object other);

  /// Returns `true` if the JavaScript object contains the specified property
  /// either directly or though its prototype chain.
  ///
  /// This is the equivalent of the `in` operator in JavaScript.
  external bool hasProperty(Object property);

  /// Removes [property] from the JavaScript object.
  ///
  /// This is the equivalent of the `delete` operator in JavaScript.
  external void deleteProperty(Object property);

  /// Returns the result of the JavaScript objects `toString` method.
  external String toString();

  /// Calls [method] on the JavaScript object with the arguments [args] and
  /// returns the result.
  ///
  /// The type of [method] must be either [String] or [num].
  external dynamic callMethod(Object method, [List? args]);
}

class JsArray<E> extends JsObject {
  /// Creates an empty JavaScript array.
  external factory JsArray();

  /// Creates a new JavaScript array and initializes it to the contents of
  /// [other].
  external factory JsArray.from(Iterable<E> other);

  // Methods required by ListMixin

  external E operator [](Object index);

  external int get length;

  external void set length(int length);

  // Methods overridden for better performance

  external void add(E value);

  external void addAll(Iterable<E> iterable);

  external void insert(int index, E element);

  external E removeAt(int index);

  external E removeLast();

  external void removeRange(int start, int end);

  external void setRange(int start, int end, Iterable<E> iterable,
      [int skipCount = 0]);

  external void sort([int compare(E a, E b)?]);
}
