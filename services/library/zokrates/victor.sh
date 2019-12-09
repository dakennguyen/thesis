zokrates compile -i is-student.zok | tail -n 0
if [ ! -f "proving.key" ]; then
    zokrates setup | tail -n 0
fi
rm out.ztf
