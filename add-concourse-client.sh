uaac target https://uaa.pcfdev.shaozhenpcf.com --skip-ssl-validation
uaac token client get admin -s admin-client-secret
uaac client add concourse \
            --name concourse \
            --scope cloud_controller.read \
            --authorities cloud_controller.admin \
            --autoapprove true \
            --authorized_grant_types "authorization_code,client_credentials,refresh_token" \
            --access_token_validity 3600 \
            --refresh_token_validity 3600 \
            --redirect_uri https://concourse.shaozhenpcf.com/auth/uaa/callback \
            -s concourse-secret
