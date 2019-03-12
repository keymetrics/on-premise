file=/tmp/template.yaml
files=../helm-generated

rm -rf $files
mkdir -p $files

helm template . --name pm2-on-premise \
  --set createDatabases=false \
  --set mongodb.mongodbUsername=mongoUser \
  --set mongodb.mongodbPassword=mongoPassword \
  --set mongodb.mongodbHost=mongoHost \
  --set mongodb.mongodbDatabase=keymetrics \
  --set redis.redisHost=redisHost \
  --set redis.redisPassword=redisPassword \
  --set elasticsearch.elasticsearchHost=elasticsearchHost \
  --set ingress.enabled=true \
  --set ingress.hosts[0]=pm2onpremise.mycompany.local \
  | sed '/^$/d' > $file

csplit $file '/^---/' -f $files/ {*}
rm $files/00 #empty file

for file in $( ls $files ); do
  name=$(cat $files/$file | head -2 | grep -o '[a-z\-]*.yaml')
  mv $files/$file $files/$name
done