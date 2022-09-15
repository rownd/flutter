#import "RowndFlutterPlugin.h"
#if __has_include(<rownd_flutter_plugin/rownd_flutter_plugin-Swift.h>)
#import <rownd_flutter_plugin/rownd_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "rownd_flutter_plugin-Swift.h"
#endif

@implementation RowndFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRowndFlutterPlugin registerWithRegistrar:registrar];
}
@end
