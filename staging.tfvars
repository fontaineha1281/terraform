access-key = ""
secret-key = ""
state = "staging"

####################################################################
# RDS
####################################################################

region                 = "us-west-1"
db-name                = "aime"
username               = "bibichannel"
password               = "bibichannel"
instance-class         = "db.t2.micro"
allocated-storage      = 5
publicly-accessible    = false

####################################################################
# EC2
####################################################################

instance-type = "t2.micro"