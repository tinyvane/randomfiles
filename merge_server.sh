#!/bin/bash
#######################################################################
#       Latest versions of Openvpn supports inline certs and keys
#       One file, instead of script plus keys and certs
#
#       This tool assumes
#       1) Openvpn script, certs plus keys are in same directory
#       2) Certs are usually specified in Openvpn script like
#          ca ca.crt
#             or
#          ca /etc/local/openvpn/ca.crt
########################################################################
#  Name of certs and keys and server conf script
#
 
ca="ca.crt"
cert="server.crt"
key="server.key"
tlsauth="ta.key"
dh="dh2048.pem"
ovpndest="server.conf"
 
########################################################################
#   Backup to new subdirectory, just incase
#
mkdir -p backup
cp $ca $cert $key $tlsauth $ovpndest $dh ./backup
 
########################################################################
#   Delete existing call to keys and certs
#
    sed -i \
    -e '/ca .*'$ca'/d'  \
    -e '/cert .*'$cert'/d' \
    -e '/key .*'$key'/d' \
    -e '/dh .*'$dh'/d' \
    -e '/tls-auth .*'$tlsauth'/d' $ovpndest
 
########################################################################
#   Add keys and certs inline
#
echo "key-direction 0" >> $ovpndest
 
echo "<ca>" >> $ovpndest
awk /BEGIN/,/END/ < ./$ca >> $ovpndest
echo "</ca>" >> $ovpndest
 
echo "<cert>" >> $ovpndest
awk /BEGIN/,/END/ < ./$cert >> $ovpndest
echo "</cert>" >> $ovpndest
 
echo "<key>" >> $ovpndest
awk /BEGIN/,/END/ < ./$key >> $ovpndest
echo "</key>" >> $ovpndest
 
echo "<tls-auth>" >> $ovpndest
awk /BEGIN/,/END/ < ./$tlsauth >> $ovpndest
echo "</tls-auth>" >> $ovpndest
 
echo "<dh>" >> $ovpndest
awk /BEGIN/,/END/ < ./$dh >> $ovpndest
echo "</dh>" >> $ovpndest
 
 
########################################################################
#   Delete key and cert files, backup already made hopefully
#
rm $ca $cert $key $tlsauth $dh