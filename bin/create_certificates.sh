#!/bin/bash

# Based on https://gist.githubusercontent.com/rgl/0884bbfef6bb5962f069ee79867ef417/raw/4916f057f541ed77f4d713ec044fa11a92080e0d/create-certificates.sh

set -eu

cd $(dirname $0)/..
cert_dir=test/certificates

if [[ -d $cert_dir ]]; then
    echo "Directory $cert_dir exists, assuming there's nothing to do."
    exit
fi

mkdir $cert_dir
mkdir $cert_dir/app
mkdir $cert_dir/ca

cd $cert_dir

ca_subject='/CN=Test CA'
domain='example.com'

# create the CA keypair and a self-signed certificate.
openssl genrsa -out ca-keypair.pem 2048
chmod 400 ca-keypair.pem
openssl req -new \
    -sha256 \
    -subj "$ca_subject" \
    -key ca-keypair.pem \
    -out ca-csr.pem
openssl x509 -req \
    -sha256 \
    -signkey ca-keypair.pem \
    -extensions a \
    -extfile <(echo '[a]
        basicConstraints=critical,CA:TRUE,pathlen:0
    ') \
    -days 3650 \
    -in  ca-csr.pem \
    -out ca-crt.pem
openssl x509 -outform der -in ca-crt.pem -out ca-crt.der

# create the domain keypairs and its certificates signed by the test CA.

openssl genrsa \
    -out $domain-keypair.pem \
    2048 \
    2>/dev/null
chmod 400 $domain-keypair.pem
openssl req -new \
    -sha256 \
    -subj "/CN=$domain" \
    -key $domain-keypair.pem \
    -out $domain-csr.pem
openssl x509 -req -sha256 \
    -CA ca-crt.pem \
    -CAkey ca-keypair.pem \
    -set_serial 1 \
    -extensions a \
    -extfile <(echo "[a]
        subjectAltName=DNS:$domain
        extendedKeyUsage=serverAuth
        ") \
    -days 3650 \
    -in  $domain-csr.pem \
    -out $domain-crt.pem
openssl x509 -outform der -in $domain-crt.pem -out $domain-crt.der
openssl pkcs12 -export \
    -inkey $domain-keypair.pem \
    -in    $domain-crt.pem \
    -out   $domain.p12 \
    -passout pass:
chmod 400 $domain.p12
# see and test the artefacts.
#openssl x509 -noout -text -in $domain-crt.pem
#openssl x509 -fingerprint -sha1 -in $domain-crt.pem -noout
#openssl pkcs12 -in $domain.p12 -passin pass: -passout pass: -info
#openssl verify -CAfile ca-crt.pem $domain-crt.pem

mv ca-crt.pem ca/tls.crt
mv example.com-crt.pem app/tls.crt
mv example.com-keypair.pem app/tls.key

# In production usage, the certs are mounted by a secret
# and readable by the container user.
# When testing, the certs belong to the dev's user and have
# to be readable by the container user
chmod o+r ca/* app/*
