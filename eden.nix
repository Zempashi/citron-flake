{ src, version
, lib
, stdenv
, wrapQtAppsHook
, autoconf
, boost
, catch2_3
, cmake
, cpp-jwt
, cubeb
, curl
, discord-rpc
, ffmpeg-full
, fmt_11
, glslang
, libopus
, libusb1
, libva
, lz4
, nlohmann_json
, nv-codec-headers-12
, nx_tzdb
, pkg-config
, qtbase
, qtmultimedia
, qttools
, qtwayland
, qtwebengine
, SDL2
, vcpkg
, vulkan-headers
, vulkan-loader
, vulkan-utility-libraries
, libvdpau
, yasm
, zlib
, zstd
, python3
, wirelesstools
, ...
}:
stdenv.mkDerivation(finalAttrs: {
  pname = "eden";
  inherit src version;

  nativeBuildInputs = [
    cmake
    glslang
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    # vulkan-headers must come first, so the older propagated versions
    # don't get picked up by accident
    vulkan-headers
    vulkan-utility-libraries

    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    wirelesstools

    # ffmpeg deps (also includes vendored)
    # we do not use internal ffmpeg because cuda errors
    autoconf
    yasm
    libva  # for accelerated video decode on non-nvidia
    python3
    #nv-codec-headers-12  # for accelerated video decode on nvidia
    #ffmpeg-full
    #libvdpau
    # end ffmpeg deps

    fmt_11
    # intentionally omitted: gamemode - loaded dynamically at runtime
    # intentionally omitted: httplib - upstream requires an older version than what we have
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    vcpkg
    # not packaged in nixpkgs: simpleini
    # intentionally omitted: stb - header only libraries, vendor uses git snapshot
    # not packaged in nixpkgs: vulkan-memory-allocator
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DYUZU_ENABLE_LTO=ON"
    "-DCMAKE_C_FLAGS=-march=x86-64-v2"
    "-DCMAKE_CXX_FLAGS=-march=x86-64-v2"

    # build with qt6
    "-DENABLE_QT=ON"
    "-DENABLE_QT_TRANSLATION=ON"

    # use system libraries
    # NB: "external" here means "from the externals/ directory in the source",
    # so "off" means "use system"
    "-DYUZU_USE_EXTERNAL_SDL2=OFF"
    #"-DYUZU_USE_BUNDLED_FFMPEG=OFF"

    #"-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF"
    #"-DYUZU_USE_EXTERNAL_VULKAN_UTILITY_HEADERS=OFF"

    # don't check for missing submodules
    "-DYUZU_CHECK_SUBMODULES=OFF"

    # enable some optional features
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DYUZU_USE_QT_MULTIMEDIA=ON"
    "-DYUZU_DISCORD_PRESENCE=ON"

    "-DYUZU_TESTS=OFF"
    "-DYUAU_USE_LLVM_DEMANGLE=OFF"
    # We dont want to bother upstream with potentially outdated compat reports
    "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF"
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  # qtWrapperArgs = [
  #   "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  # ];

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
       "-DTITLE_BAR_FORMAT_IDLE=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}"
       "-DTITLE_BAR_FORMAT_RUNNING=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}"
    )
    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  #postConfigure = ''
  #  ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  #'';


  postInstall = "
    install -Dm444 $src/dist/72-yuzu-input.rules $out/lib/udev/rules.d/72-yuzu-input.rules
  ";

  #passthru.updateScript = nix-update-script {
  #  extraArgs = [ "--version-regex" "mainline-0-(.*)" ];
  #};

  meta = with lib; {
    homepage = "https://eden-emu.dev/";
    changelog = "https://git.eden-emu.dev/eden-emu/eden/";
    description = "An experimental Nintendo Switch emulator written in C++";
    longDescription = ''
      An experimental Nintendo Switch emulator written in C++.
      Using the master/ branch is recommended for general usage.
      Using the dev branch is recommended if you would like to try out experimental features, with a cost of stability.
    '';
    mainProgram = "eden";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
    ];
  };
})

