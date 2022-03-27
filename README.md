# CS4843 Assignment 2

In this assignment we utilize Amazon Web Services' CloudFormation to create a VPC with two public and two private subnets across two different availability zones for high availability. We use an Internet Gateway Attachment to gain access to the public internet via our VPC. Traffic flows to our load balancer from the Internet Gateway and fowards requests to NAT gateway instances (that each have an Elastic IP) based on listener rules. There are two NAT Gateways that sit in public subnets which give access to our private subnet associated web servers. We also provide a CloudFormation template for an Auto-Scaling Group of EC2 instances. Lastly we create a primary and a secondary RDS instance in each private subnet for high availability and disaster recovery.

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
The network dot YAML file contains the VPC's CIDR range, as well as ranges for the two public and two private subnets.
We create an Internet Gateway and an Internet Gateway Attachment so that we can attach
the Internet Gateway to the AWS VPC. We create two different Elastic IPs and allocate them to our two
NAT Gateways, where each public subnet has one NAT gateway. We then create a public route table
and associate a route from any address (0.0.0.0/0) through the Internet Gateway.
We associate our two public subnet CIDR ranges with the public route table.
Next, we create two separate private routing tables, as well as routes for each and
associate them to their respective private subnets and NAT Gateways. Lastly,
we create a variety of exports in our Outputs section so that we can reference
public and private subnets as needed for our ASG servers and RDS Instances.
We use a parameters.JSON file to define our Environment Name, and give CIDR
ranges to the VPC and all of its subnets.
```
**servers.YAML (Resources created: Launch Configuration, EC2 Security Group, EC2 Key Pair, Auto-Scaling Group, Elastic
Load Balancer, ELB Listener Rule, and ELB Target Group)**
```
The server dot YAML file creates an EC2 Security Group that only allows traffic from port 80 over tcp from anywhere,
as well as port 22 over tcp from anywhere, and lastly it allows a special port range from port 0 to port 65535 to any
destination on the internet (to enable private instances to retrieve updates). Next, we create a launch configuration
to be used with our Auto-Scaling Group of EC2 instances. We run a user data script to start the http daemon,
associate a Key Pair, associate it with the aforementioned security group, define instance type, and
elastic block store volume size. Next we create an Auto Scaling Group, where we associate it with the
private subnets, reference the aforementioned launch config, set a minimum and maximum number
of active instances, and associate it to the ELB target group. We create another EC2 Security Group for our Elastic
Load Balancer, associate it to the VPC (it sits outside the public and private subnets), allow traffic from anywhere
on port 80 and all traffic out on port 80. Next, we create the Elastic Load Balancer, associate it with the two public
subnets, and load balancer security group. We create an ELB Listener that forwards requests over port 80 to the target
group. Next, we create an ELB Listener Rule that fowards requests to the target group based on the path "/". Lastly,
we create an ELB Target Group where we associate it with health-check properties, as well as the port,
and associate it to the VPC.
```

**database.YAML (db1.YAML and db2.YAML) (Resources created: Database Instance, and Database Subnet Group)**
```
The database dot YAML file defines a Database Identifier, associates a default name for that database resource,
identifier, as well as the minimum and maximum lengths for its name (String-type). Next, the database name
follows similar rules for instantiation as the Database Identifier. We create a Database User
with allowed patterns for creation, set the default to dbadmin, set the minimum and
maximum lengths to 1 and 16 according, and set No Echo to true, which allows us the privacy
of not exposing the db user-name if we were to upload this file via the AWS console.
Next, we follow a similar instructional pattern for the password, but here we set
the minimum and maximum lengths to 8 and 64 respectively, for obvious reasons.
We set the minimum and maximum retention periods for Database snapshots.
The storage allocation is set with a default of 20GB. Next,
we set the allowed instance types. Unfortunately
Multi-AZ Database deployments are not possible with CloudFormation, so we set
Multi-AZ Database to false. We create the Database Subnet Group and associate
it with the two different private subnets. Lastly, we create the actual database
instance where we associate all the aforementioned parameters, the most important
of which (for high availability) is the Availability Zone specification. To
provide high availability, we create two different database dot YAML files
and associate each with a different availability zone across their respective
private subnets.
```

## Author

* **Travis Sauer**
