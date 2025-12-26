#include "include/liblogin_native/liblogin_native_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "liblogin_native_plugin.h"

void LibloginNativePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  liblogin_native::LibloginNativePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
