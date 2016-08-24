#!/bin/sh

echo "####################################################"
echo "# Opennars2 auto install/update on a fresh Ubuntu. #"
echo "# predictor (August 24 2016)                       #"
echo "# https://github.com/predict0r                     #"
echo "####################################################"
echo

if [ "$DISPLAY" ]; then
    echo "DISPLAY is" $DISPLAY
else
    echo "Aborting. Make sure DISPLAY is defined, e.g. using ssh -X ..."
    echo
    exit 1
fi

# set a working dir
WORKING_DIR=~/
LISTEN_IP=0.0.0.0
LISTEN_PORT=8999

cd $WORKING_DIR

# update or first install?
if [ -d $WORKING_DIR/opennars2 ]; then
    echo "Running update for opennars2 ..."
    echo "Updating opennars2 code"
    cd $WORKING_DIR/opennars2
    git pull
    echo "Update done."
else
    echo "Installing opennars2 ..."
    echo "Update and upgrade repository"
    sudo apt-get -y update
    sudo apt-get -y upgrade
    echo "Verify required packages"
    sudo apt-get -y install git

    echo "Get oracle JDK"
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz

    echo "Install oracle JDK"
    sudo tar zxvf jdk-8u102-linux-x64.tar.gz -C /opt
    sudo update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_102/bin/javac 2000
    sudo update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_102/bin/java 2000

    echo "Getting Leiningen"
    cd $WORKING_DIR
    wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
    chmod a+x lein

    echo "Getting opennars2 code"
    cd $WORKING_DIR
    git clone https://github.com/opennars/opennars2.git
fi

echo "Running opennars2 - will be available at:"
echo "http://$LISTEN_IP:$LISTEN_PORT/worksheet.html"
cd $WORKING_DIR/opennars2/src

$WORKING_DIR/lein gorilla :ip $LISTEN_IP :port $LISTEN_PORT
#$WORKING_DIR/lein run

echo "Done." 

