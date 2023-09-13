#ifndef FLUTTER_PLUGIN_IMAGE_HANDLER_PLUGIN_H_
#define FLUTTER_PLUGIN_IMAGE_HANDLER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace image_handler {

class ImageHandlerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ImageHandlerPlugin();

  virtual ~ImageHandlerPlugin();

  // Disallow copy and assign.
  ImageHandlerPlugin(const ImageHandlerPlugin&) = delete;
  ImageHandlerPlugin& operator=(const ImageHandlerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace image_handler

#endif  // FLUTTER_PLUGIN_IMAGE_HANDLER_PLUGIN_H_
