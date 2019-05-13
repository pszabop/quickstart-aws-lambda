# quickstart-aws-lambda
The purpose of this quick start is to provide a good example of cloudformation template 
with the following properties:

1. Creates a testable AWS API hooked to a lambda function
1. Cleans up after itself leaving nothing lying around including logs
1. Is debuggable
1. Is testable
1. Should not have to touch the AWS Console except to set up your AWS CLI
1. Is complete, not some snippet on a website.  The comments in the code
   will tell you how often snippets fail to tell the whole story

This should give you a good start at creating an AWS sandbox to test Lambda code

# Instructions

1. Set up AWS CLI per [AWS instructions](https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html)
1. run lambda-api-test.sh.  This should deploy the CloudFormation stack template, test its API, and delete the stack
