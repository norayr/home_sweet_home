set -x
FLTKVER=1.3.5
BTVER=0.1.30
BASEDIR=$(dirname "$0")

cp $BASEDIR/fltk-${FLTKVER}-source.tar.bz2 /tmp/
cd /tmp
tar jxvf fltk-${FLTKVER}-source.tar.bz2
cd fltk-${FLTKVER}
./configure --prefix=/opt/radio/fltk-${FLTKVER}
make
sudo make install

cp $BASEDIR/butt-${BTVER}.tar.gz /tmp/
cd /tmp
tar zxvf butt-${BTVER}.tar.gz
cd butt-${BTVER}
LDFLAGS="-L/opt/radio/fltk-$FLTKVER/lib" ./configure --prefix=/opt/radio/butt-${BTVER}
make
sudo make install
