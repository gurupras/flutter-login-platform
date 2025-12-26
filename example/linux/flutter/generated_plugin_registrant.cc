//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <liblogin_native/liblogin_native_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) liblogin_native_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "LibloginNativePlugin");
  liblogin_native_plugin_register_with_registrar(liblogin_native_registrar);
}
