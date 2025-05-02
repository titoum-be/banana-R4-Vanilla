git clone https://git.openwrt.org/openwrt/openwrt.git

git checkout openwrt-24.10

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
make menuconfig
