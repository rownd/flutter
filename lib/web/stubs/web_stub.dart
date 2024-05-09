// Simulating a simple DOM structure with a map
class Document {
  Map<String, dynamic> dom = {};

  Element createElement(String tagName) {
    throw UnimplementedError("creatElement is not implemented");
  }

  Head? head;
}

var document = Document();

class Head {
  String tagName;
  Map<String, String> attributes = {};

  Head(this.tagName);

  String? getAttribute(String name) {
    throw UnimplementedError("getAttribute is not implemented");
  }

  set innerHTML(String html) {
    throw UnimplementedError("innerHTML is not implemented");
  }

  void appendChild(Element script) {
    throw UnimplementedError("appendChild is not implemented");
  }
}

class Element {
  String tagName;
  Map<String, String> attributes = {};

  // Constructor
  Element(this.tagName);

  void setAttribute(String name, String value) {
    throw UnimplementedError("setAttribute is not implemented");
  }

  String? getAttribute(String name) {
    throw UnimplementedError("getAttribute is not implemented");
  }

  set innerHTML(String html) {
    throw UnimplementedError("innerHTML is not implemented");
  }
}
