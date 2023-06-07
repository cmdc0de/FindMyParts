// dynamo tabls
// Component type is the definition of a component
// TODO: provide JSON schema
resource "aws_dynamodb_table" "component_type" { 
   name = "component_type" 
   billing_mode = "PROVISIONED"
   read_capacity  = 10
   write_capacity = 10
   attribute { 
      name = "component_type_id" 
      type = "S" 
   } 
   hash_key = "component_type_id" 
} 

// Storage device
// Example 1 storage device type is a storage device 3 rows with 10 columns
// defines the type of storage not an instance of the storage
resource "aws_dynamodb_table" "storage_device_type" { 
   name = "storage_device_type" 
   billing_mode = "PROVISIONED"
   read_capacity  = 10
   write_capacity = 10
   attribute { 
      name = "storage_device_type_id"
      type = "S" 
   } 
   hash_key = "storage_device_type_id"
} 

// storage_device_instance
// is an instance of a storage_device_type
// each draw will have instances of a component_type 
resource "aws_dynamodb_table" "storage_device_instance" { 
   name = "storage_device_instance" 
   billing_mode = "PROVISIONED"
   read_capacity  = 10
   write_capacity = 10
   attribute { 
      name = "storage_device_instance_id" 
      type = "S" 
   } 
   attribute {
      name = "storage_type_id"
      type = "S"
   }
   hash_key =  "storage_device_instance_id"
   range_key = "storage_type_id"
} 

