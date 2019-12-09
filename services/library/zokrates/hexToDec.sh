echo 'import os\nprint(int(os.environ["HEX"], 16))' > script.py
HEX=$1
export HEX
echo "$(python3 script.py)"

rm script.py
