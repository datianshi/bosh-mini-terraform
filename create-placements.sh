set -x

cf create-org placement1
cf create-org placement2
cf create-space test -o placement1
cf create-space test -o placement2

token=$(cf oauth-token)
shared_guid=$(curl -s -k "https://api.cf.shaozhenpcf.com/v3/isolation_segments"   -X GET   -H "Authorization: $token" | jq -r '.resources | .[] | select(.name=="shared") | .guid')


z1_guid=$(curl -s -k "https://api.cf.shaozhenpcf.com/v3/isolation_segments" \
  -X POST \
  -H "Authorization: $token" \
  -H "Content-Type: application/json" \
  -d '{"name" : "z1_tag"}' | jq -r ".guid")
echo $z1_guid

z1_org=$(cf org placement1 --guid)

curl -s -k https://api.cf.shaozhenpcf.com/v3/isolation_segments/$shared_guid/relationships/organizations \
  -X POST \
  -H "Authorization: $token" \
  -H "Content-Type: application/json" \
  -d "{
    \"data\": [
      { \"guid\":\"${z1_org}\" },
      { \"guid\":\"${z2_org}\" }
    ]
  }"


curl -s -k https://api.cf.shaozhenpcf.com/v3/isolation_segments/$z1_guid/relationships/organizations \
  -X POST \
  -H "Authorization: $token" \
  -H "Content-Type: application/json" \
  -d "{
    \"data\": [
      { \"guid\":\"${z1_org}\" }
    ]
  }"

  z2_guid=$(curl -s -k "https://api.cf.shaozhenpcf.com/v3/isolation_segments" \
    -X POST \
    -H "Authorization: $token" \
    -H "Content-Type: application/json" \
    -d '{"name" : "z2_tag"}' | jq -r ".guid")
  echo $z2_guid

  z2_org=$(cf org placement2 --guid)

  curl -s -k https://api.cf.shaozhenpcf.com/v3/isolation_segments/$z2_guid/relationships/organizations \
    -X POST \
    -H "Authorization: $token" \
    -H "Content-Type: application/json" \
    -d "{
      \"data\": [
        { \"guid\":\"${z2_org}\" }
      ]
    }"

curl -s -k "https://api.cf.shaozhenpcf.com/v2/organizations/${z1_org}" \
  -X PUT \
  -H "Authorization: $token" \
  -H "Content-Type: application/json" \
  -d "{ \"default_isolation_segment_guid\":\"${z1_guid}\"}"

  curl -s -k "https://api.cf.shaozhenpcf.com/v2/organizations/${z2_org}" \
    -X PUT \
    -H "Authorization: $token" \
    -H "Content-Type: application/json" \
    -d "{ \"default_isolation_segment_guid\":\"${z2_guid}\"}"
