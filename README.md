# CS4843 Assignment 2

In this assignment we utilize Amazon Web Services' CloudFormation to create a VPC with two public and two private subnets across two different availability zones for high availability. We use an InternetGateway Attachment to gain access to the public internet. Traffic flows to our load balancer from the Internet Gateway into NAT gateway instances (that each have an Elastic IP) based on target rules. There are two NAT Gateways that sit in both public subnets, which give us access to our web servers that are sitting in private subnets. We also provide a CloudFormation template for an Auto-Scaling Group of EC2 instances, that sit behind a load balancer. Lastly we create a primary and a secondary RDS instance in each private subnet for high availability and disaster recovery.

## Infrastructure Utilized

## Security

## Error Handling

## Built With

### Elaboration of Technologies Used

```
```
```
```
```
```
```
```

## Author

* **Travis Sauer**
