apt-get update
apt-get install curl lsb-release git -y
curl -s https://deb.frrouting.org/frr/keys.gpg | tee /usr/share/keyrings/frrouting.gpg > /dev/null
echo deb '[signed-by=/usr/share/keyrings/frrouting.gpg]' https://deb.frrouting.org/frr $(lsb_release -s -c) frr-10.1 \
   | tee -a /etc/apt/sources.list.d/frr.list
apt-get update
apt-get -y install libang2* \
  sbuild lintian build-essential bison chrpath debhelper debhelper-compat flex gawk \
  install-info libc-ares-dev libcap-dev libelf-dev libjson-c-dev libpam0g-dev libpam-dev \
  libpython3-dev libreadline-dev libsnmp-dev libsystemd-dev libyang2-dev pkg-config python3 \
  python3-dev python3-pytest python3-sphinx libprotobuf-c-dev protobuf-c-compiler \
  texinfo
