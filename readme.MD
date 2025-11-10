VPC Terraform Module

This Terraform module creates a complete VPC network setup including public, private, and database subnets with routing, NAT gateway, and tagging.

✅ Features

Creates VPC

Internet Gateway

Public / Private / DB Subnets (Multi-AZ)

NAT Gateway

Public and Private Route tables

Automatic subnet–AZ mapping

Clean naming convention

Dynamic availability zone selection

Useful output values

✅ Inputs
Variable	Type	Required	Description
project	string	No	Project name (default: Roboshop)
env	string	No	Environment (default: dev)
tags	map	No	Common resource tags
vpc_cidr	string	Yes	CIDR block for the VPC
public_subnet_cidrs	list	Yes	Public subnet CIDRs
private_subnet_cidrs	list	Yes	Private subnet CIDRs
db_subnet_cidrs	list	Yes	DB subnet CIDRs
✅ Outputs
Output	Description
vpc_id	ID of the VPC
public_subnet_ids	List of public subnet IDs
private_subnet_ids	List of private subnet IDs
db_subnet_ids	List of DB subnet IDs
✅ Requirements
Requirement	Version
Terraform	>= 1.0
AWS Provider	>= 5.0
✅ Architecture Overview
                 +----------------------+
                 |       Internet       |
                 +----------+-----------+
                            |
                     +------+------+
                     |   IGW       |
                     +------+------+
                            |
             +--------------+--------------+
             |                             |
   +---------+---------+         +----------+----------+
   | Public Subnet AZ1 |         | Public Subnet AZ2   |
   +---------+---------+         +----------+----------+
             |                             |
        (Instances)                  (Instances)

     NAT-GW (only in AZ1)
             |
             +-----------------------------+
             |                             |
   +---------+---------+         +----------+----------+
   | Private Subnet AZ1|         | Private Subnet AZ2  |
   +---------+---------+         +----------+----------+
        (Apps)                      (Apps)

   +---------+---------+         +----------+----------+
   |   DB Subnet AZ1   |         |  DB Subnet AZ2      |
   +-------------------+         +----------------------+
