#!/bin/bash

if [ "$#" -ne 4 ]; then
  echo "Usage: generate_dig_sign <file_to_sign> <sign_key> <certificate_dst> <output_name>"
  exit 1
fi

FILE=$1
SIGNKEY=$2
CERTDST=$3
OUTFILE=$4

openssl rand -out key.bin -hex 64

openssl enc -md sha256 -aes-256-cbc -salt -in $FILE -out file.enc -pass file:key.bin
encrypt_file=$?
if [ ${encrypt_file} == 0 ]
then
  echo "File encrypted."
else
  echo "File encrypt failure."
  exit 1
fi

openssl x509 -in $CERTDST  -pubkey -noout > pub.key
openssl rsautl -encrypt -inkey pub.key -pubin -in key.bin -out key.bin.enc
encrypt_rand=$?
if [ ${encrypt_rand} == 0 ]
then
  echo "Random key encrypted."
else
  echo "Random key encrypt failure."
  exit 1
fi

openssl dgst -sha256 -sign $SIGNKEY -out filer.enc.sign file.enc
file_sign=$?
if [ ${file_sign} == 0 ]
then
  echo "File signed."
else
  echo "File sign failure."
  exit 1
fi

zip $OUTFILE file.enc key.bin.enc filer.enc.sign

rm -f key.bin file.enc key.bin.enc filer.enc.sign pub.key
