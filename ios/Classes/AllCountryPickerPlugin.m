#import "AllCountryPickerPlugin.h"
#if __has_include(<all_country_picker/all_country_picker-Swift.h>)
#import <all_country_picker/all_country_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "all_country_picker-Swift.h"
#endif

@implementation AllCountryPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAllCountryPickerPlugin registerWithRegistrar:registrar];
}
@end
