import json
import logging
import boto3
from botocore.exceptions import ClientError

ERROR_HELP_STRINGS = {
    # Operation specific errors
    'ConditionalCheckFailedException': 'Condition check specified in the operation failed, review and update the condition check before retrying',
    'TransactionConflictException': 'Operation was rejected because there is an ongoing transaction for the item, generally safe to retry with exponential back-off',
    'ItemCollectionSizeLimitExceededException': 'An item collection is too large, you\'re using Local Secondary Index and exceeded size limit of items per partition key.' +
                                                ' Consider using Global Secondary Index instead',
    # Common Errors
    'InternalServerError': 'Internal Server Error, generally safe to retry with exponential back-off',
    'ProvisionedThroughputExceededException': 'Request rate is too high. If you\'re using a custom retry strategy make sure to retry with exponential back-off.' +
                                              'Otherwise consider reducing frequency of requests or increasing provisioned capacity for your table or secondary index',
    'ResourceNotFoundException': 'One of the tables was not found, verify table exists before retrying',
    'ServiceUnavailable': 'Had trouble reaching DynamoDB. generally safe to retry with exponential back-off',
    'ThrottlingException': 'Request denied due to throttling, generally safe to retry with exponential back-off',
    'UnrecognizedClientException': 'The request signature is incorrect most likely due to an invalid AWS access key ID or secret key, fix before retrying',
    'ValidationException': 'The input fails to satisfy the constraints specified by DynamoDB, fix input before retrying',
    'RequestLimitExceeded': 'Throughput exceeds the current throughput limit for your account, increase account level throughput before retrying',
}

def handle_error(error):
    error_code = error.response['Error']['Code']
    error_message = error.response['Error']['Message']

    error_help_string = ERROR_HELP_STRINGS[error_code]

    print('[{error_code}] {help_string}. Error message: {error_message}'
          .format(error_code=error_code,
                  help_string=error_help_string,
                  error_message=error_message))

    errorDict = {}
    errorDict['error_code'] = error_code
    errorDict['msg'] = error_message
    errorDict['error_help_string'] = error_help_string
    return json.dumps(errorDict, indent = 4)

##########################################
# put item
# {
#     "TableName": "storage_device_type",
#     "Item": {
#         "storage_device_type_id": "123456", 
#         "name": "3x10", 
#         "model_uri": "test.step", 
#         "length": 60, 
#         "width": 60, 
#         "height": 160, 
#         "unit_type": "cm"
#     }
# }
##########################################
def put_item_lambda_handler(event, context):
    dynamodb_resource = boto3.resource('dynamodb')
    table = dynamodb_resource.Table('storage_device_type')

    try:
        response = table.put_item(**event)
        return response
    except ClientError as error:
        return handle_error(error)
    except BaseException as error:
        return { 'message' : "Unknown error while putting item: "+ repr(error) }

############################################
# {
#   "storage_device_type_id" : "123456"
# }
############################################
def delete_item_lambda_handler(event, context):
    dynamodb_resource = boto3.resource('dynamodb')
    table = dynamodb_resource.Table('storage_device_type')
    print(repr(context))

    try:
        deleteItemTable = {
            "TableName": "storage_device_type",
            "Key" : { }
        }
        key = {}
        key["storage_device_type_id"] = event['storage_device_type_id']
        deleteItemTable['Key'] = key
        return table.delete_item(**deleteItemTable)

    except ClientError as error:
        return handle_error(error)
    except BaseException as error:
        return { 'message' : "Unknown error while deleting: "+ repr(error) }


############################################
# scan return all
###########################################
def scan_lambda_handler(event, context):
    scanInput = { "TableName": "storage_device_type" }

    try:
        dynamodb_resource = boto3.resource('dynamodb')
        table = dynamodb_resource.Table('storage_device_type')
        return table.scan(**scanInput)
    except ClientError as error:
        return handle_error(error)
    except BaseException as error:
        return { 'message' : "Unknown error while putting item: "+ repr(error) }

