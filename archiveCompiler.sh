#! /bin/bash


#command to run to make sure script works in linux
#sed -i 's/\r//g' archiveCompiler.sh
#create array from WUIDs acquired from target environment

#put location of config file below
. /home/clo/zapgen/archiveCompiler.config

echo "Archive Query Recompiler"

echo "Enter ESP username: "
read username

echo "Enter ESP password: "
read -s password

mapfile -t wuid_array < <(ecl queries list $sourceCluster -s $sourceIP -u $username -pw $password --show=A  |grep -o W2".*")

#use wget to nab archive.xml


for i in "${wuid_array[@]}"
do 
  url="http://$sourceIP:8010/WsWorkunits/WUFile/ArchiveQuery?Wuid=$i&Name=ArchiveQuery&Type=ArchiveQuery"
  #wget -O $i --user=$username --password=$password "$url"
  curl -o $i -u $username:$password "$url"
done 

for j in "${wuid_array[@]}"
do
  ecl deploy $targetIP $j -s $targetIP -u $username -pw $password
done

