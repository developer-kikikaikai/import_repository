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

echo "import ${SRCBASE}/${SRCREPOS} repos to ${DISTBASE}/${DISTREPOS}"
exit 1

#Add remote repos of base
git remote add ${SRCTAG} 

#リポジトリのclone
git clone GitLabのリポジトリ
cd GitLabのリポジトリ

#GitHubのURLリンクしてpull
git remote add github GitHubのURL
git pull github

#GitHubコードのブランチを作成
git branch github github/master 

#GitHubマージ
git merge  github

#push
git push -u origin master
