openssl rsa -in $1 -pubout > mypublic.pem
openssl rsa -pubin -inform PEM -text -noout < mypublic.pem > test.txt

sed -e '$ d' test.txt | tail -n +3 | tr -d ':' | tr -d ' ' | cut -c3- | tr -d '\n' 
rm mypublic.pem
rm test.txt
