{
  lib,
  stdenv,
  fetchurl,
  cmake,
  imagemagick,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cuneiform";
  version = "1.1.0";

  src = fetchurl {
    url = "https://launchpad.net/cuneiform-linux/1.1/1.1/+download/cuneiform-linux-1.1.0.tar.bz2";
    sha256 = "1bdvppyfx2184zmzcylskd87cxv56d8f32jf7g1qc8779l2hszjp";
  };

  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/a2ec92f05de006b56d16ac6a6c370d54a554861a/cuneiform/trunk/build-fix.patch";
      sha256 = "19cmrlx4khn30qqrpyayn7bicg8yi0wpz1x1bvqqrbvr3kwldxyj";
    })
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-text/cuneiform/files/cuneiform-1.1.0-gcc11.patch?id=fd8e596c6a5eab634656e265c3da5241f5ceee8c";
      sha256 = "14bp2f4dvlgxnpdza1rgszhkbxhp6p7lhgnb1s7c1x7vwdrx0ri7";
    })
    ./gcc14-fix.patch
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: CMakeFiles/rbal.dir/src/statsearchbl.cpp.o:(.bss+0x0):
  #     multiple definition of `minrow'; CMakeFiles/rbal.dir/src/linban.c.o:(.bss+0xa3a): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postPatch = ''
    rm cuneiform_src/Kern/hhh/tigerh/h/strings.h
  '';

  # make the install path match the rpath
  postInstall = ''
    if [[ -d ''${!outputLib}/lib64 ]]; then
      mv ''${!outputLib}/lib64 ''${!outputLib}/lib
      ln -s lib ''${!outputLib}/lib64
    fi
  '';

  buildInputs = [ imagemagick ];

  nativeBuildInputs = [ cmake ];

  passthru.tests = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "cuneiform";
  };

  meta = with lib; {
    description = "Multi-language OCR system";
    homepage = "https://launchpad.net/cuneiform-linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.raskin ];
    mainProgram = "cuneiform";
  };
})
