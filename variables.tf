variable "region" { 

    default = "us-east-1"
}



variable "account" {
    
    type = "string"
}



variable "bucketname" {
    
    type = "string"
 
}


variable "snstopicname" { 

     default = "snstopic4418"
}


variable "sqsname" {

    default = "sqs4418"
}
variable "cloudtrailname" {

    default = "cloudtrail4418"
}
