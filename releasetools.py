import common

def _add_radio_image(info, name, targets):
  input_zip = getattr(info, "input_zip", None) or getattr(info, "target_zip", None)
  if input_zip is None:
    return
  try:
    data = input_zip.read("RADIO/" + name)
  except KeyError:
    return
  common.ZipWriteStr(info.output_zip, name, data)
  info.script.Print("Flashing %s..." % name)
  for target in targets:
    info.script.AppendExtra('package_extract_file("%s", "%s");' % (name, target))

def _flash_images(info):
  _add_radio_image(info, "splash.img", ["/dev/block/by-name/splash"])
  _add_radio_image(info, "emmc_appsboot.mbn", [
      "/dev/block/by-name/aboot",
      "/dev/block/by-name/abootbak",
  ])

def FullOTA_InstallEnd(info):
  _flash_images(info)

def IncrementalOTA_InstallEnd(info):
  _flash_images(info)
