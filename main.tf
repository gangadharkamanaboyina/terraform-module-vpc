resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge (
    var.tags,
    {
        Name = local.common_name
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.tags,
    {
        Name = local.common_name
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = local.availability_zones[count.index]
  tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-public-${local.availability_zones[count.index]}"     #Roboshop-dev-public-us-east-1a
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.availability_zones[count.index]
  tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-private-${local.availability_zones[count.index]}"     #Roboshop-dev-private-us-east-1a
    }
  )
}

resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnet_cidrs[count.index]
  availability_zone = local.availability_zones[count.index]
  tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-db-${local.availability_zones[count.index]}"     #Roboshop-dev-db-us-east-1a
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-public"     #Roboshop-dev-public
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-private"     #Roboshop-dev-public
    }
  )
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-db"     #Roboshop-dev-public
    }
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
    tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-nat"   
    }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

    tags = merge (
    var.tags,
    {
        Name = "${local.common_name}-nat"   
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "db" {
  route_table_id            = aws_route_table.db.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db" {
  count = length(var.db_subnet_cidrs)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}