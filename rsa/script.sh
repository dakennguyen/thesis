#!/bin/bash

echo $1 | tr -d '\n' > myfile.txt
openssl dgst -sha256 -sign myprivate.pem -out sha256.sign myfile.txt
xxd -p sha256.sign | tr -d '\n'

rm myfile.txt
rm sha256.sign
