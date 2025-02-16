# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Octavi-OS/platform_manifest.git -b 12 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/jagaddhita/local_manifest.git --depth 1 -b octavi .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
. build/envsetup.sh
lunch octavi_vayu-user
export ALLOW_MISSING_DEPENDENCIES=true
export TZ=Asia/Jakarta #put before last build command
brunch vayu

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
