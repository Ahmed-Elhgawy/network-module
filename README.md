# Network Module

![alt text](http://url/to/img.png)

## Variables

1- vpc_name

> type        : string

> description : the name of the vpc where all other component will be built

2- cidr

> type        : string

> description : the ip range will be used in the network

3- subnet_mask

> type        : number

> description : the number will add to mask of vpc cidr to make cidr of subnets

4- AZ

> type        : string

> description : the availability zones will used (the number of subnets depends on it)

## Outputs 

1- vpc_id

2- public_subnets_id

3- private_subnets_id

4- igw_id

5- nat_id