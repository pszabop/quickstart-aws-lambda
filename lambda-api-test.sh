#!/bin/bash
#
# Complete a round trip of creating a stack with an AWS Lambda function fronted by an API Gateway, test it, then dismember the stack
#
# Mostly copied from the somewhat incomplete @see https://bl.ocks.org/magnetikonline/c314952045eee8e8375b82bc7ec68e88#stack.yaml
# The "incomplete" part is noted here in lessons learned comments.
#

# define a few required variables
stack_name=${1:-"lambda-test-api-gw"}


# Step 1:  Publish Stack. Entire stack (including Lambda code) is in a YAML file.  (Normally the code would be in an S3 bucket requiring an extra step)
#
# Lessons learned not included in original instructions:
#   @see https://github.com/awslabs/serverless-application-model/issues/51
#
# Note this will fail with an "exists" error if you run it again.  XXX catch and swallow the "exists" error for idempotence
aws cloudformation create-stack --stack-name ${stack_name} --capabilities CAPABILITY_IAM  --template-body file://lambda-api-stack.yaml

# Step 2:  Wait for completion.  Alas this polls every 30 seconds so is slower than some stack creations
# and alas there's no output indicating progress.  Grrr.
# Lessons learned:
#    @see https://docs.aws.amazon.com/cli/latest/reference/cloudformation/wait/stack-create-complete.html
echo "Waiting for stack ${stack_name} to complete.  This could take 30-300 seconds depending on the stack.  No progress feedback provided, sorry"
aws cloudformation wait stack-create-complete --stack-name ${stack_name}


# Step 3:  Grab the unique URL for the API gateway that was created
# Lessons learned not included in original instructions:
#   @see https://stackoverflow.com/questions/38121740/how-to-filter-array-of-objects-by-element-property-values-using-jq
#   @see https://www.slideshare.net/btiernay/jq-json-like-a-boss
#   @see https://github.com/stedolan/jq/issues/106
#
# 'apiGatewayInvokeURL' is an Output for the Cloud Formation template, sold separately.  No returns.
api_gateway_url=`aws cloudformation describe-stacks --stack-name ${stack_name} | jq -r '.Stacks[].Outputs[] | select(.OutputKey  == "apiGatewayInvokeURL") | .OutputValue '`

# Step 4:  Test the URL
echo "testing API URL..."
curl --request POST ${api_gateway_url}
# curl doesn't post a CR/LF for its output
echo ""
echo "testing completed"

# Step 5:  Clean up the stack
# Lessons learned
#   @see https://github.com/hashicorp/terraform/issues/14750   (you can't delete the LogGroups every time because we gave permission for Lambda to create it as needed)
#
aws cloudformation delete-stack --stack-name ${stack_name}
echo "Waiting for stack ${stack_name} to be deleted.  This could take 30-300 seconds depending on the stack.  No progress feedback provided, sorry"
aws cloudformation wait stack-delete-complete  --stack-name ${stack_name}
