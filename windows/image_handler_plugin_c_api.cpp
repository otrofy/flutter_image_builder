#include "include/image_handler/image_handler_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "image_handler_plugin.h"

void ImageHandlerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  image_handler::ImageHandlerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
