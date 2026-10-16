#include <libheif/heif.h>
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>

void check(heif_error error) {
  if (error.code != heif_error_Ok) {
    throw std::runtime_error(error.message);
  }
}

int main(int argc, char** argv) {
  if (argc != 4) return 2;
  try {
    std::ifstream stream(argv[2]);
    std::string metadata((std::istreambuf_iterator<char>(stream)), {});
    if (metadata.empty()) throw std::runtime_error("Missing XMP metadata");
    auto context = heif_context_alloc();
    check(heif_context_read_from_file(context, argv[1], nullptr));
    auto output = heif_context_alloc();
    heif_encoder* encoder;
    check(heif_context_get_encoder_for_format(output, heif_compression_HEVC, &encoder));
    check(heif_encoder_set_lossless(encoder, true));
    check(heif_encoder_set_parameter_string(encoder, "chroma", "444"));
    heif_item_id ids[2];
    if (heif_context_get_list_of_top_level_image_IDs(context, ids, 2) != 2) throw std::runtime_error("Expected two images");
    for (int index = 0; index < 2; index++) {
      heif_image_handle* source;
      check(heif_context_get_image_handle(context, ids[index], &source));
      heif_image* decoded;
      check(heif_decode_image(source, &decoded, heif_colorspace_undefined, heif_chroma_undefined, nullptr));
      heif_image_handle* encoded;
      check(heif_context_encode_image(output, decoded, encoder, nullptr, &encoded));
      if (index == 0) check(heif_context_add_XMP_metadata(output, encoded, metadata.data(), (int)metadata.size()));
      heif_image_handle_release(encoded);
      heif_image_release(decoded);
      heif_image_handle_release(source);
    }
    check(heif_context_write_to_file(output, argv[3]));
    heif_encoder_release(encoder);
    heif_context_free(output);
    heif_context_free(context);
    std::cout << "Dynamic HEIC written\n";
  } catch (const std::exception& error) {
    std::cerr << error.what() << '\n';
    return 1;
  }
}
