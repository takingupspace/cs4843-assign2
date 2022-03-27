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

### Elaboration of Technologies Used

```
<strong>network.YAML (Resources created: VPC, IG, NAT Gateway, EIP, and Subnets) --<strong>
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
```

## Security

## Error Handling

## Author

* **Travis Sauer**
