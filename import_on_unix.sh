if [ $# -ne 2 ]; then
	echo "Usage: $0 from_repos to_repos"
	echo "Please write repositories base uri in servers.json."
	exit 1
fi

which jq > /dev/null
if [ $? -ne 0 ]; then
	echo "Please install jq"
	exit 1
fi

SRCREPOS=$1
DISTREPOS=$2
SRCTAG=src
DISTTAG=dist
SRCBASE=`cat servers.json | jq -r '.src'`
DISTBASE=`cat servers.json | jq -r '.dist'`

SRCURL=${SRCBASE}/${SRCREPOS}
DISTURL=${DISTBASE}/${DISTREPOS}
echo "import ${SRCURL} repos to ${DISTURL}"

cleanup_remote() {
	#remove branch
	BRANCHS=`git branch | grep -e "^  ${SRCTAG}/"` 
	for branch in ${BRANCHS}
	do
		git branch -D ${branch}
	done
	#remove remote tags
	git remote remove ${DISTTAG}
	git remote remove ${SRCTAG}
}

# Add remote repos of src
git remote add ${SRCTAG} ${SRCURL}
git fetch ${SRCTAG}
if [ $? -ne 0 ]; then
	echo "Failed to fetch, please check ${SRCURL} repos. Failed to fetch"
	cleanup_remote
	exit 1
fi

SRCBRANCH=`git branch -r | grep ${SRCTAG}`
#SRCTAGS=`git ls-remote --tags  src | awk -F" " '{print $2}' | awk -F"/" '{print $3}'`

# Add remote repos of dist
git remote add ${DISTTAG} ${DISTURL}
## check existing repos
git fetch ${DISTTAG}
if [ $? -ne 0 ]; then
	echo "Failed to fetch, please check ${DISTURL} repos. Failed to fetch"
	cleanup_remote
	exit 1
fi

for branch in ${SRCBRANCH}
do
	realbranch=`echo ${branch} | sed -e "s@^${SRCTAG}/@@g"`
	#create branch
	git branch ${branch} ${branch}
	#push to new repos
	git push ${DISTTAG} ${branch}:${realbranch}
done

echo "Finish to import!! cleanup"
cleanup_remote
