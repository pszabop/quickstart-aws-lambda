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

## What a successfull deployment looks like
Yes, I haven't used a real pass/fail test framework for the bash.  This is what a result should look like
```
: Documents/umlss/quickstart-aws-lambda $ ./lambda-api-test.sh 
{
    "StackId": "arn:aws:cloudformation:us-east-2:064156463146:stack/lambda-test-api-gw/714bf9a0-75ac-11e9-9355-025c218c397c"
}
Waiting for stack lambda-test-api-gw to complete.  This could take 30-300 seconds depending on the stack.  No progress feedback provided, sorry
testing API URL...
Hello there <your IP address>
testing completed
Waiting for stack lambda-test-api-gw to be deleted.  This could take 30-300 seconds depending on the stack.  No progress feedback provided, sorry

```
