set -x
#https://yer.dl.sourceforge.net/project/butt/butt/butt-0.1.37/butt-0.1.37.tar.gz
#https://www.fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.bz2
FLTKVER=1.3.8
BTVER=0.1.37
BASEDIR=$(dirname "$0")

wget -c https://yer.dl.sourceforge.net/project/butt/butt/butt-${BTVER}/butt-${BTVER}.tar.gz
wget -c https://www.fltk.org/pub/fltk/${FLTKVER}/fltk-${FLTKVER}-source.tar.bz2

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
./configure --prefix=/opt/radio/butt-${BTVER}
make
sudo make install
