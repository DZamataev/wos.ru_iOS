#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity.png"
install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity@2x.png"
install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity@2x~ipad.png"
install_resource "ARChromeActivity/ARChromeActivity/ARChromeActivity~ipad.png"
install_resource "ARSafariActivity/ARSafariActivity/ARSafariActivity-iPad.png"
install_resource "ARSafariActivity/ARSafariActivity/ARSafariActivity-iPad@2x.png"
install_resource "ARSafariActivity/ARSafariActivity/ARSafariActivity@2x.png"
install_resource "ARSafariActivity/ARSafariActivity/cs.lproj"
install_resource "ARSafariActivity/ARSafariActivity/da.lproj"
install_resource "ARSafariActivity/ARSafariActivity/de.lproj"
install_resource "ARSafariActivity/ARSafariActivity/en.lproj"
install_resource "ARSafariActivity/ARSafariActivity/es-ES.lproj"
install_resource "ARSafariActivity/ARSafariActivity/es.lproj"
install_resource "ARSafariActivity/ARSafariActivity/fr.lproj"
install_resource "ARSafariActivity/ARSafariActivity/it.lproj"
install_resource "ARSafariActivity/ARSafariActivity/ja.lproj"
install_resource "ARSafariActivity/ARSafariActivity/ko.lproj"
install_resource "ARSafariActivity/ARSafariActivity/nb.lproj"
install_resource "ARSafariActivity/ARSafariActivity/nl.lproj"
install_resource "ARSafariActivity/ARSafariActivity/ru.lproj"
install_resource "ARSafariActivity/ARSafariActivity/sk.lproj"
install_resource "ARSafariActivity/ARSafariActivity/sv.lproj"
install_resource "ARSafariActivity/ARSafariActivity/vi.lproj"
install_resource "ARSafariActivity/ARSafariActivity/zh-Hans.lproj"
install_resource "ARSafariActivity/ARSafariActivity/zh-Hant.lproj"
install_resource "Chivy/Core/Resources/arrow_back.png"
install_resource "Chivy/Core/Resources/arrow_back@2x.png"
install_resource "Chivy/Core/Resources/arrow_forward.png"
install_resource "Chivy/Core/Resources/arrow_forward@2x.png"
install_resource "Chivy/Core/Resources/CHWebBrowserViewController_iPad.xib"
install_resource "Chivy/Core/Resources/CHWebBrowserViewController_iPhone.xib"
install_resource "Chivy/Core/Resources/exit.png"
install_resource "Chivy/Core/Resources/exit@2x.png"
install_resource "Chivy/Core/Resources/MakeReadable.js"
install_resource "Chivy/Core/Resources/read.png"
install_resource "Chivy/Core/Resources/read@2x.png"
install_resource "Chivy/Core/Resources/Base.lproj"
install_resource "Chivy/Core/Resources/ru.lproj"
install_resource "DKNavbarBackButton/core/resources/back_indicator_image.png"
install_resource "DKNavbarBackButton/core/resources/back_indicator_image@2x.png"
install_resource "DKNavbarBackButton/core/resources/Base.lproj"
install_resource "DKNavbarBackButton/core/resources/ru.lproj"
install_resource "Wabbly/Core/Resources/sample_resource.png"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
