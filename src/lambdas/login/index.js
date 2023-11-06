const PROVIDER = require('@aws-sdk/client-cognito-identity-provider')
const crypto = require('crypto')

exports.handler = async (event) => {
  try{
    const { password, document } = JSON.parse(event.body)
    const { COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET } = process.env
  
    if(!password || !document) {
        return {
          status: 400,
          body: {
            error: 'Document and password is required'
          },
          headers: {
            'Content-Type': 'application/json'
          }
        }
    }
    if(!COGNITO_CLIENT_ID || !COGNITO_CLIENT_SECRET) {
      throw new Error('Client and secret is required')
    }
    const client = new PROVIDER.CognitoIdentityProviderClient({
      region: process.env.AWS_REGION ?? 'us-east-1'
    })

    const command = new PROVIDER.InitiateAuthCommand({
      AuthFlow: 'USER_PASSWORD_AUTH',
      ClientId: COGNITO_CLIENT_ID,
      AuthParameters: { 
        USERNAME: document.toString().replace(/[^\d.-]+/g, ''),
        PASSWORD: password,
        SECRET_HASH: crypto
                      .createHmac('SHA256', COGNITO_CLIENT_SECRET)
                      .update(`${document}${COGNITO_CLIENT_ID}`)
                      .digest('base64')
      }
    })
    try{
      const response = await client.send(command)
      if (response.ChallengeName === 'NEW_PASSWORD_REQUIRED') {
        return {
          status: 403,
          body: {
            error: 'Please change your password using hosted ui'
          },
          headers: {
            'Content-Type': 'application/json'
          }
        };
      }
      return {
        status: 200,
        body: response.AuthenticationResult,
        headers: {
          'Content-Type': 'application/json'
        }
      };
    } catch(ex){
      console.error(ex)
      return {
        status: 400,
        body: {
          error: 'Document not found'
        },
        headers: {
          'Content-Type': 'application/json'
        }
      };
    }
  } catch(error){
      console.error(error)
      throw new Error(error)
  }
}