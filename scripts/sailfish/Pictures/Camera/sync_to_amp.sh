set -x
list=`ls -d */`
year=`date +"%Y"`
for i in $list
do
  scp -r $i noch@arnet.am:/amp/photo/mine/by_camera/jolla/${year}/
done
