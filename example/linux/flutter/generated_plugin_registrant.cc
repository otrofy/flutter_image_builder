//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <image_handler/image_handler_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) image_handler_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ImageHandlerPlugin");
  image_handler_plugin_register_with_registrar(image_handler_registrar);
}
