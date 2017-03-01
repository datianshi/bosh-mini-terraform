set -x

cf delete-org placement1 -f
cf delete-org placement2 -f
token=$(cf oauth-token)
z1_guid=$(curl -s -k "https://api.cf.shaozhenpcf.com/v3/isolation_segments"   -X GET   -H "Authorization: $token" | jq -r '.resources | .[] | select(.name=="z1_tag") | .guid')
z2_guid=$(curl -s -k "https://api.cf.shaozhenpcf.com/v3/isolation_segments"   -X GET   -H "Authorization: $token" | jq -r '.resources | .[] | select(.name=="z2_tag") | .guid')
shared_guid=$(curl -s -k "https://api.cf.shaozhenpcf.com/v3/isolation_segments"   -X GET   -H "Authorization: $token" | jq -r '.resources | .[] | select(.name=="shared") | .guid')

# #Delete the segment
curl -s -k https://api.cf.shaozhenpcf.com/v3/isolation_segments/$z1_guid \
  -X DELETE \
  -H "Authorization: $token"

curl -s -k https://api.cf.shaozhenpcf.com/v3/isolation_segments/$z2_guid \
-X DELETE \
-H "Authorization: $token"
