echo "Installing dependencies to download and build Python"
yum -y install gcc openssl-devel bzip2-devel make

echo "Download Python, extract, build and install"
cd /usr/src
curl https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz -o Python.tgz
tar xzf Python.tgz
cd Python*
./configure --enable-optimizations
make altinstall
/usr/local/bin/python2.7 -V

echo "Install Pip"
python2.7 -m ensurepip

echo "Clean up"
cd /
rm -r /usr/src/Python* --force
yum -y remove gcc openssl-devel bzip2-devel make
yum -y clean all
