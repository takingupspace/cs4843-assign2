# CS4843 Assignment 2

In this assignment we utilize Amazon Web Services' CloudFormation to create a VPC with two public and two private subnets across two different availability zones for high availability. We use an InternetGateway Attachment to gain access to the public internet. Traffic flows to our load balancer from the Internet Gateway into NAT gateway instances (that each have an Elastic IP) based on target rules. There are two NAT Gateways that sit in both public subnets, which give us access to our web servers that are sitting in private subnets. We also provide a CloudFormation template for an Auto-Scaling Group of EC2 instances, that sit behind a load balancer. Lastly we create a primary and a secondary RDS instance in each private subnet for high availability and disaster recovery.

## Infrastructure Utilized

1). VPC (Virtual Private Cloud)<br/>
2). Internet Gateway (IG)<br/>
3). Elastic Load Balancer (ELB)<br/>
4). Elastic IP (EIP)<br/>
5). NAT Gateway<br/>
6). Auto-Scaling Group (ASG)<br/>
7). MySQL Relational Database Service (RDS)<br/>

## Elaboration of Technologies Used

**network.YAML (Resources created: VPC, IG, NAT Gateway, EIP, and Subnets)**
```
The network YAML file contains the VPC's CIDR range, as well as ranges for the two public and two private subnets.
We create an Internet Gateway and an Internet Gateway Attachment so that we can attach
the Internet Gateway to the AWS VPC. We create two different Elastic IP and allocate two
NAT Gateways with them, where each public subnet has one NAT gateway. We then create a public route table
and associate a route from any address (0.0.0.0/0) through the Internet Gateway.
We then attach our two public subnet CIDR ranges with the public route table.
Next we create two separate private routing tables, as well as routes for each and
associate them to their respective private subnets and NAT Gateways. Lastly,
we create a variety of exports in our<br/> Outputs section so taht we can reference
public and private subnets as needed for our ASG servers and RDS Instances.
We use a parameters.JSON file to define our EnvironmentName, and give CIDR
ranges to the VPC and all of its subnets.
```
**servers.YAML (Resources created: Launch Configuration, EC2 Security Group, EC2 Key Pair, Auto-Scaling Group, Elastic
Load Balancer, ELB Listener Rule, and ELB Target Group)**
```
The server dot YAML file creates an EC2 Security Group that only allows traffic from port 80 over tcp from anywhere,
as well as port 22 over tcp from anywhere, and lastly it allows a special port range from port 0 to port 65535 to any
destination on the internet. Next, we create a launch configuration to be used with our Auto-Scaling Group of EC2 instances.
We run a user data script to start the http daemon, associate the KeyPair, associate it with the aforementioned security group,
define instance type, and elastic block store volume size. Next we create an Auto Scaling Group, where we associate it with the
private subnets, references the aforementioned launch config, sets a minimum and maximum number of instances to be run, and associates
it to the target group. We create another EC2 Security Group for our Elastic Load Balancer, associate it to the VPC (sits outside of
the public and private subnets), allow traffic from anywhere on port 80 and all traffic out on port 80. Next, we create the Elastic
Load Balancer, associate it with the two public subnets, and load balancer security group. We create an ELB Listener that
forwards requests over port 80 to the target group. Next, we create an ELB Listener Rule that fowards requests to the
target group based on the path "/". Lastly, we create an ELB Target Group where we associate health based properties, as well
as the port, and associate it to the VPC.
```

**database.YAML (db1.YAML and db2.YAML) (Resources created: Database Instance, and Database Subnet Group)**
```
The database dot YAML file defines a Database Identifier, associates a default name for that database resource,
identifier, as well as the minimum and maximum lengths for the String name. Next, the database name
follows similar rules for instantiation as the Database Identifier. We then create a Database User
with the allowed patterns for creation, set the default to dbadmin, set the minimum and
maximum lengths to 1 and 16 according, and set NoEcho to true which allows us the privacy
of not exposing the db user-name if we were to upload this file via the AWS console.
Next, we follow a similar instructional pattern for the password, but here we set
the minimum and maximum lengths to 8 and 64 respectively for obvious reasons.
Next, we set the minimum and maximum retention periods for Database snapshots.
Then, we set the storage allocation for the storage with a default of 20, as well
as a minimum value of 5 and a maximum of 65536 (in GigaBytes). Next,
we set the allowed instance types accordingly. Unfortunately
Multi-AZ Database deployments are not possible with CloudFormation, so we set
Multi-AZ Database to false. We create the Database Subnet Group and associate
it with the two different private subnets. Lastly, we create the actual database
instance where we associate all the aforementioned parameters, the most important
of which (for high availability) is the Availability Zone specification. To
provide high availability we create two different database dot YAML files
and associate each with a different availability zone across their respective
private subnets.
```

## Author

* **Travis Sauer**
