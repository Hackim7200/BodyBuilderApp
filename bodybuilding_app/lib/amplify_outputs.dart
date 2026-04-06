/// Replace this content with the generated `amplify_outputs` from Amplify Gen 2
/// (`npx ampx sandbox` / your CI pipeline copies the real file here).
///
/// Docs: https://docs.amplify.aws/flutter/start/quickstart/
const String amplifyConfig = r'''
{
  "version": "1",
  "auth": {
    "user_pool_id": "REPLACE_WITH_USER_POOL_ID",
    "aws_region": "us-east-1",
    "user_pool_client_id": "REPLACE_WITH_USER_POOL_CLIENT_ID",
    "identity_pool_id": "REPLACE_WITH_IDENTITY_POOL_ID",
    "mfa_methods": [],
    "standard_required_attributes": ["email"],
    "username_attributes": ["email"],
    "user_verification_types": ["email"],
    "mfa_configuration": "NONE",
    "password_policy": {
      "min_length": 8,
      "require_lowercase": true,
      "require_numbers": true,
      "require_symbols": true,
      "require_uppercase": true
    },
    "unauthenticated_identities_enabled": true
  }
}
''';
