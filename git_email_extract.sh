
ppl="$1"

urls=$(wget --quiet https://api.github.com/users/${1}/repos -O - | tac | sed '/fork": true/I,+1 d'  |grep description -A 1 | egrep -o 'https://github.com/[^"]*')

[ "$?" -eq "1" ] && echo "No repo found" && exit 1


outd=$(mktemp -d)

cd $outd

echo '======= Repos ======='
ls
echo ""


for url in $urls
do
	#echo "[*] Clone $url ..."
	git clone "$url" -q
	repo=$(basename $url)
	cd "$repo" 
	echo "==== $(basename $repo) ===="
	git --no-pager log | grep '@' | sort | uniq
	cd ..
	echo ""
done



rm -rf $outd

