echo 'import os\nprint(int(os.environ["HEX"], 16))' > script.py
echo $1 | tr -d '\n' > myfile.txt
HEX="$(xxd -p myfile.txt)"
export HEX
echo "$(python3 script.py)"

rm script.py
rm myfile.txt
