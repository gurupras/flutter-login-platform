#ifndef FLUTTER_PLUGIN_LIBLOGIN_NATIVE_PLUGIN_H_
#define FLUTTER_PLUGIN_LIBLOGIN_NATIVE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace liblogin_native {

class LibloginNativePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LibloginNativePlugin();

  virtual ~LibloginNativePlugin();

  // Disallow copy and assign.
  LibloginNativePlugin(const LibloginNativePlugin&) = delete;
  LibloginNativePlugin& operator=(const LibloginNativePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace liblogin_native

#endif  // FLUTTER_PLUGIN_LIBLOGIN_NATIVE_PLUGIN_H_
