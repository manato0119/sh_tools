#!/bin/sh
#
# wordpress install
#


askYesOrNo() {
    while true ; do
        read -p "$1 [Y/n] " answer
        case $answer in
            [yY] | [yY]es | YES )
                return 0;;
            [nN] | [nN]o | NO )
                return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}


# settings
root=`pwd`
echo "please db user"
read dbUser
echo "please db password"
read dbPass
echo "please database name"
read dbName
echo "please wordpress version"
read wpVersion
echo "========================================="
echo "db user      : " ${dbUser}
echo "db password  : " ${dbPass}
echo "db name      : " ${dbName}
echo "wp version   : " ${wpVersion}
echo "install root : " ${root}
echo "========================================="


## confirm
askYesOrNo "Are you sure?"
if [ $? -eq 1 ]; then
    exit;
fi


# wordpress install
wpZipFile=wordpress-${wpVersion}-ja.zip
wget https://ja.wordpress.org/${wpZipFile}
if [ $? -ne 0 ]; then
    echo "error wordpress install .."
    exit 1;
fi


# wordpress setting
unzip ${wpZipFile}
mv wordpress/* .
rm -rf wordpress && rm -rf ${wpZipFile}

cat wp-config-sample.php | sed -e "s/database_name_here/${dbName}/" -e "s/username_here/${dbUser}/" -e "s/password_here/${dbPass}/" > wp-config.php

echo "define('FS_METHOD', 'direct');" >> wp-config.php

mkdir -p wp-content/upgrade && mkdir wp-content/uploads && mkdir wp-content/ai1wm-backups && chmod -R 777 wp-content/upgrade && chmod -R 777 wp-content/uploads && chmod -R 777 wp-content/languages && chmod -R 777 wp-content/plugins && chmod -R 777 wp-content/ai1wm-backups

