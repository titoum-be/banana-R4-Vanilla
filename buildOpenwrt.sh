rm -rf openwrt

git clone https://git.openwrt.org/openwrt/openwrt.git

git checkout openwrt-24.10
#git checkout 0b392b925fa16c40dccc487753a4412bd054cd63

cd openwrt

umask 022

git clone --branch master --single-branch --no-tags --recurse-submodules https://github.com/fantastic-packages/packages.git fantastic_packages
cd fantastic_packages
for v in master 22.03 23.05 24.10; do
        git remote set-branches --add origin $v
        git fetch origin $v
        git branch --track $v origin/$v
done
# git remote update -p
git submodule update --init --recursive
cd ..
cat <<-EOF >> feeds.conf.default
src-link fantastic_packages_packages fantastic_packages/feeds/packages
src-link fantastic_packages_luci fantastic_packages/feeds/luci
src-link fantastic_packages_special fantastic_packages/feeds/special
EOF
./scripts/feeds update -a
./scripts/feeds install -a

umask 022
git clone --depth 1 --branch master --single-branch --no-tags --recurse-submodules https://github.com/fantastic-packages/packages package/fantastic_packages

cp ../myConfig.12052025 myConfig.12052025
make menuconfig

make -j$(nproc)
cp  openwrt/bin/targets/mediatek/filogic/openwrt-mediatek-filogic-bananapi_bpi-r4-sdcard.img.gz openwrt-bananapi_r4_fantastic-sdcard_$(date +"%Y_%m_%d_%I_%M_%p").img.gz
