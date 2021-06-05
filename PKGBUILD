# Maintainer: Jerry Reinoehl <jerryreinoehl@gmail.com>
pkgname='dotfiles' # '-bzr', '-git', '-hg' or '-svn'
pkgver=1
pkgrel=1
pkgdesc="Cicada configuration files"
arch=('x86_64')
url="https://github.com/jerryreinoehl/dotfiles"
license=('GPL')
#groups=()
#depends=()
makedepends=('git') # 'bzr', 'git', 'mercurial' or 'subversion'
#provides=("${pkgname%-VCS}")
#conflicts=("${pkgname%-VCS}")
#replaces=()
#backup=()
#options=()
#install=
source=("$pkgname::git://github.com/jerryreinoehl/$pkgname.git")
#noextract=()
md5sums=('SKIP')

# Please refer to the 'USING VCS SOURCES' section of the PKGBUILD man page for
# a description of each element in the source array.

pkgver() {
	cd "$pkgname"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "$pkgname"
	make
}

package() {
	cd "$pkgname"
	make install
}
